/*******************************************************************************
* Optical flow method based on: 
* Event-based visual flow. 
* Benosman R, Clercq C, Lagorce X, Ieng SH, Bartolozzi C.
* IEEE TNNLS, 25(2):407-417, 2014
*
* Francisco Barranco 02/10/2015
*******************************************************************************/

#include <mex.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
//#ifdef USEOMP
//#include <omp.h>
//#endif

typedef unsigned int uint32;
typedef unsigned short uint16;
#define min(x,y) ((x) < (y) ? (x) : (y))

void copy(uint16 *m, uint16 *It, int posx, int posy, int block, int rows, int cols)
{
	int m_idx, m_idy;
    //Copy data from It to m
    for(int i=posx-block;i<=posx+block;i++)
        for(int j=posy-block;j<=posy+block;j++)
        {
            //mexPrintf("element[%d][%d] = %f\n",j,i,a[i*dimy+j]);
			m_idx = i-(posx-block);
			m_idy = j-(posy-block);
            //m[m_idx*cols+m_idy] = It[i*dimy+j];
			m[m_idx*(2*block+1)+m_idy] = It[i*cols+j]; 
        }
}

uint16 removeOldEvents(uint16 *m, int blockSize, int thres)
{
    //m(abs(m(blockSize+1,blockSize+1)-m)/m(blockSize+1,blockSize+1)>th1)= 0;
    //Remove events that happened too long ago
    uint16 sum = 0;
	int cols = 2*blockSize+1;
	int rows = 2*blockSize+1;
    for(int i=0; i<rows; i++)
        for(int j=0; j<cols; j++)
		{	
            if ((abs(m[i*cols+j] - m[blockSize*cols+blockSize])/m[blockSize*cols+blockSize]) > thres)
				m[i*cols+j] = 0;

			sum += abs(m[i*cols+j]);
		}
    return sum;
}


int applyThreshold(int *a, int rows, int cols, int thres)
{
    int sum = 0;
    for(int i=0; i<rows; i++)
        for(int j=0; j<cols; j++)
	    if (abs(a[i*cols +j])>thres)
	    {
		a[i*cols +j] = 0;
		sum +=a[i*cols +j]*a[i*cols +j];
	    }
    return sum;
}

void fill_array(int *input, double *output, int rows, int cols)
{
	/* Fill real and imaginary parts of array. */
    for (int j = 0; j < cols; j++) 
		for (int i = 0; i < rows; i++) 
			output[j*cols+i] = (double) input[i*cols+j];
}


void fiit(uint16 *m, float *vx, float *vy, int blockSize, float thres)
{
    int rows = 2*blockSize+1;
	int cols = 2*blockSize+1;
	int *list = new int[rows*cols*3]; //allocate maximum size
    
	int cnt =0, sumX, sumY, sumM;
	float meanList[3];
	

    //prepare data for mex
    for(int i=0; i<rows; i++)
	for(int j=0; j<cols; j++)
	    if (m[i*cols+j] > 0)
		{		
			list[cnt*3] = i;
			list[cnt*3+1] = j;
			list[cnt*3+2] = (int)m[i*cols+j];
			sumX = sumX+i;
			sumY = sumY+j;
			sumM = sumM+(int)m[i*cols+j];
			cnt ++;
	    }
    meanList[0] = sumX/(cnt-1);
    meanList[1] = sumY/(cnt-1);
    meanList[2] = sumM/(cnt-1);

    //Call to princomp
	mxArray *input_array[1];
    mxArray *output_array[2];
    int num_out, num_in;
    
	input_array[0] = mxCreateDoubleMatrix(3, cnt-1, mxREAL);
	fill_array(list, mxGetPr(input_array[0]), cnt-1, 3);
	
    num_out = 2;
    num_in = 1;
    mexCallMATLAB(num_out, output_array, num_in, input_array, "princomp");
	
	double* coef = mxGetPr(output_array[0]);
    //coef = output_array[0];
	mxDestroyArray(input_array[0]);
	mxDestroyArray(output_array[0]);
	mxDestroyArray(output_array[1]);									

    float normal[3];
	float normal_dot_meanList;
    normal[1] = (float)coef[7]; normal[2] = (float)coef[8]; normal[3] = (float)coef[9];
    normal_dot_meanList = meanList[0]*normal[0] + meanList[1]*normal[1] +meanList[2]*normal[2];
	float *zgrid = new float[rows*cols];

    for(int i=0; i<rows; i++)
        for(int j=0; j<cols; j++)
			zgrid[i*rows+j] = (1/normal[3])*(normal_dot_meanList - i*normal[0] - j*normal[1]);
	

    // Calculate cross product normal x [0,1,0]
    float normal_cross_010[3] = {0,0,0};
    float dx, dy, norm;
    normal_cross_010[0] = -normal[3];
    //normal_cross_010[1] = 0;
    normal_cross_010[2] = normal[1];
    norm = normal_cross_010[0]*normal_cross_010[0] + normal_cross_010[2]*normal_cross_010[2];

    if(norm > 0.1)
    {
		//Central element only [blockSize, blockSize]
		
		//[vx,vy]=gradient(mm2);
		//[blockSize+1, blocksize] - [blockSize-1,blockSize]
		dx = 0.5*(zgrid[(blockSize+1)*rows+blockSize] - zgrid[(blockSize-1)*rows+blockSize]);
		//[blockSize, blocksize+1] - [blockSize,blockSize-1]
		dy = 0.5*(zgrid[blockSize*rows+blockSize+1] - zgrid[blockSize*rows+blockSize-1]);

        *vx = 1/dx*1000; 
		*vy = 1/dy*1000;  //In ms
    }else{
        *vx = 0;
        *vy = 0;
    }

    delete [] list; delete [] zgrid;
}

