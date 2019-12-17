function fbank = melFilterBank(magSpec,channels,overlapFactor,linOrNonLin)

    numSamples = length(magSpec);
    r = zeros(channels,numSamples);
    if strcmp(linOrNonLin,'nonlinear')
        melFrequencies = 2595*log10(1+magSpec/700); %Equation from lecture  
    else
        melFrequencies = magSpec;  
    end
    frameSize = floor(numSamples/channels);

    start = 1;
    frameSize = round(frameSize+(floor(frameSize*overlapFactor)));
 
    overlapOffset = floor(frameSize*overlapFactor);
    endd = frameSize;
    %overlap = (overlap of orignal framesize * 2 (both sides) with
    %frame size then half)
    tri = triang(frameSize); 

    for i=1:channels

        %insert triangle region
        for j=1:length(tri) %for every point in triangle
            r(i,start+j-1) = tri(j); %insert point in row i
        end
        
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
    %hold off;
    fbank = r * melFrequencies;
    
end