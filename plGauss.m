function f = plGauss(x, En, c, A)
% plGauss returns a Gaussian function.
%   Inputs:
%        x: Energy [eV] {vector expected}
%       En: Oscillator energy [eV] {scalar expected}
%        c: Standard deviation (HWHM) [eV] {scalar expected}
%        A: Amplitude factor [unitless] {scalar expected}
%   Outputs:
%        f: Gaussian [arb.] {vector}
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoluminescence.
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

f = A.*exp(-((x-En).^2)./(2.*(c.^2)));
end

