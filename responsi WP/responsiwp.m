opts = detectImportOptions('Real estate valuation data set.xlsx'); %untuk import dataset
opts.SelectedVariableNames = [3:5 8]; %menentukan kolom yang digunakan, disini kolom 3-5 dan kolom 8
data = readmatrix('Real estate valuation data set.xlsx',opts); %membaca data pada kolom terpilih

data = data(1:50,:); %menentukan jumlah data yang dipakai, disini sampai baris ke 50

x = data; %data rating kecocokan dari masing-masing alternatif
k = [0,0,1,0]; %nilai atribut, dimana 0= atribut biaya &1= atribut keuntungan
w = [3,5,4,1]; % bobot untuk masing-masing kriteria

%tahapan pertama, perbaikan bobot
[m n] = size (x); %inisialisasi ukuran x
w = w./sum(w); %membagi bobot per kriteria dengan jumlah total seluruh bobot

%tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)
for j=1:n,
    if k(j)==0, w(j)=-1*w(j);
    end;
end;
for i=1:m,
    S(i)=prod(x(i,:).^w);
end;

%tahapan ketiga, proses perangkingan
V = S/sum(S);

Vtranspose=V.'; %mentransposekan matrix V
opts = detectImportOptions('Real estate valuation data set.xlsx');
opts.SelectedVariableNames = (1); %menentukan kolom yang digunakan, disini kolom 1
DataAlternatif = readmatrix('Real estate valuation data set.xlsx',opts); %membaca data pada kolom terpilih
DataAlternatif = DataAlternatif(1:50,:); %menentukan jumlah data yang dipakai, disini sampai baris ke 50
DataAlternatif = [DataAlternatif Vtranspose]; %menggabungkan 2 matriks
DataAlternatif = sortrows(DataAlternatif,-2); %mengurutkan data alternatif
DataAlternatif = DataAlternatif(1:5,1); %menampilkan 5 baris data alternatif

disp ('Real Estate yang menjadi alternatif terbaik : ')
disp (DataAlternatif) %menampilkan hasil alternatif