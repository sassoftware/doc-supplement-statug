/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGREX4                                            */
/*   TITLE: Documentation Example 4 for ODS Graphics            */
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

data stack;
   input x1 x2 x3 y @@;
   datalines;
80 27 89 42   80 27 88 37   75 25 90 37   62 24 87 28   62 22 87 18
62 23 87 18   62 24 93 19   62 24 93 20   58 23 87 15   58 18 80 14
58 18 89 14   58 17 88 13   58 18 82 11   58 19 93 12   50 18 89  8
50 18 86  7   50 19 72  8   50 19 79  8   50 20 80  9   56 20 82 15
70 20 91 15
;

ods graphics on;
/*
ods _all_ close;
ods document name=QQDoc(write);
*/

proc robustreg data=stack plots=qqplot;
   model y = x1 x2 x3;
quit;

/*
ods document close;
ods listing;
*/

proc document name=QQDoc;
   list / levels=all;
quit;

