photoluminescence
================

Functions for extracting parameters from photoluminescence data.

These files were created in MATLAB R2013a.

Copyright 2014 Stephen J. Polly, RIT  
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License v3.

Acknowledgement
--------------
This work was supported in part by the National Science Foundation under Grant DMR-0955752, and the US Department of Education GAANN Fellowship P200A090225.

Dependencies
--------------
This project requires the Curve Fitting Toolbox in MATLAB.

Function Files
--------------

* `plGauss.m` Calculates a Gaussian function for a given set of inputs.
* `plGaussFit.m` Performs a fit of (n) Gaussian function against input data.
* `plGaussFitSetup.m` Sets starting conditions, as well as upper and lower bounds for the fit performed by `plGaussFit.m`.
* `plGaussn.m` Defines a fittype string and vector of coefficients necessary to fit (n) oscillators with.  


How to use these scripts
------------------------

###To produce an example Gaussian plot
Files needed:
* `plGauss.m`  

For, e.g. GaAs:  
First create a column vector of energies to plot over, here 1.3 to 1.5 eV in steps of 1 meV:

```matlab
E = (1.3 : 0.001 : 1.5)';
```

Then calculate the corresponding PL signal with a call to `plGauss.m`. In this example:
* En = 1.42 eV (Center of the signal)
* c = 0.1 eV (half-width half-max of the signal)
* A = 10 (amplitude of the signal) 


```matlab
PL = plGauss(E, 1.42, 0.1, 10);
```

Which is then plotted:

```matlab
plot(E, PL);
```

Please see the comments at the top of `plGauss.m` for more information.


###To fit data against (n) Gaussians:
Files needed:
* `plGauss.m` 
* `plGaussFit.m` 
* `plGaussFitSetup.m` 
* `plGaussn.m` 

Import experimental data to MATLAB. In this example, x-data is 'E' and y-data is 'PL'.
Make a vector of educated guesses of where the oscillators lie:

```matlab
initial = [1.21,1.38,1.42];
```

Make a call to `plGaussFit.m` using the experimental data and the 'initial' vector. Here we set testFit and testGOF to the fit output and goodness of fit output, respectively. Since the vector 'initial' has 3 values, a 3-oscillator fit will be created and used. Other outputs are the integrated areas of each Gaussian, as well as the data of each Gaussian, as though it was called by the output of each fit as described above.

```matlab
[testFit, testGOF, testArea, testGauss] = prTDFFFit(E, PL, initial);
```

The fitting process flow is as follows:
`plGaussFit.m` calls `plGaussn.m` which returns the equation to fit against, as well as all coefficients in a vector. 
It then creates a fittype, followed by a call to `plGaussFitSetup.m` where the starting point, and upper and lower bounds
are set. If the fit() is resulting in poor fits or is hitting boundaries, they should be changed within the setup file.
The fit() is then performed. Here the tolerance and number of iterations can be changed. Finally any plotting is
performed. Outputs are the MATLAB structs fitobject as `testFit` and goodness of fit `testGOF` as well as the numerically integrated (trapezoidal method) area of each Gaussian `testArea` and the output of the call to `plGauss.m` with the results of each component Gaussian in `testGauss` so they can easily be plotted or copied to another program.

