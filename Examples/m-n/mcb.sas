 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MCB                                                 */
 /*   TITLE: Macro for Multiple Comparisons with the Best Mean   */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: multiple comparisons, ranking and selection,        */
 /*    KEYS: bioequivalence                                      */
 /*   PROCS: MIXED, SORT, TRANSPOSE, PRINT, DATASETS             */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: Hsu, 1995                                           */
 /*    MISC:                                                     */
 /****************************************************************/

 /*-------------------------------------------------------------------

 DISCLAIMER:

 THIS INFORMATION IS PROVIDED BY SAS INSTITUTE INC. AS  A  SERVICE  TO
 ITS USERS.  IT  IS  PROVIDED  "AS  IS".   THERE  ARE  NO  WARRANTIES,
 EXPRESSED  OR  IMPLIED,  AS  TO  MERCHANTABILITY  OR  FITNESS  FOR  A
 PARTICULAR PURPOSE REGARDING THE ACCURACY OF THE  MATERIALS  OR  CODE
 CONTAINED HEREIN.

 -------------------------------------------------------------------*/

 /********************************************************************

Abstract:

   Given a SAS data  set  with  a  grouping  variable  and  a  numeric
   response variable, the macros defined here compute the within-group
   means of the  response,  confidence  intervals,  and  p-values  for
   multiple   comparisons   with  the  best  mean  (MCB).   Confidence
   intervals may be either constrained to contain 0 (%MCB and %MCW) or
   unconstrained (%UMCB and %UMCW); comparisons may be with either the
   maximum mean (%MCB and %UMCB) or the minimum mean (%MCW and %UMCW).



Introduction:

   You  are  conducting  an  experiment  on  the  effects  of  several
   alternative drugs for treating a certain disease.  The goal  is  to
   determine which drugs are most effective.   This  is  the  task  of
   multiple comparisons---finding which groups are superior  to  which
   other groups, and doing so in a manner which controls the  over-all
   probability of an incorrect inference.  However, in this  case  not
   all pairwise differences are of interest: you only want to  compare
   each drug with the true best drug.

   This situation is called multiple comparisons with the best or  MCB
   (Hsu, 1996).  It is related to  several  other  multiple  inference
   techniques,   such   as  bioequivalence  testing  and  ranking  and
   selection (op cit.).  MCB  may  assert  certain  treatments  to  be
   inferior to the true best, and other treatments to be within such a
   small distance of the true best that you may consider  them  to  be
   practically equivalent to the best.

   By giving  up  the  ability  to  say  precisely  how  inferior  the
   not-the-best treatments are, MCB provides  sharper  inference  than
   can be achieved by evaluating all  pairwise  comparisons.   On  the
   other hand, if you need  to  know  how  inferior  the  not-the-best
   treatments are, unconstrained multiple comparisons  with  the  best
   (UMCB) provides this sort of analysis.  MCB is executed by multiply
   performing a  one-sided  Dunnett's  test  for  comparisons  with  a
   control, in turn treating each of  the  alternative  drugs  as  the
   control which is potentially the best; UMCB  deduces from two-sided
   Dunnett's  tests (or alternatively from Tukey's all-pairwise test.)

   You can use the %MCB macro to perform MCB analysis, and  the  %UMCB
   macro to perform UMCB analysis, where  in  both  cases  the  "best"
   population mean is defined as the maximum one; use %MCW  and  %UMCW
   if you want to treat the minimum population  mean  as  the  "best".
   These macros use the MIXED procedure  and  the  output  manager  to
   perform Dunnett's and Tukey's tests and write the  results  to  SAS
   data sets, which are then processed to compute the standard form of
   MCB and UMCB analysis, respectively.



Syntax:

   The following arguments are required by each of the  macros.   They
   must be the first three arguments and they must be in  this  order.
   Do not use keywords for these arguments.

       - the SAS data set containing the data to be analyzed
       - the response variable
       - the grouping variable

   The following additional arguments may  be  listed  in  any  order,
   separated by commas:

       MODEL=   a linear model for the response, specified  using  the
                effects syntax of GLM.  The default is a one-way model
                in the required grouping variable.

       CLASS=   classification variables involved in the linear model.
                The default is the required grouping variable.

       ALPHA=   the level of significance for  comparisons  among  the
                means.  The default is 0.05.

       OUT=     the name of the  output  dataset  containing  the  MCB
                analysis.  The default is MCBOUT.

       OPTIONS= a string containing either of the following options

                  NOPRINT - suppresses printed output of results
                  NOCLEAN - suppresses deletion of temporary datasets



Output:

   The output dataset contains one observation for each group  in  the
   dataset.  For all four macros the  output  data  set  contains  the
   following variables:

      LEVEL  - formatted value of this group

      LSMEAN - sample mean response within this group

      SE     - standard error of the sample mean for this group

      CLLO   - lower confidence limit for the difference  between  the
               population mean of this group and the  best  population
               mean

      CLHI   - upper confidence limit for the difference  between  the
               population mean of this group and the  best  population
               mean

   To facilitate ranking and selection inference, the  output  dataset
   for the %MCB and %MCW  macros  contains  the  following  additional
   variables:

      RVAL   - the smallest alpha level at which the  population  mean
               of this group can be rejected  as  the  best,  for  all
               groups but the one with the best sample mean

      SVAL   - the smallest alpha level at which the  population  mean
               of this group can be selected as  the  best  treatment,
               for the group with the best sample mean




Example: Comparison of filters

   Hsu (1984) reports the results of a  study  undertaken  to  compare
   seven different brands of water filter.  For each brand, samples of
   water were run through three filters  and  then  the  filters  were
   incubated; the response is the number of bacterial  colonies  grown
   on filter.  Some of the data are missing.  The following data  step
   creates the FILTER dataset:

      data filter;
         do brand = 1 to 7;
            do i = 1 to 3;
               input ncolony @@;
               output;
               end;
            end;
         datalines;
       69 122  95
      118 154 102
      171 132 182
      122 119   .
      204 225 190
      140 130 127
      170 165   .
      ;

   A better filter is one that captures more bacteria and thus  has  a
   higher colony count.  Thus, the %MCB macro is appropriate:

      %inc '<location of SAS/STAT samples>mcb.sas';
      %mcb(filter,ncolony,brand);

   This yields the following results:

  +------------------------------------------------------------------+
  | EFFECT  BRAND   LSMEAN      SE      CLLO    CLHI     RVAL   SVAL |
  |                                                                  |
  | BRAND     1     95.333  11.707   -153.94  0.0000   0.0001  .     |
  | BRAND     2    124.667  11.707   -124.61  0.0000   0.0009  .     |
  | BRAND     3    161.667  11.707   -87.608  0.0000   0.0418  .     |
  | BRAND     4    120.500  14.339   -133.84  0.0000   0.0013  .     |
  | BRAND     5    206.333  11.707    -7.950 86.8428    .     0.1006 |
  | BRAND     6    132.333  11.707   -116.94  0.0000   0.0019  .     |
  | BRAND     7    167.500  14.339   -86.843  7.9498   0.1006  .     |
  +------------------------------------------------------------------+

   The filter brand with the highest colony count was  number  5,  but
   since the lower endpoint of the 95%  confidence  interval  for  the
   difference between it and the best is negative,  we  cannot  assert
   that this particular brand is the best.  However, we can  say  that
   either brand 5 or 7 is the best,  since  these  are  the  only  two
   brands for which the confidence interval properly contains 0.



References:

   Hsu,   Jason   C.   (1984)  "Ranking  and  Selection  and  Multiple
      Comparisons with the Best." In  _Design_of_Experiments:_Ranking_
      _and_Selection_, eds.  Thomas J.  Santner and Ajit C.   Tamhane.
      Marcel Dekker, NY.

   Hsu, Jason C. (1996).   _Multiple_Comparisons:_Theory_and_methods_,
      Chapman & Hall, NY.

 *********************************************************************/









