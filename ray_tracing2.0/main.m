
%--------------------------------------------------------------------------
%  version: 2.0 add Doppler for dynamic scenario
%  data: 25/04/2024
%  parameters.m is the list of parameters
%  generate.m is to generate CSI and corrosponding locations
%  references: 
%  [1] DeepMIMO
%  [2] 5G-NR-data-generato-main 
%--------------------------------------------------------------------------

clc; clear;

for speed = 0:5:30 

    run("parameters.m");

    %% call map
    
    % -------------------------------
    if exist('viewer','var') && isvalid(viewer) 
        viewer.clearMap();
    else
        viewer = siteviewer("Basemap","openstreetmap","Buildings",mapfile); 
    end
    % -------------------------------
    
    BS = txsite("Latitude",BS_loc(1),"Longitude",BS_loc(2),...
        "AntennaAngle",Tx_rotation,"AntennaHeight",BS_height,...  
        "TransmitterFrequency",f);
    
    %% save data
    
    run("generate.m");
    data.CSI = single(H);
    label = [location(:,1:2), vr];
    data.label = label;
    filename = "v"+num2str(speed)+".mat";
    save(filename,'data');

end
disp("Data saved successfully!");




