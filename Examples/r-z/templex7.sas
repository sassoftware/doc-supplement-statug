/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TEMPLEX7                                            */
/*   TITLE: Documentation Example 7 for Template Modification   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods                                       */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES:                                                     */
/****************************************************************/

%let vars =  nAtBat  nHits  nHome  nRuns  nRBI  nBB  nOuts nAssts
            CrAtBat CrHits CrHome CrRuns CrRbi CrBB;

proc glm noprint data=sashelp.baseball;
   class div;
   model logsalary = div &vars;
   output out=pvals p=p;
quit;

%marginal(independents=&vars, dependent=LogSalary, predicted=p)

proc glm noprint data=sashelp.baseball;
   class div;
   model logsalary = div CrHome;
   output out=pvals p=p;
quit;

%marginal(independents=CrHome, dependent=LogSalary, predicted=p,
          panel=1 3, gopts=designheight=250px)

proc glm noprint data=sashelp.baseball;
   class div;
   model logsalary = div CrHome CrRuns;
   output out=pvals p=p;
quit;

%marginal(independents=CrHome CrRuns, dependent=LogSalary, predicted=p)

%let vars = nHits nHome nRuns CrHits CrHome CrRuns CrRbi;

proc glm noprint data=sashelp.baseball;
   class div;
   model logsalary = div &vars;
   output out=pvals p=p;
quit;

%marginal(independents=&vars, dependent=LogSalary, predicted=p)

proc glm noprint data=sashelp.baseball;
   class div;
   model logsalary = div CrAtBat CrHits CrHome;
   output out=pvals p=p;
quit;

%marginal(independents=CrAtBat CrHits CrHome,
          dependent=LogSalary, predicted=p, panel=1)

proc template;
   define statgraph __marginal;
      dynamic _ivar1 _ivar2 _ivar3 ncells pplot;
      begingraph / designwidth=defaultdesignheight;
         entrytitle "Marginal Models for LogSalary";
         legenditem type=line name='a' / lineattrs=GRAPHFIT label='Data';
         legenditem type=line name='b' / lineattrs=GRAPHFIT2 label='Model';
         layout lattice / columns=2 rows=2 rowdatarange=unionall rowgutter=10
            columngutter=10;
            if (1 LE NCELLS)
               layout overlay / yaxisopts=(display=none)
                                xaxisopts=(display=(label));
                  scatterplot y=LOGSALARY x=_IVAR1;
                  loessplot y=LOGSALARY x=_IVAR1 /;
                  loessplot y=P x=_IVAR1 / lineattrs=GRAPHFIT2;
               endlayout;
            endif;
            if (2 LE NCELLS)
               layout overlay / yaxisopts=(display=none)
                                xaxisopts=(display=(label));
                  scatterplot y=LOGSALARY x=_IVAR2;
                  loessplot y=LOGSALARY x=_IVAR2 /;
                  loessplot y=P x=_IVAR2 / lineattrs=GRAPHFIT2;
               endlayout;
            endif;
            if (3 LE NCELLS)
               layout overlay / yaxisopts=(display=none)
                                xaxisopts=(display=(label));
                  scatterplot y=LOGSALARY x=_IVAR3;
                  loessplot y=LOGSALARY x=_IVAR3 /;
                  loessplot y=P x=_IVAR3 / lineattrs=GRAPHFIT2;
               endlayout;
            endif;
            if (PPLOT)
               layout overlay / yaxisopts=(display=none)
                                xaxisopts=(display=(label)
                  label='Predicted Values');
                  scatterplot y=LOGSALARY x=P;
                  loessplot y=LOGSALARY x=P /;
                  seriesplot y=_Y x=_X / lineattrs=GRAPHFIT2;
               endlayout;
            endif;
            layout overlay / yaxisopts=(display=none)
                                xaxisopts=(display=none);
               discretelegend 'a' 'b' / location=inside across=1 border=false;
            endlayout;
         endlayout;
      endgraph;
   end;
quit;

proc template;
   define statgraph __marginal;
      dynamic _ivar1 ncells pplot;
      begingraph / designwidth=defaultdesignheight;
         entrytitle "Marginal Models for LogSalary";
         legenditem type=line name='a' / lineattrs=GRAPHFIT label='Data';
         legenditem type=line name='b' / lineattrs=GRAPHFIT2 label='Model';
         layout lattice / columns=1 rows=1 rowdatarange=unionall
                          rowgutter=10 columngutter=10;
            if (1 LE NCELLS)
               layout overlay / yaxisopts=(display=none)
                                xaxisopts=(display=(label));
                  scatterplot y=LOGSALARY x=_IVAR1;
                  loessplot y=LOGSALARY x=_IVAR1 /;
                  loessplot y=P x=_IVAR1 / lineattrs=GRAPHFIT2;
                  layout gridded / autoalign=(topright topleft bottomright
                                              bottomleft);
                     discretelegend 'a' 'b' / location=inside across=1;
                  endlayout;
               endlayout;
            endif;
            if (PPLOT)
               layout overlay / yaxisopts=(display=none)
                      xaxisopts=(display=(label) label='Predicted Values');
                  scatterplot y=LOGSALARY x=P;
                  loessplot y=LOGSALARY x=P /;
                  seriesplot y=_Y x=_X / lineattrs=GRAPHFIT2;
                  layout gridded / autoalign=(topright topleft bottomright
                     bottomleft);
                     discretelegend 'a' 'b' / location=inside across=1;
                  endlayout;
               endlayout;
            endif;
         endlayout;
      endgraph;
   end;
quit;
