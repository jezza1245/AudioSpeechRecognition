function outputVectors = WavToMFCCVector(audio,frameLength,frameOverlap,sampleFreq,fBankChannels,fBankOverlap,finalTruncation,fbanktype,energy,velocity,acceleration)

% ######### GLOBAL VARIABLES ############
LENGTH_OF_FRAME_MS = frameLength; %FRAME LENGTH IN ms
LENGTH_OF_FRAME_S = LENGTH_OF_FRAME_MS / 1000; %Convert to seconds
fs = sampleFreq;
   
% #######################################

% ########## BEGIN ########


% ########## normalize ##############
audio = normalize(audio);

% ########## Calculate Frame Length and Count################
TOTAL_SAMPLES = length(audio); % Get total num samples in audio
NUM_SAMPLES_IN_FRAME = (fs*LENGTH_OF_FRAME_S); % samples per frame = samples per second * seconds in a frame
NUM_SAMPLES_OVERLAP = floor(NUM_SAMPLES_IN_FRAME*frameOverlap);
% ########## PROCESS FRAME BY FRAME #########
startSample = 1;
endSample = NUM_SAMPLES_IN_FRAME;
fprintf("Processing Frames...");

array = [];
while true
    
    %############# Get Frame ################
    frame = audio(startSample:floor(endSample));
    %disp("    "+startSample+"->"+floor(endSample));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %############# High pass filter ############
    %subplot(2,1,1),plot(frame);
    backupFrame = frame;
    for i=2:length(backupFrame)
        frame(i) = backupFrame(i)-0.97*backupFrame(i-1);
    end
    %subplot(2,1,2),plot(frame);
    %##########################################

    
    %########## hamming frame ##########
    frame = frame.*hamming(length(frame));
    
    %###################################
    
    
    
    %######## get magnitude spectrum #########
    %subplot(2,1,1),plot(frame);
    magSpec = getMagnitudeSpectrum(frame);
    %subplot(2,1,2),plot(magSpec);
    %#########################################

    
    %############# filterbank ############
    %subplot(2,1,1),plot(magSpec);
    if strcmp(fbanktype,'mel')
        fbank = melFilterBank(magSpec,fBankChannels,fBankOverlap,'nonlinear');
    elseif strcmp(fbanktype,'tri')
        fbank = melFilterBank(magSpec,fBankChannels,fBankOverlap,'linear');
    else
        fbank = RectFilterBank(magSpec,fBankChannels,fBankOverlap);
    end
    %subplot(2,1,2),plot(fbank);
    %#####################################

    %############# log #################
    %subplot(2,1,1),plot(frame);
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
    truncData = dctData(1:floor(length(dctData)*finalTruncation));
    %subplot(2,1,2),plot(truncData);
    %#####################################
    
    %########### Energy ############
    if energy
        energyComponent = getEnergyComponent(truncData);
        truncData = cat(1,truncData,energyComponent);
    end
    %###############################
    
    array = cat(2,array,truncData); 
    
    %########## get next frame ##########
    % get start of next sample, take away overlap of frame
    startSample = endSample + 1 - NUM_SAMPLES_OVERLAP;
    endSample = startSample + NUM_SAMPLES_IN_FRAME - 1;
    if endSample > TOTAL_SAMPLES
        break;
    end
    
%endfor
end

 %########## Temporal Derivatives ##########
    if velocity
        array = addVelocities(array);
    end
    
    if acceleration
        array = addAccelerations(array);
    end
  %##########################################


fprintf("COMPLETE\n");

outputVectors = array;

end

