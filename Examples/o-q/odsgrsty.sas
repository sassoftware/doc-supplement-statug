/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGRSTY                                            */
/*   TITLE: Style Examples for ODS Graphics                     */
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

proc template;
   list styles;
   /*
   source Styles.Default;
   source Styles.Statistical;
   source Styles.Journal;
   source Styles.RTF;
   source Styles.HTMLBlue;
   */
run;

ods graphics on / attrpriority=color;
proc sgplot data=sashelp.class;
   title 'Attribute Priority = Color';
   reg y=weight x=height / group=sex;
   keylegend / location=inside position=topleft across=1;
run;

ods graphics on / attrpriority=none;
proc sgplot data=sashelp.class;
   title 'Attribute Priority = None';
   reg y=weight x=height / group=sex;
   keylegend / location=inside position=topleft across=1;
run;

proc sgplot data=sashelp.class;
   title 'Solid Lines but Varying Markers';
   styleattrs datalinepatterns=(solid);
   reg y=weight x=height / group=sex;
   keylegend / location=inside position=topleft across=1;
run;
ods graphics on / reset;

ods graphics on / attrpriority=none;

proc sgplot data=sashelp.iris;
   title 'Fisher (1936) Iris Data';
   styleattrs datasymbols=(circlefilled squarefilled starfilled)
              datacontrastcolors=(red green blue);
   scatter x=petallength y=petalwidth / group=species markerattrs=(size=5px);
run;

ods graphics / reset;

data myattrmap;
   retain ID 'Attr1' MarkerSymbol 'CircleFilled';
   input Value $ LineColor $ 3-11 MarkerColor $ 13-20;
   datalines;
F pink      cxFFCCEE
M lightblue blue
;

proc sgplot data=sashelp.class dattrmap=myattrmap;
   title 'Separate Fit by Sex';
   reg y=weight x=height / group=sex degree=3 attrid=Attr1;
run;

/*
proc template;
   source styles.default;
run;
*/

proc format;
   value vf 5 = 'GraphValueText';
run;

data x1;
   array y[20] y0 - y19;
   do x = 1 to 20; y[x] = x - 0.5; end;
   do x = 0 to 10 by 5; output; end;
   label y18 = 'GraphLabelText' x = 'GraphLabelText';
   format x y18 vf.;
run;

%macro d;
   %do i = 1 %to 12;
      reg y=y%eval(19-&i) x=x / lineattrs=GraphData&i markerattrs=GraphData&i
                                curvelabel="  GraphData&i" curvelabelpos=max;
   %end;
%mend;

%macro l(i, l);
   reg y=y&i x=x / lineattrs=&l markerattrs=&l curvelabel="  &l"
                   curvelabelpos=max;
%mend;

*
ods html style=default; * You can instead specify other destinations
                          such as LISTING, PDF, or RTF;
proc sgplot noautolegend data=x1;
   title 'GraphTitleText';
   %d
   %l(19, GraphDataDefault)
   %l( 6, GraphFit)
   %l( 5, GraphFit2)
   %l( 4, GraphPredictionLimits)
   %l( 3, GraphConfidence)
   %l( 2, GraphGridLines)
   %l( 1, GraphOutlier)
   %l( 0, GraphReference)
   xaxis values=(0 5 10);
run;
*
ods html close;

data x2;
   do y = 40 to 1 by -1;
      group = 'Group' || put(41 - y, 2. -L);
      do x = 0 to 10 by 5;
         if x = 10 then do; z = 11; l = group; end;
         else           do; z = .;  l = ' ';   end;
         output;
      end;
   end;
run;

proc sgplot data=x2;
   title 'Colors, Markers, Lines Patterns for Groups';
   series  y=y x=x / group=group markers;
   scatter y=y x=z / group=group markerchar=l;
run;

/*
options nonumber nodate;
ods proctitle off;

ods pdf body="fPearlJ.pdf" style=PearlJ startpage=never;
title "PearlJ";
proc means data=sashelp.class maxdec=2;
run;

proc sgplot data=sashelp.class;
   vbar age / group=sex;
run;
ods pdf close;
*/

