 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: phrmult                                             */
 /*   TITLE: Analysis of Multivariate Failure Time Data          */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: survival analysis, multivariate analysis, ODS       */
 /*          graphics                                            */
 /*   PROCS: PHREG                                               */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: PROC LIFTEST Documentation, Details Section,        */
 /*          Analysis of Multivariate Failure Time Data sub-     */
 /*          section                                             */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/


 /*----------------------------------------------------------------
  This sample program illustrates how to use PROC PHREG to analyze
  various types of multivariate failure time data:

  1)  multiple events (ordered/unordered) data are analyzed by the
      marginal approach of Wei, Lin, and Weissfeld (1989)

  2)  clustered data are analyzed by the marginal approach of Lee,
      Wei, and Amato (1992)

  3)  recurrent events data, which are special cases of ordered
      multiple events data, can also be analyzed using an intensity
      model (Andersen and Gill, 1982), a rate/mean model (Pepe
      M.S. and Cai, J. 1993; Lawless and Nadeau, 1995; Lin et. al,
      2000), or the conditional models of Prentice, Williams, and
      Peterson (1981).

  References:

    Andersen, P.K. and Gill, R.D. (1982). Cox's regression model
      for counting processes: a large sample study. Ann. Statist.,
      10, 1100-1120.

    Lawless, J.F. and Nadeau, C. (1995). Some simple and robust
      methods for the analysis of recurrent events. Technometrics,
      158-169.

    Lee, E.W., Wei, L.J., and Amato, D. (1992). Cox-type regression
      analysis for large number of small groups of correlated
      failure time observations. In Survival Analysis, State of
      the Art, Eds, J.P. Klein and P.K. Goel, 237-247. Netherlands:
      Kluwer Academic Publishers.

    Lin, D.Y., Wei, L.J., Yang, I. and Ying, Z. (2000). Semi-
      parametric regression for the mean and rate functions of
      recurrent events. J. R. Statist. Soc., B, 62, 711-730.

    Pepe, M.S. and Cai, J. (1993). Some graphical displays and
      marginal regression analyses for recurrent failure times
      and time dependent covariates. J. Am. Statist. Assoc. 88,
      811-820.

    Prentice, R.L., Williams, B.J., and Peterson, A.V. (1981).
      On the Regression Analysis of Multivariate Failure Time
      Data. Biometrika, 68, 373-379.

    Wei, L.J., Lin, D.Y., and Weissfeld. L. (1989). Regression
     analysis of multivariate incomplete failure time data by
     modeling marginal distribution. J. Am. Statist. Assoc. 84,
     1065-1071.

  ---------------------------------------------------------------*/



 /*****************************************************************
  MARGINAL COX MODELS FOR MULTIPLE EVENTS DATA

  AIDS Study. A randomized clinical trial was conducted to assess
  the antiretrovial capability of ribavirin over times in AIDS
  patients. Blood samples were collected at weeks 4, 8, and 12 from
  each patient in three treatment groups (Placebo, Low dose, and
  High dose) of ribavirin. For each serum sample, the failure time
  is the number of days when virus positivity was detected. If a
  sample was contaminated or when it took a longer period of time
  than was achievable in the laboratory, the sample was censored.

  Data Source:  Wei, Lin, and Weissfeld (1989)
  ****************************************************************/
title 'AIDS Study';
data AIDS;
   input trt week4 week8 week12;
   label trt="1=Placebo,2=Low Dose,3=High Dose";
   datalines;
1 9 6 7
1 4 5 10
1 6 7 6
1 10 . -21
1 15 8 .
1 3 . 6
1 4 7 3
1 9 12 12
1 9 19 -19
1 6 5 6
1 9 . 18
1 9 -20 -17
2 6 4 5
2 16 17 -21
2 31 -19 -21
2 -27 -19 .
2 7 16 -23
2 -28 7 -19
2 -28 3 16
2 15 12 16
2 18 -21 22
2 8 4 7
2 4 -21 7
3 21 9 -8
3 13 7 -21
3 16 6 20
3 3 8 6
3 21 . -25
3 7 19 3
3 11 13 -21
3 -27 -18 9
3 14 14 6
3 8 11 15
3 8 4 7
3 8 3 9
3 -19 10 -17
;
run;

