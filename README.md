# Present-Wrapping-Problem-Project
Project Work - Combinatorial Decision Making and Optimization

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Installation for Windows

```
Python Version 3.6
Anaconda 1.9.12
```

### Installing

Create a new conda environment
```
conda create -n PWP python=3.6
```

Install all the packeges listed in requirements.txt
```
conda install --yes --file requirements.txt
```

## Running the CP model
At first it is necessary to run all the cells before the CP part of the notebook (*imports*-1° cell, *Accessory Functions* cells)\
The general use of the model is the following:
- having a reference model **model_name**="model name"
- having an instance **instance_name**="instance name"
- load the instance in order to have: **pr_w**(paper roll's width), **pr_h**(paper roll's height), **n_pieces**(number of pieces in that instance), **L**(the dimension of each pieces)
- running the Minizinc model using python(inside the notebook) to get the solution/s
- using the *print_solutions* function to have a graphically solution/s printing
- using the *save_solution* function to store locally one or more solutions for that instance

### TEST 1.1
Number of solutions (#) and failures when looking for all solutions to some instances of the PW problem, comparing the ordering of pieces or not, using the default search.

- Inside the model(**pwp_v9.mzn**) set 'bool: independent_solving_on_w = false;'(line 22)
- Comment all the search_ann lines at the end of the model(from line 77 to 82)
- Comment also the **"Symmetry breaking rules"** part(from line 52 to 54)
- run the test three times changing the value to the variable **ord_type**('no-ord'|'ord'|'decr-ord')

#### Results
\- : over 5 minutes of searching\
/ : unknown value

| n | # | v9_no-ord time[s] | v9_no-ord failures | v9_ord time[s] | v9_ord failures | v9_decr-ord time[s] | v9_decr-ord failures |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 8x8 | 12 | 0 | 2 | 0 | 2 | 0 | 3 |
| 9x9 | 24 | .001 | 4 | .001| 4 | .001| 21 |
|10x10|	64 | .002 | 58 | .003 | 58 | .003 | 58 |
|11x11 | 128 | .011 | 422 | .011 | 426 | .014 | 554|
|13x13 | 1568 | .115 | 3421 | .109 | 3368 | .115 | 3674|
|14x14 | 1344 | .082 | 1110 | .082 | 1149 | .099 | 2602|
|15x15 | 10752 | .766 | 9068 | .772 | 9068 | 1,086 | 23246|
|16x16 | 2304 | .162 | 2170 | .171 | 2149 | .218 | 2052|
|17x17 | 97856 | 14.64 | 237574 | 12,897 | 177718 | 35,886 | 980848|
|18x18 | / | - | - | - | - | - | -|
|19x19 | / | - | - | - | - | - | -|
|20x20 | 566784 | 77.84 | 2681267 | 85 | 2626486 | - | -|
|21x21 | / | - | - | - | - | - | -|

### TEST 1.2
The same test as before but with the **'Symmetry breaking rules'** enabled.

- (**as before**) Inside the model(**pwp_v9.mzn**) set 'bool: independent_solving_on_w = false;'(line 22)
- (**as before**) Comment all the search_ann lines at the end of the model(from line 77 to 82)
- **Uncomment** also the **"Symmetry breaking rules"** part(from line 52 to 54)
- (**as before**) run the test three times changing the value to the variable **ord_type**('no-ord'|'ord'|'decr-ord')

#### Results
\- : over 5 minutes of searching\
/ : unknown value

| n | # | v9_no-ord time[s] With symm | v9_no-ord failures With symm | v9_ord time[s] With symm | v9_ord failures With symm | v9_decr-ord time[s] With symm | v9_decr-ord failures With symm |
| --- | --- | --- | --- | --- | --- | --- | --- |
|8x8 | 3 | 0 | 1 | 0 | 1 | 0 | 1|
|9x9 | 16 | 0 | 3 | .001 | 3 | .001 | 10|
|10x10 | 22 | .001 | 29 | .002 | 29 | .001 | 34|
|11x11 | 32 | .003 | 121 | .003 | 121 | .003 | 120|
|12x12 | 48 | .004 | 123 | .004 | 123 | .003 | 120|
|13x13 | 532 | .047 | 1328 | .046 | 1299 | .045 | 1352|
|14x14 | 336 | .022 | 327 | .019 | 327 | .021 | 335|
|15x15 | 6272 | .438 | 5016 | .445 | 5424 | .462 | 5941|
|16x16 | 576 | .038 | 577 | .04 | 575 | .039 | 565|
|17x17 | 24464 | 2.576 | 72033 | 3,856 | 568870 | 3,22 | 78653|
|18x18 | / | - | - | - | - | - | -|
|19x19 | 1383360 | 185.543 | 5231506 | 182.956 | 5233576 | - | -|
|20x20 | 141696 | 15.854 | 434603 | 17.104 | 434203 | 20.927 | 751911|
|21x21 | 478656 | 76.467 | 1985506 | 79.032 | 1972509 | 79.75 | 2219187|

**With the default search the best model is: incremental order pieces**

### TEST 2
Number of failures when looking for all solutions(with symm breaking) using different search heuristics (managed the descending order inside the model based on the area value).

- (**as before**) Inside the model(**pwp_v9.mzn**) set 'bool: independent_solving_on_w = false;'(line 22)
- Comment and uncomment by hands from the first search_ann line to the last (from line 77 to 82)
- (**as before**) **Uncomment** also the **"Symmetry breaking rules"** part(from line 52 to 54)
- run the test two times changing the value to the variable **ord_type**('ord'|'decr-ord')


#### Results
\* : best result\
bold value : time limit reached(5 minutes)

|n | Input-min v9_ord | Input-min v9_decr-ord | ff-min v9_ord | ff-min v9_decr-ord | DomWdeg-min v9_ord | DomWdeg-min v9_decr-ord | Input-rand v9_ord | Input-rand v9_decr-ord | ff-rand v9_ord | ff-rand v9_decr-ord | DomWdeg-rand v9_ord | DomWdeg-rand v9_decr-ord|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|8x8 | 0* | 0* | 2 | 2 | 2 | 2 | 1 | 1 | 2 | 2 | 2 | 2|
|9x9 | 3* | 3* | 3* | 3* | 3* | 3* | 4 | 4 | 4 | 4 | 4 | 4|
|10x10 | 8* | 8* | 8* | 8* | 10 | 10 | 11 | 11 | 12 | 12 | 12 | 12|
|11x11 | 46 | 46 | 43* | 43* | 49 | 49 | 48 | 48 | 44 | 44 | 47 | 45|
|12x12 | 70 | 70 | 60* | 60* | 96 | 96 | 100 | 100 | 77 | 77 | 90 | 90|
|13x13 | 1064* | 1079 | 1075 | 1073 | 1120 | 1120 | 1168 | 1130 | 1171 | 1141 | 1174 | 1195|
|14x14 | 448 | 445 | 265 | 269 | 262 | 261* | 493 | 501 | 315 | 313 | 300 | 316|
|15x15 | 4029 | 4354* | 5098 | 5039 | 5073 | 4997 | 4929 | 4834 | 5481 | 5457 | 5471 | 5441|
|16x16 | 583 | 573 | 583 | 573 | 524* | 588 | 581 | 587 | 581 | 587 | 593 | 582|
|17x17 | 75311 | 76210 | 50606 | 51214 | 49866* | 50859 | 84216 | 85261 | 54832 | 54260 | 54970 | 56626|
|18x18 | **11925446** | **11935654** | **9123160** | **9191395** | **8695525** | __8633719*__ | **10751176** | **10834891** | **11986136** | **11531960** | **12141790** | **11018706**|
|19x19 | 3663131 | 3666035 | 3209023 | 3211247 | 3217267* | 3213256 | 4088981 | 4137855 | 3608068 | 3635708 | 3587009 | 3597849|
|20x20 | 430396 | 370630 | 447872 | 371263 | 434203 | 371235* | 467476 | 420972 | 478043 | 434628 | 470117 | 408973|
|21x21 | 1719412-70 | 1721371-71 | 1419547-69 | 1437661-66 | 1418944*-68 | 1436707-69 | 1941636-77 | 1949438-74 | 1587390-65 | 1609090-67 | 1590398-65 | 1607347-67|

**DomWdeg-min: The best on the 5 largest instances**

### TEST 3
time and failures to find at least one solution(the first one) for each instance.

- Inside the model(**pwp_v9.mzn**) set 'bool: independent_solving_on_w = independent_solving_on_w_possible();'(line 22)
- (**as before**) **Uncomment** also the **"Symmetry breaking rules"** part(from line 52 to 54)
- run the test six times changing the searching strategy by hands(I-min, ff-min, DomWdeg-min, I-rand, ff-rand, DomWdeg-rand)

#### Results
\- : over 5 minutes of searching\

|n | Input-min **time**[s] | Input-min **failures** | ff-min **time**[s] | ff-min **failures** | DomWdeg-min **time**[s] | DomWdeg-min **failures** | Input-rand **time**[s] | Input-rand **failures** | ff-rand **time**[s] | ff-rand **failures** | DomWdeg-rand **time**[s] | DomWdeg-rand **failures**|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|8x8   | 0    | 0      | 0    | 0      | 0    | 0      | .001  | 1      | .001 | 1     | 0    | 0|
|9x9   | 0    | 0      | .001 | 0      | .001 | 0      | 0     | 0      | 0    | 0     | 0    | 0|
|10x10 | 0    | 0      | 0    | 0      | 0    | 0      | 0     | 2      | 0    | 2     | 0    | 2|
|11x11 | 0    | 5      | .001 | 5      | 0    | 5      | .001  | 17     | .001 | 17    | .001 | 17|
|12x12 | .001 | 14     | .001 | 11     | 0    | 4      | 0     | 2      | 0    | 5     | .001 | 24|
|13x13 | 0    | 2      | .001 | 2      | .001 | 2      | .002  | 108    | .002 | 108   | .002 | 114|
|14x14 | 0    | 0      | 0    | 0      | 0    | 0      | .001  | 8      | .001 | 8     | 0    | 8|
|15x15 | 0    | 0      | 0    | 0      | 0    | 0      | .001  | 3      | .001 | 4     | .001 | 4|
|16x16 | .001 | 0      | 0    | 0      | 0    | 0      | .001  | 20     | .001 | 20    | .001 | 21|
|17x17 | .004 | 129    | .003 | 101    | .002 | 67     | .003  | 56     | .001 | 15    | .001 | 15|
|18x18 | 0    | 0      | .001 | 0      | .001 | 0      | .001  | 5      | .001 | 5     | .001 | 5|
|19x19 | .001 | 0      | .001 | 0      | 0    | 0      | .001  | 12     | .001 | 12    | .001 | 12|
|20x20 | 0    | 7      | .001 | 7      | .001 | 2      | .01   | 467    | .004 | 149   | .009 | 376|
|21x21 | .001 | 27     | .002 | 27     | .001 | 27     | .001  | 10     | .001 | 10    | .001 | 10|
|22x22 | .001 | 0      | .001 | 6      | .001 | 6      | .929  | 26600  | .899 | 25698 | 3.266| 98539|
|23x23 |7.543 | 298779 |10.191| 398237 | 1,014| 36927  | -     | 4894029| -    |4606515| -    | 4764111|
|24x24 | .001 | 24     | 0    | 0      | .001 | 0      | .001  | 3      | .001 | 3     | .001 | 3|
|25x25 | .162 | 3163   |14.381| 544369 |17.578| 628323 | -     |4841523 | -    |4760371| -    | 4733764|
|26x26 | .058 | 939    | .003 | 10     | .002 | 1      | 9.052 | 146669 | .017 | 233   | .018 | 233|
|27x27 | .002 | 0      | .002 | 0      | .002 | 0      | .004  | 26     | .004 | 36    | .003 | 24|
|28x28 | .003 | 22     | .003 | 18     | .002 | 6      | .041  | 559    | .079 | 1286  | .06  | 1032|
|29x29 | .002 | 0      | .002 | 0      | .002 | 0      | .974  | 14876  | .064 | 959   | .337 | 4628|
|30x30 | .001 | 0      | .001 | 0      | .001 | 0      | .084  | 1498   | .077 | 1408  | .086 | 1672|
|31x31 | 0    | 0      | .001 | 0      | .036 | 0      | .026  | 338    | .017 | 338   | .018 | 338|
|32x32 | .003 | 0      | .003 | 0      | .003 | 0      |190.797| 1915994|81.987| 861746|16.017| 165064|
|33x33 | .058 | 1042   | .056 | 1024   | .033 | 1016   | 1.837 | 29312  | .182 | 2882  | .333 | 5436|
|34x34 | .001 | 13     | .002 | 13     | .001 | 2      | 1.51  | 25247  | 1.528| 25247 | 2.012| 34574|
|35x35 | .018 | 316    | .003 | 29     | .004 | 29     | .008  | 110    | .008 | 91    | .008 | 91|
|36x36 | .003 | 23     | .002 | 23     | .002 | 6      | .045  | 738    | .046 | 738   | .047 | 738|
|37x37 | .352 | 7400   | .156 | 3594   | .307 | 9343   | 1.879 | 24917  | .595 | 7968  | 1.358| 18428|
|38x38 | .025 | 595    | .002 | 21     | .001 | 6      | .034  | 854    | .007 | 126   | .007 | 146|
|39x39 | .003 | 0      | .002 | 0      | .002 | 0      | .181  | 2163   | .02  | 154   | .021 | 154|
|40x40 | .001 | 14     | .002 | 14     | .001 | 1      | .001  | 2      | .001 | 2     | .001 | 2|
| Tot: | **8.244**s | **312514** | 24.817 | 947511 | 18.989 | 672773 |

**Input-min: The best search strategy**.\
Using that searching strategy I am able to solve all the instances in 13 seconds(with 312514 as total **failures**)

### ROTATION (point 5)
A second model has been implemented taking into consideration the possible rotation of each pieces. For more details on the model see **Model.pdf**. \
As for the main model(pwp_v9) it is possible to load any instance we want and to run the **"pwp_v9-rot.mzn"** model. All the solutions are printed out as demonstration. 

### SAME DIMENSION (point 6)
A third model has been implemented taking into consideration the possibility of having instances in which there are 2 or more pieces with the same dimension(same widths and heights). For more details on the model see **Model.pdf**.\
A specific instance, *8x8-same-dim.txt* has been created and added to the *Instances* folder.\
As for the main model(pwp_v9) it is possible to load any instance we want before running the "**pwp_v9-same-dim**" model. All the solutions are printed out as demonstration.

## Running the SMT model
At first it is necessary to run all the cells before the CP part of the notebook (*imports*-1° cell, *Accessory Functions* cells)\
The general use of the model is the following:
- having a reference function model (e.g. *create_model*)
- (the same in CP) having an instance **instance_name**="instance name"
- (the same in CP) load the instance in order to have: **pr_w**(paper roll's width), **pr_h**(paper roll's height), **n_pieces**(number of pieces in that instance), **L**(the dimension of each pieces)
- running the function model(*model = create_model(pr_w, pr_h, n_pieces, L)*) using python(inside the notebook) to get the model
- instantiating the Solver, adding the model and running the solver(*res = s.check()*)
- (the same in CP) using the *print_solutions* function to have a graphically solution/s printing
- (the same in CP) using the *save_solution* function to store locally one or more solutions for that instance

For all the instances are been founded at least one solution in an acceptable time.

|n | time[s] | 
| --- | --- | 
|8x8 | .035 | 
|9x9 | .017 | 
|10x10 | .028 |
|11x11 | .030 |
|12x12 | .047 |
|13x13 | .057 |
|14x14 | .043 |
|15x15 | .092 |
|16x16 | .089 |
|17x17 | .170 |
|18x18 | .150 |
|19x19 | .169 |
|20x20 | .209 |
|21x21 | .105 |
|22x22 | .363 |
|23x23 | 22.414 |
|24x24 | .294 |
|25x25 | 6.767 |
|26x26 | .693 |
|27x27 | .327 |
|28x28 | .491 |
|29x29 | .579 |
|30x30 | .461 |
|31x31 | .423 |
|32x32 | 1.718 |
|33x33 | .908 |
|34x34 | .608 |
|35x35 | .438 |
|36x36 | .681 |
|37x37 | .650 |
|38x38 | .349 |
|39x39 | .757 |
|40x40 | .267 |
| Tot: | 40.429 |

### ROTATION (point 5)
A second function model(**create_model_with_rotation**) has been implemented taking into consideration the possible rotation of each pieces. For more details on the model see **Model.pdf**. \
As for the main function model(create_model) it is possible to load any instance we want and to use the solver to get the solution. A solution of the 9x9 instance is printed out as demonstration. 

### SAME DIMENSION (point 6)
A third function model has been implemented(**create_model_same_dim**) taking into consideration the possibility of having instances in which there are 2 or more pieces with the same dimension(same widths and heights). For more details on the model see **Model.pdf**.\
A specific instance, *8x8-same-dim.txt* has been created and added to the *Instances* folder.\
As for the main function model(create_model) it is possible to load any instance we want before using the solver to get the solution. A solution is printed out as demonstration.
[You can use numbers for reference-style link definitions][1]

### References
- [Exhaustive approaches to 2D rectangular perfect packings](https://www.eecs.harvard.edu/~michaelm/postscripts/ipl2004.pdf)
- [2008-Search Strategies for Rectangle Packing-Helmut Simonis and Barry O’Sullivan](https://link.springer.com/chapter/10.1007/978-3-540-85958-1_4)
- [A new constraint programming approach for the orthogonal packing problem](http://vmk.ugatu.ac.ru/c%26p/article/new_2009/2D_OPP_clautiaux_constraint_progr.pdf)
- [Optimal Rectangle Packing: An Absolute Placement Approach](https://arxiv.org/ftp/arxiv/papers/1402/1402.0557.pdf)
- [The SMT-LIB Standard](http://smtlib.cs.uiowa.edu/papers/smt-lib-reference-v2.0-r10.12.21.pdf)
- [A SAT-based Method for Solving the Two-dimensional Strip Packing Problem](http://ceur-ws.org/Vol-451/paper16soh.pdf)
- [Introduction to SMT Solving CSP’s with SMT](https://www.cs.upc.edu/~erodri/webpage/papers/bergen2.pdf)
## Author
* **Filippo Lo Bue**
