/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FASTEX2                                             */
/*   TITLE: Example 2 for PROC FASTCLUS                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: cluster analysis, effect of outliers                */
/*   PROCS: FASTCLUS, SGPLOT, SGSCATTER                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC FASTCLUS, EXAMPLE 2.                           */
/*    MISC:                                                     */
/****************************************************************/

title 'Using PROC FASTCLUS to Analyze Data with Outliers';
data x;
   drop n;
   do n=1 to 100;
      x=rannor(12345)+2;
      y=rannor(12345);
      output;
   end;
   do n=1 to 100;
      x=rannor(12345)-2;
      y=rannor(12345);
      output;
   end;
   do n=1 to 10;
      x=10*rannor(12345);
      y=10*rannor(12345);
      output;
   end;
run;

title2 'Preliminary PROC FASTCLUS Analysis with 20 Clusters';
proc fastclus data=x outseed=mean1 maxc=20 maxiter=0 summary;
   var x y;
run;

proc sgscatter data=mean1;
   compare y=(_gap_ _radius_) x=_freq_;
run;

   /*    Remove low frequency clusters.  */

data seed;
   set mean1;
   if _freq_>5;
run;

title2 'PROC FASTCLUS Analysis Using LEAST= Clustering Criterion';
title3 'Values < 2 Reduce Effect of Outliers on Cluster Centers';
proc fastclus data=x seed=seed maxc=2 least=1 out=out;
   var x y;
run;

proc sgplot data=out;
   scatter y=y x=x / group=cluster;
run;

   /*   Run PROC FASTCLUS again, selecting seeds from the        */
   /*   high frequency clusters in the previous analysis         */
   /*   STRICT= prevents outliers from distorting the results.   */

title2 'PROC FASTCLUS Analysis Using STRICT= to Omit Outliers';
proc fastclus data=x seed=seed
     maxc=2 strict=3.0 out=out outseed=mean2;
   var x y;
run;

proc sgplot data=out;
   scatter y=y  x=x / group=cluster;
run;

   /* Run PROC FASTCLUS one more time with zero iterations */
   /* to assign outliers and tails to clusters.            */

title2 'Final PROC FASTCLUS Analysis Assigning Outliers to Clusters';
proc fastclus data=x seed=mean2 maxc=2 maxiter=0 out=out;
   var x y;
run;

proc sgplot data=out;
   scatter y=y x=x / group=cluster;
run;

