%> @file Filename.m
%> @brief File used to store the Filename class
%=============================================
%> @brief A class for storing all the files that correspont with the
classdef Filename

    properties
        %>filename and path, can be passed onto a "Measurement"
        file
        %>The frequency of the ventilator
        ventilspeed
        %>Degree of the BC flap
        BCdeg
        %> side/centralness of the location
        location
        %> length of the measurement in [s]
        length
    end

    methods
        %==========================================7
        %> @brief Class constructor
        %>
        %> Constructor needs all necessary data as there was not much sense in
        %> making it very clever
        function obj = Filename(filename,freq,deg,loc,time)
            %FILENAME Construct an instance of this class
            obj.file = filename;
            obj.ventilspeed = freq;
            obj.BCdeg = deg;
            obj.location = loc;
            obj.length = time;
        end

    end
end
