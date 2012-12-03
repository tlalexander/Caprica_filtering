Caprica Filtering
===========================

This applications allows investigation of filtering techniques on raw data sample files in the data directory.

Currently the filter is an Aplha Beta filter with code taken from wikipedia:
http://en.wikipedia.org/wiki/Alpha_beta_filter#Sample_Program

It also uses a moving average filter before the Alpha Beta filter, averaging the last 5 samples.

Varying the mouse position changes Alpha and Beta values. Clicking the mouse toggles the display from the speed variable to the velocity variable.

This sketch uses an external library for graphs. Make sure to download and install it:
http://gicentre.org/utils/

TODO:
Determine and and implement optimal filtration techniques to get useful and accurate speed and position data from the dataset.
Investigate use of a median filter to replace the mean filter.
Reconcile the differences in the equations provided by Wikipedia and this page: http://www.mstarlabs.com/control/engspeed.html
Some improvements could be made to the processing sketch, including GUI data file selecting and pan and zoom of data display regions.

See also:
http://code.eng.buffalo.edu/tracking/papers/tenne_optimalFilter2000.pdf