
function [xq,yq,zq, wcint,xslice_rotated,yslice_rotated, fZBED_st, freqBand_st, SSband_st, freqBandin_st, SSbandin_st, freqBandout_st, SSbandout_st] = BDI_method_bottomfind_881files(UNHIMG,hpangle,rr,Zr1,Sr1,fname)
%%

%try the BDI method and then the rootmeansum method

% first get data in format from
% read_persist_TA_testws_UNH_assumesAngle_Correct_5deg
%then follow mthod from DouglasPereriaMScE - John Hughes Clark

figsOn =0;  %figs on: 1 = yes, 0 = no

zrstore = nan(700,size(UNHIMG.data,3));
srstore = nan(700,size(UNHIMG.data,3));

for mm=1:size(UNHIMG.data,3)
    if figsOn == 1
        figure (15); pcolor(Sr1(:,:,mm),Zr1(:,:,mm),UNHIMG.data(:,:,mm)); colorbar; caxis([0 200]);
        set(gca,'YDir','reverse');
        shading flat;
    end
    
%    wci(:,:,mm) = nanmean(UNHIMG.data(50:70,60:100,mm));
wcint = 1;

cnt = 1;
for kk = 95:size(UNHIMG.data,1)%265
    smooth_time_pulse = smooth(UNHIMG.data(kk,:,mm),3);
    smooth_time_pulse(smooth_time_pulse<30) = nan;
    [pks_dum pidx_dum] = findpeaks(smooth_time_pulse,'MinPeakDistance',20);
    if isempty(pks_dum)
    else
        for tt = 1:length(pks_dum)
            mins = 2;
            zrcomp = .95;
            if pidx_dum-mins >0 & pidx_dum+mins<size(UNHIMG.data,2)%150
                p1 = smooth_time_pulse(pidx_dum(tt)-mins:pidx_dum(tt)+mins);
                a1 = hpangle(pidx_dum(tt)-mins:pidx_dum(tt)+mins);
                fnan = find(isnan(p1));
                pl = floor(length(p1)/2);
                ffirst = find(fnan<pl,1,'last');
                flast = find(fnan>pl,1,'first');
                if isempty(ffirst)
                    idx1 = 1;
                else
                    idx1 = fnan(ffirst)+1;
                end
                if isempty(flast)
                    idx2 = length(p1);
                else
                    idx2 = fnan(flast)-1;
                end
                
                p1 = p1(idx1:idx2);
                a1 = a1(idx1:idx2);
                pfit1 = polyfit(a1',p1,2);
                afit1 = a1(1):.01:a1(end);
                vfit1 = polyval(pfit1,afit1);
                [vmax1, idxm1] = max(vfit1);
                amax1 = afit1(idxm1);
                sr1 = rr(kk)'*sin(amax1)*(1500/1500);%
                zr1 = rr(kk)'*cos(amax1)*(1500/1500);%
                
                if zr1 < .55 
                    zr1 = nan;
                    sr1 = nan;
                end
                
                if zr1 > 1.2 
                    zr1 = nan;
                    sr1 = nan;
                end
               
                if sr1<.7 && sr1>-.7
                    sr1 = nan;
                    zr1 = nan;
                end
                
                if cnt >1
                if abs(zr1-zrcomp)>.3 
                    zr1 = nan;
                    sr1 = nan;
                end
                end
                
                 zrstore(cnt,mm) = zr1;
                 srstore(cnt,mm) = sr1;
                 if isnan(zr1) ==0
                    zrcomp = zr1;
                 end
               
                cnt = cnt+1;
                if figsOn == 1
                    figure (15);
                    hold on
                    %plot(sr1,zr1,'*g');
                    
                    
                                    figure (1);
                                    plot(hpangle,UNHIMG.data(kk,:,mm));
                                    hold on
                                    plot(a1,p1,'.-');
                                    plot(afit1,vfit1,'r');
                                    pause(.01);
                                    hold off
                    
                end
            end
        end
    end
    

    
cntS(mm) = cnt;    
end

% now find the bed
%bottom Detect Tom Webber's way.. center of mass along each beam (weighted
%mean sum)
n = 10;
zrcomp2 = nanmean(nanmean(zrstore));
for kk = 1:size(UNHIMG.data,2)%150
    beam = squeeze(UNHIMG.data(:,kk,mm));
    beam(1:80) = 0;
    mbeam = max(beam);
    if mbeam >60
        AA = sum(beam.^n);
        for zz = 1:size(UNHIMG.data,1)%265
            BB(zz) = (beam(zz).^n*zz);
        end
        WMS_IndexOFBed(kk) = round(sum(BB)/AA);
        Intensity_WMSBed(kk) = beam((WMS_IndexOFBed(kk)));
        zt = Zr1(WMS_IndexOFBed(kk),kk,mm);
        st = Sr1(WMS_IndexOFBed(kk),kk,mm);
        rt = sqrt(zt^2+st^2).*(1500/1500);
        at = atan2(zt,st);
        
        Zr_BEDWMS(kk,mm) = rt.*sin(at);
        Sr_BEDWMS(kk,mm) = rt.*cos(at);

