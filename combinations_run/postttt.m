function [s2d] = postttt(FF, CrdX)

dim = max(size(FF));

nf = size(FF{1},2);
naff = min(6,nf);

for dd=1:dim
    figure
    hold on
    plot(CrdX{dd},FF{dd},'linewidth',2);
    ylabel(['F',num2str(dd)],'FontSize',14 );
    xlabel(['x',num2str(dd)],'FontSize',14 );
    axis tight
end

if dim == 1
    figure
    plot(CrdX{dd},FF{1},'linewidth',2);    
end
 
if dim == 2

%     figure
%     hold on
%     plot(CrdX{1},FF{1}(:,1:naff),'linewidth',2);axis tight ;
%     ylabel('F_1(x_1)','FontSize',14 );
%     xlabel('x_1','FontSize',14 );
%     %axis ([-pi/2 pi/2 -0.2 0.2 -0.9 1.1])
% 
%     figure
%     plot( CrdX{2},FF{2}(:,1:naff),'linewidth',2);axis tight ;
%     ylabel('F_2(x_2)','FontSize',14 );
%     xlabel('x_2','FontSize',14 );
%     %axis ([-0.2 0.2 0 2 -1.5 1.5])

    figure
    s2d = FF{1} * FF{2}';
    surf(CrdX{1},CrdX{2}, s2d'); xlabel('x_1','FontSize',14 ); ylabel('x_2','FontSize',14 );
    axis tight ; axis normal ;  shading interp;
    view(2)
    colorbar
end
