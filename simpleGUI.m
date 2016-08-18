function varargout = simpleGUI(varargin)
% SIMPLEGUI MATLAB code for simpleGUI.fig
%      SIMPLEGUI, by itself, creates a new SIMPLEGUI or raises the existing
%      singleton*.
%
%      H = SIMPLEGUI returns the handle to a new SIMPLEGUI or the handle to
%      the existing singleton*.
%
%      SIMPLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLEGUI.M with the given input arguments.
%
%      SIMPLEGUI('Property','Value',...) creates a new SIMPLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simpleGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simpleGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simpleGUI

% Last Modified by GUIDE v2.5 08-Jul-2014 01:17:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simpleGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @simpleGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT





% --- Executes just before simpleGUI is made visible.
function simpleGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simpleGUI (see VARARGIN)

% Choose default command line output for simpleGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simpleGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simpleGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function sampRate_Callback(hObject, eventdata, handles)
% hObject    handle to sampRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampRate as text
%        str2double(get(hObject,'String')) returns contents of sampRate as a double


% --- Executes during object creation, after setting all properties.
function sampRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fixDuration_Callback(hObject, eventdata, handles)
% hObject    handle to fixDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixDuration as text
%        str2double(get(hObject,'String')) returns contents of fixDuration as a double


% --- Executes during object creation, after setting all properties.
function fixDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load up data

[file,folder]=uigetfile;
handles.dataStruct = loadFromTable( fullfile( folder, file) );  

% handles.dataStruct = loadFromTable( 'exampleTable.txt');
if isfield(handles, 'dataStructRaw') % reset if reloading data
    handles = rmfield(  handles, 'dataStructRaw');
end

set( handles.srcFile, 'String', fullfile( folder, file));

handles = getVarParams(handles ); % get default parameters
guidata(hObject,handles)
fprintf( 'Data imported to MATLAB.\n');

function kParam_Callback(hObject, eventdata, handles)
% hObject    handle to kParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kParam as text
%        str2double(get(hObject,'String')) returns contents of kParam as a double


% --- Executes during object creation, after setting all properties.
function kParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% smooth and interpolate
param = str2double( get(handles.kParam, 'string'));
if ~isfield(handles, 'dataStructRaw') 
    handles.dataStructRaw = handles.dataStruct;
end
handles.dataStruct = smoothTracks( handles.dataStruct, param );
guidata(hObject,handles)
fprintf( 'Kalman filtering complete.\n');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% show the gaze

handles = getVarParams(handles );  % load all parameters
guidata(hObject,handles) % set values

% get stimulus image
imgFile = get( handles.imgFile, 'String');  % if empty, will show on black

% get trial indices
subj = str2double(get( handles.pNum, 'string'));

if ~isfield( handles.dataStruct, 'sampsPerSubj' ) % make sure loaded first
    error( ['Gaze Toolbox Error: Load source file first!' ]);
end
       
sps = handles.dataStruct.sampsPerSubj;
if subj > length(sps); % unknown participant
    error( ['Gaze Toolbox Error: Only ' num2str(length(sps))  ' subjects loaded, change participant number']);
elseif subj == 1
    trlIdx = 1:sps(1);  % first participant
    prevTrial = 0;
else
    trlIdx = sum(sps(1:subj-1))+1: sum(sps(1:subj-1))+sps(subj);
    prevTrial = sum(sps(1:subj-1));
end

% visualize tracks
figure(2);
for index = trlIdx;
    title( [ 'Trial ' num2str( index-prevTrial )], 'fontsize', 20 );
    pause(.5);
    
    leftEyePos = handles.dataStruct.trackCell{index};
    if isfield( handles, 'dataStructRaw')
        leftOri = handles.dataStructRaw.trackCell{index};
    else
        leftOri = [];
    end
    visualizeTrackDist(  leftEyePos, leftOri, imgFile, handles.dataStruct.varParams )
end

function pNum_Callback(hObject, eventdata, handles)
% hObject    handle to pNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pNum as text
%        str2double(get(hObject,'String')) returns contents of pNum as a double


% --- Executes during object creation, after setting all properties.
function pNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imgFile_Callback(hObject, eventdata, handles)
% hObject    handle to imgFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgFile as text
%        str2double(get(hObject,'String')) returns contents of imgFile as a double


% --- Executes during object creation, after setting all properties.
function imgFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fixRad_Callback(hObject, eventdata, handles)
% hObject    handle to fixRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixRad as text
%        str2double(get(hObject,'String')) returns contents of fixRad as a double


