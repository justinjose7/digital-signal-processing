%% ECE 310 A | Enhancing Speech by Removing Noise
%% Assignment 2 | Professor Keene
clc, clear all, close all, load projIB
%% Butterworth vs Elliptic (df1, df2, df2sos, and df2tsos realizations)
Gsb_max = -55; %G in dB
Gpb_max = 40;
Gpb_min = 37;

Rp = Gpb_max-Gpb_min; % delta_iir
Rs = Gpb_max-Gsb_max; % zeta_iir

Wp = 2500/(fs/2); % Normalized frequency
Ws = 4000/(fs/2);

[n1,Wn] = buttord(Wp,Ws,Rp,Rs);
[z1,p1,k1] = butter(n1-3, Wn);
[b1, a1] = zp2tf(z1,p1,k1);
[s,g] = zp2sos(z1,p1,k1);

Hdf1_butter = dfilt.df1(b1,a1);
Hdf2_butter = dfilt.df2(b1,a1);
Hdf2sos_butter = dfilt.df2sos(s,g);
Hdf2tsos_butter = dfilt.df2tsos(s,g);

[n2,Wp2] = ellipord(Wp,Ws,Rp,Rs);
[z2,p2,k2] = ellip(n2,Rp,Rs,Wp2); 
[b2,a2] = zp2tf(z2,p2,k2);
[s2,g2] = zp2sos(z2,p2,k2); % Convert to SOS
 
Hdf1_ellip = dfilt.df1(b2,a2);
Hdf2_ellip = dfilt.df2(b2,a2);
Hdf2sos_ellip = dfilt.df2sos(s2,g2);
Hdf2tsos_ellip = dfilt.df2tsos(s2,g2);

%% Pole-Zero Plots for Butter and Ellip realizations
% None appear to be stable as poles lie in right hand plane for all
% realizations.
[zdf1_butter, pdf1_butter, kdf1_butter] = zpk(Hdf1_butter);
[zdf1_ellip, pdf1_ellip, kdf1_ellip] = zpk(Hdf1_ellip);

figure; % df1 realizations
subplot(2,1,1), zplane(zdf1_butter, pdf1_butter), title('Pole-Zero Plot Hdf1 (Butter)');
subplot(2,1,2), zplane(zdf1_ellip, pdf1_ellip), title('Pole-Zero Plot Hdf1 (Ellip)');

[zdf2_butter, pdf2_butter, kdf2_butter] = zpk(Hdf2_butter);
[zdf2_ellip, pdf2_ellip, kdf2_ellip] = zpk(Hdf2_ellip);

figure; %df2 realizations
subplot(2,1,1), zplane(zdf2_butter, pdf2_butter), title('Pole-Zero Plot Hdf2 (Butter)');
subplot(2,1,2), zplane(zdf2_ellip, pdf2_ellip), title('Pole-Zero Plot Hdf2 (Ellip)');

[zdf2sos_butter, pdf2sos_butter, kdf2sos_butter] = zpk(Hdf2sos_butter);
[zdf2sos_ellip, pdf2sos_ellip, kdf2sos_ellip] = zpk(Hdf2sos_ellip);

figure; %df2sos realizations
subplot(2,1,1), zplane(zdf2sos_butter, pdf2sos_butter), title('Pole-Zero Plot Hdf2sos (Butter)');
subplot(2,1,2), zplane(zdf2sos_ellip, pdf2sos_ellip), title('Pole-Zero Plot Hdf2sos (Ellip)');

[zdf2tsos_butter, pdf2tsos_butter, kdf2tsos_butter] = zpk(Hdf2tsos_butter);
[zdf2tsos_ellip, pdf2tsos_ellip, kdf2tsos_ellip] = zpk(Hdf2tsos_ellip);

