function CreateMFCCs(folderName,frameLength,frameOverlap,sampleFreq,numStates,fBankChannels,fBankOverlap,dctTruncation,fbtype,energy,velocity,acceleration)
%Select Directory

%MANUALLY SELECT AUDIO FOLDER
%d = uigetdir(pwd, 'Select Audio Folder');
%files = dir(fullfile(d, '*.wav')); %get all wavs

%AUTOMATIC DEFAULT AUDIO FOLDER
files = dir(fullfile('./audio', '*.wav')); %get all wavs

vectorDims = -1;
%for each wav
for fileIndex=1:length(files)
    
  
    %get audio data
	audio = audioread(files(fileIndex).name);
    disp("FILE: "+files(fileIndex).name);
    
    %downsample?
    if sampleFreq ~= 44100
        audio = resample(audio,sampleFreq,44100);
    end
    
    MFCCVectors = WavToMFCCVector(audio,frameLength,frameOverlap,sampleFreq,fBankChannels,fBankOverlap,dctTruncation,fbtype,energy,velocity,acceleration);
    
    
    % write HTK file
    %open file for writing
    [filepath,name,ext] = fileparts(files(fileIndex).name);
    filename = name+".mfcc";
    fid = -1;
    if mod(name(length(name)),2)==0
        fid = fopen(strcat(folderName,'/MFCCs/test/',filename),'w','ieee-be');
    else
        fid = fopen(strcat(folderName,'/MFCCs/train/',filename),'w','ieee-be');
    end
    
    %write header information
    [numDims,numVectors] = size(MFCCVectors);
    vectorDims = numDims;
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
            fwrite(fid,MFCCVectors(j,i),'float32');
        end
    end
    fclose(fid);
    fprintf("\n");
%endfor
end

writeProtoFile(folderName,numStates,vectorDims);


end

