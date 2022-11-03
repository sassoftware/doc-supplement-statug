/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSEX10                                             */
/*   TITLE: Documentation Example 10 for ODS                    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: TEMPLATE, CORR, GLIMMIX                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Rating of Automobiles';

data cars;
   input Origin $ 1-8 Make $ 10-19 Model $ 21-36
         (MPG Reliability Acceleration Braking Handling Ride
          Visibility Comfort Quiet Cargo) (1.);
   datalines;
GMC      Buick      Century         3334444544
GMC      Buick      Electra         2434453555
GMC      Buick      Lesabre         2354353545
GMC      Buick      Regal           3244443424
GMC      Buick      Riviera         2354553543
GMC      Buick      Skyhawk         3232423224
GMC      Buick      Skylark         4145555422
GMC      Chevrolet  Camaro          2254541241
GMC      Chevrolet  Caprice Classic 2445353555
GMC      Chevrolet  Chevette        5335425223
GMC      Chevrolet  Citation        4155555525
GMC      Chevrolet  Corvette        2153542242
GMC      Chevrolet  Malibu          3333444544
GMC      Chevrolet  Monte Carlo     3253353544
GMC      Chevrolet  Monza           2142233114
Chrysler Dodge      Aspen           2143333424
Chrysler Dodge      Colt Hatchback  5544445434
Chrysler Dodge      Diplomat        2153343434
Chrysler Dodge      Mirada          2143432434
Chrysler Dodge      Omni 024        4345535225
Chrysler Dodge      St Regis        1154353545
Ford     Ford       Fairmont        3324345434
Ford     Ford       Fiesta          5445344414
Ford     Ford       Granada         2233233233
Ford     Ford       LTD             3354354555
Ford     Ford       Mustang         3244323222
Ford     Ford       Pinto           4134313222
Ford     Ford       Thunderbird     2354344444
Ford     Mercury    Bobcat          4134313212
Ford     Mercury    Capri           3154322222
Ford     Mercury    Cougar XR7      2454444444
Ford     Mercury    Marquis         3354354555
Ford     Mercury    Monarch         2353232232
Ford     Mercury    Zephyr          3124345434
GMC      Oldsmobile Cutlass         3443444544
GMC      Oldsmobile Delta 88        2435353555
GMC      Oldsmobile 98              2445353555
GMC      Oldsmobile Omega           4155555522
GMC      Oldsmobile Starfire        2133522154
GMC      Oldsmobile Toronado        3323443544
Chrysler Plymouth   Champ           5544445434
Chrysler Plymouth   Gran Fury       2134353535
Chrysler Plymouth   Horizon         4345535235
Chrysler Plymouth   Volare          2153333424
GMC      Pontiac    Bonneville      2345353555
GMC      Pontiac    Firebird        1153551231
GMC      Pontiac    Grand Prix      3224432434
GMC      Pontiac    Lemans          3333444544
GMC      Pontiac    Phoenix         4155554415
GMC      Pontiac    Sunbird         3134533234
;

proc template;
   edit Base.Corr.StackedMatrix;
      column (RowName RowLabel) (Matrix) * (Matrix2);
      edit matrix;
         cellstyle _val_  = -1.00 as {backgroundcolor=CXEEEEEE},
                   _val_ <= -0.75 as {backgroundcolor=red},
                   _val_ <= -0.50 as {backgroundcolor=blue},
                   _val_ <= -0.25 as {backgroundcolor=cyan},
                   _val_ <=  0.25 as {backgroundcolor=white},
                   _val_ <=  0.50 as {backgroundcolor=cyan},
                   _val_ <=  0.75 as {backgroundcolor=blue},
                   _val_ <   1.00 as {backgroundcolor=red},
                   _val_  =  1.00 as {backgroundcolor=CXEEEEEE};
      end;
   end;
run;

/*
ods _all_ close;
ods html body='corr.html' style=HTMLBlue;
*/

