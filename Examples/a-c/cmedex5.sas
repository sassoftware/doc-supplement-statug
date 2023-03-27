/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cmedex5                                             */
/*   TITLE: Example 5 for PROC CAUSALMED                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mediation Analysis of Time-to-Event Outcome         */
/*   PROCS: CAUSALMED                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CAUSALMED, EXAMPLE 5                           */
/*    MISC:                                                     */
/****************************************************************/

data RedDye;
   input RedDye Weeks Censor Female Tumor Freq;
   datalines;
0    29      0       0    0    1
0    30      0       0    0    1
0    38      0       0    0    1
0    48      0       0    0    1
0    53      0       0    0    1
0    56      0       0    0    1
0    62      0       0    0    1
0    70      0       0    0    1
0    71      0       0    0    1
0    74      0       0    0    1
0    74      0       0    0    1
0    76      0       0    0    1
0    85      0       0    1    1
0    86      0       0    0    1
0    86      0       0    0    1
0    92      0       0    0    1
0    97      0       0    1    1
0    99      0       0    1    1
0    101     0       0    0    1
0    102     0       0    0    1
0    103     0       0    0    1
0    104     1       0    1    0
0    104     1       0    0   12
0    42      1       0    0   17
0    70      0       1    1    1
0    77      0       1    0    1
0    83      0       1    1    1
0    87      0       1    0    1
0    92      0       1    0    1
0    92      0       1    0    1
0    93      0       1    1    1
0    96      0       1    1    1
0    100     0       1    1    1
0    102     0       1    0    1
0    102     0       1    0    1
0    103     0       1    1    1
0    104     1       1    1    2
0    104     1       1    0   16
0    42      1       1    0   20
3    2       0       0    0    1
3    16      0       0    0    1
3    23      0       0    0    1
3    34      0       0    0    1
3    35      0       0    1    1
3    35      0       0    1    1
3    67      0       0    1    1
3    77      0       0    0    1
3    77      0       0    0    1
3    79      0       0    1    1
3    84      0       0    0    1
3    89      0       0    0    1
3    92      0       0    0    1
3    96      0       0    0    1
3    97      0       0    0    1
3    98      0       0    0    1
3    99      0       0    0    1
3    104     1       0    1    0
3    104     1       0    0   19
3    42      1       0    0   14
3    34      0       1    1    1
3    36      0       1    1    1
3    48      0       1    1    1
3    48      0       1    0    1
3    65      0       1    1    1
3    91      0       1    1    1
3    91      0       1    0    1
3    98      0       1    0    1
3    102     0       1    0    1
3    102     0       1    0    1
3    103     0       1    1    1
3    104     1       1    1    3
3    104     1       1    0   18
3     42     1       1    0   18
;


proc means mean stderr min max data=RedDye;
   var Censor Female Tumor Weeks;
   class RedDye;
   freq Freq;
run;


proc causalmed data=RedDye ciratio=log poutcomemod pmedmod;
   class RedDye Female Tumor;
   model Weeks*Censor(1) = RedDye | Tumor / aft;
   mediator Tumor(event='1') = RedDye(treat='3');
   covar Female;
   freq Freq;
run;

proc causalmed data=RedDye ciratio=log poutcomemod pmedmod;
   class RedDye Female Tumor;
   model Weeks*Censor(1) = RedDye | Tumor / coxph;
   mediator Tumor(event='1') = RedDye(treat='3');
   covar Female;
   freq Freq;
run;

