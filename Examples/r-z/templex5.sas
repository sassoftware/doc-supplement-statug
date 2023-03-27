/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TEMPLEX5                                            */
/*   TITLE: Documentation Example 5 for Template Modification   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods                                       */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES: This sample provides the DATA step and PROC code    */
/*   from the chapter "ODS Graphics Template Modification."  It */
/*   does not provide most of the ODS statements and style      */
/*   changes that are in the chapter.  Rather, this sample      */
/*   provides code that can be run in one large batch to make   */
/*   all of the graphs in the chapter.  If destinations were    */
/*   repeatedly opened and closed, as in the chapter, then      */
/*   output would be lost and rewritten.  Note that you should  */
/*   not specify destination style changes without first        */
/*   closing a destination.  Changing the style of the output   */
/*   without first closing the destination will not work        */
/*   as you might expect.  Do not do the following:             */
/*                                                              */
/*      ODS HTML STYLE=STATISTICAL;                             */
/*      . . . code . . .                                        */
/*      ODS HTML STYLE=DEFAULT;                                 */
/*      . . . code . . .                                        */
/*      ODS HTML STYLE=ANALYSIS;                                */
/*      . . . code . . .                                        */
/*                                                              */
/*   Instead, do the following:                                 */
/*                                                              */
/*      ODS HTML STYLE=STATISTICAL;                             */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=DEFAULT;                                 */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=ANALYSIS;                                */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*                                                              */
/*   Note that several steps are commented out in this sample,  */
/*   because they create large volumes of output.  To run those */
/*   steps, remove the comments.                                */
/****************************************************************/

/*
%let date = Project 17.104, &sysdate;

proc template;
   list stat     / where=(type='Statgraph');
   list stat.reg / where=(type='Statgraph');
run;

options ls=96;
proc template;
   source stat     / where=(type='Statgraph');
   source stat.reg / where=(type='Statgraph');
options ls=80;

*/
ods graphics on;

proc reg data=sashelp.class plots=fit(stats=none);
   model weight = height;
quit;

/*
proc template;
   delete stat.reg / store=sasuser.templat;
run;
*/

proc template;
   source / where=(type='Statgraph') file="tpls.sas";
run;

data _null_;
   infile 'tpls.sas' lrecl=256 pad;
   input line $ 1-256;
   file 'newtpls.sas';
   put line;
   line = left(lowcase(line));
   if line =: 'begingraph' then
      put 'mvar __date;' /
          'entryfootnote halign=left textattrs=GraphValueText __date;';

   file log;
   if index(line, '__date') then
      put 'ERROR: Name __date already used.' / line;
   if index(line,'entryfootnote') and not index(line,'_byline_') then put line;
run;

proc template;
   %include 'newtpls.sas' / nosource;
run;

