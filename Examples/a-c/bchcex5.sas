/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: BCHCEX5                                             */
/*   TITLE: Documentation Example 5 for PROC BCHOICE            */
/*          Heterogeneity Affected by Individual Characteristics*/
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BCHOICE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC BCHOICE, EXAMPLE 5                             */
/*    MISC:                                                     */
/****************************************************************/

proc print data=Sashelp.Margarin (obs=24);
   by HouseID Set;
   id HouseID Set;
run;

proc bchoice data=Sashelp.Margarin seed=123 nmc=40000 thin=2
   nthreads=4 plots=none;
   class Brand(ref='PPk') HouseID Set;
   model Choice = / choiceset=(HouseID Set);
   random  Brand LogPrice / subject=HouseID remean=(LogInc FamSize)
           type=un monitor=(1);
run;

