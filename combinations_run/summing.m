for t=1:26
    for i=1:2
        pRB1(i,t)=sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(recon{t}(:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,i)))))))))))))))))))))))))));
        pRB2(i,t)=sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(recon2{t}(:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,i)))))))))))))))))))))))))));
        pRB3(i,t)=sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(recon3{t}(:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,i)))))))))))))))))))))))))));
        pRB4(i,t)=sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(recon4{t}(:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,i)))))))))))))))))))))))))));
        pRB5(i,t)=sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(sum(recon5{t}(:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:,i)))))))))))))))))))))))))));
    end
end