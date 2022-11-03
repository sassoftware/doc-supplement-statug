/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGREX6                                            */
/*   TITLE: Documentation Example 6 for ODS Graphics            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods                                       */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES: This sample provides DATA step and PROC code        */
/*   from the chapter "Statistical Graphics Using ODS."         */
/****************************************************************/

proc sgplot data=sashelp.heart noautolegend;
   reg y=weight x=height / markerattrs=(size=3px) degree=3;
run;

ods graphics on / antialiasmax=6000;
proc sgplot data=sashelp.heart noautolegend;
   pbspline y=weight x=height / markerattrs=(size=3px);
run;

ods graphics on / loessmaxobs=6000;
proc sgplot data=sashelp.heart noautolegend;
   loess y=weight x=height / markerattrs=(size=3px);
run;

proc sgplot data=sashelp.heart noautolegend;
   pbspline y=weight x=height / smooth=0 nknots=5 markerattrs=(size=3px);
run;

%let st = 5;
data a;
   s1  = sqrt(&st);
   s2  = &st ** (1 / 3);
   inc = 0.01 * s2;
   do x = -&st to &st by inc;
      x1 = x;
      x2 = x * x;
      x3 = x * x * x;
      k1 = -2; k1 = (x > k1) * (x - k1) ** 3;
      k2 =  0; k2 = (x > k2) * (x - k2) ** 3;
      k3 =  2; k3 = (x > k3) * (x - k3) ** 3;
      p0 = -0.5 + 0.01 * x - 0.04 * x2 - 0.01 * x3;
      p1 = p0 + 0.1 * k1;
      p2 = p1 + - 0.5 * k2;
      p3 = p2 + 1.5 * k3;
      y  = p3;
      g  = 1 + (x > -2) + (x > 0) + (x > 2);
      if g le 1 then p1 = .;
      if g le 2 then p2 = .;
      if g le 3 then p3 = .;
      output;
   end;
run;

ods path work.templat(update) sashelp.tmplmst(read);
proc template;
   define statgraph spplot;
      %macro a(c); lineattrs=(thickness=2 color=&c) datatransparency=0 %mend;
      begingraph / border=false designwidth=defaultdesignheight;
         layout overlayequated / equatetype=square
                %let a = offsetmin=0 offsetmax=0;
                xaxisopts=(display=(line ticks tickvalues) &a)
                yaxisopts=(display=(line ticks tickvalues) &a)
                commonaxisopts=(viewmin=-5 viewmax=5
                tickvaluelist=(-5 -4 -3 -2 -1 0 1 2 3 4 5));
            seriesplot x=x y=y  / lineattrs=(color=yellow thickness=12) group=g;
            seriesplot x=x y=p0 / %a(blue);
            seriesplot x=x y=p1 / %a(red);
            seriesplot x=x y=p2 / %a(green);
            seriesplot x=x y=p3 / %a(orange);
            referenceline x=-2;
            referenceline x=0;
            referenceline x=2;
            referenceline y=0;
         endlayout;
      endgraph;
   end;
quit;

proc sgrender data=a template=spplot; run;

proc template; delete spplot; quit;

proc sgplot data=sashelp.class(where=(sex='F'));
   pbspline y=weight x=height;
run;

proc sgplot data=sashelp.class(where=(sex='F'));
   pbspline y=weight x=height / smooth=2e5;
run;

proc sgplot data=sashelp.class(where=(sex='F'));
   pbspline y=weight x=height / nknots=20;
run;

proc sgplot data=sashelp.gas;
   reg y=nox x=eqratio / degree=3 group=fuel markerattrs=(size=3px) name='a';
   keylegend 'a' / location=inside position=topright across=1;
run;

proc sgplot data=sashelp.gas;
   pbspline y=nox x=eqratio / group=fuel markerattrs=(size=3px) name='a';
   keylegend 'a' / location=inside position=topright across=1;
run;

proc sgplot data=sashelp.gas;
   loess y=nox x=eqratio / group=fuel markerattrs=(size=3px) name='a';
   keylegend 'a' / location=inside position=topright across=1;
run;

proc sgplot data=sashelp.gas;
   pbspline y=nox x=eqratio / group=fuel smooth=0 nknots=5
                              markerattrs=(size=3px) name='a';
   keylegend 'a' / location=inside position=topright across=1;
run;

