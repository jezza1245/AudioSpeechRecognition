function energyComponent = getEnergyComponent(mfccVector)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
energies = mfccVector.^2;
energyComponent = log(sum(energies));
end

