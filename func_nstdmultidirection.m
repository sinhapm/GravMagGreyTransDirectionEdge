function [NSTD360,NSTD_EW,NSTD_NS,NSTD_NWSE,NSTD_NESW]=...
    func_nstdmultidirection(dx,dy,dz,nrows,nclmns,ws)
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
% NSTD360 = NSTD for all values (360 deg)
% NSTD_EW = NSTD for East West Direction, Lineaments along North South Direction
% NSTD_NS = NSTD for North South Direction, Lineaments along East West Direction
% NSTD_NWSE = NSTD for NW-SE Direction, Lineaments along NE-SW Direction
% NSTD_NESW = NSTD for NE-SW Direction, Lineaments along NW-SE Direction
    
    %% Initilize the out matrix
    NSTD360=zeros(nrows,nclmns);
    NSTD_EW=zeros(nrows,nclmns);
    NSTD_NS=zeros(nrows,nclmns);
    NSTD_NWSE=zeros(nrows,nclmns);
    NSTD_NESW=zeros(nrows,nclmns);
    
    %% Calulate the NSTD for data points
    for ii=1:nrows 
        for jj=1:nclmns
            % Calculate NSTD for all values (360 deg) within Window
             fx360=dx(ii:ii+ws-1,jj:jj+ws-1); stdfx360=std(fx360(:));
             fy360=dy(ii:ii+ws-1,jj:jj+ws-1); stdfy360=std(fy360(:));
             fz360=dz(ii:ii+ws-1,jj:jj+ws-1); stdfz360=std(fz360(:));
             NSTD360(ii,jj)=stdfz360/(stdfx360+stdfy360+stdfz360);
             
             % Calculate NSTD for East West Direction within Window
             % This will be map the lineament along North-South
             % Direction, which is normal to filter direction
             fxEW=dx(ii+(ws-1)/2,jj:jj+ws-1); stdfxEW=std(fxEW(:));
             fyEW=dy(ii+(ws-1)/2,jj:jj+ws-1); stdfyEW=std(fyEW(:));
             fzEW=dz(ii+(ws-1)/2,jj:jj+ws-1); stdfzEW=std(fzEW(:));
             NSTD_EW(ii,jj)=stdfzEW/(stdfxEW+stdfyEW+stdfzEW);
             
             % Calculate NSTD for North South Direction within Window
             % This will be map the lineament along East-West
             % Direction, which is normal to filter direction
             fxNS=dx(ii:ii+ws-1,jj+(ws-1)/2); stdfxNS=std(fxNS(:));
             fyNS=dy(ii:ii+ws-1,jj+(ws-1)/2); stdfyNS=std(fyNS(:));
             fzNS=dz(ii:ii+ws-1,jj+(ws-1)/2); stdfzNS=std(fzNS(:));
             NSTD_NS(ii,jj)=stdfzNS/(stdfxNS+stdfyNS+stdfzNS);
             
             % Calculate NSTD (Check the Direction of Input Data) for 
             % NW-SE Direction within Window, This will be map the 
             % lineament along NE-SW Direction, which is normal to 
             % filter direction
             fxNWSE=diag(flipud(dx(ii:ii+ws-1,jj:jj+ws-1))); stdfxNWSE=std(fxNWSE(:));
             fyNWSE=diag(flipud(dy(ii:ii+ws-1,jj:jj+ws-1))); stdfyNWSE=std(fyNWSE(:));
             fzNWSE=diag(flipud(dz(ii:ii+ws-1,jj:jj+ws-1))); stdfzNWSE=std(fzNWSE(:));
             NSTD_NWSE(ii,jj)=stdfzNWSE/(stdfxNWSE+stdfyNWSE+stdfzNWSE);
             
             % Calculate NSTD (Check the Direction of Input Data) for 
             % NE-SW Direction within Window, This will be map the 
             % lineament along NW-SE Direction, which is normal to 
             % filter direction
             fxNESW=diag(dx(ii:ii+ws-1,jj:jj+ws-1)); stdfxNESW=std(fxNESW(:));
             fyNESW=diag(dy(ii:ii+ws-1,jj:jj+ws-1)); stdfyNESW=std(fyNESW(:));
             fzNESW=diag(dz(ii:ii+ws-1,jj:jj+ws-1)); stdfzNESW=std(fzNESW(:));
             NSTD_NESW(ii,jj)=stdfzNESW/(stdfxNESW+stdfyNESW+stdfzNESW);
             
        end
    end
    

end