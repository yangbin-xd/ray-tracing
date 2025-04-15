
% list of parameters
format long

%% system parameter setting

f = 28*1e9;                                % frequency 3.4 GHz
c = physconst('LightSpeed');                % c 299,792,458 m/s
lambda = c/f;                               % wavelength
Nc = 624;                                   % subcarriers
B = 60*1e9;                               % bandwidth 50 MHz
Ts = 1/B;                                   % duration 20 ns
mapfile = "dji.osm";                        % map file
MaxNumReflections = 2;                     % maximun reflections number

%% BS parameter setting        
        
BS_loc = [22.5818, 113.9379];              % BS location
BS_height = 10;                             % BS height 10 m
BS_Tx = [32, 1];                             % BS antenna shape
Tx_num = prod(BS_Tx);                       % BS antenna number
Tx_rotation = [0 0]';                       % BS antenna rotation
Tx_ant_spacing = 0.5;                % BS antenna spacing

%% UE parameter setting

UE_num = 1000;                               % UE number
UE_in_row = 50;                              % UE number in row
UE_in_col = ceil(UE_num/UE_in_row);         % UE number in column
row_space = 5;                            % UE distance in row
col_space = 5;                            % UE distance in column
UE_height = 100;                              % UE height 1.5 m
UE_Rx = [1, 1];                             % UE antenna shape
Rx_num = prod(UE_Rx);                       % UE antenna number
Rx_rotation = [0 0]';                       % UE antenna rotation
Rx_ant_spacing = 0.5;                % UE antenna spacing
lat1 = 22.5809;                             % UE range in latitude
lont1 = 113.9369;                           % UE range in longitude

R = 6371e3;                                 % Earth radius 6371 km
lat2meter = 360/(2*pi*R);                   % lat2meter = 1 m
lont2meter = 360/(2*pi*R*cosd(BS_loc(1)));  % lont2meter = 1 m

lat = lat1:lat2meter*col_space:lat1+lat2meter*col_space*(UE_in_col-1);
lont = lont1:lont2meter*row_space:lont1+lont2meter*row_space*(UE_in_row-1);

UE_loc = zeros(UE_num, 2);                  % UE location
location = zeros(UE_num, 3);                % UE relative location

% generate UE locations by loops
for i = 1 : UE_num
    decimal = i/UE_in_row - floor(i/UE_in_row);
    i_x = floor(i/UE_in_row) + ceil(decimal);
    i_y = i - i_x*UE_in_row + UE_in_row;
    i_z = 0;
    UE_loc(i,:) = [lat(i_x), lont(i_y)];
    location(i,:) = [(i_y - 1)*col_space, (i_x - 1)*row_space, i_z];
end



