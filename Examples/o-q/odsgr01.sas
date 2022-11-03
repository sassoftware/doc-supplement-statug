/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR01                                             */
/*   TITLE: Getting Started 1, ODS Graphics                     */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics                                        */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Class;
   input Name $ Height Weight Age @@;
   datalines;
Alfred  69.0 112.5 14  Alice  56.5  84.0 13  Barbara 65.3  98.0 13
Carol   62.8 102.5 14  Henry  63.5 102.5 14  James   57.3  83.0 12
Jane    59.8  84.5 12  Janet  62.5 112.5 15  Jeffrey 62.5  84.0 13
John    59.0  99.5 12  Joyce  51.3  50.5 11  Judy    64.3  90.0 14
Louise  56.3  77.0 12  Mary   66.5 112.0 15  Philip  72.0 150.0 16
Robert  64.8 128.0 12  Ronald 67.0 133.0 15  Thomas  57.5  85.0 11
William 66.5 112.0 15
;


ods html;   /* On z/OS, replace this with ods html path=".";  */
ods graphics on;

title 'Getting Started example';
proc reg data = Class;
   model Weight = Height;
run;
quit;


title 'Displaying diagnostics plots individually';
ods trace on;

proc reg data = Class plots(unpack);
   model Weight = Height;
run;
quit;

ods trace off;


title 'Selecting Cooks D plot';
ods select CooksD;

proc reg data = Class plots(unpack);
   model Weight = Height;
run;
quit;


title 'Excluding fit plot';
ods exclude Fit;

proc reg data = Class;
   model Weight = Height;
run;
quit;

ods graphics off;
ods html close;
title;
