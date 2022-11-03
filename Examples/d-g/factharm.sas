 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: FACTHARM                                            */
 /*   TITLE: Examples for PROC FACTOR from Harman                */
 /* PRODUCT: SAS                                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: factor analysis, multivariate analysis              */
 /*   PROCS: PRINT, FACTOR, SCORE                                */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: Modern Factor Analysis, Harry H. Harman, 2nd ed.    */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

*-----------------------Examples from Harman----------------------*
|                                                                 |
| The following examples are taken from Harry H. Harman's classic |
| book "Modern Factor Analysis", 2nd ed, Univ. of Chicago Press,  |
| 1967. Computing methods have improved dramatically since 1967,  |
| so the results from proc factor will not agree exactly with     |
| those given in Harman.                                          |
|                                                                 |
*----------------------------------------------------------wss----;

data hypoth6(type=corr);
   title 'Six Hypothetical Variables';
   title2 'See pp 88-92 of Harman: Modern Factor Analysis, 2nd ed';
   input _type_ $ 1-8 _name_ $ 9-16
          x1 17-20 x2 21-24 x3 25-28 x4 29-32
          x5 33-36 x6 37-40;
   datalines;
corr    x1      1.00
corr    x2       .721.00
corr    x3       .75 .781.00
corr    x4       .49 .42 .351.00
corr    x5       .42 .36 .30 .421.00
corr    x6       .28 .24 .20 .28 .241.00
;
run;

proc print;
run;

proc factor method=uls nfact=2 rotate=quartimax norm=weight;
run;

*-----------------------------------------------------------------;

data socecon;
   title 'Five Socio-Economic Variables';
   title2 'See page 14 of Harman: Modern Factor Analysis, 2nd ed';
   input pop 1-9  school 10-19 employ 20-29 services 30-39
         house 40-49;
   label pop='total population' school='median school years'
         employ='total employment' services='misc. professional services'
         house='median value house';
   datalines;
5700     12.8      2500      270       25000
1000     10.9      600       10        10000
3400     8.8       1000      10        9000
3800     13.6      1700      140       25000
4000     12.8      1600      140       25000
8200     8.3       2600      60        12000
1200     11.4      400       10        16000
9100     11.5      3300      60        14000
9900     12.5      3400      180       18000
9600     13.7      3600      390       25000
9600     9.6       3300      80        12000
9400     11.4      4000      100       13000
;
run;
proc print;
run;

ods graphics on;
proc factor outstat=fact1 method=principal nfact=2 rotate=varimax score
            plots=(loadings initloadings);
   title2 'See pages 137 & 310 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc print; by _type_ notsorted;
   title2 'Output Data Set from Proc Factor';
run;

proc score score=fact1 data=socecon out=scores;
   title2 'Factor Scores';
proc print;
run;

proc factor data=fact1 method=prin nfact=2;
   priors smc;
   title2 'See page 162 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor data=fact1 method=ml nfact=2 heywood;
   title2 'See page 229 of Harman: Modern Factor Analysis, 2nd ed';
run;

*-----------------------------------------------------------------;

data phys8(type=corr /* df=304 */);
   title 'Eight Physical Variables';
   title2 'See page 80 of Harman: Modern Factor Analysis, 2nd ed';
   input _name_ $ 1-8
         var1 9-16 var2 17-24 var3 25-32 var4 33-40
         var5 41-48 var6 49-56 var7 57-64 var8 65-72;
   if _n_=1 then _type_='n    '; else _type_='corr';
   label var1='height' var2='arm span' var3='length of forearm'
         var4='length of lower leg'
         var5='weight' var6='bitrochanteric diameter'
         var7='chest girth' var8='chest wid';
   datalines;
df       305     305     305     305     305     305     305     305
var1    1.0     .846    .805    .859    .473    .398    .301    .382
var2    .846    1.0     .881    .826    .376    .326    .277    .415
var3    .805    .881    1.0     .801    .380    .319    .237    .345
var4    .859    .826    .801    1.0     .436    .329    .327    .365
var5    .473    .376    .380    .436    1.0     .762    .730    .629
var6    .398    .326    .319    .329    .762    1.0     .583    .577
var7    .301    .277    .237    .327    .730    .583    1.0     .539
var8    .382    .415    .345    .365    .629    .577    .539    1.0
;
run;
proc print;
run;

proc factor method=prin nfact=2 outstat=fact plots=(loadings);
   priors .854 .897 .833 .783 .870 .687 .521 .579;
   title2 'See pp 154-155 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc print;
   by _type_ notsorted;
   title2 'Output Data Set from Proc Factor';
