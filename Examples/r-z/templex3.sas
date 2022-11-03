/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TEMPLEX3                                            */
/*   TITLE: Documentation Example 3 for Template Modification   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphics, ods                                       */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: ods graphics                                        */
/*    MISC:                                                     */
/*   NOTES: This sample provides the DATA step and PROC code    */
/*   from the chapter "ODS Graphics Template Modification."  It */
/*   does not provide most of the ODS statements and style      */
/*   changes that are in the chapter.  Rather, this sample      */
/*   provides code that can be run in one large batch to make   */
/*   all of the graphs in the chapter.  If destinations were    */
/*   repeatedly opened and closed, as in the chapter, then      */
/*   output would be lost and rewritten.  Note that you should  */
/*   not specify destination style changes without first        */
/*   closing a destination.  Changing the style of the output   */
/*   without first closing the destination will not work        */
/*   as you might expect.  Do not do the following:             */
/*                                                              */
/*      ODS HTML STYLE=STATISTICAL;                             */
/*      . . . code . . .                                        */
/*      ODS HTML STYLE=DEFAULT;                                 */
/*      . . . code . . .                                        */
/*      ODS HTML STYLE=ANALYSIS;                                */
/*      . . . code . . .                                        */
/*                                                              */
/*   Instead, do the following:                                 */
/*                                                              */
/*      ODS HTML STYLE=STATISTICAL;                             */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=DEFAULT;                                 */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*      ODS HTML STYLE=ANALYSIS;                                */
/*      . . . code . . .                                        */
/*      ODS HTML CLOSE;                                         */
/*                                                              */
/*   Note that several steps are commented out in this sample,  */
/*   because they create large volumes of output.  To run those */
/*   steps, remove the comments.                                */
/****************************************************************/

proc template;
   source Stat.REG.Graphics.DiagnosticsPanel;
run;

proc template;
   define statgraph Stat.Reg.Graphics.DiagnosticsPanel;
      notes "Diagnostics Panel";
      dynamic _DEPLABEL _DEPNAME _MODELLABEL _OUTLEVLABEL _TOTFREQ _NPARM _NOBS
         _OUTCOOKSDLABEL _SHOWSTATS _NSTATSCOLS _DATALABEL _SHOWNObs
         _SHOWTOTFREQ _SHOWNParm _SHOWEDF _SHOWMSE _SHOWRSquare _SHOWAdjRSq
         _SHOWSSE _SHOWDepMean _SHOWCV _SHOWAIC _SHOWBIC _SHOWCP _SHOWGMSEP
         _SHOWJP _SHOWPC _SHOWSBC _SHOWSP _EDF _MSE _RSquare _AdjRSq _SSE
         _DepMean _CV _AIC _BIC _CP _GMSEP _JP _PC _SBC _SP _byline_ _bytitle_
         _byfootnote_;
      BeginGraph / designheight=defaultDesignWidth;
         entrytitle halign=left textattrs=GRAPHVALUETEXT _MODELLABEL halign=
            center textattrs=GRAPHTITLETEXT "Fit Diagnostics" " for " _DEPNAME;
         layout lattice / columns=2 rowgutter=10 columngutter=10
            shrinkfonts=true rows=2;
            layout overlay / xaxisopts=(shortlabel='Predicted');
               referenceline y=0;
               scatterplot y=RESIDUAL x=PREDICTEDVALUE / primary=true datalabel=
                  _OUTLEVLABEL rolename=(_tip1=OBSERVATION _id1=ID1 _id2=ID2
                  _id3=ID3 _id4=ID4 _id5=ID5) tip=(y x _tip1 _id1 _id2 _id3 _id4
                  _id5);
            endlayout;
            layout overlay / yaxisopts=(label="Residual" shortlabel="Resid")
               xaxisopts=(label="Quantile");
               lineparm slope=eval (STDDEV(RESIDUAL)) y=eval (MEAN(RESIDUAL))
                  x=0 / clip=false extend=true lineattrs=GRAPHREFERENCE;
               scatterplot y=eval (SORT(DROPMISSING(RESIDUAL))) x=eval(
                  PROBIT((NUMERATE(SORT(DROPMISSING(RESIDUAL))) -0.375)/(0.25 +
                  N(RESIDUAL)))) / markerattrs=GRAPHDATADEFAULT primary=true
                  rolename=(s=eval (SORT(DROPMISSING(RESIDUAL))) nq=eval (
                  PROBIT((NUMERATE(SORT(DROPMISSING(RESIDUAL))) -0.375)/(0.25 +
                  N(RESIDUAL))))) tiplabel=(nq="Quantile" s="Residual")
                  tip=(nq s);
            endlayout;
            layout overlayequated / xaxisopts=(shortlabel='Predicted')
               yaxisopts=(label=_DEPLABEL shortlabel="Observed")
               equatetype=square;
               lineparm slope=1 x=0 y=0 / clip=true extend=true lineattrs=
                  GRAPHREFERENCE;
               scatterplot y=DEPVAR x=PREDICTEDVALUE / primary=true datalabel=
                  _OUTLEVLABEL rolename=(_tip1=OBSERVATION _id1=ID1 _id2=ID2
                  _id3=ID3 _id4=ID4 _id5=ID5) tip=(y x _tip1 _id1 _id2 _id3 _id4
                  _id5);
            endlayout;
            layout overlay / xaxisopts=(label="Residual") yaxisopts=(label=
               "Percent");
               histogram RESIDUAL / primary=true;
               densityplot RESIDUAL / name="Normal" legendlabel="Normal"
                  lineattrs=GRAPHFIT;
            endlayout;
         endlayout;
         if (_BYTITLE_)
            entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT;
         else
            if (_BYFOOTNOTE_)
               entryfootnote halign=left _BYLINE_;
            endif;
         endif;
      EndGraph;
   end;
run;

ods graphics on;

proc reg data=sashelp.class;
   model Weight = Height;
quit;

proc template;
   delete Stat.REG.Graphics.DiagnosticsPanel / store=sasuser.templat;
run;
