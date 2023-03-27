/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpfmmgs1                                            */
/*   TITLE: First Getting Started Example for PROC HPFMM        */
/*          Mixtures of binomial distributions                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Student's yeast cell counts                         */
/*          Maximum likelihood and Bayesian analysis            */
/*   PROCS: HPFMM                                               */
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

proc hpfmm data=yeast;
   model count/n =  / k=2;
   freq f;
run;

proc hpfmm data=yeast;
   model count/n =  / k=2;
   freq f;
   id f n;
   output out=hpfmmout pred(components) posterior;
run;
data hpfmmout;
   set hpfmmout;
   PredCount_1 = post_1 * f;
   PredCount_2 = post_2 * f;
run;
proc print data=hpfmmout;
run;

ods graphics on;
proc hpfmm data=yeast seed=12345;
   model count/n = / k=2;
   freq f;
   performance nthreads=2;
   bayes;
run;
ods graphics off;

