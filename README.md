# Border Ownership and Contour Detection for frame-free sensors (DVS)
  
This directory contains Matlab (R) implementations for methods for boundary detection and border ownership for DVS data.

The bio-inspired, asynchronous event-based dynamic vision sensor records temporal changes in the luminance of the scene at high temporal resolution. Since events are only triggered at significant luminance changes, most events occur at object boundaries. This paper presents an approach to learn the location of contours and their border ownership using Structured Random Forests on event-based features that encode motion, timing, texture, and spatial orientations. The classifier integrates elegantly information over time by utilizing the classification results previously computed. Finally, the contour detection and boundary assignment are demonstrated in a layer-segmentation of the scene. 

## DVS feature extraction ##

## Training the SRF ##

## Border ownership and boundary detection ##

## DVS dataset for benchmarking ## 
The code uses some data and matfiles that are already available in an external repository at:
http://www.umiacs.umd.edu/research/POETICON/DVSContours/resources/dataset/complexMotion3.zip. 

The repository contains a README.txt files that explains the contents: dvs data, extracted features, annotated groundtruth, and the results we used in the paper for the boundary detection, assigning border ownership (foreground and background), and the protosegmentation. 


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

## Example ##
Please, take a look at reconstructFlow.m for an example that shows in a general way the main functionalities of the repository.

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