 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: CANDPOLY                                            */
 /*   TITLE: Polynomial Canonical Discriminant Analysis          */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: MULTIV DISCRIM                                      */
 /*   PROCS: CANDISC CHART STANDARD                              */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Polynomial Canonical Discriminant Analysis';

 /* -------------------------------------------------------------
   Discriminant methods based on normal distributions yield linear
   or quadratic discrimination boundaries. However, by generating
   polynomial terms in a DATA step, you can have CANDISC perform
   a higher-order polynomial transformation that makes it possible
   to classify some kinds of non-normal populations effectively
   with linear discrimination boundaries. In the examples below,
   the first polynomial canonical discrimimant variable provides
   perfect or nearly perfect discrimination between classes that
   cannot be separated by ordinary linear discriminant analysis.
 --------------------------------------------------------------- */

title2 'Circles';
data circle; keep x y c;
   c=1;
   do n=1 to 20;
      x=rannor(12345);
      y=rannor(12345);
      output;
   end;
   c=2;
   do n=1 to 30;
      x=rannor(12345);
      y=rannor(12345);
      l=sqrt(x**2+y**2);
      m=1+3/l;
      x=x*m;
      y=y*m;
      output;
   end;
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=c markerchar=c;
run;

data poly;
   set circle;
   x2=x**2; y2=y**2; xy=x*y;
run;

proc candisc out=out;
   class c;
run;

ods graphics on;

proc univariate noprint;
   class c;
   histogram can1;
run;

title2 'arcs';
data arcs(keep=x y c);
   pi = constant('pi');
   a=20;
   c=1;
   m1=0; m2=0; thetam=pi;
   do n=1 to 75;
      theta=rannor(12345)*pi/4+thetam;
      x=a*cos(theta)+m1+rannor(12345);
      y=a*sin(theta)+m2+rannor(12345);
      output;
   end;
   c=2;
   m1=-5; m2=-20; thetam=0;
   do n=1 to 75;
      theta=rannor(12345)*pi/4+thetam;
      x=a*cos(theta)+m1+rannor(12345);
      y=a*sin(theta)+m2+rannor(12345);
      output;
   end;
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=c markerchar=c;
run;

proc standard m=0 s=1 out=std;
   var x y;
run;

data poly;
   set std;
   x2=x**2; xy=x*y; y2=y**2;
   x3=x**3; x2y=x**2*y; xy2=x*y**2; y3=y**3;
run;

proc candisc data=poly out=out;
   class c;
   var x y x2 y2 xy;
run;

proc univariate noprint;
   class c;
   histogram can1;
run;

proc candisc data=poly out=out;
   class c;
run;

proc univariate noprint;
   class c;
   histogram can1;
run;

ods graphics off;
