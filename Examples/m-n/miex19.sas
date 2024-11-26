/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX19                                              */
/*   TITLE: Documentation Example 19 for PROC MI                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 19                                 */
/*    MISC:                                                     */
/****************************************************************/

proc print data=sashelp.heart(obs=10);
run;

ods select MissPattern Flux FluxPlot Corr;

ods graphics on;

proc mi data=sashelp.heart simple flux nimpute=0
      displaypattern=nomeans;
   class _character_;
   var _all_;
   fcs;
run;

