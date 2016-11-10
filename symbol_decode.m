function [ b ] = symbol_decode( r_ )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   implement equ 11 on project memo:
%   b_hat(2k) = sgn(Real{conj(H).*r})
%   b_hat(2k+1) = sgn(Imag{conj(H).*r})
r_real = real(r_);
r_imag = imag(r_);
b_even = r_real>0;
b_odd = r_imag>0;
b = reshape([b_odd,b_even],[256,1])';
end

