/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPPGS                                               */
/*   TITLE: Getting Started Example for PROC SPP                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, spatial point patterns            */
/*   PROCS: SPP                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SPP, GETTING STARTED EXAMPLE                   */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc spp data=sashelp.bei plots(equate)=(trends observations);
   process trees = (x, y /area=(0,0,1000,500) Event=Trees);
   trend grad = field(x,y, gradient);
   trend elev = field(x,y, elevation);
run;

proc spp data=sashelp.bei plots(equate)=(residual intensity);
   process trees = (x,y /area=(0,0,1000,500) event=Trees);
   trend elev = field(x,y,elevation);
   trend grad = field(x,y,gradient);
   model trees = elev grad / grid(64,64) residual(B=70) ;
run;

