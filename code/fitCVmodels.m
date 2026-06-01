
clear;
clc;
close all;
addpath('/media/harveylab/500GB/Yichen/Code');

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';

whichSubs = [2];

% DTs=[4 7 10 13]; 
% DTsOdd=[5 8 11 15];
% DTsEven=[6 9 12 14];
DTs=[4]; 
DTsOdd=[5];
DTsEven=[6];
DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

DTs2=[4 13]; 
DTsOdd2=[5 15];
DTsEven2=[6 14];
DTsAll2=[DTs2; DTsOdd2; DTsEven2];
allXvalDTs2=[DTsOdd2; DTsEven2];
DTsAll2=DTsAll2(:);
allXvalDTs2=allXvalDTs2(:);

combinedDTsAll{1}=allXvalDTs;
combinedDTsAll{2}=allXvalDTs;
combinedDTsAll{3}=allXvalDTs;
combinedDTsAll{4}=allXvalDTs2;
combinedDTsAll{5}=allXvalDTs;
combinedDTsAll{6}=[5 6];
combinedDTsAll{7}=[5 6];
combinedDTsAll{8}=[5 6];
% 

allowRescale=2; %0 allows no rescaling. 1 allows every component to rescale independently (so has more freedom with more complex models). 2 fixes the ratios of the components and only allows one rescaling degree
baseModelNames=["*n-DT0.5-ILD-Linear*gFit*", "*n-DT0.5-ILD-Linear*-gFit-gFit*",...
    "*n-DT0.5-ILD-Log*-gFit*", "*n-DT0.5-ILD-Log*-gFit-gFit*", "*n-DT0.5-ILD-originalLog*-gFit*",...
    "*d-DT0.5-ILD-Log*", "*d-DT0.5-ILD-originalLog*",...
    "*1DCompressiveMonotonic-DT0.5-dBRight_*",...
    "*1DCompressiveMonotonic-DT0.5-dBRight-Log*", ...
    "*1DCompressiveMonotonic-DT0.5-dBLeft_*", ...
    "*1DCompressiveMonotonic-DT0.5-dBLeft-Log*", ...
    "*1DCompressiveBalance-DT0.5-dB_*", ...
    "*1DCompressiveBalance-DT0.5-dB-Log*", ...
    "*1DCompressiveWeighted-DT0.5-dB_*", ...
    "*1DCompressiveWeighted-DT0.5-dB-Log*"];
modelNames=baseModelNames([1 3 5 8 9 10 11 14 15]);

roiName='gray-Layer1';
%roiName='LeftBAMap';

