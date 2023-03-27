data one;
   do x=0 to 2 by 0.01;
      y=rannor(1);
      output;
   end;
run;

ods exclude all;
proc glmselect data=one outdesign(addinputvars prefix=linear)=two;
   effect spl=spline(x/knotmethod=list(1) details basis=tpf degree=1);
   model y=spl/selection=none;
run;

proc glmselect data=two outdesign(addinputvars prefix=cubic names)=three;
   effect spl=spline(x/knotmethod=list(1) details basis=tpf);
   model y=spl/selection=none;
run;

proc template;
   define statgraph tpf;
      beginGraph / designheight=240;
         layout lattice/columns=2
                        rowdatarange=unionall
                        columnGutter=10;
            rowaxes;
               rowaxis / display=(line ticks tickvalues)
                         offsetmin=0.05 offsetmax=0.05;
            endrowaxes;
            layout overlay / yaxisopts=(display=none);
               entry "Linear" / location = outside textattrs=GraphTitleText;
               seriesplot x=x y=linear4/
                  lineattrs = GraphData1(color=blue);
               referenceline x=1;
            endlayout;
            layout overlay / yaxisopts=(display=none);
               entry "Cubic" / location = outside textattrs=GraphTitleText;
               seriesplot x=x y=cubic6/
                  lineattrs = GraphData1(color=blue);
               referenceline x=1;
            endlayout;
         endlayout;
      endGraph;
   end;
run;

ods exclude none;
proc sgrender data=three template=tpf;
run;

data one;
   do x=0 to 1 by 0.01;
      y=rannor(1);
      output;
   end;
run;

ods exclude all;
proc glmselect data=one outdesign(addinputvars)=linear;
   effect linear=spline(x/knotmethod=equal(4) databoundary details degree=1);
   model y=linear/selection=none;
run;

proc glmselect data=one outdesign(addinputvars)=cubic;
   effect cubic=spline(x/knotmethod=equal(4) details databoundary degree=3);
   model y=cubic/selection=none;
run;

proc glmselect data=one outdesign(addinputvars)=cubicequal;
   effect cubic=spline(x/knotmethod=equal(4) details degree=3);
   model y=cubic/selection=none;
run;


%macro fns(prefix,n);
   %do i=1 %to &n;
      seriesplot x=x y=&prefix&i / lineattrs = GRAPHDATA&i(pattern=solid);
   %end;
%mend;


proc template;
   define statgraph bsplineLinear;
      beginGraph / designheight=240;
         layout overlay/yaxisopts=(display=(line ticks tickvalues)
                                   offsetmin=0.05 offsetmax=0.05);
            %fns(linear_,6);
         endlayout;
      endGraph;
   end;

   define statgraph bsplineCubic;
      beginGraph / designheight=320;
         layout overlay/yaxisopts=(display=(line ticks tickvalues)
                                   offsetmin=0.05 offsetmax=0.05);
            %fns(cubic_,8);
         endlayout;
      endGraph;
   end;
run;

ods exclude none;
proc sgrender data=linear template=bsplineLinear;
run;
proc sgrender data=cubic template=bsplineCubic;
run;
proc sgrender data=cubicequal template=bsplineCubic;
run;

ods exclude all;
proc glmselect data=one outdesign(addinputvars)=naturalCubic;
   effect natCubic=spline(x/knotmethod=equal(4) details naturalcubic);
   model y=natCubic/selection=none noint;
run;

proc template;
   define statgraph naturalBasis;
      beginGraph / designheight=240;
         layout overlay/yaxisopts=(display=(line ticks tickvalues)
                                   offsetmin=0.1 offsetmax=0.1);
            %fns(natCubic_,4);
            referenceline x=0.2;
            referenceline x=0.8;
         endlayout;
      endGraph;
   end;
run;

ods exclude none;
proc sgrender data=naturalCubic template=naturalBasis;
run;

