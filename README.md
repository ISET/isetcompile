# isetcompile

We are developing systematic methods to create 'compiled' Matlab functions.  We anticipate placing these functions in Docker containers that can be run on multiple platforms.  This repository will contain ISETCam and related repository functions.  At some point, we may create a vistacompile repository for MRI functionality.

## Conceptual organization 

The main directory of a function within the repository is called **functionName**.  Each such directory contains at least three functions.

* c_**functionName**.m for the main routine.
* c_**functionNameParams**.m to return a Matlab struct with all of the parameters needed in the main function.
* c_**functionNameBuild**.m to run the Matlab compiler (mcc) 
  
  We expect you to use the **jsonio library** for reading and writing the function parameters.  (See below).
  
  The function c_<functionNameBuild>.m produces two critical outputs.  One file includes all of the relevant functions and data needed for the Matlab Runtime Compiler to execute. This has the name c_<functionName>, with no m-file extension. That file will only run under the exact Matlab version that you use to compile.  The second file has the name run_c_<functionName>.sh.  This is a bash script that sets up the runtime environment necessary to invoke the function. Thus, to execute the function on a platform with, say, Matlab 2017b installed, you would run
  
      run_c_<functionName>.sh /software/Matlab/R2017b <function arguments will be placed here>

## Programming conventions

  We expect that the initial portion of the compiled functions will have an input like this

      function out = functionName(varargin)
      % Your comments
      %
      % Author 
      % See Also:
      %
      
      %% Read the function parameters
      p = inputParser;
      p.addParameter(jsonfile','c_functionName.json');
      p.parse(varargin{:});
      jsonFile = p.Results.jsonfile;
      params = jsonread(jsonFile);      % From the jsonio library
      
  Any user-specified parameters will be in the struct params.<variableName> that is returned by the jsonread.  We expect that you will have written these parameters to a json file using
  
      params = c_functionNameParams;    % Returns the default values
      params.var1 = newValue;           % Over-write the default
      jsonwrite(jsonFile,params);       % Save a json file with the parameters
      
  For an example, look at sensorCompute. 
      
## Aspects of the execution

* It is essential that the runtime library match the compilation environment exactly.
* If you do not use the jsonio methods, remember that values read in from the command line are always interpreted as strings.