for whichSub=whichSubs
    cd(paths{whichSub})
    fprintf('\n=== Processing Subject %d ===\n', whichSub);

    OddDTs  =  combinedDTsAll{whichSub}(1:2:end);
    EvenDTs =  combinedDTsAll{whichSub}(2:2:end);
    Mix2DTs=OddDTs;
    Mix5DTs=EvenDTs;

    try
        close(1); mrvCleanWorkspace;
    end

    mrVista 3;
    [VOLUME{1}] = loadROI(VOLUME{1}, roiName, [], [], 0, 1);
    for whichDT=1:length(Mix2DTs)
        for whichSplit=1:2;
            if whichSplit==1
                VOLUME{1}.curDataType=Mix2DTs(whichDT);%This determines where to load the data from. Use the OTHER split, and compare the the model from THIS split
                paramsDTname=dataTYPES(Mix5DTs(whichDT)).name;
                modelDTname=dataTYPES(Mix2DTs(whichDT)).name;

            else
                VOLUME{1}.curDataType=Mix5DTs(whichDT);
                paramsDTname=dataTYPES(Mix2DTs(whichDT)).name;
                modelDTname=dataTYPES(Mix5DTs(whichDT)).name;
            end            

            for whichModel=1:length(modelNames)
                %Load the PARAMS we want, which depend where the data will come from 
                file=dir(fullfile('Gray/', paramsDTname, '/', 'xval/',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                % thisModelName=modelFiles(whichModel);%LZ added 'Xval',because all models we want to use  are in this file
                if length(file)==1;
                    thisModelName=file;
                elseif length(file)==2
                    if length(file(1).name)<length(file(2).name)
                        thisModelName=file(1);
                    else
                        thisModelName=file(2);
                    end
                elseif length(file)==3
                     if length(file(1).name)<length(file(2).name)  && length(file(1).name)<length(file(3).name)
                        thisModelName=file(1);
                     elseif length(file(2).name)<length(file(1).name)  && length(file(2).name)<length(file(3).name)
                        thisModelName=file(2);
                     else
                        thisModelName=file(3);
                     end
                end
                load(fullfile('Gray/', paramsDTname, '/', 'xval',thisModelName.name));
                paramsXval=params;

                %Load the MODEL we want
                % thisModelName=dir(fullfile('Gray/', modelDTname, '/', 'Xval',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                file2=dir(fullfile('Gray/', modelDTname, '/', 'xval/',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                if length(file2)==1;
                    thisModelName2=file2;
                elseif length(file2)==2
                    if length(file2(1).name)<length(file2(2).name)
                        thisModelName2=file2(1);
                    else
                        thisModelName2=file2(2);
                    end
                elseif length(file2)==3
                     if length(file2(1).name)<length(file2(2).name)  && length(file2(1).name)<length(file2(3).name)
                        thisModelName2=file2(1);
                     elseif length(file2(2).name)<length(file2(1).name)  && length(file2(2).name)<length(file2(3).name)
                        thisModelName2=file2(2);
                     else
                        thisModelName2=file2(3);
                     end
                end
                load(fullfile('Gray/', modelDTname, '/', 'xval',thisModelName2.name));

                params=paramsXval; %IMPORTANT set the parameters to the other half of the data, on which the model was NOT fit. Mostly this allows for models fit from different stimulus sequences to be cross-validated

                %Load data
                params.wData='roi';

                %FOR TESTING, REMOVE LATER
                % params.analysis.calcPC=0;

                [data] = rmLoadData(VOLUME{1}, params, 1,params.analysis.coarseToFine);
                data(isnan(data)) = 0;
                data       = single(data);
                clear('ROIcoords');
                % coords of ROI in all data
                [tmp, ROIcoords]=intersectCols(VOLUME{1}.coords, VOLUME{1}.ROIs(end).coords); 

                %Now make predicted timeseries
                [trends, ntrends, dcid]  = rmMakeTrends(params);
                trends = single(trends);

                trendBetas = pinv(trends)*data;
                %if isfield(params.analysis,'allnuisance')
                %    trendBetas(ntrends+1:end) = 0;
                %    ntrends = ntrends + size(params.analysis.allnuisance,2);
                %end


                data       = data - trends*trendBetas;
                
                if length(model{1}.beta)<length(model{1}.x0) % size of gray vs. size of alldata
                    [VOLUME{1}] = loadROI(VOLUME{1}, params.roi.name, [], [], 0, 1);
                    % coords of roi in gray
                    [tmp, ROIcoords2, ib]=intersectCols(VOLUME{1}.ROIs(2).coords, VOLUME{1}.ROIs(1).coords); 
                    ROIbetas=squeeze(model{1}.beta(1,ROIcoords2, :));
                    VOLUME{1} = deleteROI(VOLUME{1},2);
                else
                    ROIbetas=squeeze(model{1}.beta(1,ROIcoords, :));
                end
                % ROIbetas=squeeze(model{1}.beta(1,ROIcoords, :));
                trendBetas=trendBetas';
                if isfield(params.stim, 'nGLMpredictors')
                    trendBetas(:,2+params.stim.nGLMpredictors:(size(trendBetas,2)+1+params.stim.nGLMpredictors))=trendBetas;
                    trendBetas(:,1:1+params.stim.nGLMpredictors)=0;
                elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                    trendBetas(:,(1+size(params.analysis.allstimimages,2)):(size(trendBetas,2)+size(params.analysis.allstimimages,2)))=trendBetas;
                    trendBetas(:,1:size(params.analysis.allstimimages,2))=0;  %HERE
                else
                    if size(ROIbetas,2)==ntrends+1
                        trendBetas(:,2:(size(trendBetas,2)+1))=trendBetas;
                        trendBetas(:,1)=0;
                    elseif size(ROIbetas,2)==ntrends+2
                        trendBetas(:,3:(size(trendBetas,2)+2))=trendBetas;
                        trendBetas(:,1:2)=0;
                    end
                end

                ROIbetas=ROIbetas-trendBetas;
                % if contains(modelNames, 'ILD-Log')
                %     params.analysis.X = sinh(params.analysis.X);
                %     params.analysis.Y = sinh(params.analysis.Y);
                % end
                % loop every voxel in selected roi
                for whichVoxel=1:size(data,2)
                    modelName = rmGet(model{1}, 'desc');

                    params.analysis.x0=model{1}.x0(ROIcoords(whichVoxel)); % coords of rois in all data (not sorted)
                    params.analysis.y0=model{1}.y0(ROIcoords(whichVoxel));
                    try
                        params.analysis.sigmaMajor=model{1}.sigma.major(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.sigmaMinor=model{1}.sigma.minor(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.theta=model{1}.sigma.theta(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.exponent=model{1}.exponent(ROIcoords(whichVoxel));
                    end

                    [prediction, prediction2, RFs, rf2, glmPredictor]=rmGridFit_makePrediction(params);

                    if allowRescale==0
                        if size(glmPredictor, 1)>0
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+glmPredictor*ROIbetas(whichVoxel, 2:1+size(glmPredictor, 2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            scaledPrediction=prediction*ROIbetas(whichVoxel, 1:size(params.analysis.allstimimages,2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(params.analysis.allstimimages, 2));
                        else
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        end
                    elseif allowRescale==1
                        if size(glmPredictor, 1)>0
                            X    = [prediction(:,n) glmPredictor trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            if b(1)<0
                                X=[glmPredictor trends(:,dcid)];
                                [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                                scaledPrediction=glmPredictor*b(2:1+size(glmPredictor, 2))+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            else
                                scaledPrediction=prediction.*b(1)+glmPredictor*b(2:1+size(glmPredictor, 2))+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            end
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            X    = [prediction trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            scaledPrediction=prediction*b(1:size(params.analysis.allstimimages,2))+trends(:,dcid)*b(end+(1-length(dcid)):end);
                        else
                            X    = [prediction(:,n) trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            if b(1)<0
                                X=[trends(:,dcid)];
                                [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                                scaledPrediction=trends(:,dcid)*b(end+(1-length(dcid)):end);
                            else
                                scaledPrediction=prediction.*b(1)+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            end
                        end
                        %IF USING THIS RESCALE=1, ADD CODE TO SAVE BETAS
                    elseif allowRescale==2
                        if size(glmPredictor, 1)>0
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+glmPredictor*ROIbetas(whichVoxel, 2:1+size(glmPredictor, 2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            scaledPrediction=prediction*ROIbetas(whichVoxel, 1:size(params.analysis.allstimimages,2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(params.analysis.allstimimages, 2));
                        else
                            if isempty(prediction2)
                                % ROIbetas - coords of beta in gray (sorted)
                                scaledPrediction=prediction.*ROIbetas(whichVoxel, 1);%+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                            else
                                scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+prediction2.*ROIbetas(whichVoxel, 2);%+trends(:,dcid)*ROIbetas(whichVoxel, 3+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                            end
                        end
                        X    = [scaledPrediction trends(:,dcid)];
                        [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                        % if b(1)<0
                        if b(1)<=0  
                            X=[trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            scaledPrediction=trends(:,dcid)*b(end+(1-length(dcid)):end);
                            b=[0 b];
                        else
                            scaledPrediction=scaledPrediction.*b(1)+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            % scaledPrediction=scaledPrediction.*b(1)+trends(:,dcid)*b(end);
                        end
                    
                        if ~isempty(prediction2)
                            % ROIbetas - coords of beta in gray (sorted)
                            b1ratio=ROIbetas(whichVoxel, 1)/(ROIbetas(whichVoxel, 1)+ROIbetas(whichVoxel, 2));
                            b2ratio=ROIbetas(whichVoxel, 2)/(ROIbetas(whichVoxel, 1)+ROIbetas(whichVoxel, 2));
                            b=[b(1)*b1ratio*ROIbetas(whichVoxel, 1), b(1)*b2ratio*ROIbetas(whichVoxel, 2), b(2:end)*ROIbetas(whichVoxel, 3+size(glmPredictor, 2))];
                            model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                            model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+2, dcid+size(glmPredictor,2)+2])=b; % check this
                            model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);
                        else
                            b=[b(1)*ROIbetas(whichVoxel, 1), b(2:end)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2))];
                            model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                            model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+1, dcid+size(glmPredictor,2)+1])=b;
                            model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);
                        end
                    end

                    % model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                    % model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+1, dcid+size(glmPredictor,2)+1])=b;
                    % model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);


                    %model{1}.rss(ROIcoords(whichVoxel))./sum((scaledPrediction-data(:,whichVoxel)).^2)/(length(prediction)/(length(prediction)-2))             
                    model{1}.rss(ROIcoords(whichVoxel))=sum((scaledPrediction-data(:,whichVoxel)).^2);%/(length(prediction)/(length(prediction)-2));
                    model{1}.rawrss(ROIcoords(whichVoxel))=sum((mean(data(:,whichVoxel))-data(:,whichVoxel)).^2);
                    % model{1}.rawrss(ROIcoords(whichVoxel))=sum((data(:,whichVoxel)).^2);
                end
                %params=params_original;
                params.analysis.allowRescale=allowRescale;
                MakefilePath=thisModelName2.folder;
                MakefilePath = replace(MakefilePath, "/xval", "");
                % we read data in Xval file and save data in xValRefit
                % both within Each DT file, because I already checked model
                % data in Xval file
                try
                    save(fullfile(MakefilePath, '/xValRefitNew3/', thisModelName2.name), 'model', 'params');
                catch
                    mkdir(fullfile(MakefilePath, '/xValRefitNew3/'));
                    save(fullfile(MakefilePath, '/xValRefitNew3/', thisModelName2.name), 'model', 'params');
                end
            end
        end
    end
end