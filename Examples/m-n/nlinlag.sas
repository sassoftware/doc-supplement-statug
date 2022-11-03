 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: NLINLAG                                             */
 /*   TITLE: Jorgenson Distributed Lag (Box Jenkins)             */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: econometrics, nonlinear models                      */
 /*   PROCS: NLIN                                                */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: ECONOMETRICS, MADDALA                               */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
*-------Maddala-Rao ML Estimate of Jorgenson Distributed Lag-------*
|    See Maddala and Rao, Review of EC and STAT, 1971, p80, and    |
| Maddala, econometricS.   This model is the same as a Box-Jenkins |
| transfer model (ratio of polynomial lags) but with a simple      |
| error process.                                                   |
*------------------------------------------------------------------*;

TITLE1 'Sample member: nlinlag';
TITLE2 'Jorgenson distributed lag model';
TITLE3 'National Industrial Conference Board data';

data a;
   input y x @@;
   n=_n_-2;
   y=y/10000;
   x=x/10000;
   datalines;
   .    .    .    .
2072 1660 2077 1926 2078 2181 2043 1897 2062 1695 2067 1705 1964 1731
1981 2151 1914 2556 1991 3152 2129 3763 2309 3903 2614 3912 2896 3571
3058 3199 3309 3262 3446 3476 3466 2993 3435 2262 3183 2011 2697 1511
2338 1631 2140 1990 2012 1993 2071 2520 2192 2804 2240 2919 2421 3024
2639 2725 2733 2321 2721 2131 2640 2552 2513 2234 2448 2282 2429 2533
2516 2517 2534 2772 2494 2380 2596 2568 2572 2944 2601 2629 2648 3133
2840 3449 2937 3764 3136 3983 3299 4381 3514 4786 3815 4094 4093 4870
4262 5344 4531 5433 4825 5911 5160 6109 5319 6542 5574 5785 5749 5707
5715 5412 5637 5465 5383 5550 5467 5465
;
proc print;
proc nlin;
   parms a0=.08 a1=.03 a2=.10 b1=1 b2=-.2 t1=1 t2=1;

   *---Compute xs=b(l)(-1) x ---;
   if n=-1 then do;
      xs=t2; xst1=0; xst2=1; xsb1=0; xsb2=0; end;
   else if n=0 then do;
      xs=t1; xst1=1; xst2=0; xsb1=0; xsb2=0; end;
   else do;
      xs=         x + b1*zlag(xs)   + b2*zlag2(xs);
      xst1 =          b1*zlag(xst1) + b2*zlag2(xst1);
      xst2 =          b1*zlag(xst2) + b2*zlag2(xst2);
      xsb1 = zlag(xs)+ b1*zlag(xsb1) + b2*zlag2(xsb1);
      xsb2 = zlag2(xs) + b1*zlag(xsb2) + b2*zlag2(xsb2);
      end;

   yhat = a0*xs + a1*zlag(xs) + a2*zlag2(xs);
   if n<=2 then yhat=.;
   model y=yhat;

run;
