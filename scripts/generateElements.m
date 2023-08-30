function positions = generateElements(xElements, yElements, pitch)
    % Generates positions for element transducer probe estimation
    % Returns a matrix of positions, corresponding to their physical
    % distance relative to the origin where the origin is in the direct
    % centre of the transducer. Only relies on the pitch between the
    % elements as we assume the position is the centre of the element. 
    arguments 
        xElements double % Number of elements on horizontal side of transducer
        yElements double % Number of elements on vertical side of transducer
        pitch double     % Pitch between the elements of the transducer
    end
    index = 1;
    positions(1 : xElements * yElements) = Position(0, 0, 0);
    for x = -((xElements - 1) / 2) * pitch : pitch : ((xElements - 1) / 2) * pitch
        for y = ((yElements - 1) / 2) * pitch : -pitch : -((yElements - 1) / 2) * pitch
            positions(index) = Position(x, y, 0);
            index = index + 1;
        end
    end
    positions = reshape(positions, [yElements, xElements]);
end