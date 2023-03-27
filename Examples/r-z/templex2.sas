/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TEMPLEX2                                            */
/*   TITLE: Documentation Example 2 for Template Modification   */
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

ods graphics on;
ods trace on;

proc reg data=sashelp.class;
   model weight = height;
run;

proc reg data=sashelp.class;
   ods output fitstatistics=fs ParameterEstimates=c;
   model weight = height;
run;

data _null_;
   set fs;
   if _n_ = 1 then call symputx('R2'  , put(nvalue2, 4.2)   , 'G');
   if _n_ = 2 then call symputx('mean', put(nvalue1, best6.), 'G');
run;

data _null_;
   set c;
   length s $ 200;
   retain s ' ';
   if _n_ = 1 then
      s = trim(dependent) || ' = ' ||       /* dependent =             */
          put(estimate, best5. -L);         /* intercept               */
   else if abs(estimate) > 1e-8 then        /* skip zero coefficients  */
      s = catx(' ', s,                      /* string so far           */
               ifc(estimate < 0, '-', '+'), /* subtract (-) or add (+) */
               put(abs(estimate), best5.),  /* abs(coefficient)        */
               variable);                   /* variable name           */
   call symputx('formula', s, 'G');
run;

proc sgplot data=sashelp.class;
   title 'Simple Linear Regression';
   inset "&formula"
         "R(*ESC*){sup '2'} = &r2"
         "(*ESC*){unicode mu}(*ESC*){unicode hat} = &mean" / position=topleft;
    reg y=weight x=height / clm cli;
run;

proc template;
   source Stat.Reg.Graphics.Fit;
run;

proc template;
   define statgraph Stat.Reg.Graphics.Fit;
      notes "Fit Plot";
      mvar formula;
      dynamic _DEPLABEL _DEPNAME _MODELLABEL _SHOWSTATS _NSTATSCOLS _SHOWNObs
         _SHOWTOTFREQ _SHOWNParm _SHOWEDF _SHOWMSE _SHOWRSquare _SHOWAdjRSq
         _SHOWSSE _SHOWDepMean _SHOWCV _SHOWAIC _SHOWBIC _SHOWCP _SHOWGMSEP
         _SHOWJP _SHOWPC _SHOWSBC _SHOWSP _NObs _NParm _EDF _MSE _RSquare
         _AdjRSq _SSE _DepMean _CV _AIC _BIC _CP _GMSEP _JP _PC _SBC _SP
         _PREDLIMITS _CONFLIMITS _XVAR _SHOWCLM _SHOWCLI _WEIGHT _SHORTXLABEL
         _SHORTYLABEL _TITLE _TOTFreq _byline_ _bytitle_ _byfootnote_;
      BeginGraph;
         entrytitle halign=left textattrs=GRAPHVALUETEXT _MODELLABEL
            halign=center textattrs=GRAPHTITLETEXT _TITLE " for " _DEPNAME;
         layout Overlay / yaxisopts=(label=_DEPLABEL shortlabel=_SHORTYLABEL)
            xaxisopts=(shortlabel=_SHORTXLABEL);
            if (_SHOWCLM=1)
               BANDPLOT limitupper=UPPERCLMEAN limitlower=LOWERCLMEAN x=_XVAR
                  / fillattrs=GRAPHCONFIDENCE connectorder=axis
                  name="Confidence" LegendLabel=_CONFLIMITS;
            endif;
            if (_SHOWCLI=1)
               if (_WEIGHT=1)
                  SCATTERPLOT y=PREDICTEDVALUE x=_XVAR / markerattrs=(size=0)
                     datatransparency=.6 yerrorupper=UPPERCL
                     yerrorlower=LOWERCL name="Prediction"
                     LegendLabel=_PREDLIMITS;
               else
                  BANDPLOT limitupper=UPPERCL limitlower=LOWERCL x=_XVAR /
                     display=(outline) outlineattrs=GRAPHPREDICTIONLIMITS
                     connectorder=axis name="Prediction"
                     LegendLabel=_PREDLIMITS;
               endif;
            endif;
            SCATTERPLOT y=DEPVAR x=_XVAR / markerattrs=GRAPHDATADEFAULT
               primary=true rolename=(_tip1=OBSERVATION _id1=ID1 _id2=ID2
               _id3=ID3 _id4=ID4 _id5=ID5)
               tip=(y x _tip1 _id1 _id2 _id3 _id4 _id5);
            SERIESPLOT y=PREDICTEDVALUE x=_XVAR / lineattrs=GRAPHFIT
               connectorder=xaxis name="Fit" LegendLabel="Fit";
            if (_SHOWCLI=1 OR _SHOWCLM=1)
               DISCRETELEGEND "Fit" "Confidence" "Prediction" / across=3
                  HALIGN=CENTER VALIGN=BOTTOM;
            endif;
            layout gridded / autoalign=(topleft topright bottomleft
                                        bottomright);
               entry halign=left formula;
               entry halign=left "R"{sup '2'} " = " eval(put(_rsquare, 4.2));
               entry halign=left "(*ESC*){unicode mu}(*ESC*){unicode hat} = "
                     eval(put(_depmean, best6.))
                     / textattrs=GraphValueText
                                 (family=GraphUnicodeText:FontFamily);
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

