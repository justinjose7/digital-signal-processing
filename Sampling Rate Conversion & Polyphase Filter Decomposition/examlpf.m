
function [maxripple,gdvariation,atten]=examlpf(h,wp,ws)

% function [R,G,A]=examlpf(h,wp,ws)
%
% Plots the DFT of the lowpass filter whose impulse response is h.
% The arguments wp, and ws denotes the passband and stopband cutoff 
% frequency normalized by pi.
% Plot 1: zooms in the passband and measures the ripple size (R).
% Plot 2: shows group delay in the passband, measuring the difference 
%         between the max-min in grd (G)
% Plot 3: shows the entire magnitude frequency response, and measures
%         the stopband attenuation (A).
% 


fftlength = 1024*8;
ffth	= db20(fft(h,fftlength));

ind	= round(wp*fftlength/2);

meandb	= mean(ffth(1:ind));

subplot(3,1,1)
plot((1:ind)/fftlength*2,ffth(1:ind));
maxripple	= max(abs(ffth(1:ind)-meandb));
title(['Passband Response,  Ripple = ' num2str(maxripple) ' dB']);
xlabel('\omega / \pi')
ylabel('dB')

subplot(3,1,2)
[gd,w]		= grpdelay(h,1,fftlength/2);
maxgd		= max(gd(1:ind));
mingd		= min(gd(1:ind));
gdvariation	= abs(maxgd-mingd);
plot(w(1:ind)/pi,gd(1:ind));
title(['Group Delay in Passband, max-min = ' num2str(gdvariation)])
xlabel('\omega / \pi');
ylabel('Samples');

subplot(3,1,3)

atten		= max(ffth(round(ws*fftlength/2):fftlength/2)-meandb);
plot((1:fftlength)/fftlength*2,ffth)
title(['Overall Response , Attenuation = ' num2str(atten) ' dB']);
xlabel('\omega / \pi');
ylabel('dB')

return
