function varargout = AsciiArt(varargin)
% ASCIIART MATLAB code for AsciiArt.fig
%      ASCIIART, by itself, creates a new ASCIIART or raises the existing
%      singleton*.
%
%      H = ASCIIART returns the handle to a new ASCIIART or the handle to
%      the existing singleton*.
%
%      ASCIIART('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASCIIART.M with the given input arguments.
%
%      ASCIIART('Property','Value',...) creates a new ASCIIART or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AsciiArt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AsciiArt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AsciiArt

% Last Modified by GUIDE v2.5 01-Aug-2017 17:40:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AsciiArt_OpeningFcn, ...
                   'gui_OutputFcn',  @AsciiArt_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AsciiArt is made visible.
function AsciiArt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AsciiArt (see VARARGIN)

% Choose default command line output for AsciiArt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.Button_Transform,'Enable','off');
set(handles.Button_Save,'visible','off');
axis off;
warning off;

% UIWAIT makes AsciiArt wait for user response (see UIRESUME)
% uiwait(handles.Main_Figure);


% --- Outputs from this function are returned to the command line.
function varargout = AsciiArt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Button_OpenImage.
function Button_OpenImage_Callback(hObject, eventdata, handles)
% hObject    handle to Button_OpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile(...
    {'*.bmp;*.jpg;*.png;*.jpeg',...
     'Image Files (*.bmp,*.jpg,*.png,*.jpeg)';...
     '*.*',...
     'All Files (*.*)'},...
     'Pick an image');
if isequal(filename,0) || isequal(pathname,0)
     return;
end

axis on;
file  = [pathname,filename];
image = imread(file);
axes(handles.Axes_Image);
imshow(image);

set(handles.Button_Transform,'Enable','on');
set(handles.Button_Transform,'Visible','on');
set(handles.Button_Save,'Visible','off');
setappdata(handles.Main_Figure,'file',file);


% --- Executes on button press in Button_Transform.
function Button_Transform_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file = getappdata(handles.Main_Figure,'file');
[~,txt] = img2txt(file);
msgbox('Complete!');
uiwait();

ButtonName = questdlg('Do you need a preview?','Question','Yes','No','Yes');
switch ButtonName
    case 'Yes'
        disp(txt);
        set(hObject,'Visible','off');
        set(handles.Button_Save','Visible','on');
        setappdata(handles.Main_Figure,'txt',txt);
    case 'No'
        set(hObject,'Visible','off');
        set(handles.Button_Save','Visible','on');
        setappdata(handles.Main_Figure,'txt',txt);
end


% --- Executes on button press in Button_Save.
function Button_Save_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname]=uiputfile(...
    {'*.txt','Text File'},...
     'Save');
 if isequal(filename,0) || isequal(pathname,0)
     return; % 如果点了“取消”
 else
     fpath=fullfile(pathname,filename); % 获得全路径的另一种方法
 end
txt = getappdata(handles.Main_Figure,'txt');
fid = fopen(fpath,'w');
siz = size(txt);
for a=1:siz(1)
    fwrite(fid,[txt(a,:),13,10]);
end

fclose(fid);
 
msgbox('Sucessfully Saved!','Yeah!');
uiwait();


function [filename,str]=img2txt(imfile,varargin)
%IMG2TXT Converts an image to ASCII text
%
%   img2txt(imfile) converts the image contained in the specified file
%                   using an ASCII character for every pixel in x-dimension
%   img2txt(imfile,stepx) converts the image contained in the specified file
%                   using an ASCII character for every stepx pixels in x-dimension
%

%   Copyright (c) by Federico Forte
%   Date:     2004/04/08 
%   Revision: 2004/04/27 

ramp=['@@@@@@@######MMMBBHHHAAAA&&GGhh9933XXX222255SSSiiiissssrrrrrrr;;;;;;;;:::::::,,,,,,,........'];
  % the 'ramp' vector represents characters in order of intensity
 im=imread(imfile);
 siz = size(im);
 if siz(2)>siz(1)
    im=imresize(im,[100 nan]);
%  elseif siz(2)>500
%      im=imresize(im,[50 nan]);
 else
     im=imresize(im,[150 nan]);
 end
im=mean(im,3);
% fid=fopen(strcat([imfile,'.txt']),'w');
filename = strcat([imfile,'.txt']);
stepx=1;
if length(varargin)>0,
  stepx=varargin{1};
end
stepy=2*stepx;
sizx=fix(size(im,2)/stepx);
sizy=fix(size(im,1)/stepy);
lumin=zeros(sizy,sizx);
for j=1:stepy,
  for k=1:stepx,
    lumin=lumin+im(j:stepy:(sizy-1)*stepy+j,k:stepx:(sizx-1)*stepx+k);
  end
end
str=ramp(fix(lumin/(stepx*stepy)/256*length(ramp))+1);
% for h=1:sizy,
%   fwrite(fid,[str(h,:),13,10]);
% end
% fclose(fid);
