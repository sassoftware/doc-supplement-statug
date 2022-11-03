/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SIM2DEX3                                            */
/*   TITLE: Documentation Example 3 for PROC SIM2D              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, simulation, random field          */
/*   PROCS: SIM2D                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIM2D, EXAMPLE 3                               */
/*    MISC:                                                     */
/****************************************************************/

title 'Risk Assessment with Simulation';

data logAsData;
   input East North logAs @@;
   label logAs='log(As) Concentration';
   datalines;
   193.0 296.6 -0.68153   232.6 479.1  0.96279   268.7 312.5 -1.02908
    43.6   4.9  0.65010   152.6  54.9  1.87076   449.1 395.8  0.95932
   310.9 493.6 -1.66208   287.8 164.9 -0.01779   330.0   8.0  2.06837
   225.7 241.7  0.15899   452.3  83.4 -1.21217   156.5 462.5 -0.89031
    11.5  84.4 -0.24496   144.4 335.7  0.11950   149.0 431.8 -0.57251
   234.3 123.2 -1.33642    37.8 197.8 -0.27624   183.1 173.9 -2.14558
   149.3 426.7 -1.06506   434.4  67.5 -1.04657   439.6 237.0 -0.09074
    36.4 175.2 -1.21211   370.6 244.0  3.28091   452.0  96.5 -0.77081
   247.0  86.8  0.04720   413.6 373.2  1.78235   253.5 291.7  0.56132
   129.7 111.9  1.34000   352.7  42.1  0.23621   279.3  82.7  2.12350
   382.6 290.7  0.86756   188.2 222.8 -1.23308   382.8 154.5 -0.94094
   304.4 309.2 -1.95158   337.5 387.2 -1.31294   490.7 189.8  0.40206
   159.0 100.1 -0.22272   245.5 329.2 -0.26082   372.1 379.5 -1.89078
   417.8  84.1 -1.25176   173.9 407.6 -0.24240   121.5 107.7  1.54509
   453.5 313.6  0.65895   143.5 346.7 -0.87196   157.4 125.5 -1.96165
   371.8 353.2 -0.59464   358.9 338.2 -1.07133     8.6 437.8  1.44203
   395.9 394.2 -0.24144   149.5  58.9  1.17459   453.5 420.6 -0.63951
   182.3  85.0  1.00005    21.0 290.1  0.31016    11.1 352.2 -0.88418
   131.2 238.4 -0.57184   104.9   6.3  1.12054   247.3 256.0  0.14019
   428.4 383.7  0.92448   327.8 481.1 -2.72543   199.2  92.8 -0.05717
   453.9 230.1  0.16571   205.0 250.6  0.07581   459.5 271.6  0.93700
   229.5 262.8  1.83590   370.4 228.6  2.96611   330.2 281.9  1.79723
   354.8 388.3 -3.18262   406.2 222.7  2.41594   254.4 393.1  2.03221
    96.7  85.2 -0.47156   407.2 256.8  0.66747   498.5 273.8  1.03041
   417.2 471.4 -1.42766   368.8 424.3 -0.70506   303.0  59.1  1.43070
   403.1 264.1  1.64554    21.2 360.8  0.67094   148.2  78.1  2.15323
   305.5 310.7 -1.47985   228.5 180.3 -0.68386   161.1 143.3  1.07901
    70.5 155.1  0.54652   363.1 282.6 -0.43051    86.0 472.5 -1.18855
   175.9 105.3 -2.08112    96.8 426.3  1.56592   475.1 453.1 -1.53776
   125.7 485.4  1.40054   277.9 201.6 -0.54565   406.2 125.0 -1.38657
    60.0 275.5 -0.59966   431.3 494.6 -0.36860   399.9 399.0 -0.77265
    28.8 311.1  0.91693   166.1 348.2 -0.49056   266.6  83.5  0.67277
    54.7 356.3  0.49596   433.5 460.3 -1.61309   201.7 167.6 -1.40678
   158.1 203.6 -1.32499    67.6 230.4  1.14672    81.9 250.0  0.63378
   372.0  50.7  0.72445    26.4 264.6  1.00862   300.1  91.7 -0.74089
   303.0 447.4  1.74589   108.4 386.2  1.12847    55.6 191.7  0.95175
    36.3 273.2  1.78880    94.5 298.3 -2.43320   366.1 187.3 -0.80526
   130.7 389.2 -0.31513    37.2 324.2  0.24489   295.5 211.8  0.41899
    58.6 206.2  0.18495   346.3 142.8 -0.92038   484.2 215.9  0.08012
   451.4 415.7  0.02773    58.9  86.5  0.17652   212.6 363.9  0.17215
   378.7 407.6  0.51516   265.9 305.0 -0.30718   123.2 314.8 -0.90591
    26.9 471.7  1.70285    16.5   7.1  0.51736   255.1 472.6  2.02381
   111.5 148.4 -0.09658   440.4 375.0  1.23285   406.4  19.5  1.01181
   321.2  65.8 -0.02095   466.4 357.1 -0.49272     2.0 484.6  0.50994
   200.9 205.1  0.43543    30.3 337.0  1.60882   297.0  12.7  1.79824
   158.2 450.7  0.05295   122.8 105.3  1.53936   417.8 329.7 -2.08124
