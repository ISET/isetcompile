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

% Create the parameters
params = c_sensorComputeParams;
params.sceneFov  = 3;
params.sensorFov = 4;
params.outfile   = 'localOut';


jsonwrite('c_sensorCompute.json',params);
c_sensorCompute('jsonFile','c_sensorCompute.json');
load(params.outfile,'rgb');
vcNewGraphWin; imagesc(rgb);
%}
%{
% Write this function
params = c_sensorComputeParams;

% Set the parameters
params.sceneType = 'frequency orientation';
params.sceneFov  = 4;
params.sensorFov = 6;
params.outfile   = 'localOut';

% Must be within the directory because we need to know the path
chdir(fullfile(isetCompileRootPath,'sensorCompute'));
jsonwrite('c_sensorCompute.json',params);

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
load(oiFile);

%% Adjust the sensor parameters to match the input

sensor = sensorCreate;
sFields = fieldnames(sensorParams);
for ii=1:length(sFields)
    sensor = sensorSet(sensor,sFields{ii},sensorParams.(sFields{ii}));
end

%% Sensor should be set.  Compute

sensor = sensorCompute(sensor,oi);

volts = sensorGet(sensor,'volts');

% The outfile ... how do we get this into a Flywheel analysis?
save(params.outfile,'volts');

end

%%