run;

proc factor rotate=varimax plots=(loadings);
   title2 'Varimax Rotation:  Harman, page 309';
run;

ods graphics off;

proc factor method=uls nfact=2;
   title2 'See Page 205 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor method=uls nfact=3 heywood;
run;

proc factor method=ml nfact=3 heywood;
   title2 'See Page 228 of Harman: Modern Factor Analysis, 2nd ed';
run;
*-----------------------------------------------------------------;

data emotion8(type=corr /* df=100 */);
   title 'Eight Emotional Variables:  Harman, page 164';
   input _type_ $ _name_ $
        sociabil sorrow tender joy wonder disgust anger fear;
   datalines;
corr    sociabil 1.00 .83 .81 .80 .71 .54 .53 .24
corr    sorrow    .83 1.0 .87 .62 .59 .58 .44 .45
corr    tender    .81 .87 1.00 .63 .37 .30 .12 .33
corr    joy      .80 .62 .63 1.00 .49 .30 .28 .29
corr    wonder   .71 .59 .37 .49 1.00 .34 .55 .19
corr    disgust  .54 .58 .30 .30 .34 1.00 .38 .21
corr    anger    .53 .44 .12 .28 .55 .38  1.00 .10
corr    fear     .24 .45 .33 .29 .19 .21 .10 1.00
n       df       101 101 101 101 101 101 101 101
;
run;

proc print;
run;

proc factor method=prin nfact=2;
   priors  .94 .94 .89 .50 .57 .28 .63 .12;
run;

proc factor method=uls nfact=2;
   priors max;
   title 'Eight Emotional Variables:  Harman, page 206';
run;

*-----------------------------------------------------------------;

data spear5 (type=corr /* df=100 */ label='Spearman''s Example');
   title 'Spearman''s Five Variables:  Harman, pp 116,391-392';
   input _type_ $ 1-8 _name_ $ 9-16
         test1 17-20 test2 21-24 test3 25-28
         test4 29-32 test5 33-36;
   label test1='mathematical judgement' test2='controlled association'
         test3='literary interpretation' test4='selective judgement'
         test5='spelling';
   datalines;
corr    test1   1.00
corr    test2   .4851.00
corr    test3   .400.3971.00
corr    test4   .397.397.3351.00
corr    test5   .295.247.275.1951.00
n       df      101 101 101 101 101
;
run;

proc print;
run;

proc factor method=ml nfact=1;
run;

*-----------------------------------------------------------------;

data heywood(type=corr /* df=100 */
            label='Harman''s heywood case example');
   title 'Heywood Example:  Harman, pp 117,391';
   input _type_ $ 1-8 _name_ $ 9-16
         x1 17-20 x2 21-24 x3 25-28 x4 29-32 x5 33-36;
   datalines;
corr    x1      1.00
corr    x2      .9451.00
corr    x3      .840.7201.00
corr    x4      .735.630.5601.00
corr    x5      .630.540.480.4201.00
n       df      101 101 101 101 101
;
run;

proc print;
run;

proc factor method=uls nfact=1 heywood;
run;

proc factor method=uls nfact=1 ultraheywood;
run;


*-----------------------------------------------------------------;

data psych9 (type=corr /* df=100 */
            label='Nine Psychological Variables');
   title 'Nine Psychological Variables:  Harman, page 244';
   input _type_ $ 1-8 _name_ $ 9-16
         x1 17-20 x2 21-24 x3 25-28 x4 29-32 x5 33-36
        x6 37-40 x7 41-44 x8 45-48 x9 49-52;
   label
        x1='word meaning' x2='sentence composition' x3='odd words'
        x4='mixed arithmetic' x5='remainders' x6='missing numbers'
        x7='gloves' x8='boots' x9='hatchets';
   datalines;
corr    x1      1.00
corr    x2       .751.00
corr    x3       .78 .721.00
corr    x4       .44 .52 .471.00
corr    x5       .45 .53 .48 .821.00
corr    x6       .51 .58 .54 .82 .741.00
corr    x7       .21 .23 .28 .33 .37 .351.00
corr    x8       .30 .32 .37 .33 .36 .38 .451.00
corr    x9       .31 .30 .37 .31 .36 .38 .52 .671.00
n       df      101 101 101 101 101 101 101 101 101
;
run;

proc print;
run;

proc factor method=prin rotate=hk ;
   priors .81 .69 .75 .91 .74 .74 .35 .58 .77;
run;

*-----------------------------------------------------------------;

