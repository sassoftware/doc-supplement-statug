
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: RSREX1                                              */
/*   TITLE: Example 1 for PROC RSREG                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: response surface regression                         */
/*   PROCS: RSREG                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC RSREG chapter           */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Frankel (1961) reports an experiment aimed at maximizing the
yield of mercaptobenzothiazole (MBT) by varying processing time
and temperature.  From Myers, Response Surface Methodology 1976.
----------------------------------------------------------------*/

title 'A Saddle Surface Response Using Ridge Analysis';

data d;
   input Time Temp MBT;
   label Time = "Reaction Time (Hours)"
         Temp = "Temperature (Degrees Centigrade)"
         MBT  = "Percent Yield Mercaptobenzothiazole";
   datalines;
 4.0   250   83.8
20.0   250   81.7
12.0   250   82.4
12.0   250   82.9
12.0   220   84.7
12.0   280   57.9
12.0   250   81.2
 6.3   229   81.3
 6.3   271   83.1
17.7   229   85.3
17.7   271   72.7
 4.0   250   82.0
;


ods graphics on;
proc rsreg data=d plots=(ridge surface);
   model MBT=Time Temp / lackfit;
   ridge max;
run;
ods graphics off;
