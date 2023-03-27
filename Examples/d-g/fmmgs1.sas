/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmgs1                                              */
/*   TITLE: First Getting Started Example for PROC FMM          */
/*          Mixtures of binomial distributions                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Student's yeast cell counts                         */
/*          Maximum likelihood and Bayesian analysis            */
/*   PROCS: FMM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Pearson, K. (1915), On certain types of compound    */
/*          frequency distributions in which the components     */
/*          can be individually described by binomial series.   */
/*          Biometrika, 11, 139--144.                           */
/*    MISC:                                                     */
/****************************************************************/

data yeast;
   input count f;
   n = 5;
   datalines;
   0     213
   1     128
   2      37
   3      18
   4       3
   5       1
;

proc fmm data=yeast;
   model count/n =  / k=2;
   freq f;
run;

proc fmm data=yeast;
   model count/n =  / k=2;
   freq f;
   output out=fmmout pred(components) posterior;
run;
data fmmout;
   set fmmout;
   PredCount_1 = post_1 * f;
   PredCount_2 = post_2 * f;
run;
proc print data=fmmout;
run;

ods graphics on;
proc fmm data=yeast seed=12345;
   model count/n = / k=2;
   freq f;
   performance cpucount=2;
   bayes;
run;
ods graphics off;

