# 🚨 ray-tracing
This is a ray tracing CSI generation software based on [MATLAB](https://www.mathworks.com/help/comm/ref/rfprop.raytracing.html) and [OpenStreetMap](https://www.openstreetmap.org).  

<p align="center">
  <video
    src="https://github.com/user-attachments/assets/169e95ff-df7c-4f98-a2c9-a7fade229579"
    controls
    muted
    playsinline
    width="200"
    height: auto;"
  >
    Your browser does not support the video tag.
  </video>
</p>

  
<img src='scenario.png' alt='Ray Tracing' width='600'>
The interface and scenario for ray tracing of the software.  

## 🗂️ Introduction
ray_tracing1.0 folder is for static scenarios  
ray_tracing2.0 folder is for dynamic scenarios  
main.py is main function for CSI generation  
parameter.py is to set parameters for the system  
generate.py is to generate CSI  
dji.osm is the map file  

## 🛠️ Please follow the following steps:
__1. Set system parameters in parameters.m file__  
```matlab
%% system parameter setting
f = 3.5*1e9;                                % frequency 3.5 GHz
c = physconst('LightSpeed');                % c 299,792,458 m/s
lambda = c/f;                               % wavelength
Nc = 52*12;                                 % subcarriers
B = 15e3*Nc;                                % bandwidth 50 MHz
Ts = 1/B;                                   % duration 20 ns
mapfile = "dji.osm";                        % map file
MaxNumReflections = 10;                     % maximun reflections number

%% BS parameter setting        
BS_loc = [22.5818, 113.9380];               % BS location
BS_height = 10;                             % BS height 10 m
BS_Tx = [8, 4];                             % BS antenna shape
Tx_num = prod(BS_Tx);                       % BS antenna number
Tx_rotation = [0 0]';                       % BS antenna rotation
Tx_ant_spacing = 0.5;                       % BS antenna spacing

%% UE parameter setting
% yaw = -5:5;                               % yaw angle
UE_num = 231;                               % UE number
UE_in_row = 21;                             % UE number in row
UE_in_col = ceil(UE_num/UE_in_row);         % % UE number in column
row_space = 10;                             % UE distance in row
col_space = 10;                             % UE distance in column
UE_height = 100;                            % UE height 1.5 m
UE_Rx = [1, 1];                             % UE antenna shape
Rx_num = prod(UE_Rx);                       % UE antenna number
Rx_rotation = [0 0]';                       % UE antenna rotation
Rx_ant_spacing = 0.5;                       % UE antenna spacing
lat1 = 22.5809;                             % UE range in latitude
lont1 = 113.9370;                           % UE range in longitude
```

__2. Run main.m file to generate CSI data labeled with locations__  

__3. (Optional) For quick operation without Graphical interface__  
```matlab
% These two sections can be commented out to disable execution.
% ----in generate.m line 18-25---
    show(UE);
    show(BS);
    plot(rays{1});
    if (j ~= UE_num)
        viewer.clearMap();
    end
% -------------------------------

% -----in main.m line 20-26------
    if exist('viewer','var') && isvalid(viewer) 
        viewer.clearMap();
    else
        viewer = siteviewer("Basemap","openstreetmap","Buildings",mapfile); 
    end
% -------------------------------
```


## 📨 Contact
[Bin Yang](https://scholar.google.com/citations?user=_v2KA7UAAAAJ&hl=zh-CN) Email: binyang_2020@163.com  

## 📝 Reference
[1] [DeepMIMO](https://github.com/DeepMIMO/DeepMIMO-matlab)  
[2] [5G-NR-data-generato-main](https://github.com/CodeDwan/5G-NR-data-generato)   
