/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREEEX1                                             */
/*   TITLE: Documentation Example 1 for PROC TREE               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: cluster                                             */
/*   PROCS: CLUSTER, TREE                                       */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC TREE, Example 1                                */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data teeth;
   title 'Mammals'' Teeth';
   input mammal & $16. v1-v8 @@;
   label v1='Right Top Incisors'
         v2='Right Bottom Incisors'
         v3='Right Top Canines'
         v4='Right Bottom Canines'
         v5='Right Top Premolars'
         v6='Right Bottom Premolars'
         v7='Right Top Molars'
         v8='Right Bottom Molars';
   datalines;
Brown Bat         2 3 1 1 3 3 3 3   Mole              3 2 1 0 3 3 3 3
Silver Hair Bat   2 3 1 1 2 3 3 3   Pigmy Bat         2 3 1 1 2 2 3 3
House Bat         2 3 1 1 1 2 3 3   Red Bat           1 3 1 1 2 2 3 3
Pika              2 1 0 0 2 2 3 3   Rabbit            2 1 0 0 3 2 3 3
Beaver            1 1 0 0 2 1 3 3   Groundhog         1 1 0 0 2 1 3 3
Gray Squirrel     1 1 0 0 1 1 3 3   House Mouse       1 1 0 0 0 0 3 3
Porcupine         1 1 0 0 1 1 3 3   Wolf              3 3 1 1 4 4 2 3
Bear              3 3 1 1 4 4 2 3   Raccoon           3 3 1 1 4 4 3 2
Marten            3 3 1 1 4 4 1 2   Weasel            3 3 1 1 3 3 1 2
Wolverine         3 3 1 1 4 4 1 2   Badger            3 3 1 1 3 3 1 2
River Otter       3 3 1 1 4 3 1 2   Sea Otter         3 2 1 1 3 3 1 2
Jaguar            3 3 1 1 3 2 1 1   Cougar            3 3 1 1 3 2 1 1
Fur Seal          3 2 1 1 4 4 1 1   Sea Lion          3 2 1 1 4 4 1 1
Grey Seal         3 2 1 1 3 3 2 2   Elephant Seal     2 1 1 1 4 4 1 1
Reindeer          0 4 1 0 3 3 3 3   Elk               0 4 1 0 3 3 3 3
Deer              0 4 0 0 3 3 3 3   Moose             0 4 0 0 3 3 3 3
;

ods graphics on;

proc cluster method=average std pseudo noeigen outtree=tree;
   id mammal;
   var v1-v8;
run;

proc tree horizontal;
   label _name_ = 'Animal';
run;

options ps=40;
proc tree lineprinter;
run;

proc tree sort height=n horizontal;
   label _name_ = 'Animal';
run;

proc tree noprint out=part nclusters=6;
   id mammal;
   copy v1-v8;
run;

proc sort;
   by cluster;
run;

proc print label uniform;
   id mammal;
   var v1-v8;
   format v1-v8 1.;
   by cluster;
run;

