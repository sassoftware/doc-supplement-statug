/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFTSSS                                             */
/*   TITLE: Displaying Summary Statistics in the Survival Plot  */
/*          Using ODS Graphics.                                 */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survival plot, summary statistics                   */
/*   PROCS: LIFETEST                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC LIFETEST documentation                         */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
 PROC LIFETEST passes a number of summary statistics as dynamic
 variables to the ODS Graphics for survival plots (see the Section
 "Additional Dynamic Variables for Survival Plots Using ODS
 Graphics" in the LIFETEST documentation). In this example, the
 graphical template (Stat.LIFETEST.Graphics.ProductLimitSurvival)
 for displaying the product-limit survival curves is modified
 to accomodate the display of the summary statistics. One can
 download Stat.Graphics.ProductLimitSurvival to the log by
 running PROC TEMPLATE as follows:

 proc template;
    source Stat.Lifetest.Graphics.ProductLimitSurvival;
 run;

 The lattice layout is used to display the survival curves in the
 plotting area and the summary statistics in the Columnheader area.
 Summary statistics are displayed using the macro
 %ProductLimitStat(n=,fmt=), where n= specifies the number of
 strata, and fmt= specifies a format for displaying the median
 survival and the corresponding confidence limits. By default,
 fmt=F6.1.

 A note of caution. After you run PROC TEMPLATE with the change,
 the new template is stored in your sasuser directory. If you
 want to restore to the original template, you can use PROC
 template as follows:

 proc template;
    delete  Stat.Lifetest.Graphics.ProductLimitSurvival;
 run;
 *****************************************************************/

%macro ProductLimitStat(n=,fmt=F6.1);
   dynamic PctMedianConfid;
   %if &n=1 %then %do;
      dynamic NObs NEvent Median LowerMedian UpperMedian;
   %end;
   %else %do;
      %do i=1 %to &n;
        dynamic StrVal&i NObs&i NEvent&i Median&i LowerMedian&i UpperMedian&i;;
      %end;
   %end;

   %if &n=1 %then %let ncol=4;
   %else          %let ncol=5;

   layout overlay / pad=(top=5);
      layout gridded / columns=&ncol border=TRUE;
         %if &n>1 %then entry " ";;
         entry "No. of Subjects";
         entry "Event";
         entry "Censored";
         entry "Median Survival (" PctMedianConfid " CL)";
         %do i=1 %to &n;
            %if &n=1 %then %do;
               entry NObs;
               entry NEvent;
               entry eval(NObs-NEvent);
               entry eval(put(Median,&fmt)) " ( "
                     eval(put(LowerMedian,&fmt)) " "
                     eval(put(UpperMedian,&fmt)) " )";
            %end;
            %else %do;
               entry halign=left StrVal&i;
               entry NObs&i;
               entry NEvent&i;
               entry eval(NObs&i-NEvent&i);
               entry eval(put(Median&i,&fmt)) " ( "
                     eval(put(LowerMedian&i,&fmt)) " "
                     eval(put(UpperMedian&i,&fmt)) " )";
            %end;
         %end;
      endlayout;
   endlayout;
%mend ProductLimitStat;


proc template ;

/* modified Stat.Lifetest.Graphics.ProductLimitSurvival template */
define statgraph Stat.Lifetest.Graphics.ProductLimitSurvival;
   dynamic NStrata xName plotAtRisk plotCensored plotCL plotHW plotEP labelCL
      labelHW labelEP maxTime StratumID classAtRisk plotBand plotTest
      GroupName yMin Transparency SecondTitle TestName pValue;
   BeginGraph;
      if (NSTRATA=1)
         if (EXISTS(STRATUMID))
            entrytitle "Product-Limit Survival Estimate" " for " STRATUMID;
         else
            entrytitle "Product-Limit Survival Estimate";
         endif;
         if (PLOTATRISK)
            entrytitle "with Number of Subjects at Risk" / textattrs=
            GRAPHVALUETEXT;
         endif;
         layout lattice / rows=1 columns=1;
         layout overlay / xaxisopts=(shortlabel=XNAME offsetmin=.05 linearopts=(
            viewmax=MAXTIME)) yaxisopts=(label="Survival Probability" shortlabel
              ="Survival" linearopts=(viewmin=0 viewmax=1 tickvaluelist=(0 .2 .4
               .6 .8 1.0)));
               if (PLOTHW=1 AND PLOTEP=0)
                bandplot LimitUpper=HW_UCL LimitLower=HW_LCL x=TIME / modelname=
                  "Survival" fillattrs=GRAPHCONFIDENCE name="HW" legendlabel=
                  LABELHW;
               endif;
               if (PLOTHW=0 AND PLOTEP=1)
                bandplot LimitUpper=EP_UCL LimitLower=EP_LCL x=TIME / modelname=
                  "Survival" fillattrs=GRAPHCONFIDENCE name="EP" legendlabel=
                  LABELEP;
               endif;
               if (PLOTHW=1 AND PLOTEP=1)
                bandplot LimitUpper=HW_UCL LimitLower=HW_LCL x=TIME / modelname=
                  "Survival" fillattrs=GRAPHDATA1 datatransparency=.55 name="HW"
                  legendlabel=LABELHW;
               bandplot LimitUpper=EP_UCL LimitLower=EP_LCL x=TIME / modelname=
                  "Survival" fillattrs=GRAPHDATA2 datatransparency=.55 name="EP"
                  legendlabel=LABELEP;
               endif;
               if (PLOTCL=1)
                  if (PLOTHW=1 OR PLOTEP=1)
               bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME / modelname
               ="Survival" display=(outline) outlineattrs=GRAPHPREDICTIONLIMITS
                     name="CL" legendlabel=LABELCL;
                  else
               bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME / modelname
                    ="Survival" fillattrs=GRAPHCONFIDENCE name="CL" legendlabel=
                     LABELCL;
                  endif;
               endif;
             stepplot y=SURVIVAL x=TIME / name="Survival" rolename=(_tip1=ATRISK
                 _tip2=EVENT) tip=(y x Time _tip1 _tip2) legendlabel="Survival";
               if (PLOTCENSORED=1)
                 scatterplot y=CENSORED x=TIME / markerattrs=(symbol=plus) name=
                  "Censored" legendlabel="Censored";
               endif;
               if (PLOTCL=1 OR PLOTHW=1 OR PLOTEP=1)
                  discretelegend "Censored" "CL" "HW" "EP" / location=outside
                  halign=center;
               else
                  if (PLOTCENSORED=1)
                 discretelegend "Censored" / location=inside autoalign=(topright
                     bottomleft);
                  endif;
               endif;
               if (PLOTATRISK=1)
                  innermargin / align=bottom;
                blockplot x=TATRISK block=ATRISK / repeatedvalues=true display=(
                     values) valuehalign=start valuefitpolicy=truncate
                     labelposition=left labelattrs=GRAPHVALUETEXT valueattrs=
                     GRAPHDATATEXT (size=7pt) includemissingclass=false;
                  endinnermargin;
               endif;
            endlayout;
            columnheaders;
               %ProductLimitStat(n=1);
            endcolumnheaders;
         endlayout;
      else
         entrytitle "Product-Limit Survival Estimates";
         if (EXISTS(SECONDTITLE))
            entrytitle SECONDTITLE / textattrs=GRAPHVALUETEXT;
         endif;
         layout lattice / rows=1 columns=1;
        layout overlay / xaxisopts=(shortlabel=XNAME offsetmin=.05 linearopts=(
            viewmax=MAXTIME)) yaxisopts=(label="Survival Probability" shortlabel
              ="Survival" linearopts=(viewmin=0 viewmax=1 tickvaluelist=(0 .2 .4
                .6 .8 1.0)));
               if (PLOTHW)
                  bandplot LimitUpper=HW_UCL LimitLower=HW_LCL x=TIME / group=
                 STRATUM index=STRATUMNUM modelname="Survival" datatransparency=
                  Transparency;
               endif;
               if (PLOTEP)
                  bandplot LimitUpper=EP_UCL LimitLower=EP_LCL x=TIME / group=
                 STRATUM index=STRATUMNUM modelname="Survival" datatransparency=
                  Transparency;
               endif;
               if (PLOTCL)
                  if (PLOTBAND)
                  bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME / group=
                STRATUM index=STRATUMNUM modelname="Survival" display=(outline);
               else
                  bandplot LimitUpper=SDF_UCL LimitLower=SDF_LCL x=TIME / group=
                 STRATUM index=STRATUMNUM modelname="Survival" datatransparency=
                  Transparency;
               endif;
               endif;
               stepplot y=SURVIVAL x=TIME / group=STRATUM index=STRATUMNUM name=
                  "Survival" rolename=(_tip1=ATRISK _tip2=EVENT) tip=(y x Time
                  _tip1 _tip2);
               if (PLOTCENSORED)
                  scatterplot y=CENSORED x=TIME / group=STRATUM index=STRATUMNUM
                  markerattrs=(symbol=plus);
               endif;
               if (PLOTATRISK)
                  innermargin / align=bottom;
                  blockplot x=TATRISK block=ATRISK / class=CLASSATRISK
                    repeatedvalues=true display=(label values) valuehalign=start
                     valuefitpolicy=truncate labelposition=left labelattrs=
                     GRAPHVALUETEXT valueattrs=GRAPHDATATEXT (size=7pt)
                     includemissingclass=false;
                     endinnermargin;
               endif;
               DiscreteLegend "Survival" / title=GROUPNAME location=outside;
               if (PLOTCENSORED)
                  if (PLOTTEST)
               layout gridded / rows=2 autoalign=(TOPRIGHT BOTTOMLEFT TOP BOTTOM
                  ) border=true BackgroundColor=GraphWalls:Color Opaque=true;
                  entry "+ Censored";
                  if (PVALUE < .0001)
                     entry TESTNAME " p " eval (PUT(PVALUE, PVALUE6.4));
                  else
                     entry TESTNAME " p=" eval (PUT(PVALUE, PVALUE6.4));
                  endif;
                  endlayout;
                  else
               layout gridded / rows=1 autoalign=(TOPRIGHT BOTTOMLEFT TOP BOTTOM
                  ) border=true BackgroundColor=GraphWalls:Color Opaque=true;
                  entry "+ Censored";
                  endlayout;
               endif;
               else
                  if (PLOTTEST)
               layout gridded / rows=1 autoalign=(TOPRIGHT BOTTOMLEFT TOP BOTTOM
                  ) border=true BackgroundColor=GraphWalls:Color Opaque=true;
                  if (PVALUE < .0001)
                     entry TESTNAME " p " eval (PUT(PVALUE, PVALUE6.4));
                  else
                     entry TESTNAME " p=" eval (PUT(PVALUE, PVALUE6.4));
                  endif;
                  endlayout;
                  endif;
               endif;
            endlayout;
            columnheaders;
                if (NStrata=2) %ProductLimitStat(n=2);endif;
                if (NStrata=3) %ProductLimitStat(n=3);endif;
                if (NStrata=4) %ProductLimitStat(n=4);endif;
                if (NStrata=5) %ProductLimitStat(n=5);endif;
                if (NStrata=6) %ProductLimitStat(n=6);endif;
            endcolumnheaders;
         endlayout;
      endif;
   EndGraph;
end;

run;


proc format;
    value treat 0 = 'standard' 1 = 'test';

data prentice;
    input time state trt cell;
    casenum = _n_;
    label time = 'Survival Time'
          state = '1 = dead, 0 = censored';
    datalines;
 72 1 1 1
411 1 1 1
228 1 1 1
231 0 0 1
242 1 0 1
991 1 0 1
111 1 0 1
  1 1 0 1
587 1 0 1
389 1 0 1
 33 1 0 1
 25 1 0 1
357 1 0 1
467 1 0 1
201 1 0 1
  1 1 0 1
 30 1 0 1
 44 1 0 1
283 1 0 1
 15 1 0 1
 87 0 0 1
112 1 0 1
999 1 0 1
 11 1 1 1
 25 0 1 1
144 1 1 1
  8 1 1 1
 42 1 1 1
100 0 1 1
314 1 1 1
110 1 1 1
 82 1 1 1
 10 1 1 1
118 1 1 1
126 1 1 1
  8 1 1 2
 92 1 1 2
 35 1 1 2
117 1 1 2
132 1 1 2
 12 1 1 2
162 1 1 2
  3 1 1 2
 95 1 1 2
 24 1 0 2
 18 1 0 2
 83 0 0 2
 31 1 0 2
 51 1 0 2
 90 1 0 2
 52 1 0 2
 73 1 0 2
  8 1 0 2
 36 1 0 2
 48 1 0 2
  7 1 0 2
140 1 0 2
186 1 0 2
 84 1 0 2
 19 1 0 2
 45 1 0 2
 80 1 0 2
;
run;

ods graphics on;

ods select SurvivalPlot (persist);

proc lifetest data = prentice plots=s;
   time time*state(0);
   strata trt;
   format trt treat.;
run;


proc lifetest data = prentice plots=s(strata=individual);
   time time*state(0);
   strata trt;
   format trt treat.;
 run;

ods graphics off;

/* To restore the orginal template */
proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival;
   run;
