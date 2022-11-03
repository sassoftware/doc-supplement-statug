/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: plmex7                                              */
/*   TITLE: Example 7 for PROC PLM                              */
/*    DESC: SIMULATED Data                                      */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: GLIMMIX,PLM                                         */
/*                                                              */
/****************************************************************/
data parms;
   length name $6;
   input Name$ Value;
   datalines;
alpha1 -3.5671
beta1   0.4421
gamma1 -2.6230
alpha2 -3.0111
beta2   0.3977
gamma2 -2.4442
;
data cov;
   input Parm row col1-col6;
   datalines;
1 1  0.007462 -0.005222  0.010234  0.000000  0.000000  0.000000
1 2 -0.005222  0.048197 -0.010590  0.000000  0.000000  0.000000
1 3  0.010234 -0.010590  0.215999  0.000000  0.000000  0.000000
1 4  0.000000  0.000000  0.000000  0.031261 -0.009096  0.015785
1 5  0.000000  0.000000  0.000000 -0.009096  0.039487 -0.019996
1 6  0.000000  0.000000  0.000000  0.015785 -0.019996  0.126172
;
proc glimmix data=parms order=data;
   class Name;
   model Value = Name / noint ddfm=none s;
   random _residual_ / type=lin(1) ldata=cov v;
   parms (1) / noiter;
   store ArtificialModel;
   title 'Linear Inference';
run;
proc plm restore=ArtificialModel;
   estimate
       'alpha1 = alpha2' Name 1  0  0 -1  0  0,
       'beta1  = beta2 ' Name 0  1  0  0 -1  0,
       'gamma1 = gamma2' Name 0  0  1  0  0 -1 /
                adjust=bon stepdown ftest(label='Homogeneity');
run;
