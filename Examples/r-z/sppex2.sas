/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPPEX2                                              */
/*   TITLE: Documentation Example 2 for PROC SPP                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, spatial point patterns            */
/*   PROCS: SPP                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SPP, EXAMPLE 2                                 */
/*    MISC:                                                     */
/****************************************************************/

proc spp data=sashelp.bei;
   process trees = (x,y /area=(0,0,1000,500) event=Trees);
   trend grad = field(x,y,Gradient);
   trend elev = field(x,y,Elevation);
   covtest trees = grad elev;
run;
