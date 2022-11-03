/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR04                                             */
/*   TITLE: Creating Graphs for a Presentation                  */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, RTF                                   */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data one;
   do x = 1 to 100;
      y = log(x) + rannor(12345);
      output;
   end;
run;

/* On z/OS, replace this with ods rtf path="." file = "loess.rtf";  */
ods rtf file = "loess.rtf";
ods graphics on;

proc loess data = one;
   model y = x / clm residual;
run;

ods graphics off;
ods rtf close;