% LIMITS        
        if Zr_BEDWMS(kk,mm) < .55
            Zr_BEDWMS(kk,mm) = nan;
            Sr_BEDWMS(kk,mm) = nan;
        end
%         if Sr_BEDWMS(kk,mm) < -1
%             Zr_BEDWMS(kk,mm) = nan;
%             Sr_BEDWMS(kk,mm) = nan;
%         end
%         
%         if Sr_BEDWMS(kk,mm) > 1
%             Zr_BEDWMS(kk,mm) = nan;
%             Sr_BEDWMS(kk,mm) = nan;
%         end
%         
%         if kk >1
%         if abs(Zr_BEDWMS(kk,mm)-zrcomp2)>.1
%             Zr_BEDWMS(kk,mm) = nan;
%             Sr_BEDWMS(kk,mm) = nan;
%         end
%         end
        
    
    else
        Zr_BEDWMS(kk,mm) = nan;
        Sr_BEDWMS(kk,mm) = nan;
    end
    
    if isnan(Zr_BEDWMS(kk,mm)) ==0
          zrcomp2old = zrcomp2;
          zrcomp2 = Zr_BEDWMS(kk,mm);
          if abs(zrcomp2-zrcomp2old)>.02
              zrcomp2 = zrcomp2old;
          end
          
    end
    

end
    
   

if figsOn == 1
    figure (15);
    plot(Sr_BEDWMS(:,mm),Zr_BEDWMS(:,mm),'.k','markersize',20);
    pause
    clf
end
end

% %% sort and order by S small to big
% 
% 
% 
for mm = 1:size(UNHIMG.data,3)
    
    ds = srstore(:,mm);
    ds(cntS(mm)+1:cntS(mm)+1+size(Sr_BEDWMS,1)-1,1) = Sr_BEDWMS(:,mm);
    dz = zrstore(:,mm);
    dz(cntS(mm)+1:cntS(mm)+1+size(Zr_BEDWMS,1)-1,1) = Zr_BEDWMS(:,mm);
    
    [sort_ds, idx] = sort(ds);
    sort_dz = dz(idx);
    first_nan = find(isnan(sort_dz),1,'first');
    Zb = sort_dz(1:first_nan-1);
    SBED = sort_ds(1:first_nan-1);
    fZBED = medfilt1(Zb,3);
    SBED = SBED(2:end-1); 
    fZBED = fZBED(2:end-1);
    