data AIDS (drop= week4 week8 week12 i);
   retain ID 0;
   array w[3] week4 week8 week12;
   set AIDS;
   *Enum= 1  week 4 sample
          2  week 8 sample
          3  week 12 sample;
   *Status= 1  event
          0  censored;
   ID + 1;
   Z1= (trt=2);
   Z2= (trt=3);
   do i= 1 to 3;
      if w[i] ^= . then do;
         if w[i] < 0 then do;
            Time= -w[i];
            Status= 0;
         end;
         else do;
            Time= w[i];
            Status= 1;
         end;
         Enum= i;
         Z11= Z1 * (Enum=1);
         Z12= Z1 * (Enum=2);
         Z13= Z1 * (Enum=3);
         Z21= Z2 * (Enum=1);
         Z22= Z2 * (Enum=2);
         Z23= Z2 * (Enum=3);
         output;
      end;
   end;

title2 'Unordered Multiple Events Data';
title3 'Marginal Cox Model with Noncommon Baseline Hazard Functions';
proc phreg data=AIDS outest=est2 covs(aggregate) covout;
   model Time * Status(0) = Z11 Z12 Z13 Z21 Z22 Z23;
   strata Enum;
   id ID;
   Z11= (trt=2) * (Enum=1);
   Z12= (trt=2) * (Enum=2);
   Z13= (trt=2) * (Enum=3);
   Z21= (trt=3) * (Enum=1);
   Z22= (trt=3) * (Enum=2);
   Z23= (trt=3) * (Enum=3);
   EqualLowDose:  test Z11 - Z12, Z11 - Z13;
   AverageLow:  test Z11, Z12, Z13/e average;
   EqualHighDose: test Z21 - Z22, Z21 - Z23;
   AverageHigh: test Z21, Z22, Z23/e average;
   run;
title2;
title3;



 /******************************************************************
  MARGINAL COX MODEL FOR CLUSTERED DATA

  Tumor Study. One of the three female rats of the same litter
  was subjected to a drug treatment. The failure time is the time
  to tumor. If a rat died before the tumor was detected, the
  failure time was censored.

  Data Source: Mantel, M., Bohidar, N.R., and Ciminera, J. (1977).
    Mantel-Haenszel analysis of litter-matched time-to response
    data, with modifications for recovery of interlitter
    information. Cancer Research, 37, 3863-3868. (Only the female
    data were used since almost all male data were censored.)
 ******************************************************************/
title 'Tumor Study';
data Rats;
   input Litter Treatment Time Status;
   label Treatment='1=treated 0=placebo'
         Time= 'weeks to tumor or death'
         Status= '1=tumor 0=death';
   datalines;
   1       1      101        0
   1       0       49        1
   1       0      104        0
   3       1      104        0
   3       0      102        0
   3       0      104        0
   5       1      104        0
   5       0      104        0
   5       0      104        0
   7       1       77        0
   7       0       97        0
   7       0       79        0
   9       1       89        0
   9       0      104        0
   9       0      104        0
  11       1       88        1
  11       0       96        1
  11       0      104        0
  13       1      104        1
  13       0       94        0
  13       0       77        1
  15       1       96        1
  15       0      104        0
  15       0      104        0
  17       1       82        0
  17       0       77        0
  17       0      104        0
  19       1       70        1
  19       0      104        0
  19       0       77        0
  21       1       89        1
  21       0       91        0
  21       0       90        0
  23       1       91        0
  23       0       70        0
  23       0       92        0
  25       1       39        1
  25       0       45        0
  25       0       50        1
  27       1      103        1
  27       0       69        0
  27       0       91        0
  29       1       93        0
  29       0      104        0
  29       0      103        0
  31       1       85        0
  31       0       72        0
  31       0      104        0
  33       1      104        0
  33       0       63        0
  33       0      104        0
  35       1      104        0
  35       0      104        0
  35       0       74        0
  37       1       81        0
  37       0      104        0
  37       0       69        0
  39       1       67        1
  39       0      104        0
  39       0       68        1
  41       1      104        0
  41       0      104        0
  41       0      104        0
  43       1      104        0
  43       0      104        0
  43       0      104        0
  45       1      104        0
  45       0       83        0
  45       0       40        1
  47       1       87        0
  47       0      104        0
  47       0      104        0
  49       1      104        0
  49       0      104        0
  49       0      104        0
  51       1       89        0
  51       0      104        0
  51       0      104        0
  53       1       78        0
  53       0      104        0
  53       0      104        0
  55       1      104        0
  55       0       81        1
  55       0       64        1
  57       1       86        1
  57       0       55        1
  57       0       94        0
  59       1       34        1
  59       0      104        0
  59       0       54        1
  61       1       76        0
  61       0       87        0
  61       0       74        0
  63       1      103        1
  63       0       73        1
  63       0       84        1
  65       1      102        1
  65       0      104        0
  65       0       80        0
  67       1       80        1
  67       0      104        0
  67       0       73        0
  69       1       45        1
  69       0       79        0
  69       0      104        0
  71       1       94        1
  71       0      104        0
  71       0      104        0
  73       1      104        0
  73       0      104        0
  73       0      104        0
  75       1      104        0
  75       0      101        1
  75       0       94        0
  77       1       76        0
  77       0       84        1
  77       0       78        1
  79       1       80        1
  79       0       81        1
  79       0       76        0
  81       1       72        1
  81       0       95        0
  81       0      104        0
  83       1       73        1
  83       0      104        0
  83       0       66        1
  85       1       92        1
  85       0      104        0
  85       0      102        1
  87       1      104        0
  87       0       98        0
  87       0       73        0
  89       1       55        0
  89       0      104        0
  89       0      104        0
  91       1       49        0
  91       0       83        0
  91       0       77        0
  93       1       89        1
  93       0      104        0
  93       0      104        0
  95       1       88        0
  95       0       79        0
  95       0       99        0
  97       1      103        1
  97       0       91        0
  97       0      104        0
  99       1      104        0
  99       0      104        0
  99       0       79        1
