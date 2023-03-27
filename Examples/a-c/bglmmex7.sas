/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex7                                            */
/*   TITLE: Example 7 for PROC BGLIMM                           */
/*    DESC: Bayesian Networking Meta Analysis                   */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Bayesian Network Meta Analysis                      */
/*   PROCS: BGLIMM                                              */
/*    DATA: Smoke Cessation, Parkinsons                         */
/*                                                              */
/*     REF:                                                     */
/****************************************************************/

data SmokeData;
   input Study Treat $ Event Total;
   datalines;
 1     NC      9       140
 1     IC     23       140
 1     GC     10       138
 2     SH     11        78
 2     IC     12        85
 2     GC     29       170
 3     NC     79       702
 3     SH     77       694
 4     NC     18       671
 4     SH     21       535
 5     NC      8       116
 5     SH     19       146
 6     NC     75       731
 6     IC     63       714
 7     NC      2       106
 7     IC      9       205
 8     NC     58       549
 8     IC     37      1561
 9     NC      0        33
 9     IC      9        48
10     NC      3       100
10     IC     31        98
11     NC      1        31
11     IC     26        95
12     NC      6        39
12     IC     17        77
13     NC     95      1107
13     IC     34      1031
14     NC     15       187
14     IC     35       504
15     NC     78       584
15     IC     73       675
16     NC     69      1177
16     IC     54       888
17     NC     64       642
17     IC     07       761
18     NC      5        62
18     IC      8        90
19     NC     20       234
19     IC     34       237
20     NC      0        20
20     GC      9        20
21     SH     20        49
21     IC     16        43
22     SH      7        66
22     GC     32       127
23     IC     12        76
23     GC     20        74
24     IC      9        55
24     GC      3        26
;

proc bglimm data=SmokeData seed=1315 nbi=5000 nmc=100000 thin=10
            outpost=CSout;
   class Study Treat / order=data;
   model Event/Total = Treat / link=probit noint;
   random Treat / sub=Study type=cs g monitor=(1 to 2);
run;

data CSoutP;
   set CSout;
   p_NC = probnorm(Treat_NC/sqrt(1+Random_Var+Random_CS));
   p_IC = probnorm(Treat_IC/sqrt(1+Random_Var+Random_CS));
   p_GC = probnorm(Treat_GC/sqrt(1+Random_Var+Random_CS));
   p_SH = probnorm(Treat_SH/sqrt(1+Random_Var+Random_CS));
run;

data CSoutP;
   set CSout;
   p_NC = probnorm(Treat_NC/sqrt(1+Random_Var+Random_CS));
   p_IC = probnorm(Treat_IC/sqrt(1+Random_Var+Random_CS));
   p_GC = probnorm(Treat_GC/sqrt(1+Random_Var+Random_CS));
   p_SH = probnorm(Treat_SH/sqrt(1+Random_Var+Random_CS));
run;

proc sgplot data=CSoutP;
   density p_NC / legendlabel="p_NC" type=kernel lineattrs=(pattern=solid);
   density p_IC / legendlabel="p_IC" type=kernel lineattrs=(pattern=ShortDash);
   density p_GC / legendlabel="p_GC" type=kernel lineattrs=(pattern=DashDotDot);
   density p_SH / legendlabel="p_SH" type=kernel lineattrs=(pattern=LongDash);
   keylegend / location=inside position=topright across=1;
   xaxis label="Probability";
   yaxis display=(nolabel noline noticks novalues);
run;

data Parkinson;
   input Sid Trt Mean SD Nstudy;
   datalines;
1   1   -1.22   3.70    54
1   3   -1.53   4.28    95
2   1   -0.70   3.70   172
2   2   -2.40   3.40   173
3   1   -0.30   4.40    76
3   2   -2.60   4.30    71
3   4   -1.20   4.30    81
4   3   -0.24   3.00   128
4   4   -0.59   3.00    72
5   3   -0.73   3.00    80
5   4   -0.18   3.00    46
6   4   -2.20   2.31   137
6   5   -2.50   2.18   131
7   4   -1.80   2.48   154
7   5   -2.10   2.99   143
;

data Parkinson2;
   set Parkinson;
   SVar= SD*SD/Nstudy;
   run;

proc bglimm data=Parkinson2 seed=1315 nmc=50000 thin=10 outpost=PostSamples;
   class Trt Sid / order=internal;
   model mean = Trt / noint scale=SVar cprior=normal;
   random Trt / sub=Sid type=cs monitor=(1 to 2);
   estimate "Placebo_Drug2" Trt -1 1 0 0 0 / e;
   estimate "Placebo_Drug3" Trt -1 0 1 0 0 / e;
   estimate "Placebo_Drug4" Trt -1 0 0 1 0 / e;
   estimate "Placebo_Drug5" Trt -1 0 0 0 1 / e;
run;