proc sgplot data=sashelp.gas;
   ods output sgplot=sg;
   pbspline y=nox x=eqratio / group=fuel smooth=0 nknots=5
                              markerattrs=(size=3px) name='a';
   keylegend 'a' / location=inside position=topright across=1;
run;

data subset(drop=SORT_FUEL_RETAIN_ALL_);
   set sg;
   Obs = _n_;
   by PBSPLINE_EQRATIO_NOX_GROUP_S__GP fuel;
   if _N_ gt 169 then do; fuel = '_'; eqratio = ._; nox = ._; end;
   if first.fuel or last.fuel or first.PBSPLINE_EQRATIO_NOX_GROUP_S__GP or
      last.PBSPLINE_EQRATIO_NOX_GROUP_S__GP or obs = 169 then output;
   if lag(first.fuel) or lag(first.PBSPLINE_EQRATIO_NOX_GROUP_S__GP) then do;
      call missing(of PBSPLI: Fuel EqRatio NOx obs);
      if _n_ gt 169 then do; fuel = '_'; eqratio = ._; nox = ._; end;
      output; output; output;
   end;
run;

proc print noobs; id obs; run;

proc freq data=sashelp.gas(where=(n(eqratio, nox) eq 2));
   tables fuel;
run;

proc transreg data=sashelp.gas nomiss solve ss2 plots=fit(nocli noclm);
   ods select anova fitstatistics fitplot;
   model identity(nox) = spline(eqratio / nknots=5 evenly after) |
                         class(fuel / zero=none);
run;

proc means data=sashelp.gas(where=(n(nox, eqratio))) noprint;
   class fuel;
   var eqratio;
   output out=m(where=(_type_ eq 1 and trim(_stat_) in ('MIN', 'MAX')));
run;

proc transpose data=m out=m2(drop=_:);
   by fuel;
   id _stat_;
   var eqratio;
run;

data gas(drop=min max);
   if _n_ = 1 then do i = 1 to n;
      set m2 nobs=n point=i;
      if fuel ne '82rongas' then
         do eqratio = min to max by (max - min) / 200; output; end;
   end;
   set sashelp.gas(where=(n(nox, eqratio)));
   output;
run;

proc transreg data=gas solve ss2 plots(interpolate)=fit(nocli noclm);
   ods select anova fitstatistics fitplot;
   model identity(nox) = class(fuel / zero=none) |
                         spline(eqratio / nknots=5 after evenly);
run;

data gas(drop=min max);
   if _n_ = 1 then do i = 1 to n;
      set m2 nobs=n point=i;
      do eqratio = min to max by (max - min) / 200; output; end;
   end;
   set sashelp.gas(where=(n(nox, eqratio)));
   output;
run;

proc transreg data=gas solve ss2 plots(interpolate)=fit(nocli noclm);
   ods select anova fitstatistics fitplot;
   model identity(nox) = class(fuel / zero=none)
                         spline(eqratio / nknots=5 after evenly);
run;

proc transreg data=gas ss2 plots(interpolate)=fit(nocli noclm);
   ods select anova fitstatistics fitplot;
   model identity(nox) = class(fuel / zero=none) * pbspline(eqratio / after);
run;

proc transreg data=gas solve ss2 plots(interpolate)=fit(nocli noclm);
   ods select anova fitstatistics fitplot;
   model identity(nox) = class(fuel / zero=none) *
                         smooth(eqratio / after sm=60);
run;

data x;
   do i = 1 to 100;
      g = 1;
      x = 10 * uniform(17);
      y = x + 2 * sin(x) + normal(17);
      output;
      g = 2;
      x = 10 * uniform(17);
      y = 5 - x - 2 * cos(x) + normal(17);
      output;
   end;
run;

proc sgplot data=x;
   title 'Penalized-B-Spline';
   pbspline y=y x=x / group=g;
run;
title;

proc transreg data=x ss2 plots=fit(nocli noclm) maxiter=100;
   model identity(y) = class(g / zero=none) | mspline(x / nknots=10);
run;

proc transreg data=x ss2 plots=fit(nocli noclm) solve;
   model identity(y) = class(g / zero=none) | spline(x / nknots=10 degree=1);
run;

proc transreg data=x ss2 plots=fit(nocli noclm) maxiter=100;
   model identity(y) = class(g / zero=none) | mspline(x / nknots=10 degree=1);
run;

proc transreg data=x ss2 plots=fit(nocli noclm) maxiter=100;
   model identity(y) = class(g / zero=none) | mspline(x / nknots=10);
   output out=msp p replace;
run;

proc sort data=msp; by g x; run;

