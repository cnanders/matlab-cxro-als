% test_ALS
%{
try
    purge
end
%}
cDirThis = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(cDirThis, '..', 'src')))

%{
% Channel Access
javaaddpath(fullfile(cDirThis, '..', 'src', 'ca_matlab-1.0.0.jar')); 

als = cxro.ALS();

als.getOperatorGrantOfUndulator12()

als.getGapOfUndulator12()
als.setGapOfUndulator12(39.7)
fprintf('pausing 3 seconds to give undulator time to move\n');
pause(3);
als.getGapOfUndulator12()
als.getCurrentOfRing()

%}

als = cxro.ALS();
als.getCurrentOfRing()
als.getGapOfUndulator12()
