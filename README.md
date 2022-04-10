# SWWP-infection-detection
These scripts were used for processing and analyzing hyperspectral data from Haagsma, Marja, et al. "Using hyperspectral imagery to detect an invasive fungal pathogen and symptom severity in Pinus strobiformis seedlings of different genotypes." Remote Sensing 12.24 (2020): 4041.

Data is available from Oregon State University's Scholars Archive: Haagsma, M.; Page, G.F.M.; Johnson, J.S. Hyperspectral Imagery of Pinus Strobiformis Infected with Fungal Pathogen, Version 1; Oregon State University: Corvallis, OR, USA, 2020. 


This documentation file was generated on 2020-10-19 by Marja Haagsma


Codes:

A. 	Name: Create_VegPix_classifier.m
	Description: This code uses hypercubes from dates 20180503 and 20180523 to create a segmentation classifier.
		Inputs: 
			- Three masks manually created in GIMP 2
               	- 05_03_Mask_background.png
               	- 05_23_Mask_75.png
               	- 05_23_Mask_background_75.png
           	- Two hypercubes, source(
               	- 20180503_SWWP
               	- 20180523_SWWP
		Outputs:
			- TC (a trained classifier)
			- the trained classifier that was used for analysis for the paper can be found in the 'misc'-folder under 'TC_0523_0503.mat'
		Dependencies:
			- enviread Felix Totir (2020). ENVI file reader/writer (https://www.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer), MATLAB Central File Exchange. Retrieved October 7, 2020.
			
B. 	Name: Data_prep.m
	Description: This code prepares the hyperspectral images for classification by automatically extract pine-pixels per pot.
		Inputs:
			- Hypercube binary file-
			- TC (from 'Create_VegPix_classifier.m)
		Outputs:
			- RGB composite image
			- Detected pots (radii, centers, Pots mask)
			- Pines (matrix with refelctance of all pine pixels)
			- Flags (vecotr, same length as Pines, indication which pots the pixels belong to)
			- X_coord & Y_coord (matrix, same length as Pines, indicating the spatial position of every pixels)
		Dependencies:
			- enviread Felix Totir (2020). ENVI file reader/writer (https://www.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer), MATLAB Central File Exchange. Retrieved October 7, 2020.
			- rad2ref
			- CircDet
			- createCirclesMask - Brett Shoelson (2020). createCirclesMask.m (https://www.mathworks.com/matlabcentral/fileexchange/47905-createcirclesmask-m), MATLAB Central File Exchange. Retrieved October 7, 2020.
	
C. 	Name: Create_Features.m
	Description: This script creates features per observation (pot).
		Inputs:
			- Pines & Flags (from Data_prep.m)
		Outputs:
			- FCube
			- FeatList (feature names per column)
		Dependencies:
			- VI_calculator
				- wv2bnd
			- dv1
			- lam_lam
			- lam_lam_log
			- ref_ratio
			
D. 	Name: Classification_Infection.m
	Description: This script will classify the hypercube for the specified classes. An SVM learner with linear kernel is used. The predicted accuracy is the 10-fold predicted accuracy. This is repeated n times. 
		Inputs: 
			- FCube
			- pots
			- target class labels:
				- Treatment_Family.csv
				- Vigor_assessment.csv
		Outputs:
			- Classification variables such as accuracy and trained classifiers for:
				- Infection, using:
					- median and VI's together
					- single VI's
				- Vigor class
			- Statistical measures of p-values (and bhattacharyya distance)
		Dependencies:
			- Classify_SVMlin
			- similar_pots
			- kappa_coefficient
			- bhattacharyya
			
			
E. 	Name: Figures_Tables.m
	Description: This script is used to analyze the results from 'Classification_Infection.m'.
		Inputs:
			- Classification results from infection detection ('Prediction.mat')
			- Classification results from vigor class ('Prediction_VA.mat')
			- p-values from 2-sample t-test and bhattacharyya distances per feature for infection separation ('p&BD_values.mat')
			- p-values from one-way ANOVA per feature for separation vigor classes ('p_values_VA.mat')
		Outputs:
			- Figures found in main body of manuscript: 'Using hyperspectral imagery to detect an invasive fungal pathogen and symptom severity in Pinus strobiformis seedlings of different genotypes'
		Dependencies:
			- none

Subfolders:

	Name: Functions
	Description: This folder contains the external functions that were used in the codes descripted above. Original scripts are indicated with (or) behind the name. These are written by Marja Haagsma. 
		Functions:
			Name: AOI_circles.m (or)
			Description: Function to find the center and radius of all the circles

			Name: bhattacharyya.m
			Description: Bhattacharyya distance between two Gaussian classes. Ref: Kailath, T., The Divergence and Bhattacharyya Distance Measures in Signal Selection, IEEE Trasnactions on Communication Technology, Vol. 15, No. 1, pp. 52-60, 1967

			Name: CircDet.m (or)
			Description: Finds the circle features of the pots. This function is specified for the use in the OSU greenhouse experiment.

			Name: Classify_SVMlin.m (Matlab generated)
			Description: Classifies the input data using a support vector machine with a linear kernel.

			Name: createCirclesMask.m (Matlab)
			Description: Make a mask for circles. Author: Brett Shoelson

			Name: dv1.m (or)
			Description: First derivative for feature calculation.

			Name: kappa_coefficient.m (or)
			Description:  Determines the Cohen's kappa coefficient for a confusionmatrix.

			Name: lam_lam.m (or)
			Description: Create lambda-lambda, the normalized differential index for all possible pairings of wavelengths.

			Name: lam_lam_log.m (or)
			Description: The logarithmic verison of lam_lam. Instead of using the reflectance value, we take the log of the inverse of the reflectance.

			Name: NSA.m (or)
			Description: The New Search Algorithm for feature ranking based on p-values and Bhattacharyya distance.

			Name: plotRGB.m
			Description: Visualize a hyperspectral cube with an RGB-composite. Ref: L.A. Klerk, AMOLF, Amsterdam, Netherlands / 2009

			Name: ref_ratio.m (or)
			Description: Calculates the reflectance ratio for feature calculations. 

			Name: similar_pots.m (or)
			Description: Finds the indices in the matrix for thwo matrices where the pot's/individual's labels correspond.

			Name: VI_Calculator.m (or)
			Description: Calculates the 84 identified vegetation indices for feature creation. For description of the vegetation indices, see the manuscript.  

			Name: wv2bnd.m (or)
			Description: use the wavelengths vector to automatically determine which bands is closest to the assigned wavelength.

	Name: Misc
	Description: miscellaneous files
			Names: '05_03_Mask_background.png', '05_23_Mask_75.png', and '05_23_Mask_background_75.png'
			Description: The input files used to create the segmentation classifier to extract pine-pixels for further analysis. These masks were manually created in GIMP 2.10.2

			Name: 'TC_0523_0503.mat'
			Description: Matlab file containing the trained classifier for separation pine-pixels from background.
