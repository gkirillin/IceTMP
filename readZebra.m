function s =readZebra(fname)
if nargin<1
    [fname pname]=uigetfile('*.dat');
    fname=[pname,fname];
end
fid=fopen(fname,'r');
 C = textscan(fid,'%s%s%f%f%f%f','delimiter',',','headerlines',9);
 fclose(fid);
C{2}=datenum(strrep(strcat(C{1},'_', C{2}),'_',' '),'dd/mm/yy HH:MM:SS');
C=C(2:end);
s=cell2struct(C,{'dates','Batt','T','dosat','domg'},2);
%%