data politic8(type=corr /* df=147 */
          label='Harmans Eight Political Variables');
   title 'Eight Political Variables:  Harman, page 166';
   input _type_ $ 1-8 _name_ $ 9-16
          lewis 17-20 roosevel 21-24 partyv 25-28 rental 29-32
          homeown 33-36 unemploy 37-40 mobility 41-44 educatn 45-48;
   datalines;
corr    lewis   1.00
corr    roosevel .841.00
corr    partyv   .62 .841.00
corr    rental  -.53-.68-.761.00
corr    homeown  .03-.05 .08-.251.00
corr    unemploy .57 .76 .81-.80 .251.00
corr    mobility-.33-.35-.51 .62-.72-.581.00
corr    educatn -.63-.73-.81 .88-.36-.84 .681.00
n       df      148 148 148 148 148 148 148 148
;
run;

proc print;
run;

proc factor method=prin nfact=2 outstat=fact;
   priors .52 1 .78 .82 .36 .8 .63 .97;
run;

proc factor rotate=varimax ;
   title 'Eight Political Variables:  Harman, page 424';
run;

proc factor rotate=quartimax ;
   title 'Eight Political Variables:  Harman, page 423';
run;

proc factor rotate=hk ;
   title 'Eight Political Variables:  Harman, page 332';
run;

proc factor rotate=promax ;
   title 'Eight Political Variables';
run;

*-----------------------------------------------------------------;

