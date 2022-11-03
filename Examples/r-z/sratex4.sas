/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SRATEX4                                             */
/*   TITLE: Documentation Example 4 for PROC STDRATE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: standardized rate                                   */
/*   PROCS: STDRATE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC STDRATE, EXAMPLE 4                             */
/*    MISC:                                                     */
/****************************************************************/

data Florida_Cs;
   input Age $1-5 Event_C16 Event_C43 PYear:comma9.;
   datalines;
00-04    0    0    953,785
05-14    0    0  1,997,935
15-24    0    4  1,885,014
25-34    1   14  1,957,573
35-44   19   43  2,356,649
45-54   64   72  2,088,000
55-64  114   70  1,548,371
65-74  201  126  1,447,432
75-84  294  136  1,087,524
85+    136   73    335,944
;

data Florida_Cs;
   set Florida_Cs;
   Cause='Stomach';  Event=Event_C16;  output;
   Cause='Skin';     Event=Event_C43;  output;
   drop Event_C16 Event_C43;
run;

proc sort data=Florida_Cs;
   by Cause;
run;

proc print data=Florida_Cs;
   var Cause Age Event PYear;
run;

data US_Cs;
   input Age $1-5 Event_C16 Event_C43 PYear:comma10.;
   datalines;
00-04     0     0  19,175,798
05-14     1     1  41,077,577
15-24    14    41  39,183,891
25-34   124   186  39,892,024
35-44   484   626  45,148,527
45-54  1097  1199  37,677,952
55-64  1804  1303  24,274,684
65-74  3054  1637  18,390,986
75-84  3833  1624  12,361,180
85+    2234   803   4,239,587
;

data US_Cs;
   set US_Cs;
   Cause='Stomach';  Event=Event_C16;  output;
   Cause='Skin';     Event=Event_C43;  output;
   drop Event_C16 Event_C43;
run;

proc sort data=US_Cs;
   by Cause;
run;

proc print data=US_Cs;
   var Cause Age Event PYear;
run;

ods graphics on;
ods select StdInfo StrataSmrPlot Smr;
proc stdrate data=Florida_Cs refdata=US_Cs
             stat=rate
             method=indirect
             plots=smr
             ;
   population event=Event total=PYear;
   reference  event=Event total=PYear;
   strata Age;
   by Cause;
ods output smr=Smr_Cs;
run;

proc print data=Smr_Cs;
   var Cause ObservedEvents ExpectedEvents Smr SmrLcl SmrUcl;
run;

proc sgplot data=Smr_Cs;
   scatter y=Cause x=Smr / group=Cause;
   highlow y=Cause high=SmrUcl low=SmrLcl / highcap=serif lowcap=serif;
   yaxis type=discrete;
   xaxis label="SMR";
   refline 1 / axis=x transparency=0.5;
run;
