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
To install, first download from GitHub (download zip)


If you are comfortable with MATLAB's command line, navigate to the "GVSToolbox" folder.  Then run:
    >>  addpath(genpath(pwd));

    Test by running: exampleEasy


If you prefer the MATLAB graphical user interface (point and click), 
	 	 1.  open MATLAB's path tool by clicking "Path tool" button or typing "pathtool" at command prompt and pressing enter.  
	    2. In the dialog that pops up, click "Add with subfolder..."
   	 3. Select the "GVSToolbox" directory, then click open.
    	 4. Click save.

    Libraries tested on linux and windows 64 bit.  libsvm may require 
    additional steps to compile for your system.  Instructions inside (ExtraToolboxes).
        

%%%%%%%%%%%%%  TESTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Test by running: exampleEasy

Graphical user interface: Run simpleGUI.  
    Load the "exampleTable.txt" file contained in the "GVSToolbox" folder
 

%%%%%%%%%%%%%  EXAMPLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
See exampleTable.txt for an example data source file.  Gaze assumed scaled in [0,1]

Run exampleEasy.m for examples of how to:
    1. Load eye data, visualize, and extract variables    
    2. Identify relevant variables (and reading them out in English)
    3. Validate the variables

Run simpleGUI  for graphical user interface


%%%%%%%%%%%%%%  DOCUMENTATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

See 'doc/GVSHome.html' for a interactive HTML tutorial (thanks to m2html package).
Online version is at:  sriveravi.github.io/GVSToolbox
   
See Supplement.pdf for explanation of machine learning methods and parameters

