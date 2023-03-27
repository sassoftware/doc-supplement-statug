/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex2                                            */
/*   TITLE: Example 2 for PROC BGLIMM                           */
/*    DESC: Mating Experiment with Crossed Random Effects       */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Binary data                                         */
/*   PROCS: BGLIMM                                              */
/*    DATA: Salamander mating data                              */
/*                                                              */
/*     REF: McCullagh, P. and Nelder. J.A. (1989)               */
/*          Generalized Linear Models, Second Edition           */
/*          London: Chapman and Hall                            */
/****************************************************************/

data Salamander;
   input Day Fpop$ Fnum Mpop$ Mnum Mating @@;
   datalines;
4  rb  1 rb  1 1  4  rb  2 rb  5 1
4  rb  3 rb  2 1  4  rb  4 rb  4 1
4  rb  5 rb  3 1  4  rb  6 ws  9 1
4  rb  7 ws  8 0  4  rb  8 ws  6 0
4  rb  9 ws 10 0  4  rb 10 ws  7 0
4  ws  1 rb  9 0  4  ws  2 rb  7 0
4  ws  3 rb  8 0  4  ws  4 rb 10 0
4  ws  5 rb  6 0  4  ws  6 ws  5 0
4  ws  7 ws  4 1  4  ws  8 ws  1 1
4  ws  9 ws  3 1  4  ws 10 ws  2 1
8  rb  1 ws  4 1  8  rb  2 ws  5 1
8  rb  3 ws  1 0  8  rb  4 ws  2 1
8  rb  5 ws  3 1  8  rb  6 rb  9 1
8  rb  7 rb  8 0  8  rb  8 rb  6 1
8  rb  9 rb  7 0  8  rb 10 rb 10 0
8  ws  1 ws  9 1  8  ws  2 ws  6 0
8  ws  3 ws  7 0  8  ws  4 ws 10 1
8  ws  5 ws  8 1  8  ws  6 rb  2 0
8  ws  7 rb  1 1  8  ws  8 rb  4 0
8  ws  9 rb  3 1  8  ws 10 rb  5 0
12 rb  1 rb  5 1  12 rb  2 rb  3 1
12 rb  3 rb  1 1  12 rb  4 rb  2 1
12 rb  5 rb  4 1  12 rb  6 ws 10 1
12 rb  7 ws  9 0  12 rb  8 ws  7 0
12 rb  9 ws  8 1  12 rb 10 ws  6 1
12 ws  1 rb  7 1  12 ws  2 rb  9 0
12 ws  3 rb  6 0  12 ws  4 rb  8 1
12 ws  5 rb 10 0  12 ws  6 ws  3 1
12 ws  7 ws  5 1  12 ws  8 ws  2 1
12 ws  9 ws  1 1  12 ws 10 ws  4 0
16 rb  1 ws  1 0  16 rb  2 ws  3 1
16 rb  3 ws  4 1  16 rb  4 ws  5 0
16 rb  5 ws  2 1  16 rb  6 rb  7 0
16 rb  7 rb  9 1  16 rb  8 rb 10 0
16 rb  9 rb  6 1  16 rb 10 rb  8 0
16 ws  1 ws 10 1  16 ws  2 ws  7 1
16 ws  3 ws  9 0  16 ws  4 ws  8 1
16 ws  5 ws  6 0  16 ws  6 rb  4 0
16 ws  7 rb  2 0  16 ws  8 rb  5 0
16 ws  9 rb  1 1  16 ws 10 rb  3 1
20 rb  1 rb  4 1  20 rb  2 rb  1 1
20 rb  3 rb  3 1  20 rb  4 rb  5 1
20 rb  5 rb  2 1  20 rb  6 ws  6 1
20 rb  7 ws  7 0  20 rb  8 ws 10 1
20 rb  9 ws  9 1  20 rb 10 ws  8 1
20 ws  1 rb 10 0  20 ws  2 rb  6 0
20 ws  3 rb  7 0  20 ws  4 rb  9 0
20 ws  5 rb  8 0  20 ws  6 ws  2 0
20 ws  7 ws  1 1  20 ws  8 ws  5 1
20 ws  9 ws  4 1  20 ws 10 ws  3 1
24 rb  1 ws  5 1  24 rb  2 ws  2 1
24 rb  3 ws  3 1  24 rb  4 ws  4 1
24 rb  5 ws  1 1  24 rb  6 rb  8 1
24 rb  7 rb  6 0  24 rb  8 rb  9 1
24 rb  9 rb 10 1  24 rb 10 rb  7 0
24 ws  1 ws  8 1  24 ws  2 ws 10 0
24 ws  3 ws  6 1  24 ws  4 ws  9 1
24 ws  5 ws  7 0  24 ws  6 rb  1 0
24 ws  7 rb  5 1  24 ws  8 rb  3 0
24 ws  9 rb  4 0  24 ws 10 rb  2 0
;

