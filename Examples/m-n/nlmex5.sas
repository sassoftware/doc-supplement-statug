/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlmex5                                              */
/*   TITLE: Documentation Example 5 for PROC NLMIXED            */
/*          Failure Time and Frailty Model                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Subject-specific survival rates                     */
/*   PROCS: NLMIXED, LIFEREG, PRINT, SGPLOT                     */
/*    DATA: Getting Started example data from PROC LIFEREG      */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data headache;
   input minutes group censor @@;
   patient = _n_;
   datalines;
11  1  0    12  1  0    19  1  0    19  1  0
19  1  0    19  1  0    21  1  0    20  1  0
21  1  0    21  1  0    20  1  0    21  1  0
20  1  0    21  1  0    25  1  0    27  1  0
30  1  0    21  1  1    24  1  1    14  2  0
16  2  0    16  2  0    21  2  0    21  2  0
23  2  0    23  2  0    23  2  0    23  2  0
25  2  1    23  2  0    24  2  0    24  2  0
26  2  1    32  2  1    30  2  1    30  2  0
32  2  1    20  2  1
;

proc nlmixed data=headache;
   bounds gamma > 0;
   linp  = b0 - b1*(group-2);
   alpha = exp(-linp);
   G_t   = exp(-(alpha*minutes)**gamma);
   g     = gamma*alpha*((alpha*minutes)**(gamma-1))*G_t;
   ll    = (censor=0)*log(g) + (censor=1)*log(G_t);
   model minutes ~ general(ll);
   predict 1-G_t out=cdf;
run;

proc print data=cdf;
   var group censor patient minutes pred;
run;

ods output ParameterEstimates=est;
proc nlmixed data=headache;
   bounds gamma > 0;
   linp  = b0 - b1*(group-2) + z;
   alpha = exp(-linp);
   G_t   = exp(-(alpha*minutes)**gamma);
   g     = gamma*alpha*((alpha*minutes)**(gamma-1))*G_t;
   ll = (censor=0)*log(g) + (censor=1)*log(G_t);
   model minutes ~ general(ll);
   random z ~ normal(0,exp(2*logsig)) subject=patient out=EB;
   predict 1-G_t out=cdf;
run;

proc print data=eb;
   var Patient Effect Estimate StdErrPred;
run;

proc transpose data=est(keep=estimate)
    out=trest(rename=(col1=gamma col2=b0 col3=b1));
run;

data pred;
   merge eb(keep=estimate) headache(keep=patient group);
   array pp{2} pred1-pred2;
   if _n_ = 1 then set trest(keep=gamma b0 b1);
   do time=11 to 32;
      linp      = b0 - b1*(group-2) + estimate;
      pp{group} = 1-exp(- (exp(-linp)*time)**gamma);
      symbolid  = patient+1;
      output;
   end;
   keep pred1 pred2 time patient;
run;

data pred;
   merge pred
         cdf(where  = (group=1)
             rename = (pred=pcdf1 minutes=minutes1)
             keep   = pred minutes group)
         cdf(where  = (group=2)
             rename = (pred=pcdf2 minutes=minutes2)
             keep   = pred minutes group);
   drop group;
run;

proc sgplot data=pred noautolegend;
   label minutes1='Minutes to Headache Relief'
         pcdf1   ='Estimated Patient-specific CDF';
   series  x=time     y=pred1  /
           group=patient
           lineattrs=(pattern=solid color=black);
   series  x=time     y=pred2  /
           group=patient
           lineattrs=(pattern=dash color=black);
   scatter x=minutes1 y=pcdf1  /
           markerattrs=(symbol=CircleFilled size=9);
   scatter x=minutes2 y=pcdf2  /
           markerattrs=(symbol=Circle       size=9);
run;

