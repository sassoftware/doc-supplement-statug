/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGREX3                                            */
/*   TITLE: Documentation Example 3 for ODS Graphics            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods                                       */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES: This sample provides DATA step and PROC code        */
/*   from the chapter "Statistical Graphics Using ODS." It      */
/*   does not provide all of the ODS statements and style       */
/*   changes that are in the example.  Rather, this sample      */
/*   provides code that can be run in one large batch to make   */
/*   all of the graphs in the example.  In practice, you would  */
/*   not want to repeatedly open and close destinations as is   */
/*   done in the chapter.  Note that you should not specify     */
/*   destination style changes without first closing a          */
/*   destination.  Changing the style of the output without     */
/*   first closing the destination will not work as you might   */
/*   expect.  Do not do the following:                          */
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
/*      ODS HTML STYLE=STATISTICAL FILE='file1.htm';            */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=DEFAULT     FILE='file2.htm';            */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=ANALYSIS    FILE='file3.htm';            */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*                                                              */
/*   Note that some steps are commented out in this sample      */
/*   because they create large volumes of output.  To run       */
/*   those steps, remove the comments.                          */
/****************************************************************/

ods graphics on / reset=index;
/*
ods _all_ close;
ods latex style=Journal;
*/

proc sgplot data=sashelp.class;
   vbar age / group=sex;
run;

/*
ods latex close;
ods listing;
*/

/*
ods _all_ close;
ods latex style=Journal2;
*/

proc sgplot data=sashelp.class;
   vbar age / group=sex;
run;

/*
ods latex close;
ods listing;
*/

/*
ods _all_ close;
ods latex style=Journal3;
*/

proc sgplot data=sashelp.class;
   vbar age / group=sex;
run;

/*
ods latex close;
ods listing;
*/

