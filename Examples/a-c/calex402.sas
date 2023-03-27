/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX402                                            */
/*   TITLE: Documentation Example 30 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: higher-order confirmatory factor analysis, COSAN    */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 30                              */
/*    MISC:                                                     */
/****************************************************************/

data Thurst(TYPE=CORR);
title "Example of THURSTONE resp. McDONALD (1985, p.57, p.105)";
   _TYPE_ = 'CORR'; Input _NAME_ $ Obs1-Obs9;
   label obs1='Sentences' obs2='Vocabulary' obs3='Sentence Completion'
         obs4='First Letters' obs5='Four-letter Words' obs6='Suffices'
         obs7='Letter series' obs8='Pedigrees' obs9='Letter Grouping';
   datalines;
obs1  1.       .      .      .      .      .      .      .      .
obs2   .828   1.      .      .      .      .      .      .      .
obs3   .776   .779   1.      .      .      .      .      .      .
obs4   .439   .493    .460  1.      .      .      .      .      .
obs5   .432   .464    .425   .674  1.      .      .      .      .
obs6   .447   .489    .443   .590   .541  1.      .      .      .
obs7   .447   .432    .401   .381   .402   .288  1.      .      .
obs8   .541   .537    .534   .350   .367   .320   .555  1.      .
obs9   .380   .358    .359   .424   .446   .325   .598   .452  1.
;

proc calis data=Thurst nobs=213 corr nose;
lineqs
   obs1 =  x1 * f1 + e1,
   obs2 =  x2 * f1 + e2,
   obs3 =  x3 * f1 + e3,
   obs4 =  x4 * f2 + e4,
   obs5 =  x5 * f2 + e5,
   obs6 =  x6 * f2 + e6,
   obs7 =  x7 * f3 + e7,
   obs8 =  x8 * f3 + e8,
   obs9 =  x9 * f3 + e9,
   f1   = x10 * f4 + e10,
   f2   = x11 * f4 + e11,
   f3   = x12 * f4 + e12;
variance
   f4      = 1.,
   e1-e9   = u1-u9,
   e10-e12 = 3 * 1.;
bounds
   0. <= u1-u9;
run;

proc calis data=Thurst nobs=213 corr nose;
   cosan
      var = obs1-obs9,
      F1(3) * F2(1) * P(1,IDE) + F1(3) * U2(3,IDE) + U1(9,DIA);
   matrix F1
      [1 , @1] = x1-x3,
      [4 , @2] = x4-X6,
      [7 , @3] = x7-x9;
   matrix F2
      [ ,1]    = x10-x12;
   matrix U1
      [1,1]    = u1-u9;
   bounds
      0. <= u1-u9;
   vnames
      F1 = [f1 f2 f3],
      F2 = [f4],
      U1 = [e1-e9];
run;

