Scroll down for installation instructions.


This MATLAB toolbox is meant to identify the relevant variables of the eye gaze. 
Copyright 2012, Samuel Rivera, Catherine Best, Hyungwook Yim, Aleix M. Martinez,
 Vladimir Sloutsky, and Dirk B. Walther at The Ohio State University.  

This work was presented at CogSci 2012 in Japan.  All papers using this software must cite the following paper:

Rivera, S., Best, C., Yim, H., Martinez, A., Sloutsky, V., & Walther, D. (2012). 
Automatic selection of eye tracking variables in visual categorization for adults and infants. 
In N. Miyake, D. Peebles, & R. P. Cooper (Eds.), Proceedings of the 34th Annual Conference 
of the Cognitive Science Society (pp. 2240-2245). 


The toolbox makes use of several software packages which implement L1 regularized optimization ( Mark Schmidt),
 support vector machine (LibSVM), and kalman filtering (Kevin Murphy).  They are included for convenienve, but
you can obtain those original packages from:
http://www.di.ens.fr/~mschmidt/Software/L1General.html
http://www.csie.ntu.edu.tw/~cjlin/libsvm/
http://www.cs.ubc.ca/~murphyk/Software/Kalman/kalman.html
  
 
%%%%%%%%%%%  INSTALLATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
To install:


If you are comfortable with MATLAB's command line and using functions, navigate to the folder containing GVSToolbox folder.  Then run:
    >>  addpath(genpath(fullfile(pwd, 'GVSToolbox')));

If you prefer the MATLABs GUI, 
	 1.  open MATLAB's path tool by clicking "Path tool" button or typing "pathtool" at command prompt and pressing enter.  
	 2. In the dialog that pops up, click "Add with subfolder..."
    3. Select the "ExtraToolboxes" directory inside GVSToolbox folder, then click open.
    4. Click "Add folder", and navigate to "GVSToolbox" folder. Click open.
    5. Click "Add folder", and navigate to "src" inside "GVSToolbox" folder. Click open.  
    6. Click save.

    Libraries tested on linux and windows 64 bit.  libsvm may require 
    additional steps to compile for your system.  Instructions inside (ExtraToolboxes).
        



See 'doc/index.html' for a interative HTML tutorial (thanks to m2html package).
See Supplement.pdf for explanation of machine learning methods and parameters

See exampleTable.txt for an example data source file.  Gaze assumed scaled in [0,1]

Run exampleEasy.m for examples of how to:
    1. Load eye data, visualize, and extract variables    
    2. Identify relevant variables (and reading them out in English)
    3. Validate the variables

Run simpleGUI  for graphical user interface

