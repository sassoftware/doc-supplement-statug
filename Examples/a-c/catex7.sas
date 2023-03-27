/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX7                                              */
/*   TITLE: Example 7 for PROC CATMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis                           */
/*   PROCS: CATMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC CATMOD chapter          */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Example 7: Repeated Measures, 4 Response Levels, 1 Population -

          Testing Vision: Right Eye vs. Left
          ----------------------------------
7477 women aged 30-39 were tested for vision in both right and
left eyes. Marginal homogeneity is tested by the main effect
of the repeated measurement factor, SIDE.

From: Grizzle, Starmer and Koch (1969, 493).
----------------------------------------------------------------*/

title 'Vision Symmetry';
data vision;
   input Right Left count @@;
   datalines;
1 1 1520    1 2  266    1 3  124    1 4  66
2 1  234    2 2 1512    2 3  432    2 4  78
3 1  117    3 2  362    3 3 1772    3 4 205
4 1   36    4 2   82    4 3  179    4 4 492
;

proc catmod data=vision;
   weight count;
   response marginals;
   model Right*Left=_response_ / freq design;
   repeated Side 2;
   title2 'Test of Marginal Homogeneity';
quit;

