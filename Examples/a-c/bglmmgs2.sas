/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmgs2                                            */
/*   TITLE: Getting Started Example 2 for PROC BGLIMM           */
/*          Logistic regression with random intercepts          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Binomial data                                       */
/*   PROCS: BGLIMM                                              */
/*    DATA: MultiCenter data                                    */
/*                                                              */
/*     REF: PROC BGLIMM, GETTING STARTED EXAMPLE 2              */
/*    MISC:                                                     */
/****************************************************************/

data MultiCenter;
   input Center Group$ N SideEffect @@;
   datalines;
 1  A  32  14   1  B  33  18
 2  A  30   4   2  B  28   8
 3  A  23  14   3  B  24   9
 4  A  22   7   4  B  22  10
 5  A  20   6   5  B  21  12
 6  A  19   1   6  B  20   3
 7  A  17   2   7  B  17   6
 8  A  16   7   8  B  15   9
 9  A  13   1   9  B  14   5
10  A  13   3  10  B  13   1
11  A  11   1  11  B  12   2
12  A  10   1  12  B   9   0
13  A   9   2  13  B   9   6
14  A   8   1  14  B   8   1
15  A   7   1  15  B   8   0
;

data a;
   set MultiCenter;
   r = SideEffect / N;
run;

data myattrmap;
  length markersymbol $ 12;
  input ID $ value $ markersymbol $;
  datalines;
  myid  A CircleFilled
  myid  B Circle
  ;

proc sgplot data=a dattrmap=myattrmap;
   xaxis values=(1 to 15 by 2);
   yaxis label="Ratio" values=(0 to 0.8 by 0.2);
   scatter x=center y=r / group=group attrid=myid;
run;

proc bglimm data=MultiCenter nmc=10000 thin=2 seed=976352;
   class Center Group;
   model SideEffect/N = Group / noint;
   random int / subject = Center monitor;
run;


proc bglimm data=MultiCenter nmc=10000 thin=2 seed=976352
   outpost=CenterOut;
   class Center Group;
   model SideEffect/N = Group / noint;
   random int / subject=Center monitor;
   estimate "log OR" group 1 -1;
run;


data prob;
   set CenterOut;
   pDiff = logistic(group_a) - logistic(group_b);
run;

%sumint(data=prob, var=pDiff);

proc sgplot data=prob noautolegend;
   yaxis display=(nolabel noline noticks novalues);
   xaxis label="Probability in Treatment Difference";
   density pDiff / type=kernel;
run;
