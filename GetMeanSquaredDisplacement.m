function msd = GetMeanSquaredDisplacement()
% GetMeanSquaredDisplacement2: Calculate mean squared displacement (MSD).

clc;            % Clear command window
clear all;      % Clear all variables from workspace

% Get trajectory data if not provided
xys = TrajectoryData(); % Assumes TrajectoryData() returns trajectory data

% Main program
Nc = length(xys);       % Number of trajectories
msd = cell(Nc, 1);      % Initialize cell array to store MSD for each trajectory
meanMSD = zeros(1, size(xys{1}, 1) - 1); % Initialize array for mean MSD

for k = 1:Nc
    xy = xys{k};                        % Get trajectory data for current trajectory
    [fn, ~] = size(xy);                 % Number of frames in the trajectory
    msdr = zeros(fn - 1, 1);            % Initialize array for MSD at different time lags

    for dt = 1:(fn - 1)                 % Loop through different time lags
        dxy = xy(1 + dt:end, :) - xy(1:end - dt, :); % Calculate displacement
        msdr(dt) = mean(sum(dxy.^2, 2)); % Compute mean squared displacement
    end

    msd{k} = msdr;                      % Store MSD for current trajectory
    meanMSD = meanMSD + msdr';           % Accumulate MSD for ensemble average
end

meanMSD = meanMSD / Nc;                 % Compute ensemble average MSD
ti = (1:length(meanMSD))';             % Time indices for plotting

% Plot ensemble average MSD
loglog(ti, meanMSD, 'bo');             % Plot MSD with blue circles
xlim([1, 1e3]);                         % Set x-axis limits
set(gca, 'xtick', 10.^[0:3]);          % Set x-axis ticks
ylim([1, 1e5]);                         % Set y-axis limits
set(gca, 'ytick', 10.^[0:5]);          % Set y-axis ticks
hold on;

ti                                   % Display time indices
meanMSD'                               % Display ensemble average MSD

if nargout==0
    clear                           % Clear variables from workspace if no output is requested
end
end