proc corr data=cars noprob;
   ods select PearsonCorr;
run;

/*
ods html close;
ods html;
ods pdf;
*/

proc template;
   delete Base.Corr.StackedMatrix / store=sasuser.templat;
run;

%paint(values=0 to 10 by 0.5,
       colors=white cyan blue magenta red)

proc print data=colors;
run;

%paint(values=-1 to 1 by 0.05, macro=setstyle,
       colors=CXEEEEEE red magenta blue cyan white
              cyan blue magenta red CXEEEEEE
              -1 -0.99 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 0.99 1)

proc template;
   edit Base.Corr.StackedMatrix;
      column (RowName RowLabel) (Matrix) * (Matrix2);
      edit matrix;
         %setstyle(backgroundcolor)
      end;
   end;
run;

/*
ods _all_ close;
ods html body='corr.html' style=HTMLBlue;
*/
proc corr data=cars noprob;
   ods select PearsonCorr;
run;
/*
ods html close;
ods html;
ods pdf;
*/

proc template;
   delete Base.Corr.StackedMatrix / store=sasuser.templat;
run;

title 'Analysis of Repeated Growth Measures';

data pr;
   input Person Gender $ y1 y2 y3 y4 y5 y6 y7 y8;
   array y{8};
   do time=5,7,8,4,3,2,1;
      Response = y{time};
      Age      = time+7;
      output;
   end;
   datalines;
 1   F   21.0  20.0  21.5  23.0  21.0  21.5  24.0  25.5
 2   F   20.5  24.0  24.5  26.0  23.5  24.5  25.0  26.5
 3   F   21.5  23.0  22.5  23.5  20.0  21.0  21.0  22.5
 4   F   21.5  22.5  23.0  25.0  23.0  23.0  23.5  24.0
 5   F   20.0  21.0  22.0  21.5  16.5  19.0  19.0  19.5
 6   F   24.5  25.0  28.0  28.0  26.0  25.0  29.0  31.0
 7   M   21.5  22.5  23.0  26.5  23.0  22.5  24.0  27.5
 8   M   25.5  27.5  26.5  27.0  20.0  23.5  22.5  26.0
 9   M   24.5  25.5  27.0  28.5  22.0  22.0  24.5  26.5
10   M   24.0  21.5  24.5  25.5  23.0  20.5  31.0  26.0
11   M   27.5  28.0  31.0  31.5  23.0  23.0  23.5  25.0
12   M   21.5  23.5  24.0  28.0  17.0  24.5  26.0  29.5
13   M   22.5  25.5  25.5  26.0  23.0  24.5  26.0  30.0
;

* You need to run the analysis once to know that 20 is a good maximum;
%paint(values=0 to 20 by 0.25,
       colors=cyan blue magenta red, macro=setstyle1)

%paint(values=0 to 1 by 0.05,
       colors=cyan blue magenta red, macro=setstyle2)

proc template;
   edit Stat.Glimmix.V;
      column Subject Index Row Col;
      edit Col;
         %setstyle1(backgroundcolor)
      end;
   end;
   edit Stat.Glimmix.VCorr;
      column Subject Index Row Col;
      edit Col;
         %setstyle2(backgroundcolor)
      end;
   end;
run;

/*
ods _all_ close;
ods html body='ar1.html' style=HTMLBlue;
*/
proc glimmix data=pr;
   class person gender time;
   model response = gender age gender*age;
   random _residual_ / sub=person type=arh(1) v residual vcorr;
   ods select v vcorr;
run;
/*
ods html close;
ods html;
ods pdf;
*/

proc template;
   delete Stat.Glimmix.V / store=sasuser.templat;
   delete Stat.Glimmix.VCorr / store=sasuser.templat;
run;

%let inc = 0.25;

%paint(values=0 to 20 by &inc, colors=blue magenta red)

data cntlin;
   set colors;
   fmtname = 'paintfmt';
   label = _rgb_;
   end = start + &inc;
   keep start end label fmtname;