;
run;

title2 'Clustered Data';
title3 'Marginal Cox Model with a Common Baseline Hazard Function';
proc phreg data=Rats covs(aggregate);
   model Time*Status(0) = Treatment;
   id Litter;
   run;
title2;
title3;

 /*****************************************************************
  RECURRENT EVENTS DATA

  CGD Study. Chronic Granulomatous Disease (CGD) is a rare immune
  disorder characterized by recurrent pyrogenic infections. A
  placeco controlled randomized clinical trial was conducted by
  the International CGD Cooperative Study Group to study the effect
  of gamma interferon to reduce the rate of infections.

  Data Source: Fleming, T.R. and Harrington, D.P. (1991). Counting
     Process and Survival Data. New York: Wiley.

 ****************************************************************/

title 'CGD Study';
title 'Recurrent Events Data';

data CGD;
   input ID TStart TStop Status Enum Trt Age;
   label ID='Case Identification Number'
         TStart='start time'
         TStop='elased time from randomization'
         Status='1=uncensored 0=censored'
         Enum='recurrence sequence number';
   datalines;
174054        0      293        0        1      1      38
174077        0      255        0        1      2      14
174109        0      213        0        1      2      26
174111        0      203        0        1      2      26
204001        0      219        1        1      1      12
204001      219      373        1        2      1      12
204001      373      414        0        3      1      12
204002        0        8        1        1      2      15
204002        8       26        1        2      2      15
204002       26      152        1        3      2      15
204002      152      241        1        4      2      15
204002      241      249        1        5      2      15
204002      249      322        1        6      2      15
204002      322      350        1        7      2      15
204002      350      439        0        8      2      15
204003        0      382        0        1      1      19
204004        0      388        0        1      1      12
204014        0      211        1        1      2       1
204014      211      260        1        2      2       1
204014      260      265        1        3      2       1
204014      265      269        1        4      2       1
204014      269      307        1        5      2       1
204014      307      363        0        6      2       1
204015        0       82        1        1      1       9
204015       82      114        1        2      1       9
204015      114      337        1        3      1       9
204015      337      367        0        4      1       9
204018        0       18        1        1      2       1
204018       18      362        0        2      2       1
204029        0      267        1        1      1       5
204029      267      360        0        2      1       5
204056        0      337        0        1      1      22
204085        0      270        0        1      2      19
204088        0      274        0        1      2       7
204102        0      271        0        1      1      25
204103        0      252        0        1      2      31
204131        0      243        0        1      1      37
204134        0      104        1        1      2       6
204134      104      227        0        2      2       6
204135        0      227        0        1      2       3
222121        0      198        0        1      2      22
222122        0      207        0        1      2      17
222123        0      168        1        1      2      19
222123      168      200        0        2      2      19
222125        0      197        0        1      1      36
238005        0      246        1        1      2      17
238005      246      253        1        2      2      17
238005      253      383        0        3      2      17
238009        0      294        1        1      2      27
238009      294      349        0        2      2      27
238010        0      371        0        1      1       5
238011        0       19        1        1      2       2
238011       19      102        0        2      2       2
238012        0      373        1        1      1       8
238012      373      388        0        2      1       8
238013        0      388        0        1      1      12
238016        0      365        0        1      2      27
238017        0      334        1        1      2      14
238017      334      370        1        2      2      14
238017      370      382        0        3      2      14
238019        0      373        0        1      1      11
238020        0      280        1        1      2      29
238020      280      385        0        2      2      29
238021        0      376        0        1      1      31
238022        0      360        0        1      1       7
238023        0      306        0        1      2      26
238036        0      118        1        1      1      13
238036      118      240        1        2      1      13
238036      240      251        0        3      1      13
238044        0      187        1        1      1      25
238044      187      356        0        2      1      25
238045        0      339        0        1      1       9
238046        0        6        1        1      2      28
238046        6      301        0        2      2      28
238051        0      334        0        1      1      13
238065        0      269        0        1      1      24
238076        0      273        0        1      2      11
238086        0      113        1        1      1       4
238086      113      273        0        2      1       4
238087        0       99        1        1      2      19
238087       99      306        1        2      2      19
238099        0      263        0        1      1      18
238100        0      167        1        1      1       7
238100      167      240        0        2      1       7
238106        0      271        0        1      2      12
238107        0      254        0        1      1      10
242091        0      278        0        1      2       9
242094        0      265        0        1      1       5
242101        0      217        0        1      1       1
242110        0      165        1        1      1       7
242110      165      210        0        2      1       7
242117        0      192        0        1      2      11
242119        0       11        1        1      2       4
242119       11       22        1        2      2       4
242119       22      169        1        3      2       4
242119      169      195        0        4      2       4
242132        0      120        1        1      2       7
242132      120      203        0        2      2       7
242133        0      197        0        1      1      15
243030        0      206        1        1      2       1
243030      206      347        0        2      2       1
243040        0      335        0        1      1       7
243041        0      274        1        1      1      17
243041      274      361        1        2      1      17
243041      361      365        0        3      1      17
243042        0      336        0        1      1       8
243052        0       52        1        1      2      20
243052       52       65        1        2      2      20
243052       65      255        1        3      2      20
243052      255      270        0        4      2      20
243053        0       67        1        1      2       5
243053       67      248        1        2      2       5
243053      248      250        1        3      2       5
243053      250      284        1        4      2       5
243053      284      347        0        5      2       5
243060        0      318        0        1      1       6
243061        0      318        1        1      2       9
243061      318      359        0        2      2       9
243097        0      259        0        1      1       5
245006        0      364        0        1      1      44
245007        0      292        1        1      2      22
245007      292      364        0        2      2      22
245008        0      363        0        1      1       7
245043        0      350        0        1      1      19
248078        0      269        0        1      1      34
248108        0      185        0        1      1      32
248115        0       91        0        1      2      25
248116        0       91        0        1      2      21
249028        0      357        0        1      2       7
249031        0      175        1        1      2       5
249031      175      280        1        2      2       5
249031      280      353        0        3      2       5
249035        0      343        0        1      2      24
249055        0      265        1        1      1      12
249055      265      303        0        2      1      12
249063        0      226        1        1      2       5
249063      226      322        0        2      2       5
249105        0      255        0        1      1      24
328064        0       65        1        1      1      26
328064       65      343        0        2      1      26
328073        0      294        0        1      2       6
328074        0      303        0        1      1       9
328079        0       23        1        1      2      25
328079       23      270        0        2      2      25
328080        0      270        0        1      1       2
328083        0      245        0        1      2       8
328084        0      261        0        1      2      10
328092        0      284        0        1      1      20
328093        0      276        0        1      2      34
328095        0      294        0        1      1       6
328096        0      277        0        1      1      11
328098        0        4        1        1      2       3
328098        4      159        1        2      2       3
328098      159      213        1        3      2       3
328098      213      287        0        4      2       3
328104        0      331        0        1      1       9
328112        0      288        0        1      2      11
328113        0      269        0        1      2      17
328114        0      269        0        1      2      10
331047        0      330        0        1      2      17
331062        0       57        1        1      2       8
331062       57      121        1        2      2       8
331062      121      351        0        3      2       8
331069        0      297        0        1      1       6
331075        0      281        0        1      2       7
331081        0      276        0        1      1       7
331089        0      279        0        1      1       8
331090        0       14        1        1      2      11
331090       14      278        0        2      2      11
331118        0      199        0        1      1       4
332032        0      308        0        1      2      18
332033        0      327        0        1      1      13
332034        0      329        0        1      2      11
332037        0      318        0        1      1       2
332038        0      304        0        1      1      17
332039        0      316        0        1      2      35
332048        0      300        0        1      2      25
332049        0      146        1        1      1      14
332049      146      188        1        2      1      14
332049      188      300        0        3      1      14
332050        0      304        1        1      2      25
332050      304      312        0        2      2      25
332057        0       91        1        1      2      27
332057       91      121        1        2      2      27
332057      121      203        1        3      2      27
332057      203      287        0        4      2      27
332058        0      293        0        1      2      32
332059        0      293        0        1      1       6
332066        0      264        1        1      2       8
332066      264      286        0        2      2       8
332067        0      286        0        1      1       9
332068        0      273        0        1      1      23
332070        0      236        1        1      2      23
332070      236      273        0        2      2      23
332071        0      273        0        1      1      17
332072        0      207        1        1      1      21
332072      207      273        0        2      1      21
332082        0      264        0        1      2       1
336024        0      160        0        1      1      12
336025        0      146        1        1      2       7
336025      146      316        0        2      2       7
336026        0      316        0        1      2       1
336027        0      315        0        1      1       3
;

