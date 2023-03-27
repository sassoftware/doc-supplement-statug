/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: DISCEX1                                             */
/*   TITLE: Documentation Example 1 for PROC DISCRIM            */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis                               */
/*   PROCS: DISCRIM                                             */
/*    DATA: FISHER (1936) IRIS DATA - SASHELP.IRIS              */
/*                                                              */
/*     REF: PROC DISCRIM, EXAMPLE 1                             */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Discriminant Analysis of Fisher (1936) Iris Data';

proc freq data=sashelp.iris noprint;
   tables petalwidth * species / out=freqout;
run;

proc sgplot data=freqout;
   vbar petalwidth / response=count group=species;
   keylegend / location=inside position=ne noborder across=1;
run;

data plotdata;
   do PetalWidth=-5 to 30 by 0.5;
      output;
   end;
run;

%macro plotden;
   title3 'Plot of Estimated Densities';

   data plotd2;
      set plotd;
      if setosa     < .002 then setosa     = .;
      if versicolor < .002 then versicolor = .;
      if virginica  < .002 then virginica  = .;
      g = 'Setosa    '; Density = setosa;     output;
      g = 'Versicolor'; Density = versicolor; output;
      g = 'Virginica '; Density = virginica;  output;
      label PetalWidth='Petal Width in mm.';
   run;

   proc sgplot data=plotd2;
      series y=Density x=PetalWidth / group=g;
      discretelegend;
   run;
%mend;

%macro plotprob;
   title3 'Plot of Posterior Probabilities';

   data plotp2;
      set plotp;
      if setosa     < .01 then setosa     = .;
      if versicolor < .01 then versicolor = .;
      if virginica  < .01 then virginica  = .;
      g = 'Setosa    '; Probability = setosa;     output;
      g = 'Versicolor'; Probability = versicolor; output;
      g = 'Virginica '; Probability = virginica;  output;
      label PetalWidth='Petal Width in mm.';
   run;

   proc sgplot data=plotp2;
      series y=Probability x=PetalWidth / group=g;
      discretelegend;
   run;
%mend;

title2 'Using Normal Density Estimates with Equal Variance';

proc discrim data=sashelp.iris method=normal pool=yes
   testdata=plotdata testout=plotp testoutd=plotd
   short noclassify crosslisterr;
   class Species;
   var PetalWidth;
run;

%plotden;
%plotprob;

title2 'Using Normal Density Estimates with Unequal Variance';

proc discrim data=sashelp.iris method=normal pool=no
   testdata=plotdata testout=plotp testoutd=plotd
   short noclassify crosslisterr;
   class Species;
   var PetalWidth;
run;

%plotden;
%plotprob;

title2 'Using Kernel Density Estimates with Equal Bandwidth';

proc discrim data=sashelp.iris method=npar kernel=normal
   r=.4 pool=yes testdata=plotdata testout=plotp
   testoutd=plotd short noclassify crosslisterr;
   class Species;
   var PetalWidth;
run;

%plotden;
%plotprob;

title2 'Using Kernel Density Estimates with Unequal Bandwidth';

proc discrim data=sashelp.iris method=npar kernel=normal
   r=.4 pool=no testdata=plotdata testout=plotp
   testoutd=plotd short noclassify crosslisterr;
   class Species;
   var PetalWidth;
run;

%plotden;
%plotprob;

