% #########################################################################
% The Program calculates the directional Normalized Standard Deviations 
% (NSTD) for Edge Detection using Grey Level Transformation
% #########################################################################
% Reference Papers

% Ref Paper1: Gray-level transformation and Canny edge detection for 
% 3D seismic discontinuity enhancement, Haibin Di*, Dengliang Gao1
% DOI http://dx.doi.org/10.1190/segam2013-1175.1
% SEG Houston 2013 Annual Meeting

% Ref Paper2: Edge enhancement of potential-field data using  
% normalized statistics, Gordon R. J. Cooper and Duncan R. Cowan
% GEOPHYSICS, VOL. 73, NO. 3 MAY-JUNE 2008; P. H1–H4
% (A part of the published code is modifed and used in the script).

% #########################################################################
% INPUT
% This is the initial program to read the value from Petrel output
% Irap spreadsheet
% datain  = matrix of data for processing

% Input File Format (X Y Z) - XY in Ascending Order top to bottom
% Direction of Input Data: 1. West to East: Left to Right, 
% 2. South to North: Top to Bottom

% Input File can be Regular spaced Rectangular/Square Grid Points or may be 
% Regular spaced Oblique Grid Points, which is padded with nearest outer 
% points to make it Regular spaced Rectangular Grid Points 

% Input Format :
% 3400	600 	-38
% 4300	600     -37
% 5200	600     -36
% 700	1500	-39
% 1600	1500	-39
% 2500	1500	-39
% 3400	1500	-38
% 4300	1500	-38
% 5200	1500	-37

% ws = Size of Filtering Window (odd numbers only, default minimum is 3)
% sm = size of Smoothing window (odd numbers only)
%      zero or negative values apply no smoothing
% N = Grey Transformation Level (total = 2N+1), only Postive value
% multidirection_flag=Y/N or Yes/No

% *************************************************************************
% OUTPUTS Format: Petrel Points with Attribute File or Columner Text File 
% NSTD360 = NSTD for all values (360 deg) within Window

% Additional output if multidirection_flag = Y or Yes
% NSTD_EW = Filtered NSTD for East West Direction within Window, 
%           Edge/Lineament Enhancement along North South Direction
% NSTD_NS = Filtered NSTD for North South Direction within Window,
%           Edge/Lineament Enhancement along East West Direction
% NSTD_NWSE = Filtered NSTD for NW-SE Direction within Window,
%           Edge/Lineament Enhancement along NE-SW Direction
% NSTD_NESW = Filtered NSTD for NE-SW Direction within Window,
%           Edge/Lineament Enhancement along NW-SE Direction

% #########################################################################

% Author: Prashant M. Sinha, sinha.pm@gmail.com, 2021

%% Program Information Display on Console Window
clear;
clc;

%% Read the Input Ascii File 
% Input Data sholud be colunmer type (Easting Northing Data_Value)
[filename, pathname,nfile]= func_openinputfile();
if nfile==0
    disp("!No file selected, quitting program.");
    clear;
