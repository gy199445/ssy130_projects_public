function [ pn ] = pn_gen( l,InitialConditions,Polynomial )
%PN_GEN Summary of this function goes here
%   Detailed explanation goes here
%   PN sequence generator
%   l:length of desired pn code;
%   InitialConditions, Polynomial
H = comm.PNSequence;
H.Polynomial = Polynomial;
H.SamplesPerFrame = l;
H.InitialConditions = InitialConditions;
pn = step(H)';
end

