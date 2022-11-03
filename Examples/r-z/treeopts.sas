 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: TREEOPTS                                            */
 /*   TITLE: Examples of Various Options for PROC TREE           */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: CLUSTER                                             */
 /*   PROCS: CLUSTER, PRINT, TREE                                */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /****************************************************************/

 /****************************************************************/
 /*   The following SAS steps demonstrate various features of    */
 /* PROC TREE.  PROC CLUSTER is used to hierarchically cluster   */
 /* data from the table of mileages between U.S. cities; then    */
 /* PROC TREE is used to generate several tree diagrams.         */
 /****************************************************************/

options ls=78 ps=60 nodate;

data mileages (type=distance);
   input (atlanta chicago denver houston losangel miami
          newyork sanfran seattle washdc) (5.) @56 city $ 15.;
   list;
   cards;
   0                                                    Atlanta
 587    0                                               Chicago
1212  920    0                                          Denver
 701  940  879    0                                     Houston
1936 1745  831 1374    0                                Los Angeles
 604 1188 1726  968 2339    0                           Miami
 748  713 1631 1420 2451 1092    0                      New York
2139 1858  949 1645  347 2594 2571    0                 San Francisco
2182 1737 1021 1891  959 2734 2408  678    0            Seattle
 543  597 1494 1220 2300  923  205 2442 2329    0       Washington DC
;
   run;

title1 'proc cluster data=mileages method=average;';
title2 '(hierarchical clustering of distance data)';
title4 'Distances between U.S. Cities';
proc cluster data=mileages method=average;
   id city;
   run;

title1 'output data set from proc cluster';
title2 '(used as input to proc tree)';
title4 'Distances between U.S. Cities';
proc print;
   run;

title1 'proc tree list;';
title2 '(listing the nodes)';
title4 'Distances between U.S. Cities';
proc tree list lp;
   run;

title1 'proc tree root=''CL3'';';
title2 '(subtree with root ''CL3'')';
title4 'Distances between U.S. Cities';
proc tree root='CL3' lp;
   run;

title1 'proc tree sort;';
title2 '(children sorted by height)';
title4 'Distances between U.S. Cities';
proc tree sort lp;
   run;

title1 'proc tree leafchar=''o'' treechar=''O'' joinchar=''='';';
title2 '(resetting the print characters)';
title4 'Distances between U.S. Cities';
proc tree leafchar='o' treechar='O' joinchar='=' lp;
   run;

title1 'proc tree horizontal;';
title2 '(horizontal output)';
title4 'Distances between U.S. Cities';
proc tree horizontal lp;
   run;
