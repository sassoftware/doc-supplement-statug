/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: distanx1                                            */
/*   TITLE: Documentation Example 1 for PROC DISTANCE           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Distance Matrix, Cluster Analysis                   */
/*   PROCS: DISTANCE, CLUSTER, TREE, PRINT, SORT                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC DISTANCE, Example 1                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data divorce;
   length State $ 15;
   input State &$
         Incompatibility Cruelty Desertion Non_Support Alcohol
         Felony Impotence Insanity Separation @@;
   datalines;
Alabama          1 1 1 1 1 1 1 1 1    Alaska           1 1 1 0 1 1 1 1 0
Arizona          1 0 0 0 0 0 0 0 0    Arkansas         0 1 1 1 1 1 1 1 1
California       1 0 0 0 0 0 0 1 0    Colorado         1 0 0 0 0 0 0 0 0
Connecticut      1 1 1 1 1 1 0 1 1    Delaware         1 0 0 0 0 0 0 0 1
Florida          1 0 0 0 0 0 0 1 0    Georgia          1 1 1 0 1 1 1 1 0
Hawaii           1 0 0 0 0 0 0 0 1    Idaho            1 1 1 1 1 1 0 1 1
Illinois         0 1 1 0 1 1 1 0 0    Indiana          1 0 0 0 0 1 1 1 0
Iowa             1 0 0 0 0 0 0 0 0    Kansas           1 1 1 0 1 1 1 1 0
Kentucky         1 0 0 0 0 0 0 0 0    Louisiana        0 0 0 0 0 1 0 0 1
Maine            1 1 1 1 1 0 1 1 0    Maryland         0 1 1 0 0 1 1 1 1
Massachusetts    1 1 1 1 1 1 1 0 1    Michigan         1 0 0 0 0 0 0 0 0
Minnesota        1 0 0 0 0 0 0 0 0    Mississippi      1 1 1 0 1 1 1 1 0
Missouri         1 0 0 0 0 0 0 0 0    Montana          1 0 0 0 0 0 0 0 0
Nebraska         1 0 0 0 0 0 0 0 0    Nevada           1 0 0 0 0 0 0 1 1
New Hampshire    1 1 1 1 1 1 1 0 0    New Jersey       0 1 1 0 1 1 0 1 1
New Mexico       1 1 1 0 0 0 0 0 0    New York         0 1 1 0 0 1 0 0 1
North Carolina   0 0 0 0 0 0 1 1 1    North Dakota     1 1 1 1 1 1 1 1 0
Ohio             1 1 1 0 1 1 1 0 1    Oklahoma         1 1 1 1 1 1 1 1 0
Oregon           1 0 0 0 0 0 0 0 0    Pennsylvania     0 1 1 0 0 1 1 1 0
Rhode Island     1 1 1 1 1 1 1 0 1    South Carolina   0 1 1 0 1 0 0 0 1
South Dakota     0 1 1 1 1 1 0 0 0    Tennessee        1 1 1 1 1 1 1 0 0
Texas            1 1 1 0 0 1 0 1 1    Utah             0 1 1 1 1 1 1 1 0
Vermont          0 1 1 1 0 1 0 1 1    Virginia         0 1 0 0 0 1 0 0 1
Washington       1 0 0 0 0 0 0 0 1    West Virginia    1 1 1 0 1 1 0 1 1
Wisconsin        1 0 0 0 0 0 0 0 1    Wyoming          1 0 0 0 0 0 0 1 1
;

title 'Grounds for Divorce';
proc distance data=divorce method=djaccard absent=0 out=distjacc;
   var anominal(Incompatibility--Separation);
   id state;
run;

proc print data=distjacc(obs=10);
   id state; var alabama--georgia;
   title2 'First 10 States';
run;
title2;

proc cluster data=distjacc method=centroid
             pseudo outtree=tree;
   id state;
   var alabama--wyoming;
run;

proc tree data=tree noprint n=9 out=out;
   id state;
run;

proc sort;
   by state;
run;

data clus;
   merge divorce out;
   by state;
run;

proc sort;
   by cluster;
run;

proc print;
   id state;
   var Incompatibility--Separation;
   by cluster;
run;
