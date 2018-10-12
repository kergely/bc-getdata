%>@file Meas_location.m
%>@brief Contains the class describing one measurement location.
%================================================================
%>@brief The class of the 
classdef Meas_location

    properties
        %> number of the pressure tapping
        number
        %> the distance of the pressure tap from the inlet.
        location
        %> the mean pressure in the measurement location
        p_mean
        %> The RMS error of the pressure in the location
        p_RMS
        %> The pressure at the inlet, used for calculating velocity
        p0
        %> The error of the pressure in the inlet
        p0_RMS
        %> The file containig the signal data
        signalfile
        %> The number of the scanivalve. Used for extracting the correct time series from the shared signal files.
        pnum
    end

    methods
        function obj = Meas_location(num,p0,p0_RMS,p_mean,p_RMS,filename)
            obj.number = num;
            obj.p0 = p0;
            obj.p_mean = p_mean;
            obj.p_RMS = p_RMS;
            obj.p0_RMS = p0_RMS;
            obj.signalfile = filename;
            %function variables passed
            % now some other stuff
            if num > 400
                obj.pnum = 2;
            else
                obj.pnum = 1;
            end
            load locpairs.mat locpairs;
            obj.location = locpairs(locpairs==num,2);
        end

        function pvec = getp(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fid = fopen(obj.signalfile);
            data = textscan(fid,'%f %f %f','headerlines',2);
            fclose(fid);
            pvec = data{obj.pnum+1};
        end

        function pvec = getp0(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fid = fopen(obj.signalfile);
            data = textscan(fid,'%f %f %f','headerlines',2);
            fclose(fid);
            pvec = data{1};
        end

        function ffres = getfft(obj)
            pvec = obj.getp();
            Fs = 1000; %Sampling frequency
            L = length(pvec);
            f = (Fs*(0:(L/2))/L)';
            %Now doing fft
            pvec = mean(pvec)+(pvec-mean(pvec)).*hann(L); %Hann(ing) - window
            Y = fft(pvec);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = P1(2:end-1)*2;
            ffres = horzcat(f,P1);
        end

        function ffres = getfftp0(obj)
            pvec = obj.getp0();
            Fs = 1000; %Sampling frequency
            L = length(pvec);
            f = (Fs*(0:(L/2))/L)';
            %Now doing fft
            pvec = mean(pvec)+(pvec-mean(pvec)).*hann(L); %Hann(ing) - window
            Y = fft(pvec);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = P1(2:end-1)*2;
            ffres = horzcat(f,P1);
        end

    end
end
