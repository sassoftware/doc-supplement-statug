/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlinex1                                             */
/*   TITLE: Documentation Example 1 for PROC NLIN               */
/*          Segmented Model                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Reparameterization                                  */
/*          Continuity condition                                */
/*          Smoothness condition                                */
/*   PROCS: NLIN, SGPLOT                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data a;
   input y x @@;
   datalines;
.46 1  .47  2 .57  3 .61  4 .62  5 .68  6 .69  7
.78 8  .70  9 .74 10 .77 11 .78 12 .74 13 .80 13
.80 15 .78 16
;

title 'Quadratic Model with Plateau';
proc nlin data=a;
   parms alpha=.45 beta=.05 gamma=-.0025;

   x0 = -.5*beta / gamma;

   if (x < x0) then
        mean = alpha + beta*x  + gamma*x*x;
   else mean = alpha + beta*x0 + gamma*x0*x0;
   model y = mean;

   if _obs_=1 and _iter_ =.  then do;
      plateau =alpha + beta*x0 + gamma*x0*x0;
      put /  x0= plateau=  ;
   end;
   output out=b predicted=yp;
run;

proc nlin data=a;
   parms alpha=.45 beta=.05 gamma=-.0025;
   x0 = -.5*beta / gamma;
   if (x < x0) then
        model y = alpha+beta*x+gamma*x*x;
   else model y = alpha+beta*x0+gamma*x0*x0;
run;

proc nlin data=a;
   parms alpha=.45 beta=.05 gamma=-.0025;
   x0 = -.5*beta / gamma;
   model y = (x <x0)*(alpha+beta*x +gamma*x*x) +
             (x>=x0)*(alpha+beta*x0+gamma*x0*x0);
run;

proc sgplot data=b noautolegend;
   yaxis label='Observed or Predicted';
   refline 0.777  / axis=y label="Plateau"    labelpos=min;
   refline 12.747 / axis=x label="Join point" labelpos=min;
   scatter y=y  x=x;
   series  y=yp x=x;
run;

proc nlin data=a;
   parms alpha=.45 beta=.05 x0=10;
   if (x<x0) then
        mean = alpha + beta*x *(1-x/(2*x0));
   else mean = alpha + beta*x0/2;
   model y = mean;
run;