%     [SSband, freqBand, DOF, Gj] = spectrum_mew(fZBED,1,1,.01,'h');
%     idx1 = closest(-1,SBED); idx2 = closest(1,SBED);
%     [SSbandin, freqBandin, DOF, Gj] = spectrum_mew(fZBED(idx1:idx2),1,1,.01,'h');
%     fZout = [fZBED(1:idx1-1);fZBED(idx2+1:end)];
%     [SSbandout, freqBandout, DOF, Gj] = spectrum_mew(fZout,1,1,.01,'h');
%     
%     if mm ==1
%         SSband_st(:,mm) = SSband;
%         freqBand_st = freqBand;
%         SSbandin_st(:,mm) = SSbandin;
%         freqBandin_st = freqBandin;
%         SSbandout_st(:,mm) = SSbandout;
%         freqBandout_st = freqBandout;
%     else
%         idxes = round(closest(freqBand_st,freqBand));
%         SSband_st(:,mm) = SSband(idxes);
%         idxes1 = floor(closest(freqBandin_st,freqBandin));
%         SSbandin_st(:,mm) = SSbandin(idxes1);
%         idxes2 = floor(closest(freqBandout_st,freqBandout));
%         SSbandout_st(:,mm) = SSbandout(idxes2);
%     end
% 
%     if figsOn ==1
%     figure (31);
%     subplot(1,2,1)
%     hold off
%     semilogy(freqBand,SSband(:,mm))
%     hold on
%     semilogy(freqBandin,SSbandin(:,mm))
%     semilogy(freqBandout,SSbandout(:,mm))
%     %ylim([0 .2E-5])
%     subplot(1,2,2)
%     hold off
%     pcolor(Sr1(:,:,mm),Zr1(:,:,mm),UNHIMG.data(:,:,mm)); colorbar; caxis([0 200]);
%         set(gca,'YDir','reverse');
%         shading flat; axis image
%         hold on
%         plot(SBED,fZBED,'.m');
%     pause
%     end
%     

%     % remove the parabola from the bed
%     xlin = SBED;
%     tfit = fit(SBED,fZBED,'poly2');
%     p = coeffvalues(tfit);
%     zlin = p(1).*xlin.^2 +p(2).*xlin + p(3);
%     %p = polyfit(SBED,fZBED,1);
%     %zlin = p(1)*xlin+p(2);
%     
%     
    fZBEDdetrend = fZBED;
    
    SBED_st{mm} = SBED;
    fZBED_st{mm} = fZBEDdetrend;
    %fZBED_st{mm} = BED_newZ;
%     
%    
%     if figsOn ==1
%     %plot(sort_ds,sort_dz); hold on
%     figure (15); pcolor(Sr1(:,:,mm),Zr1(:,:,mm),UNHIMG.data(:,:,mm)); colorbar; caxis([0 200]);
%         set(gca,'YDir','reverse');
%         shading flat;
%      hold on
%     plot(SBED,fZBED,'m');
%     hold on
%     %plot(SBED,BED_newZ,'b');
%     pause
%     hold off
%     end
end
 
% figure; loglog(freqBand_st,mean(SSband_st,2))
% hold on
% loglog(freqBandin_st,mean(SSbandin_st,2))
% loglog(freqBandout_st,mean(SSbandout_st,2))

%% now rotate slices based upon azimuth angle...

shiftAngle = 0;
    azinc = 9.9;
    
    for gg = 1:size(UNHIMG.data,3)
        S_bed = cell2mat(SBED_st(gg));
        Z_bed = cell2mat(fZBED_st(gg));
        cntLen(gg) = length(Z_bed);
        % define the x- and y-data for the original line we would like to rotate
        if strcmp(UNHIMG.direction881a,'blank towards pipe') == 1
            x = repmat(-.084,1,length(S_bed));%75); %use -0.084 when the Sonar blanking spot is ~180 deg away from pipe, use 0.084 when it is toward pipe.
        else
            x = repmat(-.084,1,length(S_bed));
        end
        %x = -.8+.0213/2:.0213:.8-.0213/2;
        y = S_bed';%,index_low_diff)';%
        %y = -.8+.0213/2:.0213:.8-.0213/2;%ones(1,75);
        z = Z_bed';%,index_low_diff)';
        
        % create a matrix of these points, which will be useful in future calculations
        v = [x;y];
        
        % choose a point which will be the center of rotation
        x_center = 0;
        y_center = 0;
        
        % create a matrix which will be used later in calculations
        center = repmat([x_center; y_center], 1, length(x));
        
        % define a counter-clockwise rotation matrix
        theta = deg2rad(shiftAngle); % rotation of bed to horizontal
        R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
        shiftAngle = shiftAngle + azinc;
        
        % do the rotation...
        s = v - center; % shift points in the plane so that the center of rotation is at the origin
        so = R*s; % apply the rotation about the origin
        vo = so + center; % shift again so the origin goes back to the desired center of rotation
        % this can be done in one line as:
        %vo = R*(v - center) + center
        
        
        % pick out the vectors of rotated x- and y-data
        xslice_rotated{gg} = so(1,:);
        yslice_rotated{gg} = so(2,:);
        
        
        
