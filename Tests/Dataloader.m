fileID = fopen('../Adatok/BC alap/10Hz/3sec_jobb/180925_BC_alap_10Hz_3sec_jobb.txt','r');
data = textscan(fileID,'%d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %d %s','headerlines',22,'Collectoutput',true,'EmptyValue',NaN,'Delimiter','\t');
fclose(fileID);

measloc = zeros(length(data{1}),1);

for i=1:length(data{1})
    measloc(i) = data{1}(i,1);
end


fileID = fopen('../Adatok/BC alap/10Hz/3sec_bal/180925_BC_alap.txt','r');
tline = fgetl(fileID);
fclose(fileID);
