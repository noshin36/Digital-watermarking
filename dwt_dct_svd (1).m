chon = 0;
n=6;
while chon~=n
    chon = menu('DWT - DCT - SVD','Cover image','Watermark image','Watermarking','Show Watermarked Image','Show Extracted Image','Exit');
if chon == 1
[fname anhmau]=uigetfile({'*.jpg;*.png;*.tif;*bmp'},'Cover image'); %select image
    Imau=imread(strcat(anhmau,fname)); 
    figure(1),
    imshow(Imau),
    title('cover iamge');
    
    
    Imau = double(imresize(Imau,[512 512],'bilinear'));
        figure(5),
        imshow(Imau),
        title('cover');

    I1=Imau(:,:,1);%get the first color in case of RGB image
    IG=Imau(:,:,2);
    IB=Imau(:,:,3);
end    
    
if chon == 2
[fname anhgiau]=uigetfile({'*.jpg;*.png;*.tif;*bmp'},'Watermark image'); %select image
    
    Igiau=imread(strcat(anhgiau,fname)); 
    figure(2),imshow(Igiau),title('Watermark image');
    Igiau=Igiau(:,:,1);%get the first color in case of RGB image
    I2 = double(imresize(Igiau,[512 512],'bilinear'));
end

if chon == 3
% 4 band c cover
[LL,HL,LH,HH] = dwt2(I1,'haar');
DHL = dct2(HL);
DLH = dct2(LH);
DHH = dct2(HH);

[U1, S1, V1] = svd(DHL);
[U2, S2, V2] = svd(DLH);
[U3, S3, V3] = svd(DHH);

% 4 band watermark

[LL1,HL1,LH1,HH1] = dwt2(I2,'haar');
DHL1 = dct2(HL1);
DLH1 = dct2(LH1);
DHH1 = dct2(HH1);

[UW1, SW1, VW1] = svd(DHL1);
[UW2, SW2, VW2] = svd(DLH1);
[UW3, SW3, VW3] = svd(DHH1);

% Xu Ly
SC1 = S1 + 0.01 * SW1;
SC2 = S2 + 0.01 * SW2;
SC3 = S3 + 0.01 * SW3;

I1_s1 = U1 * SC1 * V1';
I1_s2 = U2 * SC2 * V2';
I1_s3 = U3 * SC3 * V3';

I1_d1 = idct2(I1_s1);
I1_d2 = idct2(I1_s2);
I1_d3 = idct2(I1_s3);



sI = size(I1);
WaterMarked = idwt2(LL, I1_d1, I1_d2, I1_d3, 'haar', sI);
WaterMarked1 = uint8(WaterMarked);
Watermarked_image=cat(3,WaterMarked1,IG,IB); 
imwrite(Watermarked_image,'dwt.bmp','bmp');
imshow(Watermarked_image,[]);
title('Watermarked after Image'); 
end

if chon == 4
figure(3); 
imshow(Watermarked_image,[]);
title('Watermarked after Image'); 
 
end

if chon == 5
    ex_dwt_dct_svd();
end


end
