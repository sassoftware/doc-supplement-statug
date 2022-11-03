/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: rreggs2                                             */
/*   TITLE: Getting Started Example 2 for PROC ROBUSTREG        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Robust Regression                                   */
/*                                                              */
/*   PROCS: ROBUSTREG                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data hbk;
   input index $ x1 x2 x3 y @@;
   datalines;
 1  10.1  19.6  28.3   9.7          2   9.5  20.5  28.9  10.1
 3  10.7  20.2  31.0  10.3          4   9.9  21.5  31.7   9.5
 5  10.3  21.1  31.1  10.0          6  10.8  20.4  29.2  10.0
 7  10.5  20.9  29.1  10.8          8   9.9  19.6  28.8  10.3
 9   9.7  20.7  31.0   9.6         10   9.3  19.7  30.3   9.9
11  11.0  24.0  35.0  -0.2         12  12.0  23.0  37.0  -0.4
13  12.0  26.0  34.0   0.7         14  11.0  34.0  34.0   0.1
15   3.4   2.9   2.1  -0.4         16   3.1   2.2   0.3   0.6
17   0.0   1.6   0.2  -0.2         18   2.3   1.6   2.0   0.0
19   0.8   2.9   1.6   0.1         20   3.1   3.4   2.2   0.4
21   2.6   2.2   1.9   0.9         22   0.4   3.2   1.9   0.3
23   2.0   2.3   0.8  -0.8         24   1.3   2.3   0.5   0.7
25   1.0   0.0   0.4  -0.3         26   0.9   3.3   2.5  -0.8
27   3.3   2.5   2.9  -0.7         28   1.8   0.8   2.0   0.3
29   1.2   0.9   0.8   0.3         30   1.2   0.7   3.4  -0.3
31   3.1   1.4   1.0   0.0         32   0.5   2.4   0.3  -0.4
33   1.5   3.1   1.5  -0.6         34   0.4   0.0   0.7  -0.7
35   3.1   2.4   3.0   0.3         36   1.1   2.2   2.7  -1.0
37   0.1   3.0   2.6  -0.6         38   1.5   1.2   0.2   0.9
39   2.1   0.0   1.2  -0.7         40   0.5   2.0   1.2  -0.5
41   3.4   1.6   2.9  -0.1         42   0.3   1.0   2.7  -0.7
43   0.1   3.3   0.9   0.6         44   1.8   0.5   3.2  -0.7
45   1.9   0.1   0.6  -0.5         46   1.8   0.5   3.0  -0.4
47   3.0   0.1   0.8  -0.9         48   3.1   1.6   3.0   0.1
49   3.1   2.5   1.9   0.9         50   2.1   2.8   2.9  -0.4
51   2.3   1.5   0.4   0.7         52   3.3   0.6   1.2  -0.5
53   0.3   0.4   3.3   0.7         54   1.1   3.0   0.3   0.7
55   0.5   2.4   0.9   0.0         56   1.8   3.2   0.9   0.1
57   1.8   0.7   0.7   0.7         58   2.4   3.4   1.5  -0.1
59   1.6   2.1   3.0  -0.3         60   0.3   1.5   3.3  -0.9
61   0.4   3.4   3.0  -0.3         62   0.9   0.1   0.3   0.6
63   1.1   2.7   0.2  -0.3         64   2.8   3.0   2.9  -0.5
65   2.0   0.7   2.7   0.6         66   0.2   1.8   0.8  -0.9
67   1.6   2.0   1.2  -0.7         68   0.1   0.0   1.1   0.6
69   2.0   0.6   0.3   0.2         70   1.0   2.2   2.9   0.7
71   2.2   2.5   2.3   0.2         72   0.6   2.0   1.5  -0.2
73   0.3   1.7   2.2   0.4         74   0.0   2.2   1.6  -0.9
75   0.3   0.4   2.6   0.2
;
proc robustreg data=hbk fwls method=lts;
   model y = x1 x2 x3 / diagnostics leverage;
   id index;
run;