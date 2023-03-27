/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmxex06                                             */
/*   TITLE: Documentation Example 6 for PROC GLIMMIX            */
/*          Radial Smoothing of Repeated Measures Data          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Mixed model smoothing                               */
/*          Smooth temporal trends                              */
/*   PROCS: GLIMMIX, SORT, SGPANEL                              */
/*    DATA: Diggle, P.J., Liang, K.-Y., and Zeger, S.L. (1994)  */
/*          Analysis of Longitudinal Data                       */
/*          Oxford, UK: Oxford University Press                 */
/*                                                              */
/*     REF                                                      */
/*    MISC:                                                     */
/****************************************************************/

data times;
   input time1-time23;
   datalines;
 122  150  166  179  219  247  276  296  324  354  380  445
 478  508  536  569  599  627  655  668  723  751  781
;

data cows;
   if _n_ = 1 then merge times;
   array t{23} time1   - time23;
   array w{23} weight1 - weight23;
   input cow iron infection weight1-weight23 @@;
   do i=1 to 23;
      weight = w{i};
      tpoint = (t{i}-t{1})/10;
      output;
   end;
   keep cow iron infection tpoint weight;
   datalines;
  1 0 0  4.7    4.905  5.011  5.075  5.136  5.165  5.298  5.323
         5.416  5.438  5.541  5.652  5.687  5.737  5.814  5.799
         5.784  5.844  5.886  5.914  5.979  5.927  5.94
  2 0 0  4.868  5.075  5.193  5.22   5.298  5.416  5.481  5.521
         5.617  5.635  5.687  5.768  5.799  5.872  5.886  5.872
         5.914  5.966  5.991  6.016  6.087  6.098  6.153
  3 0 0  4.868  5.011  5.136  5.193  5.273  5.323  5.416  5.46
         5.521  5.58   5.617  5.687  5.72   5.753  5.784  5.784
         5.784  5.814  5.829  5.872  5.927  5.9    5.991
  4 0 0  4.828  5.011  5.136  5.193  5.273  5.347  5.438  5.561
         5.541  5.598  5.67    .     5.737  5.844  5.858  5.872
         5.886  5.927  5.94   5.979  6.052  6.028  6.12
  5 1 0  4.787  4.977  5.043  5.136  5.106  5.298  5.298  5.371
         5.438  5.501  5.561  5.652  5.67   5.737  5.784  5.768
         5.784  5.784  5.829  5.858  5.914  5.9    5.94
  6 1 0  4.745  4.868  5.043  5.106  5.22   5.298  5.347  5.347
         5.416  5.501  5.561  5.58   5.687  5.72   5.737  5.72
         5.737  5.753  5.768  5.784  5.844  5.844  5.9
  7 1 0  4.745  4.905  5.011  5.106  5.165  5.273  5.371  5.416
         5.416  5.521  5.541  5.635  5.687  5.704  5.784  5.768
         5.768  5.814  5.829  5.858  5.94   5.94   6.004
  8 0 1  4.942  5.106  5.136  5.193  5.298  5.347  5.46   5.521
         5.561  5.58   5.635  5.704  5.784  5.823  5.858  5.9
         5.94   5.991  6.016  6.064  6.052  6.016  5.979
  9 0 1  4.605  4.745  4.868  4.905  4.977  5.22   5.165  5.22
         5.22   5.247  5.298  5.416  5.501  5.521  5.58   5.58
         5.635  5.67   5.72   5.753  5.799  5.829  5.858
 10 0 1  4.7    4.868  4.905  4.977  5.011  5.106  5.165  5.22
         5.22   5.22   5.273  5.384  5.438  5.438  5.501  5.501
         5.541  5.598  5.58   5.635  5.687  5.72   5.704
 11 0 1  4.828  5.011  5.075  5.165  5.247  5.323  5.394  5.46
         5.46   5.501  5.541  5.609  5.687  5.704  5.72   5.704
         5.704  5.72   5.737  5.768  5.858  5.9    5.94
 12 0 1  4.7    4.828  4.905  5.011  5.075  5.165  5.247  5.298
         5.298  5.323  5.416  5.505  5.561  5.58   5.561  5.635
         5.687  5.72   5.72   5.737  5.784  5.814  5.799
 13 0 1  4.828  5.011  5.075  5.136  5.22   5.273  5.347  5.416
         5.438  5.416  5.521  5.628  5.67   5.687  5.72   5.72
         5.799  5.858  5.872  5.914  5.94   5.991  6.016
 14 0 1  4.828  4.942  5.011  5.075  5.075  5.22   5.273  5.298
         5.323  5.298  5.394  5.489  5.541  5.58   5.617  5.67
         5.704  5.753  5.768  5.814  5.872  5.927  5.927
 15 0 1  4.745  4.905  4.977  5.075  5.193  5.22   5.298  5.323
         5.394  5.394  5.438  5.583  5.617  5.652  5.687  5.72
         5.753  5.768  5.814  5.844  5.886  5.886  5.886
 16 0 1  4.7    4.868  5.011  5.043  5.106  5.165  5.247  5.298
         5.347  5.371  5.438  5.455  5.617  5.635  5.704  5.737
         5.784  5.768  5.814  5.844  5.886  5.94   5.927
 17 1 1  4.605  4.787  4.828  4.942  5.011  5.136  5.22   5.247
         5.273  5.247  5.347  5.366  5.416  5.46   5.541  5.481
         5.501  5.635  5.652  5.598  5.635  5.635  5.598
 18 1 1  4.828  4.977  5.011  5.136  5.273  5.298  5.371  5.46
         5.416  5.416  5.438  5.557  5.617  5.67   5.72   5.72
         5.799  5.858  5.886  5.914  5.979  6.004  6.028
 19 1 1  4.7    4.905  4.942  5.011  5.043  5.136  5.193  5.193
         5.247  5.22   5.323  5.338  5.371  5.394  5.438  5.416
         5.501  5.561  5.541  5.58   5.652  5.67   5.704
 20 1 1  4.745  4.905  4.977  5.043  5.136  5.273  5.347  5.394
         5.416  5.394  5.521  5.617  5.617  5.617  5.67   5.635
         5.652  5.687  5.652  5.617  5.687  5.768  5.814
 21 1 1  4.787  4.942  4.977  5.106  5.165  5.247  5.323  5.416
         5.394  5.371  5.438  5.521  5.521  5.561  5.635  5.617
         5.687  5.72   5.737  5.737  5.768  5.768  5.704
 22 1 1  4.605  4.828  4.828  4.977  5.043  5.165  5.22   5.273
         5.247  5.22   5.298  5.375  5.371  5.416  5.501  5.501
         5.521  5.561  5.617  5.635  5.72   5.737  5.768
 23 1 1  4.7    4.905  5.011  5.075  5.106  5.22   5.22   5.298
         5.323  5.347  5.416  5.472  5.501  5.541  5.598  5.598
         5.598  5.652  5.67   5.704  5.737  5.768  5.784
 24 1 1  4.745  4.942  5.011  5.075  5.106  5.247  5.273  5.323
         5.347  5.371  5.416  5.481  5.501  5.541  5.598  5.598
         5.635  5.687  5.704  5.72   5.829  5.844  5.9
 25 1 1  4.654  4.828  4.828  4.977  4.977  5.043  5.136  5.165
         5.165  5.165  5.193  5.204  5.22   5.273  5.371  5.347
         5.46   5.58   5.635  5.67   5.753  5.799  5.844
 26 1 1  4.828  4.977  5.011  5.106  5.165  5.22   5.273  5.323
         5.371  5.394  5.46   5.576  5.652  5.617  5.687  5.67
         5.72   5.784  5.784  5.784  5.829  5.814  5.844
