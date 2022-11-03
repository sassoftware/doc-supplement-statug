
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX1                                             */
/*   TITLE: Documentation Example 1 for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER ANALYSIS MILEAGE                            */
/*   PROCS: CLUSTER                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CLUSTER, Example 1.                            */
/*    MISC:                                                     */
/****************************************************************/

proc print noobs data=sashelp.mileages;
run;

title 'Cluster Analysis of Flying Mileages Between 10 American Cities';
ods graphics on;

title2 'Using METHOD=AVERAGE';
proc cluster data=sashelp.mileages(type=distance) method=average pseudo;
  id City;
run;

title2 'Using METHOD=CENTROID';
proc cluster data=sashelp.mileages(type=distance) method=centroid pseudo;
   id City;
run;

title2 'Using METHOD=DENSITY K=3';
proc cluster data=sashelp.mileages(type=distance) method=density k=3;
   id City;
run;

title2 'Using METHOD=SINGLE';
proc cluster data=sashelp.mileages(type=distance) method=single;
   id City;
run;

title2 'Using METHOD=TWOSTAGE K=3';
proc cluster data=sashelp.mileages(type=distance) method=twostage k=3;
   id City;
run;

title2 'Using METHOD=WARD';
proc cluster data=sashelp.mileages(type=distance) method=ward pseudo;
   id City;
run;