data Pattern;
   Trt=1;
   Age=30;
   output;
   Trt=2;
   Age=1;
   output;
   run;


 /*
  Under the intensity model, the risk of a recurrent event for a
  subject satisfies the usual proportional hazards model, and it
  is unaffected by any earlier events that occurred to the same
  subject unless covariates that captured such dependence are
  explictly specified in the model. You can predict the
  cumulative hazard function for a given pattern of covariate
  values.
 */


title3 'Intensity Model';
proc phreg data=CGD;
   model (TStart TStop)*Status(0)= Trt Age;
   baseline covariates=Pattern out=Out1 cumhaz=_all_/nomeans;
   run;


 /*
  The rate/mean model assumes that the underlying counting process
  is a time-transformed Poisson process and the covariates have
  multiplicative effects on the means and rate functions of the
  counting process.
 */

title3 'Proportional Means Model';
proc phreg data=CGD covs(aggregate);
   model (TStart TStop)*Status(0)= Trt Age;
   id ID;
   baseline covariates=Pattern out=Out2 cmf=_all_/nomeans;
   run;


proc template;
   define statgraph CMF;
      dynamic _title;
      BeginGraph;
         entrytitle "Estimates of Cumulative Mean Frequencies of Infections";
      layout gridded;
         layout overlay /
            xaxisopts=(label="Follow-up time (days)")
            yaxisopts=(label="CMF"
                       linearopts=(tickvaluelist= (0 .2 .4 .6 .8 1.0 1.2 1.4
                                                  1.6 1.8 2.0 2.2 2.4 2.6)));
            stepplot y=CMF x=TStop / group=Patient  name="mean";
            discretelegend "mean" / location=inside
                                    hAlign=left
                                    vAlign=top
                                    across=1
                                    border=true;
         endlayout;
       endlayout;
