/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmxex10                                             */
/*   TITLE: Documentation Example 10 for PROC GLIMMIX           */
/*          Multiple Trends Correspond to Multiple Extrema in   */
/*          Profile Likelihoods                                 */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Profile log likelihoods                             */
/*          COVTEST statement                                   */
/*   PROCS: GLIMMIX, SGPLOT                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc print data=Sashelp.enso(obs=10);
run;

data tdata;
  do covp1=0,0.0005,0.05,0.1,0.2,0.5,
           1,2,3,4,5,6,8,10,15,20,50,
           75,100,125,140,150,160,175,
           200,225,250,275,300,350;
     output;
  end;
run;

ods select FitStatistics CovParms CovTests;
proc glimmix data=sashelp.enso noprofile;
   model pressure = year;
   random year / type=rsmooth knotmethod=equal(50);
   parms (2) (10);
   covtest tdata=tdata / parms;
   ods output covtests=ct;
run;

proc sgplot data=ct;
   series y=objective x=covp1;
run;

proc glimmix data=sashelp.enso;
   model pressure = year;
   random year / type=rsmooth knotmethod=equal(50);
   parms (0) (10);
   output out=gmxout1 pred=pred1;
run;
proc glimmix data=sashelp.enso;
   model pressure = year;
   random year / type=rsmooth knotmethod=equal(50);
   output out=gmxout2 pred=pred2;
   parms (2) (10);
run;
proc glimmix data=sashelp.enso;
   model pressure = year;
   random year / type=rsmooth knotmethod=equal(50);
   output out=gmxout3 pred=pred3;
   parms (200) (10);
run;
data plotthis; merge gmxout1 gmxout2 gmxout3;
run;
proc sgplot data=plotthis;
   scatter x=year y=Pressure;
   series  x=year y=pred1 /
        lineattrs   = (pattern=solid thickness=2)
        legendlabel = "Var[RSmooth] = 0.0005"
        name        = "pred1";
   series  x=year y=pred2 /
        lineattrs   = (pattern=dot thickness=2)
        legendlabel = "Var[RSmooth] = 3.5719"
        name        = "pred2";
   series  x=year y=pred3 /
        lineattrs   = (pattern=dash thickness=2)
        legendlabel = "Var[RSmooth] = 186.71"
        name        = "pred3";
   keylegend "pred1" "pred2" "pred3" / across=2;
run;