proc bglimm data=Salamander seed=725697;
   class Fpop Fnum Mpop Mnum;
   model Mating (event='1') = Fpop|Mpop / dist=binary;
run;


proc bglimm data=salamander nmc=20000 seed=901214;
   class Fpop Fnum Mpop Mnum;
   model Mating (event='1') = Fpop|Mpop / dist=binary;
   random int / sub=Fpop*Fnum;
   random int / sub=Mpop*Mnum;
run;

proc bglimm data=salamander nmc=20000 seed=901214 outpost=Sal_Out;
   class Fpop Fnum Mpop Mnum;
   model Mating (event='1') = Fpop|Mpop / dist=binary;
   random int / sub=Fpop*Fnum;
   random int / sub=Mpop*Mnum;
   estimate "rb and rb" Int 1 Fpop 1 0 Mpop 1 0 Fpop*Mpop 1;
   estimate "rb and ws" Int 1 Fpop 1 0 Mpop 0 1 Fpop*Mpop 0 1;
   estimate "ws and rb" Int 1 Fpop 0 1 Mpop 1 0 Fpop*Mpop 0 0 1;
   estimate "ws and ws" Int 1 Fpop 0 1 Mpop 0 1 Fpop*Mpop 0 0 0 1;
run;

data Post;
   set Sal_Out;
   rr = Intercept + Fpop_rb + Mpop_rb + Fpop_rb_Mpop_rb;
   rw = Intercept + Fpop_rb;
   wr = Intercept + Mpop_rb;
   ww = Intercept;
   drop Intercept__:;
run;

data Prob;
   set Post;
   p_rr_f = logistic(rr);
   p_rw_f = logistic(rw);
   p_wr_f = logistic(wr);
   p_ww_f = logistic(ww);
run;

data Prob;
   set Post;
   call streaminit(87925);
   g_f = rand("normal", 0, sqrt(random1_var));
   g_m = rand("normal", 0, sqrt(random2_var));
   p_rr = logistic(rr + g_f + g_m);
   g_f = rand("normal", 0, sqrt(random1_var));
   g_m = rand("normal", 0, sqrt(random2_var));
   p_rw = logistic(rw + g_f + g_m);
   g_f = rand("normal", 0, sqrt(random1_var));
   g_m = rand("normal", 0, sqrt(random2_var));
   p_wr = logistic(wr + g_f + g_m);
   g_f = rand("normal", 0, sqrt(random1_var));
   g_m = rand("normal", 0, sqrt(random2_var));
   p_ww = logistic(ww + g_f + g_m);
   drop g_f g_m;
run;

proc sgplot data=Prob noborder;
  density p_rr / type=kernel legendlabel='p(rb & rb)'
     lineattrs=(pattern=solid);
  density p_rw / type=kernel legendlabel='p(rb & ws)'
     lineattrs=(pattern=ShortDash);
  density p_wr / type=kernel legendlabel='p(ws & rb)'
     lineattrs=(pattern=DashDotDot);
  density p_ww / type=kernel legendlabel='p(ws & ws)'
     lineattrs=(pattern=LongDash);
  keylegend / location=inside position=topright across=1;
  xaxis label="Probability";
  yaxis display=(nolabel noline noticks novalues);
run;

data nonMarg;
   set post;
   p_rr_f = logistic(rr);
   p_rw_f = logistic(rw);
   p_wr_f = logistic(wr);
   p_ww_f = logistic(ww);
run;

proc sgplot data=nonMarg noborder;
  density p_rr_f / type=kernel legendlabel='p(rb & rb)'
     lineattrs=(pattern=solid);
  density p_rw_f / type=kernel legendlabel='p(rb & ws)'
     lineattrs=(pattern=ShortDash);
  density p_wr_f / type=kernel legendlabel='p(ws & rb)'
     lineattrs=(pattern=DashDotDot);
  density p_ww_f / type=kernel legendlabel='p(ws & ws)'
     lineattrs=(pattern=LongDash);
  keylegend / location=inside position=topright across=1;
  xaxis label="Probability";
  yaxis display=(nolabel noline noticks novalues);
run;

