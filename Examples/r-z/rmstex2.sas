/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: RMSTEX2                                             */
/*   TITLE: Example 2 for PROC RMSTREG                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Compare RMST between 2 groups                       */
/*   PROCS: RMSTREG                                             */
/*    DATA: Hosmer, D. W., Jr., and Lemeshow, S. (1999).        */
/*          Applied Survival Analysis: Regression Modeling of   */
/*          Time-to-Event Data. New York: John Wiley & Sons.    */
/*                                                              */
/*     REF: PROC RMSTREG, EXAMPLE 2                             */
/*    MISC:                                                     */
/****************************************************************/

data HIV;
   input Time Age Drug Status;
   datalines;
    5      46      0        1
    6      35      1        0
    8      30      1        1
    3      30      1        1
   22      36      0        1
    1      32      1        0
    7      36      1        1
    9      31      1        1
    3      48      0        1
   12      47      0        1
    2      28      1        0
   12      34      0        1
    1      44      1        1
   15      32      1        1
   34      36      0        1
    1      36      0        1
    4      54      0        1
   19      35      0        0
    3      44      1        0
    2      38      0        1
    2      40      0        0
    6      34      1        1
   60      25      0        0
   11      32      0        1
    2      42      1        0
    5      47      0        1
    4      30      0        0
    1      47      1        1
   13      41      0        1
    3      40      1        1
    2      43      0        1
    1      41      0        1
   30      30      0        1
    7      37      0        1
    4      42      1        1
    8      31      1        1
    5      39      1        1
   10      32      0        1
    2      51      0        1
    9      36      0        1
   36      43      0        1
    3      39      0        1
    9      33      0        1
    3      45      1        1
   35      33      0        1
    8      28      0        1
   11      31      0        1
   56      20      1        0
    2      44      0        0
    3      39      1        1
   15      33      0        1
    1      31      0        1
   10      33      0        1
    1      50      1        1
    7      36      1        1
    3      30      1        1
    3      42      1        1
    2      32      1        1
   32      34      0        1
    3      38      1        1
   10      33      0        0
   11      39      1        1
    3      39      1        1
    7      33      1        1
    5      34      1        1
   31      34      0        1
    5      46      1        1
   58      22      0        1
    1      44      1        1
    3      37      0        0
   43      25      0        1
    1      38      0        1
    6      32      0        1
   53      34      0        1
   14      29      0        1
    4      36      1        1
   54      21      0        1
    1      26      1        1
    1      32      1        1
    8      42      0        1
    5      40      1        1
    1      37      1        1
    1      47      0        1
    2      32      1        1
    7      41      1        0
    1      46      1        0
   10      26      1        1
   24      30      0        0
    7      32      1        1
   12      31      1        0
    4      35      0        1
   57      36      0        1
    1      41      1        1
   12      36      1        0
    7      35      1        1
    1      34      1        1
    5      28      0        1
   60      29      0        0
    2      35      1        0
    1      34      1        1
;

proc rmstreg data=hiv tau=48;
   class Drug;
   model Time*Status(0) = Drug Age / link=linear;
   lsmeans Drug;
run;

proc rmstreg data=hiv tau=48;
   class Drug;
   model Time*Status(0) = Drug Age / link=linear method=ipcw;
   lsmeans Drug;
run;

ods graphics on;
proc lifetest data=hiv plot=s(test);
   strata Drug;
   time Time*Status(1);
run;

proc rmstreg data=hiv tau=48;
   class Drug;
   model Time*Status(0) = Drug Age / link=linear method=ipcw(strata=Drug);
   lsmeans Drug;
run;