proc reg data=sashelp.class;
   model weight = height;
run;

proc template;
   delete Stat.Reg.Graphics.Fit / store=sasuser.templat;
run;

proc transreg data=sashelp.class ss2;
   ods output fitstatistics=fs coef=c;
   model identity(weight) = pspline(height);
run;

data _null_;
   set fs;
   if _n_ = 1 then call symputx('R2'  , put(value2, 4.2)   , 'G');
   if _n_ = 2 then call symputx('mean', put(value1, best6.), 'G');
run;

data _null_;
   set c end=eof;
   length s $ 200 c $ 1;
   retain s ' ';
   if _n_ = 1 then
      s = scan(dependent, 2, '()') || ' = ' ||    /* dependent =             */
          put(coefficient, best5. -L);            /* intercept               */
   else if abs(coefficient) > 1e-8 then do;       /* skip zero coefficients  */
      s = catx(' ', s,                            /* string so far           */
               ifc(coefficient < 0, '-', '+'),    /* subtract (-) or add (+) */
               put(abs(coefficient), best5. -L ), /* abs(coefficient)        */
               scan(variable, 2, '._'));          /* variable name           */
      c = scan(variable, 2, '_');                 /* grab power              */
      if c ne '1' then                            /* skip power for linear   */
         s = cats(s, "(*ESC*){sup '", c, "'}");   /* add superscript         */
   end;
   if eof then call symputx('formula', trim(s), 'G');
run;

proc sgplot data=sashelp.class;
   title 'Cubic Fit Function';
   inset "&formula"
         "R(*ESC*){sup '2'} = &r2"
         "(*ESC*){unicode mu}(*ESC*){unicode hat} = &mean" / position=topleft;
    reg y=weight x=height / degree=3 cli clm;
run;

