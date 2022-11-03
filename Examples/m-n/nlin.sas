 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: NLIN                                                */
 /*   TITLE: Nonlinear Regression using PROC NLIN                */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: nonlinear models,                                   */
 /*   PROCS: NLIN SGPLOT PRINT                                   */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title1 '------------------ NLIN Sample --------------------';
title2 '--- Nonlinear Models of U.S. Population Growth ----';
data uspop;
   input pop :6.3 @@;
   retain year 1780;
   year=year+10;
   yearsq=year*year;
   datalines;
 3929 5308 7239 9638 12866 17069 23191 31443 39818 50155
 62947 75994 91972 105710 122775 131669 151325 179323 203211
 226542 248710
 ;

proc print data=uspop;
run;
proc nlin data=uspop;
     parms c0=3.9 c1=.022;
     model pop=c0*exp(c1*(year-1790));
     output out=PP1 P=PREDICT R=RESID;
run;
proc sgplot data=pp1(obs=20);
     scatter y=pop     x=year /
             legendlabel='Observed';
     scatter y=predict x=year /
             legendlabel='Predicted';
run;
proc sgplot data=pp1(obs=20);
     scatter y=resid x=year;
     refline 0;
run;

proc nlin data=uspop best=8;
     parms c0=4 to 16 by 2 c1=.01 to .03 by .0025;
     x=year-1790; z=exp(c1*x);
     model POP=C0*Z;
run;
proc nlin data=uspop;
     parms a=500 b=4.846 c=-.0248;
     x=year-1790;   z=exp(b+c*x);
     model pop=a/(1+z);
     output out=pp2 p=predict r=resid;
run;
proc sgplot data=pp2(obs=20);
     scatter y=pop     x=year /
             legendlabel='Observed';
     scatter y=predict x=year /
             legendlabel='Predicted';
run;
proc sgplot data=pp2(obs=20);
     scatter y=resid x=year;
     refline 0;
run;

proc sgplot data=pp2;
     scatter y=pop     x=year /
             legendlabel='Observed';
     scatter y=predict x=year /
             legendlabel='Predicted';
run;

proc nlin data=uspop;
     parms a=11.72 b=.02 d=1.86;
     *---Compute some useful quantities first---;
     x=year-1790;
     z=log(a*b/d);
     x0=-z/b;
     c=d/b+d*z/b;
     cut=x0+1790;
     if year<1800 then put cut=;
     *---Decide which side this is on---;
     if x>x0 then goto upper;
     *---compute model for lower side---;
     w=exp(b*x);
     model pop=a*w;
     RETURN;
upper:*---Compute model for upper side---;
     w=d/b;
     model pop=w+w*z+d*x;
     return;
     *---Output predicted and residuals---;
     output out=po p=predict r=resid;
run;

proc sgplot data=po(obs=20);
     scatter y=pop     x=year /
             legendlabel='Observed';
     scatter y=predict x=year /
             legendlabel='Predicted';
run;
proc sgplot data=po(obs=20);
     scatter y=resid x=year;
     refline 0;
run;
