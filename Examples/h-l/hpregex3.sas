/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpregex3                                            */
/*   TITLE: Example 3 for PROC HPREG                            */
/*    DESC: Simulated Data                                      */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: FORWARDSWAP selection                               */
/*   PROCS: HPREG                                               */
/*                                                              */
/****************************************************************/


  data ex3Data;
     array x{20};
     do i=1 to 10000;
        do j=1 to 20;
           x{j} = ranuni(1);
        end;
        y = 3*x1 + 7*x2 -5*x3 + 5*x1*x3 +
            4*x2*x13 + x7 + x11 -x13  + x1*x4 + rannor(1);
        output;
     end;
  run;


 proc hpreg data=ex3Data;
     model y = x1|x2|x3|x4|x5|x6|x7|x8|x9|x10|X11|
               x12|x13|x14|x5|x16|x7|x18|x19|x20@2 /
                   include=(x1 x2 x3) start=(x1*x2 x1*x3 x2*x3);
     selection method=forwardswap(select=rsquare maxef=15 choose=sbc)
               details=all;
 run;

