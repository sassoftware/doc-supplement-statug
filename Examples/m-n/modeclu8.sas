 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MODECLU8                                            */
 /*   TITLE: Uniform Kernel Nonparametric Density Estimation     */
 /* PRODUCT: SAS                                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: nonparametric methods, graphics                     */
 /*   PROCS: MODECLUS SGPLOT SGRENDER TEMPLATE                   */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Uniform Kernel Nonparametric Density Estimation';

title2 'Bivariate Normal Distribution';

ods graphics on / antialiasmax=1000;

data normal(drop=n);
   f=0;                      /* grid of points */
   do x=0 to 2 by .05;
      do y=0 to 1 by .05;
         output;
      end;
   end;

   f=1;                      /* data points    */
   do n=1 to 100;
      x=normal(104)/4+1;
      y=normal(104)/8+.5;
      output;
   end;
run;

proc sgplot data=normal(where=(f));
   scatter y=y x=x;
run;

proc modeclus data=normal r=.05 .1 .2 .4 out=out;
   var x y;
   freq f;
run;

%let t = axisopts=(offsetmin=0 offsetmax=0);
proc template;
   define statgraph Contour;
      begingraph / designheight=360;
         entrytitle 'Uniform Kernel Nonparametric Density Estimation';
         entrytitle 'Bivariate Normal Distribution';
         layout lattice / rows=1 columns=2;
            layout overlay / x&t y&t;
               contourplotparm y=y x=x z=density / gridded=true;
               endlayout;
            surfaceplotparm y=y x=x z=density;
         endlayout;
      endgraph;
   end;
run;

proc sgrender template=Contour data=out(where=(f=0));
   label density = '00'x;
   by _r_;
run;

title2 'Mixture of Two Normal Distributions';

data normix(drop=n);
   f=0;                      /* grid of points */
   do x=0 to 2 by .05;
      do y=0 to 1 by .05;
         output;
      end;
   end;

   f=1;                      /* data points    */
   do n=1 to 100;
      x=normal(104)/8+.7+.6*mod(n,2);
      y=normal(104)/8+.5;
      output;
   end;
run;

proc sgplot data=normix(where=(f));
   scatter y=y x=x;
run;

proc modeclus data=normix r=.05 .1 .2 .4 out=out;
   var x y;
   freq f;
run;

proc sgrender template=Contour data=out(where=(f=0));
   label density = '00'x;
   by _r_;
run;

title2 'Uniform Distribution';

data uniform(drop=n);
   f=0;                      /* grid of points */
   do x=0 to 2 by .05;
      do y=0 to 1 by .05;
         output;
      end;
   end;

   f=1;                      /* data points    */
   do n=1 to 100;
      x=ranuni(104)*2;
      y=ranuni(104);
      output;
   end;
run;

proc sgplot data=uniform(where=(f));
   scatter y=y x=x;
run;

proc modeclus data=uniform r=.05 .1 .2 .4 out=out;
   var x y;
   freq f;
run;

proc sgrender template=Contour data=out(where=(f=0));
   label density = '00'x;
   by _r_;
run;
