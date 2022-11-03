/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SRATEX2                                             */
/*   TITLE: Documentation Example 2 for PROC STDRATE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: standardized rate                                   */
/*   PROCS: STDRATE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC STDRATE, EXAMPLE 2                             */
/*    MISC:                                                     */
/****************************************************************/

data School;
   input Smoking $ Pet $ Grade $ Case Student;
   datalines;
Yes   Yes   K-1   109    807
Yes   Yes   2-3   106    791
Yes   Yes   4-5   112    868
Yes   No    K-1   168   1329
Yes   No    2-3   162   1337
Yes   No    4-5   183   1594
No    Yes   K-1   284   2403
No    Yes   2-3   266   2237
No    Yes   4-5   273   2279
No    No    K-1   414   3398
No    No    2-3   372   3251
No    No    4-5   382   3270
;

ods graphics on;
proc stdrate data=School
             method=mh
             stat=risk
             effect=diff
             plots=all
             ;
   population group=Smoking event=Case total=Student;
   strata Pet Grade / order=data stats(cl=none) effect;
run;