%let l = halign=left;
proc template;
   define statgraph class;
      begingraph / designheight=640px designwidth=520px;
         layout overlay / xaxisopts=(display=none) yaxisopts=(display=none);
            layout gridded / columns=3 autoalign=(topleft);
               entry &l textattrs=(weight=bold) 'Description';
               entry &l textattrs=(weight=bold) 'Displayed';
               entry &l textattrs=(weight=bold) "Unicode";
               entry &l 'R Square';
               entry &l 'R' {sup '2'};
               entry &l "'R' {sup '2'}";
               entry &l 'y hat sub i';
               entry &l 'y' {unicode hat}{sub 'i'};
               entry &l "'y' {unicode hat}{sub 'i'}";
               entry &l 'plus or minus';
               entry &l '7 ' {unicode '00B1'x} ' 2';
               entry &l "'7 ' {unicode '00B1'x} ' 2'";
               entry &l 'not equal to             ';
               entry &l 'a ' {unicode '2260'x} ' b';
               entry &l "'a ' {unicode '2260'x} ' b'";
               entry &l 'less than or equal       ';
               entry &l 'a ' {unicode '2264'x} ' b';
               entry &l "'a ' {unicode '2264'x} ' b'";
               entry &l 'greater than or equal    ';
               entry &l 'b ' {unicode '2265'x} ' a';
               entry &l "'b ' {unicode '2265'x} ' a'";
               entry &l 'almost equal';
               entry &l 'a ' {unicode '2248'x} ' b';
               entry &l "'a ' {unicode '2248'x} ' b'";
               entry &l 'infinity';
               entry &l {unicode '221e'x};
               entry &l "{unicode '221e'x}";
               entry &l 'combining tilde';
               entry &l 'El nin' {unicode tilde} 'o';
               entry &l "'El nin' {unicode tilde} 'o'";
               entry &l 'grave accent';
               entry &l 'cre' {unicode '0300'x} 'me';
               entry &l "'cre' {unicode '0300'x} 'me'";
               entry &l 'circumflex, acute accent   ';
               entry &l 'bru' {unicode '0302'x} 'le' {unicode '0301'x} 'e';
               entry &l "'bru' {unicode '0302'x} 'le' {unicode '0301'x} 'e'";
               entry &l 'degree sign';
               entry &l '90' {unicode '00B0'x} ' angle';
               entry &l "'90' {unicode '00B0'x} ' angle'";
               entry &l 'euro sign';
               entry &l {unicode '20AC'x} '100';
               entry &l "{unicode '20AC'x} '100'";
               entry &l 'cent sign';
               entry &l '25' {unicode '00A2'x};
               entry &l "'25' {unicode '00A2'x}";
               entry &l 'copyright';
               entry &l {unicode '00a9'x};
               entry &l "{unicode '00a9'x}";
               entry &l 'bullet';
               entry &l {unicode '2022'x};
               entry &l "{unicode '2022'x}";
               entry &l 'alpha';
               entry &l {unicode alpha} '   ' {unicode alpha_u};
               entry &l "{unicode alpha} '   ' {unicode alpha_u}";
               entry &l 'beta';
               entry &l {unicode beta} '   ' {unicode beta_u};
               entry &l "{unicode beta} '   ' {unicode beta_u}";
               entry &l 'gamma';
               entry &l {unicode gamma} '   ' {unicode gamma_u};
               entry &l "{unicode gamma} '   ' {unicode gamma_u}";
               entry &l 'delta';
               entry &l {unicode delta} '   ' {unicode delta_u};
               entry &l "{unicode delta} '   ' {unicode delta_u}";
               entry &l 'epsilon';
               entry &l {unicode epsilon} '   ' {unicode epsilon_u};
               entry &l "{unicode epsilon} '   ' {unicode epsilon_u}";
               entry &l 'zeta';
               entry &l {unicode zeta} '   ' {unicode zeta_u};
               entry &l "{unicode zeta} '   ' {unicode zeta_u}";
               entry &l 'eta';
               entry &l {unicode eta} '   ' {unicode eta_u};
               entry &l "{unicode eta} '   ' {unicode eta_u}";
               entry &l 'theta';
               entry &l {unicode theta} '   ' {unicode theta_u};
               entry &l "{unicode theta} '   ' {unicode theta_u}";
               entry &l 'iota';
               entry &l {unicode iota} '   ' {unicode iota_u};
               entry &l "{unicode iota} '   ' {unicode iota_u}";
               entry &l 'kappa';
               entry &l {unicode kappa} '   ' {unicode kappa_u};
               entry &l "{unicode kappa} '   ' {unicode kappa_u}";
               entry &l 'lambda';
               entry &l {unicode lambda} '   ' {unicode lambda_u};
               entry &l "{unicode lambda} '   ' {unicode lambda_u}";
               entry &l 'mu';
               entry &l {unicode mu} '   ' {unicode mu_u};
               entry &l "{unicode mu} '   ' {unicode mu_u}";
               entry &l 'nu';
               entry &l {unicode nu} '   ' {unicode nu_u};
               entry &l "{unicode nu} '   ' {unicode nu_u}";
               entry &l 'xi';
               entry &l {unicode xi} '   ' {unicode xi_u};
               entry &l "{unicode xi} '   ' {unicode xi_u}";
               entry &l 'omicron';
               entry &l {unicode omicron} '   ' {unicode omicron_u};
               entry &l "{unicode omicron} '   ' {unicode omicron_u}";
               entry &l 'pi';
               entry &l {unicode pi} '   ' {unicode pi_u};
               entry &l "{unicode pi} '   ' {unicode pi_u}";
               entry &l 'rho';
               entry &l {unicode rho} '   ' {unicode rho_u};
               entry &l "{unicode rho} '   ' {unicode rho_u}";
               entry &l 'sigma';
               entry &l {unicode sigma} '   ' {unicode sigma_u};
               entry &l "{unicode sigma} '   ' {unicode sigma_u}";
               entry &l 'tau';
               entry &l {unicode tau} '   ' {unicode tau_u};
               entry &l "{unicode tau} '   ' {unicode tau_u}";
               entry &l 'upsilon';
               entry &l {unicode upsilon} '   ' {unicode upsilon_u};
               entry &l "{unicode upsilon} '   ' {unicode upsilon_u}";
               entry &l 'phi';
               entry &l {unicode phi} '   ' {unicode phi_u};
               entry &l "{unicode phi} '   ' {unicode phi_u}";
               entry &l 'chi';
               entry &l {unicode chi} '   ' {unicode chi_u};
               entry &l "{unicode chi} '   ' {unicode chi_u}";
               entry &l 'psi';
               entry &l {unicode psi} '   ' {unicode psi_u};
               entry &l "{unicode psi} '   ' {unicode psi_u}";
               entry &l 'omega';
               entry &l {unicode omega} '   ' {unicode omega_u};
               entry &l "{unicode omega} '   ' {unicode omega_u}";
            endlayout;
            scatterplot y=weight x=height / markerattrs=(size=0);
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=sashelp.class template=class;
run;

