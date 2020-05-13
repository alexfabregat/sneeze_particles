function [nfselected,fselected,fnameroot,path] = getfilelist
%[nfiles,files,fnameroot,path]=GETFILELIST dialogs to get a list of *.bmp files
%
%get first and last files
[filename1,pathname1]=uigetfile('*.3D','Select the first file of a series') ;
[filename2,pathname2]=uigetfile('*.3D','Select the last file of a series')  ;
%
%check the path of this two files
if strcmp(pathname1,pathname2)~=1
    errordlg('This two files should be in the same directory','ERROR IN FILES SELECTED')
    return
end
path=pathname1 ;
%
%get the list of all files
%'dirall' is a struct array and the field 'name' has the name of the files
%'nfiles' in the number of files of this directory (including '.' and '..')
%'dirfiles' is a cell array with the file names
%..... which has to be sorted to ensure alphabetical order!!
dirall=dir(path) ; nfiles=max(size(dirall)) ;
for n=1:nfiles ; dirfiles{n}=dirall(n).name ; end ;
dirfiles=sort(dirfiles) ;
%
%get first and last file numbers
firstfile=0 ; lastfile=0 ;
for n=1:nfiles
    if strcmp(dirfiles{n},filename1) ; firstfile=n ; end ;
    if strcmp(dirfiles{n},filename2) ; lastfile=n  ; end ;
end
%
%get common characters in the filenames
n=1 ; while strncmp(filename1,filename2,n) ; n=n+1 ; end
fnameroot=filename1(1:n-1) ;
%
%get the number of the first and of the last file
[path1,file1,extension1]=fileparts(filename1) ; filenum1=str2num(file1(n:max(size(file1)))) ;
[path2,file2,extension2]=fileparts(filename2) ; filenum2=str2num(file2(n:max(size(file2)))) ;
%
%check if the files are consecutive
% if (lastfile-firstfile) ~= (filenum2-filenum1)
%     errordlg('The series of files is not consecutive','ERROR IN FILES SELECTED')
%     return
% end
%
%check if the extension of the files is always the same
for n=firstfile+1:lastfile
    [path2,file2,extension2]=fileparts(filename2) ;
    if extension1~=extension2
        errordlg('The extension of all the files is not the same','ERROR IN FILES SELECTED')
        return
    end
end
%
%check if the extension of the files is 'bmp'
%if ~strcmp(extension1,'.bmp')
%    errordlg('The extension of the files is not ''.bmp''','ERROR IN FILES SELECTED')
%    return
%end
%
%get filestep
filestep=1 ; 
answer=inputdlg('file step?','INPUT FILES',1,{'1'}) ;
filestep=str2num(answer{1}) ;
%
%this is the list of files
nfselected=0 ;
for n=firstfile:filestep:lastfile ; 
    nfselected=nfselected+1 ;
    fselected{nfselected}=dirfiles{n} ;
end ;
%
return
%