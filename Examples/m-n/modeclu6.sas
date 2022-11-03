 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MODECLU6                                            */
 /*   TITLE: MODECLUS Analysis of Artificial Data Sets           */
 /* PRODUCT: SAS                                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: CLUSTER                                             */
 /*   PROCS: MODECLUS SGPLOT                                     */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Modeclus Analysis';

data compact;
   keep x y;
   n=50; scale=1;
   mx=0; my=0; link generate;
   mx=8; my=0; link generate;
   mx=4; my=8; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(1)*scale+mx;
      y=rannor(1)*scale+my;
      output;
   end;
   return;
run;

proc modeclus data=compact m=6 k=10 to 50 by 5 short;
   title2 'of Data Containing Well-Separated, Compact Clusters';
run;

proc modeclus data=compact m=6 k=20 out=out;
run;

proc sgplot;
   scatter y=y x=x / markerchar=cluster;
run;

*---------------------------------------------------------------------;

data closer;
   keep x y;
   n=50; scale=1;
   mx=0; my=0; link generate;
   mx=3; my=0; link generate;
   mx=1; my=2; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(9)*scale+mx;
      y=rannor(9)*scale+my;
      output;
   end;
   return;
run;

proc modeclus data=closer m=6 k=10 to 50 by 5 short;
   title2 'of Data Containing Poorly-Separated, Compact Clusters';
run;

proc modeclus data=closer m=6 k=20 out=out;
run;

proc sgplot;
   scatter y=y x=x / markerchar=cluster;
run;

*---------------------------------------------------------------------;

data unequal;
   keep x y;
   mx=1; my=0; n=20; scale=.5; link generate;
   mx=6; my=0; n=80; scale=2.; link generate;
   mx=3; my=4; n=40; scale=1.; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(1)*scale+mx;
      y=rannor(1)*scale+my;
      output;
   end;
   return;
run;

proc modeclus data=unequal m=6 k=10 to 50 by 5 short;
   title2 'of Data Containing Compact Clusters of Unequal Size';
run;

proc modeclus data=unequal m=6 k=20 out=out;
run;

proc sgplot;
   scatter y=y x=x / markerchar=cluster;
run;

*---------------------------------------------------------------------;

data elongate;
   keep x y;
   ma=8; mb=0; link generate;
   ma=6; mb=8; link generate;
   stop;
generate:
   do i=1 to 50;
      a=rannor(7)*6+ma;
      b=rannor(7)+mb;
      x=a-b;
      y=a+b;
      output;
   end;
   return;
run;

proc modeclus data=elongate m=6 k=10 to 50 by 5 short;
   title2 'of Data Containing Parallel Elongated Clusters';
run;

proc modeclus data=elongate m=6 k=20 out=out;
run;

proc sgplot;
   scatter y=y x=x / markerchar=cluster;
run;

*---------------------------------------------------------------------;

data irreg;
   keep x y;
   do i=1 to 100;
      a=i*.0628319;
      x=cos(a)+(i>50)+rannor(7)*.1;
      y=sin(a)+(i>50)*.3+rannor(7)*.1;
      output;
   end;
run;

proc modeclus data=irreg m=6 k=10 to 50 by 5 cascade=1 short;
   title2 'of Data Containing Irregular Clusters';
run;

proc modeclus data=irreg m=6 k=20 cascade=1 out=out;
run;

proc sgplot;
   scatter y=y x=x / markerchar=cluster;
run;
