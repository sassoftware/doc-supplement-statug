/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: loessex1                                            */
/*   TITLE: Documentation Example 1 for PROC LOESS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Local Regression                                    */
/*   PROCS: LOESS                                               */
/*    DATA: Engine Exhaust Emissions                            */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data Gas;
   input NOx E @@;
   format NOx f3.1;
   format E f3.1;
   datalines;
4.818  0.831   2.849  1.045
3.275  1.021   4.691  0.97
4.255  0.825   5.064  0.891
2.118  0.71    4.602  0.801
2.286  1.074   0.97   1.148
3.965  1       5.344  0.928
3.834  0.767   1.99   0.701
5.199  0.807   5.283  0.902
3.752  0.997   0.537  1.224
1.64   1.089   5.055  0.973
4.937  0.98    1.561  0.665
;


proc sgplot data=Gas;
   scatter x=E y=NOx;
run;

ods graphics on;

proc loess data=Gas;
   ods output OutputStatistics = GasFit
              FitSummary=Summary;
   model NOx = E / degree=2 select=AICC(steps) smooth = 0.6 1.0
                   direct alpha=.01 all details;
run;

ods graphics off;

data h0 h1;
   set Summary(keep=SmoothingParameter Label1 nValue1
               where=(Label1 in ('Residual Sum of Squares','Delta1',
                      'Delta2','Lookup Degrees of Freedom')));
   if SmoothingParameter = 1 then output h0;
   else output h1;
run;

proc transpose data=h0(drop=SmoothingParameter Label1) out=h0;
run;

data h0(drop=_NAME_);
   set h0;
   rename Col1 = RSSNull
          Col2 = delta1Null
          Col3 = delta2Null;
run;

proc transpose data=h1(drop=SmoothingParameter Label1) out=h1;
run;

data h1(drop=_NAME_);
   set h1;
   rename Col1 = RSS     Col2 = delta1
          Col3 = delta2  Col4 = rho;
run;

data ftest;
   merge h0 h1;
   nu = (delta1Null - delta1)**2 / (delta2Null - delta2);
   Numerator = (RSSNull - RSS)/(delta1Null - delta1);
   Denominator = RSS/delta1;
   FValue = Numerator / Denominator;
   PValue = 1 - ProbF(FValue, nu, rho);
   label nu     = 'Num DF'   rho    = 'Den DF'
         FValue = 'F Value'  PValue = 'Pr > F';
run;

proc print data=ftest label;
   var nu rho Numerator Denominator FValue PValue;
   format nu rho FValue 7.2 PValue 6.4;
run;