%macro n2cclass(dsin,dsout,class,options = );

   %let clean = 1;
   %let iopt = 1;
   %do %while(%length(%scan(&options,&iopt)));
      %if (%upcase(%scan(&options,&iopt)) = NOCLEAN) %then
         %let clean = 0;
      %else
         %put Warning: Unrecognized option %scan(&options,&iopt).;
      %let iopt = %eval(&iopt + 1);
      %end;

   ods listing close;
   ods output Variables=_Var;
   proc contents data=&dsin;
   run;
   ods listing;

   %let numc =;
   %let nnumc = 0;
   data _null_; set _Var;
      _nc = 1; _cvar = trim(left(upcase(scan("&class",_nc))));
      do while (_cvar ^= ' ');
         if (  (trim(left(upcase(Variable)))=_cvar )
             & (trim(left(Type            ))='Num')) then do;
            call symput('numc' ,
                        trim(left(  symget('numc')||' '
                                  ||trim(left(Variable)))));
            call symput('nnumc',trim(left(1+symget('nnumc'))));
            end;
         _nc = _nc + 1; _cvar = trim(left(upcase(scan("&class",_nc))));
         end;
   run;

   data &dsout; set &dsin; run;
   %do inumc = 1 %to &nnumc;
      %let numcvar = %scan(&numc,&inumc);
      data &dsout; set &dsout;
         _tempc = trim(left(put(&numcvar,best16.)));
      data &dsout; set &dsout;
         drop &numcvar;
      data &dsout; set &dsout;
         rename _tempc=&numcvar;
      run;
   %end;

   %let allv =;
   %let nallv = 0;
   proc sort data=_Var out=_Var; by Num;
   data _null_; set _Var;
      call symput('allv' ,
                  trim(left(  symget('allv')||' '
                            ||trim(left(Variable)))));
      call symput('nallv',trim(left(1+symget('nallv'))));
   run;

   data _temp; set &dsout;
   data &dsout; if (0); run;
   %do ivar = 1 %to &nallv;
      %let var = %scan(&allv,&ivar);
      data &dsout; merge &dsout _temp(keep=&var);
      run;
   %end;

   %if (&clean) %then %do;
      proc datasets library=work nolist;
         delete _Var _temp;
      run;
      %end;

