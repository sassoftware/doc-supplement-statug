/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX1                                              */
/*   TITLE: Example 1 for PROC CATMOD                           */
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
Example 1: Linear Response Function, r=2 Responses

             Detergent Preference Study
             --------------------------
The data are from a consumer blind trial of detergent
preference. The variables measured in the study were
   softness=softness of laundry water (soft, med, hard)
   prev=previous user of brand m? (yes, no)
   temp=temperature of laundry water (high, low)
   brand=brand preferred (m, x).

From: Ries and Smith (1963).   See also Cox (1970, 38).
----------------------------------------------------------------*/

data detergent;
   input Softness $ Brand $ Previous $ Temperature $ Count @@;
   datalines;
soft X yes high 19   soft X yes low 57
soft X no  high 29   soft X no  low 63
soft M yes high 29   soft M yes low 49
soft M no  high 27   soft M no  low 53
med  X yes high 23   med  X yes low 47
med  X no  high 33   med  X no  low 66
med  M yes high 47   med  M yes low 55
med  M no  high 23   med  M no  low 50
hard X yes high 24   hard X yes low 37
hard X no  high 42   hard X no  low 68
hard M yes high 43   hard M yes low 52
hard M no  high 30   hard M no  low 42
;

title 'Detergent Preference Study';
proc catmod data=detergent;
   response 1 0;
   weight Count;
   model Brand=Softness|Previous|Temperature / freq prob;
   title2 'Saturated Model';
run;

   model Brand=Softness Previous Temperature
       / clparm noprofile design;
   title2 'Main-Effects Model';
run;
quit;
