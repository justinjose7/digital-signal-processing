%% Part 1: Single Stage System
% ECE 310 A | Justin Jose, Chris Kim, David Levi | 11025Hz -> 24000Hz sampling rate converter
% Professor Keene
function out = srconvert1(in);

tic

signal = in;
signal = upsample(signal, 320);

% elliptic filter of order 5, passband ripple of 0.1, stopband attenuation
% of 80, cutoff frequency of pi/320
[B, A] = ellip(5,0.1, 80, 1/320, 'low');
signal = filter(B, A, signal);

signal = downsample(signal, 147);

soundsc(signal, 24000);
out = signal;

toc