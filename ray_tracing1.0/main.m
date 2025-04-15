
%--------------------------------------------------------------------------
%  version: 1.0 for static scenario
%  data: 25/04/2023
%  parameters.m is the list of parameters
%  generate.m is to generate CSI and corrosponding locations
%  references: 
%  [1] DeepMIMO
%  [2] 5G-NR-data-generato-main 
%--------------------------------------------------------------------------

clc; clear;
run("parameters.m");

%% call map

% -----------------------------------
if exist('viewer','var') && isvalid(viewer) 
    viewer.clearMap();
else
    viewer = siteviewer("Basemap","openstreetmap","Buildings",mapfile); 
end
% -----------------------------------

BS = txsite("Latitude",BS_loc(1),"Longitude",BS_loc(2),...
    "AntennaAngle",Tx_rotation,"AntennaHeight",BS_height,...  
    "TransmitterFrequency",f);

%% save data

run("generate.m");
real = real(H);
imag = imag(H);
CSI = zeros(UE_num, Rx_num, Tx_num, 12, 2);
CSI(:,:,:,:,1) = real;
CSI(:,:,:,:,2) = imag;
data.CSI = CSI;
data.loc = location;
% filename = "f"+num2str(f/1e9)+"_Nc"+num2str(Nc)+"_UE"+num2str(UE_num)+".mat";
% save(filename,'data');
save('data.mat','data')
disp("Data saved successfully!");