;

ods graphics on;


/* Semivariance model fitting in PROC VARIOGRAM ----------------*/

proc variogram data=logAsData plots=none;
   store out=SemivAsStore / label='LogAs Concentration Models';
   compute lagd=5 maxlag=40;
   coord xc=East yc=North;
   model form=auto(mlist=(exp,gau,mat) nest=1 to 2);
   var logAs;
run;


/* Examine fitted correlation models in input item store -------*/

proc sim2d data=logAsData outsim=Outsim plots=none;
   restore in=SemivAsStore / info(det only);
   coordinates xc=East yc=North;
   simulate var=logAs numreal=5000 storeselect seed=39841;
   grid x=0 to 500 by 10 y=0 to 500 by 10;
run;


/* Simulation with Gaussian-Gaussian covariance model ----------*/

proc sim2d data=logAsData outsim=Outsim plots=(sim semivar);
   restore in=SemivAsStore;
   coordinates xc=East yc=North;
   simulate var=logAs numreal=5000 storeselect seed=89702;
   grid x=0 to 500 by 10 y=0 to 500 by 10;
run;


/* Analysis of affected area percentage ------------------------*/

data AsOverLimit;
   set Outsim;
   OverLimit = (exp(svalue) > 10) * 100;
run;

proc means data=AsOverLimit noprint;
   by _ITER_;
   var OverLimit;
   output out=OverLimitData mean=PctOverLimit;
run;
proc means data=OverLimitData mean p5 p95;
   var PctOverLimit;
   label PctOverLimit="Percent above threshold";
run;


/* Analysis of WHO standard violation probability --------------*/

data LocalAsOverLimit;
   set Outsim;
   LocalOverLimit = (exp(svalue) > 10);
run;

proc sort data=LocalAsOverLimit;
   by gxc gyc;
run;
proc means data=LocalAsOverLimit noprint;
   by gxc gyc;
   var LocalOverLimit;
   output out=OverLimLoci mean=ProbOverLimit;
run;

proc template;
   define statgraph surfacePlot;
      dynamic _VARX _VARY _VAR _TITLE _LEGENDLABEL;
      BeginGraph;
      entrytitle _TITLE;
      layout overlay /
         xaxisopts = (offsetmax=0)
         yaxisopts = (offsetmax=0);
         contourplotparm x=_VARX y=_VARY z=_VAR /
                         nhint=10 name='probplot';
         continuouslegend 'probplot' / title=_LEGENDLABEL;
      endlayout;
      EndGraph;
   end;
run;

proc sgrender data=OverLimLoci template=surfacePlot;
   dynamic _VARX ='gxc'
           _VARY ='gyc'
           _VAR  ='ProbOverLimit'
           _TITLE='Arsenic WHO Standard Violation'
           _LEGENDLABEL='Violation Probability';
   label gyc='North' gxc='East';
run;

ods graphics off;