proc sgplot data=msp;
   title 'Transreg Output Data Set';
   scatter y=y  x=x / group=g markerattrs=(size=3px);
   series  y=py x=x / group=g name='a';
   keylegend 'a' / location=inside position=topleft across=1;
run;
title;

proc orthoreg data=sashelp.heart;
   effect spl = spline(height / knotmethod=equal(5));
   model weight = spl;
   effectplot / obs;
run;

proc orthoreg data=sashelp.gas;
   effect spl = spline(eqratio / knotmethod=equal(3));
   class fuel;
   model nox = spl | fuel;
   effectplot / obs extend=data;
   ods output SliceFitPlot=sp;
run;

proc orthoreg data=sashelp.gas;
   effect spl = spline(eqratio / naturalcubic knotmethod=equal(5));
   class fuel;
   model nox = spl | fuel;
   effectplot / obs;
run;

data x2;
   do x = -2 to 2 by 0.1;
      y = x + sin(x) + normal(17);
      output;
   end;
run;

proc transreg data=x2 details ss2;
   model identity(y) = bspline(x / nknots=3 evenly=3);
run;

proc transreg data=x2 details ss2;
   model identity(y) = spline(x / nknots=3 evenly=3);
run;

%let k = -4.000000000001 -3.000000000001 -2.000000000001 -1 0 1
          2.000000000001  3.000000000001  4.000000000001;
proc transreg data=x2 details ss2;
   model identity(y) = bspline(x / knots=&k);
run;

proc orthoreg data=x2;
   effect spl = spline(x / knotmethod=equal(3));
   model  y = spl / noint;
run;

proc orthoreg data=x2;
   effect spl = spline(x / knotmethod=listwithboundary(&k));
   model  y = spl / noint;
run;

proc transreg data=x2 details ss2;
   model identity(y) = bspline(x / nknots=3 evenly=3);
   output out=b1(keep=x_:) replace;
run;

proc glimmix data=x2 outdesign=b2(drop=x y
   rename=(%macro ren; %do i = 1 %to 7; _x&i=x_%eval(&i-1) %end; %mend; %ren));
   effect spl = spline(x / knotmethod=equal(3));
   model y = spl / noint;
run;

%let k = -4.000000000001 -3.000000000001 -2.000000000001 -1 0 1
          2.000000000001  3.000000000001  4.000000000001;

proc iml;
   use x2(keep=x); read all into x;
   b = bspline(x, 3, {&k});
   vname = 'x_0' : rowcatc('x_' || char(ncol(b)-1));
   create b3 from b[colname=vname]; append from b;
quit;

data b4(keep=x:);
   %let d   = 3;                        /* degree                  */
   %let nkn = %eval(&d * 2 + 3);        /* total number of knots   */
   %let nb  = %eval(&d + 1 + 3);        /* number of cols in basis */
   array k[&nkn] _temporary_ (&k);      /* knots                   */
   array b[&nb] x_0 - x_%eval(&nb - 1); /* basis                   */
   array w[%eval(2 * &d)];              /* work                    */
   set x2;
   do i = 1 to &nb; b[i] = 0; end;

   * find the index of first knot greater than current data value;
   do ki = 1 to &nkn while(k[ki] le x); end;
   kki = ki - &d - 1;

   * make the basis;
   b[1 + kki] = 1;
   do j = 1 to &d;
      w[&d + j] = k[ki + j - 1] - x;
      w[j] = x - k[ki - j];
      s = 0;
      do i = 1 to j;
         t = w[&d + i] + w[j + 1 - i];
         if t ne 0.0 then t = b[i + kki] / t;
         b[i + kki] = s + w[&d + i] * t;
         s = w[j + 1 - i] * t;
      end;
      b[j + 1 + kki] = s;
   end;
run;

options nolabel;
proc compare error note briefsummary criterion=1e-12
   data=b1 compare=b2 method=relative(1);
run;

proc compare error note briefsummary criterion=1e-12
   data=b1 compare=b3 method=relative(1);
run;

proc compare error note briefsummary criterion=1e-12
   data=b1 compare=b4(drop=x) method=relative(1);
run;
options label;

proc sgplot data=b4;
   %macro s; %do i = 0 %to &nb-1; series y=x_&i x=x; %end; %mend; %s
   yaxis label='B-Spline Basis Functions';
run;

proc transreg data=x2 details ss2;
   model identity(y) = pspline(x / name=(p) nknots=3);
   output out=p1(keep=p_:) replace;
