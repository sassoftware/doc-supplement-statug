/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CANDEX1                                             */
/*   TITLE: Documentation Example for PROC CANDISC              */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis, multivariate analysis        */
/*   PROCS: CANDISC                                             */
/*    DATA: FISHER (1936) IRIS DATA - SASHELP.IRIS              */
/*                                                              */
/*     REF: PROC CANDISC, EXAMPLE 1                             */
/*    MISC:                                                     */
/****************************************************************/

title 'Fisher (1936) Iris Data';

proc candisc data=sashelp.iris out=outcan distance anova;
   class Species;
   var SepalLength SepalWidth PetalLength PetalWidth;
run;

proc template;
   define statgraph scatter;
      begingraph / attrpriority=none;
         entrytitle 'Fisher (1936) Iris Data';
         layout overlayequated / equatetype=fit
            xaxisopts=(label='Canonical Variable 1')
            yaxisopts=(label='Canonical Variable 2');
            scatterplot x=Can1 y=Can2 / group=species name='iris'
                                        markerattrs=(size=3px);
            layout gridded / autoalign=(topright topleft);
               discretelegend 'iris' / border=false opaque=false;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=outcan template=scatter;
run;

