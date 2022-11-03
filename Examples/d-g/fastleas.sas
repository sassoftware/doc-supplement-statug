 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: FASTLEAS                                            */
 /*   TITLE: Using the LEAST= Option with PROC FASTCLUS          */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: CLUSTER                                             */
 /*   PROCS: FASTCLUS SGPLOT SORT                                */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/


title 'Cluster Analysis of Artificial Five-Group Data With Outliers';

data clusdata(drop=n);
   do g=1 to 5;
      if      g=1 then do; xm=3;  ym=6;  end;
      else if g=2 then do; xm=3;  ym=3;  end;
      else if g=3 then do; xm=8;  ym=3;  end;
      else if g=4 then do; xm=12; ym=6;  end;
      else             do; xm=5;  ym=13; end;
      do n=1 to 30-g*3;
         x=xm+rannor(8237657);
         y=ym+rannor(8237657);
         random=ranuni(8237657);
         output;
      end;
   end;
   xm=5;
   ym=5;
   do n=1 to 20;
      x=xm+ranexp(8237657)*10;
      y=ym+ranexp(8237657)*10;
      random=ranuni(8237657);
      output;
   end;
run;

proc sort;
   by random;
run;

proc sgplot noautolegend;
   scatter y=y x=x / markerchar=g group=g;
run;

* Preliminary clusters for initial seeds;

title2 "Preliminary Clusters";
proc fastclus maxc=25 maxiter=0 data=clusdata out=out outseed=init;
   var x y;
run;

data init;
   set init;
   if _freq_ > 3;
run;

* Set ups macro for repeated runs of FASTCLUS followed by PROC SGPLOT;

%macro runfast(clus,least);
   title2 "Fitting &clus Clusters with LEAST=&least";

   proc fastclus least=&least maxc=&clus maxiter=99
        data=clusdata seed=init out=out;
      var x y;
   run;

   proc sgplot noautolegend;
      scatter y=y x=x / markerchar=cluster group=cluster;
   run;
%mend;

%macro driver(start,end);
   %do clus=&start %to &end;
      %runfast(&clus,1);
      %runfast(&clus,1.5);
      %runfast(&clus,2);
      %runfast(&clus,5);
      %runfast(&clus,max);
   %end;
%mend;

* The analysis is run for 2 to 6 clusters;

%driver(start=2,end=6);