// [E,Efg,Ebg,ind] = mexFunction(model,chns,chnsSs) - helper for edgesDetect.m
// [Ox, Oy, It_pos, It_neg] = visualFlowBenosman(x, y, tms, pol, old_It_pos, old_It_neg, blockSize, thresholdActivity, thresholdDistance, maxspeed, DVSW, DVSH);
void mexFunction( int nl, mxArray *pl[], int nr, const mxArray *pr[])
{   
    // Reading inputs
    uint16* posX = (uint16*) mxGetData(pr[0]);
    uint16* posY = (uint16*) mxGetData(pr[1]);
    uint16* tms = (uint16*) mxGetData(pr[2]);
    int* pol = (int*) mxGetData(pr[3]);    
    const int numEvents = (int) mxGetScalar(pr[4]);
    /*uint16* oldItPos = (uint16*) mxGetData(pr[5]);
    uint16* oldItNeg = (uint16*) mxGetData(pr[6]);
    const int blockSize = (int) mxGetScalar(pr[7]);
    const int thresholdActivity = (int) mxGetScalar(pr[8]);
    const float thresholdDistance = (float) mxGetScalar(pr[9]);
    const float maxspeed = (float) mxGetScalar(pr[10]);
    const int DVSW = (int) mxGetScalar(pr[11]);
    const int DVSH = (int) mxGetScalar(pr[12]);
                       
    const int outDims [2]= {DVSW, DVSH};
    uint16 *m = new uint16[(2*blockSize+1)*(2*blockSize+1)];

    float vvx;
    float vvy;
    //float *vvx = new float[(2*BlockSize+1)*(2*BlockSize+1)];
    //float *vvy = new float[(2*BlockSize+1)*(2*BlockSize+1)];
    
    // create outputs
    pl[0] = mxCreateNumericArray(2,outDims,mxDOUBLE_CLASS,mxREAL);
    float *Ox = (float*) mxGetData(pl[0]);
    pl[1] = mxCreateNumericArray(2,outDims,mxDOUBLE_CLASS,mxREAL);
    float *Oy = (float*) mxGetData(pl[1]);
    pl[2] = mxCreateNumericArray(2,outDims,mxUINT16_CLASS,mxREAL);
    uint16 *It_pos = (uint16*) mxGetData(pl[2]);
    pl[3] = mxCreateNumericArray(2,outDims,mxUINT16_CLASS,mxREAL);
    uint16 *It_neg = (uint16*) mxGetData(pl[3]);
    int nThreads;


    // Main loop
    int ptx, pty;
	uint16 sum;   

    // apply forest to all patches and store leaf inds
    //#ifdef USEOMP
    //nThreads = min(nThreads,omp_get_max_threads());
    nThreads = omp_get_max_threads();
    #pragma omp parallel for num_threads(nThreads)
    //#endif
    for(int ev=1; ev<numEvents; ev++)
    {        
        //Update position
        ptx = posX[ev]; pty = posY[ev];
        //Get the timestamps of the positions: storing only the last event
        if (pol[ev]==1)
            It_pos[ptx*DVSH+pty]=tms[ev];
        else
            It_neg[ptx*DVSH+pty]=tms[ev];

        //Discarding events out of the border (borderSize == blockSize == 8)        
        if (ptx>blockSize && ptx<DVSW-blockSize){
           if (pty>blockSize && pty<DVSH-blockSize){

               // Extract time region around (ptx,pty) position
               // Region is (blockSize+1+blockSize) x (blockSize+1+blockSize)
               //            17 x 17 (blockSize ==8)
               if (pol[ev]==1)
					//m=It_pos(pty-blockSize:pty+blockSize,ptx-blockSize:ptx+blockSize);
					copy(m, It_pos, ptx, pty, blockSize, DVSH, DVSW);      
					
               else
					//m=It_neg(pty-blockSize:pty+blockSize,ptx-blockSize:ptx+blockSize);		   
					copy(m, It_neg, ptx, pty, blockSize, DVSH, DVSW);
                   
               
               // Remove those events that happened long time ago respect the timestamp of (ptx, pty)--> 20% 
               // The time of ptx,pty is m(blockSize+1, blockSize+1)
               //m(abs(m(blockSize+1,blockSize+1)-m)/m(blockSize+1,blockSize+1)>0.2)=0;
				sum = removeOldEvents(m, blockSize, thresholdActivity);
               
               //If there are any new events
               //if (sum(m(:)>0)){
			   if (sum > 0)
			   {	
					fiit(m, &vvx, &vvy, blockSize, thresholdDistance);
					if(abs(vvx) > maxspeed)
						vvx = 0;
					if(abs(vvy) > maxspeed)
						vvy = 0;
			   
				   //fiit(m, &vvx, &vvy, th2);
				   //sumvvx = applyThreshold(vvx, DVSW, DVSH, maxspeed);
				   //sumvvy = applyThreshold(vvy, DVSW, DVSH, maxspeed);
									  
				   //if(sumvvx != 0 || sumvvy != 0)
				   if(vvx != 0 || vvy != 0)
				   {
						//Get the central element
						//Ox[ptx*DVSH+pty] = vvx[blockSize*(2*blockSize+1)+blockSize];
						//Oy[ptx*DVSH+pty] = vvy[blockSize*(2*blockSize+1)+blockSize];
					   
						Ox[ptx*DVSH+pty] = vvx;
						Oy[ptx*DVSH+pty] = vvy;
				   }
			   } //if (sum(m(:)>0))
			} //if pty
		} //if ptx                
	}
*/        
    //delete[] vvx; delete[] vvy; 
	delete [] m;
}
