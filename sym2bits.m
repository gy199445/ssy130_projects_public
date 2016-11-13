function [ bits ] = sym2bits( symbols )
%SYM2BITS Summary of this function goes here
%   Detailed explanation goes here
%   map symbols to bits
bits = [sign(real(symbols)); sign(imag(symbols))];
bits = bits(:)';
%finally map -1 to 0, 1 to 1
bits = bits>0;
end

