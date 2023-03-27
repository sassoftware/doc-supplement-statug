/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX06                                             */
/*   TITLE: Documentation Example 23 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: RAM, LINEQS, and LISMOD modeling languages          */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 23                              */
/*    MISC:                                                     */
/****************************************************************/

title "Stability of Alienation";
title2 "Data Matrix of WHEATON, MUTHEN, ALWIN & SUMMERS (1977)";
data Wheaton(type=cov);
   _type_ = 'cov';
   input _name_ $ 1-11 Anomie67 Powerless67 Anomie71 Powerless71
                       Education SEI;
   label Anomie67='Anomie (1967)' Powerless67='Powerlessness (1967)'
         Anomie71='Anomie (1971)' Powerless71='Powerlessness (1971)'
         Education='Education'    SEI='Occupational Status Index';
   datalines;
Anomie67       11.834     .        .        .       .        .
Powerless67     6.947    9.364     .        .       .        .
Anomie71        6.819    5.091   12.532     .       .        .
Powerless71     4.783    5.028    7.495    9.986    .        .
Education      -3.839   -3.889   -3.841   -3.625   9.610     .
SEI           -21.899  -18.831  -21.748  -18.775  35.522  450.288
;

proc calis nobs=932 data=Wheaton;
   ram
      var =  Anomie67     /* 1 */
             Powerless67  /* 2 */
             Anomie71     /* 3 */
             Powerless71  /* 4 */
             Education    /* 5 */
             SEI          /* 6 */
             Alien67      /* 7 */
             Alien71      /* 8 */
             SES,         /* 9 */
      _A_    1   7   1.0,
      _A_    2   7   0.833,
      _A_    3   8   1.0,
      _A_    4   8   0.833,
      _A_    5   9   1.0,
      _A_    6   9   lambda,
      _A_    7   9   gamma1,
      _A_    8   9   gamma2,
      _A_    8   7   beta,
      _P_    1   1   theta1,
      _P_    2   2   theta2,
      _P_    3   3   theta1,
      _P_    4   4   theta2,
      _P_    5   5   theta3,
      _P_    6   6   theta4,
      _P_    7   7   psi1,
      _P_    8   8   psi2,
      _P_    9   9   phi,
      _P_    1   3   theta5,
      _P_    2   4   theta5;
run;

proc calis nobs=932 data=Wheaton;
   lineqs
      Anomie67     = 1.0    * f_Alien67 + e1,
      Powerless67  = 0.833  * f_Alien67 + e2,
      Anomie71     = 1.0    * f_Alien71 + e3,
      Powerless71  = 0.833  * f_Alien71 + e4,
      Education    = 1.0    * f_SES     + e5,
      SEI          = lambda * f_SES     + e6,
      f_Alien67    = gamma1 * f_SES     + d1,
      f_Alien71    = gamma2 * f_SES     + beta * f_Alien67 + d2;
   variance
      E1           = theta1,
      E2           = theta2,
      E3           = theta1,
      E4           = theta2,
      E5           = theta3,
      E6           = theta4,
      D1           = psi1,
      D2           = psi2,
      f_SES        = phi;
   cov
      E1  E3       = theta5,
      E2  E4       = theta5;
run;

proc calis nobs=932 data=Wheaton;
   lismod
      yvar   = Anomie67 Powerless67 Anomie71 Powerless71,
      xvar   = Education SEI,
      etavar = Alien67  Alien71,
      xivar  = SES;
   matrix _LAMBDAY_
      [1,1]  = 1,
      [2,1]  = 0.833,
      [3,2]  = 1,
      [4,2]  = 0.833;
   matrix _LAMBDAX_
      [1,1]  = 1,
      [2,1]  = lambda;
   matrix _GAMMA_
      [1,1]  = gamma1,
      [2,1]  = gamma2;
   matrix _BETA_
      [2,1]  = beta;
   matrix _THETAY_
      [1,1]  = theta1-theta2 theta1-theta2,
      [3,1]  = theta5,
      [4,2]  = theta5;
   matrix _THETAX_
      [1,1]  = theta3-theta4;
   matrix _PSI_
      [1,1]  = psi1-psi2;
   matrix _PHI_
      [1,1]  = phi;
run;

