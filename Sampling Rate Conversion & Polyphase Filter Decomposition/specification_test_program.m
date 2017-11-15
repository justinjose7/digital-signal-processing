%% ECE 310 A | Justin Jose, Chris Kim, David Levi | 11025Hz -> 24000Hz sampling rate converter
%% Design Specification Check Figures
%% Part 1: Single Stage System
part1 = srconvert1([1 zeros(1, 3000)]);
p1 = figure;
p1.Name = 'Part 1: Single-Stage';
p1DesignSpecs = verify(part1);

%% Part 2: Multi-stage System
part2 = srconvert2([1 zeros(1, 3000)]);
p2 = figure;
p2.Name = 'Part 2: Multi-Stage';
p2DesignSpecs = verify(part2);

%% Part 3: Multi-stage Polyphased System
part3 = srconvert3([1 zeros(1, 3000)]);
p3 = figure;
p3.Name = 'Part 3: Multi-Stage Polyphased';
p3DesignSpecs = verify(part3);

%% Audio test
[signal, fs] = audioread('wagner.wav');
%Comment out what you don't want to hear
%srconvert1(signal);
%srconvert2(signal);
srconvert3(signal);
