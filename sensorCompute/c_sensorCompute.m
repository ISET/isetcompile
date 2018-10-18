function rgb = c_sensorCompute(varargin)
% Create compiled code for producing sensor RGB data
%
% This function is not interesting in itself.
%
% The comments on how to compile this code are in the _build file.
%
% ZL/BW
%
% See also
%   c_sensorCompute_build
%

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

p.addParameter('jsonfile','c_sensorCompute.json');
p.parse(varargin{:});

jsonFile = p.Results.jsonfile;
params = jsonread(jsonFile);

%%  Create the scene
scene = sceneCreate(params.sceneType);
scene = sceneSet(scene,'fov',params.sceneFov);

%%
oi = oiCreate;
oi = oiCompute(oi,scene);

%%
sensor = sensorCreate;
sensor = sensorSetSizeToFOV(sensor,params.sensorFov);
sensor = sensorCompute(sensor,oi);

rgb = sensorGet(sensor,'rgb');
save(params.outfile,'rgb');

end

%%