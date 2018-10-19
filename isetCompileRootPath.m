function rootPath=isetCompileRootPath()
% Return the path to the root iset directory
%
% This function must reside in the directory at the base of the ISET
% compile directory structure.  It is used to determine the location of
% various sub-directories.
% 
% Example:
%   fullfile(isetCompileRootPath,'data')

rootPath=which('isetCompileRootPath');

[rootPath,fName,ext]=fileparts(rootPath);

return
