function dataoutput2d = func_2Dmatrixpadding(datain2d,ws)

% Matrix Padding (Own Values)- CODE 

% This Function pad the 2D matrix with its own same values of top & bottom
% and pad the left & right column with its own values.

% datain2d = Two Dimensional input data - double 
% ws= kernelsize, window 3X3, 5X5 or 7X7 etc. - interger
% nxline = No of XLine - integer
% ninline = No of InLine - integer
% dataoutput2d = Gaussian Filtered Two Dimesional Output data - double
    
    % Half of Window Size (for 5X5 Window Size - (5-1)/2=2)
    ws_half=(ws-1)/2;
    
    % Intilizing
    timeslice_temp=datain2d;
    
    % Size of Input Data Matrix 
    [nrows, ncolumns]=size(datain2d);
    
    % First Padding the Top & Bottom Rows
    clmn_pad_top=datain2d(1,:);
    clmn_pad_bottom=datain2d(nrows,:);
    
    for ii=1:ws_half
        dataoutput2d=[clmn_pad_top;timeslice_temp;clmn_pad_bottom];
        timeslice_temp=dataoutput2d;
    end
    
    % Padding the Left & Right Columns
    rows_pad_left=timeslice_temp(:,1);
    rows_pad_right=timeslice_temp(:,ncolumns);
    
    for ii=1:ws_half
        dataoutput2d=[rows_pad_left timeslice_temp rows_pad_right];
        timeslice_temp=dataoutput2d;
    end
    
end
