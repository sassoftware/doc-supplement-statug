/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex06                                             */
/*   TITLE: Documentation Example 6 for PROC POWER              */
/*          (Comparing Two Survival Curves)                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          log-rank test                                       */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data survcurvedata;
   lambda = -log(0.5)/5;
   do time = 0 to 5 by 0.1;
      surv1 = exp(-lambda*time);
      if (time<=0.05) then surv2 = 1;
      else if (time>=0.995 and time<=1.05) then surv2 = 0.95;
      else if (time>=1.995 and time<=2.05) then surv2 = 0.9;
      else if (time>=2.995 and time<=3.05) then surv2 = 0.75;
      else if (time>=3.995 and time<=4.05) then surv2 = 0.7;
      else if (time>=4.995 and time<=5.05) then surv2 = 0.6;
      else surv2 = .;
      output;
   end;
run;

proc template;
   define statgraph survcurves;
      begingraph;
         layout lattice / rows=1 columns=1;
            layout overlay /
               yaxisopts=( display=ALL label="Prob (Survival Time >= t)")
               xaxisopts=( display=ALL label="t")
               pad=10;
               seriesplot x=time y=surv1 /
                  name = "std"
                  lineattrs=(pattern=solid)
                  legendlabel = "Standard Treatment (exponential)";
               seriesplot x=time y=surv2 /
                  name = "pro"
                  lineattrs=(pattern=shortdash)
                  display=all
                  markerattrs=(symbol = circle)
                  legendlabel = "Proposed Treatment (piecewise linear)";
               discretelegend "std" "pro" /
                  location=inside
                  autoalign=(topright)
                  across=1
                  border=true;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=survcurvedata template=survcurves;
run;

proc power;
   twosamplesurvival test=logrank
      curve("Standard") = 5 : 0.5
      curve("Proposed") = (1 to 5 by 1):(0.95 0.9 0.75 0.7 0.6)
      groupsurvival = "Standard" | "Proposed"
      accrualtime = 2
      followuptime = 3
      groupmedlosstimes = 10 | 20 5
      power = 0.8
      npergroup = .;
run;

