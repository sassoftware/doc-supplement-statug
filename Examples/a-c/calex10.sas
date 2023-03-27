/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX10                                             */
/*   TITLE: Documentation Example 28 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple-group model, purchase behavior             */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 28                              */
/*    MISC:                                                     */
/****************************************************************/

data region1(type=cov);
   input _type_ $6. _name_ $12. Spend02 Spend03 Courtesy Responsive
         Helpful Delivery Pricing Availability Quality;
   datalines;
COV   Spend02      14.428  2.206  0.439 0.520 0.459 0.498 0.635 0.642 0.769
COV   Spend03       2.206 14.178  0.540 0.665 0.560 0.622 0.535 0.588 0.715
COV   Courtesy      0.439  0.540  1.642 0.541 0.473 0.506 0.109 0.120 0.126
COV   Responsive    0.520  0.665  0.541 2.977 0.582 0.629 0.119 0.253 0.184
COV   Helpful       0.459  0.560  0.473 0.582 2.801 0.546 0.113 0.121 0.139
COV   Delivery      0.498  0.622  0.506 0.629 0.546 3.830 0.120 0.132 0.145
COV   Pricing       0.635  0.535  0.109 0.119 0.113 0.120 2.152 0.491 0.538
COV   Availability  0.642  0.588  0.120 0.253 0.121 0.132 0.491 2.372 0.589
COV   Quality       0.769  0.715  0.126 0.184 0.139 0.145 0.538 0.589 2.753
MEAN     .        183.500 301.921 4.312 4.724 3.921 4.357 6.144 4.994 5.971
;

data region2(type=cov);
   input _type_ $6. _name_ $12. Spend02 Spend03 Courtesy Responsive
         Helpful Delivery Pricing Availability Quality;
   datalines;
COV   Spend02       14.489   2.193 0.442 0.541 0.469 0.508 0.637 0.675 0.769
COV   Spend03        2.193  14.168 0.542 0.663 0.574 0.623 0.607 0.642 0.732
COV   Courtesy       0.442   0.542 3.282 0.883 0.477 0.120 0.248 0.283 0.387
COV   Responsive     0.541   0.663 0.883 2.717 0.477 0.601 0.421 0.104 0.105
COV   Helpful        0.469   0.574 0.477 0.477 2.018 0.507 0.187 0.162 0.205
COV   Delivery       0.508   0.623 0.120 0.601 0.507 2.999 0.179 0.334 0.099
COV   Pricing        0.637   0.607 0.248 0.421 0.187 0.179 2.512 0.477 0.423
COV   Availability   0.675   0.642 0.283 0.104 0.162 0.334 0.477 2.085 0.675
COV   Quality        0.769   0.732 0.387 0.105 0.205 0.099 0.423 0.675 2.698
MEAN     .         156.250 313.670 2.412 2.727 5.224 6.376 7.147 3.233 5.119
;

proc calis meanstr;
   group 1 / data=region1 label="Region 1" nobs=378;
   group 2 / data=region2 label="Region 2" nobs=423;
   model 1 / group=1,2;
      path
         Service ===> Spend02  Spend03      ,
         Product ===> Spend02  Spend03      ,
         Spend02 ===> Spend03               ,
         Service ===> Courtesy Responsive
                      Helpful Delivery      ,
         Product ===> Pricing  Availability
                      Quality               ;
      pvar
         Courtesy Responsive Helpful Delivery Pricing
         Availability Quality Spend02 Spend03,
         Service Product = 2 * 1.;
      pcov
         Service Product;
run;

proc calis meanstr;
   group 1 / data=region1 label="Region 1" nobs=378;
   group 2 / data=region2 label="Region 2" nobs=423;
   model 1 / group=1;
      path
         Service ===> Spend02  Spend03      ,
         Product ===> Spend02  Spend03      ,
         Spend02 ===> Spend03               ,
         Service ===> Courtesy Responsive Helpful Delivery  ,
         Product ===> Pricing  Availability Quality ;
      pvar
         Courtesy Responsive Helpful Delivery Pricing
         Availability Quality Spend02 Spend03,
         Service Product = 2 * 1.;
      pcov
         Service Product;
   model 2 / group=2;
      refmodel 1/ allnewparms;
run;

proc calis meanstr modification;
   group 1 / data=region1 label="Region 1" nobs=378;
   group 2 / data=region2 label="Region 2" nobs=423;
   model 3 / label="Model for References Only";
      path
         Service ===> Spend02  Spend03      ,
         Product ===> Spend02  Spend03      ,
         Spend02 ===> Spend03               ,
         Service ===> Courtesy Responsive
                      Helpful Delivery      ,
         Product ===> Pricing  Availability
                      Quality               ;
      pvar
         Courtesy Responsive Helpful Delivery Pricing
         Availability Quality Spend02 Spend03,
         Service Product = 2 * 1.;
      pcov
         Service Product;
   model 1 / groups=1;
      refmodel 3;
      mean
         Spend02 Spend03 = G1_InterSpend02 G1_InterSpend03,
         Courtesy Responsive Helpful
         Delivery Pricing Availability
         Quality = G1_intercept01-G1_intercept07;
   model 2 / groups=2;
      refmodel 3;
      mean
         Spend02 Spend03 = G2_InterSpend02 G2_InterSpend03,
         Courtesy Responsive Helpful
         Delivery Pricing Availability
         Quality = G2_intercept01-G2_intercept07;
      simtests
         SpendDiff       = (Spend02Diff Spend03Diff)
         MeasurementDiff = (CourtesyDiff ResponsiveDiff
                            HelpfulDiff DeliveryDiff
                            PricingDiff AvailabilityDiff
                            QualityDiff);
      Spend02Diff      = G2_InterSpend02 - G1_InterSpend02;
      Spend03Diff      = G2_InterSpend03 - G1_InterSpend03;
      CourtesyDiff     = G2_intercept01  - G1_intercept01;
      ResponsiveDiff   = G2_intercept02  - G1_intercept02;
      HelpfulDiff      = G2_intercept03  - G1_intercept03;
      DeliveryDiff     = G2_intercept04  - G1_intercept04;
      PricingDiff      = G2_intercept05  - G1_intercept05;
      AvailabilityDiff = G2_intercept06  - G1_intercept06;
      QualityDiff      = G2_intercept07  - G1_intercept07;
run;

