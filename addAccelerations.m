function mfccvectors = addAccelerations(mfccVectors)

    accelerations = [];
    
    [elementsInVector,numVectors] = size(mfccVectors);

    velocityStartIndex = round(elementsInVector/2)+1;
    
    accelerationVector = mfccVectors((velocityStartIndex:end),2);
    accelerations = cat(2, accelerations, accelerationVector);

    %loop through feature vectors and calculate delta component
    for i=2:numVectors-1
        deltaVector = minus(mfccVectors((velocityStartIndex:end),i+1),mfccVectors((velocityStartIndex:end),i-1));
        accelerations = cat(2, accelerations, deltaVector);
    end
        
    accelerationVector = minus(0,mfccVectors((velocityStartIndex:end),numVectors-1));
    accelerations = cat(2, accelerations, accelerationVector);
    
    mfccvectors = cat(1, mfccVectors, accelerations);
    
end

