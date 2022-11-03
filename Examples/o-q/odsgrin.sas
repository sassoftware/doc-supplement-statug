/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGRIN                                             */
/*   TITLE: Introductory Examples for ODS Graphics              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods                                       */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES: This sample provides DATA step and PROC code        */
/*   from the chapter "Statistical Graphics Using ODS." It      */
/*   does not provide all of the ODS statements and style       */
/*   changes that are in the example.  Rather, this sample      */
/*   provides code that can be run in one large batch to make   */
/*   all of the graphs in the example.  In practice, you would  */
/*   not want to repeatedly open and close destinations as is   */
/*   done in the chapter.  Note that you should not specify     */
/*   destination style changes without first closing a          */
/*   destination.  Changing the style of the output without     */
/*   first closing the destination will not work as you might   */
/*   expect.  Do not do the following:                          */
/*                                                              */
/*      ODS HTML STYLE=STATISTICAL;                             */
/*      . . . code . . .                                        */
/*      ODS HTML STYLE=DEFAULT;                                 */
/*      . . . code . . .                                        */
/*      ODS HTML STYLE=ANALYSIS;                                */
/*      . . . code . . .                                        */
/*                                                              */
/*   Instead, do the following:                                 */
/*                                                              */
/*      ODS HTML STYLE=STATISTICAL FILE='file1.htm';            */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=DEFAULT     FILE='file2.htm';            */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=ANALYSIS    FILE='file3.htm';            */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*                                                              */
/*   Note that some steps are commented out in this sample      */
/*   because they create large volumes of output.  To run       */
/*   those steps, remove the comments.                          */
/****************************************************************/

ods graphics on;

proc reg data=sashelp.class;
   model Weight = Height;
quit;

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group / test=logrank;
run;

data bivnormal;
   do i = 1 to 1000;
      z1 = rannor(104);
      z2 = rannor(104);
      z3 = rannor(104);
      x  = 3*z1+z2;
      y  = 3*z1+z3;
      output;
   end;
run;

proc kde data=bivnormal;
   bivar x y / plots=contour surface;
run;

data thick;
   set sashelp.thick;
   if _n_ in (41, 42, 73) then thick = .;
run;

proc krige2d data=thick outest=predictions
             plots=(observ(showmissing)
                    pred(fill=pred line=pred obs=linegrad)
                    pred(fill=se line=se obs=linegrad));
   coordinates xc=East yc=North;
   predict var=Thick r=60;
   model scale=7.2881 range=30.6239 form=gauss;
   grid x=0 to 100 by 2.5 y=0 to 100 by 2.5;
run;

data Sample;
   input obsnam $ v1-v27 ls ha dt @@;
   datalines;
EM1   2766 2610 3306 3630 3600 3438 3213 3051 2907 2844 2796
      2787 2760 2754 2670 2520 2310 2100 1917 1755 1602 1467
      1353 1260 1167 1101 1017         3.0110  0.0000   0.00
EM2   1492 1419 1369 1158  958  887  905  929  920  887  800
       710  617  535  451  368  296  241  190  157  128  106
        89   70   65   56   50         0.0000  0.4005   0.00
EM3   2450 2379 2400 2055 1689 1355 1109  908  750  673  644
       640  630  618  571  512  440  368  305  247  196  156
       120   98   80   61   50         0.0000  0.0000  90.63
EM4   2751 2883 3492 3570 3282 2937 2634 2370 2187 2070 2007
      1974 1950 1890 1824 1680 1527 1350 1206 1080  984  888
       810  732  669  630  582         1.4820  0.1580  40.00
EM5   2652 2691 3225 3285 3033 2784 2520 2340 2235 2148 2094
      2049 2007 1917 1800 1650 1464 1299 1140 1020  909  810
       726  657  594  549  507         1.1160  0.4104  30.45
EM6   3993 4722 6147 6720 6531 5970 5382 4842 4470 4200 4077
      4008 3948 3864 3663 3390 3090 2787 2481 2241 2028 1830
      1680 1533 1440 1314 1227         3.3970  0.3032  50.82
EM7   4032 4350 5430 5763 5490 4974 4452 3990 3690 3474 3357
      3300 3213 3147 3000 2772 2490 2220 1980 1779 1599 1440
      1320 1200 1119 1032  957         2.4280  0.2981  70.59
