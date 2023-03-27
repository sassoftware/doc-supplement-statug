/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX04                                             */
/*   TITLE: Documentation Example 20 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: confirmatory factor model, cognitive abilities      */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 20                              */
/*    MISC:                                                     */
/****************************************************************/

title "Confirmatory Factor Analysis Using the FACTOR Modeling Language";
title2 "Cognitive Data";
data cognitive1(type=cov);
   _type_='cov';
   input _name_ $ reading1 reading2 reading3 math1 math2 math3
         writing1 writing2 writing3;
   datalines;
reading1 83.024    .      .      .      .      .      .      .      .
reading2 50.924 108.243   .      .      .      .      .      .      .
reading3 62.205  72.050 99.341   .      .      .      .      .      .
math1    22.522  22.474 25.731 82.214   .      .      .      .      .
math2    14.157  22.487 18.334 64.423 96.125   .      .      .      .
math3    22.252  20.645 23.214 49.287 58.177 88.625   .      .      .
writing1 33.433  42.474 41.731 25.318 14.254 27.370 90.734   .      .
writing2 24.147  20.487 18.034 22.106 26.105 22.346 53.891 96.543   .
writing3 13.340  20.645 23.314 19.387 28.177 38.635 55.347 52.999 98.445
;

proc calis data=cognitive1 nobs=64 modification;
   factor
      Read_Factor   ===> reading1-reading3 ,
      Math_Factor   ===> math1-math3       ,
      Write_Factor  ===> writing1-writing3 ;
   pvar
      Read_Factor Math_Factor Write_Factor = 3 * 1.;
   cov
      Read_Factor Math_Factor Write_Factor = 3 * 0.;
run;

proc calis data=cognitive1 nobs=64 modification;
   factor
      Read_Factor   ===> reading1-reading3 ,
      Math_Factor   ===> math1-math3       ,
      Write_Factor  ===> writing1-writing3 ;
   pvar
      Read_Factor Math_Factor Write_Factor = 3 * 1.;
   cov
      Read_Factor Math_Factor Write_Factor /* = 3 * 0. */;
run;

