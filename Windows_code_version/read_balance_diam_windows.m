% function [dq]=read_balance_diam(pathname,fignum)
% function [dp]=read_balance(pathname,fignum)
% INPUT:
% pathname: 'Full path to data'
% fignum  : figure index. Set it to 0 to prevnt plotting

close all
clear all
clc

% Set to 1 to compute trajctory curvature. Expensive!
get_kappa = 0;

delta = 1.0;    % Box size
dtol  = 0.4;    % Do not touch: used in the periodic reconstruction

[nt,files,root,path]=getfilelist ;

% Get the number of times from the number of files
%eval(['[aa,bb] = system(''ls ',pathname,'/fbalance*.3D | wc -l'');']);
%nt = str2num(bb);

% Read files of the form "fbalance?????.3D"
for j=1:nt
  filename= [path,files{j}];
  
%  filename = ['fbalance',num2str(j,'%05d'),'.3D'];
  disp(['Reading ',filename,'...'])
  fid     = fopen(filename,'r');
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









