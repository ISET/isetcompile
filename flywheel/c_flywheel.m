function s = c_flywheel(varargin)
% Return a flywheel object from the Renderings project
%
%
%
% ZL/BW

%%  We need to open a scitran object
s = [];

% This will probably need to get the token and created in here.
st = scitran('stanfordlabs');

% List the Renderings project
h = st.projectHierarchy('Renderings');
stPrint(h.sessions,'label');

end
%%