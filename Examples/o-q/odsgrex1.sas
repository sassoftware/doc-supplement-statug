/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGREX1                                            */
/*   TITLE: Documentation Example 1 for ODS Graphics            */
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

data pr;
   input Person Gender $ y1 y2 y3 y4 @@;
   y=y1; Age=8;  output;
   y=y2; Age=10; output;
   y=y3; Age=12; output;
   y=y4; Age=14; output;
   drop y1-y4;
   datalines;
 1  F  21.0  20.0  21.5  23.0      2  F  21.0  21.5  24.0  25.5
 3  F  20.5  24.0  24.5  26.0      4  F  23.5  24.5  25.0  26.5
 5  F  21.5  23.0  22.5  23.5      6  F  20.0  21.0  21.0  22.5
 7  F  21.5  22.5  23.0  25.0      8  F  23.0  23.0  23.5  24.0
 9  F  20.0  21.0  22.0  21.5     10  F  16.5  19.0  19.0  19.5
11  F  24.5  25.0  28.0  28.0     12  M  26.0  25.0  29.0  31.0
13  M  21.5  22.5  23.0  26.5     14  M  23.0  22.5  24.0  27.5
15  M  25.5  27.5  26.5  27.0     16  M  20.0  23.5  22.5  26.0
17  M  24.5  25.5  27.0  28.5     18  M  22.0  22.0  24.5  26.5
19  M  24.0  21.5  24.5  25.5     20  M  23.0  20.5  31.0  26.0
21  M  27.5  28.0  31.0  31.5     22  M  23.0  23.0  23.5  25.0
23  M  21.5  23.5  24.0  28.0     24  M  17.0  24.5  26.0  29.5
25  M  22.5  25.5  25.5  26.0     26  M  23.0  24.5  26.0  30.0
27  M  22.0  21.5  23.5  25.0
;

/*
ods _all_ close;
ods html body='b.html' style=HTMLBlue;
*/
ods graphics on / imagemap=on;

proc mixed data=pr method=ml plots=boxplot;
   ods select 'Conditional Residuals by Gender';
   class Person Gender;
   model y = Gender Age Gender*Age;
   random intercept Age / type=un subject=Person;
run;

*
ods html close;