EndGraph;
    end;
run;

ods graphics on;
ods html;
data _null_;
   set out2;
   if Trt=1 and Age=30 then Patient='Gamma Interferon, Age=30';
   else Patient='Placebo, Age=1';
   file print ods=(template="CMF");
   put _ods_;
   output;
   run;
ods html close;
ods graphics off;


 /*
   The analysis of the PWP (Prentice, Williams, and Peterson)
   conditional models is confined to the first three infections.
   GapTime is the time between the current recurrence and the
   prevous recurrence.
 */


data CGD2;
   set CGD;
   GapTime= TStop-TStart;
   if Enum > 3 then delete;
   run;

title3 'PWP total time model with stratum-specific regression coefficients';
proc phreg data=CGD2;
   model (TStart,TStop)*Status(0)=Trt1 Trt2 Trt3 Age1 Age2 Age3;
   strata Enum;
   Trt1= Trt * (Enum=1);
   Trt2= Trt * (Enum=2);
   Trt3= Trt * (Enum=3);
   Age1= Age * (Enum=1);
   Age2= Age * (Enum=2);
   Age3= Age * (Enum=3);
   run;

title3 'PWP total time model with common regression coefficients';
proc phreg data=CGD2;
   model (TStart,TStop)*Status(0)=Trt Age;
   strata Enum;
   run;

title3 'PWP gap time model with spratum-specific regression coefficients';
proc phreg data=CGD2;
  model GapTime*Status(0)=Trt1 Trt2 Trt3 Age1 Age2 Age3;
  strata Enum;
  Trt1= Trt * (Enum=1);
  Trt2= Trt * (Enum=2);
  Trt3= Trt * (Enum=3);
  Age1= Age * (Enum=1);
  Age2= Age * (Enum=2);
  Age3= Age * (Enum=3);
  run;


title3 'PWP gap time model with common regression coefficients';
proc phreg data=CGD2;
  model GapTime*Status(0)=Trt Age;
  strata Enum;
  run;
