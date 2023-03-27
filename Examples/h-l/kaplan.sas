/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: KAPLAN                                              */
/*   TITLE: Kaplan-Meier Plot Modification Examples             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods, survival analysis, Kaplan-Meier      */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2013         */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES:                                                     */
/****************************************************************/

ods select where=(_path_ ? 'Print' or _path_ ? 'Plot')(persist);
proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival  /
      store=sasuser.templat;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival2 /
      store=sasuser.templat;
run;

ods graphics on;

proc lifetest data=sashelp.BMT;
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival;
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(strata=individual);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(strata=panel);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(cb=ep test);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(cb=all test);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(cb=hw test atrisk);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(cb=hw test atrisk(maxlen=13));
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT
              plots=survival(atrisk(maxlen=13 outside(0.15)));
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT
              plots=survival(atrisk(maxlen=13 outside)=0 to 3000 by 1000);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(atrisk
   (atrisktick maxlen=13 outside)=0 500 750 1000 1250 1500 1750 2000 2500);
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT plots=survival(atrisk
   (atrisktickonly maxlen=13 outside)=0 1250 2500);
   time T * Status(0);
   strata Group;
run;

proc format;
   invalue bmtnum   'AML-Low Risk' = 1  'ALL' = 2  'AML-High Risk' = 3;
   value   bmtfmt   1 = 'AML-Low Risk'  2 = 'ALL'  3 = 'AML-High Risk';
run;

data BMT(drop=g);
   set sashelp.BMT(rename=(group=g));
   Group = input(g, bmtnum.);
run;

proc lifetest data=BMT plots=survival(cl test atrisk(maxlen=13));
   time T * Status(0);
   strata Group / order=internal;
   format group bmtfmt.;
run;

proc format;
   invalue bmtnum 'ALL' = 1  'AML-Low Risk' = 2  'AML-High Risk' = 3;
   value   bmtfmt 1 = 'ALL'  2 = 'AML-Low Risk'  3 = 'AML-High Risk';
run;

data BMT(drop=g);
   set sashelp.BMT(rename=(group=g));
   Group = input(g, bmtnum.);
run;

proc lifetest data=BMT plots=survival(cl test atrisk(maxlen=13));
   time T * Status(0);
   strata Group / order=internal;
   format group bmtfmt.;
run;

proc lifetest data=sashelp.BMT
              plots=survival(nocensor test atrisk(maxlen=13));
   time T * Status(0);
   strata Group;
run;

proc lifetest data=sashelp.BMT
     plots=survival(cb=hw failure test atrisk(maxlen=13));
   time T * Status(0);
   strata Group;
run;

