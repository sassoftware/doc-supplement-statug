/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: EFPLEX1                                             */
/*   TITLE: Example 1 for EFFECTPLOT Statement                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, saddle points                         */
/*   PROCS: ORTHOREG                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, Shared Concepts Chapter      */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 1. A Saddle Surface
*****************************************************************/

/*
Frankel (1961) reports an experiment aimed at maximizing the
yield of mercaptobenzothiazole (MBT) by varying processing time
and temperature.  From Myers, Response Surface Methodology 1976.
*/

title 'Example 1. A Saddle Surface';
data d;
   input Time Temp MBT @@;
   label Time = "Reaction Time (Hours)"
         Temp = "Temperature (Degrees Centigrade)"
         MBT  = "Percent Yield Mercaptobenzothiazole";
   datalines;
 4.0  250  83.8    20.0  250  81.7    12.0  250  82.4
12.0  250  82.9    12.0  220  84.7    12.0  280  57.9
12.0  250  81.2     6.3  229  81.3     6.3  271  83.1
17.7  229  85.3    17.7  271  72.7     4.0  250  82.0
;
ods graphics on;
proc orthoreg data=d;
   model MBT=Time|Time|Temp|Temp@2;
   effectplot fit(x=time plotby=temp);
run;
proc orthoreg data=d;
   model MBT=Time|Time|Temp|Temp@2;
   effectplot slicefit(x=time sliceby=temp=229 250 271 280);
run;
proc orthoreg data=d;
   model MBT=Time|Time|Temp|Temp@2;
   effectplot / obs(jitter(seed=39393));
run;
ods graphics off;
