
close all;
clear;
clc;

%% ptc1 All binaural condition
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=1;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be    "*Mirrored*", "*Mirrored*-originalLog",...

% selected.
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_log", "ILD_log-gfit", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",  "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_log-gfit", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",  "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub01
cd(paths{1});

% for sub01
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% Required to get the names of the various dataTypes
cd(paths{1});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=1
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=1
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS01_All_EightplusNew20.mat', "dataS01")
clear dataS01;
clear dataTmp;

close all;
clear;
clc;

%% ptc1 moving binaural condition
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=1;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be    "*Mirrored*", "*Mirrored*-originalLog",...

% selected.
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub01
cd(paths{1});
% mrVista 3

% for sub01
DTs=[10]; 
DTsOdd=[11];
DTsEven=[12];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{1});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=1
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=1
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS01_moving_EightplusNew20.mat', "dataS01")
clear dataS01;
clear dataTmp;

close all;
clear;
clc;
%% ptc1 static binaural condition
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=1;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be    "*Mirrored*", "*Mirrored*-originalLog",...

% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub01
cd(paths{1});
% mrVista 3

% for sub01
DTs=[7]; 
DTsOdd=[8];
DTsEven=[9];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{1});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=1
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=1
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS01_static_EightplusNew20.mat', "dataS01")
clear dataS01;
clear dataTmp;

close all;
clear;
clc;

%% ptc1 monaural condition
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=1;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be    "*Mirrored*", "*Mirrored*-originalLog",...

% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub01
cd(paths{1});
% mrVista 3

% for sub01
DTs=[13]; 
DTsOdd=[15];
DTsEven=[14];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{1});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=1
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=1
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS01_monaural_EightplusNew20.mat', "dataS01")
clear dataS01;
clear dataTmp;

close all;
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 13 all binaural 
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=2;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% sub13
cd(paths{2});

% for sub13
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);


% Required to get the names of the various dataTypes
cd(paths{2});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=2
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end


DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=2
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS13_all_EightplusNew20.mat', "dataS13")
clear dataS13;
clear dataTmp;
% SetILDViewParams
close all;
clear;
clc;

%% 13 moving binaural 
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=2;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub13
cd(paths{2});
% mrVista 3

% for sub13
DTs=[10]; 
DTsOdd=[11];
DTsEven=[12];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];





% Required to get the names of the various dataTypes
cd(paths{2});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=2
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end


DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=2
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS13_moving_EightplusNew20.mat', "dataS13")
clear dataS13;
clear dataTmp;
% SetILDViewParams
close all;
clear;
clc;
%% 13 static binaural 
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=2;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub13
cd(paths{2});
% mrVista 3

% for sub13
DTs=[7]; 
DTsOdd=[8];
DTsEven=[9];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];





% Required to get the names of the various dataTypes
cd(paths{2});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=2
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end


DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=2
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS13_static_EightplusNew20.mat', "dataS13")
clear dataS13;
clear dataTmp;
% SetILDViewParams
close all;
clear;
clc;
%% 13 monaural binaural 
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=2;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub13
cd(paths{2});
% mrVista 3

% for sub13
DTs=[13]; 
DTsOdd=[15];
DTsEven=[14];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];





% Required to get the names of the various dataTypes
cd(paths{2});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=2
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end


DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=2
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS13_monaural_EightplusNew20.mat', "dataS13")
clear dataS13;
clear dataTmp;
% SetILDViewParams
close all;
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 14 all binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=3;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub14
cd(paths{3});
% mrVista 3

% for sub14
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);


% Required to get the names of the various dataTypes
cd(paths{3});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.


% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=3
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=3
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS14_all_EightplusNew20.mat', "dataS14")
clear dataS14;
clear dataTmp;


% SetILDViewParams

close all;
clear;
clc;


%% 14 moving binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=3;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub14
cd(paths{3});
% mrVista 3

% for sub14
DTs=[10]; 
DTsOdd=[11];
DTsEven=[12];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{3});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.


% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=3
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=3
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS14_moving_EightplusNew20.mat', "dataS14")
clear dataS14;
clear dataTmp;


% SetILDViewParams

close all;
clear;
clc;

%% 14 static binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=3;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub14
cd(paths{3});
% mrVista 3

% for sub14
DTs=[7]; 
DTsOdd=[8];
DTsEven=[9];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{3});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.


% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=3
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=3
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS14_static_EightplusNew20.mat', "dataS14")
clear dataS14;
clear dataTmp;


% SetILDViewParams

close all;
clear;
clc;

%% 14 monaural binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=3;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.


% sub14
cd(paths{3});
% mrVista 3

% for sub14
DTs=[13]; 
DTsOdd=[15];
DTsEven=[14];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{3});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.


% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=3
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=3
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS14_monaural_EightplusNew20.mat', "dataS14")
clear dataS14;
clear dataTmp;


% SetILDViewParams

close all;
clear;
clc;

%%

%%%%%%%%%%%%%%%%%
%% 15 static
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=4;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];


% sub15
cd(paths{whichSubs});
% mrVista 3
% 
% for sub15
DTs=[4];
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);


% Required to get the names of the various dataTypes
cd(paths{whichSubs});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.


% EightplusNew
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=whichSubs
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=whichSubs
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS15_static_EightplusNew20.mat', "dataS15")
clear dataS15;
clear dataTmp;


% SetILDViewParams

close all;
clear;
clc;




%% 15 monaural
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=4;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];


% sub15
cd(paths{whichSubs});
% mrVista 3
% 
% for sub15
DTs=[13];
DTsOdd=[15];
DTsEven=[14];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% Required to get the names of the various dataTypes
cd(paths{whichSubs});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.


