/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex8                                            */
/*   TITLE: Example 8 for PROC BGLIMM                           */
/*    DESC: Power Prior                                         */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Power Prior                                         */
/*   PROCS: BGLIMM                                              */
/*    DATA: Kociba, NTP                                         */
/*                                                              */
/*     REF:                                                     */
/****************************************************************/

data Kociba;
   input y n Dose;
datalines;
9  86  0
3  50  1
18 50  10
34 48  100
;

data NTP;
   input y n Dose;
datalines;
5  75  0
1  49  1.4
3  50  7.1
12 49  71
;

proc bglimm data=Kociba seed=1181 nmc=10000;
   model y/n = Dose;
run;

proc bglimm data=NTP seed=1181 nmc=10000;
   model y/n = Dose;
run;

data Combined;
   set Kociba(in=i) NTP;
   a0 = 1;
   if i then a0 = 0.3;
   run;

proc bglimm data=Combined seed=1181 nmc=10000;
   model y/n = Dose;
   freq  a0 / notrunc;
run;

data CombinedBy;
   set Kociba(in=i) NTP;
   do val = 0 to 1 by 0.1;
      a0 = 1;
      dicIdx = 1;
      if i then do;
         a0 = val;
         dicIdx = 0;
         end;
      output;
      end;

proc sort;
   by val;
run;

ods output dic = dic0;
proc bglimm data=CombinedBy seed=1181 nmc=10000 dic(include=dicIdx);
   model y/n = Dose;
   freq  a0 / notrunc;
   by val;
run;

data Combined;
   set Kociba(in=i) NTP;
   a0 = 1;
   if i then a0 = 0.1;
   run;

proc bglimm data=Combined seed=1181 nmc=10000;
   model y/n = Dose;
   freq  a0 / notrunc;
run;

