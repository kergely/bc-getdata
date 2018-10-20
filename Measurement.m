%> @file Measurement.m
%> @brief File used to store the Measurement class
% =======================================================
%> @brief A class for one measurement

classdef Measurement

    properties
        %>file name and path
        file
        %> the average pressure durning the measurement [Pa]
        pressure
        %> % outside temperature in [K]
        temperature
        %> The density [kg/m^3]
        rho
        %> Type of the waveform file
        waveform
        %> rate of sampling, always should be 1000 Hz. Currently unused, should
        %> be 1000 Hz
        samplerate
        %> length of sampling
        sampletime
        % name of the measurement
        name
        % A list of the various measurements on the pressure taps we made during
        measurements
    end

    methods
        %====================================================
        %> @brief Class constructor
        %>
        %> The constructor takes the name of the corresponding measurement,
        %> and fills up the necessary fields.
        %>
        %>@param infile_name The input filename
        %>
        %>@return an instance of the Measurement class
        function obj = Measurement(infile_name)
            %MEASUREMENT Construct an instance of Measurement
            %   Uses the filename and loads data from that
            obj.file = infile_name;
            fileID = fopen(infile_name);
            for linenum=1:22
                line = fgetl(fileID);
                if linenum==4
                    split= strsplit(line,'\t');
                    obj.name = split{2};
                elseif linenum==5
                    split = strsplit(line,'\t');
                    obj.pressure = str2double(split{2});
                    if obj.pressure == 0.0
                        obj.pressure = 101325.0;
                        %1 atm if there was no input pressure specified
                    end
                elseif linenum == 6
                    split = strsplit(line,'\t');
                    obj.temperature = str2double(split{2});
                    if obj.temperature == 0.0
                        obj.temperature = 20.0;
                        %Set temperature to 20°C
                    end
                    if obj.temperature < 100
                        obj.temperature = obj.temperature+273.15;
                        %Change it to K if it is most likely in Celsius
                    end
                elseif linenum == 14
                    split = strsplit(line,'\t');
                    obj.samplerate = str2double(split{2});
                elseif linenum == 15
                    split = strsplit(line,'\t');
                    obj.sampletime = str2double(split{2});
                elseif linenum ==17
                    split = strsplit(line,'\t');
                    obj.waveform = split{2};
                end
            end
            % loads the header of the measurement file and extracts the
            % necesary values
            load constants.mat R
            obj.rho = obj.pressure/(R*obj.temperature);
            fclose(fileID);
            % Read the important parts of the header
            % Reading the rest
            fileID = fopen(infile_name,'rt');
            raw_data = textscan(fileID,'%d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %d %s','headerlines',22,'Collectoutput',true,'EmptyValue',NaN,'Delimiter','\t');
            fclose(fileID);
            meas_counter = 0;
            %all data loaded is in the raw_data
            for i=1:length(raw_data{1})
                num = raw_data{1}(i,1);
                if num > 0
                    meas_counter = meas_counter+1;
                    p0 = raw_data{2}(i,7);
                    p0_RMS = raw_data{2}(i,8);
                    p_mean = raw_data{2}(i,9);
                    p_RMS = raw_data{2}(i,10);
                    filepath = raw_data{4}{i};
                    filepath = strsplit(filepath,'\');
                    filename = filepath{end};
                    meas_path_split = strsplit(obj.file,'/');
                    meas_path_split{end} = strcat('time_series/',filename);
                    filename2 = strjoin(meas_path_split,'/');
                    obj.measurements{meas_counter} = Meas_location(num,p0,p0_RMS,p_mean,p_RMS,filename2);
                end
            end
            for i=1:length(raw_data{1})
                num = raw_data{1}(i,2);
                if num > 0
                    meas_counter = meas_counter+1;
                    p0 = raw_data{2}(i,7);
                    p0_RMS = raw_data{2}(i,8);
                    p_mean = raw_data{2}(i,11);
                    p_RMS = raw_data{2}(i,12);
                    filepath = raw_data{4}{i};
                    filepath = strsplit(filepath,'\');
                    filename = filepath{end};
                    meas_path_split = strsplit(obj.file,'/');
                    meas_path_split{end} = strcat('time_series/',filename);
                    filename2 = strjoin(meas_path_split,'/');
                    obj.measurements{meas_counter} = Meas_location(num,p0,p0_RMS,p_mean,p_RMS,filename2);
                    %Creadet the data of one measurement and added it to
                    %the list.
                end
            end
            %We need the thing organized so I am using bubble sort - no
            %comments, I am too lazy to code anything more efficient for
            %this very low key case.
            for i= length(obj.measurements)-1:-1:1
                for j=1:i
                    if obj.measurements{j}.location()>obj.measurements{j+1}.location()
                        dump = obj.measurements{j};
                        obj.measurements{j} = obj.measurements{j+1};
                        obj.measurements{j+1} = dump;
                    end
                end
            end
            %Should be sorted right now. Order: ascending by location.
        end

        %============================================
        %>@brief List numbers of pressure tappings
        %>
        %>Return the number of pressure taps along the BC measurement,
        %>which naturally means that it is in decreasing order
        %>
        %>@param no parameters needed
        %>@return a matrix of pressure tap numbers
        %============================================
        function list = listnum(obj)
        list = zeros(length(obj.measurements),1);
        for i=1:length(obj.measurements)
            list(i) = obj.measurements{i}.number;
        end
        end

        %============================================
        %>@brief list average pressures in pressure taps
        %>
        %>Lists the average pressure values in the measurement locations
        %>
        %>@param no parameters needed
        %>@return a vector of average pressures in the pressure tap
        %============================================
        function listp = listp(obj)
            listp = zeros(length(obj.measurements),1);
            for i=1:length(obj.measurements)
                listp(i) = obj.measurements{i}.p_mean;
            end
        end

        %============================================
        %>@brief list average pressures in the intake
        %>
        %>Lists the average pressure values at the intake. All values will
        %> appear twice due to the way the data was collected.
        %>
        %>@param no parameters needed
        %>@return a vector of intake pressure values
        %============================================
        function list = listp0(obj)
        list = zeros(length(obj.measurements),1);
        for i=1:length(obj.measurements)
            list(i) = obj.measurements{i}.p0;
        end
        end

        %============================================
        %>@brief list the locations of the pressure taps
        %>
        %>Lists the location of the pressure taps. It is naturally in ascending order.
        %>
        %>@param no parameters needed
        %>@return a vector of distances [m]
        %============================================
        function list = listloc(obj)
        list = zeros(length(obj.measurements),1);
        for i=1:length(obj.measurements)
            list(i) = obj.measurements{i}.location;
        end
        end


        %============================================
        %>@brief List the pressure coefficient
        %>
        %> Non-dimensionalized pressure. Pressure is non-dimensionalised
        %> with the dynamic pressure of the average velocity in the first section
        %> (\f$ p_{din} =\rho/2*v^2 \f$). Then it is moved so that point 329  (the
        %> last one before the Borda-Carnot) is at a cp of zero.
        %>
        %>@param no parameters needed
        %>@return a vector of pressure coefficients
        %============================================
        function list = listcp(obj)
        v_avg = obj.vel();
        p_din = v_avg(1)^2.0*obj.rho*0.5;
        list = zeros(length(obj.measurements),1);
        for i=1:length(obj.measurements)
            list(i) = obj.measurements{i}.p_mean/p_din;
        end
        %Point 329 is at the smallend number
        load constants.mat small_end
        displacement = list(small_end);
        list = -1.0*((-1*displacement)+list());
        end


        %============================================
        %>@brief list the non-dimensional locations of the pressure taps
        %>
        %>Lists the non-dimensional location of the pressure taps.  non
        %>dimensionalised with the size of the Borda-Carnot step.
        %>
        %>@param no parameters needed
        %>@return a vector of non-dimensional distances
        %============================================
        function list = listloc2(obj)
        load constants.mat L_step
        list = zeros(length(obj.measurements),1);
        for i=1:length(obj.measurements)
            list(i) = obj.measurements{i}.location/L_step;
        end
        end

        %============================================
        %>@brief Calculate flow rate
        %>
        %>Calculating the flow rate in the measurement inlet orifice plate.
        %>
        %>@param no parameters needed
        %>@return Flow rate in [m^3/s]
        %============================================
        function q_v = flow(obj)
            load constants.mat D_be epsilon alpha
            deltap = mean(obj.listp0);
            q_v = alpha * epsilon * (D_be^2*pi)/4.0 *sqrt(2/obj.rho*deltap);
        end

        %============================================
        %>@brief Calculate the velocities
        %>
        %>Caclulates the mean velocity in both parts of the measurement setup
        %>
        %>@param
        %>@return Vector of the two velocities
        %============================================
        function v = vel(obj)
            load constants.mat A_small A_big;
            v = [0,0];
            qv = obj.flow();
            v(1) = qv/A_small;
            v(2) = qv/A_big;
        end

        %============================================
        %>@brief Calculate the Reynolds number
        %>
        %>Caclulates the Reynolds number as \f$ Re = \frac{v \cdot D}{\nu} \f$ velocity in both parts of the measurement setup. \f$ \nu \f$ is taken from the constants file.
        %>
        %>@param no parameters needed
        %>@return Vector of the two Reynolds numbers
        %============================================
        function Re = Re(obj)
            load constants.mat D_small D_big nu;
            v = obj.vel();
            Re(1) = v(1)*D_small/nu;
            Re(2) = v(2)*D_big/nu;
        end

        %============================================
        %>@brief Fits a line on the pressure loss of the first section.
        %>
        %>Fits a simple regression on the first part of the length (L)-pressure (p) curve. Fittinig is up to the first 40 ellements (those before the BC), and is done by simple regression. This means that \f$ p = \beta_2 \cdot L + \beta_1 \f$. This is the returned values. Only uses those that have been deemed good in @ref point_keep.
        %>
        %>@param no parameters needed
        %>@return The intercept and slope of the fitted curve.
        %============================================
        function beta = fit_curve(obj)
            load tokeep.mat good %Gets good measurement points.
            locs = obj.listloc();
            locs = locs(good);
            L = ones(length(good),2);
            L(:,2) = locs;
            %Gathered the necessary indices
            deltap = obj.listp();
            deltap = deltap(good);
            beta = L\deltap; %solves the matrix equation.
        end

        %=========================================
        %>@ brief Calculates the loss coefficient of the pipe
        %>
        %>Calculates the loss coefficient of the "tube". Calculated from \t$ \Delta p = \lambda \frac{\rho}{2} v^2 \frac{L}{D} \t$ while taking it into account that \f$ \beta_2 = \frac{\partial p}{\partial L}\f$, which allows for the loss to be calcualted as \f$ \lambda = \frac{2 D \beta_2}{\rho v^2}\f$.
        %@>
        %>@param No parameters needed
        %>@return The loss coefficient of the first part of the tube.
        %============================================
        function lambda = lambda(obj)
            load constants.mat D_small
            beta = obj.fit_curve();
            v = obj.vel();
            lambda = (2*D_small*beta(2))/(obj.rho*v(1)^2.0);
        end
        %===============================================
        %>@brief Calculates the pressure loss coefficient of the second tube part
        %>
        %>Calculates the pressure loss coefficient of the second tube part. The displacement between the Blasius-predicted and the actual \f$ \lambda \f$ is calculated, and assumed constant. After this the Blasius-formula is used to calculate a friction factor at the Reynolds number belonging to the second section of the tube, and then the displacement is reapplied.
        %>
        %>@param None needed
        %>@return The loss coefficient of the second part of the system
        %========================================================
        function lambda2 = lambda2(obj)
            Re = obj.Re();
            lambda1 = obj.lambda();
            Bla1 = Blasius(Re(1));
            lambdadisp = lambda1-Bla1; %Displacement between measured lambda and the Blasius formula
            Bla2 = Blasius(Re(2)); %What Blasisu would say to the second point;
            lambda2 = Bla2+lambdadisp;
        end

        %==============================================
        %>@brief The intercept and slope of the slope fitted on the second part of the system.
        %>
        %>The slope fitted to the second part of the system is calculated
        %>from the \t$ \lambda_2 \t$ function a
        %>
        %>@param No parameters needed
        %>@return The intercept and slope of the second fitted curve
        %==============================================
        function gamma = retrofit_curve(obj)
            gamma = zeros(2,1);
            lambda = obj.lambda2();
            load constants.mat D_big small_end
            % Ehelyett az legyen, h a minimum pont legyen az első
            small_end = small_end+29; %TODO ezt ellenőrizni
            v = obj.vel;
            locs = obj.listloc();
            locs(1:small_end) = [];
            p = obj.listp();
            p(1:small_end) = [];
            %removed the locations before the BC, so that they do not affect the slope.
            gamma(2) =obj.rho()/2.0 * v(2)^2.0 * lambda * 1.0/D_big; %recalculates the slope
            order0 = ones(length(locs),1); %multiplicator of gamma2
            gamma(1) = order0\(p-locs*gamma(2));
        end

        %================================================
        %>@brief The theoretical pressure loss in the BC
        %>
        %>The theoretical pressure loss in the Borda Carnot, calculated
        %>from the upstream and downstream velocities as
        %> \t$ \Delta p =\frac{\rho}{2} \left(v_1 -v_2 \right)^2
        %>@param No parameters needed
        %>@return The loss in the BC.
        %=========================================================
        function dp = BCloss_theor(obj)
            v = obj.vel();
            dp = obj.rho/2.0*(v(1)-v(2))^2.0;
        end

        %================================================
        %>@brief The theoretical pressure loss in the BC
        %>
        %>The theoretical pressure loss in the Borda Carnot, calculated
        %>from the upstream and downstream velocities as
        %> \t$ \Delta p =\frac{\rho}{2} \left(v_1 -v_2 \right)^2
        %>@param
        %>@return The pressure loss in the BC, gained by extraplating the pressures.
        %=========================================================
        function dp = BCloss_real(obj)
            beta = obj.fit_curve();
            gamma = obj.retrofit_curve();
            load constants.mat dist_BC
            p1 = beta(1)+beta(2)*dist_BC;
            p2 = gamma(1)+gamma(2)*dist_BC;
            dp = p1-p2;
        end
    end
end