% EightplusNew
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=whichSubs
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=whichSubs
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS15_monaural_EightplusNew20.mat', "dataS15")
clear dataS15;
clear dataTmp;


% SetILDViewParams

close all;
clear;
clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 18 all binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=5;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{5});
% mrVista 3

% for sub18
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);




% Required to get the names of the various dataTypes
cd(paths{5});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=5
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=5
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS18_all_EightplusNew20.mat', "dataS18")
clear dataS18;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;




%% 18 moving binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=5;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{5});
% mrVista 3

% for sub18
DTs=[10]; 
DTsOdd=[11];
DTsEven=[12];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% 
% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% 




% Required to get the names of the various dataTypes
cd(paths{5});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=5
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=5
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS18_moving_EightplusNew20.mat', "dataS18")
clear dataS18;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;

%% 18 static binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=5;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{5});
% mrVista 3

% for sub18
DTs=[7]; 
DTsOdd=[8];
DTsEven=[9];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% 
% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% 




% Required to get the names of the various dataTypes
cd(paths{5});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=5
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=5
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS18_static_EightplusNew20.mat', "dataS18")
clear dataS18;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;


%% 18 monaural binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=5;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{5});
% mrVista 3

% for sub18
DTs=[13]; 
DTsOdd=[15];
DTsEven=[14];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

% 
% modelNames{1}=["dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB-Log"];
% % % modelNames{1}=["ILD_originallog",  "ILD_originalMirrored"];
% % % modelFileNames{1}=["ILD-originalLog*-gFit",  "Mirrored*-originalLog"];
% % CrossValidateCandidateBinauralModels
% % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% % modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",    "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",    "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% 




% Required to get the names of the various dataTypes
cd(paths{5});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=5
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=5
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS18_monaural_EightplusNew20.mat', "dataS18")
clear dataS18;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

%% 19 moving binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=6;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{whichSubs});
% mrVista 3

% for sub18
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);





% Required to get the names of the various dataTypes
cd(paths{whichSubs});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=whichSubs
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=whichSubs
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS19_moving_EightplusNew20.mat', "dataS19")
clear dataS19;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

%% 20 moving binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=7;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{whichSubs});
% mrVista 3

% for sub18
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);





% Required to get the names of the various dataTypes
cd(paths{whichSubs});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=whichSubs
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=whichSubs
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS20_moving_EightplusNew20.mat', "dataS20")
clear dataS20;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

%% 21 moving binaural

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
subjectOrder=baseSubjectOrder;

% Select which of the above subjects to run analysis for
whichSubs=8;
%Define which mrVista dataTYPES contain your data for all, odd and even
%runs (odd and even for cross-validation)
%DTnames=["StaticBinaural","OddStaticBinaural", "EvenStaticBinaural", "AllLeft","AllRight", "OddLeft","OddRight","EvenLeft", "EvenRight","AllMonaural","EvenMonaural","OddMonaural"];
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC"];
% Models withing each folder
modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelNames{1}=["ILD", "ILD_HRF"];
% Unique part of corresponding file name
% If multiple files match this unique part, the shortest file name will be
% selected.
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight", "1DCompressiveMonotonic-DT0.5-dBLeft", "1DCompressiveBalance-DT0.5-dB", "LinearMonaural-DT0.5-dBLeft", "LinearMonaural-DT0.5-dBRight"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% modelNames{1}=["dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB*Log"];
% DTs are those with all data, the other two contain odd and even scans
% Order of entry needs to match, i.e. DTs{1}=XXAll, DTsOdd{1}=XXOdd,
% DTsEven{1}=XXEven, DTs{2}=YYAll, DTsOdd{2}=YYOdd, etc.

% modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog",  "ILD_originalMirrored", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
% modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Linear*-gFit-gFit", "ILD-Log*-gFit", "ILD-Log*-gFit-gFit", "ILD-originalLog*-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveBalance-DT0.5-dB_", "1DCompressiveBalance-DT0.5-dB-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];
modelNames{1}=["ILD", "ILD_log", "ILD_originallog", "ILD_log_ggfit",  "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBWeighted_linear", "dBWeighted_log"];
modelFileNames{1}=["ILD-Linear*-gFit", "ILD-Log*-gFit", "ILD-originalLog*-gFit", "ILD-Log*-gFit-gFit",   "1DCompressiveMonotonic-DT0.5-dBRight_", "1DCompressiveMonotonic-DT0.5-dBRight-Log", "1DCompressiveMonotonic-DT0.5-dBLeft_", "1DCompressiveMonotonic-DT0.5-dBLeft-Log", "1DCompressiveWeighted-DT0.5-dB_", "1DCompressiveWeighted-DT0.5-dB-Log"];

% sub18
cd(paths{whichSubs});
% mrVista 3

% for sub18
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);





% Required to get the names of the various dataTypes
cd(paths{whichSubs});
mrVista 3
for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all


% %Get that data. MOST SUBSEQUENT STEPS RELY ON THE DATA BEING STRUCTURED IN
% %A SPECIFIC WAY, FROM THIS STEP.

% 8+newmap
mapNames=baseMapNames;
mapNames(9)='PC';
for thisSub=whichSubs
    close all; mrvCleanWorkspace;
    dataTmp=getILDModelData(paths{thisSub}, modelNames, modelFileNames, mapNames, DTsAll, allXvalDTs);
    eval([char(subjectOrder(thisSub)), '=dataTmp;'])
end

DTnames=baseDTnames;
%Join all ROIs within subject into a field called 'All'
for thisSub=whichSubs
    thisData=char(subjectOrder(thisSub));
    UniteROIsILD;
end
save('dataS21_moving_EightplusNew20.mat', "dataS21")
clear dataS21;
clear dataTmp;




% SetILDViewParams
close all;
clear;
clc;