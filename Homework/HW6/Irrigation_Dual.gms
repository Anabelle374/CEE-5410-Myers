$ontext
CEE 6410 - Water Resources Systems Analysis

THE PROBLEM:

An aqueduct constructed to supply water to industrial users has an excess capacity in the months
of June, July, and August of 14,000 acft, 18,000 acft, and 6,000 acft, respectively. It is
proposed to develop not more than 10,000 acres of new land by utilizing the excess aqueduct
capacity for irrigation water deliveries. Two crops, hay and grain, are to be grown. Their
monthly water requirements and expected net returns are given in the following table:
                    Monthly Water Requirement (acft/acre)
            June            July            August          Return, $/acre
Hay          2               1                1                  100
Grain        1               2                0                  120

                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Anabelle Myers
$offtext

* 1. DEFINE the SETS
SETS plnt crops growing /Hay, Grain/
     res resources /June, July, August, Land/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /June 14000,
           July  18000,
           August 6000
           Land 10000 /;

TABLE A(plnt,res) Left hand side constraint coefficients
                 June    July    August   Land
 Hay              2       1        1       1
 Grain            1       2        0       1 ;

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (Number)
          VPROFIT  total profit ($)
          Y(res)  value of resources used (units specific to variable)
          VREDCOST total reduced cost ($);
* Non-negativity constraints
POSITIVE VARIABLES X,Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(res) Resource Constraints
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(plnt) Profit levels;
   
*Primal Equations
PROFIT_PRIMAL..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONS_PRIMAL(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(res,b(res)*Y(res));
RES_CONS_DUAL(plnt)..          sum(res,A(plnt,res)*Y(res)) =G= c(plnt);


* 5. DEFINE the MODEL from the EQUATIONS
*Primal Model
MODEL PLANT_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL/;
*Dual Model
MODEL PLANT_DUAL / REDCOST_DUAL, RES_CONS_DUAL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file



