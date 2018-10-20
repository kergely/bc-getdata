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
        %============================
        %>@brief Class constructor
        %>
        %> The constructors takes data from a local measurement. These need to be passed to the function.
        %>
        %> @param num The number of the pressure tap
        %> @param p0 the pressure at the intake.
        %> @param p0_RMS The mean error of the preesure
        %> @param p_mean The mean pressure along the pressure tappings
        %> @param p_RMS The RMS error of the pressure at he pressure tap
        %> @param filename The filename containing the waveform data
        function obj = Meas_location(num,p0,p0_RMS,p_mean,p_RMS,filename)
            obj.number = num;
            obj.p0 = p0;
            obj.p_mean = p_mean;
            obj.p_RMS = p_RMS;
            obj.p0_RMS = p0_RMS;
            obj.signalfile = filename;
            %function variables passed
            if num > 400
                obj.pnum = 2;
            else
                obj.pnum = 1;
            end %Determine the number of the scanivalve
            load locpairs.mat locpairs; %location pairs are stored in file
            obj.location = locpairs(locpairs==num,2);
        end

        %============================================
        %>@brief return the pressure of the location at all measurements
        %>
        %>Returns the all pressure measurements in the pressure tap by using the waveform file. Note that there is no temporal data.
        %>
        %>@param obj no parameters needed
        %>@return The pressures in the pressure tap during the whole sampling
        %============================================
        function pvec = getp(obj)
            fid = fopen(obj.signalfile);
            data = textscan(fid,'%f %f %f','headerlines',2);
            fclose(fid);
            pvec = data{obj.pnum+1};
        end
        %============================================
        %>@brief return the pressure of the intake during the measurements
        %>
        %>Returns the all pressure measurements in the pressure tap by using the waveform file. Note that there is no temporal data.
        %>
        %>@param obj no parameters needed
        %>@return The pressures in the pressure tap  of the intake during the whole sampling
        %============================================
        function pvec = getp0(obj)
            fid = fopen(obj.signalfile);
            data = textscan(fid,'%f %f %f','headerlines',2);
            fclose(fid);
            pvec = data{1};
        end
        %============================================
        %>@brief perform an fft on the sampled data on the pressure valve
        %>
        %>Returns the all pressure measurements in the pressure tap by using the waveform file. A Hann - window is applied to the signal to decrease spectral leakage.
        %>
        %>@param obj no parameters needed
        %>@return A two-column vector, where the first is the frequency bin and the second is the corresponding pressure amplitude.
        %============================================
        function ffres = getfft(obj)
            pvec = obj.getp();
            Fs = 1000; %Sampling frequency
            L = length(pvec);
            f = (Fs*(0:(L/2))/L)';
            %Now doing fft
            pvec = mean(pvec)+(pvec-mean(pvec)).*hann(L); %Hann(ing) - window, and taking into account the DC component.
            Y = fft(pvec);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = P1(2:end-1)*2;
            ffres = horzcat(f,P1);
        end

        %============================================
        %>@brief perform an fft on the sampled data on the pressure inlet
        %>
        %>Returns the all pressure measurements in the inlet by using the waveform file. A Hann - window is applied to the signal to decrease spectral leakage.
        %>
        %>@param obj no parameters needed
        %>@return A two-column vector, where the first is the frequency bin and the second is the corresponding pressure amplitude.
        %============================================
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
        %=============================================
        %>@brief Check the histogram of a measuremet location
        %>
        %> Plots the histogram and returns the sigma of the distribution
        %>
        %>@param plot whether to actually show the plot or not
        %>@return A number containg sigma
        %================================================
        function sigmap = sigmap(obj,plot)
            pvec = obj.getp();
            pdist = fitdist(pvec,'Normal');
            %[h,p] = chi2gof(pvec,'CDF',pdist,'Nbins',15);
            totest = (pvec-pdist.mu)/pdist.sigma;
            [h,p] = kstest(totest);
            h
            p
            if plot
                histfit(pvec,15,'Normal') %histogram with normal fit
                %histogram(pdist)
            end
            sigmap = pdist.mu;
        end
    end
end


