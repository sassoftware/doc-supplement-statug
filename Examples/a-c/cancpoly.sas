 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: cancpoly                                            */
 /*   TITLE: Reducing Interaction with Canonical Correlation     */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: multivariate analysis, regression                   */
 /*   PROCS: ANOVA CANCORR SGPLOT STANDARD                       */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

/*------ Polynomial Conjoint Analysis ------*/
title 'Estimating a Polynomial Transformation to Reduce Interaction';
title2 'by Canonical Correlation';

data x;
   drop r;
   do a = 1 to 3;
      do b = 1 to 4;
         do r = 1 to 2;
            logx = (a + b/2.5 - 2) + rannor(12345)/5;
            x = exp(logx);
            output;
         end;
      end;
   end;
run;

proc standard m=0 s=1 out=b;
   var x logx;
run;

proc sgplot;
   scatter y=logx x=x;
run;

proc anova;
   classes a b;
   model x = a b a*b;
run;

data c;
   set b;
   a1 = (a = 2);
   a2 = (a = 3);
   b1 = (b = 2);
   b2 = (b = 3);
   b3 = (b = 4);
   x2 = x**2;
   x3 = x**3;
   x4 = x**4;
   x5 = x**5;
run;

proc cancorr ncan=1 out=canon(rename=(w1=xp3) drop=v1);
   var a1-a2 b1-b3;
   with x x2 x3;
run;

proc sgplot;
   scatter y=xp3 x=x / legendlabel='x';
   scatter y=xp3 x=logx / legendlabel='logx';
run;

proc anova;
   classes a b;
   model xp3 = a b a*b;
run;

proc cancorr ncan=1 out=canon(rename=(w1=xp5) drop=v1);
   var a1-a2 b1-b3;
   with x x2 x3 x4 x5;
run;

proc sgplot;
   scatter y=xp5 x=x / legendlabel='x';
   scatter y=xp5 x=logx / legendlabel='logx';
run;

proc anova;
   classes a b;
   model xp5 = a b a*b;
run;