%mend;




 /*-------------------------------------------------------------------*/
 /*  Constrained MC with the best                                     */
 /*-------------------------------------------------------------------*/
%macro mcb(data            ,
           resp            ,
           mean            ,
           model   = &mean ,
           class   = &mean ,
           alpha   = 0.05  ,
           out     = mcbout,
           options =       );

 /*
 /  Retrieve options.
 /---------------------------------------------------------------------*/
   %let print = 1;
   %let clean = 1;
   %let iopt = 1;
   %do %while(%length(%scan(&options,&iopt)));
      %if       (%upcase(%scan(&options,&iopt)) = NOPRINT) %then
         %let print = 0;
      %else %if (%upcase(%scan(&options,&iopt)) = NOCLEAN) %then
         %let clean = 0;
      %else
         %put Warning: Unrecognized option %scan(&options,&iopt).;
      %let iopt = %eval(&iopt + 1);
      %end;

 /*
 /  Count number of variables in grouping effect.
 /---------------------------------------------------------------------*/
   %let ivar = 1;
   %do %while(%length(%scan(&mean,&ivar,*)));
      %let var&ivar = %upcase(%scan(&mean,&ivar,*));
      %let ivar = %eval(&ivar + 1);
      %end;
   %let nvar = %eval(&ivar - 1);

 /*
 /  Compute ANOVA and LSMEANS
 /---------------------------------------------------------------------*/
   ods listing close;
   proc mixed data=&data;
      class &class;
      model &resp = &model;
      lsmeans &mean;
      ods output LSMeans=&out;
   run;
   %n2cclass(&out,&out,&class);
   ods listing;
   data &out; set &out; orig_n = _n_;
   proc sort data=&out out=&out; by &mean;
   run;

 /*
 /  Retrieve the levels of the classification variable.
 /---------------------------------------------------------------------*/
   data &out; set &out;
      drop tvalue probt;
      length level $ 20;

      level = '';
      %do ivar = 1 %to &nvar;
         level = trim(left(level)) || ' ' || trim(left(&&var&ivar));
         %end;
      call symput('nlev',trim(left(_n_)));
      call symput('lev'||trim(left(_n_)),level);
      run;

 /*
 /  Now, perform Dunnett's comparison-with-control test with each
 /  level as the control.
 /---------------------------------------------------------------------*/
   ods listing close;
   proc mixed data=&data;
      class &class;
      model &resp = &model / dfm=sat;
      %do ilev = 1 %to &nlev;
         %let control =;
         %do ivar = 1 %to &nvar;
            %let control = &control "%scan(&&lev&ilev,&ivar)";
            %end;
         lsmeans &mean / diff=controlu(&control) cl alpha=&alpha
                               adjust=dunnett;
         %end;
      ods output Diffs=_mcb;
   run;
   %n2cclass(_mcb,_mcb,&class);
   ods listing;
   data _mcb; set _mcb;
      length level1 $ 20 level2 $ 20;

      level1 = '';
      level2 = '';
      %do ivar = 1 %to &nvar;
         %let v1 = &&var&ivar;
         %let v2 = _&&var&ivar;
         %if (%length(&v2) > 8) %then
            %let var2 = %substr(&v2,1,8);
         level1 = trim(left(level1)) || ' ' || trim(left(&v1));
         level2 = trim(left(level2)) || ' ' || trim(left(&v2));
         %end;
   run;

 /*
 /  Sort results by first and second level, respectively.
 /---------------------------------------------------------------------*/
   proc sort data=_mcb out=_tmcb1; by level1 level2;
   proc transpose data=_tmcb1 out=_tmcb1 prefix=lo;
      by level1; var AdjLower;
   data _tmcb1; set _tmcb1; ilev = _n_;
   proc sort data=_mcb out=_tmcb2; by level2 level1;
   proc transpose data=_tmcb2 out=_tmcb2 prefix=lo;
      by level2; var AdjLower;
   data _tmcb2; set _tmcb2; ilev = _n_;
   run;

 /*
 /  From Hsu (1996), p. 94:
 /     Di+ = +( min_{j!=i} m_i - m_j + d^i*s*sqrt(1/n_i + 1/n_j))^+
 /         = +(-max_{j!=i} m_j - m_i - d^i*s*sqrt(1/n_i + 1/n_j))^+
 /     G = {i : min_{j!=i} m_i - m_j + d^i*s*sqrt(1/n_i + 1/n_j) > 0}
 /     Di- = 0                                                if G = {i}
 /         = min_{j!=i} m_i - m_j + d^j*s*sqrt(1/n_i + 1/n_j) otherwise
 /---------------------------------------------------------------------*/
   data clhi; set _tmcb2; keep level2 clhi ilev;
      rename level2=level;
      clhi = -max(of lo1-lo%eval(&nlev-1));
      if (clhi < 0) then clhi = 0;
   data _g; set clhi; if (clhi > 0);
   run;

   %let ng = 0;
   %let g  = 0;
   data _null_; set _g;
      call symput('ng',_n_ );
      call symput('g' ,ilev);
   run;

   data cllo; set _tmcb1; keep level1 cllo ilev;
      rename level1=level;
      if ((&ng = 1) & (&g = ilev)) then cllo = 0;
      else                              cllo = min(of lo1-lo%eval(&nlev-1));
   run;

   data cl; merge cllo clhi;
      by level;
   data &out; merge &out cl;
      drop df ilev;
   run;

 /*
 /  Compute RVAL and SVAL.  RVAL is just the p-value for Dunnett's
 /  test for all means except the best, and SVAL is the maximum RVAL.
 /---------------------------------------------------------------------*/
   data _slev; set &out; _i_ = _n_;
   proc sort data=_slev out=_slev; by descending estimate;
   %let ibest = 0;
   data _null_; set _slev;
      if (_n_ = 1) then call symput('ibest',_i_);
   proc sort data=_mcb out=_pval; by level2 adjp;
   proc transpose data=_pval out=_pval prefix=p; by level2; var adjp;
   data _pval; set _pval; keep level2 rval;
      rename level2=level;
      if (_n_ = &ibest) then rval = .;
      else                   rval = p1;
   proc sort data=_pval out=_spval; by descending rval;
   data _null_; set _spval; if (_n_ = 1) then call symput('sval',rval);
   data _pval; set _pval;
      if (_n_ = &ibest) then sval = &sval;
   data &out; merge &out _pval; by level; drop level;
   proc sort data=&out out=&out; by orig_n;
   data &out; set &out; drop orig_n;
   run;

 /*
 /  Print and clean up.
 /---------------------------------------------------------------------*/
   %if (&print) %then %do;
      proc print uniform data=&out noobs;
      run;
      %end;

   %if (&clean) %then %do;
      proc datasets library=work nolist;
         delete cllo clhi cl _slev _spval _pval _mcb _tmcb1 _tmcb2 _g;
      run;
      %end;

