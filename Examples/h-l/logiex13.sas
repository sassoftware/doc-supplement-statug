/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX13                                            */
/*   TITLE: Example 13 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          conditional logistic regression analysis,           */
/*          exact conditional logistic regression analysis,     */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 13. Firth's Penalized Likelihood Compared to Other Approaches
*****************************************************************/

/*
Firth's penalized likelihood approach is a method for addressing issues of
separability, small sample sizes, and bias of the parameter estimates.

This example compares results obtained from a 2x2 table where one cell has
zero frequencies.  This is an example of a quasi-completely separated data
set.
*/

title 'Example 13. Firth''s Penalized Likelihood Compared to Other Approaches';

%let beta0=-15;
%let beta1=16;
data one;
   keep sample X y pry;
   do sample=1 to 10/*1000*/;
      do i=1 to 100;
         X=rantbl(987987,.4,.6)-1;
         xb= &beta0 + X*&beta1;
         exb=exp(xb);
         pry= exb/(1+exb);
         cut= ranuni(393993);
         if (pry < cut) then y=1; else y=0;
         output;
      end;
   end;
run;

ods exclude all;
proc logistic data=one;
   by sample;
   class X(param=ref);
   model y(event='1')=X / firth clodds=pl;
   ods output cloddspl=firth;
run;
proc logistic data=one exactonly;
   by sample;
   class X(param=ref);
   model y(event='1')=X;
   exact X / estimate=odds;
   ods output exactoddsratio=exact;
run;
ods select all;
proc means data=firth;
   var LowerCL OddsRatioEst UpperCL;
run;
proc means data=exact;
   var LowerCL Estimate UpperCL;
run;


/*
This example compares results on case-control data.

Due to the exact analyses, this program takes a long time and a lot of
resources to run.  You may want to reduce the number of samples generated.
*/

%let beta0=1;
%let beta1=2;
data one;
   do sample=1 to 3/*1000*/;
      do pair=1 to 20;
         ran=ranuni(939393);
         a=3*ranuni(9384984)-1;
         pdf0= pdf('NORMAL',a,.4,1);
         pdf1= pdf('NORMAL',a,1,1);
         pry0= pdf0/(pdf0+pdf1);
         pry1= 1-pry0;
         xb= log(pry0/pry1);
         x= (xb-&beta0*pair/100) / &beta1;
         y=0;
         output;
         x= (-xb-&beta0*pair/100) / &beta1;
         y=1;
         output;
      end;
   end;
run;

ods exclude all;
proc logistic data=one;
   by sample;
   class pair / param=ref;
   model y=x pair / clodds=pl;
   ods output cloddspl=oru;
run;
data oru;
   set oru;
   if Effect='x';
   rename lowercl=lclu uppercl=uclu oddsratioest=orestu;
run;
proc logistic data=one;
   by sample;
   strata pair;
   model y=x / clodds=wald;
   ods output cloddswald=orc;
run;
data orc;
   set orc;
   if Effect='x';
   rename lowercl=lclc uppercl=uclc oddsratioest=orestc;
run;
proc logistic data=one exactonly;
   by sample;
   strata pair;
   model y=x;
   exact x / estimate=both;
   ods output ExactOddsRatio=ore;
run;
proc logistic data=one;
   by sample;
   class pair / param=ref;
   model y=x pair / firth clodds=pl;
   ods output cloddspl=orf;
run;
data orf;
   set orf;
   if Effect='x';
   rename lowercl=lclf uppercl=uclf oddsratioest=orestf;
run;
data all;
   merge oru orc ore orf;
run;
ods select all;
proc means data=all;
run;
