function [myFit, myGof, myArea, myGauss] = plGaussFit(x, y, Eini, varargin)
% plGaussFit returns the MATLAB structs fitobject, goodness of fit,  and
% the numerically integrated (trapezoidal method) area of each Gaussian
% testArea and the output of the call to plGauss.m with the results of each
% component Gaussian in testGauss so they can easily be plotted or copied 
% to another program, against the input x and y data, using 
% the sum of n oscillators defined by plGauss.
%   Inputs:
%       x: x-values of experimental data (energy) [eV] {vector expected}
%       y: y-values of experimental data (photoluminescence) [unitless] 
%           {vector expected}
%       initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
%   Outputs:
%       myFit: MATLAB fit [various] {cfit}
%       myGof: MATLAB goodness of fit [various] {struct}
%       myArea: Trapezoidal integrated area of fits {array}
%       myGauss: Output of Gaussian function {array}
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoluminescence.
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3. 

    p = inputParser;
    addOptional(p,'plotFitOnly','false');
    addOptional(p,'plotAll','true');
    addOptional(p,'cini',nan(length(Eini)));
    addOptional(p,'Aini',nan(length(Eini)));
    parse(p,varargin{:});

    n=length(Eini);
    
    [myEq, myCoeff]=plGaussn(n);
    
    myFitType=fittype(myEq, 'dependent',{'y'},'independent',{'x'},...
    'coefficients', myCoeff);

    [start,upper,lower]=plGaussFitSetup(x, Eini, myCoeff, ...
        p.Results.cini, p.Results.Aini);

    [myFit,myGof]=fit(x,y,myFitType,'StartPoint', start, 'Upper', upper,...
        'Lower', lower, 'MaxFunEvals', 5000, 'MaxIter', 5000,...
        'TolFun', 1e-10, 'TolX', 1e-10, 'DiffMinChange', 1e-12);

    %Build plots based on variable inputs
    if strcmp(p.Results.plotFitOnly, 'true')
        myPlot=plot(myFit,'k',x,y);
        set(myPlot,'LineWidth', 3);
    elseif strcmp(p.Results.plotAll, 'true')
        myPlot=plot(myFit,'k',x,y);
        set(myPlot,'LineWidth', 3);
        fitCoeff=coeffvalues(myFit);
        fitCoeffNames=coeffnames(myFit);
        myGauss=zeros(length(x), n);
        myArea(n)=zeros;
        for j=1:n
             myName=strcat('EnG',num2str(j,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myEnG=fitCoeff(boolIndex);

             myName=strcat('cG',num2str(j,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             mycG=fitCoeff(boolIndex);

             myName=strcat('AG',num2str(j,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myAG=fitCoeff(boolIndex);

             myGauss(:,j)=plGauss(x, myEnG, mycG, myAG);
             myArea(j)=trapz(plGauss(x, myEnG, mycG, myAG));
         end
         hold on
         plot(x,myGauss, 'linewidth', 1);
         hold off
    end
end
