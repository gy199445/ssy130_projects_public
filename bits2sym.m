function [ sym ] = bits2sym( bits )
%BITS2SYM Summary of this function goes here
%   Detailed explanation goes here
%   Transform bits to symbols(QPSK)
sym = sqrt(0.5)*(bits(1:2:end-1) + 1i*bits(2:2:end));
end