else
    
    datain=load(strcat(pathname, filename));
    
    %% Calculate for the Number of Rows & Colums and assign Easting & Northing
    % Make a Rectangular Grid padded with zeros
    [datain_2d,Easting,Northing,nrows,nclmns,TF,x,y]=func_rowscolumnFormatting(datain);
    
    %% Initialize the variable and ask for necessary inputs
    run_flag="Y";
    while run_flag=="Y"

        answer=func_inputparametrs();
        
        if ~isempty(answer)
            
            ws=abs(str2double(answer{1,1})); % Filter Window Size
            sw=abs(str2double(answer{2,1})); % Filter Window Size
            N=abs(str2double(answer{3,1}));
            multidirection_flag=answer{4,1};
            
            if upper(multidirection_flag)=='Y'
                multidirection_flag="Yes";
                
            elseif upper(multidirection_flag)=="YES"
                multidirection_flag="Yes";
            else
                multidirection_flag="No";
            end
            % Set the Value of Input Window Size to odd number
            ws=floor(ws/2)*2+1;
            if ws<3
                ws=3;
            end

            if N<0
                N=-1*N;
            end
            
            % Set the Value of Input Smoothing Window Size to odd number
            sw=floor(sw/2)*2+1;
            
            disp(strcat("Input Parameters: Window Size=",num2str(ws),...
                ", Smoothing Window=", num2str(sw),...
                ", Grey Level=",num2str(N),...
                ", Directional Filtering=",num2str(multidirection_flag)));
            disp("Please Wait...");
            
            %% Padding of the 2D Matrix
            datain_2d_padded = func_2Dmatrixpadding(datain_2d,ws);
            
            %% Gray Level Transformation
            datain_2d_glt=func_greytransform(datain_2d_padded,...
                nrows,nclmns, ws, N); 
            
            %% Smooth the Input Data      

            if sw>=3
                %disp("Smoothing the Input values...");
                se=ones(sw)/(sw*sw);
                datain_2dsmooth=conv2(datain_2d,se,'same');
                datain_2d_glt=conv2(datain_2d_glt,se,'same');
                clear se;
                
            else
                sw=0;
                datain_2dsmooth=datain_2d;
            end
            
            %% Data Padding
            datain_2d_glt = func_2Dmatrixpadding(datain_2d_glt,ws);

            %% Calculate & call the Function for Horizontal & 1st Vertical Derivative
            [dx_glt,dy_glt]=gradient(datain_2d_glt); % Horizontal Derivative
            dz_glt=func_verticalderivation(datain_2d_glt);% First Vertical Derivative
            
            %% Caculate the Directional Normalized Standard Devation Edge
            if multidirection_flag=="Yes"
                [NSTD360_glt,NSTD_EW_glt,NSTD_NS_glt,NSTD_NWSE_glt,NSTD_NESW_glt]=...
                    func_nstdmultidirection(dx_glt,dy_glt,dz_glt,nrows,nclmns,ws);
            else
                [NSTD360_glt]=...
                    func_nstd(dx_glt,dy_glt,dz_glt,nrows,nclmns,ws);                
            end
            
            %% Dispaly Results 
            colourtype='jet';
            [X,Y]=meshgrid(x,y);
            figurename = strcat(filename,": [ WS: ",num2str(ws),...
                ", SW: ", num2str(sw)," ]");
            
            t1=strcat("InputData - SW=",num2str(sw));
            
            t2=strcat("Output(Filter: All Direction)- WS=",num2str(ws),...
                ", SW= ", num2str(sw));
            [ax1]=func_subplot1x2(figurename,X,Y,datain_2d,NSTD360_glt,...
                t1,t2,colourtype);
            
            if multidirection_flag=="Yes"
                t2=strcat("Output(Filter:EastWest)- WS=",num2str(ws),...
                    ", SW= ", num2str(sw));
                
                [ax2]=func_subplot1x2(figurename,X,Y,datain_2d,NSTD_EW_glt,...
                    t1,t2,colourtype);   
                
                t2=strcat("Output(Filter:NorthSouth)- WS=",num2str(ws),...
                    ", SW= ", num2str(sw));
                
                [ax3]=func_subplot1x2(figurename,X,Y,datain_2d,NSTD_NS_glt,...
                    t1,t2,colourtype);
                
                
                t2=strcat("Output(Filter: NW-SE)- WS=",num2str(ws),...
                    ", SW= ", num2str(sw));
                
                [ax4]=func_subplot1x2(figurename,X,Y,datain_2d,NSTD_NWSE_glt,...
                    t1,t2,colourtype);
                
                t2=strcat("Output(Filter: NE-SW)- WS=",num2str(ws),...
                    ", SW= ", num2str(sw));
                
                [ax5]=func_subplot1x2(figurename,X,Y,datain_2d,NSTD_NESW_glt,...
                    t1,t2,colourtype);
            end
            linkaxes([ax1 ax2 ax3 ax4 ax5],'xy');
            
            questanswer = questdlg('Do you want to re-run the process to change the Input Parameters?', ...
                'Input Parameters Change', ...
                'Yes','No','No');
            
            switch questanswer
                case 'Yes'
                    run_flag = "Y";
                case 'No'
                    run_flag = 'n';
                    
                case ''
                    run_flag = 'n';
            end
            
        else
                        
            questanswer = questdlg('Would you like to continue or terminate the program?', ...
                'Run Confimation', ...
                'Re-Enter Input Parameters','Terminate Program','Re-Enter Input Parameters');
            
            switch questanswer
                case 'Re-Enter Input Parameters'
                    run_flag = "Y"; 
                case 'Terminate Program'
                    disp("!Parameters Input Cancelled...");
                    run_flag = 'n'; 
                case ''
                    disp("!Parameters Input Cancelled...");
                    run_flag = 'n';
            end

        end % if isempty(answer)=="False"
    end % while run_flag end
        
    %% Writing the output into a text file
    if ~isempty(answer) %Statement 2
        disp('------------------------------------------------------------------------------');
        prompt = "Do you want to write the output(last run only) in the file (y/n) : ";
        write_flag = upper(input(prompt, 's'));
        if write_flag=="Y"
            disp('Please wait...');
            disp('Writing output into the file:');
            [filename,pathname, filterindex] = uiputfile(...
                {'*.txt;', 'Petrel Points with Attributes (*.txt)';...
                '*.txt;','Columner Text File (*.txt)'},...
                'Save File:',...
                strcat('NSTDWS',num2str(ws),'SW',num2str(sw),'L',num2str(N),'_',filename));

            if isequal(filename,0) || isequal(pathname,0)
                disp('File Saving Cancelled.')
            else
                fileout=strcat(pathname, filename);
                disp(fileout);

                %this opens and writes the output matrix in a ASCII file with a single data column with depths
                fid=fopen(fileout,'w');
                if filterindex==1
                    line1 = '# Petrel Points with attributes';
                    line2 = '# Unit in X and Y direction: m';
                    line3 = '# Unit in depth: m';
                    fprintf(fid,'%s\n%s\n%s\n',line1,line2,line3);
                    fprintf(fid,'%s\n',"VERSION 1");
                    fprintf(fid,'%s\n',"BEGIN HEADER");
                    fprintf(fid,'%s\n',"X");
                    fprintf(fid,'%s\n',"Y");
                    fprintf(fid,'%s\n',"Z");
                end
                
                if multidirection_flag=="Yes"
                    if filterindex==1
                        fprintf(fid,'%s\n',"FLOAT,NSTDGL360");
                        fprintf(fid,'%s\n',"FLOAT,NSTDGL_EW");
                        fprintf(fid,'%s\n',"FLOAT,NSTDGL_NS");
                        fprintf(fid,'%s\n',"FLOAT,NSTDGL_NWSE");
                        fprintf(fid,'%s\n',"FLOAT,NSTDGL_NESW");
                        fprintf(fid,'%s\n',"END HEADER");
                    else
                        fprintf(fid,'%7s\t%8s\t%17s\t%9s\t%9s\t%9s\t%11s\t%11s\n',...
                            'Easting','Northing','InputData(smooth)',...
                            'NSTDGL360','NSTDGL_EW','NSTDGL_NS','NSTDGL_NWSE','NSTDGL_NESW');
                    end
                else
                    if filterindex==1
                        fprintf(fid,'%s\n',"FLOAT,NSTDGL360");
                        fprintf(fid,'%s\n',"END HEADER");
                    else
                        fprintf(fid,'%7s\t%8s\t%17s\t%9s\n',...
                            'Easting','Northing','InputData(smooth)',...
                            'NSTDGL360');
                    end
                end
                
                cnt=1;
                for ii=1:nrows
                    for jj=1:nclmns
                        if TF(ii,jj)==0

                        if multidirection_flag=="Yes"
                            fprintf(fid,'%10.2f\t%10.2f\t%7.5f\t%7.5f\t%7.5f\t%7.5f\t%7.5f\t%7.5f\n',...
                                Easting(cnt),Northing(cnt),datain_2dsmooth(ii,jj),...
                                NSTD360_glt(ii,jj),NSTD_EW_glt(ii,jj),...
                                NSTD_NS_glt(ii,jj),NSTD_NWSE_glt(ii,jj),...
                                NSTD_NESW_glt(ii,jj));
                        else
                            fprintf(fid,'%10.2f\t%10.2f\t%7.5f\t%7.5f\n',...
                                Easting(cnt),Northing(cnt),datain_2dsmooth(ii,jj),...
                                NSTD360_glt(ii,jj));

                        end
                            cnt=cnt+1;
                        end
                    end
                end
                fclose(fid);

                disp('Completed.');
                disp('------------------------------------------------------------------------------');
            end
        end % if write_flag=="Y"
    end % if isempty(answer)=="False" %Statement 2
end % if total_files==0