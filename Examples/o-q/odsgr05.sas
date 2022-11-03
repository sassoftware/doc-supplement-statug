/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR05                                             */
/*   TITLE: Creating Graphs in PostScript Files                 */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, PostScript, Journal style, LaTeX      */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data stack;
   input  x1 x2 x3 y @@;
   datalines;
80  27  89  42    80  27  88  37    75  25  90  37
62  24  87  28    62  22  87  18    62  23  87  18
62  24  93  19    62  24  93  20    58  23  87  15
58  18  80  14    58  18  89  14    58  17  88  13
58  18  82  11    58  19  93  12    50  18  89   8
50  18  86   7    50  19  72   8    50  19  79   8
50  20  80   9    56  20  82  15    70  20  91  15
;


/*------------------------------------------------*/
/* On z/OS, replace the ODS LATEX statement with: */
/*                                                */
/*    ods latex path="." style=Journal;           */
/*------------------------------------------------*/
ods latex style=Journal;
ods graphics on;

proc robustreg plot=reshistogram data=stack;
   model y = x1 x2 x3;
run;

ods graphics off;
ods latex close;
