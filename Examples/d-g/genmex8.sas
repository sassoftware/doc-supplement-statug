
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GENMEX8                                             */
/*   TITLE: Example 8 for PROC GENMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: generalized linear models, model assessment         */
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GENMOD, EXAMPLE 8                              */
/*    MISC:                                                     */
/****************************************************************/


data Surg;
   input Y X1 X2 X3;
   LogX1 = log10(X1);
   datalines;
2.30100       6.70000   62     81
2.00430       5.10000   59     66
2.30960       7.40000   57     83
2.00430       6.50000   73     41
2.70670       7.80000   65    115
1.90310       5.80000   38     72
1.90310       5.70000   46     63
2.10380       3.70000   68     81
2.30540       6.00000   67     93
2.30750       3.70000   76     94
2.51720       6.30000   84     83
1.81290       6.70000   51     43
2.91910       5.80000   96    114
2.51850       5.80000   83     88
2.22530       7.70000   62     67
2.33650       7.40000   74     68
1.93950       6.00000   85     28
1.53150       3.70000   51     41
2.33240       7.30000   68     74
2.23550       5.60000   57     87
2.03740       5.20000   52     76
2.13350       3.40000   83     53
1.84510       6.70000   26     68
2.34240       5.80000   67     86
2.44090       6.30000   59    100
2.15840       5.80000   61     73
2.25770       5.20000   52     86
2.75890      11.20000   76     90
1.85730       5.20000   54     56
2.25040       5.80000   76     59
1.85130       3.20000   64     65
1.76340       8.70000   45     23
2.06450       5.00000   59     73
2.46980       5.80000   72     93
2.06070       5.40000   58     70
2.26480       5.30000   51     99
2.07190       2.60000   74     86
2.07920       4.30000    8    119
2.17900       4.80000   61     76
2.17030       5.40000   52     88
1.97770       5.20000   49     72
1.87510       3.60000   28     99
2.68400       8.80000   86     88
2.18470       6.50000   56     77
2.28100       3.40000   77     93
2.08990       6.50000   40     84
2.49280       4.50000   73    106
2.59990       4.80000   86    101
2.19870       5.10000   67     77
2.49140       3.90000   82    103
2.09340       6.60000   77     46
2.09690       6.40000   85     40
2.29670       6.40000   59     85
2.49550       8.80000   78     72
;

proc print data=Surg;
run;

ods graphics on;

proc genmod data=Surg;
   model Y = X1 X2 X3 / scale=Pearson;
   assess var=(X1) / resample=10000
                     seed=603708000
                     crpanel;
run;

data sim;
   p = 1 / 91;
   sigma = 1;
   beta0 = 0;
   seed =  9364001;
   nsample = 100000;
   do n = 1 to nsample;
      /* generates values of x */
      x = rantbl( seed, p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p,
                        p, p, p, p, p, p, p, p, p, p );

      x = 1 + ( x - 1 ) / 10;

      lp = beta0 + log( x );
      ylog = lp + sigma * rannor( seed );
      lp = beta0 + x + x*x;
      yquad = lp + sigma * rannor( seed );
      lp = beta0 + x + x*x + x*x*x;
      ycubic = lp + sigma * rannor( seed );
      lp = beta0 + ( x > 5 );
      ydisc = lp + sigma * rannor( seed );
      output;
   end;
run;

proc genmod data=sim;
   model ylog = x;
   output out=outlog resraw=rlog;
run;

proc genmod data=sim;
   model yquad = x;
   output out=outquad resraw=rquad;
run;

proc genmod data=sim;
   model ycubic = x x*x;
   output out=outcubic resraw=rcubic;
run;

proc genmod data=sim;
   model ydisc = x;
   output out=outdisc resraw=rdisc;
run;

data all;
   set outlog;
   set outquad;
   set outcubic;
   set outdisc;
run;

proc sort data=all;
   by x;
run;

data A;
   set all;
   y1 + rlog;
   y2 + rquad;
   y3 + rcubic;
   y4 + rdisc;
run;

data B;
   set A;
   by x;
   if last.x then do;
      y1 = y1 / sqrt(nsample);
      y2 = y2 / sqrt(nsample);
      y3 = y3 / sqrt(nsample);
      y4 = y4 / sqrt(nsample);
      output;
   end;
run;

/* 2x2 Panel Plot Template */
proc template;
   define statgraph MisSpecification;
      BeginGraph;
         entrytitle "Covariate Misspecification";
         layout lattice / columns=2 rows=2 columndatarange=unionall;
            columnaxes;
               columnaxis / display=(ticks tickvalues label) label="x";
               columnaxis / display=(ticks tickvalues label) label="x";
            endcolumnaxes;

            cell;
               cellheader;
                  entry "(a) Data: log(X), Model: X";
               endcellheader;
               layout overlay / xaxisopts=(display=none)
                                yaxisopts=(label="Cumulative Residual");
                  seriesplot y=y1 x=x / lineattrs=GraphFit;
               endlayout;
            endcell;
            cell;
               cellheader;
                  entry "(b) Data: X*X, Model: X";
               endcellheader;
               layout overlay / xaxisopts=(display=none)
                                yaxisopts=(label=" ");
                  seriesplot y=y2 x=x /  lineattrs=GraphFit;
               endlayout;
            endcell;

            cell;
               cellheader;
                  entry "(c) Data: X*X*X, Model: X*X";
               endcellheader;
               layout overlay / xaxisopts=(display=none)
                                yaxisopts=(label="Cumulative Residual");
                  seriesplot y=y3 x=x /  lineattrs=GraphFit;
               endlayout;
            endcell;
            cell;
               cellheader;
                  entry "(d) Data: I(X>5), Model: X";
               endcellheader;
               layout overlay / xaxisopts=(display=none)
                                yaxisopts=(label=" ");
                  seriesplot y=y4 x=x /  lineattrs=GraphFit;
               endlayout;
            endcell;
         endlayout;
      EndGraph;
   end;
run;

proc sgrender data=B template=MisSpecification;
run;

proc genmod data=Surg;
   model Y = LogX1 X2 X3 / scale=Pearson;
   assess var=(LogX1) / resample=10000
                        seed=603708000;
run;

