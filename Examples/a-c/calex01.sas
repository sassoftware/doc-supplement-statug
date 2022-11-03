/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX01                                             */
/*   TITLE: Documentation Example 17 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: path model, stability of alienation                 */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 17                              */
/*    MISC:                                                     */
/****************************************************************/

title "Stability of Alienation";
title2 "Data Matrix of WHEATON, MUTHEN, ALWIN & SUMMERS (1977)";
data Wheaton(TYPE=COV);
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

ods graphics on;

proc calis nobs=932 data=Wheaton plots=residuals;
   path
      Anomie67   Powerless67  <===  Alien67   = 1.0  0.833,
      Anomie71   Powerless71  <===  Alien71   = 1.0  0.833,
      Education  SEI          <===  SES       = 1.0  lambda,
      Alien67    Alien71      <===  SES       = gamma1 gamma2,
      Alien71                 <===  Alien67   = beta;
   pvar
      Anomie67     = theta1,
      Powerless67  = theta2,
      Anomie71     = theta1,
      Powerless71  = theta2,
      Education    = theta3,
      SEI          = theta4,
      Alien67      = psi1,
      Alien71      = psi2,
      SES          = phi;
   pcov
      Anomie67    Anomie71    = theta5,
      Powerless67 Powerless71 = theta5;
   pathdiagram title='Stability of Alienation';
run;

ods graphics off;
