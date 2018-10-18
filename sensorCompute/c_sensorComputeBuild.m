%% Build file for c_sensorCompute
%
% We learned how to compile an ISETCam function.
%
% The output is a shell script called run_c_sensorCompute.sh that is
% invoked by the command
%
%    ./run_c_sensorCompute.sh /software/MATLAB/R2017b
%
% The script sets up the environment needed to execute the standalone
% applications.  To run the so-called 'standalone', however, has
% pre-requisites that are described in the readme.txt that is printed when
% the compile is finished.  These are extensive.  See that file..
%
% You must have exactly the same Matlab Runtime installed wherever you
% deploy this standalone.  The readme.txt suggests how to package the whole
% environment.
%
% The startup file for your Matlab session should be structured with the
% isdeployed function this way
%{
 if ~isdeployed
    ....
    Do your thing 
    ...
 end
%}
% Our understanding is that when you start Matlab normally, 'Do your thing'
% is run. This sets up your general environment.
%
% Then, when you run the compiler (mcc), it looks at your startup, but it
% knows that mcc is running and isdeployed becomes true.  So, it does not
% 'Do your thing'. Rather, it accepts the current environment and starts
% the compilation.
%
% ZL and BW
%
% See also
%

%% The compilation

% For this particular application, we add several data directories.
%
% The different flags are
%
%  -m Make a standalone application
%  -R Suppress the Matlab 'nodisplay' run-time warning
%  -a Add the data in this directory to the compiled object
%
chdir(fullfile(isetCompileRootPath,'sensorCompute'));
mcc -m -R -nodisplay c_sensorCompute.m ...
    -a ../../isetcam/data/lights ...
    -a ../../isetcam/data/human ...
    -a ../../isetcam/data/sensor ...
    -a ../../isetcam/data/surfaces ...

    
