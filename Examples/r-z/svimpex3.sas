/*********************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                      */
/*                                                                   */
/*    NAME: SVIMPEX3                                                 */
/*   TITLE: Documentation Example 3 for PROC SURVEYIMPUTE            */
/* PRODUCT: STAT                                                     */
/*  SYSTEM: ALL                                                      */
/*    KEYS: fully efficient fractional imputation (FEFI), NHANES     */
/*    KEYS: balanced repeated replication (BRR)                      */
/*    KEYS: imputation-adjusted replicate weights, domain analysis   */
/*   PROCS: SURVEYIMPUTE, SURVEYFREQ                                 */
/*    DATA: NHANES III                                               */
/*    URL:  http://www.cdc.gov/nchs/nhanes/about_nhanes.htm          */
/*  UPDATE: March 30, 2018                                           */
/*     REF: PROC SURVEYIMPUTE, Example 3                             */
/*    MISC: You must download the core and imp1 data sets from       */
/*          NHANES III before running the sample program. See the    */
/*          description in the example about how to create the smoke */
/*          data set that is used in this example.                   */
/*********************************************************************/

/*
data Smoke;
   merge core (keep=seqn wtp: hff1if han6srif har3rif hat28if DMARETHN HSSEX)
         imp1 (keep=seqn      hff1mi han6srmi har3rmi hat28mi );
   by seqn;
run;

*---Create education levels and imputation cells, ---;
*---and assign . to missing items                 ---;
data Smoke; set Smoke;
   if HFA7 <=8                 then Education='Elementary ';
   if HFA7 > 8  and HFA7 <= 12 then Education='High School';
   if HFA7 > 12 and HFA7 <= 17 then Education='College    ';
   if HFA7 > 17                then Education='Unknown    ';
   if DMARETHN = 1 & HSSEX = 1 then ImputationCells=1;
   if DMARETHN = 1 & HSSEX = 2 then ImputationCells=2;
   if DMARETHN = 2 & HSSEX = 1 then ImputationCells=3;
   if DMARETHN = 2 & HSSEX = 2 then ImputationCells=4;
   if DMARETHN = 3 & HSSEX = 1 then ImputationCells=5;
   if DMARETHN = 3 & HSSEX = 2 then ImputationCells=6;
   if DMARETHN = 4             then ImputationCells=7;
   if HFF1IF   = 2 then HFF1MI   = .;
   if HAN6SRIF = 2 then HAN6SRMI = .;
   if HAR3RIF  = 2 then HAR3RMI  = .;
   if HAT28IF  = 2 then HAT28MI  = .;
run;

proc surveyimpute data=Smoke method=FEFI varmethod=BRR;
   weight wtpfqx6;
   repweights wtpqrp:;
   id seqn;
   class hff1mi han6srmi har3rmi hat28mi;
   var   hff1mi han6srmi har3rmi hat28mi;
   cells ImputationCells;
   output out=SmokeImputed;
run;

proc surveyfreq data=SmokeImputed varmethod=brr(fay=0.3) varheader=label;
   weight ImpWt;
   repweights ImpRepWt_:;
   table HFF1MI*HAR3RMI;
   table Education*HAT28MI / row nototal nofreq nowt;
run;

*/

