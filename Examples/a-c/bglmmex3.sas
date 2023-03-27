/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex3                                            */
/*   TITLE: Example 3 for PROC BGLIMM                           */
/*    DESC: Poisson Regression with Random Effects              */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Poisson data                                        */
/*   PROCS: BGLIMM                                              */
/*    DATA: Scottish lip cancer data                            */
/*                                                              */
/*     REF: Clayton, D. and Kaldor, J. (1987)                   */
/*          Empirical Bayes Estimates of Age-standardized       */
/*          Relative Risks for Use in Disease Mapping           */
/*          Biometrics, 43, 671-681                             */
/****************************************************************/

data LipCancer;
   input County Observed Expected Employment SMR;
   if (Observed > 0) then ExpCount = 100*Observed/SMR;
   else ExpCount = Expected;
   x    = Employment / 10;
   LogN = log(ExpCount);
   datalines;
 1  9  1.4 16 652.2
 2 39  8.7 16 450.3
 3 11  3.0 10 361.8
 4  9  2.5 24 355.7
 5 15  4.3 10 352.1
 6  8  2.4 24 333.3
 7 26  8.1 10 320.6
 8  7  2.3  7 304.3
 9  6  2.0  7 303.0
10 20  6.6 16 301.7
11 13  4.4  7 295.5
12  5  1.8 16 279.3
13  3  1.1 10 277.8
14  8  3.3 24 241.7
15 17  7.8  7 216.8
16  9  4.6 16 197.8
17  2  1.1 10 186.9
18  7  4.2  7 167.5
19  9  5.5  7 162.7
20  7  4.4 10 157.7
21 16 10.5  7 153.0
22 31 22.7 16 136.7
23 11  8.8 10 125.4
24  7  5.6  7 124.6
25 19 15.5  1 122.8
26 15 12.5  1 120.1
27  7  6.0  7 115.9
28 10  9.0  7 111.6
29 16 14.4 10 111.3
30 11 10.2 10 107.8
31  5  4.8  7 105.3
32  3  2.9 24 104.2
33  7  7.0 10  99.6
34  8  8.5  7  93.8
35 11 12.3  7  89.3
36  9 10.1  0  89.1
37 11 12.7 10  86.8
38  8  9.4  1  85.6
39  6  7.2 16  83.3
40  4  5.3  0  75.9
41 10 18.8  1  53.3
42  8 15.8 16  50.7
43  2  4.3 16  46.3
44  6 14.6  0  41.0
45 19 50.7  1  37.5
46  3  8.2  7  36.6
47  2  5.6  1  35.8
48  3  9.3  1  32.1
49 28 88.7  0  31.6
50  6 19.6  1  30.6
51  1  3.4  1  29.1
52  1  3.6  0  27.6
53  1  5.7  1  17.4
54  1  7.0  1  14.2
55  0  4.2 16   0.0
56  0  1.8 10   0.0
;

proc bglimm data=LipCancer seed=10571042 nmc=10000
   outpost=LipCancer_Out;
   class County;
   model Observed = x / dist=poisson offset=LogN;
   random int / sub=County;
run;

data SMR_PRED;
   array gamma[56] Intercept__County_1-Intercept__County_56;
   array SMR_pred[56];
   set LipCancer_Out;
      do i = 1 to 56;
         set LipCancer(rename=(x=data_x)) point=i;
         SMR_pred[i] = 100 * exp(Intercept + x * data_x + gamma[i]);
      end;
   keep smr_pred:;
   run;


%sumint(data=SMR_PRED, var=_numeric_, print=NO, out=SMR_SI)

data combine;
   merge LipCancer SMR_SI;
run;

proc sgplot data=combine noautolegend aspect=1;
   yaxis label="Predicted SMR" max=700;
   xaxis label="Observed SMR" max=700;
   text x=SMR y=mean text=employment;
   lineparm x=0 y=0 slope=1;
run;

proc bglimm data=LipCancer seed=10571042 nmc=10000
   outpost=LipCancer_fOut;
   class County;
   model Observed = x / dist=poisson offset=LogN;
run;

data SMR_PRED_f;
   array SMR_pred[56];
   set LipCancer_Out;
      do i = 1 to 56;
         set LipCancer(rename=(x=data_x)) point=i;
         SMR_pred[i] = 100 * exp(Intercept + x * data_x);
      end;
   keep smr_pred:;
   run;

%sumint(data=SMR_PRED_f, var=_numeric_, print=NO, out=SMR_SIf)

data combine_f;
   merge LipCancer SMR_SIf;
run;

proc sgplot data=combine_f noautolegend aspect=1;
   yaxis label="Predicted SMR" max=700;
   xaxis label="Observed SMR" max=700;
   text x=SMR y=mean text=employment;
   lineparm x=0 y=0 slope=1;
run;

proc bglimm data=LipCancer seed=10571042 nmc=10000 DIC;
   class County;
   model Observed = x / dist=poisson offset=LogN;
   random int / sub=County;
run;

proc bglimm data=LipCancer seed=10571042 nmc=10000 DIC;
   class County;
   model Observed = x / dist=poisson offset=LogN;
run;

proc bglimm data=LipCancer seed=10571042 nmc=10000;
   class County Employment;
   model Observed = x / dist=poisson offset=LogN;
   random int / sub=Employment;
   random int / sub=County;
run;

