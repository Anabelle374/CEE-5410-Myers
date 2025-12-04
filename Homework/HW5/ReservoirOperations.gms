$ontext
CEE 6410 - Water Resources Systems Analysis

Anabelle Myers
$offtext

* 1. DEFINE the SETS
SETS t /1, 2, 3, 4, 5, 6/;

* 2. DEFINE input data
PARAMETERS
   Inflow(t) Inflow (unit)
    /1 2,
     2 2,
     3 3,
     4 4,
     5 3,
     6 2/

   HydBen(t) Hydropower Benefit ($ per unit)
    /1 1.6,
     2 1.7,
     3 1.8,
     4 1.9,
     5 2.0,
     6 2.0/

   IrrBen(t) Irrigation Benfit ($ per unit)
    /1 1.0,
     2 1.2,
     3 1.9,
     4 2.0,
     5 2.2,
     6 2.2/;

SCALARS
   Max_Res      Reservoir Capacity (unit)          /9/
   Max_Turb     Turbine Capacity (unit per month)  /4/
   Init_Storage Initial Storage (unit)             /5/
   MinFlow_A    Minimum Flow at A                  /1/;
    

* 3. DEFINE the variables
VARIABLES
   Hyd_Release(t)  Flow through turbines (units)
   Irr_Release(t)  Irrigation diversion (units)
   Release(t)      Bypass per non-turbine release (units)
   Storage(t)      Storage at end of month t (units)
   Total_Benefit   Total economic benefit ($);

* Non-negativity constraints
POSITIVE VARIABLES Hyd_Release, Irr_Release, Release, Storage;

* 4. COMBINE variables and data in equations
EQUATIONS
   BENEFIT          Benefit
   MASS_BAL(t)      Reservoir storage
   RES_CAP(t)       Reservoir capacity
   TURB_CAP(t)      Turbine capacity
   MINFLOW(t)       Flow available for irrigation and min flow at A
   FINAL_STORAGE    Ending storage;

BENEFIT..
    Total_Benefit =E= SUM(t, HydBen(t)*Hyd_Release(t) + IrrBen(t)*Irr_Release(t));
    
* Water leaves storage only once as Hyd_Release + Release.
MASS_BAL(t)..
   Storage(t) =E=
      ( Init_Storage + Inflow(t) - Hyd_Release(t) - Release(t) )$(ORD(t) = 1)
    + ( Storage(t-1) + Inflow(t) - Hyd_Release(t) - Release(t) )$(ORD(t) > 1);
    
RES_CAP(t)..
    Storage(t) =L= Max_Res;

TURB_CAP(t)..
    Hyd_Release(t) =L= Max_Turb;

MINFLOW(t)..
    Irr_Release(t) + MinFlow_A =L= Hyd_Release(t) + Release(t);
    
FINAL_STORAGE..
    Storage('6') =G= Init_Storage;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL RESERVOIR /ALL/;

RESERVOIR.optfile = 1;

* 6. SOLVE the MODEL
SOLVE RESERVOIR USING LP MAXIMIZING Total_Benefit;
