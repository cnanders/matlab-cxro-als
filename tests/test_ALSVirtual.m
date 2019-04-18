% test_ALS
%{
try
    purge
end
%}
cDirThis = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(cDirThis, '..', 'src')))

als = cxro.ALSVirtual();
als.getGapOfUndulator12()
als.setGapOfUndulator12(40)
als.getGapOfUndulator12()
als.getCurrentOfRing()
