/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: IRTEX2                                              */
/*   TITLE: Documentation Example 2 for PROC IRT                */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: IRT                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC IRT, EXAMPLE 2                                 */
/*    MISC:                                                     */
/****************************************************************/

data IrtMulti;
   input item1-item10 @@;
   datalines;
1 0 0 0 1 1 2 1 2 1 1 1 1 1 1 3 3 3 3 3 0 1 0 0 1 1 1 1 1 1 1 0 0 1 0
1 2 3 2 2 0 0 0 0 0 1 1 1 1 1 1 0 0 1 0 1 3 3 1 2 0 0 0 0 0 1 1 3 3 2
0 0 1 0 0 1 2 2 3 2 0 1 0 0 1 1 1 2 2 2 0 0 0 0 0 2 2 3 3 2 0 1 0 1 0
2 3 3 3 3 0 0 1 0 1 1 2 3 2 3 1 1 1 1 1 2 2 3 2 2 0 0 0 0 1 1 2 2 3 1
1 0 1 1 1 2 3 3 2 3 0 1 0 0 1 1 2 3 3 3 1 0 1 1 1 2 3 3 3 3 0 1 0 1 1
3 2 3 3 2 1 1 1 0 0 1 3 3 2 1 1 1 0 0 1 2 3 3 3 3 0 1 1 1 1 1 2 1 2 3
1 0 0 1 1 3 1 1 1 1 1 0 0 0 1 1 1 3 3 1 0 0 0 0 1 1 3 3 3 3 0 0 0 0 0
1 1 1 3 2 1 0 0 0 0 1 3 3 3 3 1 1 0 1 1 3 1 1 3 3 1 0 1 1 1 1 3 1 1 1
1 1 1 1 1 2 3 2 3 3 0 0 1 0 0 2 2 2 1 1 0 0 1 0 1 1 2 3 3 3 1 1 1 1 1
1 1 2 1 2 0 0 0 0 1 3 1 1 1 2 1 1 1 1 1 2 2 3 1 3 0 0 0 0 1 2 2 3 2 3
1 1 1 1 1 3 3 3 1 3 1 1 1 1 1 1 3 3 3 1 0 1 0 0 0 2 2 2 2 3 0 1 0 1 0
2 2 3 2 2 1 0 0 1 1 1 1 2 1 3 1 0 0 0 1 3 1 2 2 1 0 0 0 0 0 1 3 1 3 1
0 1 1 0 0 2 1 3 2 1 0 0 0 0 1 2 2 3 2 2 0 0 0 0 0 1 1 2 2 2 0 0 0 1 1
1 1 1 1 1 0 0 0 0 1 3 1 3 2 2 0 0 0 0 0 2 1 1 2 1 0 0 0 1 1 1 3 2 2 2
0 0 0 0 0 2 1 2 3 2 1 1 1 0 0 1 3 1 2 2 0 0 0 0 1 2 2 2 2 3 0 1 1 1 1
2 2 3 3 2 0 0 1 0 1 2 2 3 2 1 1 0 1 1 1 3 1 1 2 2 0 0 0 0 1 1 3 3 2 3
1 1 1 0 0 1 3 3 2 1 0 0 0 0 0 2 1 1 2 1 0 0 0 1 1 2 3 3 3 2 0 0 0 0 0
1 2 1 2 2 0 0 1 0 1 3 1 1 1 1 0 1 0 0 1 1 2 1 2 1 0 0 1 0 0 3 1 3 2 3
0 0 0 0 0 1 1 1 3 1 1 0 0 1 0 1 1 1 1 1 0 0 1 1 1 2 1 2 3 3 0 0 0 0 0
3 2 2 3 2 0 0 0 0 1 2 2 2 2 2 0 0 1 1 1 2 2 3 3 3 0 0 1 0 0 2 2 3 3 2
0 1 1 0 1 2 3 1 2 3 1 0 1 1 1 2 2 2 2 1 1 1 0 1 1 1 1 1 3 3 1 1 0 1 1
2 3 1 3 3 0 0 0 0 1 3 1 2 1 1 0 0 0 0 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1
0 0 0 0 1 3 1 3 1 1 1 1 1 0 1 1 1 2 2 2 0 0 0 1 0 1 1 1 3 1 0 0 0 1 1
1 1 2 1 1 1 0 1 1 1 1 3 1 1 2 1 1 1 1 0 3 3 3 3 3 1 1 0 1 0 3 1 3 1 1
0 0 0 0 0 1 2 2 1 1 0 0 1 0 1 2 2 2 3 1 0 1 1 1 0 2 2 3 2 2 0 0 0 0 1
3 1 3 3 1 1 1 1 1 1 3 2 2 2 3 1 0 1 1 1 1 1 3 3 3 0 0 1 0 1 2 1 2 1 2
0 0 1 1 1 2 1 2 3 2 1 1 1 1 1 3 2 3 3 3 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1
1 2 2 2 3 1 0 1 0 1 1 3 3 3 3 0 0 0 0 0 2 1 1 1 1 1 0 1 0 1 1 1 3 2 3
0 0 0 0 0 3 1 1 2 1 0 1 1 0 0 1 2 2 3 1 1 0 1 1 1 3 3 3 2 2 1 1 0 1 0
1 2 2 2 2 1 0 0 0 0 1 1 1 2 1 0 0 0 0 0 3 2 2 2 1 0 0 0 1 1 3 3 3 2 3
0 0 0 0 1 2 2 2 3 2 0 0 0 0 1 2 2 2 2 2 0 0 0 0 0 2 1 2 2 2 0 0 1 1 1
3 3 3 3 3 1 1 1 0 1 1 2 2 1 1 0 0 0 0 1 2 3 3 3 2 0 0 1 0 1 2 3 3 2 2
1 1 1 0 1 2 3 3 2 3 1 0 0 0 1 1 3 2 3 3 1 0 0 0 1 2 2 1 2 2 0 1 0 1 0
1 3 1 3 3 0 0 0 0 0 1 1 1 1 1 0 1 0 0 0 3 2 1 2 3 0 0 0 1 0 2 1 1 2 1
1 1 0 0 1 3 3 1 1 1 1 1 1 1 1 3 2 1 1 2 1 0 1 0 1 3 2 3 2 3 1 1 1 0 1
2 2 2 2 2 1 1 0 1 1 2 3 3 2 3 0 0 0 1 0 1 1 1 1 3 1 0 1 1 1 2 3 3 3 3
0 0 0 1 1 2 3 1 1 1 1 1 0 1 1 3 1 2 2 2 0 0 0 1 1 1 2 1 2 3 1 1 1 0 1
1 1 2 1 2 1 1 1 1 1 2 3 3 1 3 0 0 1 1 0 2 2 1 1 1 1 0 0 0 1 3 1 2 2 2
0 1 1 1 1 1 2 1 2 3 0 0 0 0 1 3 3 2 3 2 0 0 0 1 0 1 1 1 1 1 0 0 0 0 0
1 3 3 2 1 0 0 0 1 1 1 1 2 2 2 0 1 0 0 1 3 1 1 2 1 0 0 1 0 0 1 2 2 2 2
0 0 0 0 1 2 2 2 2 3 1 0 1 1 0 3 2 1 3 1 0 0 0 0 1 3 2 3 2 1 0 1 1 1 0
2 2 3 3 2 1 0 0 1 0 3 2 3 2 3 0 1 0 0 1 2 2 3 1 2 0 0 0 0 0 2 1 1 1 1
0 0 0 0 1 3 2 2 1 3 0 0 0 1 1 1 3 1 1 3 0 0 0 1 1 2 1 1 1 1 1 1 1 1 1
3 3 2 2 2 0 0 1 1 1 1 2 2 2 3 0 1 1 0 0 1 3 1 3 3 1 0 0 1 1 2 3 3 2 3
1 1 1 1 1 3 2 3 2 3 1 0 1 0 1 1 3 3 2 3 1 1 1 1 0 3 2 3 1 1 0 1 1 0 1
1 2 3 2 3 1 1 1 0 1 1 3 2 2 2 0 0 0 1 0 1 2 1 1 1 0 0 0 0 0 1 1 1 2 2
1 1 1 1 1 2 3 3 3 2 1 1 1 0 1 2 3 3 2 1 1 1 1 1 1 2 2 3 2 3 0 0 0 0 1
2 2 2 2 3 0 0 0 0 1 2 2 2 2 2 0 0 1 0 1 2 1 2 3 3 1 1 0 1 1 3 2 3 3 1
0 0 1 0 0 1 2 3 2 1 0 0 1 0 0 1 2 2 2 1 1 0 0 0 0 1 2 2 1 2 1 0 0 1 0
2 2 2 3 2 0 0 1 1 1 2 1 3 2 2 0 0 0 0 0 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1
0 0 0 1 1 1 3 3 2 2 0 0 0 0 0 1 2 3 3 2 0 0 0 0 0 2 2 2 3 3 1 0 1 0 1
3 1 3 3 2 0 1 1 0 1 1 3 2 3 2 0 0 0 1 1 2 1 2 2 1 0 0 0 0 0 3 1 1 2 1
0 0 0 0 1 1 1 1 2 1 0 1 1 1 0 1 3 3 3 2 1 0 0 1 1 3 3 3 3 3 0 0 0 0 0
1 1 2 3 3 1 0 1 1 1 2 3 3 1 3 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 3 3 3 3 3
1 0 0 0 1 3 1 3 3 1 0 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 2 2 1 3 0 0 0 0 0
2 1 1 2 2 0 0 0 1 0 2 2 3 3 3 1 0 0 0 0 2 2 2 2 2 0 0 0 1 1 1 1 3 2 2
0 1 1 0 0 3 2 3 2 3 0 0 0 0 1 2 2 2 2 2 1 1 1 1 1 2 2 3 3 3 0 0 0 1 1
1 3 3 1 1 1 0 1 0 1 3 2 3 1 2 0 0 0 0 0 2 2 2 2 2 1 0 0 1 1 1 2 3 3 3
0 0 0 0 1 2 2 2 1 2 1 1 0 1 0 3 3 1 3 1 0 0 0 0 1 3 3 2 1 3 1 0 0 0 0
2 2 2 2 2 0 0 1 0 1 1 3 2 1 1 1 0 1 0 1 1 3 3 2 1 0 1 0 0 1 1 2 1 2 2
0 0 0 0 1 2 2 2 1 1 1 1 1 0 1 2 3 3 2 3 1 1 1 1 1 1 2 3 3 2 0 0 0 0 0
1 2 2 1 2 0 1 0 0 1 3 3 3 3 3 1 1 1 1 1 3 1 3 2 3 1 1 1 1 0 1 2 3 3 1
0 0 0 0 1 1 2 3 2 2 1 0 0 1 1 3 3 3 2 3 0 1 1 1 0 3 2 3 3 1 0 0 0 0 1
1 3 3 3 3 0 0 0 0 0 1 1 3 2 3 0 0 0 1 0 1 1 2 1 3 1 1 1 1 0 2 3 3 3 2
1 1 1 1 1 2 2 2 2 2 1 1 1 0 1 2 3 3 3 3 0 1 0 0 0 3 3 2 1 2 0 0 0 0 0
1 1 1 1 1 1 1 1 1 1 2 3 3 3 2 1 1 1 1 0 1 3 2 3 2 0 0 0 1 1 1 1 3 1 1
0 0 1 0 0 1 1 1 3 2 1 0 1 1 0 1 1 3 3 3 0 0 0 0 0 2 2 2 2 2 1 1 0 0 1
1 3 3 1 3 1 1 0 0 1 2 3 3 3 1 1 1 0 1 1 1 3 1 3 2 0 0 1 1 0 2 1 2 3 1
1 1 1 1 1 1 2 3 3 3 0 0 0 0 1 1 1 1 1 2 1 1 0 0 1 3 3 3 1 2 1 1 1 1 1
3 3 1 2 3 0 1 0 0 1 1 2 2 2 2 0 0 0 0 1 1 1 1 1 1 1 0 0 0 1 2 3 2 3 2
1 0 1 0 1 2 3 3 3 3 0 0 0 0 0 3 1 1 1 1 1 0 1 1 1 1 1 1 2 2 1 1 1 1 1
3 3 1 1 1 0 1 1 0 1 1 2 3 2 2 0 0 0 0 0 3 1 2 2 2 1 0 0 0 0 1 1 1 1 2
1 0 0 1 0 2 1 1 3 1 0 0 0 0 0 1 1 1 2 2 0 0 1 1 1 2 2 3 2 2 0 0 1 0 0
1 2 3 2 1 0 0 0 0 1 2 2 1 1 1 1 1 1 1 1 3 3 3 1 1 0 1 0 0 0 3 2 3 2 2
1 1 0 0 1 3 3 3 3 3 1 1 1 0 1 2 3 3 3 3 0 1 1 0 0 2 3 3 3 1 1 0 1 0 1
1 2 3 1 1 1 0 0 0 0 2 3 2 2 3 0 0 0 0 1 3 2 3 2 2 1 1 1 1 0 3 3 3 2 3
0 0 0 1 1 2 3 3 3 3 0 0 0 1 0 2 3 2 2 1 1 1 0 0 1 3 3 1 3 1 0 1 0 0 1
2 1 2 2 2 1 1 1 0 1 2 2 2 3 1 1 0 0 0 1 2 2 2 2 2 1 1 1 1 1 3 3 3 3 3
0 1 1 0 1 2 2 2 3 2 1 1 1 1 1 3 3 3 3 3 1 1 1 1 1 3 3 2 3 3 1 0 0 0 1
3 3 2 3 1 0 0 0 0 0 1 1 1 1 3 0 0 0 0 0 2 2 1 2 3 0 0 0 0 1 1 3 3 2 1
0 0 0 1 1 1 3 1 3 1 0 0 1 0 1 1 2 3 3 3 1 1 1 1 0 1 2 1 2 1 0 1 0 1 0
1 1 1 1 1 0 0 1 1 1 1 3 3 2 2 1 1 1 1 1 3 1 2 3 2 1 1 1 0 0 1 3 3 2 2
0 0 1 1 1 1 2 2 3 3 1 1 1 1 1 2 3 3 3 2 1 1 1 1 1 1 1 2 1 3 0 0 0 1 1
1 3 2 1 2 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 2 2 3 2 2 1 1 1 0 1 2 3 3 3 3
0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 1 2 3 0 0 0 1 0 1 2 3 1 3 0 0 0 0 0
1 2 3 3 2 0 0 1 1 1 1 2 3 3 1 1 1 1 1 1 2 3 3 3 2 0 0 0 0 1 3 3 2 3 3
0 0 0 0 1 2 2 2 2 1 0 0 0 0 1 2 3 2 2 2 1 0 1 1 1 2 3 2 3 3 0 0 0 0 1
1 3 1 1 2 0 0 0 1 0 2 1 2 1 1 0 0 1 0 0 1 2 2 1 3 1 0 0 1 1 1 3 2 3 3
1 0 0 0 1 3 1 3 3 3 0 1 1 1 1 3 3 2 3 2 1 1 1 0 0 2 2 2 1 1 0 0 0 1 1
2 2 3 3 3 1 1 0 1 1 2 3 2 3 2 1 1 1 1 1 2 3 3 3 3 0 0 0 0 0 3 1 1 2 1
1 1 0 0 1 1 3 3 2 3 0 0 0 1 1 2 2 3 3 3 0 0 0 1 0 1 3 3 1 1 1 0 1 1 0
2 3 3 1 3 1 0 0 1 1 3 3 3 1 3 0 1 1 0 1 1 1 2 2 2 0 0 0 0 0 2 3 2 3 2
0 1 0 0 0 2 3 2 3 2 0 0 0 0 1 1 3 3 2 2 1 0 1 1 1 1 3 3 1 3 0 1 0 1 1
3 3 3 3 1 0 0 0 0 0 1 1 1 1 2 0 0 0 1 0 1 1 1 1 1 0 1 1 0 1 3 2 3 3 3
0 0 0 0 1 3 3 3 1 2 0 0 1 0 1 2 3 3 3 2 1 1 1 0 0 1 1 2 2 2 0 0 1 0 0
2 1 1 1 2 0 0 0 0 0 1 1 2 1 1 0 0 1 0 0 2 2 1 2 1 0 0 0 1 1 1 3 2 2 1
0 0 0 1 1 1 2 1 2 3 0 0 1 0 1 2 3 2 2 2 0 1 0 1 1 1 3 3 3 2 0 0 0 0 1
2 2 2 2 3 1 1 1 0 1 1 2 3 2 2 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 1 1 1 2 1
1 0 0 1 1 3 1 2 1 3 0 0 0 0 0 1 1 2 2 3 1 0 0 1 0 3 2 2 2 1 0 0 1 0 1
3 2 3 3 2 1 0 0 1 0 1 1 1 2 1 0 0 1 0 1 1 1 1 3 1 0 0 1 0 0 1 2 2 2 2
1 1 1 0 1 3 1 1 1 1 0 0 0 0 0 3 1 3 1 3 1 0 0 0 1 3 1 2 2 3 1 0 0 0 1
3 1 3 1 1 0 0 0 0 1 1 1 2 1 2 0 0 0 1 1 1 3 3 2 2 1 1 1 0 1 2 3 3 3 3
0 0 1 0 0 2 2 2 2 1 0 1 0 0 1 1 3 2 2 1 0 0 0 1 1 1 1 1 1 3 1 1 0 1 0
2 3 3 3 3 0 0 0 1 1 1 2 1 1 3 0 0 0 0 1 1 3 3 3 2 1 0 1 0 1 1 3 1 1 1
0 0 0 0 1 1 1 3 3 1 1 1 1 1 1 2 3 3 2 1 1 0 0 0 0 1 3 2 2 2 1 0 1 0 1
1 1 3 3 2 0 0 0 1 0 2 2 3 3 2 1 1 0 0 1 1 3 3 2 2 0 0 0 0 1 1 3 2 1 3
1 0 0 0 0 1 1 3 1 3 1 1 0 1 0 3 1 2 2 3 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0
3 2 2 2 3 0 0 0 1 1 3 3 2 2 2 1 0 1 1 1 3 1 3 2 1 1 0 0 1 1 1 3 3 2 1
1 1 0 0 1 2 3 3 3 3 1 1 1 0 1 2 2 3 2 1 0 0 1 0 1 1 1 2 1 1 0 0 0 0 0
3 1 1 1 1 1 1 1 1 1 3 3 3 3 3 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 2 2 1
0 0 0 0 0 2 1 2 1 1 1 0 0 0 0 1 1 1 3 3 1 1 1 0 1 2 2 3 2 3 1 0 0 0 1
3 3 2 3 1 0 0 0 0 1 1 2 2 1 2 0 0 0 1 1 1 3 1 2 1 0 1 0 0 1 1 1 2 2 2
0 0 0 0 0 2 2 2 2 1 1 0 0 0 1 2 2 2 2 2 1 0 0 1 1 3 3 2 2 3 0 0 0 0 1
2 1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 1 1 3 3 2 2 3 1 0 0 1 1 3 1 1 3 2
0 0 0 0 1 3 1 1 1 1 1 1 1 1 1 3 3 3 3 3 0 0 0 1 1 2 3 2 2 3 0 0 0 0 0
2 1 1 1 1 1 0 0 0 1 1 3 3 2 2 1 1 1 0 1 2 3 2 3 3 1 1 1 0 0 1 1 3 2 2
1 1 1 0 1 3 2 3 3 3 1 0 1 1 1 2 1 1 1 2 1 0 0 1 1 3 2 3 1 3 0 0 0 1 1
2 3 2 1 2 1 1 0 1 1 1 3 3 3 3 0 0 0 0 0 1 3 3 1 2 0 0 0 0 0 1 1 1 2 2
0 1 1 0 0 2 2 3 3 3 0 1 0 1 1 3 3 3 3 3 1 0 1 1 0 3 3 2 3 2 1 1 0 0 1
3 1 3 3 3 0 1 0 1 0 3 2 2 3 2 0 1 1 0 1 2 2 2 1 1 0 0 0 0 0 1 1 1 1 1
0 0 0 0 0 3 1 1 1 1 1 0 0 1 0 2 3 3 2 2 0 0 0 0 0 1 2 3 3 3 1 1 1 1 1
1 2 3 3 3 0 1 0 0 0 2 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 1 3 1 1 2 3
1 1 1 1 1 3 3 3 3 3 1 1 0 1 1 1 3 3 3 3 1 1 1 0 0 2 2 2 1 3 1 0 1 1 1
1 2 3 3 2 1 1 1 1 1 3 3 3 3 3 1 0 0 0 0 3 3 3 2 1 1 1 0 0 1 1 3 3 3 2
0 1 0 0 0 2 2 1 1 1 0 1 1 0 0 3 2 3 3 1 1 0 0 0 0 2 1 3 2 3 0 0 0 0 0
1 1 1 1 1 0 0 0 0 0 1 2 1 1 2 1 1 0 1 1 3 3 3 2 3 0 0 0 1 1 3 2 3 2 3
0 0 0 1 0 2 3 2 3 2 0 0 0 0 0 1 1 2 2 1 1 0 1 1 0 3 2 2 3 3 0 1 0 0 1
2 3 3 3 3 0 0 0 0 0 2 3 3 1 1 0 1 0 0 0 1 2 3 3 3 1 1 0 1 0 2 3 3 2 2
1 1 1 0 1 3 3 3 3 3 0 0 0 0 1 1 1 1 2 1 1 1 1 0 1 1 1 2 2 2 1 0 0 1 1
2 3 3 3 3 0 0 1 1 1 1 3 1 1 3 0 0 1 1 1 3 3 3 3 3 0 0 1 0 1 2 2 2 2 2
0 0 0 0 1 3 1 3 3 3 0 0 1 0 1 3 2 2 3 2 0 0 1 1 1 2 3 3 2 3 0 0 0 0 1
3 3 3 3 2 1 0 0 0 1 1 1 3 1 3 0 0 0 1 1 1 3 3 2 2 1 1 1 1 0 3 1 3 2 2
1 1 1 1 0 2 1 3 2 3 1 0 0 0 0 2 1 2 2 3 0 0 0 0 1 1 3 1 1 1 0 0 1 0 0
3 2 1 1 2 0 0 0 0 1 1 3 3 3 3 0 0 0 0 1 2 2 2 3 3 1 0 0 0 0 1 1 3 3 2
1 0 1 1 1 2 2 3 2 2 1 0 1 1 1 2 3 3 3 3 0 0 1 0 1 2 2 3 2 2 1 0 0 0 1
1 1 2 2 2 0 0 0 0 1 1 2 2 2 2 1 1 1 0 1 2 2 3 2 2 0 0 0 1 0 2 2 1 1 1
1 0 1 0 1 3 2 3 3 2 1 1 0 1 0 2 3 2 1 3 1 0 0 1 1 2 2 3 3 3 1 0 1 0 1
3 3 3 3 3 0 0 0 0 1 1 1 2 2 2 0 0 0 0 1 1 2 3 3 3 1 1 1 1 0 2 3 3 3 2
0 1 1 0 1 2 3 2 2 3 0 0 1 0 1 1 1 2 3 2 1 1 1 0 0 2 3 3 3 1 0 1 1 1 1
3 3 1 3 2 0 0 0 1 0 1 3 2 2 1 0 0 0 0 1 1 2 2 2 3 1 0 1 0 1 2 2 3 2 1
1 0 0 1 1 1 2 2 3 1 0 1 0 1 0 1 3 1 1 1 0 1 1 0 1 3 3 3 3 2 1 0 1 0 0
1 2 1 1 1 1 0 1 1 0 1 3 3 1 3 1 1 0 1 0 2 2 2 2 3 1 1 0 1 1 3 2 3 2 2
0 0 0 1 0 2 2 3 1 2 0 0 0 1 0 2 3 3 3 2 0 1 0 0 1 2 2 1 2 1
;

ods graphics on;
proc irt data=IrtMulti nfactor=2 plots=scree;
   var item1-item10;
run;


proc irt data=IrtMulti;
   var item1-item4 item6 item5 item7-item10;
   factor  Factor1->item1-item4 item6,
           Factor2->item5 item7-item10;
run;

