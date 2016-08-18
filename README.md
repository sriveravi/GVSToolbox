
GVS Quick Start Guide
===


This MATLAB toolbox is meant to identify the relevant variables of the eye gaze.  Those variables best distinguish two experiment groups or conditions. Copyright 2012, Samuel Rivera, Catherine Best, Hyungwook Yim, Aleix M. Martinez, Vladimir Sloutsky, and Dirk B. Walther at The Ohio State University.

This work was presented at CogSci 2012 in Japan. Please cite:

Rivera, S., Best, C., Yim, H., Martinez, A., Sloutsky, V., & Walther, D. (2012). Automatic selection of eye tracking variables in visual categorization for adults and infants. In N. Miyake, D. Peebles, & R. P. Cooper (Eds.), Proceedings of the 34th Annual Conference of the Cognitive Science Society (pp. 2240-2245).



---
## Installation

#### Non-coders    
1. Click "download zip" at top of this GitHub page.
2. Unzip downloaded file.
3. Open MATLAB's path tool by clicking "Path tool" button or typing "pathtool" at command prompt (where you see the ">>" ).
4. In the dialog that pops up, click "Add with subfolder..."
5. Select the "GVSToolbox" directory, then click open.
6. Click save.

#### Coders

1. fork or clone
2. In Matlab, navigate to "GVSToolbox" then run:


    addpath(genpath(pwd));

#### Installation Notes
* Libraries tested on linux and windows 64 bit.  libsvm (for SVM) may require additional steps to compile for your system.  Instructions inside (ExtraToolboxes). Optionally, just don't use SVM classifier.

* The toolbox uses several (included in "ExtraToolboxes" directory) software packages which implement L1 regularized optimization by [Mark Schmidt](http://www.di.ens.fr/~mschmidt/Software/L1General.html),
 support vector machine by [LibSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/), and kalman filtering by [Kevin Murphy](http://www.cs.ubc.ca/~murphyk/Software/Kalman/kalman.html).

---
## Testing
Run the following script to run through a battery of tasks with the included example files.

    exampleEasy;

You should get output that looks like this at command prompt:

    Var 1 is feat 1 of totalDistTraveled
    Var 2 is feat 1 of latencyFirstRelAOIFixation
    Var 3 is feat 1 of AOIFixDensity
    Accuracy = 0.25, (1/4), 0 Guessed 1; Train # class 1: 0, class 0: 1.
    Accuracy = 0.00, (0/1), 1 Guessed 1; Train # class 1: 3, class 0: 1.
    Finding fixations and saccades... done!   

Then you should see a video of the actual gaze superimposed on the stimulus image    

![gaze visualize](./Screenshots/GVSVis.png "Gaze Visualization")

## Graphical User Interface (GUI)
Open the GUI by running the script:

    simpleGUI;


![gvs gui](./Screenshots/GVSGUI.png "GVS GUI")



## Data Source Format
* See exampleTable.txt for an example.
* Data source file in following tab delimited format.
* Gaze coordinates assumed scaled in [0,1].  Missing coordinates set as -1.
* Label should be 0 or 1, corresponding to the different experiment groups.  The toolbox identifies the gaze features that separate those groups.

![data file](./Screenshots/dataExample.png "data source")
---
## Documentation

* Interactive HTML documentation (thanks to [m2html](http://www.artefact.tk/software/matlab/m2html/) package) in 'doc/GVSHome.html', or see the [online version](sriveravi.github.io/GVSToolbox).

* Supplement.pdf for detailed explanation of machine learning methods and parameter choices.

##  Examples
All necessary example files are included to get you started with the toolbox.  For testing general functionality, run

    exampleEasy;

#### Load data source file 'exampleTable.txt'

    dataStructRaw = loadFromTable( 'exampleTable.txt' );

#### Run a Kalman filter on noisy gaze data

    dataStruct = smoothTracks( dataStructRaw );

#### Visualize noisy and filtered gaze over display image

    varParams.imageSize = [1024; 1280]; % set image size (h,width)
    imgFile = 'AOI_Dense_Test.bmp';
    eyePos = dataStruct.trackCell{1};
    eyePosUnfilt  = dataStructRaw.trackCell{1};
    visualizeTrackDist(  eyePos, eyePosUnfilt, imgFile, varParams);


#### Extract gaze variables (fixatons/saccades/dwell times)

    varParams.imageSize = [1024; 1280]; % set image size (h,width)
    varParams.numFixationInSeq = 5;  % keep up to 5 fixations
    aoiPositions = [ 20, 40;  % x1, x2
                     40, 80]; % y1, y2  
    aoiRadius = 30;  % 30 pixel radius for AOI cicular region
    relevantAOIs = 1;  % AOI (x1,y1) is relevant AOI
    [ featureVect, varParams ] = extractVarsDist( dataStruct.trackCell, aoiPositions, aoiRadius, relevantAOIs, varParams );


#### Identify relevant variables (those that separate experiment conditions)

    numWanted = 5;   % number variables to keep

    % Using Sparse Logistic Regression
    [ bestVariablesLR ] = sortVariablesLR( featureVect, dataStruct.allLabels, numWanted );

    % Using Naiive Bayes
    [ bestVariablesBayes] = sortVariablesNB( featureVect, dataStruct.allLabels, dataStruct.sampsPerSubj, numWanted );             


#### Output best variables in human readable format

    describeVariables( varParams, bestVariablesLR );   


#### Validate using classifier

    % LDA
    [ percCorrectLDA, wLDA ] = runLDALeave1Out( featureVect(bestVariablesLR,:), dataStruct.allLabels, dataStruct.sampsPerSubj );

    % SVM using libSVM
    [ percCorrectSVM, wSVM  ] = runSVMLeave1Out( featureVect(bestVariablesLR,:), dataStruct.allLabels, dataStruct.sampsPerSubj );


#### Output top variables for data analysis

    exportToTable( dataStruct, featureVect(bestVariablesLR,:), 'outFile.txt' );
