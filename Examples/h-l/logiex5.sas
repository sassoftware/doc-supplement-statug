/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX5                                             */
/*   TITLE: Example 5 for PROC LOGISTIC                         */
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
Example 5. Stratified Sampling
*****************************************************************/

/*
Consider the hypothetical example in Fleiss (1981, pp. 6-7) in
which a test is applied to a sample of 1000 people known to have a
disease and to another sample of 1000 people known not to have the
same disease. In the diseased sample, 950 were tested positively;
in the nondiseased sample, only 10 were tested positively. If the
true disease rate in the population is 1 in 100, you should specify
PEVENT= .01 in order to obtain the correct positive and negative
predictive values for the stratified sampling scheme. Omitting the
PEVENT= option is equivalent to using the overall sample disease
rate (1000/2000 = .5) as the value of the PEVENT= option and
thereby ignoring the stratified sampling.
*/

title 'Example 5. Stratified Sampling';

data Screen;
   do Disease='Present','Absent';
      do Test=1,0;
         input Count @@;
         output;
      end;
   end;
   datalines;
950  50
 10 990
;

proc logistic data=Screen;
   freq Count;
   model Disease(event='Present')=Test
         / pevent=.5 .01 ctable pprob=.5;
run;

