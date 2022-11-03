/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR07                                             */
/*   TITLE: Customizing Graph Titles and Axes Labels            */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, customizing titles and axes labels    */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data stack;
   input  x1 x2 x3 y @@;
   datalines;
80  27  89  42    80  27  88  37    75  25  90  37
62  24  87  28    62  22  87  18    62  23  87  18
62  24  93  19    62  24  93  20    58  23  87  15
58  18  80  14    58  18  89  14    58  17  88  13
58  18  82  11    58  19  93  12    50  18  89   8
50  18  86   7    50  19  72   8    50  19  79   8
50  20  80   9    56  20  82  15    70  20  91  15
;


/* Displaying original Q-Q plot */
ods html;  /* On z/OS, replace this with ods html path=".";  */
ods graphics on;
ods trace on;

title 'Original Q-Q plot';
ods select ResidualQQPlot;

proc robustreg plot=resqqplot data=stack;
   model y = x1 x2 x3;
run;


/* Displaying template definition in SAS log */
proc template;
   source Stat.Robustreg.Graphics.ResidualQQPlot;
run;


/* Modifying title and y-axis label */
proc template;
define statgraph Stat.Robustreg.Graphics.ResidualQQPlot;
notes "Q-Q Plot for Standardized Robust Residuals";
dynamic _DEPLABEL Residual;
layout Gridded;
   layout Gridded / columns=2;
      ENTRYTITLE "My Favorite Title" / pad=(bottom=5);
   EndLayout;
   layout Overlay /
      yaxisopts=(label=_DEPLABEL display=all)
      xaxisopts=(label="Normal Quantile" display=all);
      SCATTERPLOT y=eval(SORT(DROPMISSING(RESIDUAL)))
         x=eval(PROBIT((NUMERATE(SORT(DROPMISSING(RESIDUAL)))
                -0.375)/(0.25+N(RESIDUAL)))) /
            primary=true
            markerattrs=(size=GraphDataDefault:markersize
                         symbol=GraphDataDefault:markersymbol
                         color=GraphDataDefault:contrastcolor)
            legendlabel="Residual" Name="Data";
      lineparm slope=eval(STDDEV(RESIDUAL)) Y=eval(MEAN(RESIDUAL)) /
         lineattrs=(color=StatGraphFitLine:contrastcolor
                    pattern=StatGraphFitLine:linestyle
                    thickness=StatGraphFitLine:linethickness)
         legendlabel="Normal" name="Fit" extend=true;
      DiscreteLegend "Fit" "Data" / border=true across=2
         backgroundattrs=(color=GraphWalls:BackgroundColor);
   EndLayout;
EndLayout;
end;
run;


/* Displaying modified Q-Q plot */
title 'Modified Q-Q plot';
ods select ResidualQQPlot;

proc robustreg plot=resqqplot data=stack;
   model y = x1 x2 x3;
run;

ods graphics off;
ods html close;
ods trace off;
title;
