/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX17                                              */
/*   TITLE: Documentation Example 17 for PROC MI                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 17                                 */
/*    MISC:                                                     */
/****************************************************************/

data Mono2;
   do Grd= 6 to 8;
   do j=1 to 50;

      Grade= Grd;
      if (Grd=6) then do;
         if (ranuni(999) > .80) then Grade= .;
      end;
      else if (ranuni(99) > .95) then Grade= .;

      if (j < 26) then Study= 1;
      else             Study= 0;

      Score0= 70 + 3*rannor(1);
      if (Score0 >= 100) then Score0= 100 - 10*ranuni(99);

      Score= Score0 + 2*rannor(99) + 2;
      if (Study = 1) then do;
         Score= Score + 3;
         if (Grd = 6) then Score= Score + 1;
         if (Grd = 8) then Score= Score + 3;
      end;

      output;
   end; end;
   drop Grd j;
run;

proc print data=Mono2(obs=10);
   var Grade Score0 Score Study;
   title 'First 10 Obs in the Student Test Data';
run;

proc mi data=Mono2 seed=34857 nimpute=20 out=outex17;
   class Study Grade;
   monotone logistic (Grade / link=glogit);
   mnar adjust( Grade (event='6') /shift=2);
   var Study Score0 Score Grade;
run;

proc print data=outex17(obs=10);
   var _Imputation_ Grade Study Score0 Score;
   title 'First 10 Observations of the Imputed Student Test Data Set';
run;
