function xys = TrajectoryData()
    % Prompt user to select an Excel file
    xlsfile = uigetfile({'*.xlsx;*.xls','Excel Files (*.xlsx,*.xls)'},'Select Cell Trajectory File');

    % Extract file extension
    [~, ~, ext] = fileparts(xlsfile);
    
    % Read data based on file extension
    switch lower(ext)
        case {'.xlsx', '.xls'}
            num = xlsread(xlsfile); 
        otherwise
            error('Incorrect file format!');
    end

    % Identify unique cell IDs
    ui = unique(num(:,1));
    % Calculate length of each trajectory
    tlength = arrayfun(@(k) sum(num(:,1) == k), ui);
    % Determine minimum trajectory length
    Nmin = min(tlength);
    % Initialize cell array to store trajectory data
    xys = cell(size(ui));

    % Extract and store trajectory data for each cell ID
    for k = 1:length(ui)     
        col = num(:,1) == ui(k);    
        xytemp = num(col,1:end);
        % Sort trajectory data based on time
        [~, sid] = sort(xytemp(:,2),'ascend'); 
        xytemp = xytemp(sid,3:end);
        % Trim trajectory data to match minimum length
        xytemp = xytemp(1:Nmin,:);
        % Store trajectory data in cell array
        xys{k} = xytemp;   
    end
end