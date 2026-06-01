function [whichSubs, dtsPerSub, veThresh, whichDT] = getConditionSettings(condition)
    switch condition
        case 'AllBinaural'  
            whichSubs = [1 2 3 4 5 6 7 8];
            dtsPerSub = [1 1 1 4 1 7 7 7];
            veThresh  = 0.2;  
            whichDT   = 1;        
        case 'MovingBinaural'   
            whichSubs = [1 2 3 5 6 7 8];
            dtsPerSub = [7 7 7 0 7 7 7 7];
            veThresh  = 0.2;  
            whichDT   = 7;        
            % whichSubs = [1 3 5 6 7 8];
            % dtsPerSub = [7 0 7 0 7 7 7 7];
            % veThresh  = 0.2;  
            % whichDT   = 7;        
        case 'StaticBinaural'  
            whichSubs = [1 2 3 4 5];
            dtsPerSub = [4 4 4 4 4 0 0 0];
            veThresh  = 0.2;  
            whichDT   = 4;        
        case 'Monaural' 
            % whichSubs = [1 2 3 4 5];
            % dtsPerSub = [10 10 10 10 10 0 0 0];
            % veThresh  = 0.2; 
            % whichDT   = 10;        
            whichSubs = [1 2 3 5];
            dtsPerSub = [10 10 10 0 10 0 0 0];
            veThresh  = 0.2; 
            whichDT   = 10;        
        otherwise
            error("Unknown condition")
    end
end