%mend;








 /*-------------------------------------------------------------------*/
 /* Constrained MC with the worst                                     */
 /*-------------------------------------------------------------------*/
%macro mcw(data,
           resp ,
           mean,
           model   = &mean,
           class   = &mean,
           alpha   = 0.05 ,
           out     = mcbout ,
           options =      );

 /*
 /  Retrieve options.
 /---------------------------------------------------------------------*/
   %let print = 1;
   %let clean = 1;
   %let iopt = 1;
   %do %while(%length(%scan(&options,&iopt)));
      %if       (%upcase(%scan(&options,&iopt)) = NOPRINT) %then
         %let print = 0;
      %else %if (%upcase(%scan(&options,&iopt)) = NOCLEAN) %then
         %let clean = 0;
      %else
         %put Warning: Unrecognized option %scan(&options,&iopt).;
      %let iopt = %eval(&iopt + 1);
      %end;

 /*
 /  Copy the dataset but reverse the sign of the response, so that
 /  the best is the maximum response.
 /---------------------------------------------------------------------*/
   data _tmpds; set &data; &resp = -&resp; run;

   %mcb(_tmpds,
        &resp ,
        &mean ,
        model   = &model  ,
        class   = &class  ,
        alpha   = &alpha  ,
        out     = &out    ,
        options = &options);

 /*
 /  Reverse the sign of the results, so that the best is again the
 /  minimum response.
 /---------------------------------------------------------------------*/
   data &out; set &out;
      rename cllo=cllo;
      rename clhi=clhi;
      estimate = -estimate;
      tvalue = -tvalue;
      _temp = -cllo; cllo = -clhi; clhi = _temp; drop _temp;
   run;

 /*
 /  Print and clean up.
 /---------------------------------------------------------------------*/
   %if (&print) %then %do;
      proc print uniform data=&out noobs;
      run;
      %end;

   %if (&clean) %then %do;
      proc datasets library=work nolist;
         delete _tmpds;
      run;
      %end;

