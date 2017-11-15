%% Part 3: Multi-stage Poly-Phased System
function out = srconvert3(in);
tic
signal = in;
factorsOfL = [8 8 5];

N     = 360;  % Order
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