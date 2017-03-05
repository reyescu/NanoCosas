clear all
close all
load('LNT_ML-WSe2-YIG_45_cross_long_CCD_000.mat')
Data=ch{1}.s1(:,:,1:380)-2000;
xrange=ax{1}.range;
xarray=ax{1}.array;
larray=ax{3}.array(1:380);
nx=length(xarray);
yrange=ax{2}.range;
yarray=ax{2}.array;
%figure(1)
hold on
for i=1:110
    for j=1:110
    %scatter(larray,squeeze(Data(i,j,:)));
    [xData, yData] = prepareCurveData(larray,squeeze(Data(i,j,:)) );
    [myfit,fitres]=my2gaussfit(larray,squeeze(Data(i,j,:)));
    a1(i,j)=myfit.a1;
    b1(i,j)=myfit.b1;
    c1(i,j)=myfit.c1;
     a2(i,j)=myfit.a2;
    b2(i,j)=myfit.b2;
    c2(i,j)=myfit.c2;
    hold off
    
    if ((mod(j,10)==0))
        i 
        j
       % Plot fit with data.
% %figure( 'Name', 'untitled fit 1' );
 hold off
 h = plot( myfit, xData, yData );
% legend( h, 'yy vs. larray', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel larray
% ylabel yy
% grid on
%  
    end
        
    
    end
end
save('fitting2.mat','a1','b1','c1','a2','b2','c2');
figure;
 title('a1')
imagesc(imresize(a1./1E4,3))
colorbar;
caxis([3 4])


figure()

    