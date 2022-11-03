 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: FASTCLUS                                            */
 /*   TITLE: Analysis of Artificial Five-Group Data              */
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

title 'Cluster Analysis Of Artificial Five-Group Data';

data clusdata(drop=n);
   do g=1 to 5;
      if      g=1 then do; xm=1;  ym=4;  end;
      else if g=2 then do; xm=1;  ym=1;  end;
      else if g=3 then do; xm=6;  ym=1;  end;
      else if g=4 then do; xm=15; ym=5;  end;
      else             do; xm=3;  ym=20; end;
      do n=1 to 20;
         x=xm+rannor(12345);
         y=ym+rannor(12345);
         random=ranuni(12345);
         output;
      end;
   end;
run;

proc sort;
   by random;
run;

proc sgplot;
   scatter y=y x=x / markerchar=g group=g;
run;

* Set up macro for repeated runs of FASTCLUS followed by PROC SGPLOT;

%macro onemore(start=2,end=6);
   %do clus=&start %to &end;
      title2 "Fitting &clus Clusters";

      proc fastclus maxc=&clus data=clusdata out=clusters;
         var x y;
      run;

      proc sgplot noautolegend;
         scatter y=y x=x / markerchar=cluster group=cluster;
      run;
   %end;
%mend;

* The analysis is run for 2 to 6 clusters;

%onemore;
