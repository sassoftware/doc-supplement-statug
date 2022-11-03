 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: PEARSON                                             */
 /*   TITLE: Pearson and Likelihood Ratio Chi-Squares            */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: categorical data analysis,                          */
 /*   PROCS: CATMOD                                              */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
 /*
   This program computes Pearson's goodness-of-fit chi-square
   statistic and the likelihood ratio statistic to test the
   goodness of fit of a multinomial distribution with equal
   probabilities.

   The first DATA step simulates one hundred trials of a
   multinomial experiment with ten equally-likely outcomes. The
   Pearson and likelihood ratio statistics are computed and
   printed in a subsequent DATA step.  Equal expected frequencies
   are used resulting in tests of the null hypothesis of equal
   probabilities.  The likelihood ratio test can more easily be
   obtained with the CATMOD procedure.  CATMOD is run twice to
   demonstrate its use with either the raw data set or a summary
   data set.
 */

 data multinom;
  do n=1 to 100;      /* multinomial, p(i)=.1, i=1,2,...,10 */
     y=rantbl(1,.1,.1,.1,.1,.1,.1,.1,.1,.1,.1);
     drop n;
     output;
  end;
  run;
proc freq;
  tables y / noprint out=cells;  /* data set of cell counts */
  run;
proc summary;
  var count;
  output out=summary             /* total count and number  */
         sum=total n=ncells;     /* of cells                */
  run;
data _null_;
  set cells nobs=ncells end=eof;
  if _n_=1 then set summary;
  cellexp=total/ncells;          /* uniform expected cell counts */
  cellchsq=(count-cellexp)**2    /* cell contribution */
           /    cellexp;         /*     to chi-square */
  chisq+cellchsq;                /* sum is Pearson chi-square   */
  cellg2=count*log(count/cellexp); /* cell contribution to G**2 */
  g2+cellg2;                     /* sum is one-half G**2        */
  if eof then do;
     g2=2*g2;
     df=ncells-1;
     pchisq=1-probchi(chisq,df);
     pg2=1-probchi(g2,df);
     put 'Pearson chi-square = ' chisq 'with '
         df 'degrees of freedom';
     put 'Pr > chisq = ' pchisq;
     put 'Likelihood ratio chi-square = ' g2 'with '
         df 'degrees of freedom';
     put 'Pr > chisq = ' pg2;
  end;
  run;

proc catmod data=cells;
  weight count;
  model y= / noint;
  quit;

proc catmod data=multinom;
  model y= / noint;
  quit;
