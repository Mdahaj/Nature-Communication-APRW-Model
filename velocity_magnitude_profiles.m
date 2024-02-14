function V_M_P = velocity_magnitude_profiles()
% Calculate velocity magnitude profiles.

clc;            
clear all;      

% Default parameters
tlag = 1;       % Frame lag for calculating velocity
bins = 25;      % Number of bins for evaluating velocity polarity profile

% Retrieve trajectory data
xys = TrajectoryData(); 

% Main program
dR = [];   
theta = []; 
for k = 1:length(xys)
    xy = xys{k};                                % Get trajectory data
    dxy=xy(1+tlag:end,1:2)-xy(1:end-tlag,1:2);% Calculate displacement
    xyr = [xy(:,1)-mean(xy(:,1)), xy(:,2)-mean(xy(:,2))]; 
    [~, ~, rm] = svd(dxy);                      % Singular value decomposition
    dxyr = dxy * rm;                            % Rotate the displacement vectors
    [thr, ~] = cart2pol(dxyr(:,1), dxyr(:,2));  % Convert to polar coordinates
    thr = mod(thr/pi*180, 360);                
    dR = [dR; dxyr];                            
    theta = [theta, thr(:)];                    
end

[ang, rho] = cart2pol(dR(:,1), dR(:,2));        % Convert displacement to polar coordinates
angp = linspace(-pi, pi, bins);                 % Generate bins for angles
angstep = (angp(2:end) + angp(1:end-1)) / 2;    % Calculate midpoint of bins
V_M_P = zeros(length(angstep), 2);             
for kaa = 1:length(angp)-1
    cc = ang >= angp(kaa) & ang < angp(kaa+1); 
    V_M_P(kaa,:) = [angstep(kaa), mean(rho(cc))]; % Compute mean displacement magnitude for each bin
end

% Normalize dR
dRnx = V_M_P(:,2) .* cos(V_M_P(:,1)) / max(V_M_P(:,2)); 
dRny = V_M_P(:,2) .* sin(V_M_P(:,1)) / max(V_M_P(:,2)); 

plot(dRnx, dRny, 'bo');          
axis equal;                        
xlim([-1.5, 1.5]);                  
ylim([-1.5, 1.5]);                  

an=[dRnx,dRny];

an

if nargout==0
    clear                          
end
end
