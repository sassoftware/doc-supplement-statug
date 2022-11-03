/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX6                                             */
/*   TITLE: Size, Shape, and Correlation of Grocery Boxes       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER ANALYSIS SIZE SHAPE CORRELATION             */
/*   PROCS: CLUSTER, STANDARD, TREE, SORT, PRINT, FREQ          */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CLUSTER                                        */
/*    MISC:                                                     */
/****************************************************************/

title 'Cluster Analysis of Grocery Boxes';
data grocery2;
   length name $35   /* name of product */
          class $16  /* category of product */
          unit $1    /* unit of measurement for weights:
                           g=gram
                           o=ounce
                           l=lb
                        all weights are converted to grams */
          color $8   /* predominant color of box */
          height 8   /* height of box in cm. */
          width 8    /* width of box in cm. */
          depth 8    /* depth of box (front to back) in cm. */
          weight 8   /* weight of box in grams */
          c_white c_yellow c_red c_green c_blue 4;
                     /* dummy variables */
   retain class;
   drop unit;

   /*--- read name with possible embedded blanks ---*/
   input name & @;

   /*--- if name starts with "---",              ---*/
   /*--- it's really a category value            ---*/
   if substr(name,1,3) = '---' then do;
      class = substr(name,4,index(substr(name,4),'-')-1);
      delete;
      return;
   end;

   /*--- read the rest of the variables ---*/
   input height width depth weight unit color;

   /*--- convert weights to grams ---*/
   select (unit);
      when ('l') weight = weight * 454;
      when ('o') weight = weight * 28.3;
      when ('g') ;
      otherwise put 'Invalid unit ' unit;
   end;

   /*--- use 0/1 coding for dummy variables for colors ---*/
   c_white  = (color = 'w');
   c_yellow = (color = 'y');
   c_red    = (color = 'r');
   c_green  = (color = 'g');
   c_blue   = (color = 'b');

datalines;

---Breakfast cereals---

Cheerios                            32.5 22.4  8.4  567 g y
Cheerios                            30.3 20.4  7.2  425 g y
Cheerios                            27.5 19    6.2  283 g y
Cheerios                            24.1 17.2  5.3  198 g y
Special K                           30.1 20.5  8.5   18 o w
Special K                           29.6 19.2  6.7   12 o w
Special K                           23.4 16.6  5.7    7 o w
Corn Flakes                         33.7 25.4  8     24 o w
Corn Flakes                         30.2 20.6  8.4   18 o w
Corn Flakes                         30   19.1  6.6   12 o w
Grape Nuts                          21.7 16.3  4.9  680 g w
Shredded Wheat                      19.7 19.9  7.5  283 g y
Shredded Wheat, Spoon Size          26.6 19.6  5.6  510 g r
All-Bran                            21.1 14.3  5.2 13.8 o y
Froot Loops                         30.2 20.8  8.5 19.7 o r
Froot Loops                         25   17.7  6.4   11 o r

---Crackers---

Wheatsworth                         11.1 25.2  5.5  326 g w
Ritz                                23.1 16    5.3  340 g r
Ritz                                23.1 20.7  5.2  454 g r
Premium Saltines                    11   25   10.7  454 g w
Waverly Wafers                      14.4 22.5  6.2  454 g g

---Detergent---

Arm & Hammer Detergent              38.8 30   16.9   25 l y
Arm & Hammer Detergent              39.5 25.8 11   14.2 l y
Arm & Hammer Detergent              33.7 22.8  7      7 l y
Arm & Hammer Detergent              27.8 19.4  6.3    4 l y
Tide                                39.4 24.8 11.3  9.2 l r
Tide                                32.5 23.2  7.3  4.5 l r
Tide                                26.5 19.9  6.3   42 o r
Tide                                19.3 14.6  4.7   17 o r

---Little Debbie---

