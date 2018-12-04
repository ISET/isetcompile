function rgb = c_sensorCompute(oiFile,sensorFile)
% Produce sensor mosaic output data (either volts or electrons)
%
% Brief description:
%    We take an optical image as input.  The parameters determine the
%    sensor properties (e.g., color filters, pixel size, and so
%    forth). We write out a mat-file of the sensor responses (either
%    volts or electrons).
%
% Inputs
%   oi      -   Optical image filename.  Will be read in from Flywheel.
%   sParams - JSON file representing a list of sensor params that can
%             be applied using sensorSet.  Probably a JSON Flywheel
%             file.
%
% Optional key/value pairs
%   N/A
%
% Output
%   sensorData - A mat-file of an array of sensor responses,
%                volts
%
% 
% The comments on how to compile this code are in the _build file.
%
% ZL/BW
%
% See also
%   c_sensorCompute_build
%

%%
%{
% Check the function running locally.

% The oi is specified here
scene = sceneCreate('freqorient');
oi = oiCreate;
oi = oiCompute(oi,scene);
oiFile = fullfile(isetCompileRootPath,'local','oi');
save(oiFile,'oi');

% The output is specified here
sensorParams.outfile = fullfile(isetCompileRootPath,'local','outFile');

sensorParams.type = 'monochrome';
sensorParams.fov = 10;
sensorFile = fullfile(isetCompileRootPath,'local','sensorParams.json');

jsonwrite(sensorFile,sensorParams);

c_sensorCompute(oiFile,sensorFile);

load(sensorParams.outfile,'volts');
vcNewGraphWin; imtool(volts);
%}

%{
% Execute the code
system('./run_c_sensorCompute.sh /software/MATLAB/R2017b');
load(params.outfile,'rgb');
vcNewGraphWin; imagesc(rgb);
%}

%%  When compiled, the inputs always appear to be strings

p = inputParser;
p.addRequired('oiFile');        % Mat-file, optical image
p.addRequired('sensorFile');    % Sensor parameters file

p.parse(oiFile,sensorFile);

sensorParams = jsonread(sensorFile);

% How do get this file from Flywheel?
load(oiFile);

%% Build the sensor from the sensorFile parameters

sensor = sensorCreate(sensorParams.type);
reservedTypes = {'outfile','type'};
sFields = fieldnames(sensorParams);
for ii=1:length(sFields)
    if ~ismember(sFields{ii},reservedTypes)
        sensor = sensorSet(sensor,sFields{ii},sensorParams.(sFields{ii}));
    end
end

%% Sensor should be set.  Compute

sensor = sensorCompute(sensor,oi);

volts = sensorGet(sensor,'volts');

% The outfile ... how do we get this into a Flywheel analysis?

% How do we save this file in an analysis?
save(sensorParams.outfile,'volts');

end

%%