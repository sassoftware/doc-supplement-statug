 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: LIFTMISC                                            */
 /*   TITLE: PROC LIFETEST Samples from Previous Releases        */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: survival analysis, nonparametric methods            */
 /*   PROCS: LIFETEST                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /****************************************************************/

ods graphics on;

 /*-------------------------------------------------------------*/
 /* Data Source:  J.D.Kalfleisch and R.L. Prentice (1980): The  */
 /*               Statistical Analysis of Failure Time Data.    */
 /*               John Wiley and Sons. p 2                      */

title 'Lifetimes of Rats Exposed to DMBA';
data vagcan;
   label days  ='Days from Exposure to Death'
         group ='Treatment Group';
   input days @@;
   censored = (days < 0);
   days = abs(days);
   if _n_ > 19 then group = 'pretrt1';
   else group = 'pretrt2';
   datalines;
143 164 188 188 190 192 206 209 213 216
220 227 230 234 246 265 304  -216  -244
142 156 163 198 205 232 232 233 233 233 233 239
240 261 280 280 296 296 323 -204 -344
;

proc lifetest data = vagcan plots = (s,ls,lls);
   time days*censored(1);
   strata group;
run;

 /*------------------------------------------------------------*/
 /* Data Source:  D.R. Cox and D. Oaks (1984): Analysis of     */
 /*               Survival Data. Chapman and Hall, London.     */
 /*               p. 9                                         */

title 'Relation of Log White Blood Count and Lifetime';
data wbc;
   input wbc t @@;
   if _n_ < 18 then group = 'AG+';
   else group = 'AG-';
   lwbc = log(wbc);
   datalines;
 2.3  65    .75 156   4.3 100  2.6 134   6.0  16 10.5 108
10.0 121  17.0    4   5.4  39  7.0 143   9.4  56 32.0  26
35.0  22 100.0    1 100.0   1 52.0   5 100.0  65

 4.4  56   3.0   65   4.0  17  1.5   7   9.0  16  5.3  22
10.0   3  19.0    4  27.0   2 28.0   3  31.0   8 26.0   4
21.0   3  79.0   30 100.0   4 100.0 43
;
proc lifetest notable plots=none;
   strata group;
   time t;
   test lwbc;
run;

 /*--------------------------------------------------------------*/
 /* Data Source: R.L. Prentice (1973): Exponential survivals     */
 /*              with censoring and explanatory variables.       */

data prentice;
   input time state trt cell @@;
   casenum = _n_;
   label time = 'Survival Time'
         state = '1 = dead, 0 = censored';
   datalines;
 72 1 1 1   411 1 1 1   228 1 1 1   231 0 0 1   242 1 0 1   991 1 0 1
111 1 0 1     1 1 0 1   587 1 0 1   389 1 0 1    33 1 0 1    25 1 0 1
357 1 0 1   467 1 0 1   201 1 0 1     1 1 0 1    30 1 0 1    44 1 0 1
283 1 0 1    15 1 0 1    87 0 0 1   112 1 0 1   999 1 0 1    11 1 1 1
 25 0 1 1   144 1 1 1     8 1 1 1    42 1 1 1   100 0 1 1   314 1 1 1
110 1 1 1    82 1 1 1    10 1 1 1   118 1 1 1   126 1 1 1     8 1 1 2
 92 1 1 2    35 1 1 2   117 1 1 2   132 1 1 2    12 1 1 2   162 1 1 2
  3 1 1 2    95 1 1 2    24 1 0 2    18 1 0 2    83 0 0 2    31 1 0 2
 51 1 0 2    90 1 0 2    52 1 0 2    73 1 0 2     8 1 0 2    36 1 0 2
 48 1 0 2     7 1 0 2   140 1 0 2   186 1 0 2    84 1 0 2    19 1 0 2
 45 1 0 2    80 1 0 2
;

proc format;
   value tumor 1='squamous' 2='adenoma';
run;

title 'Survival of Lung Cancer Patients';

 /* life table estimates with one stratum */
proc lifetest data = prentice
              outs = one
              method = life
              intervals = (0 to 899.1 by 99.9, 999.1)
              plots = (s, ls, lls, h, p);
   time time*state(0);
run;

proc print data = one;
   title 'Lifetable Estimates';
run;

 /* product limit estimates with one stratum  */
 /* id variable cell has formated values      */
title;
proc lifetest data = prentice
              plots = (s, ls, lls);
   time time*state(0);
   id casenum cell;
   format cell tumor.;
run;

 /* product limit estimates stratified by trt  */
 /* id variable cell has formated values       */
  title;
proc lifetest data = prentice
              outs = two
              plots = (s, ls, lls);
   time time*state(0);
   strata trt;
   id casenum cell;
   format cell tumor.;
run;

proc print data = two;
   title 'Kaplan Meier Estimates';
run;

proc format;
   value treat 0 = 'standard' 1 = 'test';
run;

 /* life table estimates by cell and stratified by trt */
 /* strata variable trt has formated values            */
title;
proc lifetest data = prentice
              outs = three
              method = life
              intervals = (0 to 899.1 by 99.9, 999.1)
              plots = (s, ls, lls, h, p);
   time time*state(0);
   strata trt;
   by cell;
   format trt treat.;
run;

 /*  variable names replaced by variable labels */
proc print data = three label;
   title 'Lifetable Estimates by CELL';
run;

 /* product limit estimates by cell and stratified by trt */
 /* By variable cell has formated values                  */
title;
proc lifetest data = prentice
              outs = four
              plots = (s, ls, lls);
   time time*state(0);
   strata trt;
   by cell;
   format cell tumor.;
run;

proc print data = four label;
   title 'Product Limit Estimates by CELL';
run;


 /*****************************************************************
  Sample Program liftex4.sas in Previous Releases
 *****************************************************************/
 /* Data Source: Example 5.2 in R.C. Elandt-Johnson and N.L.     */
 /*              Johnson (1980): Survival Models and Data        */
 /*              Analysis. John Wiley and Sons, New York.        */

 /*
   The definition of HAZARD RATE in PROC LIFETEST is different
   from that of Elandt-Johnson and Johnson. The HAZARD RATE in
   PROC LIFETEST is their CENTRAL RATE.                                   */

data mice;
   input lifetime freq @@;
   datalines;
 40 1  48 1  50 1  54 1  56 1  59 1  62 1  63 1  67 2  69 1
 70 1  71 1  73 2  76 1  77 1  80 1  81 2  82 1  83 1  84 1
 86 2  87 1  88 5  89 1  90 2  91 1  93 1  94 1  95 1  96 1
 97 2  98 1  99 2 100 4 101 3 102 2 103 5 104 3 105 2 106 3
107 1 108 1 109 2 110 3 111 3 112 1 113 2 114 2 115 1 116 2
117 1 118 3 119 2 120 3 121 2 123 2 124 3 125 2 126 5 127 4
128 4 129 6 130 4 131 2 132 1 133 3 134 4 135 3 136 4 137 3
138 1 139 2 140 2 141 5 142 1 144 5 145 2 146 4 147 4 148 4
149 1 150 1 151 4 152 2 153 1 155 1 156 1 157 1 158 2 160 1
161 1 162 2 163 2 164 1 165 2 166 1 168 1 169 1 171 2 172 2
174 1 177 2
;

proc lifetest method = life
              intervals = (30 to 180 by 15)
              plots = (pdf, hazard);
   time lifetime;
   freq freq;
   title 'Male Mice Exposed to 240 Rad of Gamma Radiation';
run;

ods graphics off;
