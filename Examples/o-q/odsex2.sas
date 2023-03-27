/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSEX2                                              */
/*   TITLE: Documentation Example 2 for ODS                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Unbalanced Two-way Design';
data twoway;
   input Treatment Block y @@;
   datalines;
1 1 17   1 1 28   1 1 19   1 1 21   1 1 19   1 2 43
1 2 30   1 2 39   1 2 44   1 2 44   1 3 16
2 1 21   2 1 21   2 1 24   2 1 25   2 2 39   2 2 45
2 2 42   2 2 47   2 3 19   2 3 22   2 3 16
3 1 22   3 1 30   3 1 33   3 1 31   3 2 46   3 3 26
3 3 31   3 3 26   3 3 33   3 3 29   3 3 25
;

proc glm data=twoway;
   class Treatment Block;
   model y = Treatment | Block;
   means Treatment;
   lsmeans Treatment;
   ods select ModelANOVA Means;
   ods trace on;
   ods show;
run;

ods show;
quit;
ods show;