%let sym = ArrowDown Asterisk Circle CircleFilled Diamond DiamondFilled
           GreaterThan Hash IBeam Plus Square SquareFilled Star StarFilled
           Tack Tilde Triangle TriangleFilled Union X Y Z;
%let uni = 2193 002A 25cb 25cf 25c7 2666 003e 0023 2336 002b 25a1 25a0 2606
           2605 22a4 223c 25b3 25b2 222a 0058 0059 005a;

data x;
   retain fmtname '$markers' x1 0 x2 0.1 x3 1 x4 0.9;
   length m $ 20 u $ 4 l label $ 30;
   do y     = 1 to 22;
      m     = scan("&sym", y);
      u     = scan("&uni", y);
      l     = cat("{unicode '", u, "'x}");
      label = catt('(*ESC*)', l);
      start = m;
      output;
   end;
run;

proc format cntlin=x;
run;

ods graphics on / attrpriority=none width=3in height=4in;

proc sgplot data=x noautolegend;
   title justify=left ' Markers' justify=right 'Unicode Characters';
   styleattrs datasymbols=(&sym) datacontrastcolors=(black);
   scatter x=x1 y=y / group=m;
   text    x=x2 y=y text=m / position=right;
   scatter x=x3 y=y / markerchar=start
                      markercharattrs=(size=9 family='Arial Unicode MS');
   text    x=x4 y=y text=l / position=right;
   format  start $markers.;
   xaxis   display=none offsetmin=0.05 offsetmax=0.27;
   yaxis   display=none offsetmin=0.01 offsetmax=0.05 reverse;
run;

ods graphics on / reset=all;
title;

