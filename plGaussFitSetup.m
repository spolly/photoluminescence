function [start, upper, lower] = plGaussFitSetup(x, initial, myCoeff,...
                                    varargin)
% plGaussFitSetup returns vectors describing initial conditions, as well as 
% upper and lower bounds for the fitting function.
%   Inputs:
%       x: x-values of experimental data [eV] {vector expected}
% initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
% myCoeff: Names of coefficients used in the equation, as output by
%                   plGaussn.m {vector expected}
%   Outputs:
%       start: Starting point of all parameters [various] {vector}
%       upper: Upper bounds of all parameters [various] {vector}
%       lower: Lower bounds of all parameters [various] {vector}
% 
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoluminescence.
%
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.
%En=[1.12, 1.118, 1.154, 1.201, 1.267, 1.32, 1.346, 1.35, 1.362, 1.425];

    erangeF=0.02;        %Value erange determines percentage change allowed    
    EnGplus=1+erangeF;   %via bounds for energy. E.g. 0.02 means 2% higher   
    EnGminus=1-erangeF;  %or lower than the input guess.
    EnGmax=max(x)*0.999;
    EnGmin=min(x)*1.001;

    cGstart=10e-3;
    cGup=80e-3;
    cGlow=1e-5;

    AGstart=5e-2;
    AGup=1e2;
    AGlow=1e-8;

    cLength=length(myCoeff);
    start(cLength)=zeros;
    upper(cLength)=zeros;
    lower(cLength)=zeros;
    initialIndex = 1;
    for i=1:cLength
        switchparam = char(myCoeff(i));
        switch switchparam(1:end-2)
            case 'EnG'
                %First check to make sure the generatated bounds on the 
                %guesses of energy are inside the data, if not set to just 
                %inside the data range.
                if initial(initialIndex)*EnGplus > EnGmax
                    EnGup=EnGmax;
                else
                    EnGup=initial(initialIndex)*EnGplus;
                end
                if initial(initialIndex)*EnGminus < EnGmin
                    EnGlow=EnGmin;
                else
                    EnGlow=initial(initialIndex)*EnGminus;
                end
                if initialIndex == length(initial)
                    start(i)=initial(initialIndex);
                    upper(i)=1.6;
                    lower(i)=1.4;
                else
                    start(i)=initial(initialIndex);
                    upper(i)=EnGup;
                    lower(i)=EnGlow;
                end
                initialIndex = initialIndex + 1;
            case 'cG'
                start(i)=cGstart;
                upper(i)=cGup;
                lower(i)=cGlow;
            case 'AG'
                start(i)=AGstart;
                upper(i)=AGup;
                lower(i)=AGlow;
            % End setup ranges for prFDFF parameters
        end
    end
end