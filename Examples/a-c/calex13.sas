/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX13                                             */
/*   TITLE: Documentation Example 22 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: equality of covariance and mean matrices            */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 22                              */
/*    MISC:                                                     */
/****************************************************************/

data g1(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .721    1.      .      .      .      .      .      .       .
corr    x3 .676   .379     1.     .      .      .      .      .       .
corr    x4 .149   .403    .450    1.     .      .      .      .       .
corr    x5 .422   .384    .445   .411    1.     .      .      .       .
corr    x6 .343   .456    .243   .308   .531    1.     .      .       .
corr    x7 .115   .225    .201   .481   .373   .198   1.      .       .
corr    x8 .213   .237    .434   .503   .267   .333   .355   1.       .
corr    x9 .236   .257    .159   .246   .126   .235   .601   .512    1.
mean     . 21.3   22.3    17.2   23.4   22.1   15.6   18.7   20.1  19.7
std      .  1.2    1.4    .87    1.33    2.2    1.4    2.3    2.1   1.8
n        .   21     21      21     21     21     21     21     21    21
;

data g2(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .733    1.      .      .      .      .      .      .       .
corr    x3 .576   .388     1.     .      .      .      .      .       .
corr    x4 .209   .414    .425    1.     .      .      .      .       .
corr    x5 .412   .286    .461   .398    1.     .      .      .       .
corr    x6 .323   .399    .212   .302   .522    1.     .      .       .
corr    x7 .215   .295    .188   .467   .334   .232   1.      .       .
corr    x8 .204   .257    .462   .522   .298   .355  .372    1.       .
corr    x9 .245   .272    .177   .301   .156   .246  .578   .422     1.
mean     . 22.1   19.8    16.9   23.3   21.9   17.3   17.9   19.1  19.8
std      .  1.3    1.3    .99    1.25    2.1    1.3    2.2    2.0   1.5
n        .   22     22      22     22     22     22     22     22    22
;

data g3(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .699    1.      .      .      .      .      .      .       .
corr    x3 .488   .328     1.     .      .      .      .      .       .
corr    x4 .235   .398    .413    1.     .      .      .      .       .
corr    x5 .377   .265    .471   .376    1.     .      .      .       .
corr    x6 .335   .412    .265   .314   .503    1.     .      .       .
corr    x7 .243   .216    .192   .423   .369   .212   1.      .       .
corr    x8 .217   .292    .423   .525   .219   .317  .376    1.       .
corr    x9 .211   .283    .152   .285   .147   .135  .633   .579     1.
mean     . 22.2   20.9    15.4   25.1   22.6   16.3   19.3   20.2  19.5
std      .  1.5    1.0    1.04    1.5    1.9    1.6    2.4    2.2   1.6
n        .   20     20      20     20     20     20     20     20    20
;

proc calis covpattern=eqcovmat meanpattern=eqmeanvec modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis covpattern=eqcovmat meanpattern=saturated;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc template;
   define table LagrangeEquality;
      notes "Lagrange Tests for Releasing Equality Constraints For CALIS DOC";
      col_space_min=1 contents_label="Equality Constraints";
      header h1 h2 h3;

      define header h1;
         text "Lagrange Multiplier Statistics "
              "for Releasing Equality Constraints";
         space=1 spill_margin;
         end;

      column Parameter ModelNum RelParmType Var1 Var2 LMStat PVal
             ParmChange RelParmChange;

      define Parameter;
         header="Parm" id width=9 style=RowHeader blank_dups=on;
         translate _val_ = ._ into '.';
         end;

      define ModelNum;
         header=";;Model" id format=best5. style=RowHeader;
         translate _val_ = ._ into '';
         end;

      define RelParmType;
         header="Type" id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define Var1;
         id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define Var2;
         id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define header h2;
         text "Released Parameter";
         start=ModelNum end=Var2 expand='-';
         end;

      define LMStat;
         parent=Stat.Calis.ChiSq;
         header="LM Stat";
         translate _val_ = ._ into '';
         end;

      define PVal;
         parent=Stat.Calis.ProbChiSq;
         translate _val_ = ._ into '';
         end;

      define ParmChange;
         header=";Original;Parm" format=D8.;
         translate _val_ = ._ into '';
         end;

      define RelParmChange;
         header=";Released;Parm" format=D8.;
         translate _val_ = ._ into '';
         end;

      define header h3;
         text "Changes";
         start=ParmChange end=RelParmChange expand='-';
         end;
      end;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new;    /* constraint a */
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,    /* constraint a */
                 mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean4=mean4_new,     /* constraint b */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean3=mean3_mdl3,
                 mean4=mean4_new;     /* constraint b */
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean1=mean1_new,     /* constraint c */
                 mean2=mean2_new,     /* constraint a */
                 mean4=mean4_new,     /* constraint b */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean1=mean1_new,    /* constraint c */
                 mean2=mean2_new,    /* constraint a */
                 mean3=mean3_mdl3,
                 mean4=mean4_new;    /* constraint b */
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;