% --- Executes during object creation, after setting all properties.
function fixRad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sacStartThresh_Callback(hObject, eventdata, handles)
% hObject    handle to sacStartThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sacStartThresh as text
%        str2double(get(hObject,'String')) returns contents of sacStartThresh as a double


% --- Executes during object creation, after setting all properties.
function sacStartThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sacStartThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sacStopThresh_Callback(hObject, eventdata, handles)
% hObject    handle to sacStopThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sacStopThresh as text
%        str2double(get(hObject,'String')) returns contents of sacStopThresh as a double


% --- Executes during object creation, after setting all properties.
function sacStopThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sacStopThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% validate variable

handles = getVarParams(handles ); % get default parameters
guidata(hObject,handles)

% if no top variables found
if ~isfield( handles.dataStruct, 'bestVarsIdx');
    error( 'Gaze Toolbox Error: First select top variables.');
end
bestVarsIdx = handles.dataStruct.bestVarsIdx;
 
% now validate
if get( handles.L1Val, 'Value')  % if doing L1-LR    
    alg = 'L1-Logistic Regression';
    [ percCorrect, w ] = runLRLeave1Out( handles.dataStruct.featureVect(bestVarsIdx,:), ...
        handles.dataStruct.allLabels, handles.dataStruct.sampsPerSubj );
elseif get( handles.BayesVal, 'Value')  % if doing L1-LR
    alg = 'Bayes Classifier';;
    [ percCorrect, w ] = runLDALeave1Out( handles.dataStruct.featureVect(bestVarsIdx,:), ...
        handles.dataStruct.allLabels, handles.dataStruct.sampsPerSubj );
else %otherwise SVM
    alg = 'SVM Classifier';
    [ percCorrect, w  ] = runSVMLeave1Out( handles.dataStruct.featureVect(bestVarsIdx,:), ...
        handles.dataStruct.allLabels, handles.dataStruct.sampsPerSubj );    
end
fprintf( '\n%s Leave 1 subject out CV-Accuracy: %f, feature weights:\n', alg, percCorrect)
w

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% identify and export
handles = getVarParams(handles ); % get default parameters
guidata(hObject,handles)

numWanted = str2double( get( handles.numKeep, 'string'));

% re-calculate feature vectors
fprintf( 'Extracting all gaze variables...')
[  handles.dataStruct.featureVect, handles.dataStruct.varParams ]  ...
    = extractVarsDist( handles.dataStruct.trackCell, ...
        handles.dataStruct.aoiPos, handles.dataStruct.outSideDist, ...
        handles.dataStruct.relAOI, handles.dataStruct.varParams );
fprintf( 'done.\n');

if get( handles.L1Select, 'Value')  % if doing L1-LR
    fprintf( '\nTop L1-LR selected variables:\n');
    [ bestVarsIdx ] = sortVariablesLR( handles.dataStruct.featureVect, handles.dataStruct.allLabels, numWanted );                  
else %doing Naive Bayes otherwise
    fprintf( '\nTop Naive Bayes selected variables:\n');
    [ bestVarsIdx ] = sortVariablesNB( handles.dataStruct.featureVect, handles.dataStruct.allLabels, ...
                handles.dataStruct.sampsPerSubj, numWanted );  
end
% output best variables 
describeVariables( handles.dataStruct.varParams, bestVarsIdx ); % to screen
exportToTable( handles.dataStruct, handles.dataStruct.featureVect(bestVarsIdx,:), 'variablesTable.txt' ); % to table
fprintf( 'Exported to file variablesTable.txt\n');

% add top variables to struct
handles.dataStruct.bestVarsIdx = bestVarsIdx;
guidata(hObject,handles)

function aoiOut_Callback(hObject, eventdata, handles)
% hObject    handle to aoiOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aoiOut as text
%        str2double(get(hObject,'String')) returns contents of aoiOut as a double


% --- Executes during object creation, after setting all properties.
function aoiOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aoiOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aoiX_Callback(hObject, eventdata, handles)
% hObject    handle to aoiX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aoiX as text
%        str2double(get(hObject,'String')) returns contents of aoiX as a double


% --- Executes during object creation, after setting all properties.
function aoiX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aoiX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aoiY_Callback(hObject, eventdata, handles)
% hObject    handle to aoiY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aoiY as text
%        str2double(get(hObject,'String')) returns contents of aoiY as a double