EM8   4530 5190 6910 7580 7510 6930 6150 5490 4990 4670 4490
      4370 4300 4210 4000 3770 3420 3060 2760 2490 2230 2060
      1860 1700 1590 1490 1380         4.0240  0.1153  89.39
EM9   4077 4410 5460 5857 5607 5097 4605 4170 3864 3708 3588
      3537 3480 3330 3192 2910 2610 2325 2064 1830 1638 1476
      1350 1236 1122 1044  963         2.2750  0.5040  81.75
EM10  3450 3432 3969 4020 3678 3237 2814 2487 2205 2061 2001
      1965 1947 1890 1776 1635 1452 1278 1128  981  867  753
       663  600  552  507  468         0.9588  0.1450 101.10
EM11  4989 5301 6807 7425 7155 6525 5784 5166 4695 4380 4197
      4131 4077 3972 3777 3531 3168 2835 2517 2244 2004 1809
      1620 1470 1359 1266 1167         3.1900  0.2530 120.00
EM12  5340 5790 7590 8390 8310 7670 6890 6190 5700 5380 5200
      5110 5040 4900 4700 4390 3970 3540 3170 2810 2490 2240
      2060 1870 1700 1590 1470         4.1320  0.5691 117.70
EM13  3162 3477 4365 4650 4470 4107 3717 3432 3228 3093 3009
      2964 2916 2838 2694 2490 2253 2013 1788 1599 1431 1305
      1194 1077  990  927  855         2.1600  0.4360  27.59
EM14  4380 4695 6018 6510 6342 5760 5151 4596 4200 3948 3807
      3720 3672 3567 3438 3171 2880 2571 2280 2046 1857 1680
      1548 1413 1314 1200 1119         3.0940  0.2471  61.71
EM15  4587 4200 5040 5289 4965 4449 3939 3507 3174 2970 2850
      2814 2748 2670 2529 2328 2088 1851 1641 1431 1284 1134
      1020  918  840  756  714         1.6040  0.2856 108.80
EM16  4017 4725 6090 6570 6354 5895 5346 4911 4611 4422 4314
      4287 4224 4110 3915 3600 3240 2913 2598 2325 2088 1917
      1734 1587 1452 1356 1257         3.1620  0.7012  60.00
;

proc pls data=sample cv=split cvtest(seed=104);
   model ls ha dt = v1-v27;
run;

proc format;
   value a -1 =   8 0 =   9 1 =  10;
   value l -1 = 250 0 = 300 1 = 350;
   value o -1 =  40 0 =  45 1 =  50;
run;

data yarn;
   input Fail Amplitude Length Load @@;
   format amplitude a. length l. load o.;
   label fail = 'Time in Cycles until Failure';
   datalines;
 674 -1 -1 -1    370 -1 -1  0    292 -1 -1  1    338  0 -1 -1
 266  0 -1  0    210  0 -1  1    170  1 -1 -1    118  1 -1  0
  90  1 -1  1   1414 -1  0 -1   1198 -1  0  0    634 -1  0  1
1022  0  0 -1    620  0  0  0    438  0  0  1    442  1  0 -1
 332  1  0  0    220  1  0  1   3636 -1  1 -1   3184 -1  1  0
2000 -1  1  1   1568  0  1 -1   1070  0  1  0    566  0  1  1
1140  1  1 -1    884  1  1  0    360  1  1  1
;

proc transreg data=yarn;
   model BoxCox(fail / convenient lambda=-2 to 2 by 0.05) =
         qpoint(length amplitude load);
run;

data plants;
   input Type $ @;
   do Block = 1 to 3;
      input StemLength @@;
      output;
   end;
   datalines;
Clarion   32.7 32.3 31.5   Clinton   32.1 29.7 29.1   Knox      35.7 35.9 33.1
ONeill    36.0 34.2 31.2   Compost   31.8 28.0 29.2   Wabash    38.2 37.8 31.9
Webster   32.5 31.1 29.7
;

proc glimmix data=plants order=data plots=diffogram;
   class Block Type;
   model StemLength = Block Type;
   lsmeans Type;
run;

options validvarname=any;

