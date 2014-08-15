function [start, upper, lower] = plGaussFitSetup(x, initial, myCoeff,...
                                     testc, testA)
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

    erangeF=0.004;       %Value erange determines percentage change allowed    
    EnGplus=1+erangeF;   %via bounds for energy. E.g. 0.02 means 2% higher   
    EnGminus=1-erangeF;  %or lower than the input guess. 004 used for PR
    EnGmax=max(x)*0.999;
    EnGmin=min(x)*1.001;

    cGstart=10e-3;  %Half-width half-max (HWHM) starting point
    cGup=25e-3;     %HWHM maximum
    cGlow=1e-5;     %HWHM minimum

    AGstart=5e-2;   %Amplitude starting point
    AGup=1e2;       %Amplitude maximum
    AGlow=1e-8;     %Amplitude minimum

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
                    start(i)=initial(initialIndex);
                    upper(i)=EnGup;
                    lower(i)=EnGlow;                
            case 'cG'
                if testc(initialIndex)==0
                    start(i)=cGstart;
                else
                    start(i)=testc(initialIndex);
                end
                upper(i)=cGup;
                lower(i)=cGlow;
            case 'AG'
                if testA(initialIndex)==0
                    start(i)=AGstart;
                else
                    start(i)=testA(initialIndex);
                end
                start(i)=AGstart;
                upper(i)=AGup;
                lower(i)=AGlow;
                initialIndex = initialIndex + 1;
        end
    end
end