data psych24(/* df=145 */ type=corr);
   title 'Twenty Four Psychological Tests';
   title2 'See Pages 124-125 of Harman: Modern Factor Analysis, 2nd ed';

   input _name_ $ test1-test24;
   if _n_=1 then _type_='n    '; else _type_='corr';
   label
       test1='visual perception'              test2='cubes'
       test3='paper form board'               test4='flags'
       test5='general information'            test6='paragraph comprehension'
       test7='sentence completion'            test8='word classification'
       test9='word meaning'                   test10='addition'
       test11='code'                          test12='counting dots'
       test13='straight-curved capitals'      test14='word recognition'
       test15='number recognition'            test16='figure recognition'
       test17='object - number'               test18='number - figure'
       test19='figure - word'                 test20='deduction'
       test21='numerical puzzles'             test22='problem reasoning'
       test23='series completion'             test24='arithmetic problems';
   datalines;
 df         146     146     146     146     146
            146     146     146     146     146
            146     146     146     146     146
            146     146     146     146     146
            146     146     146     146
 test1      1.000   0.318   0.403   0.468   0.321
            0.335   0.304   0.332   0.326   0.116
            0.308   0.314   0.489   0.125   0.238
            0.414   0.176   0.368   0.270   0.365
            0.369   0.413   0.474   0.282
 test2      0.318   1.000   0.317   0.230   0.285
            0.234   0.157   0.157   0.195   0.057
            0.150   0.145   0.239   0.103   0.131
            0.272   0.005   0.255   0.112   0.292
            0.306   0.232   0.348   0.211
 test3      0.403   0.317   1.000   0.305   0.247
            0.268   0.223   0.382   0.184  -0.075
            0.091   0.140   0.321   0.177   0.065
            0.263   0.177   0.211   0.312   0.297
            0.165   0.250   0.383   0.203
 test4      0.468   0.230   0.305   1.000   0.227
            0.327   0.335   0.391   0.325   0.099
            0.110   0.160   0.327   0.066   0.127
            0.322   0.187   0.251   0.137   0.339
            0.349   0.380   0.335   0.248
 test5      0.321   0.285   0.247   0.227   1.000
            0.622   0.656   0.578   0.723   0.311
            0.344   0.215   0.344   0.280   0.229
            0.187   0.208   0.263   0.190   0.398
            0.318   0.441   0.435   0.420
 test6      0.335   0.234   0.268   0.327   0.622
            1.000   0.722   0.527   0.714   0.203
            0.353   0.095   0.309   0.292   0.251
            0.291   0.273   0.167   0.251   0.435
            0.263   0.386   0.431   0.433
 test7      0.304   0.157   0.223   0.335   0.656
            0.722   1.000   0.619   0.685   0.246
            0.232   0.181   0.345   0.236   0.172
            0.180   0.228   0.159   0.226   0.451
            0.314   0.396   0.405   0.437
 test8      0.332   0.157   0.382   0.391   0.578
            0.527   0.619   1.000   0.532   0.285
            0.300   0.271   0.395   0.252   0.175
            0.296   0.255   0.250   0.274   0.427
            0.362   0.357   0.501   0.388
 test9      0.326   0.195   0.184   0.325   0.723
            0.714   0.685   0.532   1.000   0.170
            0.280   0.113   0.280   0.260   0.248
            0.242   0.274   0.208   0.274   0.446
            0.266   0.483   0.504   0.424
 test10     0.116   0.057  -0.075   0.099   0.311
            0.203   0.246   0.285   0.170   1.000
            0.484   0.585   0.408   0.172   0.154
            0.124   0.289   0.317   0.190   0.173
            0.405   0.160   0.262   0.531
 test11     0.308   0.150   0.091   0.110   0.344
            0.353   0.232   0.300   0.280   0.484
            1.000   0.428   0.535   0.350   0.240
            0.314   0.362   0.350   0.290   0.202
            0.399   0.304   0.251   0.412
 test12     0.314   0.145   0.140   0.160   0.215
            0.095   0.181   0.271   0.113   0.585
            0.428   1.000   0.512   0.131   0.173
            0.119   0.278   0.349   0.110   0.246
            0.355   0.193   0.350   0.414
 test13     0.489   0.239   0.321   0.327   0.344
            0.309   0.345   0.395   0.280   0.408
            0.535   0.512   1.000   0.195   0.139
            0.281   0.194   0.323   0.263   0.241
            0.425   0.279   0.382   0.358
 test14     0.125   0.103   0.177   0.066   0.280
            0.292   0.236   0.252   0.260   0.172
            0.350   0.131   0.195   1.000   0.370
            0.412   0.341   0.201   0.206   0.302
            0.183   0.243   0.242   0.304
 test15     0.238   0.131   0.065   0.127   0.229
            0.251   0.172   0.175   0.248   0.154
            0.240   0.173   0.139   0.370   1.000
            0.325   0.345   0.334   0.192   0.272
            0.232   0.246   0.256   0.165
 test16     0.414   0.272   0.263   0.322   0.187
            0.291   0.180   0.296   0.242   0.124
            0.314   0.119   0.281   0.412   0.325
            1.000   0.324   0.344   0.258   0.388
            0.348   0.283   0.360   0.262
 test17     0.176   0.005   0.177   0.187   0.208
            0.273   0.228   0.255   0.274   0.289
            0.362   0.278   0.194   0.341   0.345
            0.324   1.000   0.448   0.324   0.262
            0.173   0.273   0.287   0.326
 test18     0.368   0.255   0.211   0.251   0.263
            0.167   0.159   0.250   0.208   0.317
            0.350   0.349   0.323   0.201   0.334
            0.344   0.448   1.000   0.358   0.301
            0.357   0.317   0.272   0.405
 test19     0.270   0.112   0.312   0.137   0.190
            0.251   0.226   0.274   0.274   0.190
            0.290   0.110   0.263   0.206   0.192
            0.258   0.324   0.358   1.0   0.167
            0.331   0.342   0.303   0.374
 test20     0.365   0.292   0.297   0.339   0.398
            0.435   0.451   0.427   0.446   0.173
            0.202   0.246   0.241   0.302   0.272
            0.388   0.262   0.301   0.167   1.000
            0.413   0.463   0.509   0.366
 test21     0.369   0.306   0.165   0.349   0.318
            0.263   0.314   0.362   0.266   0.405
            0.399   0.355   0.425   0.183   0.232
            0.348   0.173   0.357   0.331   0.413
            1.000   0.374   0.451   0.448
 test22     0.413   0.232   0.250   0.380   0.441
            0.386   0.396   0.357   0.483   0.160
            0.304   0.193   0.279   0.243   0.246
            0.283   0.273   0.317   0.342   0.463
            0.374   1.000   0.503   0.375
 test23     0.474   0.348   0.383   0.335   0.435
            0.431   0.405   0.501   0.504   0.262
            0.251   0.350   0.382   0.242   0.256
            0.360   0.287   0.272   0.303   0.509
            0.451   0.503   1.0   0.434
 test24     0.282   0.211   0.203   0.248   0.420
            0.433   0.437   0.388   0.424   0.531
            0.412   0.414   0.358   0.304   0.165
            0.262   0.326   0.405   0.374   0.366
            0.448   0.375   0.434   1.000
;
run;

proc print;
run;

proc factor method=prin nfact=10;
   title2 'See Page 168 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor method=prin nfact=5;
     priors smc;
   title2 'See Page 170 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor method=ml nfact=4;
   title2 'See Page 231 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor method=uls  nfact=5 residuals;
   title2 'See pp 208-209 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor method=uls  nfact=4 outstat=fact;
   title2 'See Page 209 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor rotate=varimax;
   title2 'See Page 311 of Harman: Modern Factor Analysis, 2nd ed';
run;

proc factor rotate=quartimax;
run;