data Jobratings;
   input ('Communication Skills'n
          'Problem Solving'n
          'Learning Ability'n
          'Judgment Under Pressure'n
          'Observational Skills'n
          'Willingness to Confront Problems'n
          'Interest in People'n
          'Interpersonal Sensitivity'n
          'Desire for Self-Improvement'n
          'Appearance'n
          'Dependability'n
          'Physical Ability'n
          'Integrity'n
          'Overall Rating'n) (1.);
   datalines;
26838853879867
74758876857667
56757863775875
67869777988997
99997798878888
89897899888799
89999889899798
87794798468886
35652335143113
89888879576867
76557899446397
97889998898989
76766677598888
77667676779677
63839932588856
25738811284915
88879966797988
87979877959679
87989975878798
99889988898888
78876765687677
88889888899899
88889988878988
67646577384776
78778788799997
76888866768667
67678665746776
33424476664855
65656765785766
54566676565866
56655566656775
88889988868887
89899999898799
98889999899899
57554776468878
53687777797887
68666716475767
78778889798997
67364767565846
77678865886767
68698955669998
55546866663886
68888999998989
97787888798999
76677899799997
44754687877787
77876678798888
76668778799797
57653634361543
76777745653656
76766665656676
88888888878789
88977888869778
58894888747886
58674565473676
76777767777777
77788878789798
98989987999868
66729911474713
98889976999988
88786856667748
77868887897889
99999986999999
46688587616886
66755778486776
87777788889797
65666656545976
73574488887687
74755556586596
76677778789797
87878746777667
86776955874877
77888767778678
65778787778997
58786887787987
65787766676778
86777875468777
67788877757777
77778967855867
67887876767777
24786585535866
46532343542533
35566766676784
11231214211211
76886588536887
57784788688589
56667766465666
66787778778898
77687998877997
76668888546676
66477987589998
86788976884597
77868765785477
99988888987888
65948933886457
99999877988898
96636736876587
98676887798968
87878877898979
88897888888788
99997899799799
99899899899899
76656399567486
;

proc princomp data=Jobratings(drop='Overall Rating'n) n=2
              plots=(Matrix PatternProfile);
run;

options validvarname=v7;

proc sgplot data=sashelp.iris;
   title 'Fisher (1936) Iris Data';
   scatter x=petallength y=petalwidth / group=species;
run;

ods graphics on / attrpriority=none;

proc sgplot data=sashelp.iris;
   title 'Fisher (1936) Iris Data';
   styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=petallength y=petalwidth / group=species markerattrs=(size=5px);
run;

ods graphics / reset;

/*
ods graphics on;
ods trace on;

proc kde data=bivnormal;
   bivar x y / plots=contour surface;
run;

ods trace off;

ods trace on / label;

proc kde data=bivnormal;
   bivar x y / plots=contour surface;
run;

ods trace off;

proc kde data=bivnormal;
   ods select ContourPlot SurfacePlot;
   bivar x y / plots=contour surface;
run;

proc kde data=bivnormal;
   ods exclude Inputs Controls;
   bivar x y / plots=contour surface;
run;
*/

proc reg data=sashelp.class plots(unpack);
   ods select where = (_path_ ? 'DiagnosticPlots');
   model Weight = Height;
quit;

/*
proc kde data=bivnormal;
   ods select ContourPlot SurfacePlot;
   bivar x y / plots=contour surface;
run;
*/

data growth;
   length Country $ 20;
   input country &$ GDP LFG EQP NEQ GAP;
   datalines;
