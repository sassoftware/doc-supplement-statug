/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmxex09                                             */
/*   TITLE: Documentation Example 9 for PROC GLIMMIX            */
/*          Testing Equality of Covariance and Correlation      */
/*          Matrices                                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          COVTEST statement                                   */
/*          Contrast among covariance parameters                */
/*   PROCS: GLIMMIX                                             */
/*    DATA: Fisher's iris data                                  */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc print data=Sashelp.iris(obs=10);
run;

data iris_univ;
   set sashelp.iris;
   retain id 0;
   array y (4) SepalLength SepalWidth PetalLength PetalWidth;
   id+1;
   do var=1 to 4;
      response = y{var};
      output;
   end;
   drop SepalLength SepalWidth PetalLength PetalWidth:;
run;

ods select FitStatistics CovParms CovTests;
proc glimmix data=iris_univ;
   class species var id;
   model response = species*var;
   random _residual_ / type=un group=species subject=id;
   covtest homogeneity;
run;


ods select FitStatistics CovParms CovTests;
proc glimmix data=iris_univ;
   class species var id;
   model response = species*var;
   random _residual_ / type=unr group=species subject=id;
   covtest 'Equal Covariance Matrices'  homogeneity;
   covtest 'Equal Correlation Matrices' general
        0  0  0  0  1  0  0  0  0  0
        0  0  0  0 -1  0  0  0  0  0,
        0  0  0  0  1  0  0  0  0  0
        0  0  0  0  0  0  0  0  0  0
        0  0  0  0 -1  0  0  0  0  0,
        0  0  0  0  0  1  0  0  0  0
        0  0  0  0  0 -1  0  0  0  0,
        0  0  0  0  0  1  0  0  0  0
        0  0  0  0  0  0  0  0  0  0
        0  0  0  0  0 -1  0  0  0  0,
        0  0  0  0  0  0  1  0  0  0
        0  0  0  0  0  0 -1  0  0  0,
        0  0  0  0  0  0  1  0  0  0
        0  0  0  0  0  0  0  0  0  0
        0  0  0  0  0  0 -1  0  0  0,
        0  0  0  0  0  0  0  1  0  0
        0  0  0  0  0  0  0 -1  0  0,
        0  0  0  0  0  0  0  1  0  0
        0  0  0  0  0  0  0  0  0  0
        0  0  0  0  0  0  0 -1  0  0,
        0  0  0  0  0  0  0  0  1  0
        0  0  0  0  0  0  0  0 -1  0,
        0  0  0  0  0  0  0  0  1  0
        0  0  0  0  0  0  0  0  0  0
        0  0  0  0  0  0  0  0  -1 0,
        0  0  0  0  0  0  0  0  0  1
        0  0  0  0  0  0  0  0  0 -1,
        0  0  0  0  0  0  0  0  0  1
        0  0  0  0  0  0  0  0  0  0
        0  0  0  0  0  0  0  0  0 -1 / estimates;
run;

