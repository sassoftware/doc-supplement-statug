/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: stdizeex                                            */
/*   TITLE: Documentation Examples for PROC STDIZE              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Standardization, Cluster Analysis                   */
/*   PROCS: STDIZE, FASTCLUS, FREQ                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC STDIZE, EXAMPLE                                */
/*    MISC:                                                     */
/****************************************************************/

title 'Fish Measurement Data';

data Fish;
   set sashelp.fish;
   if Weight <= 0 or Weight = . then delete;
   Weight3 = Weight ** (1/3);
   Height = Height / Weight3;
   Width  = Width  / Weight3;
   Length1 = Length1 / Weight3;
   Length2 = Length2 / Weight3;
   Length3 = Length3 / Weight3;
   LogLengthRatio = log(Length3 / Length1);
run;

/*--- macro for standardization ---*/

%macro Std(mtd);
   title2 "Data are Standardized by PROC STDIZE with METHOD= &mtd";
   proc stdize data=fish out=sdzout method=&mtd;
      var Length1 logLengthRatio Height Width Weight3;
   run;
%mend Std;

/*--- macro for clustering and crosstabulating ---*/
/*--- cluster membership with species ---*/

%macro FastFreq(ds);
   proc fastclus data=&ds out=clust maxclusters=7 maxiter=100 noprint;
      var Length1 logLengthRatio Height Width Weight3;
   run;

   proc freq data=clust;
      tables species*cluster;
   run;
%mend FastFreq;

/*     Approach 1: data are standardized by PROC STDIZE   */

%Std(MEAN);
%FastFreq(sdzout);

%Std(MEDIAN);
%FastFreq(sdzout);

%Std(SUM);
%FastFreq(sdzout);

%Std(EUCLEN);
%FastFreq(sdzout);

%Std(USTD);
%FastFreq(sdzout);

%Std(STD);
%FastFreq(sdzout);

%Std(RANGE);
%FastFreq(sdzout);

%Std(MIDRANGE);
%FastFreq(sdzout);

%Std(MAXABS);
%FastFreq(sdzout);

%Std(IQR);
%FastFreq(sdzout);

%Std(MAD);
%FastFreq(sdzout);

%Std(AGK(.14));
%FastFreq(sdzout);

%Std(SPACING(.14));
%FastFreq(sdzout);

%Std(ABW(5));
%FastFreq(sdzout);

%Std(AWAVE(5));
%FastFreq(sdzout);

%Std(L(1));
%FastFreq(sdzout);

%Std(L(1.5));
%FastFreq(sdzout);

%Std(L(2));
%FastFreq(sdzout);

%Std(STD);
%FastFreq(sdzout);

%Std(RANGE);
%FastFreq(sdzout);

%Std(AGK(.14));
%FastFreq(sdzout);

%Std(SPACING(.14));
%FastFreq(sdzout);

/*         Approach 2: data are untransformed             */

title2 'Data are Untransformed';
%FastFreq(fish);

/*    Approach 3: data are transformed by PROC ACECLUS    */

title2 'Data are Transformed by PROC ACECLUS';
proc aceclus data=fish out=ace p=.02 noprint;
   var Length1 logLengthRatio Height Width Weight3;
run;
%FastFreq(ace);