figure; %df2sos realizations
subplot(2,1,1), zplane(zdf2tsos_butter, pdf2tsos_butter), title('Pole-Zero Plot Hdf2tsos (Butter)');
subplot(2,1,2), zplane(zdf2tsos_ellip, pdf2tsos_ellip), title('Pole-Zero Plot Hdf2tsos (Ellip)');

%% Magnitude Response and Group Delay Plots for Butter and Ellip realizations
[h_df1_butter,w_df1_butter] = freqz(Hdf1_butter, 1000);
[h_df1_ellip,w_df1_ellip] = freqz(Hdf1_ellip, 1000);

[h_df2_butter,w_df2_butter] = freqz(Hdf2_butter, 1000);
[h_df2_ellip,w_df2_ellip] = freqz(Hdf2_ellip, 1000);

[h_df2sos_butter,w_df2sos_butter] = freqz(Hdf2sos_butter, 1000);
[h_df2sos_ellip,w_df2sos_ellip] = freqz(Hdf2sos_ellip, 1000);

[h_df2tsos_butter,w_df2tsos_butter] = freqz(Hdf2tsos_butter, 1000);
[h_df2tsos_ellip,w_df2tsos_ellip] = freqz(Hdf2tsos_ellip, 1000);


figure;
subplot(2,1,1);
plot(w_df1_butter/pi,20*log10(abs(h_df1_butter))), hold
plot(w_df1_ellip/pi,20*log10(abs(h_df1_ellip)))
plot(w_df2_butter/pi,20*log10(abs(h_df2_butter)))
plot(w_df2_ellip/pi,20*log10(abs(h_df2_ellip)))
plot(w_df2sos_butter/pi,20*log10(abs(h_df2sos_butter)))
plot(w_df2sos_ellip/pi,20*log10(abs(h_df2sos_ellip)))
plot(w_df2tsos_butter/pi,20*log10(abs(h_df2tsos_butter)))
plot(w_df2tsos_ellip/pi,20*log10(abs(h_df2tsos_ellip))), hold
axis([0 1 -100 10]);
title('Magnitude Response');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude (dB)')
legend('Location','northeastoutside','Hdf1 (Butter)', 'Hdf1 (Ellip)', 'Hdf2 (Butter)', 'Hdf2 (Ellip) ',...
    'Hdf2sos (Butter)', 'Hdf2sos (Ellip)', 'Hdf2tsos (Butter)', 'Hdf2tsos (Ellip)')

subplot(2,1,2);
grpdelay(h_df1_butter),hold
grpdelay(h_df1_ellip);
grpdelay(h_df2_butter);
grpdelay(h_df2_ellip);
grpdelay(h_df2sos_butter);
grpdelay(h_df2sos_ellip);
grpdelay(h_df2tsos_butter);
grpdelay(h_df2tsos_ellip), hold
title('Group Delay');
legend('Location','northeastoutside','Hdf1 (Butter)', 'Hdf1 (Ellip)', 'Hdf2 (Butter)', 'Hdf2 (Ellip) ',...
    'Hdf2sos (Butter)', 'Hdf2sos (Ellip)', 'Hdf2tsos (Butter)', 'Hdf2tsos (Ellip)')

%% Butterworth
% n = 20, 41 multiplications per input sample (DFII structure)
[h1, w1] = freqz(b1,a1);
figure;
subplot(3,1,1), plot(w1/pi,20*log10(abs(h1)));
title('Magnitude Response for Butterworth');
xlabel('Normalized Frequency(\times\pi rad/sample)'), ylabel('Magnitude (dB)')

subplot(3,1,2), plot(w1/pi,(abs(h1)));
title('Magnitude Response for Butterworth (Focused on Passband Ripple)');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude')
xlim([0 Wp]);

subplot(3,1,3), grpdelay(b1,a1);
title('Group Delay for Butterworth');

y = filter(b1, a1, [1 zeros(1,99)]);

figure;
subplot(2,1,1), zplane(z1, p1);
title('Pole-Zero Plot for Butterworth');
subplot(2,1,2), stem(y);
title('Impulse Response for Butterworth');

