

error = [];
iteration_num = 500000;
phase_H = angle(H);
phase_matrix = linspace(-pi,pi,256);

e = mean((abs(R(:))-T(:)).^2);

erro = e;

for i=1:iteration_num
    m = randi(512/space);
    n = randi(512/space);
    k = randi(256);
    
    H_new = H;
    H_new(m,n) = abs(H(m,n))*exp(1i*phase_matrix(k));
    R_new = fft2(H_new); % re-calculate the whole replay

    e2 = mean((abs(R_new(:))-T(:)).^2);
    if e > e2
        H(m,n) = abs(H(m,n))*exp(1i*phase_matrix(k));
        e = e2;
        R = R_new;    
    end
    
    if rem(i,1e3) == 0 % hologram not 100% efficient, obviously - boost the amplitude boost of the incident beam  
        avgR = mean(abs(R(:)));

        H   = ifft2(R * 1/avgR*avgT);
        R   = fft2(H);
        erro = mean((abs(R(:))-T(:)).^2);
    end
    
    if rem(i,1000) == 0
        figure(123)
        subplot(1,2,1)
        semilogy(1:i-1,error, '.-')
        subplot(1,2,2)
        imagesc(abs(R))
    end
    error = [error; e]; 

end

	figure
	subplot(2,1,1);
	imagesc(T);
	title('Original image')
	subplot(2,1,2);
	imagesc(abs(R))               %last pattern
	title('reconstructed image');
	figure
	i = 1:1:i;
	plot(i,(error'));
	title('Error');
	figure
	imagesc(abs(R)) %last pattern
	title('reconstructed image');
	
	toc;