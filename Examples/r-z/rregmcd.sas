/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: rregmcd                                             */
/*   TITLE: Documentation MCD Example for PROC ROBUSTREG        */
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

data Children;
   do i=1 to 80;
      off_trail=ranuni(321)>.9;
      x=rannor(111)*ranuni(321);
      trail_x=(i-40)/80*3;
      trail_y=trail_x;
      if off_trail=1 then y=x-1+rannor(321);
      else y=x;
      output;
   end;
run;

proc sgplot data=Children;
   series   x=trail_x y=trail_y/lineattrs=(color="red" pattern=4);
   scatter  x=x y=y/group=off_trail;
   ellipse  x=x y=y/alpha=.05 lineattrs=(color="green" pattern=34);
run;

ods graphics on;
proc robustreg data=children plots=ddplot(label=none);
   model i = x y/leverage(mcdinfo opc);
run;
ods graphics off;
