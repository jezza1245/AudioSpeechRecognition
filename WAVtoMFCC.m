function WAVtoMFCC()
    %CREATE A SINGLE MFCC FROM SINGLE WAV WITH DESIRED PARAMETERS
    
    sampleFreq = 16000;

    frameLength = 20;
    frameOverlap = 0.0;

    fbankType = 'mel';
    fbankChannels = 16;
    fbankOverlap = 0.5;

    postDctTruncation = 0.5;

    energy = true;
    velocity = true;
    acceleration = true;

    numStates = 20;

    
    fil = uigetfile(pwd, 'Select WAV');
    disp("SELECTED WAV -> "+fil);

    dir = uigetdir(pwd, 'Select Version');
    folderName = dir;
    disp("SELECTED FOLDER -> "+folderName);
    
    disp(" ###### VARIABLES ##### ");
    disp("Sample Frequency (Samples Per Second) -> "+sampleFreq);
    disp("Frame Based Characteristics");
    disp("    Frame Length (ms) -> "+frameLength);
    disp("    Frame Overlap(%)(0 to 1) -> "+frameOverlap);
    disp("FilterBank Based Characteristics");
    disp("    FilterBank Type -> "+fbankType);
    disp("    #Channels-> "+fbankChannels);
    disp("    Channel Overlap -> "+fbankOverlap);
    disp("Post-DCT Truncation -> "+postDctTruncation);
    disp("Energy Characteristic -> "+energy);
    disp("Velocity Characteristic -> "+velocity);
    disp("Acceleration Characteristic -> "+acceleration);
    disp("HMM Characteristics");
    disp("    #States -> "+numStates);
    disp(" ############# ");
    
    
    %get audio data
	audio = audioread(fil);
    
    %downsample?
    if sampleFreq ~= 44100
        audio = resample(audio,sampleFreq,44100);
    end
    
    LENGTH_OF_FRAME_S = frameLength / 1000; %Convert to seconds
   

% ########## BEGIN ####################################################

    % ########## normalize ##############
    audio = normalize(audio);

    % ########## Calculate Frame Length and Count################
    TOTAL_SAMPLES = length(audio); % Get total num samples in audio
    NUM_SAMPLES_IN_FRAME = (sampleFreq*LENGTH_OF_FRAME_S); 

    % ########## PROCESS FRAME BY FRAME #########
    startSample = 1;
    endSample = NUM_SAMPLES_IN_FRAME;
    fprintf("Processing Frames...");

    mfccvectors = [];
    while true
    
        %############# Get Frame ################
        frame = audio(startSample:floor(endSample));
        %disp("    "+startSample+"->"+floor(endSample));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %############# High pass filter ############
        %subplot(2,1,1),plot(frame);
        for i=length(frame):-1:2
            frame(i) = frame(i)-0.97*frame(i-1);
        end
        %subplot(2,1,2),plot(frame);
        %##########################################


        %########## hamming frame ##########
        subplot(2,1,1),plot(frame);
        frame = frame.*hamming(length(frame));
        subplot(2,1,2),plot(frame);
        plot(frame);
        %hold on;
        %###################################



        %######## get magnitude spectrum #########
        %subplot(2,1,1),plot(frame);
        magSpec = getMagnitudeSpectrum(frame);
        %subplot(2,1,2),plot(magSpec);
        %#########################################


        %############# filterbank ############
        if strcmp(fbankType,'mel')
            fbank = melFilterBank(magSpec,fbankChannels,fbankOverlap,'nonlinear');
        elseif strcmp(fbankType,'tri')
            fbank = melFilterBank(magSpec,fbankChannels,fbankOverlap,'linear');
        else
            fbank = RectFilterBank(magSpec,fbankChannels,fbankOverlap);
        end
        %subplot(2,1,2),plot(fbank);
        %#####################################

        %############# log #################
        %subplot(2,1,1),plot(fbank);
        logData = log(fbank);
        %subplot(2,1,2),plot(logData);
        %###################################

        %############# dct ################
        %subplot(2,1,1),plot(logData);
        dctData = dct(logData);
        %subplot(2,1,2),plot(dctData);
        %##################################

        %############ truncation #############
        %subplot(2,1,1),plot(dctData);
        truncData = dctData(1:floor(length(dctData)*postDctTruncation));
        %subplot(2,1,2),plot(truncData);
        %#####################################

        %########### Energy ############
        if energy
            energyComponent = getEnergyComponent(truncData);
            truncData = cat(1,truncData,energyComponent); 
        end
        %###############################

        mfccvectors = cat(2,mfccvectors,truncData); 

        %########## get next frame ##########
        % get start of next sample, take away overlap of frame
        startSample = floor((endSample + 1)-(frameOverlap*NUM_SAMPLES_IN_FRAME));
        endSample = startSample + NUM_SAMPLES_IN_FRAME - 1;
        if endSample > TOTAL_SAMPLES
            break;
        end
    
    %while can get another frame, loop
    %else end
    end
    
    %########## Temporal Derivatives ##########
    if velocity
        mfccvectors = addVelocities(mfccvectors);
    end
    
    if acceleration
        mfccvectors = addAccelerations(mfccvectors);
    end
    %##########################################
    
fprintf("COMPLETE\n");
    
%################### END #######################################
    
%################### WRITE MFCC FILE ###########################
    [filepath,name,ext] = fileparts(fil);
    filename = name+".mfcc";
    
    fid = fopen(strcat(folderName,'/MFCCs/test/',filename),'w','ieee-be');

    
    %write header information
    [numDims,numVectors] = size(mfccvectors);
    fwrite(fid, numVectors, 'int32'); % number of vector
    
    frameLengthS = frameLength * 10^(-3);
    vectorPeriod = frameLengthS*10^(7); %Change for overlapping and different frame length
    fwrite(fid, vectorPeriod, 'int32'); % sample period in 100ns units (4 byte int)
    
    fwrite(fid, numDims * 4, 'int16'); % number of bytes per vector (2 byte int)
    
    parmKind = 9;
    fwrite(fid, parmKind, 'int16'); % code for the sample kind (2 byte int)
    
    % Write the data: one coefficient at a time:
    for i = 1: numVectors
        for j = 1:numDims
            fwrite(fid,mfccvectors(j,i),'float32');
        end
    end
    fclose(fid);
    fprintf("\n");

%##################### END WRITING MFCC FILE #####################

end
%TEST COMMAND FOR REFERENCE
    %HVite -T 1 -d hmms/ -w lib/NET lib/dict lib/words3 MFCCs/test/speech018.mfcc
   