costDF2_butter = cost(Hdf2_butter);
%% Elliptic
% n = 8, 17 multiplications per input sample (DFII Structure)
[h2, w2] = freqz(b2,a2);
figure;
subplot(3,1,1), plot(w2/pi,20*log10(abs(h2)));
title('Magnitude Response for Ellip');
xlabel('Normalized Frequency(\times\pi rad/sample)'), ylabel('Magnitude (dB)')

subplot(3,1,2), plot(w2/pi,(abs(h2)));
title('Magnitude Response for Ellip (Focused on Passband Ripple)');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude')
xlim([0 Wp]);

subplot(3,1,3), grpdelay(b2,a2);
title('Group Delay for Ellip');

y = filter(b2, a2, [1 zeros(1,99)]);

figure;
subplot(2,1,1), zplane(z1, p1);
title('Pole-Zero Plot for Ellip');
subplot(2,1,2), stem(y);
title('Impulse Response for Ellip');

costDF2_ellip = cost(Hdf2_ellip);
%% Chebyshev Type I
% n = 11, 23 multiplications per input sample (DFII structure)
[n3, Wp3] = cheb1ord(Wp, Ws, Rp, Rs);
[z3,p3,k3] = cheby1(n3, Rp, Wp3);
[b3, a3] = zp2tf(z3,p3,k3);
[h3, w3] = freqz(b3,a3);

figure;
subplot(3,1,1), plot(w3/pi,20*log10(abs(h3)));
title('Magnitude Response for Cheby I');
xlabel('Normalized Frequency(\times\pi rad/sample)'), ylabel('Magnitude (dB)')

subplot(3,1,2), plot(w3/pi,(abs(h3)));
title('Magnitude Response for Cheby I (Focused on Passband Ripple)');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude')
xlim([0 Wp]);

subplot(3,1,3), grpdelay(b3,a3);
title('Group Delay for Cheby I');

y = filter(b3, a3, [1 zeros(1,99)]);

figure;
subplot(2,1,1), zplane(z3, p3);
title('Pole-Zero Plot for Cheby I');
subplot(2,1,2), stem(y);
title('Impulse Response Cheby I');

Hdf2_cheby1 = dfilt.df2(b3, a3);
costDF2_cheby1 = cost(Hdf2_cheby1);
%% Chebyshev Type II
% n = 11, 23 multiplications per input sample (DFII structure)
[n4, Wp4] = cheb2ord(Wp, Ws, Rp, Rs);
[z4,p4,k4] = cheby1(n4, Rp, Wp4);
[b4, a4] = zp2tf(z4,p4,k4);
[h4, w4] = freqz(b4, a4);

figure;
subplot(3,1,1), plot(w4/pi,20*log10(abs(h4)));
title('Magnitude Response for Cheby II');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude (dB)')

subplot(3,1,2), plot(w4/pi,(abs(h4)));
title('Magnitude Response for Cheby II (Focused on Passband Ripple)');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude')
xlim([0 Wp]);

subplot(3,1,3), grpdelay(b4,a4);
title('Group Delay for Cheby II');

y = filter(b4, a4, [1 zeros(1,99)]);

figure;
subplot(2,1,1), zplane(z4, p4);
title('Pole-Zero Plot for Cheby II');

subplot(2,1,2), stem(y);
title('Impulse Response Cheby II');

Hdf2_cheby2 = dfilt.df2(b4, a4);
costDF2_cheby2 = cost(Hdf2_cheby2);
%% Parks McClellan
% n = 64, 65 multiplications per input sample (DFII structure)
Rp = 10^((Gpb_max-Gpb_min)/20) - 1; % delta_fir
Rs = 10^((Gsb_max - Gpb_max)/20); % zeta_fir
DEV = [Rp Rs];

