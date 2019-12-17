function mfccvector = addVelocities(mfccVectors)
    
    velocities = [];
    
    [elementsInVector,numVectors] = size(mfccVectors);
    
    elementsInVector = elementsInVector - 1; %ignore energy element

    velocityVector = mfccVectors((1:elementsInVector),2);
    velocities = cat(2, velocities, velocityVector);

    %loop through feature vectors and calculate delta component
    for i=2:numVectors-1
        velocityVector = minus(mfccVectors((1:elementsInVector),i+1),mfccVectors((1:elementsInVector),i-1));
        velocities = cat(2, velocities, velocityVector);
    end
        
    velocityVector = minus(0,mfccVectors((1:elementsInVector),numVectors-1));
    velocities = cat(2, velocities, velocityVector);
    
    mfccvector = cat(1, mfccVectors, velocities);
    
end

