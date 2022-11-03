/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tpsplex5                                            */
/*   TITLE: Example 5 for PROC TPSPLINE                         */
/*    DESC: Melanoma Incidences for 37 Years                    */
/*     REF: Houghton et al, 1980                                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Thin-Plate Spline Model, UCLM LCLM Options          */
/*   PROCS: TPSPLINE                                            */
/*                                                              */
/****************************************************************/

data melanoma;
   input  year incidences @@;
   datalines;
1936    0.9   1937   0.8  1938   0.8  1939   1.3
1940    1.4   1941   1.2  1942   1.7  1943   1.8
1944    1.6   1945   1.5  1946   1.5  1947   2.0
1948    2.5   1949   2.7  1950   2.9  1951   2.5
1952    3.1   1953   2.4  1954   2.2  1955   2.9
1956    2.5   1957   2.6  1958   3.2  1959   3.8
1960    4.2   1961   3.9  1962   3.7  1963   3.3
1964    3.7   1965   3.9  1966   4.1  1967   3.8
1968    4.7   1969   4.4  1970   4.8  1971   4.8
1972    4.8
;

ods graphics on;
proc tpspline data=melanoma plots(only)=(criterionplot fitplot(clm));
   model incidences = (year) /alpha = 0.1;
   output out = result pred uclm lclm;
run;

proc tpspline data=melanoma plots(only)=fitplot(clm);
   model incidences = (year) /alpha = 0.1;
   output out=result pred uclm lclm;
run;

data bootstrap;
   set result;
   array y{1070} y1-y1070;
   do i=1 to 1070;
      y{i} = p_incidences + 0.232823*rannor(123456789);
   end;
   keep y1-y1070 p_incidences year;
run;

ods exclude all;
proc tpspline data=bootstrap plots=none;
   ods output FitStatistics=FitResult;
   id p_incidences;
   model y1-y1070 = (year);
   output out=result2;
run;
ods exclude none;

data FitResult;
   set FitResult;
   if Parameter="Standard Deviation";
   keep Value;
run;

proc transpose data=FitResult out=sd prefix=sd;

data result2;
   if _N_ = 1 then set sd;
   set result2;
run;

data boot;
   set result2;
   array y{1070}  p_y1-p_y1070;
   array sd{1070} sd1-sd1070;
   do i=1 to 1070;
      if sd{i} > 0 then do;
         d = (y{i} - P_incidences)/sd{i};
         obs = _N_;
         output;
      end;
   end;
   keep d obs P_incidences year;
run;

proc sort data=boot;
   by obs;
run;

data boot;
   set boot;
      by obs;
   retain n;

   if first.obs then n=1;
      else n=n+1;
   if n > 1000 then delete;
run;

proc sort data=boot;
   by obs d;
run;

data chi1 chi2 ;
   set boot;
   if (_N_ = (obs-1)*1000+50)  then output chi1;
   if (_N_ = (obs-1)*1000+950) then output chi2;
run;

proc sort data=result;
   by year;
run;

proc sort data=chi1;
   by year;
run;

proc sort data=chi2;
   by year;
run;

data result;
   merge result
      chi1(rename=(d=chi05))
      chi2(rename=(d=chi95));
   keep year incidences P_incidences lower upper
        LCLM_incidences UCLM_incidences;

   lower = -chi95*0.232823 + P_incidences;
   upper = -chi05*0.232823 + P_incidences;

   label  lower="Lower 90% CL (Bootstrap)"
          upper="Upper 90% CL (Bootstrap)"
          lclm_incidences="Lower 90% CL (Bayesian)"
          uclm_incidences="Upper 90% CL (Bayesian)";
run;

proc sgplot data=result;
   title "Age-adjusted Melanoma Incidence for 37 Years";

   xaxis label="year";
   yaxis label="Incidences";

   band x=year lower=lclm_incidences upper=uclm_incidences/name="bayesian"
               legendlabel="90% Bayesian CI of Predicted incidences"
               fillattrs=(color=red);
   band x=year lower=lower upper=upper/name="bootstrap"
               legendlabel="90% Bootstrap CI of Predicted incidences"
               transparency=0.05;
   scatter x=year y=incidences/name="obs" legendlabel="incidences";
   series x=year y=p_incidences/name="pred"
               legendlabel="predicted values of incidences"
               lineattrs=graphfit(thickness=1px);

   discretelegend "bayesian" "bootstrap" "obs" "pred";
run;

ods graphics off;
