%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERACTIVE SEGMENTATION
% This code contains the main framework for interactive segmentation. Most
% of it concerns the interface and you won't have to touch it.
% 
% The only function that is of any interest to you is 
% 
% 'segment_ClickedCallback'
% 
% which is placed at the end of this file.
% 
% This function will need your code for creating color histograms, creating
% the data cost, and doing the primal dual algorithm. Your code should go
% in the section "Primal Dual Segmentation" of segment_ClickedCallback.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function varargout = interactiveSeg(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interactiveSeg_OpeningFcn, ...
                   'gui_OutputFcn',  @interactiveSeg_OutputFcn, ...
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


% --- Executes just before interactiveSeg is made visible.
function interactiveSeg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interactiveSeg (see VARARGIN)

% Choose default command line output for interactiveSeg
handles.output = hObject;

% Initialize the parameters
handles.fgDrawer = false;
handles.bgDrawer = false;
handles.erDrawer = false;
handles.lambda = 1.0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interactiveSeg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interactiveSeg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function openFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.filename, handles.pathname] = uigetfile({'*.png;*.jpg;*.bmp' ; '*'});
addpath(genpath(handles.pathname));

% Read the image, store it in the handles and show it
handles.image   = imread(handles.filename);
handles.width   = size(handles.image,2);
handles.height  = size(handles.image,1);
handles.channel = size(handles.image,3);

if(isfield(handles,'imgPos')) % in case another image was on screen already
    delete(handles.imgPos);
end

f = imshow(handles.filename);
handles.imgPos = f;

% Forground / Background initialization
handles.fgData = [];
handles.bgData = [];

% Make sure all drawing options are set to off
handles.fgDrawer = false;
handles.bgDrawer = false;
handles.erDrawer = false;

% Size of the brush for painting
handles.brushSize = 5;

% Update the structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function fgButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to fgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fgDrawer = ~handles.fgDrawer;

if(handles.fgDrawer)
    set(handles.imgPos,'ButtonDownFcn',@startDrawFcn);
else
    set(handles.imgPos,'ButtonDownFcn',@stopDrawFcn);
end

set(handles.figure1,'WindowButtonUpFcn', @stopDrawFcn);

guidata(hObject, handles);


% --------------------------------------------------------------------
function bgButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to bgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fgDrawer = false;
handles.bgDrawer = ~handles.bgDrawer;
handles.erDrawer = false;

if(handles.bgDrawer)
    set(handles.imgPos,'ButtonDownFcn',@startDrawFcn);
else
    set(handles.imgPos,'ButtonDownFcn',@stopDrawFcn);
end

set(handles.figure1,'WindowButtonUpFcn', @stopDrawFcn);

guidata(hObject, handles);


% --------------------------------------------------------------------
function erButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to erButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fgDrawer = false;
handles.bgDrawer = false;
handles.erDrawer = ~handles.erDrawer;

if(handles.erDrawer)
    set(handles.imgPos,'ButtonDownFcn',@startDrawFcn);
else
    set(handles.imgPos,'ButtonDownFcn',@stopDrawFcn);
end

set(handles.figure1,'WindowButtonUpFcn', @stopDrawFcn);

guidata(hObject, handles);

% --------------------------------------------------------------------
function startDrawFcn(hObject, eventdata)
handles = guidata( ancestor(hObject, 'image') );
fprintf('Start drawing\n');

guidata(hObject,handles);

set(handles.figure1, 'WindowButtonMotionFcn', @drawing);

% --------------------------------------------------------------------
function drawing(hObject, eventData)
handles = guidata( ancestor(hObject, 'figure') ); % recover the handles

a = get(handles.imgPos,'Parent'); % axis of the image
set(a, 'Units', 'pixels');
pt = get(a, 'CurrentPoint'); % get current position of the cursor on the image
pt = pt(1,1:2); % CurrentPoint gives 3D coordinates of a projected line, we only need the 2d position

% Paint on the image
paintedPixels = getPaintedPixels(pt,handles.brushSize,handles.width, handles.height);

LineSpec = '';
if (handles.fgDrawer)
    handles.fgData = [handles.fgData ; paintedPixels];
    handles.fgData = unique(handles.fgData,'rows');
    LineSpec = 'r';
    
elseif (handles.bgDrawer)
    handles.bgData = [handles.bgData ; paintedPixels];
    handles.bgData = unique(handles.bgData,'rows');
    LineSpec = 'b';
    
