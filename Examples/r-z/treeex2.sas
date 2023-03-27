/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREEEX2                                             */
/*   TITLE: Documentation Example 2 for PROC TREE               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: cluster                                             */
/*   PROCS: CLUSTER, TREE                                       */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC TREE, Example 2                                */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Fisher (1936) Iris Data';
ods graphics on;

proc cluster data=sashelp.iris method=twostage print=10
             outtree=tree k=8 noeigen;
   var SepalLength SepalWidth PetalLength PetalWidth;
   copy Species;
run;

proc tree data=tree horizontal lineprinter pages=1 maxh=10;
   id species;
run;

