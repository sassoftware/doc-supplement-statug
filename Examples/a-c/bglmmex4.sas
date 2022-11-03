/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex4                                            */
/*   TITLE: Example 4 for PROC BGLIMM                           */
/*    DESC: Repeated Growth Measurements with Group Difference  */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Group difference                                    */
/*   PROCS: BGLIMM                                              */
/*    DATA: Pothoff and Roy growth measurements                 */
/*                                                              */
/*     REF:                                                     */
/****************************************************************/

data pr;
   input Person Gender $ y1 y2 y3 y4;
   Distance=y1; Age=8;  Time=1; output;
   Distance=y2; Age=10; Time=2; output;
   Distance=y3; Age=12; Time=3; output;
   Distance=y4; Age=14; Time=4; output;
   drop y1-y4;
   datalines;
 1   F   21.0    20.0    21.5    23.0
 2   F   21.0    21.5    24.0    25.5
 3   F   20.5    24.0    24.5    26.0
 4   F   23.5    24.5    25.0    26.5
 5   F   21.5    23.0    22.5    23.5
 6   F   20.0    21.0    21.0    22.5
 7   F   21.5    22.5    23.0    25.0
 8   F   23.0    23.0    23.5    24.0
 9   F   20.0    21.0    22.0    21.5
10   F   16.5    19.0    19.0    19.5
11   F   24.5    25.0    28.0    28.0
12   M   26.0    25.0    29.0    31.0
13   M   21.5    22.5    23.0    26.5
14   M   23.0    22.5    24.0    27.5
15   M   25.5    27.5    26.5    27.0
16   M   20.0    23.5    22.5    26.0
17   M   24.5    25.5    27.0    28.5
18   M   22.0    22.0    24.5    26.5
19   M   24.0    21.5    24.5    25.5
20   M   23.0    20.5    31.0    26.0
21   M   27.5    28.0    31.0    31.5
22   M   23.0    23.0    23.5    25.0
23   M   21.5    23.5    24.0    28.0
24   M   17.0    24.5    26.0    29.5
25   M   22.5    25.5    25.5    26.0
26   M   23.0    24.5    26.0    30.0
27   M   22.0    21.5    23.5    25.0
;

proc sgpanel data=pr noautolegend;
   panelby Gender / columns=2 sparse;
   scatter x=Age y=Distance / group=Person
      markerattrs=(color=black symbol=circlefilled);
   series x=Age y=Distance / group=Person
      lineattrs=GraphDataDefault(color=blue pattern=1);
   label age = 'Age in Years' Distance ='Distance (mm)';
run;


proc bglimm data=pr seed=475193 outpost=pr_out;
   by Gender;
   class Person Time;
   model Distance = Age;
   repeated Time / subject=Person type=un r;
run;


data boys girls;
   set pr_out;
   if gender eq 'F' then output girls;
   else output boys;
   keep residual:;
   run;

data boys;
   set boys;
   Cov_11_boys = residual_un_1_1;
   Cov_21_boys = residual_un_2_1;
   Cov_22_boys = residual_un_2_2;
   Cov_31_boys = residual_un_3_1;
   Cov_32_boys = residual_un_3_2;
   Cov_33_boys = residual_un_3_3;
   Cov_41_boys = residual_un_4_1;
   Cov_42_boys = residual_un_4_2;
   Cov_43_boys = residual_un_4_3;
   Cov_44_boys = residual_un_4_4;
   keep cov:;
   run;


data girls;
   set girls;
   Cov_11_girls = residual_un_1_1;
   Cov_21_girls = residual_un_2_1;
   Cov_22_girls = residual_un_2_2;
   Cov_31_girls = residual_un_3_1;
   Cov_32_girls = residual_un_3_2;
   Cov_33_girls = residual_un_3_3;
   Cov_41_girls = residual_un_4_1;
   Cov_42_girls = residual_un_4_2;
   Cov_43_girls = residual_un_4_3;
   Cov_44_girls = residual_un_4_4;
   keep cov:;
   run;


data a;
   merge boys girls;
   if _n_ eq 1 then do;
      x = 0;
      y = 0;
   end;
   else do;
      x = .;
      y = .;
   end;
   run;

%macro oneplot(var1=, var2=, label=);
   layout overlay / yaxisopts=(display=none
                               offsetmin=0
                               linearopts=(viewmin=0))
      xaxisopts=(label="&label")
      walldisplay=(fill) ;

   densityplot &var1 /kernel() lineattrs=(pattern=2
                                          color=red)
      name="k1" legendlabel = "Boys";
   densityplot &var2 /kernel() lineattrs=(pattern=4
                                          color=darkblue)
      name="k2" legendlabel = "Girls";
   endlayout;
