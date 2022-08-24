% Gerchberg Saxton Algorithm(Source, Target, Retrieved_Phase)
%  A = IFT(Target)
%  while error criterion is not satisfied
%    B = Amplitude(Source) * exp(i*Phase(A))
%    C = FT(B)
%    D = Amplitude(Target) * exp(i*Phase(C))
%    A = IFT(D)
%  end while
%  Retrieved_Phase = Phase(A)
%---------------------------------------------------------
% %-------------------------------------------------------
% calculate input beam or input intensity,
% in this example a gaussian beam was selected, 
clear all; close all;
tic;
	x = linspace(-10,10,1024);
	y = linspace(-10,10,1024);
	[X,Y] = meshgrid(x,y);
	x0 = 0;     		% center
	y0 = 0;     		% center
	sigma = 2; 			% beam waist
	A = 1;      		% peak of the beam 
	res = ((X-x0).^2 + (Y-y0).^2)./(2*sigma^2);
	input_intensity = A  * exp(-res);
	surf(input_intensity);
	shading interp 
%---------------------------------------------------------
	Target=rgb2gray(imresize(imread('Sample_Image.tiff'),[1024,1024]));
	Target=double(Target);
	A = fftshift(ifft2(fftshift(Target)));
	error = [];
	iteration_num = 50;
	%hologram = |objectWave + referenceWave|.^2
    
for i=1:iteration_num
  B = abs(input_intensity) .* exp(1i*angle(A));
  C = fftshift(fft2(fftshift(B)));
  D = abs(Target) .* exp(1i*angle(C));
  A = fftshift(ifft2(fftshift(D)));
  error = [error; sum(sum(abs(1.32*abs(C) - abs(Target))))];   
end
	figure
	subplot(2,1,1);
	imagesc(Target);
	title('Original image')
	subplot(2,1,2);
	imagesc(abs(C))               %last pattern
	title('reconstructed image');
	figure
	i = 1:1:i;
	plot(i,(error'));
	title('Error');
	figure
	imagesc(abs(C)) %last pattern
	title('reconstructed image');
	
	toc;