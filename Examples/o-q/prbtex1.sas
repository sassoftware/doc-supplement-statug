/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: prbtex1                                             */
/*   TITLE: Documentation Example 1 for PROC PROBIT             */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*                                                              */
/*   PROCS: PROBIT                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data a;
   infile cards eof=eof;
   input Dose N Response @@;
   Observed= Response/N;
   output;
   return;
eof: do Dose=0.5 to 7.5 by 0.25;
        output;
     end;
   datalines;
1 10 1  2 12 2  3 10 4  4 10 5
5 12 8  6 10 8  7 10 10
;

ods graphics on;

proc probit log10;
   model Response/N=Dose / lackfit inversecl itprint;
   output out=B p=Prob std=std xbeta=xbeta;
run;

proc probit log10 plot=predpplot;
   model Response/N=Dose / d=logistic inversecl;
   output out=B p=Prob std=std xbeta=xbeta;
run;

