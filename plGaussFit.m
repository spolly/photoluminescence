function [myFit , myGof, myArea] = plGaussFit(x, y, initial, varargin)
% plGaussFit returns a fit and a gof against the input x and y data, using 
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
    parse(p,varargin{:});
    
    n=length(initial);
    
    [myEq, myCoeff]=plGaussn(n);
    
    myFitType=fittype(myEq, 'dependent',{'y'},'independent',{'x'},...
    'coefficients', myCoeff);

    [start,upper,lower]=plGaussFitSetup(x, initial, myCoeff);

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
        G_iter=1;
        myGauss=zeros(length(x), n);
        for j=1:n
             myName=strcat('EnG',num2str(G_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myEnG=fitCoeff(boolIndex);

             myName=strcat('cG',num2str(G_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             mycG=fitCoeff(boolIndex);

             myName=strcat('AG',num2str(G_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myAG=fitCoeff(boolIndex);

             myGauss(:,G_iter)=plGauss(x, myEnG, mycG, myAG);
             myArea(:,G_iter)=trapz(plGauss(x, myEnG, mycG, myAG));
             G_iter = G_iter + 1;
         end
         hold on
         plot(x,myGauss, 'linewidth', 1);
         hold off
    end
end
