function [dq]=read_balance_diam(pathname,fignum)
% function [dp]=read_balance(pathname,fignum)
% INPUT:
% pathname: 'Full path to data'
% fignum  : figure index. Set it to 0 to prevnt plotting

clear dp

% Set to 1 to compute trajctory curvature. Expensive!
get_kappa = 0;

delta = 1.0;    % Box size
dtol  = 0.4;    % Do not touch: used in the periodic reconstruction

% Get the number of times from the number of files
eval(['[aa,bb] = system(''ls ',pathname,'/fbalance*.3D | wc -l'');']);
nt = str2num(bb);

% Read files of the form "fbalance?????.3D"
for j=1:nt
  filename = ['fbalance',num2str(j,'%05d'),'.3D'];
  disp(['Reading ',filename,'...'])
  fid     = fopen([pathname,filename],'r');
  time(j) = fscanf(fid,'%g',[1,1]);
  A       = fscanf(fid,'%g',[20,inf]);
  A = A';
  np = size(A,1);
    sp(:,j)   = A(:,1);
    xp(:,j,1) = A(:,2);
    xp(:,j,2) = A(:,3);
    xp(:,j,3) = A(:,4);
    up(:,j,1) = A(:,5);
    up(:,j,2) = A(:,6);
    up(:,j,3) = A(:,7);
    dp(:,j,1) = A(:,8);
    dp(:,j,2) = A(:,9);
    dp(:,j,3) = A(:,10);
    wp(:,j)   = A(:,11);
    tp(:,j,1) = A(:,12);
    tp(:,j,2) = A(:,13);
    tp(:,j,3) = A(:,14);
    lp(:,j,1) = A(:,15);
    lp(:,j,2) = A(:,16);
    lp(:,j,3) = A(:,17);
    bp(:,j,1) = A(:,18);
    bp(:,j,2) = A(:,19);
    bp(:,j,3) = A(:,20);
  fclose(fid);
end 

% For a given variable of the form K(dim1,dim2,dim3,dim4)
% dim1: particle index, 1:np
% dim2: tme index,      1:nt
% dim3: coordinate:     1=x, 2=y, 3=z, (4=magnitude)

% Velocity magnitude
up(:,:,4) = (up(:,:,1).^2+up(:,:,2).^2+up(:,:,3).^2).^(0.5);
% Force magnitudes
dp(:,:,4) = (dp(:,:,1).^2+dp(:,:,2).^2+dp(:,:,3).^2).^(0.5);
tp(:,:,4) = (tp(:,:,1).^2+tp(:,:,2).^2+tp(:,:,3).^2).^(0.5);
lp(:,:,4) = (lp(:,:,1).^2+lp(:,:,2).^2+lp(:,:,3).^2).^(0.5);
bp(:,:,4) = (bp(:,:,1).^2+bp(:,:,2).^2+bp(:,:,3).^2).^(0.5);

% Distance travelled: only accurate if dt between snapshots is small
xp(:,1,4) = zeros(np,1);
deltat = diff(time);
for j = 1:length(deltat)
  xp(:,j+1,4) = up(:,j,4)*deltat(j);
end

% Curvature - Expensive!
if get_kappa
% This will be used to identify the stuck particles, if any, that have been reinjected.
 jump  = sqrt((xp(:,2:end,1)-xp(:,1:end-1,1)).^2 + (xp(:,2:end,2)-xp(:,1:end-1,2)).^2 + (xp(:,2:end,3)-xp(:,1:end-1,3)).^2);
 meanjump = mean(mean(jump));
 stdjump  = std(std(jump));
 [h1,h2]  = find(jump > meanjump + 100 * stdjump);
 VarNames = {'Stuck_p_ID','Stuck_Time'};
 T = table(h1,h2,'VariableNames',VarNames)
 a1 = setdiff([1:np],h1);

for i=1:np
 dxdt = gradient(xp(i,:,1),time);
 dydt = gradient(xp(i,:,2),time);
 dzdt = gradient(xp(i,:,3),time);
 d2xdt2 = gradient(dxdt,time);
 d2ydt2 = gradient(dydt,time);
 d2zdt2 = gradient(dzdt,time);
 term1 = (d2zdt2.*dydt-d2ydt2.*dzdt).^2;
 term2 = (d2xdt2.*dzdt-d2zdt2.*dxdt).^2;
 term3 = (d2ydt2.*dxdt-d2xdt2.*dydt).^2;
 kappa(i,:) = sqrt(term1 + term2 + term3)./(dxdt.^2 + dydt.^2 + dzdt.^2).^(3/2);
 kappam(i) = mean(kappa(i,:));
 end
 for i=h1
 kappa(i,1:nt) = 0.0;
 end
 dq.kappa = kappa;
end

% Min max values for each force
disp(['Drag:             ',num2str(min(dp(:,nt,4))),'     ',num2str(max(dp(:,nt,4)))])
disp(['Weight:           ',num2str(min(wp(:,nt))),  '     ',num2str(max(wp(:,nt)))])
disp(['Thermophoresis:   ',num2str(min(tp(:,nt,4))),'     ',num2str(max(tp(:,nt,4)))])
disp(['Lift:             ',num2str(min(lp(:,nt,4))),'     ',num2str(max(lp(:,nt,4)))])
disp(['Brownian:         ',num2str(min(bp(:,nt,4))),'     ',num2str(max(bp(:,nt,4)))])

% Force Balance
acc(:,:,1) = dp(:,:,1) + tp(:,:,1) + lp(:,:,1) + bp(:,:,1);
acc(:,:,2) = dp(:,:,2) + tp(:,:,2) + lp(:,:,2) + bp(:,:,2) + wp(:,:);
acc(:,:,3) = dp(:,:,3) + tp(:,:,3) + lp(:,:,3) + bp(:,:,3);
acc(:,:,4) = (acc(:,:,1).^2+acc(:,:,2).^2+acc(:,:,3).^2).^(0.5);

dq.t = time;
dq.xp = xp;
dq.up = up;
dq.ap = acc;
dq.dp = dp;
dq.wp = wp;
dq.tp = tp;
dq.lp = lp;
dq.bp = bp;
dq.sp = sp;

% Normalize particle size
for k=1:nt                                       
dq.np(:,k) = (dq.sp(:,k)-min(min(dq.sp)))/(max(max(dq.sp))-min(min(dq.sp)));
dq.np(:,k) = dq.np(:,k) + 1.0;
end

% Radial and angular velocities
for k=1:nt
rad1 = sqrt(dq.xp(:,k,1).^2 + dq.xp(:,k,2).^2);
the1 = atan2(dq.xp(:,k,2),dq.xp(:,k,1));
dq.up(:,k,5) =  dq.up(:,k,1).*cos(the1) + dq.up(:,k,2).*sin(the1);
dq.up(:,k,6) = -dq.up(:,k,1).*sin(the1) + dq.up(:,k,2).*cos(the1);
end


