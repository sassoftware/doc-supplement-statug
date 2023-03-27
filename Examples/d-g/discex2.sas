/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: DISCEX2                                             */
/*   TITLE: Documentation Example 2 for PROC DISCRIM            */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis                               */
/*   PROCS: DISCRIM                                             */
/*    DATA: FISHER (1936) IRIS DATA - SASHELP.IRIS              */
/*                                                              */
/*     REF: PROC DISCRIM, EXAMPLE 2                             */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Discriminant Analysis of Fisher (1936) Iris Data';
proc template;
   define statgraph scatter;
      begingraph;
         entrytitle 'Fisher (1936) Iris Data';
         layout overlayequated / equatetype=fit;
            scatterplot x=petallength y=petalwidth /
                        group=species name='iris';
            layout gridded / autoalign=(topleft);
               discretelegend 'iris' / border=false opaque=false;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=sashelp.iris template=scatter;
run;

data plotdata;
   do PetalLength = -2 to 72 by 0.5;
      do PetalWidth= - 5 to 32 by 0.5;
         output;
      end;
   end;
run;

%let close = thresholdmin=0 thresholdmax=0 offsetmin=0 offsetmax=0;
%let close = xaxisopts=(&close) yaxisopts=(&close);

proc template;
   define statgraph contour;
      begingraph;
         layout overlayequated / equatetype=equate &close;
            contourplotparm x=petallength y=petalwidth z=z /
                            contourtype=fill nhint=30;
            scatterplot x=pl y=pw / group=species name='iris'
                        includemissinggroup=false primary=true;
            layout gridded / autoalign=(topleft);
               discretelegend 'iris' / border=false opaque=false;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

%macro contden;
   data contour(keep=PetalWidth PetalLength species z pl pw);
      merge plotd(in=d) sashelp.iris(keep=PetalWidth PetalLength species
                                     rename=(PetalWidth=pw PetalLength=pl));
      if d then z = max(setosa,versicolor,virginica);
   run;

   title3 'Plot of Estimated Densities';

   proc sgrender data=contour template=contour;
   run;
%mend;

%macro contprob;
   data posterior(keep=PetalWidth PetalLength species z pl pw into);
      merge plotp(in=d) sashelp.iris(keep=PetalWidth PetalLength species
                                     rename=(PetalWidth=pw PetalLength=pl));
      if d then z = max(setosa,versicolor,virginica);
      into = 1 * (_into_ =: 'Set') + 2 * (_into_ =: 'Ver') +
             3 * (_into_ =: 'Vir');
   run;

   title3 'Plot of Posterior Probabilities ';

   proc sgrender data=posterior template=contour;
   run;
%mend;

%macro contclass;
   title3 'Plot of Classification Results';

   proc sgrender data=posterior(drop=z rename=(into=z)) template=contour;
   run;
%mend;

title2 'Using Normal Density Estimates with Equal Variance';

proc discrim data=sashelp.iris method=normal pool=yes
   testdata=plotdata testout=plotp testoutd=plotd
   short noclassify crosslisterr;
   class Species;
   var Petal:;
run;

%contden
%contprob
%contclass

title2 'Using Normal Density Estimates with Unequal Variance';

proc discrim data=sashelp.iris method=normal pool=no
   testdata=plotdata testout=plotp testoutd=plotd
   short noclassify crosslisterr;
   class Species;
   var Petal:;
run;

%contden
%contprob
%contclass

title2 'Using Kernel Density Estimates with Equal Bandwidth';

proc discrim data=sashelp.iris method=npar kernel=normal
   r=.5 pool=yes testoutd=plotd testdata=plotdata testout=plotp
   short noclassify crosslisterr;
   class Species;
   var Petal:;
run;

%contden
%contprob
%contclass

title2 'Using Kernel Density Estimates with Unequal Bandwidth';

proc discrim data=sashelp.iris method=npar kernel=normal
   r=.5 pool=no testoutd=plotd testdata=plotdata testout=plotp
   short noclassify crosslisterr;
   class Species;
   var Petal:;
run;

%contden
%contprob
%contclass

