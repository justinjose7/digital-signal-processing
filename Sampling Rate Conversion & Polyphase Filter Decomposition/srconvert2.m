%% Part 2: Multi-stage System
function out = srconvert2(in);
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