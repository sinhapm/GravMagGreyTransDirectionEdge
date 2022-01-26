function [filename, pathname,indx]= func_openinputfile()
    try
    %% Input the Multiple or One Segy file/s
    disp('------------------------------------------------------------------------------');
    disp("Open & Read the ASCII Input File...");
    
    [filename, pathname,indx] = uigetfile({'*.txt';'*.*'},...
        'Select an ASCII file: ','MultiSelect', 'off');
    
    disp(strcat("Selected File: ", num2str(filename)));
    
    disp('------------------------------------------------------------------------------');
    catch
        filename='';
        pathname='';
        indx=0;
        disp('!Error while opening the file.');
    end
    
end