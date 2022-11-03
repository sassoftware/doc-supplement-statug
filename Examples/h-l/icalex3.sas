/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICALEX3                                             */
/*   TITLE: Documentation Example 4 for Introduction to SEM     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: measurement error model, Lord data                  */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Introduction to SEM, Example 4                      */
/*    MISC:                                                     */
/****************************************************************/

data lord(type=cov);
   input _type_ $ _name_ $ W X Y Z;
   datalines;
n   . 649       .       .       .
cov W 86.3979   .       .       .
cov X 57.7751 86.2632   .       .
cov Y 56.8651 59.3177 97.2850   .
cov Z 58.8986 59.6683 73.8201 97.8192
;

proc calis data=lord;
   path
      W <=== F1,
      X <=== F1,
      Y <=== F2,
      Z <=== F2;
   pvar
      F1 = 1.0,
      F2 = 1.0,
      W X Y Z;
   pcov
      F1 F2;
run;

proc calis data=lord;
   path
      W <=== F1,
      X <=== F1,
      Y <=== F2,
      Z <=== F2;
   pvar
      F1 = 1.0,
      F2 = 1.0,
      W X Y Z;
   pcov
      F1 F2 = 1.0;
run;

proc calis data=lord;
   path
      W <=== F1,
      X <=== F1,
      Y <=== F1,
      Z <=== F1;
   pvar
      F1 = 1.0,
      W X Y Z;
run;

proc calis data=lord;
   path
      W <=== F1   = beta1,
      X <=== F1   = beta1,
      Y <=== F2   = beta2,
      Z <=== F2   = beta2;
   pvar
      F1  = 1.0,
      F2  = 1.0,
      W X = 2 * theta1,
      Y Z = 2 * theta2;
   pcov
      F1 F2;
run;

proc calis data=lord;
   path
      W <=== F1   = beta1,
      X <=== F1   = beta1,
      Y <=== F2   = beta2,
      Z <=== F2   = beta2;
   pvar
      F1  = 1.0,
      F2  = 1.0,
      W X = 2 * theta1,
      Y Z = 2 * theta2;
   pcov
      F1 F2 = 1.0;
run;

proc calis data=lord;
   factor
      F1  ===>  W  X,
      F2  ===>  Y  Z;
   pvar
      F1 = 1.0,
      F2 = 1.0,
      W X Y Z;
   cov
      F1 F2;
run;

proc calis data=lord;
   factor
      F1  ===>  W  X    = 2 * beta1,
      F2  ===>  Y  Z    = 2 * beta2;
   pvar
      F1  = 1.0,
      F2  = 1.0,
      W X = 2 * theta1,
      Y Z = 2 * theta2;
   cov
      F1 F2;
run;

title 'RAM Specification of the Full Model for Lord Data';
proc calis data=lord;
   ram var=W X Y Z F1 F2,
       _A_   1  5,
       _A_   2  5,
       _A_   3  6,
       _A_   4  6,
       _P_   5  5  1.0,
       _P_   6  6  1.0;
   fitindex on(only) = [chisq df probchi SRMSR RMSEA BENTLERCFI AGFI]
                       noindextype;
run;

proc calis data=lord;
   ram var = W X Y Z F1 F2, /* W=1, X=2, Y=3, Z=4, F1=5, F2=6*/
       _A_   1  5  beta1,
       _A_   2  5  beta1,
       _A_   3  6  beta2,
       _A_   4  6  beta2,
       _P_   5  5  1.0,
       _P_   6  6  1.0,
       _P_   1  1  theta1,
       _P_   2  2  theta1,
       _P_   3  3  theta2,
       _P_   4  4  theta2,
       _P_   5  6  ;
run;
