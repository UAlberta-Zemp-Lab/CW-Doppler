function [phaseDelays, phaseErrors] = generatePhaseDelays(elementPositions, focalPointPosition, waveLength)
    % Calculates the phase delays (in degrees) and phase errors (in percent)
    % from the inputed elementPositions and focalPointPosition. Wavelength
    % is used to determine the phase delay of each element based on the
    % geometry of the transducer by this relation: Phase distance = N * waveLength / 16,
    % where N is the discrete phase delay, N = 0, 1, 2, ..., 15.
    arguments
        elementPositions (:, :) Position; % Position matrix with N x M size corresponding to number of transducer elements
        focalPointPosition Position;      % Position of focal point relative to origin (center of transducer, +Z is outward from probe toward insonified region)
        waveLength double                 % Wavelength of carrier frequency
    end                                   

    phaseMap = zeros(1, 16);
    for i = 1:16
        phaseMap(i) = (i - 1) * waveLength / 16; % Generates a phase map relating delay angle to distance
    end

    [xElements, yElements] = size(elementPositions);
    phaseDelays = zeros(xElements, yElements);
    phaseErrors = zeros(xElements, yElements);
    for i = 1:xElements
        for j = 1:yElements
            element = elementPositions(i, j);
            distanceFromFocalPoint = sqrt((element.x - focalPointPosition.x) ^ 2 ...
                + (element.y - focalPointPosition.y) ^ 2 ...
                + (element.z - focalPointPosition.z) ^ 2);
            distanceDelta = distanceFromFocalPoint - focalPointPosition.z;
            smallestDelta = 10000; % Should be big enough
            for k = 1:16
                phaseDelta = abs(distanceDelta - phaseMap(k));
                if (phaseDelta < smallestDelta)
                    smallestDelta = phaseDelta;
                    phaseDelays(i, j) = (k-1) * 22.5; % phaseDelays in degrees
                    phaseErrors(i, j) = phaseDelta / waveLength * 100; % phaseError in percent
                end
            end
        end
    end
end