/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex02                                             */
/*   TITLE: Documentation Example 2 for PROC POWER              */
/*          (The Sawtooth Power Function in Proportion          */
/*          Analyses)                                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: sample size                                         */
/*          power analysis                                      */
/*          binomial proportion                                 */
/*          graphs                                              */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc power;
   onesamplefreq test=z method=normal
      sides          = 1
      alpha          = 0.05
      nullproportion = 0.3
      proportion     = 0.2
      ntotal         = .
      power          = 0.8;
run;

proc power;
   onesamplefreq test=adjz method=normal
      sides          = 1
      alpha          = 0.05
      nullproportion = 0.3
      proportion     = 0.2
      ntotal         = .
      power          = 0.8;
run;

ods graphics on;

proc power plotonly;
   onesamplefreq test=exact
      sides          = 1
      alpha          = 0.05
      nullproportion = 0.3
      proportion     = 0.2
      ntotal         = 119
      power          = .;
   plot x=n min=110 max=140 step=1
      yopts=(ref=.8) xopts=(ref=119 129);
run;

proc power plotonly;
   onesamplefreq test=exact
      sides          = 1
      alpha          = 0.05
      nullproportion = 0.3
      proportion     = 0.18 0.2 0.22
      ntotal         = 119
      power          = .;
   plot x=n min=110 max=140 step=1
      yopts=(ref=.8) xopts=(ref=119 129);
run;

proc power plotonly;
   ods output plotcontent=PlotData;
   onesamplefreq test=exact
      sides          = 1
      alpha          = 0.05
      nullproportion = 0.3
      proportion     = 0.2
      ntotal         = 119
      power          = .;
   plot x=n min=110 max=140 step=1
      yopts=(ref=.8) xopts=(ref=119 129);
run;

proc print data=PlotData;
   var NTotal LowerCritVal Alpha Power;
run;

proc power plotonly;
   onesamplefreq test=exact
      sides          = 1
      alpha          = 0.05
      nullproportion = 0.2
      proportion     = 0.3
      ntotal         = 119
      power          = .;
   plot x=n min=110 max=140 step=1;
run;

proc power plotonly;
   onesamplefreq test=exact
      sides          = 2
      alpha          = 0.2
      nullproportion = 0.1
      proportion     = 0.09
      ntotal         = 10
      power          = .;
   plot x=n min=2 max=100 step=1;
run;

ods graphics off;

