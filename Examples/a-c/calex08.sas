/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX08                                             */
/*   TITLE: Documentation Example 26 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: higher-order and hierarchical factor models         */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 26                              */
/*    MISC:                                                     */
/****************************************************************/

data Thurst(type=corr);
title "Example of THURSTONE resp. McDONALD (1985, p.57, p.105)";
   _type_ = 'corr'; input _name_ $ V1-V9;
   label V1='Sentences' V2='Vocabulary' V3='Sentence Completion'
         V4='First Letters' V5='Four-letter Words' V6='Suffices'
         V7='Letter series' V8='Pedigrees' V9='Letter Grouping';
   datalines;
V1  1.       .      .      .      .      .      .      .      .
V2   .828   1.      .      .      .      .      .      .      .
V3   .776   .779   1.      .      .      .      .      .      .
V4   .439   .493    .460  1.      .      .      .      .      .
V5   .432   .464    .425   .674  1.      .      .      .      .
V6   .447   .489    .443   .590   .541  1.      .      .      .
V7   .447   .432    .401   .381   .402   .288  1.      .      .
V8   .541   .537    .534   .350   .367   .320   .555  1.      .
V9   .380   .358    .359   .424   .446   .325   .598   .452  1.
;

proc calis corr data=Thurst method=max nobs=213 nose nostand;
   lineqs
      V1      = X11 * Factor1                                    + E1,
      V2      = X21 * Factor1                                    + E2,
      V3      = X31 * Factor1                                    + E3,
      V4      =             X42 * Factor2                        + E4,
      V5      =             X52 * Factor2                        + E5,
      V6      =             X62 * Factor2                        + E6,
      V7      =                         X73 * Factor3            + E7,
      V8      =                         X83 * Factor3            + E8,
      V9      =                         X93 * Factor3            + E9,
      Factor1 =                                    L1g * FactorG + E10,
      Factor2 =                                    L2g * FactorG + E11,
      Factor3 =                                    L3g * FactorG + E12;
   variance
      FactorG   = 1. ,
      E1-E12    = U1-U9 W1-W3;
   bounds
      0. <= U1-U9;
   fitindex ON(ONLY)=[chisq df probchi];
   /* SAS Programming Statements: Dependent parameter definitions */
      W1  = 1. - L1g * L1g;
      W2  = 1. - L2g * L2g;
      W3  = 1. - L3g * L3g;
run;

proc calis corr data=Thurst method=max nobs=213 nose nostand;
   lineqs
      V1 = X11 * Factor1                       + X1g * FactorG + E1,
      V2 = X21 * Factor1                       + X2g * FactorG + E2,
      V3 = X31 * Factor1                       + X3g * FactorG + E3,
      V4 =            X42 * Factor2            + X4g * FactorG + E4,
      V5 =            X52 * Factor2            + X5g * FactorG + E5,
      V6 =            X62 * Factor2            + X6g * FactorG + E6,
      V7 =                       X73 * Factor3 + X7g * FactorG + E7,
      V8 =                       X83 * Factor3 + X8g * FactorG + E8,
      V9 =                       X93 * Factor3 + X9g * FactorG + E9;
   variance
      Factor1-Factor3 = 3 * 1.,
      FactorG         = 1. ,
      E1-E9           = U1-U9;
   cov
      Factor1-Factor3 FactorG = 6 * 0.;
   bounds
      0. <= U1-U9;
   fitindex ON(ONLY)=[chisq df probchi];
run;

data _null_;
   df0 = 24; chi0 = 38.1963;
   df1 = 18; chi1 = 24.2163;
   diff = chi0-chi1;
   p = 1.-probchi(chi0-chi1,df0-df1);
   put 'Chi-square difference = ' diff;
   put 'p-value = ' p;
run;

proc calis corr data=Thurst method=max nobs=213 nose nostand;
   lineqs
      V1 = X11 * Factor1                          + X1g * FactorG + E1,
      V2 = X21 * Factor1                          + X2g * FactorG + E2,
      V3 = X31 * Factor1                          + X3g * FactorG + E3,
      V4 =              X42 * Factor2             + X4g * FactorG + E4,
      V5 =              X52 * Factor2             + X5g * FactorG + E5,
      V6 =              X62 * Factor2             + X6g * FactorG + E6,
      V7 =                          X73 * Factor3 + X7g * FactorG + E7,
      V8 =                          X83 * Factor3 + X8g * FactorG + E8,
      V9 =                          X93 * Factor3 + X9g * FactorG + E9;
   variance
      Factor1-Factor3 = 3 * 1.,
      FactorG         = 1. ,
      E1-E9           = U1-U9;
   cov
      Factor1-Factor3 FactorG = 6 * 0.;
   bounds
      0. <= U1-U9;
   fitindex ON(ONLY)=[chisq df probchi];
   parameters p1 (.5) p2 (.5) p3 (.5);
   /* Proportionality constraints */
   X1g = p1 * X11;
   X2g = p1 * X21;
   X3g = p1 * X31;
   X4g = p2 * X42;
   X5g = p2 * X52;
   X6g = p2 * X62;
   X7g = p3 * X73;
   X8g = p3 * X83;
   X9g = p3 * X93;
run;

