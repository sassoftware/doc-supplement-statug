/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: probitex4                                           */
/*   TITLE: Documentation Example 4 for PROC PROBIT             */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*                                                              */
/*   PROCS: PROBIT                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data epidemic;
   input treat$ dose n r sex @@;
   label dose = Dose;
   datalines;
A  2.17 142 142  0   A   .57 132  47  1  A  1.68 128 105  1   A  1.08 126 100  0
A  1.79 125 118  0   B  1.66 117 115  1  B  1.49 127 114  0   B  1.17  51  44  1
B  2.00 127 126  0   B   .80 129 100  1
;

data xval;
   input treat $ dose sex;
   datalines;
B  2.  1
;

proc probit optc lackfit covout data=epidemic
            outest = out1 xdata = xval
            Plots=(predpplot ippplot lpredplot);
   class treat sex;
   model r/n = dose treat sex sex*treat/corrb covb inversecl;
   output out = out2 p =p;
run;

proc print data=out1;
run;

