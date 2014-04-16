
for t=1:26
    i=1;
for akt=1:2;
    for cd2=1:2;
        for cd4=1:2;
            for cd6=1:2;
               for cycd=1:2;
                    for cyce=1:2;
                        for egf=1:2;
                            for eralph=1:2;
                                for erbb=1:2;
                                    for erbb12=1:2;
                                        for erbb13=1:2;
                                            for erbb2=1:2;
                                                for erbb23=1:2;
                                                    for erbb3=1:2;
                                                        for ig=1:2;
                                                            for mek=1:2;
                                                                for myc=1:2;
                                                                    for p21=1:2;
                                                                        for p27=1:2;
                                                                            for prb=1:2;
                                                                                recon1{t}(akt,cd2,cd4,cd6,cycd,cyce,egf,eralph,erbb,erbb12,erbb13,erbb2,erbb23,erbb3,ig,mek,myc,p21,p27,prb)=res2{t}(i,1);
                                                                            recon5{t}(akt,cd2,cd4,cd6,cycd,cyce,egf,eralph,erbb,erbb12,erbb13,erbb2,erbb23,erbb3,ig,mek,myc,p21,p27,prb)=res2{t}(i,5);
                                                                            recon2{t}(akt,cd2,cd4,cd6,cycd,cyce,egf,eralph,erbb,erbb12,erbb13,erbb2,erbb23,erbb3,ig,mek,myc,p21,p27,prb)=res2{t}(i,2);
                                                                            recon3{t}(akt,cd2,cd4,cd6,cycd,cyce,egf,eralph,erbb,erbb12,erbb13,erbb2,erbb23,erbb3,ig,mek,myc,p21,p27,prb)=res2{t}(i,3);
                                                                         recon4{t}(akt,cd2,cd4,cd6,cycd,cyce,egf,eralph,erbb,erbb12,erbb13,erbb2,erbb23,erbb3,ig,mek,myc,p21,p27,prb)=res2{t}(i,4);
                                                                            i=i+1;

                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                     
                                end
                                
                            end
                        end
                    end
               end
            end
        end
     end
end

end