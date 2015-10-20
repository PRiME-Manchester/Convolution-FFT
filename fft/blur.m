%% Blur Demo

%Number of iterations
REPS = 1000;
plotsX = 4;
plotsY = 4;

%Import image
%origimage = imread('tonimorrison','png');
origimage = imread('lena','jpg');

%Reduce image to 2-D
origimage = origimage(:,:,1);

%Plot image
figure
subplot(plotsY, plotsX, 1);

imagesc(origimage)
axis image
colormap gray
title('Original Image')
set(gca, 'XTick', [], 'YTick', [])

%% Blur Kernel
ksize = 256;
kernel = zeros(ksize);

%Gaussian Blur
s = 255;
m = ksize/2;
[X, Y] = meshgrid(1:ksize);
kernel = (1/(2*pi*s^2))*exp(-((X-m).^2 + (Y-m).^2)/(2*s^2));

%Display Kernel
%figure;
subplot(plotsY, plotsX ,2);
imagesc(kernel)
axis square
title('Blur Kernel')
colormap gray

[h, w] = size(origimage);
kernelimage = zeros(h,w);
kernelimage(1:ksize, 1:ksize) = kernel;
% Perform 2D Kernel FFT
fftkernel = fft2(kernelimage);
%Gfftkernel = gpuArray(fftkernel);

tic;
%% Embed kernel in image that is size of original image
for i=1:REPS
    tStart = tic;
    
    %Perform 2D image FFT
    fftimage = fft2(double(origimage));

    %Set all zero values to minimum value
    %fftkernel(find(fftkernel == 0)) = 1e-6;
    %fftkernel(fftkernel == 0) = 1e-6;

    %Multiply FFTs
    fftblurimage = fftimage.*fftkernel;

    %Perform Inverse 2D FFT
    blurimage = ifft2(fftblurimage);

    %Display Blurred Image
%     subplot(plotsX, plotsY, i+2);
%     imagesc(blurimage)
%     axis square
%     title('Blurred Image')
%     colormap gray
%     set(gca, 'XTick', [], 'YTick', []);
    
    %t1 = toc;
    tElapsed = toc(tStart);
    minTime = min(tElapsed, Inf);
    
%    origimage = blurimage;
end
averageTime = toc/(REPS);

fprintf(1, 'Minimum time: %.1f ms\n', minTime*1000);
fprintf(1, 'Average time: %.1f ms\n', averageTime*1000);

%disp(minTime);
%disp(averageTime);