run;

data both; merge p1 b1; run;

proc print data=both noobs;
   format _numeric_ bestd6.5 p_1 p_2 best6.;
run;

proc cancorr data=both;
  var x:;
  with p:;
run;

data class;
   set sashelp.class(rename=(height=Height1)) nobs=n;
   output;
   if _n_ = n then do;
      call missing(name, sex, height1);
      do age = 10 to 17; output; end;
   end;
run;

proc reg data=class;
   model height1 = age;
   output out=p1 p=p1y r=r1y;
run;

data class;
   f = 1;
   set sashelp.class(rename=(height=Height2)) nobs=n;
   output;
   if _n_ = n then do;
      call missing(f, name, sex);
      do age = 10 to 17; output; end;
   end;
run;

proc reg data=class;
   freq f;
   model height2 = age;
   output out=p2 p=p2y r=r2y;
run;

data all; merge p1 p2; run;

proc print data=all;
   var f name sex age height: p: r:;
   format p1y p2y r1y r2y 6.3;
run;

proc means min max data=sashelp.gas;
   class fuel;
   var eqratio;
   output out=m(where=(_type_ eq 1 and _stat_ in ('MIN', 'MAX')));
run;

proc transpose data=m out=m2(drop=_:);
   var eqratio;
   by fuel;
   id _stat_;
run;

data score(drop=min max);
   set m2;
   do eqratio = min to max by (max - min) / 200; output; end;
run;

data gas;
   set sashelp.gas(where=(n(nox))) score;
run;

proc glimmix data=gas;
   effect spl = spline(eqratio / naturalcubic knotmethod=equal(5));
   class fuel;
   model nox = spl | fuel;
   output out=scored(where=(nmiss(nox))) pred=py;
run;

proc sgplot data=scored;
   series y=py x=eqratio / group=fuel;
run;

proc glimmix data=sashelp.gas;
   effect spl = spline(eqratio / naturalcubic knotmethod=equal(5));
   class fuel;
   model nox = spl | fuel;
   store SplineModel;
run;

proc plm restore=SplineModel;
   score data=score out=scored2 predicted=py;
run;

proc sgplot data=scored2;
   series y=py x=eqratio / group=fuel;
run;

data Neuralgia;
   input Treatment $ Sex $ Age Duration Pain $ @@;
   datalines;
P  F  68   1  No   B  M  74  16  No   P  F  67  30  No   P  M  66  26  Yes
B  F  67  28  No   B  F  77  16  No   A  F  71  12  No   B  F  72  50  No
B  F  76   9  Yes  A  M  71  17  Yes  A  F  63  27  No   A  F  69  18  Yes
B  F  66  12  No   A  M  62  42  No   P  F  64   1  Yes  A  F  64  17  No
P  M  74   4  No   A  F  72  25  No   P  M  70   1  Yes  B  M  66  19  No
B  M  59  29  No   A  F  64  30  No   A  M  70  28  No   A  M  69   1  No
B  F  78   1  No   P  M  83   1  Yes  B  F  69  42  No   B  M  75  30  Yes
P  M  77  29  Yes  P  F  79  20  Yes  A  M  70  12  No   A  F  69  12  No
B  F  65  14  No   B  M  70   1  No   B  M  67  23  No   A  M  76  25  Yes
P  M  78  12  Yes  B  M  77   1  Yes  B  F  69  24  No   P  M  66   4  Yes
P  F  65  29  No   P  M  60  26  Yes  A  M  78  15  Yes  B  M  75  21  Yes
A  F  67  11  No   P  F  72  27  No   P  F  70  13  Yes  A  M  75   6  Yes
B  F  65   7  No   P  F  68  27  Yes  P  M  68  11  Yes  P  M  67  17  Yes
B  M  70  22  No   A  M  65  15  No   P  F  67   1  Yes  A  M  67  10  No
P  F  72  11  Yes  A  F  74   1  No   B  M  80  21  Yes  A  F  69   3  No
;

proc logistic data=Neuralgia outdesign=coded;
   class Treatment Sex;
   effect Age2      = spline(age / degree=2 knotmethod=equal(0));
   effect Duration2 = polynomial(duration / degree=2);
   model Pain= Treatment Sex Treatment*Sex Age2 Duration2 / expb;
run;

proc print data=coded(obs=10); run;

proc adaptivereg data=sashelp.gas plots=all details=bases;
   class fuel;
   model nox = eqratio | fuel;
run;
