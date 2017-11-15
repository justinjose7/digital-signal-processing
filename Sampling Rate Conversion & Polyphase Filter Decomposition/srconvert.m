%% ECE 310 A | Justin Jose, Chris Kim, David Levi | 11025Hz -> 24000Hz sampling rate converter
%% Code for srconvert(in) | Professor Keene

%% Part 1: Single Stage System
function out = srconvert(in);
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
%% Part 2: Multi-stage System
function out = srconvert(in);

tic

signal = in;

factorsOfL = [8 8 5];

N     = 360;   % Order
Ap = 0.01;  % Passband Ripple (dB)
Ast = 85;   % Stopband Attenuation (dB)

Rp  = (10^(Ap/20) - 1)/(10^(Ap/20) + 1); % deviation of passband ripple
Rst = 10^(-Ast/20); % deviation of stopband attenuation

for i = 1:3
    signal = upsample(signal, factorsOfL(i));
    fc = 1/factorsOfL(i);
    B = firceqrip(N,fc,[Rp Rst], 'passedge');
    signal = conv(B, signal); 

end
  
signal = downsample(signal, 147);

soundsc(signal, 24000);
out = signal;

toc

%% Part 3: Multi-stage Poly-Phased System
function out = srconvert(in);
tic
signal = in;
factorsOfL = [8 8 5];

N     = 360  % Order
Ap = 0.01;  % Passband Ripple (dB)
Ast = 85;   % Stopband Attenuation (dB)

Rp  = (10^(Ap/20) - 1)/(10^(Ap/20) + 1);
Rst = 10^(-Ast/20);
% filters for interpolation
B8 = firceqrip(N,1/8,[Rp Rst], 'passedge');
B5 = firceqrip(N,1/5,[Rp Rst], 'passedge');

% decompose filters into the polyphase filters for each interpolation stage
polyFilters8 =  poly1(B8,8);
polyFilters5 =  poly1(B5,5);

% initialize each stage output to 0
stage1 = zeros();
stage2 = zeros();
stage3 = zeros();

for i = 1:8
    signal = conv(polyFilters8(i, :),in); % convolve correct filter with input signal
    signal = upsample(signal, 8, i-1); % i-1 indicates delay
    stage1 = stage1 + signal;
end
for i = 1:8
    signal = conv(polyFilters8(i, :),stage1); % convolve with output of stage 1
    signal = upsample(signal, 8, i-1);
    stage2 = stage2 + signal;
end
for i = 1:5
    signal = conv(polyFilters5(i, :),stage2); % ...
    signal = upsample(signal, 5, i-1);
    stage3 = stage3 + signal;
end
signal = downsample(stage3, 147);
toc
soundsc(signal, 24000);
out = signal;

