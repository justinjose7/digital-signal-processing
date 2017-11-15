function E=poly1(h,M)
%
% Performs type I polyphase decomposition of h in M components.
% The ith row of E corresponds to the ith polyphase component.
% Assumes that the first point of h is index 0.
%
h = [h zeros(1, ceil(length(h)/M)*M-length(h))];
E = reshape(h, M, length(h)/M);