proc template;
   %let m = circle square diamond asterisk plus triangle circlefilled
            starfilled squarefilled diamondfilled trianglefilled;
   %let ls = 1 4 8 5 14 26 15 20 41 42 2;
   %macro makestyle;
      %let l = %eval(%sysfunc(mod(&k,12))+1);
      %let k = %eval(&k+1);
      style GraphData&k from GraphData&l /
            linestyle=%scan(&ls, &j) markersymbol="%scan(&m, &i)";
      %mend;
   define style styles.HTMLBlueL;
      parent=styles.htmlbluecml;
      style GraphFit2 from GraphFit2 / linestyle = 1;
      %macro htmlbluel;
         %let k = 0;
         %do i = 1 %to 11; %do j = 1 %to 11; %makestyle %end; %end;
         %mend;
      %htmlbluel
      end;
   define style styles.HTMLBlueM;
      parent=styles.htmlbluecml;
      style GraphFit2 from GraphFit2 / linestyle = 1;
      %macro htmlbluem;
         %let k = 0;
         %do j = 1 %to 11; %do i = 1 %to 11; %makestyle %end; %end;
         %mend;
      %htmlbluem
      end;
   %let m = circlefilled starfilled squarefilled diamondfilled trianglefilled;
   define style styles.HTMLBlueFL;
      parent=styles.htmlbluecml;
      style GraphFit2 from GraphFit2 / linestyle = 1;
      %macro htmlbluel;
         %let k = 0;
         %do i = 1 %to 5; %do j = 1 %to 11; %makestyle %end; %end;
         %mend;
      %htmlbluel
      end;
   define style styles.HTMLBlueFM;
      parent=styles.htmlbluecml;
      style GraphFit2 from GraphFit2 / linestyle = 1;
      %macro htmlbluem;
         %let k = 0;
         %do j = 1 %to 11; %do i = 1 %to 5; %makestyle %end; %end;
         %mend;
      %htmlbluem
   end;
run;

proc sgplot data=x2;
   title 'Colors, Markers, Lines Patterns for Groups';
   series  y=y x=x / group=group markers;
   scatter y=y x=z / group=group markerchar=l;
run;

ods graphics on;
*
ods html style=htmlblue; * You can instead specify other destinations
                           such as LISTING, PDF, or RTF;
proc transreg data=sashelp.Gas plots=fit(nocli noclm);
   model identity(nox) = class(Fuel / zero=none) * pbspline(EqRatio);
run;
*
ods html close;

%modstyle(parent=statistical, name=StatColor, linestyles=solid, type=CLM)
*
ods html style=StatColor;
proc transreg data=sashelp.Gas plots=fit(nocli noclm);
   model identity(nox) = class(Fuel / zero=none) * pbspline(EqRatio);
run;
*
ods html close;

data x;
   do g = 1 to 12;
      do x = 1 to 10;
         y = 13 - g + sin(x * 0.1 * g);
         output;
      end;
   end;
run;

%modstyle(name=markstyle, parent=statistical, type=CLM,
          markers=star plus circle square diamond starfilled
                  circlefilled squarefilled diamondfilled)

*
ods html style=markstyle; * You can instead specify other destinations
                            such as LISTING, PDF, or RTF;
proc sgplot;
   title 'Modified Marker List';
   loess y=y x=x / group=g;
run;
*
ods html close;

%modstyle(name=linestyle, parent=statistical, type=CLM,
          linestyles=Solid LongDash MediumDash Dash ShortDash Dot ThinDot)

*
ods html style=linestyle; * You can instead specify other destinations
                            such as LISTING, PDF, or RTF;
proc sgplot;
   title 'Modified Line Style List';
   loess y=y x=x / group=g;
run;
*
ods html close;

/*
proc template;
   source styles.markstyle;
   source styles.linestyle;
run;
*/

/*
proc template;
   source Styles.HTMLBlue / expand;
run;
*/

