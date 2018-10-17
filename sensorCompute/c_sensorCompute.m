function rgb = c_sensorCompute()
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
 system('./run_c_sensorCompute.sh /software/MATLAB/R2017b');
 load('sensor1','rgb');
 vcNewGraphWin; imagesc(rgb);
%}

scene = sceneCreate('mackay');
scene = sceneSet(scene,'fov',5);
oi = oiCreate;
oi = oiCompute(oi,scene);

sensor = sensorCreate;
sensor = sensorSetSizeToFOV(sensor,4);
sensor = sensorCompute(sensor,oi);

rgb = sensorGet(sensor,'rgb');
save('sensor1','rgb');

end

%%