/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPSPLEX2                                            */
/*   TITLE: Documentation Example 2 for PROC HPSPLIT            */
/*                                                              */
/* PRODUCT: HPSTAT                                              */
/*  SYSTEM: ALL                                                 */
/*    KEYS: cost-complexity pruning                             */
/*   PROCS: HPSTAT                                              */
/*                                                              */
/****************************************************************/

ods graphics on;

proc hpsplit data=sampsio.snra cvmethod=random(10) seed=123 intervalbins=500;
   class Type;
   grow gini;
   model Type = Blue Green Red NearInfrared NDVI Elevation
                SoilBrightness Greenness Yellowness NoneSuch;
   prune costcomplexity;
run;

proc hpsplit data=sampsio.snra plots=zoomedtree(node=7) seed=123 cvmodelfit
   intervalbins=500;
   class Type;
   grow gini;
   model Type = Blue Green Red NearInfrared NDVI Elevation
                SoilBrightness Greenness Yellowness NoneSuch;
   prune costcomplexity (leaves=10);
run;

