 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: CLUSDIST                                            */
 /*   TITLE: Computing a Distance Matrix                         */
 /* PRODUCT: SAS                                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: CLUSTER DISTANCE                                    */
 /*   PROCS: CLUSTER TREE PRINT SORT                             */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

Title 'Computing a Distance Matrix';

 /***

NOTE: Most commonly-used distance measures can be computed by
PROC DISTANCE. But if you need to use a distance measure that
is not in PROC DISTANCE, you can compute it using a DATA step.
This example shows how to loop over the rows and columns of a
coordinate data set to compute a distance matrix. You can adapt
this DATA step code to compute many other types matrices.

  ***

A wide variety of distance and similarity measures are used in
cluster analysis (Anderberg 1973, Sneath and Sokal 1973).
If your data are in coordinate form and you want to use a non-Euclidean
distance for clustering, you can compute a distance matrix using a
DATA step or the IML procedure.

Similarity measures must be converted to dissimilarities before
being used in CLUSTER. Such conversion can be done in a variety
of ways, such as taking reciprocals or subtracting from a large
value. The choice of conversion method depends on the application
and the similarity measure.

In the following example, the observations are states. Binary-valued
variables correspond to various grounds for divorce and indicate
whether the grounds for divorce apply in each of the states.
A DATA step is used to compute the Jaccard coefficient (Anderberg
1973, 89, 115, and 117) between each pair of states. The Jaccard
coefficient is defined as the number of variables that are coded
as 1 for both states divided by the number of variables that are
coded as 1 for either or both states. The Jaccard coefficient is
converted to a distance measure by subtracting it from 1.

 ***/

options ls=120 ps=60;
data divorce;
   title2 'Grounds for Divorce';
   input State $15.
         (Incompatibility Cruelty Desertion Non_Support Alcohol
          Felony Impotence Insanity Separation) (1.) @@;
   if mod(_n_,2) then input +4 @@; else input;
   datalines;
Alabama        111111111    Alaska         111011110
Arizona        100000000    Arkansas       011111111
California     100000010    Colorado       100000000
Connecticut    111111011    Delaware       100000001
Florida        100000010    Georgia        111011110
Hawaii         100000001    Idaho          111111011
Illinois       011011100    Indiana        100001110
Iowa           100000000    Kansas         111011110
Kentucky       100000000    Louisiana      000001001
Maine          111110110    Maryland       011001111
Massachusetts  111111101    Michigan       100000000
Minnesota      100000000    Mississippi    111011110
Missouri       100000000    Montana        100000000
Nebraska       100000000    Nevada         100000011
New Hampshire  111111100    New Jersey     011011011
New Mexico     111000000    New York       011001001
North Carolina 000000111    North Dakota   111111110
Ohio           111011101    Oklahoma       111111110
Oregon         100000000    Pennsylvania   011001110
Rhode Island   111111101    South Carolina 011010001
South Dakota   011111000    Tennessee      111111100
Texas          111001011    Utah           011111110
Vermont        011101011    Virginia       010001001
Washington     100000001    West Virginia  111011011
Wisconsin      100000001    Wyoming        100000011
;

   /* compute distance matrix containing (1.0 - Jaccard coefficient) */
data distjacc(type=distance);
   array dj(*) dj1-dj50;          /* variables to contain 1-Jaccard  */
   retain dj1-dj50 .;               /* initialize to missing values  */

   do row=1 to 50;             /* loop over rows of distance matrix  */
      set divorce point=row;                      /* read row state  */
      array grounds(*) incompatibility--separation; /* declare arrays*/
      array save(*) save1-save9;        /* after the SET statement   */

      do g=1 to 9;                       /* save data for row state  */
         save(g)=grounds(g);
      end;

      do col=1 to row;      /* loop over columns of distance matrix  */
         set divorce(drop=state) point=col;    /* read column state  */
         num=0;      /* number of grounds that apply to both states  */
         den=0;     /* number of grounds that apply to either state  */
         do g=1 to 9;              /* loop over grounds for divorce  */
            num=num+(grounds(g) & save(g));
            den=den+(grounds(g) | save(g));
         end;
         if den then dj(col)=1-num/den;      /* convert to distance  */
                else dj(col)=1;
      end;

      output;                /* output a row of the distance matrix  */
   end;
   stop;          /* stop statement is needed because SET statement
                                                  uses POINT= option */
   keep state dj1-dj50;  /* keep only the state and distance matrix  */
run;

proc print data=distjacc(obs=10);
   title2 'First 10 States';
   id state;
   var dj1-dj10;
run;
title2;

proc cluster data=distjacc method=centroid pseudo outtree=tree;
   id state;
   var dj1-dj50;
run;

proc tree data=tree noprint n=9 out=out;
   id state;
run;

proc sort;
   by state;
run;

data clus;
   merge divorce out;
   by state;
run;

proc sort;
   by cluster;
run;

proc print;
   id state;
   var incompatibility--separation;
   by cluster;
run;
