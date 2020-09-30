# CP - Present Wrapping Problem(PWP)
There are three version of the same minizinc model for the PWP. \
\
The main model is **pwp_v8.mzn** in which the points 1-4 are satisfied.\
The model **pwp_v8-rot.mzn** is an extension of the previous one(*pwp_v9.mzn*) and include also the point 5.\
The model **pwp_v8-same-dim.mzn** is an extension of the *pwp_v9.mzn* model and include also the point 6.

## Instances
Inside the folder '*Instances*' is possible to find several instances of the PW Problem and in the subfolder '*dzn*' there are many instances converted into the input format(dzn) for Minizinc.

## Running the models
It is possible to run all the models simply using Minizinc(https://www.minizinc.org/) or using the PWP notebook(recommended) which is inside the main folder.