Figaroos                            13.5 18.6  3.7   12 o y
Swiss Cake Rolls                    10.1 21.8  5.8   13 o w
Fudge Brownies                      11   30.8  2.5   12 o w
Marshmallow Supremes                 9.4 32    7     10 o w
Apple Delights                      11.2 30.1  4.9   15 o w
Snack Cakes                         13.4 32    3.4   13 o b
Nutty Bar                           13.2 18.5  4.2   12 o y
Lemon Stix                          13.2 18.5  4.2    9 o w
Fudge Rounds                         8.1 28.3  5.4  9.5 o w

---Tea---

Celestial Seasonings Mint Magic      7.8 13.8  6.3   49 g b
Celestial Seasonings Cranberry Cove  7.8 13.8  6.3   46 g r
Celestial Seasonings Sleepy Time     7.8 13.8  6.3   37 g g
Celestial Seasonings Lemon Zinger    7.8 13.8  6.3   56 g y
Bigelow Lemon Lift                   7.7 13.4  6.9   40 g y
Bigelow Plantation Mint              7.7 13.4  6.9   35 g g
Bigelow Earl Grey                    7.7 13.4  6.9   35 g b
Luzianne                             8.9 22.8  6.4    6 o r
Luzianne                            18.4 20.2  6.9    8 o r
Luzianne Decaffeinated               8.9 22.8  6.4 5.25 o g
Lipton Tea Bags                     17.1 20    6.7    8 o r
Lipton Tea Bags                     11.5 14.4  6.6 3.75 o r
Lipton Tea Bags                      6.7 10    5.7 1.25 o r
Lipton Family Size Tea Bags         13.7 24    9     12 o r
Lipton Family Size Tea Bags          8.7 20.8  8.2    6 o r
Lipton Family Size Tea Bags          8.9 11.1  8.2    3 o r
Lipton Loose Tea                    12.7 10.9  5.4    8 o r

---Paste, Tooth---

Colgate                              4.4 22    3.5    7 o r
Colgate                              3.6 15.6  3.3    3 o r
Colgate                              4.2 18.3  3.5    5 o r
Crest                                4.3 21.7  3.7  6.4 o w
Crest                                4.3 17.4  3.6  4.6 o w
Crest                                3.5 15.2  3.2  2.7 o w
Crest                                3.0 10.9  2.8  .85 o w
Arm & Hammer                         4.4 17    3.7    5 o w
;

data grocery;
   length name $16;
   set grocery2;
run;

proc format; value $color
   'w'='White'
   'y'='Yellow'
   'r'='Red'
   'g'='Green'
   'b'='Blue';
run;

%let cluster=1;   /* 1=show CLUSTER output, 0=don't */
%let tree=0;      /* 1=print TREE diagram, 0=don't */
%let list=0;      /* 1=list clusters, 0=don't */
%let crosstab=1;  /* 1=crosstabulate clusters and classes,
                     0=don't                              */
%let crosscol=0;  /* 1=crosstabulate clusters and colors,
                     0=don't                              */

   /*--- define macro with options for TREE ---*/
%macro treeopt;
   %if &tree %then h page=1;
   %else noprint;
%mend;

   /*--- define macro with options for CLUSTER ---*/
%macro clusopt;
   %if &cluster %then pseudo ccc p=20;
   %else noprint;
%mend;

   /*------ two macros for showing cluster results ------*/
%macro show(n); /* n=number of clusters
                   to show results for */

proc tree data=tree %treeopt n=&n out=out;
   id name;
   copy class height width depth weight color;
run;

%if &list %then %do;
   proc sort;
      by cluster;
   run;

   proc print;
      var class name height width depth weight color;
      by cluster clusname;
   run;
%end;
%mend;

%macro show2 ;
%if &crosstab %then %do;
   ods graphics on ;
   proc freq ;
        tables class * cluster / plots=freqplot ;
   run;
   ods graphics off ;
%end;

%if &crosscol %then %do;
   ods graphics on ;
   proc freq ;
        tables color * cluster / plots=freqplot ;
   run;
   ods graphics off ;
%end;
%mend;

