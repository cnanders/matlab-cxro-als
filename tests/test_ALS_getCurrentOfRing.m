% test_ALS
%{
try
    purge
end
%}
cDirThis = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(cDirThis, '..', 'src')))
% Channel Access
javaaddpath(fullfile(cDirThis, '..', 'src', 'ca_matlab-1.0.0.jar')); 

als = cxro.ALS();
als.getCurrentOfRing()
