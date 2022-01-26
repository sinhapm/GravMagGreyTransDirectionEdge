 function [ax]=func_subplot1x2(figurename,...
    X,Y,data1,data2,title1,title2,colourtype)    

    nfr=1; nfc=2;
    
    f=figure;
    set(f,'Name',figurename);
    set(f,'NumberTitle','on','WindowState', 'maximized');
    
    ax(1)=subplot(nfr,nfc,1); surface(X,Y,data1,'EdgeColor','none');
    axis equal; axis tight; axis off; axis xy; title(title1);
    xlabel('Easting','FontSize',10,'FontWeight','bold');
    ylabel('Northing','FontSize',10,'FontWeight','bold');
    colormap(colourtype); shading interp; axis tight;
    colorbar;
    
    ax(2)=subplot(nfr,nfc,2); surface(X,Y,data2,'EdgeColor','none');
    axis equal; axis tight; axis off; axis xy; title(title2);
    xlabel('Easting','FontSize',10,'FontWeight','bold');
    ylabel('Northing','FontSize',10,'FontWeight','bold');
    view(2); grid off; colormap(colourtype); shading interp; axis tight;
    colorbar
    
end
