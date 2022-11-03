 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMMCSLO                                            */
 /*   TITLE: Multiple Comparisons of Slopes                      */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance,                                */
 /*   PROCS: GLM SUMMARY                                         */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Multiple Comparisons of Slopes in Independent Samples';

* Create artificial data with 5 classes and the following
  parameters:

     class        1    2    3    4    5
     slope        1   .5  .33  .25  .20
     intercept    1    2    3    4    5
;
data xy;
   drop n;
   do class=1 to 5;
      do n=1 to 10+class;
         x=rannor(1);
         y=class+x/class+rannor(1)/5;
         output;
         end;
      end;
run;

* Usual GLM analysis;
proc glm data=xy;
   class class;
   model y=class x(class)/solution ss1 noint;
run;

* Produce data set with class means;
proc summary data=xy nway;
   class class;
   var x y;
   output out=mean mean=xbar ybar;
run;

* Compute new variable such that the weighted mean in each
  class will equal the estimated slope, and create noise
  variables that will be used later to reduce the error
  degrees of freedom;
data slopint;
   array noise noise1-noise5;
   merge xy mean;
   by class;
   slope=(y-ybar)/(x-xbar);
   weight=abs(x-xbar)**2;
   do over noise; noise=ranuni(1); end;
run;

* Orthogonalize the noise variables to the real variables;
proc glm data=slopint;
   weight weight;
   class class;
   model noise1-noise5=slope class/nouni ss1 noint;
   output out=slopint2 r=res1-res5;
run;

* Do the multiple comparisons of means which are really slopes;
proc glm data=slopint2;
   weight weight;
   class class;
   model slope=class res1-res5/solution ss1 noint;
   means class/tukey;
run;
