 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: POWER                                               */
 /*   TITLE: Power Analysis of Linear Models                     */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance, power analysis                */
 /*   PROCS: GLM PLOT                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: O'Brien, R. ASA Proc. Stat. Comp. Sect., 1982,114-8 */
 /*    MISC: Reproduces example in above paper                   */
 /*                                                              */
 /****************************************************************/


 /* reproduces O'Brien's 1982 ASA stat. comp paper */

data means;
  input a b mean @@;
  datalines;
1 1 100 1 2 100 1 3 100 1 4 100
2 1 100 2 2 100 2 3  95 2 4  90
3 1 100 3 2  98 3 3  92 3 4  84
;

 /* suppress all printing, use sums of squares in output ds */

proc glm noprint outstat=next;
   class a b;
   model mean=a|b/ss3 ;
   contrast 'A Lin' a -1 0 1;
   contrast 'B Lin' b -3 -1 1 3;
   contrast 'A Lin * B Lin'
       a*b 3 1 -1 -3 0 0 0 0 -3 -1 1 3;
run; quit;

data;
   set next;
   retain edf;
   if _type_ ^= 'ERROR';
   do Freq = 5 to 20 by 5;
      /* calculate edf as number of observations - number of cells */
      edf = freq * 12 - 12;
      do sigma=15 to 20 by 5;
        c = freq * ss/(sigma*sigma);
        fcrit=finv(.95,df,edf,0);
        Power = 1 - probf(fcrit,df,edf,c);
        output;
     end;
   end;
run;

proc sort;
   by _source_;
run;

proc sgplot;
   by _source_;
   label _source_ = 'Source';
   scatter y=power x=freq / markerchar=sigma;
run;
