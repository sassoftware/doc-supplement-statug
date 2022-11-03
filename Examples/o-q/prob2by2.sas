 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: PROB2BY2                                            */
 /*   TITLE: Window for 2 by 2 Table Calculation                 */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: interactive, probability                            */
 /*   PROCS: DATA                                                */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
data _null_;
 /* program to compute probabilities for the 2 by 2 table. */
 window two color=red
   rows=10 irow=10 group=inter
 #1 @32 '2 by 2 TABLE' color = black
 #2 @12 '+--------------------------------------------+' color = black
 #3 @12 '|' color=black +1 n1 @35 '|' color=black
  +1 n2 @57 '|' color=black +2 m1 color=cyan
 #4 @12 '+--------------------------------------------+' color = black
 #5 @12 '|' color=black +1 n3 @35 '|' color=black
  +1 n4 @57 '|' color=black +2 m2 color=cyan
 #6 @12 '+--------------------------------------------+' color = black
 #7 @13 p1 color=yellow @37 p2 color = yellow @60 n color=blue
 #8 @2 'Enter Odds Ratio'
  +1 or 4.2 @25 'Prob(n11<=' +1 t1 4. ')=' prob 6.4;


 do while(upcase(_cmd_) ne 'STOP');
   display two ;
   link compute;
 end;
 stop;

 compute:

   m1 = n1 + n2; m2 = n3+n4; p1=n1+n3; p2=n2+n4;
   n=m1+m2; t1 = n1;
   prob=probhypr(n,m1,p1,n1,or);

 return;
run;
