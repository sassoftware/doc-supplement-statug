/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICPHGEX2                                            */
/*   TITLE: Documentation Example 2 for PROC ICPHREG            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Proportional hazards regression model,              */
/*   PROCS: ICPHREG                                             */
/*    DATA: Larder BA, Darby G, Richman, DD (1989),             */
/*          Science, 243, 1731-1734.                            */
/*     REF: SAS/STAT User's Guide, PROC ICPHREG Chapter         */
/*    MISC:                                                     */
/****************************************************************/

data hiv;
   input Left Right Stage Dose CdLow CdHigh;
   if (Left=0) then Left=.;
   if (Right>=26) then Right=.;
   datalines;
0 16 0 0 0 1
15 26 0 0 0 1
12 26 0 0 0 1
17 26 0 0 0 1
13 26 0 0 0 1
0 24 0 0 1 0
6 26 0 1 1 0
0 15 0 1 1 0
14 26 0 1 1 0
12 26 0 1 1 0
13 26 0 1 0 1
12 26 0 1 1 0
12 26 0 1 1 0
0 18 0 1 0 1
0 14 0 1 0 1
0 17 0 1 1 0
0 15 0 1 1 0
3 26 1 0 0 1
4 26 1 0 0 1
1 11 1 0 0 1
13 19 1 0 0 1
0 6 1 0 0 1
0 11 1 1 0 0
6 26 1 1 0 0
0 6 1 1 0 0
2 12 1 1 0 0
1 17 1 1 1 0
0 14 1 1 0 0
0 25 1 1 0 1
2 11 1 1 0 0
0 14 1 1 0 0
;

ods graphics on;
proc icphreg data=hiv plot=surv;
   class Stage / desc;
   model (Left, Right) = Stage / basehaz=splines;
run;

data cov;
   Stage=0; output;
   Stage=1; output;
run;

proc icphreg data=hiv plot=surv;
   class Stage / desc;
   model (Left, Right) = Stage / basehaz=splines;
   baseline covariates=cov;
run;

proc icphreg data=hiv plot=cumhaz;
   class Stage / desc;
   model (Left, Right) = Stage / basehaz=splines;
   baseline covariates=cov;
run;
