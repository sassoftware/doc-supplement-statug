/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TEMPLGS1                                            */
/*   TITLE: Getting Started with Template Modification          */
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

proc template;
   define statgraph scatter;
      begingraph;
         entrytitle 'Fisher (1936) Iris Data';
         layout overlayequated / equatetype=fit;
            scatterplot x=petallength y=petalwidth /
                        group=species name='iris';
            layout gridded / autoalign=(topleft);
               discretelegend 'iris' / border=false opaque=false;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=sashelp.iris template=scatter;
run;

ods trace on;
ods graphics on;

proc reg data=sashelp.class;
   model Weight = Height;
quit;

proc template;
   source Stat.REG.Graphics.ResidualPlot;
run;

/*
ods path sashelp.tmplmst(read);
proc datasets library=sasuser nolist;
   delete templat(memtype=itemstor);
run;
ods path sasuser.templat(update) sashelp.tmplmst(read);
*/

%modtmplt(template=Stat.glm.graphics.residualhistogram, steps=t,
          stmtopts1=.  add  discretelegend  autoalign=(topleft),
          stmtopts2=1  add  densityplot     legendlabel='Normal Density',
          stmtopts3=2  add  densityplot     legendlabel='Kernel Density',
          stmtopts4=1  add  overlay         yaxisopts=(griddisplay=on)
                            yaxisopts=(label='Normal and Kernel Density'))

proc glm plots=diagnostics(unpack) data=sashelp.class;
   model weight = height;
run;

%modtmplt(template=Stat.glm.graphics.residualhistogram, steps=d)

%modtmplt(template=Stat.glm.graphics.residualhistogram, steps=t,
          stmtopts1=. delete discretelegend,
          stmtopts2=1 after  begingraph entryfootnote
                      textattrs=GraphLabelText(color=cx445694) 'Normal  '
                      textattrs=GraphLabelText(color=cxA23A2E) 'Kernel')

proc glm plots=diagnostics(unpack) data=sashelp.class;
   model weight = height;
run;

%modtmplt(template=Stat.glm.graphics.residualhistogram, steps=d)

