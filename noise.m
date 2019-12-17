function noisyAudio = noise(audioData, noiseData, SNR)

%%%%%%%%%%% Cut noise file to audiofile length %%%%%%%%%%%
noiseData = noiseData(1:length(audioData));

%%%%%%%%%%% Noise calculations to feed into SNR formula %%%%%%%%%%%
noisePower = mean(noiseData.^2);
speechPower = mean(audioData.^2);

%%%%%%%%%%% Calc SNR a %%%%%%%%%%%
a = sqrt((speechPower/noisePower)*(10^-(SNR/10)));
disp(length(noiseData));
disp(length(audioData));

%%%%%%%%%%% Sum speech n noise %%%%%%%%%%%
finalOutput = audioData + (a*noiseData);

noisyAudio = finalOutput;

end

