
% generate CSI
Ns = 140;
H = zeros(UE_num, Rx_num, Tx_num, 12, Ns);
vr = zeros(UE_num, 1);
pm = propagationModel("raytracing");
pm.AngularSeparation = "low";
pm.MaxNumReflections = MaxNumReflections;

tic
count = 0;    % backspace for display

for j = 1 : UE_num
    UE = rxsite("Latitude",UE_loc(j,1), "Longitude",UE_loc(j,2),...   
        "AntennaHeight",UE_height, "AntennaAngle",Rx_rotation);
        rays = raytrace(BS, UE, pm);
       
% -------------------------------
    show(UE);
    show(BS);
    plot(rays{1});
    if (j ~= UE_num)
        viewer.clearMap();
    end
% -------------------------------

    x = BS_Tx(1); y = BS_Tx(2);
    Tx_ind = [zeros(1, x*y)', ...
              repmat(reshape(repmat(0:1:x-1,1,1), 1, x), 1, y)', ...
              reshape(repmat(0:1:y-1,x,1), 1, x*y)'];
    x = UE_Rx(1); y = UE_Rx(2);
    Rx_ind = [zeros(1, x*y)', ...
              repmat(reshape(repmat(0:1:x-1,1,1), 1, x), 1, y)', ...
              reshape(repmat(0:1:y-1,x,1), 1, x*y)'];
    
    pathAoDs = [rays{1}.AngleOfDeparture];       % AoD of each ray
    pathAoAs = [rays{1}.AngleOfArrival];         % AoA of each ray
    DoD_theta = pathAoDs(1,:);
    DoD_phi = 90-pathAoDs(2,:);  
    DoA_theta = pathAoAs(1,:);
    DoA_phi = 90-pathAoAs(2,:); 
    
    % TX Array Response
    gamma_TX = +1j*2*pi*Tx_ant_spacing*[sind(DoD_phi).*cosd(DoD_theta);
               sind(DoD_phi).*sind(DoD_theta); cosd(DoD_phi)];
    Tx_response = exp(Tx_ind*gamma_TX);
    
    % RX Array Response
    gamma_RX = +1j*2*pi*Rx_ant_spacing*[sind(DoA_phi).*cosd(DoA_theta);
                sind(DoA_phi).*sind(DoA_theta); cosd(DoA_phi)];
    Rx_response = exp(Rx_ind*gamma_RX);
    
    [m,n] = size(rays{1});
    phase = zeros(1,n);
    ToAs = zeros(1,n);
    power_dB = zeros(1,n);
    for k = 1:n
        power_dB(k) = -rays{1}(k).PathLoss;
        ToAs(k) = rays{1}(k).PropagationDelay;
        phase(k) = rays{1}(k).PhaseShift;
    end
    power = 1e-3*(10.^(0.1.*(power_dB + 30)));
    k = (0:1:12-1)';
    path_const = sqrt(power/Nc).*exp(1j*phase).*exp(-1j*2*pi*(k/Nc)*ToAs/Ts);
    
    % Doppler
    v = zeros(1,length(DoA_theta));

    for i = 1:length(DoA_theta)
        v(i) = speed*cosd(90-DoA_phi(i)).*cosd(DoA_theta(i));
    end
    vr(j) = v(1);

    T = 10e-3/140:10e-3/140:10e-3;
    for i = 1:length(T)
        Doppler = exp(1j*2*pi*f*v*T(i)/c);
        path_const_Doppler = path_const.*Doppler;

        channel = sum(reshape(Rx_response, Rx_num, 1, 1, []).* ...
                  reshape(Tx_response, 1, Tx_num, 1, []).* ...
                  reshape(path_const_Doppler, 1, 1, 12, []), 4);
        H(j,:,:,:,i) = channel;
    end

    fprintf(repmat('\b', 1, count));
    count = fprintf("velocity: %d m/s, progress：%d / %d, percent: %.3f%%\n", speed, j, UE_num, j/UE_num*100);
   
end

toc




