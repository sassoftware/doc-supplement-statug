 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMFRACT                                            */
 /*   TITLE: Fractional Factorial with Repeated Measures         */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance, repeated measures analysis    */
 /*   PROCS: GLM PLOT                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

*-----------------------------------------------------------------
  The data are from a simulation experiment comparing three
  methods for initializing a multidimensional scaling algorithm.
  The methods are OLD, NEW, and RANDOM. The dependent variable is
  CPU time.  Smaller values are better.
------------------------------------------------------------------;

proc format;
   value level
      1='Low'
      2='Medium'
      3='High';
run;

data init;
   input stim sub dim error old new random;

   array x  old  new  random;
   array xl OldL NewL RandomL;
   do over x; xl=log(x); end;

   label stim='Number of Stimuli'
         sub='Number of Subjects'
         dim='Number of Dimensions'
         error='Error Level'
         old='Old Initialization Method'
         new='New Initialization Method'
         random='Random Initialization'
         oldl='LOG Old Initialization Method'
         newl='LOG New Initialization Method'
         randoml='LOG Random Initialization';
   format error level.;
   datalines;
10 10 5 1     26    40    50
20 20 4 1    187    99   182
30 30 3 1    362   245   415
40 40 2 1    623   511   790
50 50 6 1   4252  2034  4266
10 20 2 1     17    18    22
20 30 6 1    426   205   481
30 40 5 1    750   455   936
40 50 4 1   1338   973  1853
50 10 3 1    417   306   429
10 30 4 2    109    66   109
20 40 3 2    240   171   230
30 50 2 2    446   362   539
40 10 6 2    928   352   662
50 20 5 2   1270   832  1652
10 40 6 3    218   158   359
20 50 5 3    638   322   624
30 10 4 3    222   150   241
40 20 3 3    692   352   478
50 30 2 3    687   602  1007
10 50 3 3    258   102   246
20 10 2 3     38    38    45
30 20 6 3    605   335  1000
40 30 5 3   1093   709  1253
50 40 4 3   1990  1159  2501
;

proc print label;
   id stim sub dim error;
   var random old new;
run;

*-----------------------------------------------------------------
  A preliminary analysis is done to get univariate statistics and
  do a residual-by-predicted plot.
------------------------------------------------------------------;

title 'Analysis of CPU Times';
proc glm data=init;
   class stim sub dim error;
   model random old new = stim sub dim error / ss1;
   output out=out r=RandomR OldR NewR
                  p=RandomP OldP NewP;
run; quit;

title2 'Plot of Residuals by Predicted Values';
proc sgplot data=out;
   scatter y=oldr x=oldp;
run;

proc sgplot data=out;
   scatter y=newr x=newp;
run;

proc sgplot data=out;
   scatter y=randomr x=randomp;
run;

*-----------------------------------------------------------------
  The first plot shows nonlinearity and unequal variances, so we
  try again with logarithms instead of raw CPU times.
------------------------------------------------------------------;

title 'Analysis of LOG(CPU Times)';
proc glm data=init;
   class stim sub dim error;
   model randoml oldl newl = stim sub dim error / ss1;
   repeated method 3 / nou summary;
   output out=outl r=RandomR OldR NewR
                   p=RandomP OldP NewP;
   lsmeans stim / out=ostim;
   lsmeans sub / out=osub;
   lsmeans dim / out=odim;
   lsmeans error / out=oerror;
run; quit;

title2 'Plot of Residuals by Predicted Values';
proc sgplot data=outl;
   scatter y=oldr x=oldp;
run;

proc sgplot data=out;
   scatter y=newr x=newp;
run;

proc sgplot data=out;
   scatter y=randomr x=randomp;
run;

title2 'Plot of Marginal Means';

proc sgplot data=ostim;
   scatter y=lsmean x=stim / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

proc sgplot data=osub;
   scatter y=lsmean x=sub / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

proc sgplot data=odim;
   scatter y=lsmean x=dim / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

proc sgplot data=oerror;
   scatter y=lsmean x=error / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

*-----------------------------------------------------------------
  A possible outlier is evident in the lower left corner of the
  residual-by-predicted plots for RANDOM and NEW. The analysis is
  repeated with the outlier removed by a WHERE statement. The
  design is no longer orthogonal, so SS3 is specified in the MODEL
  statement instead of SS2.
------------------------------------------------------------------;

title 'Analysis of LOG(CPU Times) with Outlier Removed';
proc glm data=outl(drop   = oldr newr randomp oldp newp
                   rename = (randomr=resid));
   where resid > -.3;
   class stim sub dim error;
   model randoml oldl newl = stim sub dim error / ss3;
   repeated method 3 / nou summary;
   output out=out r=RandomR OldR NewR
                   p=RandomP OldP NewP;
   lsmeans stim / out=ostim;
   lsmeans sub / out=osub;
   lsmeans dim / out=odim;
   lsmeans error / out=oerror;
run; quit;

title2 'Plot of Residuals by Predicted Values';
proc sgplot data=out;
   scatter y=oldr x=oldp;
run;

proc sgplot data=out;
   scatter y=newr x=newp;
run;

proc sgplot data=out;
   scatter y=randomr x=randomp;
run;

title2 'Plot of Marginal Means';

proc sgplot data=ostim;
   scatter y=lsmean x=stim / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

proc sgplot data=osub;
   scatter y=lsmean x=sub / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

proc sgplot data=odim;
   scatter y=lsmean x=dim / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;

proc sgplot data=oerror;
   scatter y=lsmean x=error / markerchar=_name_;
   label lsmean='LOG(CPU Time)';
run;
