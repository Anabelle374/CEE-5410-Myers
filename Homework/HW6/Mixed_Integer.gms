$ontext
CEE 6410 Fall 2015


Anabelle Myers
December 5th, 2025
$offtext

* 1. DEFINE the SETS
SETS t season /1, 2/;

* 2. DEFINE input data
PARAMETERS
    Qt(t)        River inflow acft
        /1 600,
        2 200/
    Irr(t)     Irrigation Demand acftperacre
       /1 1.0,
       2 3.0/;
                  
* Costs/profit
SCALARS
    ProfitPerAcre   Profit per acre irrigated $ per yr per acre   /300/
    CostHigh        Capital cost high dam ($ per yr)          /10000/
    CostLow         Capital cost low dam ($ per yr)           /6000/
    CostPumpCap     Capital cost pump ($ per yr)              /8000/
    CostPumpOp      Operating cost pump ($ per acft)         /20/;
    
* Capacities
SCALARS
    CapHigh      Storage capacity per high dam (acft)     /700/
    CapLow       Storage capacity per low dam (acft)      /300/
    PumpCapSeas  Pump capacity per 6 month season (acft)  /396/;



* 3. DEFINE the variables
Variables
    ACRES        Farm size (acres irrigated)
    R(t)         Gravity diversion from reservoir to farm (acft per season)
    P(t)         Pumped diversion from river to farm (acft per season)
    S(t)         Reservoir storage at end of season t (acft)
    Z            Net annual benefit ($);

BINARY VARIABLES
    IHigh        1 if high dam is built or 0 otherwise
    ILow         1 if low dam is built or 0 otherwise
    IPump        1 if pump is built or 0 otherwise;

* Non-negativity constraints
POSITIVE VARIABLES ACRES, R, P, S;


* 4. COMBINE variables and data in equations
EQUATIONS
    OBJ              Objective (net benefit)
    MASS1            Storage balance after season 1
    MASS2            Storage balance after season 2
    RESCAP1          Storage capacity in season 1
    RESCAP2          Storage capacity in season 2
    DAMTYPECHOICE        At most one of high per low dam
    DEMAND1          Water demand in season 1
    DEMAND2          Water demand in season 2
    PUMPCAP1         Pump capacity in season 1
    PUMPCAP2         Pump capacity in season 2;
    
OBJ..
    Z =E= ProfitPerAcre*ACRES - CostHigh*IHigh - CostLow*ILow - CostPumpCap*IPump - CostPumpOp*SUM(t, P(t));

MASS1..
    S('1') =E= Qt('1') - R('1');

MASS2..
    S('2') =E= S('1') + Qt('2') - R('2');

RESCAP1..
    S('1') =L= CapHigh*IHigh + CapLow*ILow;

RESCAP2..
    S('2') =L= CapHigh*IHigh + CapLow*ILow;

DAMTYPECHOICE..
    IHigh + ILow =L= 1;

DEMAND1..
    R('1') + P('1') =G= Irr('1')*ACRES;

DEMAND2..
    R('2') + P('2') =G= Irr('2')*ACRES;

PUMPCAP1..
    P('1') =L= PumpCapSeas*IPump;

PUMPCAP2..
    P('2') =L= PumpCapSeas*IPump;


* 5. DEFINE the MODEL from the EQUATIONS
MODEL Mixed_Integer /ALL/;


* 6. SOLVE the MODEL
SOLVE Mixed_Integer USING MIP MAXIMIZING Z;

DISPLAY ACRES.L, R.L, P.L, S.L, IHigh.L, ILow.L, IPump.L, Z.L;
