function varargout = responsi(varargin)
% RESPONSI MATLAB code for responsi.fig
%      RESPONSI, by itself, creates a new RESPONSI or raises the existing
%      singleton*.
%
%      H = RESPONSI returns the handle to a new RESPONSI or the handle to
%      the existing singleton*.
%
%      RESPONSI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPONSI.M with the given input arguments.
%
%      RESPONSI('Property','Value',...) creates a new RESPONSI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before responsi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to responsi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help responsi

% Last Modified by GUIDE v2.5 26-Jun-2021 06:31:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @responsi_OpeningFcn, ...
                   'gui_OutputFcn',  @responsi_OutputFcn, ...
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


% --- Executes just before responsi is made visible.
function responsi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to responsi (see VARARGIN)

% Choose default command line output for responsi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes responsi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = responsi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('DATA RUMAH.xlsx'); %untuk import dataset
opts.SelectedVariableNames = (1); %menentukan kolom yang digunakan, disini kolom 1
data1 = readmatrix('DATA RUMAH.xlsx',opts); %membaca data pada kolom terpilih

opts = detectImportOptions('DATA RUMAH.xlsx'); %untuk import dataset
opts.SelectedVariableNames = (3:8); %menentukan kolom yang digunakan, disini kolom 3-8
data2 = readmatrix('DATA RUMAH.xlsx',opts); %membaca data pada kolom terpilih

data = [data1 data2]; %menggabungkan 2 matrix 
set(handles.uitable1,'data',data); %membaca file 'DATA RUMAH.xlsx' dan menampilkan pada uitable1

opts = detectImportOptions('DATA RUMAH.xlsx'); %untuk import dataset
opts.SelectedVariableNames = (3:8); %menentukan kolom yang digunakan, disini kolom 3-8
x = readmatrix('DATA RUMAH.xlsx',opts); %membaca data pada kolom terpilih
k = [0,1,1,1,1,1]; %nilai atribut, dimana 0= atribut biaya &1= atribut keuntungan
w = [0.30,0.20,0.23,0.10,0.07,0.10]; % bobot untuk masing-masing kriteria

%tahapan pertama, normalisasi matriks
[m n] = size(x); %matriks m x n dengan ukuran sebanyak variabel x (input)
R = zeros(m,n); %membuat matriks R, yang merupakan matriks kosong
for j=1:n,
    if k(j)==1, %statement untuk kriteria dengan atribut keuntungan
        R(:,j)=x(:,j)./max(x(:,j));
    else
        R(:,j)=min(x(:,j))./x(:,j);
    end;
end;

%tahapan kedua, proses perangkingan
for i=1:m,
 V(i) = sum(w.*R(i,:));
end;

Vtranspose=V.'; %mentransposekan matrix V
Vtranspose=num2cell(Vtranspose); %mengubah data matrix tanspose menjadi data cell
opts = detectImportOptions('DATA RUMAH.xlsx');
opts.SelectedVariableNames = (2); %menentukan kolom yang digunakan, disini kolom 2
DataAlternatif = readtable('DATA RUMAH.xlsx',opts); %membaca data pada kolom terpilih
DataAlternatif = table2cell(DataAlternatif); %mengubah data alternatif menjadi bentuk data cell
DataAlternatif = [DataAlternatif Vtranspose]; %menggabungkan 2 matriks
DataAlternatif = sortrows(DataAlternatif,-2); %mengurutkan data alternatif
DataAlternatif = DataAlternatif(1:20,1); %menampilkan 20 baris data alternatif

set(handles.uitable2,'data',DataAlternatif); %menampilkan data alternatif pada uitable2

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
