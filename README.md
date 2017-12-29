# Border Ownership and Contour Detection for frame-free sensors (DVS)
  
This directory contains Matlab (R) implementations for methods for boundary detection and border ownership for event data.

The bio-inspired, asynchronous event-based dynamic vision sensor (DVS) records temporal changes in the luminance of the scene at high temporal resolution. Since events are only triggered at significant luminance changes, most events occur at object boundaries. This paper presents an approach to learn the location of contours and their border ownership using Structured Random Forests on event-based features that encode motion, timing, texture, and spatial orientations. The classifier integrates elegantly information over time by utilizing the classification results previously computed. Finally, the contour detection and boundary assignment are demonstrated in a layer-segmentation of the scene. 

## DVS feature extraction ##
As explained in the paper, our approach uses the following features: 
- Event-based Orientation. The intuition is that concave edges often belong to foreground objects. 
- Event temporal information. Timestamps provide information for tracking contours, defining a surface that encodes locally the direction and speed of image motion. 
- Event-based Motion Estimation. Image motion encodes relative depth information useful for assigning border ownership (motion parallax).
- Event-based time texture. The aim in this case is to separate occlusion edges from texture edges. 

In the current repository, please be advise of the different versions for extracting features called: *batch_extractFeaturesNUM.m* where NUM refers to the version number (1 to 5)

## Training the Structured Random Forests (SRF) ##
The training has not been included in this repository. If you are interested in training your SRF please go to:

http://www.umiacs.umd.edu/~cteo/BOWN_SRF/

## Border ownership and boundary detection ##
Boundary detection and border ownership are done using Structured Random Forests. Trained models for the DVS data are available in the *__./model__* folder. 
Moreover, some files in the repository can be used for seeing how it works: 
- *estimateBoundaryForVideo.m*: Detection and boundary assignment for the video at:

https://www.youtube.com/watch?v=XTeX_5awL3w   

- *__./demo__*: The folder contains a software for running the contour detection in real time provided the DVS sensor. It uses a more simplified model than the one we used in the paper.

The *__./toolbox__* folder is required for running the boundary detection and border ownership. To learn more about that toolbox please go to:

http://vision.ucsd.edu/~pdollar/toolbox/doc/


## DVS dataset for benchmarking ## 
The code uses some data and matfiles that are already available in an external repository at:

http://www.umiacs.umd.edu/research/POETICON/DVSContours/resources/dataset/complexMotion3.zip. 

The repository contains a README.txt file that explains the contents: event streams (dvs data), extracted features, annotated groundtruth, and the results we used in the paper for the boundary detection, assigning border ownership (foreground and background), and the protosegmentation. 

## More documentation ##

If you use any of the methods, the dataset, or the code, please cite the article
F. Barranco, C. L. Teo, C. Fermuller, and Y. Aloimonos. "Contour Detection and Characterization for Asynchronous Event Sensors." In Proceedings of the IEEE International Conference on Computer Vision, pp. 486-494. 2015.

	@inproceedings{barranco_contour_2015,
		author = {Barranco, F. and Teo, C. L. and Fermuller, C. and Aloimonos, Y.},
		title = {Contour Detection and Characterization for Asynchronous Event Sensors},
		journal = {Proceedings of the IEEE International Conference on Computer Vision},
		pages = {486--494},
		year = {2015}
	}

Some additional information is available at:
http://www.umiacs.umd.edu/research/POETICON/DVSContours/


Please report problems, bugs, or suggestions to
fbarranco_at_ugr_dot_es (Replace _at_ by @ and _dot_ by .).

Copyright (C) 2017 Francisco Barranco, 12/30/2017, University of Granada.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.