%mend oneplot;

%macro empty();
   layout overlay / yaxisopts=(display=none)
      xaxisopts=(display=none)
      walldisplay=(fill);
   scatterplot x=x y=y / markerattrs=(size=0);
   endlayout;
%mend;


proc template;
   define statgraph _dencomp;
      begingraph / designwidth=defaultDesignHeight;
      layout lattice / columns=4 rows=4 border=false columngutter=0
         order=packed skipemptycells=true;
      %oneplot(var1=Cov_11_boys, var2=Cov_11_girls, label=Cov(1,1));
      %empty();
      %empty();
      %empty();
      %oneplot(var1=Cov_21_boys, var2=Cov_21_girls, label=Cov(2,1));
      %oneplot(var1=Cov_22_boys, var2=Cov_22_girls, label=Cov(2,2));
      %empty;
      %empty;
      %oneplot(var1=Cov_31_boys, var2=Cov_31_girls, label=Cov(3,1));
      %oneplot(var1=Cov_32_boys, var2=Cov_32_girls, label=Cov(3,2));
      %oneplot(var1=Cov_33_boys, var2=Cov_33_girls, label=Cov(3,3));
      %empty;
      %oneplot(var1=Cov_41_boys, var2=Cov_41_girls, label=Cov(4,1));
      %oneplot(var1=Cov_42_boys, var2=Cov_42_girls, label=Cov(4,2));
      %oneplot(var1=Cov_43_boys, var2=Cov_43_girls, label=Cov(4,3));
      %oneplot(var1=Cov_44_boys, var2=Cov_44_girls, label=Cov(4,4));
      sidebar / align=bottom spacefill=false;
      discretelegend "k1" "k2" / across=2;
      endsidebar;

      endlayout;
      endgraph;
      end;
   run;

proc sgrender data=a template=_dencomp;
   run;

proc bglimm data=pr seed=475193 outpost=pr_out;
   class Person Gender Time;
   model Distance = Age|Gender;
   repeated Time / type=un subject=Person group=Gender r;
run;

proc bglimm data=pr seed=475193 outpost=pr_out;
   class Person Gender Time;
   model Distance = Age|Gender;
   repeated Time / type=un subject=Person group=Gender r;
   estimate 'Girls Intercept' Int 1 Gender 1 0;
   estimate 'Boys Intercept'  Int 1 Gender 0 1;
   estimate 'Girls Slope' Age 1 Age*Gender 1 0;
   estimate 'Boys Slope' Age 1 Age*Gender 0 1;
run;

data prob;
   set pr_out;
   pDiff = boys_slope - girls_slope;
   prob = (pDiff > 0);
   keep pDiff prob;
run;

%sumint(data=prob, var=pDiff prob)

proc template;
   define statgraph _den;
      dynamic _x _y;
      begingraph / drawspace=datavalue;
      layout overlay / walldisplay=(fill)
         xaxisopts=(offsetmin=0
                    label="Boys' Slope - Girls' Slope"
                    linearopts=(viewmin=-0.3 viewmax=1))
         yaxisopts=(display=none
                    offsetmin=0);
      seriesplot x=value y=density  /
                          lineattrs=GraphFit(pattern=1
                                             color=black);
      bandplot x=value limitupper=upper
         limitlower=lower;
    drawarrow x1=0.72 x2=0.6  y1=1.3 y2=1 / arrowheadscale=0.5;
    drawtext textattrs=(size=11) "Pr(Difference > 0) > 0.99" /
      y=1.3 x=0.75 anchor=bottom width=1 widthunit=data;
      endlayout;
      endgraph;
      end;
   run;

proc kde data=prob;
   univar pDiff / out=_d;
run;

data _d;
   set _d;
   lower = 0;
   if value < 0 then upper = .;
   else upper = density;
   run;

proc sgrender data=_d template=_den;
   run;

proc bglimm data=pr seed=475193 outpost=pr_out;
   class Person Gender Time;
   model Distance = Gender Gender*Age / noint;
   repeated Time / type=un subject=Person group=Gender;
run;

proc bglimm data=pr seed=475193 outpost=pr_out;
   class Person Gender Time;
   model Distance = Gender Age*Gender / noint;
   repeated Time / type=un subject=Person group=Gender;
   estimate 'Intercept Difference' Gender 1 -1;
   estimate 'Slope Difference' Gender*Age 1 -1;
   estimate 'Girl at Age 11' Gender 1 0 Gender*Age 11 0;
   estimate 'Boy  at Age 11' Gender 0 1 Gender*Age 0 11;
run;