%mend;






 /*-------------------------------------------------------------------*/
 /*  Constrained MC with the best                                     */
 /*-------------------------------------------------------------------*/
%macro umcb(data,
           resp ,
           mean,
           model   = &mean,
           class   = &mean,
           alpha   = 0.05 ,
           out     = mcbout ,
           method  = EH   ,
           options =      );

 /*
 /  Retrieve options.
 /---------------------------------------------------------------------*/
   %let print = 1;
   %let clean = 1;
   %let iopt = 1;
   %do %while(%length(%scan(&options,&iopt)));
      %if       (%upcase(%scan(&options,&iopt)) = NOPRINT) %then
         %let print = 0;
      %else %if (%upcase(%scan(&options,&iopt)) = NOCLEAN) %then
         %let clean = 0;
      %else
         %put Warning: Unrecognized option %scan(&options,&iopt).;
      %let iopt = %eval(&iopt + 1);
      %end;

 /*
 /  Count number of variables in grouping effect.
 /---------------------------------------------------------------------*/
   %let ivar = 1;
   %do %while(%length(%scan(&mean,&ivar,*)));
      %let var&ivar = %upcase(%scan(&mean,&ivar,*));
      %let ivar = %eval(&ivar + 1);
      %end;
   %let nvar = %eval(&ivar - 1);

 /*
 /  Compute ANOVA and LSMEANS
 /---------------------------------------------------------------------*/
   ods listing close;
   proc mixed data=&data;
      class &class;
      model &resp = &model;
      lsmeans &mean;
      ods output LSMeans=&out;
   run;
   %n2cclass(&out,&out,&class);
   ods listing;
   data &out; set &out; orig_n = _n_;
   proc sort data=&out out=&out; by &mean;
   run;

 /*
 /  Retrieve the levels of the classification variable.
 /---------------------------------------------------------------------*/
   data &out; set &out;
      drop tvalue probt;
      length level $ 20;

      level = '';
      %do ivar = 1 %to &nvar;
         level = trim(left(level)) || ' ' || trim(left(&&var&ivar));
         %end;
      call symput('nlev',trim(left(_n_)));
      call symput('lev'||trim(left(_n_)),level);
      run;

   %if (%upcase(&method) = TK) %then %do;
      ods listing close;
      proc mixed data=&data;
         class &class;
         model &resp = &model;
         lsmeans &mean / diff=all cl alpha=&alpha adjust=tukey;
         ods output Diffs=_mcb;
      run;
      %n2cclass(_mcb,_mcb,&class);
      ods listing;
      proc sort data=_mcb out=_mcb;
         by &mean _&mean;
      run;

 /*
 /  Add reverse differences.
 /---------------------------------------------------------------------*/
      data _mcb; set _mcb; keep level1 level2 AdjLower AdjUpper adjp;
         length level1 $ 20 level2 $ 20;

         level1 = '';
         level2 = '';
         %do ivar = 1 %to &nvar;
            %let v1 = &&var&ivar;
            %let v2 = _&&var&ivar;
            %if (%length(&v2) > 8) %then
               %let var2 = %substr(&v2,1,8);
            level1 = trim(left(level1)) || ' ' || trim(left(&v1));
            level2 = trim(left(level2)) || ' ' || trim(left(&v2));
            %end;
         output;
         _tmplev = level1;    level1   = level2;    level2   = _tmplev;
         _tmpcl  = -AdjLower; AdjLower = -AdjUpper; AdjUpper = _tmpcl;
         output;
      run;

 /*
 /  Confidence limits are the minimum lower and upper CL's for each
 /  level.
 /---------------------------------------------------------------------*/
      proc sort data=_mcb out=_mcb; by level1 level2;
      proc transpose data=_mcb out=cllo prefix=lo;
         by level1; var AdjLower;
      proc transpose data=_mcb out=clhi prefix=hi;
         by level1; var AdjUpper;
      data cllo; set cllo;
         rename level1=level;
         cllo = min(of lo1-lo%eval(&nlev-1));
      data clhi; set clhi;
         rename level1=level;
         clhi = min(of hi1-hi%eval(&nlev-1));
      data cl; merge cllo(keep=level cllo) clhi(keep=level clhi);
      run;

      data &out; merge &out cl; drop level;
      run;

      %if (&clean) %then %do;
         proc datasets library=work nolist;
            delete _mcb cllo clhi cl;
            run;
         %end;
      %end;
   %else %do;

 /*
 /  Now, perform Dunnett's comparison-with-control test with each
 /  level as the control.
 /---------------------------------------------------------------------*/
      ods listing close;
      proc mixed data=&data;
         class &class;
         model &resp = &model / dfm=sat;
         %do ilev = 1 %to &nlev;
            %let control =;
            %do ivar = 1 %to &nvar;
               %let control = &control "%scan(&&lev&ilev,&ivar)";
               %end;
            lsmeans &mean / diff=control(&control) cl alpha=&alpha
                                  adjust=dunnett;
            %end;
         ods output Diffs=_mcb;
      run;
      %n2cclass(_mcb,_mcb,&class);
      ods listing;
      data _mcb; set _mcb;
         length level1 $ 20 level2 $ 20;

         level1 = '';
         level2 = '';
         %do ivar = 1 %to &nvar;
            %let v1 = &&var&ivar;
            %let v2 = _&&var&ivar;
            %if (%length(&v2) > 8) %then
               %let var2 = %substr(&v2,1,8);
            level1 = trim(left(level1)) || ' ' || trim(left(&v1));
            level2 = trim(left(level2)) || ' ' || trim(left(&v2));
            %end;
      proc sort data=_mcb out=_mcb; by level2 level1;
      data cl; keep cllo clhi;
         array m{&nlev,&nlev}; /* m[i1]-m[i2] - |d|^i2*s[i1,i2] */
         array p{&nlev,&nlev}; /* m[i1]-m[i2] + |d|^i2*s[i1,i2] */
         array s{&nlev};
         array l{&nlev};
         array u{&nlev};

         do i = 1 to &nlev; do j = 1 to &nlev;
            m[i,j] = .; p[i,j] = .;
            end; end;
         do obs = 1 to %eval(&nlev*(&nlev-1));
            set _mcb point=obs;

            j  = mod((obs-1),%eval(&nlev-1)) + 1;
            i2 = int((obs-1)/%eval(&nlev-1)) + 1;
            if (j < i2) then i1 = j;
            else             i1 = j + 1;

            m[i1,i2] = AdjLower;
            p[i1,i2] = AdjUpper;
            end;

 /*
 /  From Hsu (1996), p. 120:
 /     S = {i : min_{j!=i}   m_i - m_j + |d|^i*s[i,j] > 0}
 /       = {i : min_{j!=i} -(m_j - m_i - |d|^i*s[i,j]) > 0}
 /       = {i : min_{j!=i} -m[j,i] > 0}
 /---------------------------------------------------------------------*/
         ns = 0;
         do i = 1 to &nlev;
            minmmji = 1e12;
            do j = 1 to &nlev; if (j ^= i) then do;
               if (-m[j,i] < minmmji) then minmmji = -m[j,i];
               end; end;
            s[i] = (minmmji > 0);
            ns = ns + s[i];
            end;

 /*
 /  From Hsu (1996), p. 115:
 /     Lij = (i ^= j) * (m_i - m_j + |d|^j*s[i,j])
 /         = (i ^= j) * p[i,j]
 /     Li  = min_{j in S} Lij
 /
 /     Uij = (i ^= j) * -(m_i - m_j + |d|^j*s[i,j])^-
 /         = (i ^= j) * min(0,p[i,j])
 /     Ui  = max_{j in S} Uij
         put "Edwards-Hsu intervals";
         do i = 1 to &nlev;

            li = 1e12;
            do j = 1 to &nlev; if (s[j]) then do;
               if (i = j) then lij = 0;
               else            lij = m[i,j];
               if (lij < li) then li = lij;
               end; end;

            ui = -1e12;
            do j = 1 to &nlev; if (s[j]) then do;
               if (i = j) then uij = 0;
               else            uij = min(0,p[i,j]);
               if (uij > ui) then ui = uij;
               end; end;

            put li 7.3 " < mu" i 1. " - max_j muj < " ui 7.3;
            end;
 /---------------------------------------------------------------------*/

 /*
 /  From Hsu (1996), p. 120:
 /     If S = {i} then
 /        Li* = (min_{j!=i}   m_i - m_j - |d|^i*s[i,j] )^+
 /            = (min_{j!=i} -(m_j - m_i + |d|^i*s[i,j]))^+
 /            = (min_{j!=i} -p[j,i])^+
 /     Otherwise
 /        Li* = min_{j in S,j!=i} m_i - m_j - |d|^j*s[i,j]
 /            = min_{j in S,j!=i} m[i,j]
 /---------------------------------------------------------------------*/
         do i = 1 to &nlev;
            if ((ns = 1) & s[i]) then do;
               minmpji = 1e12;
               do j = 1 to &nlev; if (j ^= i) then do;
                  if (-p[j,i] < minmpji) then minmpji = -p[j,i];
                  end; end;
               l[i] = max(0,minmpji);
               end;
            else do;
               minpmij = 1e12;
               do j = 1 to &nlev; if (s[j] & (j ^= i)) then do;
                  if (m[i,j] < minpmij) then minpmij = m[i,j];
                  end; end;
               l[i] = minpmij;
               end;
            end;

 /*
 /  From Hsu (1996), p. 120:
 /     If i in S then
 /        Ui* = min_{j!=i}   m_i - m_j + |d|^i*s[i,j]
 /            = min_{j!=i} -(m_j - m_i - |d|^i*s[i,j])
 /            = min_{j!=i} -m[j,i]
 /     Otherwise
 /        Ui* = -(max_{j in S,} m_i - m_j + |d|^j*s[i,j])^-
 /            = -(max_{j in S,} p[i,j])^-
 /---------------------------------------------------------------------*/
         do i = 1 to &nlev;
            if (s[i]) then do;
               minmmji = 1e12;
               do j = 1 to &nlev; if (j ^= i) then do;
                  if (-m[j,i] < minmmji) then minmmji = -m[j,i];
                  end; end;
               u[i] = minmmji;
               end;
            else do;
               minppij = -1e12;
               do j = 1 to &nlev; if (s[j]) then do;
                  if (p[i,j] > minppij) then minppij = p[i,j];
                  end; end;
               u[i] = minppij;
               end;
            end;

         do i = 1 to &nlev;
            cllo = l{i}; clhi = u{i};
            output;
            end;

         stop;
      data &out; merge &out cl; drop level;
      run;

      %if (&clean) %then %do;
         proc datasets library=work nolist;
            delete _mcb cl;
            run;
         %end;

      %end;

   proc sort data=&out out=&out; by orig_n;
   data &out; set &out; drop orig_n;
   run;

 /*
 /  Print and clean up.
 /---------------------------------------------------------------------*/
   %if (&print) %then %do;
      proc print uniform data=&out noobs;
      run;
      %end;

