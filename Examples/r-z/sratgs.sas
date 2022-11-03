/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SRATGS                                              */
/*   TITLE: Getting Started Example for PROC STDRATE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: standardized rates                                  */
/*   PROCS: STDRATE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC STDRATE, GETTING STARTED EXAMPLE               */
/*    MISC:                                                     */
/****************************************************************/

data Florida_C43;
   input Age $1-5 Event PYear:comma9.;
   datalines;
00-04    0    953,785
05-14    0  1,997,935
15-24    4  1,885,014
25-34   14  1,957,573
35-44   43  2,356,649
45-54   72  2,088,000
55-64   70  1,548,371
65-74  126  1,447,432
75-84  136  1,087,524
85+     73    335,944
;

data US_C43;
   input Age $1-5 Event:comma5. PYear:comma10.;
   datalines;
00-04      0  19,175,798
05-14      1  41,077,577
15-24     41  39,183,891
25-34    186  39,892,024
35-44    626  45,148,527
45-54  1,199  37,677,952
55-64  1,303  24,274,684
65-74  1,637  18,390,986
75-84  1,624  12,361,180
85+      803   4,239,587
;

ods graphics on;
proc stdrate data=Florida_C43 refdata=US_C43
             method=indirect
             stat=rate(mult=100000)
             plots=all
             ;
   population event=Event total=PYear;
   reference  event=Event total=PYear;
   strata Age / stats smr;
run;