/**********************************************************/
/*                                                        */
/*       Analysis 1: standardized box measurements        */
/*                                                        */
/**********************************************************/
title2 'Analysis 1: Standardized data';
proc cluster data=grocery m=cen std %clusopt outtree=tree;
   var height width depth weight;
   copy name class color;
run;

%show(10);

%show2;

/**********************************************************/
/*                                                        */
/*    Analysis 2: standardized row-centered logarithms    */
/*                                                        */
/**********************************************************/

title2 'Row-centered logarithms';
data shape;
   set grocery;
   array x height width depth weight;
   array l l_height l_width l_depth l_weight;
                          /* logarithms */
   weight=weight**(1/3);  /* take cube root to conform with
                             the other linear measurements */
   do over l;             /* take logarithms */
      l=log(x);
   end;
   mean=mean( of l(*));   /* find row mean of logarithms */
   do over l;
      l=l-mean;           /* center row */
   end;
run;

title2 'Analysis 2: Standardized row-centered logarithms';
proc standard data=shape out=shapstan m=0 s=1;
   var l_height l_width l_depth l_weight;
run;

proc cluster data=shapstan m=cen %clusopt outtree=tree;
   var l_height l_width l_depth l_weight;
   copy name class height width depth weight color;
run;

%show(8);

%show2;

/**********************************************************/
/*                                                        */
/*  Analysis 3: standardized row-standardized logarithms  */
/*                                                        */
/**********************************************************/

%let list=1;
%let crosscol=1;

title2 'Row-standardized logarithms';
data std;
   set grocery;
   array x height width depth weight;
   array l l_height l_width l_depth l_weight;
                         /* logarithms */
   weight=weight**(1/3); /* take cube root to conform with
                            the other linear measurements */
   do over l;
      l=log(x);          /* take logarithms */
   end;
   mean=mean( of l(*));  /* find row mean of logarithms */
   std=std( of l(*));    /* find row standard deviation */
   do over l;
      l=(l-mean)/std;    /* standardize row */
   end;
run;

title2 'Analysis 3: Standardized row-standardized logarithms';
proc standard data=std out=stdstan m=0 s=1;
   var l_height l_width l_depth l_weight;
run;

proc cluster data=stdstan m=cen %clusopt outtree=tree;
   var l_height l_width l_depth l_weight;
   copy name class height width depth weight color;
run;


%show(7);

%show2 ;

/************************************************************/
/*                                                          */
/* Analyses 4-7: standardized row-standardized logs & color */
/*                                                          */
/************************************************************/
%let list=0;
%let crosscol=1;

title2
  'Analysis 4: Standardized row-standardized
               logarithms and color (s=.2)';
proc standard data=stdstan out=stdstan m=0 s=.2;
   var c_:;
run;

proc cluster data=stdstan m=cen %clusopt outtree=tree;
   var l_height l_width l_depth l_weight c_:;
   copy name class height width depth weight color;
run;

%show(7);

%show2;

title2
  'Analysis 5: Standardized row-standardized
               logarithms and color (s=.3)';
proc standard data=stdstan out=stdstan m=0 s=.3;
   var c_:;
run;

proc cluster data=stdstan m=cen %clusopt outtree=tree;
   var l_height l_width l_depth l_weight c_:;
   copy name class height width depth weight color;
run;

%show(6);

%show2;

title2
  'Analysis 6: Standardized row-standardized
               logarithms and color (s=.4)';
proc standard data=stdstan out=stdstan m=0 s=.4;
   var c_:;
run;

proc cluster data=stdstan m=cen %clusopt outtree=tree;
   var l_height l_width l_depth l_weight c_:;
   copy name class height width depth weight color;
run;

%show(3);

%show2;

title2
  'Analysis 7: Standardized row-standardized
               logarithms and color (s=.8)';
proc standard data=stdstan out=stdstan m=0 s=.8;
   var c_:;
run;

proc cluster data=stdstan m=cen %clusopt outtree=tree;
   var l_height l_width l_depth l_weight c_:;
   copy name class height width depth weight color;
run;


%show(10);

%show2;
