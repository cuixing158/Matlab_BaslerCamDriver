function cameraStruct = baslerCameraInfo(cameraIndex, varargin)
% baslerCameraInfo.m - Get all info on the selected Basler camera
%
%  Returns a struct containing all relevant information on the selected
%  Basler camera. It is possible to supply an optional visibility parameter
%  which specifies which camera information is displayed.
%  Possible values are:
%    - 0: Beginner
%    - 1: Expert
%    - 2: Guru
%  The default value is 0: Beginner
%
%  Usage:
%  cameraStruct = baslerCameraInfo(cameraIndex);
%  cameraStruct = baslerCameraInfo(cameraIndex, visibility);
%

% Parse visibility input
if nargin == 2
    visibility = varargin{1};
else
    visibility = 0;
end

% Get raw data
cameraCell = baslerGetRawCameraParams(cameraIndex);

% Remove empty values
emptyRows = cellfun( @isempty, cameraCell(:,2) );
cameraCell = cameraCell(~emptyRows,:);

% Remove N parameters
nParamRows = cellfun(                                       ...
        @(x) ~isempty( regexp(x,'N\d{1,4}','once')) ,         ...
        cameraCell(:,1));
cameraCell = cameraCell(~nParamRows,:);

% Remove parameters with '_ConvertTo' or '_convertFrom'
nParamConv = cellfun(                                       ...
        @(x) ~isempty( strfind(x,'_ConvertTo')) ,           ...
        cameraCell(:,1))                                    ...
    |                                                       ...
    cellfun(                                                ...
        @(x) ~isempty( strfind(x,'_ConvertFrom')) ,           ...
        cameraCell(:,1))                                    ...
    ;
cameraCell = cameraCell(~nParamConv,:);

% Only correct visibility
nVisRows = cellfun( @(x)x>visibility, cameraCell(:,3) );
cameraCell = cameraCell(~nVisRows,:);

% Remove visibility
cameraCell = cameraCell(:,1:2);
cameraStruct = cell2struct(cameraCell(:,2),cameraCell(:,1),1);

end