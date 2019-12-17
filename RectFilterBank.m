function outputArg1 = RectFilterBank(magSpec,numChannels,overlapFactor)
numSamples = length(magSpec);
frameSize = floor((numSamples + (numSamples*overlapFactor))/numChannels);
overlapOffset = round(frameSize*overlapFactor);

r = zeros(numChannels,numSamples);

start = 1;
endd = frameSize;
for i=1:numChannels
   
    r(i,start:endd)=1;
    
    %plot(r(i,:));
    %hold on;
    
    start = endd + 1 - overlapOffset;
    endd = start - 1 + frameSize;
    
end
[rownum,colnum]=size(r);
if colnum > numSamples
    extra = colnum-numSamples;
    r=r(:,1:end-extra);
end
%multiply
fbank = r*magSpec;

%hold off;

outputArg1 = fbank;

end

