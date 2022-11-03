/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tteex01                                             */
/*   TITLE: Documentation Example 1 for PROC TTEST              */
/*          (Using Summary Statistics to Compare Group Means)   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: two-sample t test                                   */
/*   PROCS: TTEST                                               */
/*    DATA: Steer grazing data from                             */
/*          Huntsberger, David V. and Billingsley, Patrick P.   */
/*          (1989), Elements of Statistical Inference, Dubuque, */
/*          IA:  Wm. C. Brown.                                  */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data graze;
   length GrazeType $ 10;
   input GrazeType $ WtGain @@;
   datalines;
controlled  45   controlled  62
controlled  96   controlled 128
controlled 120   controlled  99
controlled  28   controlled  50
controlled 109   controlled 115
controlled  39   controlled  96
controlled  87   controlled 100
controlled  76   controlled  80
continuous  94   continuous  12
continuous  26   continuous  89
continuous  88   continuous  96
continuous  85   continuous 130
continuous  75   continuous  54
continuous 112   continuous  69
continuous 104   continuous  95
continuous  53   continuous  21
;
proc sort;
   by GrazeType;
run;

proc means data=graze noprint;
   var WtGain;
   by GrazeType;
   output out=newgraze;
run;
proc print data=newgraze;
run;
proc ttest data=newgraze;
   class GrazeType;
   var WtGain;
run;
