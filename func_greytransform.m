function greytrans_seis2d=func_greytransform(datain2d_padded,...
        nxline, ninline, ks, N)

% Grey Level Transformation CODE

% This Function performs the Grey Level Transformation
% Ref Paper: Gray-level transformation and Canny edge detection for 
% 3D seismic discontinuity enhancement, Haibin Di*, Dengliang Gao1
% DOI http://dx.doi.org/10.1190/segam2013-1175.1
% SEG Houston 2013 Annual Meeting

% datain2d_padded = Padded Two Dimensional input data - double e.g. - Seismic TimeSlice
% ks= kernelsize, window 3X3, 5X5 or 7X7 etc. - interger
% nxline = No of XLine - integer
% ninline = No of InLine - integer
% N= Grey Transformation Level (total = 2N+1)
% dataoutput2d = Gaussian Filtered Two Dimesional Output data - double

    % Initilize
    greytrans_seis2d=ones(nxline,ninline);
    
    % Half of Window Size (for 5X5 Window Size - (5-1)/2=2)
    ks_half=(ks-1)/2;
   
    

    for ii=1:nxline
        for jj=1:ninline
            S=datain2d_padded(ii:(ii-1+ks), jj:(jj-1+ks)); % windowed data
            Smax=max(S(:));
            Smin=min(S(:));
            del=0.5/N*(Smax-Smin);
            greyscaled_S=round((S-Smin)/del)-N;
            greytrans_seis2d(ii,jj)=greyscaled_S(ks_half+1,ks_half+1);
        end
    end
    

end
