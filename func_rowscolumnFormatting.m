function [data,Easting,Northing,nrows,ncolumns,TF,x,y]=func_rowscolumnFormatting(datain)

%     figure; plot(datain(:,1),datain(:,2),'r*'); grid on;
    file_rows_length=length(datain(:,1));
    
    xmin=min(datain(:,1));
    xmax=max(datain(:,1));
    ymin=min(datain(:,2));
    ymax=max(datain(:,2));
    
    delx=0; dely=0;
    
    for ii=1:file_rows_length-1
       if datain(ii,1)~=datain(ii+1,1)
           delx=datain(ii+1,1)-datain(ii,1);
           break;
       end
    end
    
    for ii=1:file_rows_length-1
       if datain(ii,2)~=datain(ii+1,2)
           dely=datain(ii+1,2)-datain(ii,2);
           break;
       end
    end
    
    
    x= xmin:delx:xmax; % Regular Easting X values - for surface grid figure display
    y= ymin:dely:ymax;  % Regular Easting X values - for surface grid figure display
    
    nrows=numel(y);
    ncolumns=numel(x);
    
    % Initilize the Regular Blank Set
    data=-999*ones(nrows,ncolumns); % Replace -999 with zeros later on
     
    xpos=xmin;
    ypos=ymin;
    cnt=1;
    
    for ii=1:nrows
        for jj=1:ncolumns
            
            if cnt==file_rows_length
                break;
            end
            if xpos==datain(cnt,1) && ypos==datain(cnt,2)
                data(ii,jj)=datain(cnt,3);
                cnt=cnt+1;
            end
            xpos=xpos+delx;
        end
        xpos=xmin;
        ypos=ypos+dely;
    end

    % Find the index where the data value is -999
    TF = data==-999;
    TF2 = data~=-999;
    
    % Filling the each rows with the first & last column existing field data  
    for ii=1:nrows
        minpos = find(TF2(ii,:), 1 );
        maxpos = find(TF2(ii,:)==1, 1, 'last' );
        
        if minpos>1
            data(ii,1:minpos-1)=data(ii,minpos);
        end
        if maxpos<ncolumns
            data(ii,maxpos-1:ncolumns)=data(ii,maxpos);
        end      
%         disp (strcat('ii=',num2str(ii),',Minpos=',num2str(minpos),',Maxpos=',num2str(maxpos)));
    end
    
%     % Replace the data value = -999 with 0 values.
%     data(TF)=0;

    Easting=datain(:,1); % Supplied Easting Values
    Northing=datain(:,2);  % Supplied Northing Values
    
end