proc template;
   define style Styles.NewStyle;
      parent=Styles.Statistical;
      class GraphFonts  /
         'GraphAnnoFont'     = ("<MTserif>, Times New Roman",10pt)
         'GraphDataFont'     = ("<MTserif>, Times New Roman", 7pt)
         'GraphUnicodeFont'  = ("<MTserif>, Times New Roman", 9pt)
         'GraphValueFont'    = ("<MTserif>, Times New Roman", 9pt)
         'GraphLabel2Font'   = ("<MTserif>, Times New Roman",10pt)
         'GraphLabelFont'    = ("<MTserif>, Times New Roman",10pt)
         'GraphFootnoteFont' = ("<MTserif>, Times New Roman",10pt)
         'GraphTitleFont'    = ("<MTserif>, Times New Roman",11pt)
         'GraphTitle1Font'   = ("<MTserif>, Times New Roman",14pt)
         'NodeTitleFont'     = ("<MTserif>, Times New Roman", 9pt)
         'NodeLabelFont'     = ("<MTserif>, Times New Roman", 9pt)
         'NodeLinkLabelFont' = ("<MTserif>, Times New Roman", 9pt)
         'NodeInputLabelFont'= ("<MTserif>, Times New Roman", 9pt)
         'NodeDetailFont'    = ("<MTserif>, Times New Roman", 7pt);
   end;
run;

data stack;
   input x1 x2 x3 y @@;
   datalines;
80 27 89 42   80 27 88 37   75 25 90 37   62 24 87 28   62 22 87 18
62 23 87 18   62 24 93 19   62 24 93 20   58 23 87 15   58 18 80 14
58 18 89 14   58 17 88 13   58 18 82 11   58 19 93 12   50 18 89  8
50 18 86  7   50 19 72  8   50 19 79  8   50 20 80  9   56 20 82 15
70 20 91 15
;

*
ods html style=HTMLBlue;
proc robustreg data=stack plots=qqplot;
   ods select QQPlot;
   model y = x1 x2 x3;
run;
/*
ods html close;

ods html style=NewStyle;
proc robustreg data=stack plots=qqplot;
   ods select QQPlot;
   model y = x1 x2 x3;
run;
ods html close;
*/

/*
proc template;
   source styles.HTMLBlue;
run;
*/

/*
proc template;
   source Styles.HTMLBlue / expand;
run;
*/

proc template;
   define style Styles.NewStyle;
      parent=Styles.Statistical;
      class GraphFonts  /
         'GraphAnnoFont'     = ("<MTserif>, Times New Roman",10pt)
         'GraphDataFont'     = ("<MTserif>, Times New Roman", 7pt)
         'GraphUnicodeFont'  = ("<MTserif>, Times New Roman", 9pt)
         'GraphValueFont'    = ("<MTserif>, Times New Roman", 9pt)
         'GraphLabel2Font'   = ("<MTserif>, Times New Roman",10pt)
         'GraphLabelFont'    = ("<MTserif>, Times New Roman",10pt)
         'GraphFootnoteFont' = ("<MTserif>, Times New Roman",10pt)
         'GraphTitleFont'    = ("<MTserif>, Times New Roman",11pt)
         'GraphTitle1Font'   = ("<MTserif>, Times New Roman",14pt)
         'NodeTitleFont'     = ("<MTserif>, Times New Roman", 9pt)
         'NodeLabelFont'     = ("<MTserif>, Times New Roman", 9pt)
         'NodeLinkLabelFont' = ("<MTserif>, Times New Roman", 9pt)
         'NodeInputLabelFont'= ("<MTserif>, Times New Roman", 9pt)
         'NodeDetailFont'    = ("<MTserif>, Times New Roman", 7pt);
      class GraphReference / linethickness=4px;
   end;
run;

/*
ods html style=NewStyle;
ods graphics on;

proc robustreg data=stack plots=qqplot;
   ods select QQPlot;
   model y = x1 x2 x3;
run;
ods html close;
*/