;

proc glimmix data=cows;
   t2 = tpoint / 100;
   class cow iron infection;
   model weight = iron infection iron*infection tpoint;
   random t2 / type=rsmooth subject=cow
                    knotmethod=kdtree(bucket=100 knotinfo);
   output out=gmxout pred(blup)=pred;
   nloptions tech=newrap;
run;

data plot;
   set gmxout;
   length group $26;
   if      (iron=0) and (infection=0) then group='Control Group (n=4)';
   else if (iron=1) and (infection=0) then group='Iron - No Infection (n=3)';
   else if (iron=0) and (infection=1) then group='No Iron - Infection (n=9)';
   else group = 'Iron - Infection (n=10)';
run;
proc sort data=plot; by group cow;
run;

proc sgpanel data=plot noautolegend;
   title 'Radial Smoothing With Cow-Specific Trends';
   label tpoint='Time' weight='log(Weight)';
   panelby group / columns=2 rows=2;
   scatter x=tpoint y=weight;
   series  x=tpoint y=pred / group=cow lineattrs=GraphFit;
run;

ods select OptInfo FitStatistics CovParms;
proc glimmix data=cows;
   t2 = tpoint / 100;
   class cow iron infection;
   model weight = iron infection iron*infection tpoint;
   random t2 / type=rsmooth
               subject=cow
               group=iron*infection
               knotmethod=kdtree(bucket=100);
   nloptions tech=newrap;
run;

ods select FitStatistics CovParms;
proc glimmix data=cows;
   t2 = tpoint / 100;
   class cow iron infection;
   model weight = iron infection iron*infection tpoint;
   random t2 / type=rsmooth
               subject=iron*infection
               knotmethod=kdtree(bucket=100);
   random intercept / subject=cow;
   output out=gmxout pred(blup)=pred;
   nloptions tech=newrap;
run;

data plot;
   set gmxout;
   length group $26;
   if      (iron=0) and (infection=0) then group='Control Group (n=4)';
   else if (iron=1) and (infection=0) then group='Iron - No Infection (n=3)';
   else if (iron=0) and (infection=1) then group='No Iron - Infection (n=9)';
   else group = 'Iron - Infection (n=10)';
run;
proc sort data=plot; by group cow;
run;

proc sgpanel data=plot noautolegend;
   title 'Group-Specific Smoothing and Random Cow Intercepts';
   label tpoint='Time' weight='log(Weight)';
   panelby group / columns=2 rows=2;
   scatter x=tpoint y=weight;
   series  x=tpoint y=pred / group=cow lineattrs=GraphFit;
run;

