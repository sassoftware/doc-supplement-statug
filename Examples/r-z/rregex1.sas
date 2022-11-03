/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: rregex1                                             */
/*   TITLE: Documentation Example 1 for PROC ROBUSTREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Robust Regression                                   */
/*                                                              */
/*   PROCS: ROBUSTREG                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data a (drop=i);
   do i=1 to 1000;
      x1=rannor(1234);
      x2=rannor(1234);
      e=rannor(1234);
      if i > 900 then y=100 + e;
      else y=10 + 5*x1 + 3*x2 + .5 * e;
      output;
   end;
run;
proc reg data=a;
   model y = x1 x2;
run;
proc robustreg data=a method=m;
   model y = x1 x2;
run;
proc robustreg data=a method=mm seed=100;
   model y = x1 x2;
run;
proc robustreg data=a method=s seed=100;
   model y = x1 x2;
run;
proc robustreg data=a method=lts seed=100;
   model y = x1 x2;
run;
data b (drop=i);
   do i=1 to 1000;
      x1=rannor(1234);
      x2=rannor(1234);
      e=rannor(1234);
      if i > 600 then y=100 + e;
      else y=10 + 5*x1 +  3*x2 + .5 * e;
      output;
   end;
run;
proc robustreg data=b method=m;
   model y = x1 x2;
run;
proc robustreg data=b method=mm;
   model y = x1 x2;
run;
proc robustreg data=b method=m(wf=bisquare(c=2));
   model y = x1 x2;
run;
proc robustreg data=b method=mm(inith=502 k0=1.8);
   model y = x1 x2;
run;
data c (drop=i);
   do i=1 to 1000;
      x1=rannor(1234);
      x2=rannor(1234);
      e=rannor(1234);
      if i > 600 then y=100 + e;
      else y=10 + 5*x1 + 3*x2 + .5 * e;
      if i < 11 then x1=200 * rannor(1234);
      if i < 11 then x2=200 * rannor(1234);
      if i < 11 then y= 100*e;
      output;
   end;
run;
proc robustreg data=c method=mm(inith=502 k0=1.8) seed=100;
   model y = x1 x2;
run;
proc robustreg data=c method=s(k0=1.8) seed=100;
   model y = x1 x2;
run;
proc robustreg data=c method=lts(h=502) seed=100;
   model y = x1 x2;
run;
