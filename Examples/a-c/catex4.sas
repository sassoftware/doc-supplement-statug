/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX4                                              */
/*   TITLE: Example 4 for PROC CATMOD                           */
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
Example 4: Log-Linear Model, Three Dependent Variables

                  Bartlett's Data
                  ---------------
Cuttings of two different lengths were planted at one of two
time points, and their survival status was recorded. The
variables are
    v1=survival status (dead or alive)
    v2=time of planting (spring or at_once)
    v3=length of cutting (long or short).

From: Bishop, Fienberg, and Holland (1975, 89)
----------------------------------------------------------------*/

data bartlett;
   input Length Time Status wt @@;
   datalines;
1 1 1 156     1 1 2  84     1 2 1 84     1 2 2 156
2 1 1 107     2 1 2 133     2 2 1 31     2 2 2 209
;

title 'Bartlett''s Data';
proc catmod data=bartlett;
   weight wt;
   model Length*Time*Status=_response_
         / noparm pred=freq;
   loglin Length|Time|Status @ 2;
   title2 'Model with No 3-Variable Interaction';
quit;