ods trace on;
proc lifetest data=sashelp.BMT
   plots=survival(cb=hw failure test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

proc template;
   delete Stat.Lifetest.Graphics.ProductLimitFailure2;
   source Stat.Lifetest.Graphics.ProductLimitFailure2 / file='tpl.tpl';
quit;

data _null_;                                        /* Standard boilerplate   */
   infile 'tpl.tpl' end=eof;                        /* Standard boilerplate   */
   input;                                           /* Standard boilerplate   */
   if _n_ eq 1 then call execute('proc template;'); /* Standard boilerplate   */
   _infile_ = tranwrd(_infile_, 'viewmax=1',        /* Customization: var =   */
                                'viewmax=0.8');     /* tranwrd(var, from, to);*/
   call execute(_infile_);                          /* Standard boilerplate   */
   if eof then call execute('quit;');               /* Standard boilerplate   */
run;                                                /* Standard boilerplate   */

proc template;
   source Stat.Lifetest.Graphics.ProductLimitFailure2 / store=sasuser.templat;
quit;

proc template;
   source Stat.Lifetest.Graphics.ProductLimitFailure2 /
     store=sasuser.templat file='tplmod.tpl';
quit;

proc lifetest data=sashelp.BMT
   plots=survival(cb=hw failure test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

data _null_;
   infile 'tpl.tpl' end=eof;
   input;
   if _n_ eq 1 then call execute('proc template;');
   _infile_ = tranwrd(_infile_, 'viewmax=1', 'viewmax=100');
   _infile_ = tranwrd(_infile_, 'tickvaluelist=(0 .2 .4 .6 .8 1.0)',
                     'tickvaluelist=(0 20 40 60 80 100)');
   _infile_ = tranwrd(_infile_, '1-', '100-100*');
   _infile_ = tranwrd(_infile_, 'Failure Probability', 'Failure Percentage');
   call execute(_infile_);
   if eof then call execute('quit;');
run;

proc lifetest data=sashelp.BMT
   plots=survival(cb=hw failure test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

data _null_;
   %let url = //support.sas.com/documentation/onlinedoc/stat/ex_code/151;
   infile "http:&url/templft.html" device=url;

   file 'macros.tmp';
   retain pre 0;
   input;
   _infile_ = tranwrd(_infile_, '&amp;', '&');
   _infile_ = tranwrd(_infile_, '&lt;' , '<');
   if index(_infile_, '</pre>') then pre = 0;
   if pre then put _infile_;
   if index(_infile_, '<pre>')  then pre = 1;
run;

%inc 'macros.tmp' / nosource;

%ProvideSurvivalMacros

%CompileSurvivalTemplates

proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival  /
          store=sasuser.templat;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival2 /
          store=sasuser.templat;
run;

/*-- Original Macro Variable Definitions ----------------------------------
%let TitleText0 = METHOD " Survival Estimate";
%let TitleText1 = &titletext0 " for " STRATUMID;
%let TitleText2 = &titletext0 "s";
-------------------------------------------------------------------------*/

                                          /* Make the macros and macro      */
%ProvideSurvivalMacros                    /* variables available.           */

%let TitleText0 = "Kaplan-Meier Plot";    /* Change the title.              */
%let TitleText1 = &titletext0 " for " STRATUMID;
%let TitleText2 = &titletext0;

%CompileSurvivalTemplates                 /* Compile the templates with     */
                                          /* the new title.                 */

proc lifetest data=sashelp.BMT            /* Perform the analysis and make  */
              plots=survival(cb=hw test); /* the graph.                     */
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros                    /* Optionally restore the default */
                                          /* macros and macro variables.    */

proc template;                            /* Delete the modified templates. */
   delete Stat.Lifetest.Graphics.ProductLimitSurvival  / store=sasuser.templat;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival2 / store=sasuser.templat;
run;

/*-- Original Macro Variable Definitions ----------------------------------
%let yOptions   = label="Survival Probability" shortlabel="Survival"
                  linearopts=(viewmin=0 viewmax=1
                              tickvaluelist=(0 .2 .4 .6 .8 1.0));
-------------------------------------------------------------------------*/

%ProvideSurvivalMacros

%let yOptions = label="Survival"
                linearopts=(viewmin=0 viewmax=1
                            tickvaluelist=(0 .25 .5 .75 1));

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let yOptions = label="Survival"
                linearopts=(viewmin=0.2 viewmax=1
                            tickvaluelist=(0 .2 .4 .6 .8 1.0));

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let StepOpts = lineattrs=(thickness=2.5);

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let GraphOpts = DataContrastColors=(green red blue)
                 DataColors=(green red blue);

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let GraphOpts = attrpriority=none
                 DataLinePatterns=(ShortDash MediumDash LongDash);

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

/*-- Original Macro Variable Definitions ----------------------------------
%let TitleText0 = METHOD " Survival Estimate";
%let TitleText1 = &titletext0 " for " STRATUMID;
%let TitleText2 = &titletext0 "s";
%let yOptions   = label="Survival Probability"
                  shortlabel="Survival"
                  linearopts=(viewmin=0 viewmax=1
                              tickvaluelist=(0 .2 .4 .6 .8 1.0));
%let xOptions   = shortlabel=XNAME
                  offsetmin=.05
                  linearopts=(viewmax=MAXTIME tickvaluelist=XTICKVALS
                              tickvaluefitpolicy=XTICKVALFITPOL);
-------------------------------------------------------------------------*/

%let tatters    = textattrs=(size=12pt weight=bold family='arial');
%let TitleText0 = METHOD " Survival Estimate";
%let TitleText1 = &titletext0 " for " STRATUMID / &tatters;
%let TitleText2 = &titletext0 "s" / &tatters;

%let yOptions   = label="Survival Probability"
                  shortlabel="Survival"
                  labelattrs=(size=10pt weight=bold)
                  tickvalueattrs=(size=8pt)
                  linearopts=(viewmin=0 viewmax=1
                              tickvaluelist=(0 .2 .4 .6 .8 1.0));

%let xOptions   = shortlabel=XNAME
                  offsetmin=.05
                  labelattrs=(size=10pt weight=bold)
                  tickvalueattrs=(size=8pt)
                  linearopts=(viewmax=MAXTIME tickvaluelist=XTICKVALS
                              tickvaluefitpolicy=XTICKVALFITPOL);

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros
/*-- Original Macro Variable Definitions ----------------------------------
%let InsetOpts  = autoalign=(TOPRIGHT BOTTOMLEFT TOP BOTTOM)
                  border=true BackgroundColor=GraphWalls:Color Opaque=true;
%let LegendOpts = title=GROUPNAME location=outside;
-------------------------------------------------------------------------*/

%let InsetOpts  = autoalign=(BottomRight)
                  border=true BackgroundColor=GraphWalls:Color Opaque=true;
%let LegendOpts = title=GROUPNAME location=inside across=1 autoalign=(TopRight);
%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

/*-- Original Macro Variable Definitions ----------------------------------
%let Censored   = markerattrs=(symbol=plus);
%let CensorStr  = "+ Censored";
-------------------------------------------------------------------------*/

%ProvideSurvivalMacros

%let censored  = markerattrs=(symbol=circlefilled size=3px);
%let censorstr = "(*ESC*){Unicode '25cf'x} Censored"
                 / textattrs=GraphValueText(family=GraphUnicodeText:FontFamily);

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros
%macro StmtsTop;
   referenceline y=0.5;
%mend;
%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let yoptions = &yoptions griddisplay=on;

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%macro pValue;
   if (PVALUE < .0001)
      entry "Log Rank p "   eval (PUT(PVALUE, PVALUE6.4));
   else
      entry "Log Rank p = " eval (PUT(PVALUE, PVALUE6.4));
   endif;
%mend;

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival  /
          store=sasuser.templat;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival2 /
          store=sasuser.templat;
run;

%ProvideSurvivalMacros

%let ntitles = 1;
%macro StmtsBeginGraph;
   *
   entryfootnote halign=left "Acme Company, %sysfunc(date(),worddate.)" /
                 textattrs=GraphDataText;
   entryfootnote halign=left "Acme Company, July 25, 2013" /
                 textattrs=GraphDataText;
%mend;

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let ntitles = 1;

%macro StmtsBeginGraph;
*
entrytitle "Acme Company, %sysfunc(date(),worddate.)" /textattrs=GraphValueText;
entrytitle "Acme Company, July 25, 2013" / textattrs=GraphValueText;
%mend;

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
   plots=survival(cb=hw test);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%macro StmtsBeginGraph;
  * Coordinates are ad hoc, and there are many available coordinate systems.
    See the documentation for more information.;
  drawtext textattrs=(weight=Bold) 'Number at Risk' / x=5 y=14 width=9;
%mend;

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(atrisk outside maxlen=13);
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let TitleText2 = "Kaplan-Meier Plot";
%let LegendOpts = title="+ Censored"
                  location=inside autoalign=(Bottom);
%let InsetOpts  = ;

%macro StmtsBottom;
   dynamic %do i = 1 %to 3; StrVal&i NObs&i NEvent&i %end;;
   layout gridded / columns=3 border=TRUE autoalign=(TopRight);
      entry ""; entry "Event"; entry "Total";
      %do i = 1 %to 3;
         %let t = / textattrs=GraphData&i;
         entry halign=right Strval&i &t; entry NEvent&i &t; entry NObs&i &t;
      %end;
   endlayout;
%mend;

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT plots=survival(cb=hw atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let GraphOpts = DesignHeight=DefaultDesignWidth;

%SurvivalSummaryTable

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

%ProvideSurvivalMacros

%let GraphOpts  = DesignHeight=500px;
%let LegendOpts = ;

%SurvivalSummaryTable

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw atrisk(maxlen=13));
   time T * Status(0);
   strata Group;
run;

proc format;
   invalue bmtnum 'ALL' = 1  'AML-Low Risk' = 2  'AML-High Risk' = 3;
   value   bmtfmt 1 = 'ALL'  2 = 'AML-Low Risk'  3 = 'AML-High Risk';
run;

data BMT(drop=g);
   set sashelp.BMT(rename=(group=g));
   Group = input(g, bmtnum.);
run;

%ProvideSurvivalMacros

%let TitleText2 = "Kaplan-Meier Plot";
%let nTitles    = 1;
%let GraphOpts  = DesignHeight=500px;
%let LegendOpts = ;
%let InsetOpts  = ;

%SurvivalSummaryTable

%CompileSurvivalTemplates

proc lifetest data=BMT plots=survival(cb=hw atrisk(maxlen=13));
   time T * Status(0);
   strata Group / order=internal;
   format group bmtfmt.;
run;

proc format;
   invalue bmtnum 'ALL' = 1  'AML-Low Risk' = 2  'AML-High Risk' = 3;
   value   bmtfmt 1 = 'ALL'  2 = 'AML-Low Risk'  3 = 'AML-High Risk';
run;

data BMT(drop=g);
   set sashelp.BMT(rename=(group=g));
   Group = input(g, bmtnum.);
run;

%ProvideSurvivalMacros

%let TitleText2 = "Kaplan-Meier Plot";
%let nTitles    = 1;
%let GraphOpts  = DesignHeight=500px;
%let LegendOpts = ;
%let InsetOpts  = ;

%SurvivalSummaryTable

%CompileSurvivalTemplates

proc template;
   source Stat.Lifetest.Graphics.ProductLimitSurvival / file='temp.tmp';
quit;

data _null_;
   length var stmt $ 32;
   infile 'temp.tmp' end=eof;
   input;
   if _n_ eq 1 then call execute('proc template;');
   stmt = scan(_infile_, 1);
   if stmt in ('scatterplot', 'stepplot', 'bandplot') then do;
      var = scan(scan(_infile_, 2, '='), 1);
      _infile_ = tranwrd(_infile_, trim(var), cats('eval(100*',var,')'));
      if stmt = 'bandplot' then do;
         var = scan(scan(_infile_, 3, '='), 1);
         _infile_ = tranwrd(_infile_, trim(var), cats('eval(100*',var,')'));
      end;
   end;
   _infile_ = tranwrd(_infile_, 'Survival Probability', 'Survival Percentage');
   _infile_ = tranwrd(_infile_, '0 .2 .4 .6 .8 1.0', '0 20 40 60 80 100');
   _infile_ = tranwrd(_infile_, 'viewmax=1', 'viewmax=100');
   call execute(_infile_);
   if eof then call execute('quit;');
run;

proc lifetest data=BMT plots=survival(cb=hw atrisk(maxlen=13));
   time T * Status(0);
   strata Group / order=internal;
   format group bmtfmt.;
run;

%ProvideSurvivalMacros

proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival  /
          store=sasuser.templat;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival2 /
          store=sasuser.templat;
run;

proc format;
   value $dfmt "AML-Low Risk"  = "AML(*ESC*){Unicode '2014'x}Low Risk"
               "AML-High Risk" = "AML(*ESC*){Unicode '2014'x}High Risk";
run;

ods graphics on;
proc lifetest data=sashelp.BMT plots=survival(cb=hw atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
   format group $dfmt.;
run;

proc lifetest data=sashelp.BMT plots=survival(cb=hw atrisk(outside maxlen=13));
   time T * Status(0);
   strata / group=Group;
   format group $dfmt.;
run;

ods document name=MyDoc (write);
proc lifetest data=sashelp.BMT plots=survival(cb=hw atrisk(outside maxlen=13));
   ods output survivalplot=sp;
   time T * Status(0);
   strata Group;
run;
ods document close;

proc document name=MyDoc;
   list / levels=all;
quit;

proc document name=MyDoc;
   ods output dynamics=dynamics;
   obdynam \Lifetest#1\SurvivalPlot#1;
quit;

data _null_;
   set dynamics(where=(label1 ne '___NOBS___')) end=eof;
   if _n_ = 1 then
      call execute('proc sgrender data=sp
                    template=Stat.Lifetest.Graphics.ProductLimitSurvival2;
                    format stratum $dfmt.;
                    dynamic');
   if cvalue1 ne ' ' then
      call execute(catx(' ', label1, '=',
                   ifc(n(nvalue1), cvalue1, quote(trim(cvalue1)))));
   if eof then call execute('; run;');
run;

data bmt;
   set sashelp.bmt;
   s1 = scan(group, 1, '-');
   s2 = scan(group, 2, '-');
   if s2 ne ' ' then s1 = cats(s1,'-');
   else              s2 = 'ALL';
run;

proc lifetest data=BMT plots=survival(cb=hw atrisk(outside maxlen=13));
   ods output survivalplot=sp;
   time T * Status(0);
   strata s1 s2;
run;

proc format;
   value $d2fmt '1: s1=ALL s2=ALL'= 'ALL'
                "2: s1=AML- s2=High Risk" =
                "AML (*ESC*){Unicode '2014'x} High(*ESC*){Unicode '2012'x}Risk"
                "3: s1=AML- s2=Low Risk"  =
                "AML (*ESC*){Unicode '2014'x} Low(*ESC*){Unicode '2012'x}Risk";

run;

ods document name=MyDoc (write);
proc lifetest data=BMT plots=survival(cb=hw atrisk(outside maxlen=16));
   ods output survivalplot=sp;
   time T * Status(0);
   strata s1 s2;
run;
ods document close;

proc document name=MyDoc;
   ods output dynamics=dynamics;
   obdynam \Lifetest#1\SurvivalPlot#1;
quit;

data _null_;
   set dynamics(where=(label1 ne '___NOBS___')) end=eof;
   if _n_ = 1 then
      call execute('proc sgrender data=sp
                    template=Stat.Lifetest.Graphics.ProductLimitSurvival2;
                    format stratum $d2fmt.;
                    dynamic');
   if label1 eq 'CLASSATRISK' then cvalue1 = 'Stratum';
   if cvalue1 ne ' ' then
      call execute(catx(' ', label1, '=',
                   ifc(n(nvalue1), cvalue1, quote(trim(cvalue1)))));
   if eof then call execute('; run;');
run;

*
ods html style=htmlbluecml image_dpi=300;
proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;
*
ods html close;

proc template;
   define style styles.ListingColor;
      parent = styles.Listing;
      style Graph from Graph / attrpriority = "Color";
   end;
run;

*
ods html style=ListingColor image_dpi=300;
proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;
*
ods html close;

proc template;
   source styles.statistical / file='style.tmp';
run;

data colors;
   length element Color $ 20;
   infile 'style.tmp';
   input;
   if index(_infile_, 'data') then do;
      element = scan(_infile_, 1, ' ');
      Color = scan(_infile_, 3, ' ;');
      Type = ifc(index(element, 'gc'), 'Line', 'Fill') || ' Colors';
      i = input(compress(element, 'gcdat'';'), ?? 2.);
      if i then output;
   end;
run;

proc sort; by descending type i; run;

proc print; id type; by descending type; var color; run;

data display;
   array y[12] y1 - y12;
   do i = 1 to 12; y[i] = i;      end;
   do x = 1 to 10; output;        end;
   do i = 1 to 12; y[i] = i + .5; end;
   do x = 1 to 10; output;        end;
run;

data _null_;
   set colors;
   call symputx(compress(type || put(i, 2.)), color);
run;

proc sgplot noautolegend data=display;
   %macro reg;
      title 'Line and Fill Colors, Respectively';
      %do i = 1 %to 12;
         reg y=y%eval(13-&i) x=x / lineattrs=GraphData&i clmattrs=GraphData&i
                      nomarkers clm  curvelabelpos=max
                      curvelabel="  GraphData&i &&LineColors&i &&FillColors&i";
      %end;
   %mend;
   %reg
   xaxis display=none;
   yaxis display=none;
run;

title;

%ProvideSurvivalMacros

%let GraphOpts = DataContrastColors=(cx01665E cxA23A2E cx445694)
                 DataColors=(cx66A5A0 cxD05B5B cx6F7EB3);

%CompileSurvivalTemplates

proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;

%macro reorder(from, to, list);

   proc template;
      define style styles.&to;
         parent=styles.&from;
         %do i = 1 %to 12;
            %let s = %scan(&list, &i);
            %if &s ne %then %do;
               style GraphData&i from GraphData&i /
                     contrastcolor = GraphColors("gcdata&s")
                     color = GraphColors("gdata&s");
            %end;
         %end;
      end;
   run;

%mend;

%reorder(htmlblue,   /* Parent style.                               */
         MyStyle,    /* New style to create.  Specify it in an ODS  */
                     /* destination statement.                      */
         3 2 1)      /* Replace the first few GraphData colors      */
                     /* (1 2 3) with the colors from the specified  */
                     /* GraphData style elements (3 2 1).           */
                     /* You can specify up to 12 integers in the    */
                     /* range 1 - 12.                               */

*
ods html style=mystyle;
proc lifetest data=sashelp.BMT
              plots=survival(cb=hw test atrisk(outside maxlen=13));
   time T * Status(0);
   strata Group;
run;
*
ods html close;

proc template;
   define style Styles.MyStyle;
      parent = styles.htmlblue;
      style GraphData1 from GraphData1 /
         color = GraphColors('gdata3')
         contrastcolor = GraphColors('gcdata3');
      style GraphData2 from GraphData2 /
         color = GraphColors('gdata2')
         contrastcolor = GraphColors('gcdata2');
      style GraphData3 from GraphData3 /
         color = GraphColors('gdata1')
         contrastcolor = GraphColors('gcdata1');
   end;
run;

proc template;
   define style Styles.MyStyle;
      parent = styles.htmlblue;
      style GraphData1 from GraphData1 /
         color = cx66A5A0
         contrastcolor = cx01665E;
      style GraphData2 from GraphData2 /
         color = cxD05B5B
         contrastcolor = cxA23A2E;
      style GraphData3 from GraphData3 /
         color = cx6F7EB3
         contrastcolor = cx445694;
   end;
run;

proc template;
   delete Styles.MyStyle / store=sasuser.templat;
run;

proc template;
   source styles.htmlblue / expand file='style.tmp';
run;

data _null_;
   infile 'style.tmp' pad;
   input line $char80.;
   file print;
   if index(lowcase(line), ' graphfonts ') then y + 1;
   if y then put line $char80.;
   if y and index(line, ';') then stop;
run;

proc template;
   define style Styles.BigFont;
      parent = Styles.HTMLBlue;
      style graphfonts from graphfonts /
         'GraphLabelFont' = ("<sans-serif>, <MTsans-serif>",12pt,bold)
         'GraphValueFont' = ("<sans-serif>, <MTsans-serif>",8pt,bold);
   end;
run;

*
ods html style=BigFont;
proc lifetest data=sashelp.BMT plots=survival(maxlen=13 atrisk);
   time T * Status(0);
   strata Group;
run;
*
ods html close;

proc template;
   delete Styles.BigFont / store=sasuser.templat;
run;

proc template;
   source styles.htmlblue / expand file='style.tmp';
run;

data _null_;
   infile 'style.tmp' pad;
   input line $char80.;
   file print;
   if index(lowcase(line), ' graphdata1 ') then y + 1;
   if y then put line $char80.;
   if y and index(line, ';') then stop;
run;

proc template;
   source styles / file='style.tmp';
run;

data _null_;
   infile 'style.tmp' pad;
   length style $ 80;
   retain style;
   input line $char80.;
   file print;
   if index(lowcase(line), 'define style') then style = line;
   if index(lowcase(line), ' graphfonts ') then do;
      y + 1;
      put style $char80.;
   end;
   if y then put line $char80.;
   if index(line, ';') then y = 0;;
run;

proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival  /
      store=sasuser.templat;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival2 /
      store=sasuser.templat;
   delete Styles.ListingColor / store=sasuser.templat;
run;

