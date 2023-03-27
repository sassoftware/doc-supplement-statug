/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFTEX4                                             */
/*   TITLE: Documentation Example 4 for PROC LIFETEST           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: competing risks, CIF, Gray's Test, ODS Graphics     */
/*   PROCS: LIFETEST                                            */
/*    DATA: Klein and Moeschberger (1997), Survival Analysis:   */
/*          Techniques for Censored and Truncated Data          */
/*     REF: SAS/STAT User's Guide, PROC LIFETEST Chapter        */
/*    MISC:                                                     */
/****************************************************************/

proc format;
   value diseaseLabel 1='ALL' 2='AML-Low Risk' 3='AML-High Risk';
   value genderLabel  0='Female' 1='Male';
run;

data Bmt;
   input Disease Dftime Status Gender@@;
   Dftime= Dftime / 365.25;
   label Dftime='Disease-Free Survival Time (Years)'
         Disease='Disease Group';
   datalines;
1       2081       0       1       1       1602    0       1
1       1496       0       1       1       1462    0       0
1       1433       0       1       1       1377    0       1
1       1330       0       1       1       996     0       1
1       226        0       0       1       1199    0       1
1       1111       0       1       1       530     0       1
1       1182       0       0       1       1167    0       0
1       418        2       1       1       383     1       1
1       276        2       0       1       104     1       1
1       609        1       1       1       172     2       0
1       487        2       1       1       662     1       1
1       194        2       0       1       230     1       0
1       526        2       1       1       122     2       1
1       129        1       0       1       74      1       1
1       122        1       0       1       86      2       1
1       466        2       1       1       192     1       1
1       109        1       1       1       55      1       0
1       1          2       1       1       107     2       1
1       110        1       0       1       332     2       1
2       2569       0       1       2       2506    0       1
2       2409       0       1       2       2218    0       1
2       1857       0       0       2       1829    0       1
2       1562       0       1       2       1470    0       1
2       1363       0       1       2       1030    0       0
2       860        0       0       2       1258    0       0
2       2246       0       0       2       1870    0       0
2       1799       0       1       2       1709    0       0
2       1674       0       1       2       1568    0       1
2       1527       0       0       2       1324    0       1
2       957        0       1       2       932     0       0
2       847        0       1       2       848     0       1
2       1850       0       0       2       1843    0       0
2       1535       0       0       2       1447    0       0
2       1384       0       0       2       414     2       1
2       2204       2       0       2       1063    2       1
2       481        2       1       2       105     2       1
2       641        2       1       2       390     2       1
2       288        2       1       2       421     1       1
2       79         2       0       2       748     1       1
2       486        1       0       2       48      2       0
2       272        1       0       2       1074    2       1
2       381        1       0       2       10      2       1
2       53         2       0       2       80      2       0
2       35         2       0       2       248     1       1
2       704        2       0       2       211     1       1
2       219        1       1       2       606     1       1
3       2640       0       1       3       2430    0       1
3       2252       0       1       3       2140    0       1
3       2133       0       0       3       1238    0       1
3       1631       0       1       3       2024    0       0
3       1345       0       1       3       1136    0       1
3       845        0       0       3       422     1       0
3       162        2       1       3       84      1       0
3       100        1       1       3       2       2       1
3       47         1       1       3       242     1       1
3       456        1       1       3       268     1       0
3       318        2       0       3       32      1       1
3       467        1       0       3       47      1       1
3       390        1       1       3       183     2       0
3       105        2       1       3       115     1       0
3       164        2       0       3       93      1       0
3       120        1       0       3       80      2       1
3       677        2       1       3       64      1       0
3       168        2       0       3       74      2       0
3       16         2       0       3       157     1       0
3       625        1       0       3       48      1       0
3       273        1       1       3       63      2       1
3       76         1       1       3       113     1       0
3       363        2       1
;

ods graphics on;
proc lifetest data=Bmt plots=cif(test) timelist=0.5 1.0 1.5 2.0 4.0 6.0;
   time Dftime*Status(0)/eventcode=1;
   strata Disease / order=internal;
   format Disease diseaseLabel. Gender genderLabel.;
run;

proc lifetest data=bmt plots=cif(test );
   time Dftime*Status(0)/eventcode=1;
   strata Gender/group=Disease order=internal;
   format Disease diseaseLabel. Gender genderLabel.;
run;
ods graphics off;

