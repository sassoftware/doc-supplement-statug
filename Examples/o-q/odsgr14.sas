/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR14                                             */
/*   TITLE: Modifying Panels                                    */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, modifying panels                      */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Class;
   input Name $ Height Weight Age @@;
   datalines;
Alfred  69.0 112.5 14  Alice  56.5  84.0 13  Barbara 65.3  98.0 13
Carol   62.8 102.5 14  Henry  63.5 102.5 14  James   57.3  83.0 12
Jane    59.8  84.5 12  Janet  62.5 112.5 15  Jeffrey 62.5  84.0 13
John    59.0  99.5 12  Joyce  51.3  50.5 11  Judy    64.3  90.0 14
Louise  56.3  77.0 12  Mary   66.5 112.0 15  Philip  72.0 150.0 16
Robert  64.8 128.0 12  Ronald 67.0 133.0 15  Thomas  57.5  85.0 11
William 66.5 112.0 15
;


/* Displaying template definition in SAS log */
proc template;
   source Stat.Reg.Graphics.DiagnosticsPanel;
run;


/* Modifying diagnostics panel template definition */
proc template;
define statgraph Stat.Reg.Graphics.DiagnosticsPanel;
   notes "Diagnostics Panel";
   dynamic _TITLE _MODELLABEL _DEPLABEL _NOBS _NPARM _EDF _MSE _RSquare _AdjRSq;
   /* 2x2 LATTICE layout */
   layout lattice / columns=2 rowgutter=10 height=640px rows=2;
      sidebar / align=top;
         layout overlay / pad=( bottom=5 );
            entrytitle halign=left textattrs=(family=GraphValueText:fontFace
            weight=
               GraphValueText:fontWeight style=GraphValueText:fontStyle size=
               GraphValueText:fontSize ) _MODELLABEL halign=center
                textattrs=( family=
               GraphTitleText:fontFace weight=GraphTitleText:fontWeight style=
               GraphTitleText:fontStyle size=GraphTitleText:fontSize )
               "Fit Diagnostics" " for "
               _DEPLABEL;
         endlayout;
      endsidebar;
      /* 1. Residual By Predicted */
      layout overlay / yaxisopts=( display=STANDARD )
         xaxisopts=( display=STANDARD );
         lineparm slope=0 y=0 x=0 / extend=true
         lineattrs=( color=GraphReferenceLines:foreground
            thickness=GraphReferenceLines:linethickness
            pattern=GraphReferenceLines:linestyle );
         scatterplot y=RESIDUAL x=PREDICTEDVALUE / markerattrs=( symbol=
            GraphDataDefault:markersymbol
           color=GraphDataDefault:contrastcolor size=
            GraphDataDefault:markersize ) primary=true
            rolename=( _tip1=OBSERVATION ) tip=( y x _tip1 );
      endlayout;
      /* 4. Q-Q Plot */
      layout overlay / yaxisopts=( label="Residual" )
         xaxisopts=( label="Quantile" );
         lineparm slope=eval (STDDEV(RESIDUAL)) y=eval (MEAN(RESIDUAL)) x=0 /
            extend=true lineattrs=(
            color=GraphReferenceLines:foreground
            thickness=GraphReferenceLines:linethickness
            pattern=GraphReferenceLines:linestyle );
         scatterplot y=eval (SORT(DROPMISSING(RESIDUAL))) x=eval
            (PROBIT((NUMERATE(SORT(DROPMISSING(RESIDUAL))) -0.375)/
                   (0.25 + N(RESIDUAL)))) /
            markerattrs=( symbol=GraphDataDefault:markersymbol
                color=GraphDataDefault:contrastcolor
            size=GraphDataDefault:markersize ) primary=true;
      endlayout;
      /* 6. Cook's D Plot */
      layout overlay / xaxisopts=( linearopts= ( integer=true ) );
         lineparm y=eval (4./_NOBS) x=0 slope=0 / extend=true
            lineattrs=( color=GraphReferenceLines:foreground
            thickness=GraphReferenceLines:linethickness
            pattern=GraphReferenceLines:linestyle );
         needleplot y=COOKSD x=OBSERVATION / primary=true;
      endlayout;
      /* 7. Residual Histogram */
      layout overlay / xaxisopts=( label="Residual" )
         yaxisopts=( label="Percent" );
         histogram RESIDUAL / primary=true;
         densityplot RESIDUAL / name="Normal" legendlabel="Normal"
            lineattrs=( color=
            StatGraphFitLine:contrastcolor
            thickness=StatGraphFitLine:linethickness
            pattern=
            StatGraphFitLine:linestyle );
      endlayout;
      /*  9. Summary Statistics Box in a SIDEBAR */
      sidebar / align = bottom;
         layout gridded;
            layout lattice / rows = 1 columns = 4 border = TRUE
                   backgroundattrs=(color=GraphWalls:color);
               layout gridded / columns = 2;
                  entry "NObs=";
                  entry eval(PUT(_NOBS,BEST6.));
               endlayout;
               layout gridded / columns = 2;
                  entry "MSE=";
                  entry eval(PUT(_MSE,BEST6.));
               endlayout;
               layout gridded / columns = 2;
                  entry "R^2=";
                  entry eval(PUT(_RSQUARE,BEST6.));
               endlayout;
               layout gridded / columns = 2;
                  entry "Adj R^2=";
                  entry eval(PUT(_ADJRSQ,BEST6.));
               endlayout;
            endlayout;
         endlayout;
      endsidebar;
   endlayout; /* End of 2x2 LATTICE layout */
end;
run;


/* Displaying modified diagnostics panel */
ods html;  /* On z/OS, replace this with ods html path=".";  */
ods graphics on;

ods select DiagnosticsPanel;

proc reg data = Class;
   model Weight = Height;
run;
quit;

ods graphics off;
ods html close;
