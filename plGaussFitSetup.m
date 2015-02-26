function [start, upper, lower] = plGaussFitSetup(x, Eini, myCoeff, cini, Aini)
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

%=====User editable to change functionality and range======================
    %Value erange determines percentage change allowed
    %via bounds for energy. E.g. 0.02 means 2% higher
    %or lower than the input guess. 0.004 used for PR
    %see https://github.com/spolly/photoreflectance
    erangeF=0.004; %[eV]          
    
    %Boundary conditions
    cGstart=10e-3;  %Half-width half-max (HWHM) starting point [eV]
    cGup=25e-3;     %HWHM maximum [eV]
    cGlow=1e-5;     %HWHM minimum [eV]

    AGstart=5e-2;   %Amplitude starting point [arb.]
    AGup=1e2;       %Amplitude maximum [arb.]
    AGlow=1e-8;     %Amplitude minimum [arb.]
    
%==========================================================================
    
    EnGplus=1+erangeF;     
    EnGminus=1-erangeF;  
    EnGmax=max(x)*0.999; 
    EnGmin=min(x)*1.001;

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
                if Eini(initialIndex)*EnGplus > EnGmax
                    EnGup=EnGmax;
                else
                    EnGup=Eini(initialIndex)*EnGplus;
                end
                if Eini(initialIndex)*EnGminus < EnGmin
                    EnGlow=EnGmin;
                else
                    EnGlow=Eini(initialIndex)*EnGminus;
                end
                start(i)=Eini(initialIndex);
                upper(i)=EnGup;
                lower(i)=EnGlow;                
            case 'cG'
              if isnan(cini(initialIndex))
                    start(i)=cGstart;
              else
                    start(i)=cini(initialIndex);
              end
                upper(i)=cGup;
                lower(i)=cGlow;
            case 'AG'
               if isnan(Aini(initialIndex))
                    start(i)=AGstart;
               else
                   start(i)=Aini(initialIndex);
               end
                start(i)=AGstart;
                upper(i)=AGup;
                lower(i)=AGlow;
                initialIndex = initialIndex + 1;
        end
    end
end