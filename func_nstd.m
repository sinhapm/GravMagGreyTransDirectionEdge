function [NSTD360]=...
    func_nstd(dx,dy,dz,nrows,nclmns,ws)
% Calculate the normalized standard deviations NSTD for Edge Detection
% Direction of Input Data: 1. West to East: Left to Right, 
% 2. South to North: Top to Bottom 

% dx = Deravitive along X-direction
% dy = Deravitive along Y-direction
% dz = Derivative along Z-direction
% nrows = Number of Rows of Input 2D Matrix - Before Padding
% nclmns = Number of Columns of Input 2D Matrix - Before Padding
% ws = Window Size for Moving Average

% OUTPUT
% NSTD360 = NSTD for all values (360 deg) within Window
    
    %% Initilize the out matrix
    NSTD360=zeros(nrows,nclmns);
    
    %% Calulate the NSTD for data points
    for ii=1:nrows 
        for jj=1:nclmns
            % Calculate NSTD for all values (360 deg) within Window
             fx360=dx(ii:ii+ws-1,jj:jj+ws-1); stdfx360=std(fx360(:));
             fy360=dy(ii:ii+ws-1,jj:jj+ws-1); stdfy360=std(fy360(:));
             fz360=dz(ii:ii+ws-1,jj:jj+ws-1); stdfz360=std(fz360(:));
             NSTD360(ii,jj)=stdfz360/(stdfx360+stdfy360+stdfz360);          
        end
    end
    

end