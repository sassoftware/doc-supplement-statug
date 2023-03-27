/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TEMPLEX4                                            */
/*   TITLE: Documentation Example 4 for Template Modification   */
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

title "Number of Ph.D.'s Awarded from 1973 to 1978";

data PhD;
   input Science $ 1-19 y1973-y1978;
   label y1973 = '1973'
         y1974 = '1974'
         y1975 = '1975'
         y1976 = '1976'
         y1977 = '1977'
         y1978 = '1978';
   datalines;
Life Sciences       4489 4303 4402 4350 4266 4361
Physical Sciences   4101 3800 3749 3572 3410 3234
Social Sciences     3354 3286 3344 3278 3137 3008
Behavioral Sciences 2444 2587 2749 2878 2960 3049
Engineering         3338 3144 2959 2791 2641 2432
Mathematics         1222 1196 1149 1003  959  959
;

ods graphics on;
ods trace on;

proc corresp data=PhD short;
   ods select configplot;
   var y1973-y1978;
   id Science;
run;

proc template;
   source Stat.Corresp.Graphics.Configuration;
run;

proc template;
   define statgraph Stat.Corresp.Graphics.Configuration;
      dynamic xVar yVar head legend _byline_ _bytitle_ _byfootnote_;
      begingraph;
         entrytitle HEAD;
         layout overlayequated / equatetype=fit xaxisopts=(offsetmin=0.1
            offsetmax=0.1) yaxisopts=(offsetmin=0.1 offsetmax=0.1);

            referenceline x=0;
            referenceline y=0;

            scatterplot y=YVAR x=XVAR / group=GROUP index=INDEX datalabel=LABEL
               name="Type" tip=(y x datalabel group) tiplabel=(group="Point");
            if (LEGEND)
               discretelegend "Type";
            endif;
         endlayout;
         if (_BYTITLE_)
            entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT;
         else
            if (_BYFOOTNOTE_)
               entryfootnote halign=left _BYLINE_;
            endif;
         endif;
      endgraph;
   end;
run;

proc corresp data=PhD short;
   ods select configplot;
   var y1973-y1978;
   id Science;
run;

proc template;
   delete Stat.Corresp.Graphics.Configuration / store=sasuser.templat;
run;

proc template;
   define style noframe;
      parent=styles.htmlblue;
      style graphwalls from graphwalls / frameborder=off;
   end;
run;

*
ods listing style=noframe;

proc corresp data=PhD short;
   ods select configplot;
   var y1973-y1978;
   id Science;
run;

proc template;
   define statgraph Stat.Corresp.Graphics.Configuration;
      dynamic xVar yVar head legend _byline_ _bytitle_ _byfootnote_;
      begingraph;
         entrytitle HEAD;

         layout overlayequated / equatetype=fit walldisplay=none
            xaxisopts=(display=(tickvalues) offsetmin=0.1 offsetmax=0.1)
            yaxisopts=(display=(tickvalues) offsetmin=0.1 offsetmax=0.1);

            referenceline x=0;
            referenceline y=0;

            scatterplot y=YVAR x=XVAR / group=GROUP index=INDEX datalabel=LABEL
               name="Type" tip=(y x datalabel group) tiplabel=(group="Point");
            if (LEGEND)
               discretelegend "Type";
            endif;
         endlayout;
         if (_BYTITLE_)
            entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT;
         else
            if (_BYFOOTNOTE_)
               entryfootnote halign=left _BYLINE_;
            endif;
         endif;
      endgraph;
   end;
run;

*
ods listing style=htmlblue;

proc corresp data=PhD short;
   ods select configplot;
   var y1973-y1978;
   id Science;
run;

proc template;
   define statgraph Stat.Corresp.Graphics.Configuration;
      dynamic xVar yVar head legend _byline_ _bytitle_ _byfootnote_;
      begingraph;
         entrytitle HEAD;

         layout overlayequated / equatetype=fit
            commonaxisopts=(tickvaluelist=(0))
            xaxisopts=(offsetmin=0.1 offsetmax=0.1)
            yaxisopts=(offsetmin=0.1 offsetmax=0.1);


            referenceline x=0;
            referenceline y=0;

            scatterplot y=YVAR x=XVAR / group=GROUP index=INDEX datalabel=LABEL
               name="Type" tip=(y x datalabel group) tiplabel=(group="Point");
            if (LEGEND)
               discretelegend "Type";
            endif;
         endlayout;
         if (_BYTITLE_)
            entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT;
         else
            if (_BYFOOTNOTE_)
               entryfootnote halign=left _BYLINE_;
            endif;
         endif;
      endgraph;
   end;
run;

proc corresp data=PhD short;
   ods select configplot;
   var y1973-y1978;
   id Science;
run;

proc template;
   delete Stat.Corresp.Graphics.Configuration / store=sasuser.templat;
run;

