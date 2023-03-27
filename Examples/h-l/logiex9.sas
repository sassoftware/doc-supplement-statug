/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX9                                             */
/*   TITLE: Example 9 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 9. Goodness-of-Fit Tests and Subpopulations
*****************************************************************/

/*
A study is done to investigate the effects of two binary factors, A and B, on
a binary response, Y.  Subjects are randomly selected from subpopulations
defined by the four possible combinations of levels of A and B.  The number
of subjects responding with each level of Y is recorded and entered into data
set A.

First, a full model is fit to examine the main effects of A and B as well as
the interaction effect of A and B. Note that Pearson and Deviance
goodness-of-fit tests cannot be obtained for this model since a full model
containing four parameters is fit, leaving no residual degrees of freedom.
For a binary response model, the goodness-of-fit tests have m-q degrees of
freedom, where m is the number of subpopulations and q is the number of model
parameters. In the preceding model, m=q=4, resulting in zero degrees of
freedom for the tests.
*/

title 'Example 9: Goodness-of-Fit Tests and Subpopulations';

data One;
   do A=0,1;
      do B=0,1;
         do Y=1,2;
            input F @@;
            output;
         end;
      end;
   end;
   datalines;
23 63 31 70 67 100 70 104
;

proc logistic data=One;
   freq F;
   model Y=A B A*B;
run;


/*
Results of the model fit above show that neither the A*B interaction nor the
B main effect is significant. If a reduced model containing only the A effect
is fit, two degrees of freedom become available for testing goodness of fit.
Specifying the SCALE=NONE option requests the Pearson and deviance
statistics.  With single-trial syntax, the AGGREGATE= option is needed to
define the subpopulations in the study.

Specifying AGGREGATE=(A B) creates subpopulations of the four combinations of
levels of A and B. Although the B effect is being dropped from the model, it
is still needed to define the original subpopulations in the study. If
AGGREGATE=(A) were specified, only two subpopulations would be created from
the levels of A, resulting in m=q=2 and zero degrees of freedom for the
tests.
*/

proc logistic data=One;
   freq F;
   model Y=A / scale=none aggregate=(A B);
run;

