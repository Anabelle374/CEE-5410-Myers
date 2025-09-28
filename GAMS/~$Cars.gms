$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint and furthur modified to represent the vehicle



THE PROBLEM:

An irrigated farm can be planted in two crops:  eggplants and tomatoes.  Data are as fol-lows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
        Eggplant        Tomatoes
Water        1x103 gal/plant        2x103 gal/plant      4x106 gal/year
Land        4 ft2/plant        3 ft2/plant               1.2x104 ft2
Labor         5hr/plant        2.5/hr plant              17,500 hours
Profit/plant        $6        $7

                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

David E Rosenberg
david.rosenberg@usu.edu
September 15, 2015
$offtext

* 1. DEFINE the SETS
SETS spatial points of interest in the problem schematic /Inflow, Reservoir.
     plnt crops growing /Eggplant, Tomatoes/
     res resources /Water, Land, Labor/
* for car production
     cars Cars to produce / Coups, Minivans /
     materials Materials used to produce vehicles / Metal, CircuitBoards, Labor/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per plant)
         /Eggplant 6,
         Tomatoes 7/
   b(res) Right hand constraint values (per resource)
          /Water 4000000,
           Land  12000,
           Labor  17500/
           
    carprofit(cars) Profit per car produced ($ per car)
     / coups 6
     minivans 7/
    
    carconstrains(materials) Righthand constraint values for car production (per resource)
     /Metal 4000000
     CircuitBoard 120000
     Labor 17500/;
    
        

    carconstraints(materials)
TABLE A(plnt,res) Left hand side constraint coefficients
                 Water    Land   Labor
 Eggplant        1000      4       5
 Tomatoes        2000      3       2.5;

TABLE Z(cars,materials) Left hand side constraint coefficients for the car problem
                 Metal    CircuitBoards   Labor
 Coups        1000      4       5
 Minivans        2000      3       2.5;

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (Number)
          VPROFIT  total profit ($);

VARIABLES W(cars) cars to produce (Number)
        CPROFIT total profit from producing cars ($);

* Non-negativity constraints
POSITIVE VARIABLES X, W;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints
   PROFITCARS Toatal profit from producing cars ($) the objective function value
   MATERIALCONTRAINT(materials) Rsources used to produce cars;
   

PROFIT..                 VPROFIT =E= SUM(plnt, c(plnt)*X(plnt));
RES_CONSTRAIN(res) ..    SUM(plnt, A(plnt,res)*X(plnt)) =L= b(res);

PROFITCARS..        CPROFIT =E= SUM(cars, carprofit(cars)*W(cars));
MATERIALCONTRAINTS(materials).. SUM(cars, Z(cars,materials)*W(cars)) =L= carconstraints



* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
MODEL CARPRODUCTION / PROFITCARS, MATERIALCONTRAINTS/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
*SOLVE PLANTING USING LP MAXIMIZING VPROFIT;
SOLVE CARPRPRODUCTION USING LP MAXIMIXING CPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
