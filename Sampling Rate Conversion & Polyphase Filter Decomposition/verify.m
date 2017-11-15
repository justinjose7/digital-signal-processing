function yes = verify(h)
%
% Verifies that h meets all the specifications given in the
% handout. Returns a 1 if all specifications are met.


[R,G,A]=examlpf(h,147/320,147/320*1.2);


% passband magnitude

yes		= R <=0.1;
subplot(3,1,1)

if R <=0.1
	title(['Passband Response,  Ripple = ' num2str(R) ' dB, OK']);
else
	title(['Passband Response,  Ripple = ' num2str(R) ' dB, too big']);
end

% Group delay
subplot(3,1,2)
if G <= 720
	title(['Group Delay in Passband, max-min = ' num2str(G) ', OK'])
else
	title(['Group Delay in Passband, max-min = ' num2str(G) ', too big'])
end
yes		= yes*(G <= 720);

% Stopband magnitude

subplot(3,1,3)
if A <=-70
	title(['Overall Response , Attenuation = ' num2str(A) ' dB, OK']);
else
	title(['Overall Response , Attenuation = ' num2str(A) ' dB, too small']);
end

yes		= yes * (A <= -70);


sprintf('Passband Ripple:       %5.3f dB \n',R)
sprintf('Groupdelay Variation:  %5d   samples \n',G)
sprintf('Stopband Attenuation:  %5.3f dB \n',A)


return




