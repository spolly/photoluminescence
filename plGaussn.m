function [myEq,myCoeff]=plGaussn(n)
% plGaussn builds a string defining the sum of (n) Gaussian functions of 
% the equation presented in plGauss.m, as well as a vector of corrisponding 
% coefficient names.
%   Inputs:
%       n: Number of Gaussians to use [unitless] {scalar expected}
%   Outputs:
%       myEq: Equation to use in building a fittype {string}
%       myCoeff: List of parameter names used in myEq {vector}
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoluminescence.
%
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    myEq='';
    myCoeff={};
    for i=1:n
        nGx=num2str(i,'%02d');
        EnGx=strcat('EnG',nGx);
        cGx=strcat('cG',nGx);
        AGx=strcat('AG',nGx);     
        %f = plGauss(x, Eg, c, A)
        myEq=strcat(myEq, 'plGauss(x, ', EnGx, ', ', cGx, ', ', AGx,...
            ') +');
        myCoeff=horzcat(myCoeff, {EnGx, cGx, AGx});
    end
    %remove trailing ' +'
    myEq=myEq(1:end-2);
end

