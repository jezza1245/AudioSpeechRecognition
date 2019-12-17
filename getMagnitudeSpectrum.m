function outputArg1 = getMagnitudeSpectrum(data)

%Fourier Transform
dataF = fft(data);

%Get Magnitude Spectrum
magSpec = abs(dataF);

%Truncate Second Half
magSpecTrunc = magSpec(1:floor((length(magSpec)/2)));

outputArg1 = magSpecTrunc;
end

