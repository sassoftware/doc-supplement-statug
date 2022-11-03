
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: modecex2                                            */
/*   TITLE: Documentation Example 2 for PROC MODECLUS           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Distance Data, Nonparametric Density Estimation,    */
/*          Cluster Analysis                                    */
/*   PROCS: MODECLUS, TRANSPOSE                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MODECLUS, Example 2                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Modeclus Analysis of 10 American Cities';
title2 'Based on Flying Mileages';

*-----Fill in Upper Triangle of Distance Matrix---------------;
proc transpose data=sashelp.mileages out=tran;
   copy city;
run;

data mileages(type=distance drop=col: _: i);
   merge sashelp.mileages tran;
   array var[10] atlanta--washingtondc;
   array col[10];
   do i = 1 to 10;
      var[i] = sum(var[i], col[i]);
   end;
run;


*-----Clustering with K-Nearest-Neighbor Density Estimates-----;
proc modeclus data=mileages all m=1 k=3;
   id CITY;
run;

*------Clustering with Uniform-Kernel Density Estimates--------;
proc modeclus data=mileages all m=1 r=600 800;
   id CITY;
run;

*------Clustering Neighborhoods Extended to Nearest Neighbor--------;
proc modeclus data=mileages list m=1 ck=2 r=600 800;
   id CITY;
run;