%             figure (89);
%             plot(x, y, 'k.', xslice_rotated{gg}, yslice_rotated{gg}, 'r.');
%             axis equal;
%             hold on
%             plot(0,0,'go');
%             xlim([-1.2 1.2]);
%             ylim([-2 2]);
%             pause
%             clf
    end


    ss = 1;
    for gg = 1:size(UNHIMG.data,3)
        ee = ss+cntLen(gg)-1;
        Xin(ss:ee,1) = cell2mat(xslice_rotated(gg))';
        Yin(ss:ee,1) = cell2mat(yslice_rotated(gg))';
        Zin(ss:ee,1) = cell2mat(fZBED_st(gg))';
        ss = length(Xin)+1;
    end
        
    % linear surface model
%         tfit = fit([Xin, Yin],Zin,'poly23');
%         p = coeffvalues(tfit);
%         zlin = p(1) + p(2).*Xin + p(3).*Yin + p(4).*Xin.^2 + p(5).*Xin.*Yin + p(6).*Yin.^2 + p(7).*Xin.^2.*Yin + p(8).*Xin.*Yin.^2 + p(9).*Yin.^3;
%      Zin2 = Zin-zlin;
    %Zin = -(Zin - mean(Zin));

    gdsize = 0.005; %.005
    th = (0:azinc:360)*pi/180;
    r = 0:gdsize:1.5; %1.7;
    [TH,R] = meshgrid(th,r);
    [X,Y] = pol2cart(TH,R);
    
    F = scatteredInterpolant(Xin,Yin,Zin);
    Z(:,:)=F(X(:,:),Y(:,:));
    
    meanZ = nanmean(nanmean(Z));
    Zpad = nan(size(Z,1)+floor(.5*size(Z,1)), size(Z,2));
    Zpad(isnan(Zpad)) = meanZ;
    Zpad(1:size(Z,1),:) = Z;
    
    gdsize = 0.005;
    th = (0:azinc:360)*pi/180;
    r = 0:gdsize:2.55;
    [TH,R] = meshgrid(th,r);
    [Xp,Yp] = pol2cart(TH,R);
    
   % [xq,yq,zq]=griddata(Xp,Yp,Zpad,repmat([-1.7:.005:1.7],681,1),repmat([-1.7:.005:1.7]',1,681));
       [xq,yq,zq]=griddata(X,Y,Z,repmat([-1.5:.005:1.5],601,1),repmat([-1.5:.005:1.5]',1,601));

    %wcint = nanmean(nanmean(nanmean(wci)));
   
    
    
    
    %% some plotting
    if figsOn ==1
    figure (2);
    for kk = 1:size(UNHIMG.data,3)
        
         
        scatter(xslice_rotated{kk},yslice_rotated{kk}, 50,-fZBED_st{kk},'filled');
        hold on
    end
    axis image;
    %colormap pink
    %caxis([.5 .9])
    
    figure (4); surf(xq,yq,-zq); shading flat
    shading flat
    axis image
    caxis([-.17 .17])
    colormap pink
    pause(.01)
    end
    
    
    
