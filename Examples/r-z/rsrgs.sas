

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: RSRGS                                               */
/*   TITLE: Getting Started Example for PROC RSREG              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: response surface regression                         */
/*   PROCS: RSREG                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC RSREG chapter           */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Schneider and Stockett (1963) performed an experiment aimed at
reducing the unpleasant odor of a chemical product with several
factors. From Peter W. M. John, Statistical Design and Analysis
of Experiments, Macmillan 1971.
----------------------------------------------------------------*/


title 'Response Surface with a Simple Optimum';
data smell;
   input Odor T R H @@;
   label
      T = "Temperature"
      R = "Gas-Liquid Ratio"
      H = "Packing Height";
   datalines;
 66 40 .3 4     39 120 .3 4     43 40 .7 4     49 120 .7  4
 58 40 .5 2     17 120 .5 2     -5 40 .5 6    -40 120 .5  6
 65 80 .3 2      7  80 .7 2     43 80 .3 6    -22  80 .7  6
-31 80 .5 4    -35  80 .5 4    -26 80 .5 4
;


proc rsreg data=smell;
   model Odor = T R H / lackfit;
run;

ods graphics on;
proc rsreg data=smell
           plots(unpack)=surface(3d at(H=7.541050));
   model Odor = T R H;
   ods select 'T * R = Pred';
run;
ods graphics off;
