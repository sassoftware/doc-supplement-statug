/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NPAR1GS                                             */
/*   TITLE: Getting Started Examples for PROC NPAR1WAY          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: nonparametric methods, categorical data analysis,   */
/*    KEYS: Wilcoxon test, Kruskal-Wallis test, exact tests,    */
/*    KEYS: EDF, Kolmogorov-Smirnov statistics                  */
/*   PROCS: NPAR1WAY                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC NPAR1WAY, Getting Started                      */
/*    MISC:                                                     */
/****************************************************************/
data Gossypol;
   input Dose n;
   do i=1 to n;
      input Gain @@;
      output;
   end;
   datalines;
0 16
228 229 218 216 224 208 235 229 233 219 224 220 232 200 208 232
.04 11
186 229 220 208 228 198 222 273 216 198 213
.07 12
179 193 183 180 143 204 114 188 178 134 208 196
.10 17
130 87 135 116 118 165 151 59 126 64 78 94 150 160 122 110 178
.13 11
154 130 130 118 118 104 112 134 98 100 104
;
proc npar1way data=Gossypol;
   class Dose;
   var Gain;
run;
/* Box Plot of Wilcoxon Scores ---------------------------------*/
ods graphics on;
proc npar1way data=Gossypol plots(only)=wilcoxonboxplot;
   class Dose;
   var Gain;
run;
ods graphics off;
/* Two-Sample Analysis -----------------------------------------*/
proc npar1way data=Gossypol;
   where Dose <= .04;
   class Dose;
   var Gain;
run;
