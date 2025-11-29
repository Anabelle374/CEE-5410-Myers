$ontext
CEE 6410 - Water Resources Systems Analysis

THE PROBLEM:




THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Anabelle Myers
$offtext

* 1. DEFINE the SETS
SETS prdc crops growing /Trucks, Sedans/
     res resources /Tanks, Rows, Drive, Vehicles/;

* 2. DEFINE input data
PARAMETERS
   c(prdc) Objective function coefficients ($ per vehicle)
         /Trucks 100,
         Sedans 110/
   b(res) Right hand constraint values (per resource)
          /Tanks 14000,
           Rows  18000,
           Drive 6000
           Vehicles 10000 /;

TABLE A(prdc,res) Left hand side constraint coefficients
                 Tanks    Rows    Drive   Vehicles
 Trucks            2       1        1       1
 Sedans            1       2        0       1 ;

* 3. DEFINE the variables
VARIABLES X(prdc) vehicles planted (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(prdc,c(prdc)*X(prdc));
RES_CONSTRAIN(res) ..    SUM(prdc,A(prdc,res)*X(prdc)) =L= b(res);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PRODUCING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PRODUCING /ALL/;

PRODUCING.optfile = 1;

* 6. SOLVE the MODEL
* Solve the PRODUCING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PRODUCING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
