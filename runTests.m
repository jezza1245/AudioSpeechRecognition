function runTests()

sampleFreq = 8000; % 8000 was best

frameLength = 20; %20 was best
frameOverlap = 0.0; %0.0 was best

fbankType = 'mel';
fbankChannels = 16; %16 was best
fbankOverlap = 0.5; % 0.3 was best

postDctTruncation = 0.7; % 0.7 was best

energy = true;
velocity = true;
acceleration = true;

numStates = 4; % 12,16,20,24 were best

count = 0;


    
    folderName = strcat('PLEASS',num2str(count));
    copyfile('ASRv2',folderName);

    CreateMFCCs(folderName,frameLength,frameOverlap,sampleFreq,numStates,fbankChannels,fbankOverlap,postDctTruncation,fbankType,energy,velocity,acceleration);



    
    







end

