/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX10                                             */
/*   TITLE: Example 10 for PROC CATMOD                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis                           */
/*   PROCS: CATMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC CATMOD chapter          */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Example 10: Direct Input of Response Functions and Covariance Matrix

             Health Survey Data Analysis
             ---------------------------
Variational models are fit to health survey data. Estimates
of a well-being index have been computed for domains
corresponding to an age by sex cross-classification.

From: Koch and Stokes (1979).
----------------------------------------------------------------*/

data fbeing(type=est);
   input   b1-b5   _type_ $  _name_ $  b6-b10 #2;
   datalines;
 7.93726   7.92509   7.82815   7.73696   8.16791  parms    .
 7.24978   7.18991   7.35960   7.31937   7.55184
 0.00739   0.00019   0.00146  -0.00082   0.00076  cov      b1
 0.00189   0.00118   0.00140  -0.00140   0.00039
 0.00019   0.01172   0.00183   0.00029   0.00083  cov      b2
-0.00123  -0.00629  -0.00088  -0.00232   0.00034
 0.00146   0.00183   0.01050  -0.00173   0.00011  cov      b3
 0.00434  -0.00059  -0.00055   0.00023  -0.00013
-0.00082   0.00029  -0.00173   0.01335   0.00140  cov      b4
 0.00158   0.00212   0.00211   0.00066   0.00240
 0.00076   0.00083   0.00011   0.00140   0.01430  cov      b5
-0.00050  -0.00098   0.00239  -0.00010   0.00213
 0.00189  -0.00123   0.00434   0.00158  -0.00050  cov      b6
 0.01110   0.00101   0.00177  -0.00018  -0.00082
 0.00118  -0.00629  -0.00059   0.00212  -0.00098  cov      b7
 0.00101   0.02342   0.00144   0.00369   0.00253
 0.00140  -0.00088  -0.00055   0.00211   0.00239  cov      b8
 0.00177   0.00144   0.01060   0.00157   0.00226
-0.00140  -0.00232   0.00023   0.00066  -0.00010  cov      b9
-0.00018   0.00369   0.00157   0.02298   0.00918
 0.00039   0.00034  -0.00013   0.00240   0.00213  cov     b10
-0.00082   0.00253   0.00226   0.00918   0.01921
;

proc catmod data=fbeing;
   title 'Complex Sample Survey Analysis';
   response read b1-b10;
   factors sex $ 2, age $ 5 / _response_=sex age
                              profile=(male     '25-34',
                                       male     '35-44',
                                       male     '45-54',
                                       male     '55-64',
                                       male     '65-74',
                                       female   '25-34',
                                       female   '35-44',
                                       female   '45-54',
                                       female   '55-64',
                                       female   '65-74');
   model _f_=_response_
         / design title='Main Effects for Sex and Age';
run;

   contrast 'No Age Effect for Age<65' all_parms 0 0 1 0 0 -1,
                                       all_parms 0 0 0 1 0 -1,
                                       all_parms 0 0 0 0 1 -1;
run;

   model _f_=(1  1  1,
              1  1  1,
              1  1  1,
              1  1  1,
              1  1 -1,
              1 -1  1,
              1 -1  1,
              1 -1  1,
              1 -1  1,
              1 -1 -1)
                      (1='Intercept' ,
                       2='Sex'       ,
                       3='Age (25-64 vs. 65-74)')
         / design title='Binary Age Effect (25-64 vs. 65-74)' ;
run;
quit;
