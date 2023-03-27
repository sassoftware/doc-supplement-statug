/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATGS1                                              */
/*   TITLE: Getting Started Example 1 for PROC CATMOD           */
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
Getting Started Example: WLS Analysis of Mean Response

From: Stokes, Davis, and Koch (1995, 307-313).
----------------------------------------------------------------*/

title 'WLS Analysis of Mean Response';

data colds;
   input sex $ residence $ periods count @@;
   datalines;
female rural 0  45  female rural 1  64  female rural 2  71
female urban 0  80  female urban 1 104  female urban 2 116
male   rural 0  84  male   rural 1 124  male   rural 2  82
male   urban 0 106  male   urban 1 117  male   urban 2  87
;

proc catmod data=colds;
   weight count;
   response means;
   model periods = sex residence sex*residence / design;
run;

   model periods = sex residence / design;
run;

