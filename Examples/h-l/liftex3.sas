/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFTEX3                                             */
/*   TITLE: Documentation Example 3 for PROC LIFETEST           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: life-table estimate                                 */
/*   PROCS: LIFETEST                                            */
/*    DATA: Originally from Parker et al. (1946), included in   */
/*          E.T. Lee (1980): Statistical Method for Survival    */
/*          Data Analysis. Lifetime Learning Publications.      */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LIFETEST Chapter        */
/*    MISC:                                                     */
/****************************************************************/

title 'Survival of Males with Angina Pectoris';
data Males;
   keep Freq Years Censored;
   retain Years -.5;
   input fail withdraw @@;
   Years + 1;
   Censored=0;
   Freq=fail;
   output;
   Censored=1;
   Freq=withdraw;
   output;
   datalines;
456   0 226  39 152  22 171  23 135 24 125 107
 83 133  74 102  51  68  42  64  43 45  34  53
 18  33   9  27   6  23   0  30
;

ods graphics on;
proc lifetest data=Males  method=lt intervals=(0 to 15 by 1)
              plots=(s,ls,lls,h,p);
   time Years*Censored(1);
   freq Freq;
run;
ods graphics off;
