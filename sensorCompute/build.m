%% Build file for c_sensorCompute
%
% We learned how to compile an ISETCam function.
%
% The different flags are
%
%  -m Make a standalone application
%  -R Suppress the Matlab 'nodisplay' run-time warning
%  -a Add the data in this directory to the compiled object
%
% The output is a shell script called run_c_sensorCompute.sh that is
% invoked by the command
%
%    ./run_c_sensorCompute.sh /software/MATLAB/R2017b
%
% The script sets up the environment needed to execute the standalone
% applications.  To run the so-called 'standalone', however, has
% pre-requisites that are described in the readme.txt.  These are
% extensive.  See that file..
%
% You must have exactly the same Matlab Runtime installed wherever you
% deploy this.  The readme.txt suggests how to package the whole
% environment.

% For this particular application, we add several data directories.
mcc -m -R -nodisplay c_sensorCompute.m ...
    -a ../../isetcam/data/lights ...
    -a ../../isetcam/data/human ...
    -a ../../isetcam/data/sensor ...
    -a ../../isetcam/data/surfaces