Argentina             0.0089 0.0118 0.0214 0.2286 0.6079
Austria               0.0332 0.0014 0.0991 0.1349 0.5809
Belgium               0.0256 0.0061 0.0684 0.1653 0.4109
Bolivia               0.0124 0.0209 0.0167 0.1133 0.8634
Botswana              0.0676 0.0239 0.1310 0.1490 0.9474
Brazil                0.0437 0.0306 0.0646 0.1588 0.8498
Cameroon              0.0458 0.0169 0.0415 0.0885 0.9333
Canada                0.0169 0.0261 0.0771 0.1529 0.1783
Chile                 0.0021 0.0216 0.0154 0.2846 0.5402
Colombia              0.0239 0.0266 0.0229 0.1553 0.7695
Costa Rica            0.0121 0.0354 0.0433 0.1067 0.7043
Denmark               0.0187 0.0115 0.0688 0.1834 0.4079
Dominican Republic    0.0199 0.0280 0.0321 0.1379 0.8293
Ecuador               0.0283 0.0274 0.0303 0.2097 0.8205
El Salvador           0.0046 0.0316 0.0223 0.0577 0.8414
Ethiopia              0.0094 0.0206 0.0212 0.0288 0.9805
Finland               0.0301 0.0083 0.1206 0.2494 0.5589
France                0.0292 0.0089 0.0879 0.1767 0.4708
Germany               0.0259 0.0047 0.0890 0.1885 0.4585
Greece                0.0446 0.0044 0.0655 0.2245 0.7924
Guatemala             0.0149 0.0242 0.0384 0.0516 0.7885
Honduras              0.0148 0.0303 0.0446 0.0954 0.8850
Hong Kong             0.0484 0.0359 0.0767 0.1233 0.7471
India                 0.0115 0.0170 0.0278 0.1448 0.9356
Indonesia             0.0345 0.0213 0.0221 0.1179 0.9243
Ireland               0.0288 0.0081 0.0814 0.1879 0.6457
Israel                0.0452 0.0305 0.1112 0.1788 0.6816
Italy                 0.0362 0.0038 0.0683 0.1790 0.5441
Ivory Coast           0.0278 0.0274 0.0243 0.0957 0.9207
Jamaica               0.0055 0.0201 0.0609 0.1455 0.8229
Japan                 0.0535 0.0117 0.1223 0.2464 0.7484
Kenya                 0.0146 0.0346 0.0462 0.1268 0.9415
Korea                 0.0479 0.0282 0.0557 0.1842 0.8807
Luxembourg            0.0236 0.0064 0.0711 0.1944 0.2863
Madagascar           -0.0102 0.0203 0.0219 0.0481 0.9217
Malawi                0.0153 0.0226 0.0361 0.0935 0.9628
Malaysia              0.0332 0.0316 0.0446 0.1878 0.7853
Mali                  0.0044 0.0184 0.0433 0.0267 0.9478
Mexico                0.0198 0.0349 0.0273 0.1687 0.5921
Morocco               0.0243 0.0281 0.0260 0.0540 0.8405
Netherlands           0.0231 0.0146 0.0778 0.1781 0.3605
Nigeria              -0.0047 0.0283 0.0358 0.0842 0.8579
Norway                0.0260 0.0150 0.0701 0.2199 0.3755
Pakistan              0.0295 0.0258 0.0263 0.0880 0.9180
Panama                0.0295 0.0279 0.0388 0.2212 0.8015
Paraguay              0.0261 0.0299 0.0189 0.1011 0.8458
Peru                  0.0107 0.0271 0.0267 0.0933 0.7406
Philippines           0.0179 0.0253 0.0445 0.0974 0.8747
Portugal              0.0318 0.0118 0.0729 0.1571 0.8033
Senegal              -0.0011 0.0274 0.0193 0.0807 0.8884
Spain                 0.0373 0.0069 0.0397 0.1305 0.6613
Sri Lanka             0.0137 0.0207 0.0138 0.1352 0.8555
Tanzania              0.0184 0.0276 0.0860 0.0940 0.9762
Thailand              0.0341 0.0278 0.0395 0.1412 0.9174
Tunisia               0.0279 0.0256 0.0428 0.0972 0.7838
UK                    0.0189 0.0048 0.0694 0.1132 0.4307
US                    0.0133 0.0189 0.0762 0.1356 0.0000
Uruguay               0.0041 0.0052 0.0155 0.1154 0.5782
Venezuel              0.0120 0.0378 0.0340 0.0760 0.4974
Zambia               -0.0110 0.0275 0.0702 0.2012 0.8695
Zimbabwe              0.0110 0.0309 0.0843 0.1257 0.8875
;

/*
ods graphics on;
ods html sge=on;

proc robustreg data=growth plots=(ddplot histogram);
   model GDP  = LFG GAP EQP NEQ / diagnostics leverage;
   output out=robout r=resid sr=stdres;
run;

ods _all_ close;
ods html;
*/

/*
ods path sashelp.tmplmst(read);
proc datasets library=sasuser nolist;
   delete templat(memtype=itemstor);
run;
ods path sasuser.templat(update) sashelp.tmplmst(read);
*/
