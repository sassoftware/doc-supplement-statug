/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CANDGS                                              */
/*   TITLE: Getting Started Example for PROC CANDISC            */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis, multivariate analysis        */
/*   PROCS: CANDISC                                             */
/*    DATA: SASHELP.FISH DATA                                   */
/*                                                              */
/*     REF: PROC CANDISC, GETTING STARTED EXAMPLE               */
/*    MISC:                                                     */
/****************************************************************/

title 'Fish Measurement Data';

proc candisc data=sashelp.fish ncan=3 out=outcan;
   ods exclude tstruc bstruc pstruc tcoef pcoef;
   class Species;
   var Weight Length1 Length2 Length3 Height Width;
run;

proc template;
   define statgraph scatter;
      begingraph / attrpriority=none;
         entrytitle 'Fish Measurement Data';
         layout overlayequated / equatetype=fit
            xaxisopts=(label='Canonical Variable 1')
            yaxisopts=(label='Canonical Variable 2');
            scatterplot x=Can1 y=Can2 / group=species name='fish'
                                        markerattrs=(size=3px);
            layout gridded / autoalign=(topright);
               discretelegend 'fish' / border=false opaque=false;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=outcan template=scatter;
run;

