function [ sym ] = bits2sym( bits )
%BITS2SYM Summary of this function goes here
%   Detailed explanation goes here
%   Transform bits to symbols(QPSK)
%   mapped 0 to -1, and 1 to 1
b = bits*2-1;
sym = sqrt(0.5)*(b(1:2:end-1) + 1i*b(2:2:end));
end

