/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SVREX1                                              */
/*   TITLE: Documentation Example 1 for PROC SURVEYREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: regression, survey sampling                         */
/*    KEYS: unequal weighting, linear model                     */
/*    KEYS: simple random sampling                              */
/*   PROCS: SURVEYREG                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYREG, Example 1                           */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Labor;
   input City $ 1-16 LFPR1972 LFPR1968;
   datalines;
New York        .45     .42
Los Angeles     .50     .50
Chicago         .52     .52
Philadelphia    .45     .45
Detroit         .46     .43
San Francisco   .55     .55
Boston          .60     .45
Pittsburgh      .49     .34
St. Louis       .35     .45
Connecticut     .55     .54
Washington D.C. .52     .42
Cincinnati      .53     .51
Baltimore       .57     .49
Newark          .53     .54
Minn/St. Paul   .59     .50
Buffalo         .64     .58
Houston         .50     .49
Patterson       .57     .56
Dallas          .64     .63
;

ods graphics on;
title 'Study of Labor Force Participation Rates of Women';
proc surveyreg data=Labor total=200;
   model LFPR1972 = LFPR1968;
run;