%mend;









 /*-------------------------------------------------------------------*/
 /* Unconstrained MC with the worst                                   */
 /*-------------------------------------------------------------------*/
%macro umcw(data,
            resp ,
            mean,
            model   = &mean ,
            class   = &mean ,
            alpha   = 0.05  ,
            out     = mcbout,
            method  = EH    ,
            options =       );

 /*
 /  Retrieve options.
 /---------------------------------------------------------------------*/
   %let print = 1;
   %let clean = 1;
   %let iopt = 1;
   %do %while(%length(%scan(&options,&iopt)));
      %if       (%upcase(%scan(&options,&iopt)) = NOPRINT) %then
         %let print = 0;
      %else %if (%upcase(%scan(&options,&iopt)) = NOCLEAN) %then
         %let clean = 0;
      %else
         %put Warning: Unrecognized option %scan(&options,&iopt).;
      %let iopt = %eval(&iopt + 1);
      %end;

 /*
 /  Copy the dataset but reverse the sign of the response, so that
 /  the best is the maximum response.
 /---------------------------------------------------------------------*/
   data _tmpds; set &data; &resp = -&resp; run;

   %umcb(_tmpds,
         &resp ,
         &mean ,
         model   = &model  ,
         class   = &class  ,
         alpha   = &alpha  ,
         out     = &out    ,
         method  = &method ,
         options = &options);

 /*
 /  Reverse the sign of the results, so that the best is again the
 /  minimum response.
 /---------------------------------------------------------------------*/
   data &out; set &out;
      rename cllo=cllo;
      rename clhi=clhi;
      estimate = -estimate;
      tvalue = -tvalue;
      _temp = -cllo; cllo = -clhi; clhi = _temp; drop _temp;
   run;

 /*
 /  Print and clean up.
 /---------------------------------------------------------------------*/
   %if (&print) %then %do;
      proc print uniform data=&out noobs;
      run;
      %end;

   %if (&clean) %then %do;
      proc datasets library=work nolist;
         delete _tmpds;
      run;
      %end;

%mend;
