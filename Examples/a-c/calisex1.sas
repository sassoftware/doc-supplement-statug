/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALISEX1                                            */
/*   TITLE: Documentation Example 1 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: structural equation models, path analysis           */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 1                               */
/*    MISC:                                                     */
/****************************************************************/

data Wheaton(TYPE=COV);
title "Stability of Alienation";
title2 "Data Matrix of WHEATON, MUTHEN, ALWIN & SUMMERS (1977)";
   _type_ = 'cov'; input _name_ $ v1-v6;
   label v1='Anomie (1967)' v2='Anomie (1971)' v3='Education'
         v4='Powerlessness (1967)' v5='Powerlessness (1971)'
         v6='Occupational Status Index';
   datalines;
v1   11.834     .        .        .       .        .
v2    6.947    9.364     .        .       .        .
v3    6.819    5.091   12.532     .       .        .
v4    4.783    5.028    7.495    9.986    .        .
v5   -3.839   -3.889   -3.841   -3.625   9.610     .
v6  -21.899  -18.831  -21.748  -18.775  35.522  450.288
;


ods graphics on;

proc calis cov data=Wheaton tech=nr edf=931 pall plots=residuals;
   lineqs
      v1 =         f1                  + e1,
      v2 =    .833 f1                  + e2,
      v3 =         f2                  + e3,
      v4 =    .833 f2                  + e4,
      v5 =         f3                  + e5,
      v6 = Lamb (.5) f3                + e6,
      f1 = Gam1(-.5) f3                + d1,
      f2 = Beta (.5) f1 + Gam2(-.5) f3 + d2;
   std
      e1-e6 = The1-The2 The1-The4 (6 * 3.),
      d1-d2 = Psi1-Psi2 (2 * 4.),
      f3    = Phi (6.) ;
   cov
      e1 e3 = The5 (.2),
      e4 e2 = The5 (.2);
run;

ods graphics off;

proc calis cov data=Wheaton tech=nr edf=931;
   Cosan J(9, Ide) * A(9, Gen, Imi) * P(9, Sym);
   Matrix A
           [ ,7] = 1. .833  5 * 0. Beta (.5) ,
           [ ,8] = 2 * 0.  1.  .833 ,
           [ ,9] = 4 * 0.  1.  Lamb Gam1-Gam2 (.5 2 * -.5);
   Matrix P
           [1,1] = The1-The2 The1-The4 (6 * 3.) ,
           [7,7] = Psi1-Psi2 Phi (2 * 4. 6.) ,
           [3,1] = The5 (.2) ,
           [4,2] = The5 (.2) ;
   Vnames J V1-V6 F1-F3 ,
          A = J ,
          P E1-E6 D1-D3 ;
run;

proc calis cov data=Wheaton tech=nr edf=931;
   Ram
      1   1  7  1.       ,
      1   2  7  .833     ,
      1   3  8  1.       ,
      1   4  8  .833     ,
      1   5  9  1.       ,
      1   6  9  .5    Lamb ,
      1   7  9  -.5   Gam1 ,
      1   8  7  .5    Beta ,
      1   8  9  -.5   Gam2 ,
      2   1  1  3.    The1 ,
      2   2  2  3.    The2 ,
      2   3  3  3.    The1 ,
      2   4  4  3.    The2 ,
      2   5  5  3.    The3 ,
      2   6  6  3.    The4 ,
      2   1  3  .2    The5 ,
      2   2  4  .2    The5 ,
      2   7  7  4.    Psi1 ,
      2   8  8  4.    Psi2 ,
      2   9  9  6.    Phi ;
   Vnames 1 F1-F3,
          2 E1-E6 D1-D3;
run;
