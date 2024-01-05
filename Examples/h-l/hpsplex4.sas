/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPSPLEX4                                            */
/*   TITLE: Documentation Example 4 for PROC HPSPLIT            */
/*    DESC: Predicting mortgage default                         */
/*                                                              */
/* PRODUCT: HPSTAT                                              */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: HPSPLIT                                             */
/*                                                              */
/****************************************************************/

/* Convert variable names to mixed case */
data hmeq;
   length Bad Loan MortDue Value 8 Reason Job $7
          YoJ Derog Delinq CLAge nInq CLNo DebtInc 8;
   set sampsio.hmeq;
run;

proc print data=hmeq(obs=10); run;

ods graphics on;

proc hpsplit data=hmeq maxdepth=5;
   class Bad Delinq Derog Job nInq Reason;
   model Bad(event='1') = Delinq Derog Job nInq Reason CLAge CLNo
               DebtInc Loan MortDue Value YoJ;
   prune costcomplexity;
   partition fraction(validate=0.3 seed=123);
   * Delete this comment and modify the file name as needed to run:
   code file='hpsplexc.sas';
   * Delete this comment and modify the file name as needed to run:
   rules file='rules.txt';
run;

/* Uncomment and modify the file name as needed to run:
data scored;
   set hmeq;
   %include 'hpsplexc.sas';
run;
*/