% --- Executes during object creation, after setting all properties.
function aoiY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aoiY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function relAOI_Callback(hObject, eventdata, handles)
% hObject    handle to relAOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of relAOI as text
%        str2double(get(hObject,'String')) returns contents of relAOI as a double


% --- Executes during object creation, after setting all properties.
function relAOI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to relAOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function handles = getVarParams(handles )

% get screen size
w = str2double( get(handles.width, 'string'));
h = str2double( get(handles.height, 'string'));
handles.dataStruct.varParams.imageSize = [h; w];

% fixMinNumSamples = duration * sampRate
handles.dataStruct.varParams.fixMinNumSamples = ceil(str2double( get(handles.fixDuration, 'string'))*str2double( get(handles.sampRate, 'string'))/1000);
handles.dataStruct.varParams.fixMaxCircleRadius = str2double( get(handles.fixRad, 'string'));
handles.dataStruct.varParams.velThreshold = str2double( get(handles.sacStartThresh, 'string'));
handles.dataStruct.varParams.stopThreshold = str2double( get(handles.sacStopThresh, 'string'));
handles.dataStruct.varParams.numFixationInSeq = str2double( get(handles.maxFix, 'string'));
handles.dataStruct.varParams.numSaccadesInSeq = str2double( get(handles.maxSac, 'string'));

% get AOI parameters
aoiX = get( handles.aoiX, 'string');
aoiX = cell2mat( textscan(aoiX, '%f','delimiter', ','))';
aoiY = get( handles.aoiY, 'string');
aoiY = cell2mat( textscan(aoiY, '%f','delimiter', ','))';
aoiPos = [aoiX; aoiY];
outSideDist = str2double( get( handles.aoiOut, 'string'));
handles.dataStruct.aoiPos = aoiPos;
handles.dataStruct.outSideDist = outSideDist;
relAOI = get( handles.relAOI, 'string');
handles.dataStruct.relAOI = cell2mat( textscan(relAOI, '%f','delimiter', ','));


function maxFix_Callback(hObject, eventdata, handles)
% hObject    handle to maxFix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxFix as text
%        str2double(get(hObject,'String')) returns contents of maxFix as a double


% --- Executes during object creation, after setting all properties.
function maxFix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxFix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxSac_Callback(hObject, eventdata, handles)
% hObject    handle to maxSac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxSac as text
%        str2double(get(hObject,'String')) returns contents of maxSac as a double


% --- Executes during object creation, after setting all properties.
function maxSac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load image
[file,folder]=uigetfile;
set( handles.imgFile, 'String', fullfile( folder, file));


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% visualize AOIs
% load up stuff
handles = getVarParams(handles ); % get default parameters
guidata(hObject,handles)

% get stimulus image
showFigure =1;
imgFile = get( handles.imgFile, 'String');  % if empty, will show on black
if isempty( imgFile)
    stimSize = handles.dataStruct.varParams.imageSize;
    A = uint8(zeros( stimSize(1), stimSize(2), 3));
else
    A = imread( imgFile );
end

%show it
figure(2);
AOIimage = viewAOILandscape( handles.dataStruct.aoiPos, handles.dataStruct.outSideDist, A, showFigure );



function numKeep_Callback(hObject, eventdata, handles)
% hObject    handle to numKeep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numKeep as text
%        str2double(get(hObject,'String')) returns contents of numKeep as a double


% --- Executes during object creation, after setting all properties.
function numKeep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numKeep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function srcFile_Callback(hObject, eventdata, handles)
% hObject    handle to srcFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srcFile as text
%        str2double(get(hObject,'String')) returns contents of srcFile as a double


% --- Executes during object creation, after setting all properties.
function srcFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srcFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% k-means auto labeling

handles = getVarParams(handles ); % get default parameters
if ~isfield( handles.dataStruct, 'trackCell' ) % make sure loaded first
    error( ['Gaze Toolbox Error: Load source file first!' ]);
end
fprintf( 'Extracting gaze variables...')
[  handles.dataStruct.featureVect, handles.dataStruct.varParams ]  ...
    = extractVarsDist( handles.dataStruct.trackCell, ...
        handles.dataStruct.aoiPos, handles.dataStruct.outSideDist, ...
        handles.dataStruct.relAOI, handles.dataStruct.varParams );
fprintf( 'done.\n');    
handles.dataStruct.allLabels = autoLabel( handles.dataStruct.featureVect );
fprintf( 'Optional k-means labeling done.  Re-load source to reset trial labels. \n');

guidata(hObject,handles)


% --- Executes when uipanel30 is resized.
function uipanel30_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