[n5, fo, mo, w] = firpmord([2500 4000], [1 0], DEV, fs);
b5 = firpm(n5, fo, mo, w);
[z5,p5,k5] = tf2zpk(b5, 1);
[h5, w5] = freqz(b5);


figure;
subplot(3,1,1), plot(w5/pi,20*log10(abs(h5)));
title('Magnitude Response for Parks McClellan');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude (dB)')

subplot(3,1,2), plot(w5/pi,(abs(h5)));
title('Magnitude Response for Parks McClellan (Focused on Passband Ripple)');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude')
xlim([0 Wp]);

subplot(3,1,3), grpdelay(b5,1);
title('Group Delay for Parks McClellan');

y = filter(b5, 1, [1 zeros(1,99)]);

figure;
subplot(2,1,1), zplane(z5, p5);
title('Pole-Zero Plot for Parks McClellan');

subplot(2,1,2), stem(y);
title('Impulse Response Parks McClellan');

Hdf2_pm = dfilt.df2(b5,1);
costDF2_pm = cost(Hdf2_pm);
%% Kaiser
% n = 179, 180 multiplications per input sample (DFII structure)
[n6, Wn, bta, filtype] = kaiserord([2500 4000], [1 0], DEV, fs);
b6 = fir1(n6, Wn, filtype, kaiser(n6+1, bta), 'noscale');
[z6, p6, k6] = tf2zpk(b6, 1);
[h6, w6] = freqz(b6);

figure;
subplot(3,1,1), plot(w6/pi,20*log10(abs(h6)));
title('Magnitude Response for Kaiser');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude (dB)')

subplot(3,1,2), plot(w6/pi,(abs(h6)));
title('Magnitude Response for Kaiser (Focused on Passband Ripple)');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude')
xlim([0 Wp]);

subplot(3,1,3), grpdelay(b6,1);
title('Group Delay for Kaiser');

y = filter(b6, 1, [1 zeros(1,99)]);

figure;
subplot(2,1,1), zplane(z6, p6);
title('Pole-Zero Plot for Kaiser');

subplot(2,1,2), stem(y);
title('Impulse Response Kaiser');

Hdf2_kaiser = dfilt.df2(b6,1);
costDF2_kaiser = cost(Hdf2_kaiser);
%% Magnitude Response/Group Delay Plots of Butterworth, Elliptic, Cheby I, Cheby II, Parks McClellan, and Kaiser
figure;
subplot(2,1,1);
plot(w1/pi,20*log10(abs(h1))), hold
plot(w2/pi,20*log10(abs(h2)))
plot(w3/pi,20*log10(abs(h3)))
plot(w4/pi,20*log10(abs(h4)))
plot(w5/pi,20*log10(abs(h5)))
plot(w6/pi,20*log10(abs(h6))) , hold
axis([0 1 -200 10]);
title('Magnitude Response');
xlabel('Normalized Frequency (\times\pi rad/sample)'), ylabel('Magnitude (dB)')
legend('Location','northeastoutside','Butterworth', 'Elliptic', 'Cheby I', 'Cheby II',...
    'Parks McClellan', 'Kaiser')

subplot(2,1,2);
grpdelay(h1),hold
grpdelay(h2);
grpdelay(h3);
grpdelay(h4);
grpdelay(h5);
grpdelay(h6), hold
title('Group Delay');
legend('Location','northeastoutside','Butterworth', 'Elliptic', 'Cheby I', 'Cheby II',...
    'Parks McClellan', 'Kaiser')

%% Sound Test for Each Filter

% Butterworth
y1 = filter(b1, a1, noisy);
% Elliptic
y2 = filter(b2, a2, noisy);
% Chebyshev I
y3 = filter(b3, a3, noisy);
% Chebyshev II
y4 = filter(b4, a4, noisy);
% Parks McClellan
y5 = filter(b5, 1, noisy);
% Kaiser
y6 = filter(b6, 1, noisy);
% Pass in any of y(1-6) below to test each filter
soundsc(y1, fs);