run;

proc format cntlin=cntlin;
run;

proc template;
   edit Stat.Glimmix.V;
      column Subject Index Row Col;
      edit Col;
         style = {foreground=paintfmt8. font_weight=bold};
      end;
   end;
run;

/*
ods _all_ close;
ods html body='ar1.html' style=HTMLBlue;
*/
proc glimmix data=pr;
   class person gender time;
   model response = gender age gender*age;
   random _residual_ / sub=person type=arh(1) v residual;
   ods select v;
run;
/*
ods html close;
ods html;
ods pdf;
*/

proc template;
   delete Stat.Glimmix.V / store=sasuser.templat;
run;
title;

ods select none;
proc corr data=sashelp.cars noprob;
   ods output PearsonCorr=p;
run;
ods select all;

data p2;
   set p end=eof;
   array __n[*] _numeric_;
   do __i = _n_ to dim(__n); __n[__i] = ._; end;
   if _n_ = 1 then do;
      call execute('data _null_; set p2;');
      call execute('file print ods=(template="Base.Corr.StackedMatrix"');
      call execute('columns=(rowname=variable');
   end;
   call execute(cats('matrix=',vname(__n[_n_]),'(generic)'));
   if eof then call execute(')); put _ods_; run;');
run;

data _null_;
   set p2;
   file print ods=(template="Base.Corr.StackedMatrix"
                   columns=(rowname=variable
                            matrix=MSRP(generic)
                            matrix=Invoice(generic)
                            matrix=EngineSize(generic)
                            matrix=Cylinders(generic)
                            matrix=Horsepower(generic)
                            matrix=MPG_City(generic)
                            matrix=MPG_Highway(generic)
                            matrix=Weight(generic)
                            matrix=Wheelbase(generic)
                            matrix=Length(generic)));
   put _ods_;
run;

data p2;
   set p end=eof;
   array __n[*] _numeric_;
   do __i = _n_ to dim(__n); __n[__i] = ._; end;
   if _n_ = 1 then do;
      call execute('data _null_; set p2;');
      call execute('file print ods=(template="Base.Corr.StackedMatrix"');
      call execute('columns=(rowname=variable');
   end;
   if not eof then call execute(cats('matrix=',vname(__n[_n_]),'(generic)'));
   if eof then call execute(')); if _n_ ne 1 then put _ods_; run;');
run;

%let inc = 0.01;
%paint(values=-1 to 1 by &inc, colors=red magenta cyan magenta red)

data cntlin;
   set colors;
   FmtName = 'paintfmt';
   Label = _rgb_;
   End = round(start + &inc, &inc);
   keep start end label fmtname;
run;

proc format cntlin=cntlin; run;

proc template;
   edit Base.Corr.StackedMatrix;
      column (RowName RowLabel) (Matrix);
      header 'Pearson Correlation Coefficients';
      edit matrix;format=5.2 style={foreground=paintfmt8. font_weight=bold};end;
   end;
quit;

ods select none;
proc corr data=sashelp.cars noprob;
   ods output PearsonCorr=p;
run;
ods select all;

/*
ods _all_ close;
ods html body='upper.html' style=HTMLBlue;
*/

data p2;
   set p end=eof;
   array __n[*] _numeric_;
   do __i = 1 to _n_; __n[__i] = ._; end;
   if _n_ = 1 then do;
      call execute('data _null_; set p2 end=eof;');
      call execute('file print ods=(template="Base.Corr.StackedMatrix"');
      call execute('columns=(rowname=variable');
   end;
   if _n_ ne 1 then call execute(cats('matrix=',vname(__n[_n_]),'(generic)'));
   if eof then call execute(')); if not eof then put _ods_; run;');
run;

/*
ods html close;
ods html;
ods pdf;
*/

proc template;
   delete Base.Corr.StackedMatrix / store=sasuser.templat;
quit;
