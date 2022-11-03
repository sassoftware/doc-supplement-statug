 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MODSTYEX                                            */
 /*   TITLE: Modify Template Styles for ODS Graphics             */
 /*          Illustrations of the MODSTYLE macro.                */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: graphs                                              */
 /*   PROCS:                                                     */
 /*    DATA:                                                     */
 /*                                                              */
  /* UPDATE:  24Aug2007                                           */
 /*    MISC: The following SAS products are required to run the  */
 /*          macro: BASE, GRAPH.                                 */
 /*                                                              */
 /*          The macro MODSTYLE is in the autocall library.      */
 /*          If your site has installed the autocall libraries   */
 /*          supplied by SAS Institute and uses the standard     */
 /*          configuration of SAS software supplied by the       */
 /*          Institute, you need only to ensure that the SAS     */
 /*          system option MAUTOSOURCE is in effect to begin     */
 /*          using the autocall macros.  For more information    */
 /*          about autocall libraries, refer to SAS Macro        */
 /*          Language: Reference.                                */
 /*                                                              */
 /*          This sample shows macro usage.                      */
 /****************************************************************/

****************************************************************
*   Proc SGRender, Example 1.                                  *
****************************************************************;

data one;
  do group=1 to 32;
    lower=group-0.5;
    upper=group+0.5;
    do x=0 to 10;
      output;
    end;
  end;
run;
proc template;
  define statgraph mytpl;
  begingraph;
  layout lattice / rows=1 columns=3 columndatarange=UNIONALL
                   rowdatarange=UNIONALL;
     rowaxes;
        rowaxis / display=(line ticks tickvalues);
     endrowaxes;
    layout overlay / yaxisopts=(display=none) xaxisopts=(display=none);
      seriesplot y=group x=x / group=group display=all;
    endlayout;
    layout overlay / yaxisopts=(display=none) xaxisopts=(display=none);
      scatterplot y=group x=x / group=group markerattrs=(size=9);
    endlayout;
    layout overlay / yaxisopts=(display=none) xaxisopts=(display=none);
      bandplot limitlower=lower limitupper=upper x=x / group=group;
      seriesplot y=group x=x / group=group;
    endlayout;
  endlayout;
  endgraph;
end;

%modstyle(name=NewStatStyle,parent=Statistical,type=LMbyC);
ods listing style=NewStatStyle;
proc sgrender data=one template=mytpl;
run;
ods listing close;
ods listing;

****************************************************************
*   Proc Logistic, Example 2.                                  *
****************************************************************;

data beetles(keep=time sex conc freq);
   input time m20 f20 m32 f32 m50 f50 m80 f80;
   conc=.20; freq= m20; sex=1; output;
             freq= f20; sex=2; output;
   conc=.32; freq= m32; sex=1; output;
             freq= f32; sex=2; output;
   conc=.50; freq= m50; sex=1; output;
             freq= f50; sex=2; output;
   conc=.80; freq= m80; sex=1; output;
             freq= f80; sex=2; output;
   datalines;
 1   3   0  7  1  5  0  4  2
 2  11   2 10  5  8  4 10  7
 3  10   4 11 11 11  6  8 15
 4   7   8 16 10 15  6 14  9
 5   4   9  3  5  4  3  8  3
 6   3   3  2  1  2  1  2  4
 7   2   0  1  0  1  1  1  1
 8   1   0  0  1  1  4  0  1
 9   0   0  1  1  0  0  0  0
10   0   0  0  0  0  0  1  1
11   0   0  0  0  1  1  0  0
12   1   0  0  0  0  1  0  0
13   1   0  0  0  0  1  0  0
14 101 126 19 47  7 17  2  4
;
data days;
   set beetles;
   do day=1 to time;
      if (day < 14) then do;
         y= (day=time);
         output;
      end;
   end;
run;
proc logistic data=days outest=est1 noprint;
   class day / param=glm;
   model y(event='1')= day sex conc
         / noint link=cloglog technique=newton;
   freq freq;
run;
data one (keep=day survival element s_m20 s_f20 s_m80 s_f80);
   array dd day1-day13;
   array sc[4] m20 f20 m80 f80;
   array s_sc[4] s_m20 s_f20 s_m80 s_f80 (1 1 1 1);
   set est1;
   m20= exp(sex + .20 * conc);
   f20= exp(2 * sex + .20 * conc);
   m80= exp(sex + .80 * conc);
   f80= exp(2 * sex + .80 * conc);
   survival=1;
   day=0;
   output;
   do over dd;
      element= exp(-exp(dd));
      survival= survival * element;
      do i=1 to 4;
        s_sc[i] = survival ** sc[i];
      end;
      day + 1;
      output;
   end;
run;
%modstyle(name=LogiStyle,parent=Statistical,markers=circlefilled,
          linestyles=solid);
ods listing style=LogiStyle;
proc sgplot data=one;
   title 'Flour Beetles Sprayed with Insecticide';
   xaxis grid integer;
   yaxis grid label='Survival Function';
   pbspline y=s_m20 x=day /
      legendlabel = "Male at 0.20 conc." name="pred1";
   pbspline y=s_m80 x=day /
      legendlabel = "Male at 0.80 conc." name="pred2";
   pbspline y=s_f20 x=day /
      legendlabel = "Female at 0.20 conc." name="pred3";
   pbspline y=s_f80 x=day /
      legendlabel = "Female at 0.80 conc." name="pred4";
   discretelegend "pred1" "pred2" "pred3" "pred4" / across=2;
run;
ods listing close;
ods listing;


****************************************************************
*   Proc Cluster, Example 3.                                   *
****************************************************************;

data closer;
   keep x y c;
   n=50; scale=1;
   mx=0; my=0; c=3; link generate;
   mx=3; my=0; c=1; link generate;
   mx=1; my=2; c=2; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(9)*scale+mx;
      y=rannor(9)*scale+my;
      output;
   end;
   return;
run;
proc cluster data=closer outtree=tree
             method=single noprint;
   var x y;
run;

proc tree data=tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Single Linkage Cluster Analysis';
   title2 'of Data Containing Poorly Separated, Compact Clusters';
run;
proc sort data=out; by cluster;

%modstyle(name=ClusterStyle,parent=Statistical,type=CLM,
          markers=circlefilled empty);
ods listing style=ClusterStyle;
proc sgplot;
   scatter y=y x=x / group=cluster;
run;
ods listing close;
ods listing;