elseif (handles.erDrawer)
    LineSpec = 'k';
    
    if(~isempty(handles.fgData))
        handles.fgData(ismember(handles.fgData,paintedPixels, 'rows'),:) = [];
    end
    
    if(~isempty(handles.bgData))
        handles.bgData(ismember(handles.bgData,paintedPixels, 'rows'),:) = [];
    end
    
end

hold on
plot(paintedPixels(:,1), paintedPixels(:,2), LineSpec);

guidata(hObject, handles);


% --------------------------------------------------------------------
function stopDrawFcn(hObject, eventData)
handles = guidata( ancestor(hObject, 'figure') );
set(handles.figure1, 'WindowButtonMotionFcn', '');

function lamEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lamEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lamEdit as text
%        str2double(get(hObject,'String')) returns contents of lamEdit as a double
handles.lambda = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lamEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lamEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function loadScribbles_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to loadScribbles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load scribbles2.mat
handles.fgData = seed_fg;
handles.bgData = seed_bg;

handles.imgPos = imshow(handles.image);
hold on
plot(seed_fg(:,1),seed_fg(:,2),'.r');
hold on
plot(seed_bg(:,1),seed_bg(:,2),'.b');

guidata(hObject, handles);


% --------------------------------------------------------------------
function segment_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata( ancestor(hObject, 'figure') ); % recover the handles
a = get(handles.imgPos,'Parent'); % axis of the image
set(a, 'Units', 'pixels');false

% Set all drawing options to 
handles.fgDrawer = false;
handles.bgDrawer = false;
handles.erDrawer = false;

% Extract the seeds for foreground and background
seed_fg = handles.fgData;
seed_bg = handles.bgData;

% Read the image we want to segment
I = handles.image;
handles.imgPos = imshow(I);drawnow;

% Size of the image
w = handles.width; 
h = handles.height;

% Get lambda
lambda = handles.lambda;

%% Primal Dual Segmentation

% add custom functions
addpath(genpath('../functions'))

% Compute the data costs using the color histograms that you computed.
% In case you don't have a working code for the color histograms, uncomment
% the following line.

load colorHist.mat;
% TODO my color hist


% It loads the color histogram for foreground (resp. background) in hist_fg
% (resp. hist_bg)

% We call Ix the unknown function which gives a value between 0 and 1 for 
% every pixel. You can of course use another notation, but be careful in
% that case to change the notation in the code for showing the results.
% You can do the computation with any form you like (vectorized,
% matrix...), however the code which show the evolution of the segmentation
% need Ix to be an h x w matrix where h and w are the size of the image.
% If you work with a vectorized version don't forget to reshape it into
% matrix form before showing the evolution, using the function 'reshape' of 
% matlab.

% Initialize Ix, tau, sigma ...

sigma = 0.35;
tau = 0.35;
theta = 1;

% (x_0, y_0) in X x Y
x = reshape(double(rgb2gray(I)), [], 1);
y = grad(x, [h, w]);
y = y ./ max(y(:));

% x_bar_0 = x_0
x_bar = x;

for k = 1:2000
    
  fprintf('.');
  if(~mod(k,50))
      fprintf(sprintf(' (%d iterations)\n', k));
  end
  
  %% Primal Dual iterations
   
    % precalculate f
    f = f_I(hist_fg, hist_bg, I);   % size: (w*h) x 1
    
        % y_n+1
        grad_xn_bar = grad(x_bar, [h, w]);  % grad(x_bar_n) / size: (w*h) x 2 x ch
        
        y = (y + sigma * grad_xn_bar) ...
            ./ max(1, sqrt(sum ((y + sigma * grad_xn_bar).^2, 2)));
        
        % x_n+1
        div_y = div(y, [h, w]);             % div(y_n+1) / size: (w*h) x 1 x ch
        x_n = x;                % x before update (save temporary for x_bar)
        
        x = min(1, max(0, x - tau * (- div_y) + tau * f));
        
        % x_bar_n+1
        x_bar = x + theta * (x - x_n);
  %% Show evolution
  
  if(k<5 || ~mod(k,50))
      
      % reshape
      Ix = reshape(x, h, w);
      
      handles.imgPos = imshow(I,'Parent', a);
      hold on;
      bw = (Ix > 0.99);
      B = bwboundaries(bw,'holes');
      for l=1:length(B)
          boundary = B{l};
          plot(a, boundary(:,2), boundary(:,1), 'y', 'linewidth', 2.0);
      end
      drawnow;
      
      figure(2)
      imshow(Ix);
      drawnow;
  end

end

%% Show the results

guidata(hObject, handles);
