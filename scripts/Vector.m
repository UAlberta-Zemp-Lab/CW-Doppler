classdef Vector
    %Vector 
    % 3D vector class representation
    % TODO: Add helper functions, i.e., cross product, dot product,
    % projections, etc

    properties
        x double;
        y double;
        z double;
    end

    methods
        function obj = Vector(x_, y_, z_)
            arguments 
                x_ double;
                y_ double;
                z_ double;
            end
            obj.x = x_;
            obj.y = y_;
            obj.z = z_;
        end
    end
end