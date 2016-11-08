function [ sym ] = bits2sym( bits )
%BITS2SYM Summary of this function goes here
%   Detailed explanation goes here
%   Transform bits to symbols(QPSK)
QPSK_constellation = [1+1j -1+1j 1-1j -1-1j]/(2^0.5);
paired_bits = buffer(bits,2)';
msg = bi2de(paired_bits,'left-msb')+1;
sym = QPSK_constellation(msg);
end

