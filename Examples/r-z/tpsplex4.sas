/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tpsplex4                                            */
/*   TITLE: Example 4 for PROC TPSPLINE                         */
/*    DESC: simulated large data set                            */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Thin-Plate Spline Model, D= Option                  */
/*   PROCS: TPSPLINE                                            */
/*                                                              */
/****************************************************************/
data large;
   do x=-5 to 5 by 0.02;
      y=5*sin(3*x)+1*rannor(57391);
      output;
   end;
run;
proc tpspline data=large;
   model y  =(x) /lognlambda=(-5 to -1 by 0.2) alpha=0.01;
   output out=fit1 pred lclm uclm;
run;
proc tpspline data=large;
   model y  =(x) /lognlambda=(-5 to -1 by 0.2) d=0.05 alpha=0.01;
   output out=fit2 pred lclm uclm;
run;
data fit2;
   set fit2;
   P1_y     = P_y;
   LCLM1_y  = LCLM_y;
   UCLM1_y  = UCLM_y;
   drop P_y LCLM_y UCLM_y;
run;

proc sort data=fit1;
   by x y;
run;

proc sort data=fit2;
   by x y;
run;

data comp;
   merge fit1 fit2;
      by x y;
   label p1_y   ="Yhat1" p_y="Yhat0"
         lclm_y ="Lower CL"
         uclm_y ="Upper CL";
run;

proc sgplot data=comp;
   title "Comparison of Two Estimates";
   title2 "with and without the D= Option";

   yaxis label="Predicted y Values";
   xaxis label="x";

   band x=x lower=lclm_y upper=uclm_y /name="range"
                      legendlabel="99% CI of Predicted y without D=";
   series x=x y=P_y/ name="P_y" legendlabel="Predicted y without D="
                      lineattrs=graphfit(thickness=1px pattern=shortdash);
   series x=x y=P1_y/ name="P1_y" legendlabel="Predicted y with D="
                      lineattrs=graphfit(thickness=1px color=red);
   discretelegend "range" "P_y" "P1_y";
run;
