/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICPHGEX3                                            */
/*   TITLE: Documentation Example 3 for PROC ICPHREG            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Proportional hazards regression model               */
/*   PROCS: ICPHREG                                             */
/*    DATA: Collett, D. (2003). Modelling Survival Data in      */
/*          Medical Research, Second Edition. Taylor & Francis. */
/*     REF: SAS/STAT User's Guide, PROC ICPHREG Chapter         */
/*    MISC:                                                     */
/****************************************************************/

data hyper;
   input nephrectomy age time status @@;
   datalines;
0   1    9      1
0   1    6      1
0   1   21      1
0   2   15      1
0   2    8      1
0   2   17      1
0   3   12      1
1   1  104      0
1   1    9      1
1   1   56      1
1   1   35      1
1   1   52      1
1   1   68      1
1   1   77      0
1   1   84      1
1   1    8      1
1   1   38      1
1   1   72      1
1   1   36      1
1   1   48      1
1   1   26      1
1   1  108      1
1   1    5      1
1   2  108      0
1   2   26      1
1   2   14      1
1   2  115      1
1   2   52      1
1   2    5      0
1   2   18      1
1   2   36      1
1   2    9      1
1   3   10      1
1   3    9      1
1   3   18      1
1   3    6      1
;

data hyper;
   set hyper;
   left = time;
   if status = 0 then right = .;
   else right = time;
run;

ods graphics on;
proc icphreg data=hyper plot(timerange=(0,125))=surv;
   class Age(desc);
   strata Nephrectomy;
   model (Left, Right) = Age / basehaz=splines(df=1);
run;

