/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SRATEX1                                             */
/*   TITLE: Documentation Example 1 for PROC STDRATE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: standardized rate                                   */
/*   PROCS: STDRATE                                             */
/*     REF: PROC STDRATE, EXAMPLE 1                             */
/****************************************************************/

data Alaska;
   State='Alaska';
   input Sex $ Age $ Death PYear:comma7.;
   datalines;
Male    00-14   37   81,205
Male    15-34   68   93,662
Male    35-54  206  108,615
Male    55-74  369   35,139
Male    75+    556    5,491
Female  00-14   78   77,203
Female  15-34  181   85,412
Female  35-54  395  100,386
Female  55-74  555   32,118
Female  75+    479    7,701
;

data Florida;
   State='Florida';
   input Sex $ Age $ Death:comma6. PYear:comma9.;
   datalines;
Male    00-14   1,189  1,505,889
Male    15-34   2,962  1,972,157
Male    35-54  10,279  2,197,912
Male    55-74  26,354  1,383,533
Male    75+    42,443    554,632
Female  00-14     906  1,445,831
Female  15-34   1,234  1,870,430
Female  35-54   5,630  2,246,737
Female  55-74  18,309  1,612,270
Female  75+    53,489    868,838
;

data TwoStates;
   length State $ 7.;
   set Alaska Florida;
run;

data US;
   input Sex $ Age $ PYear:comma10.;
   datalines;
Male    00-14  30,854,207
Male    15-34  40,199,647
Male    35-54  40,945,028
Male    55-74  19,948,630
Male    75+     6,106,351
Female  00-14  29,399,168
Female  15-34  38,876,268
Female  35-54  41,881,451
Female  55-74  22,717,040
Female  75+    10,494,416
;

ods graphics on;
proc stdrate data=TwoStates
             refdata=US
             method=direct
             stat=rate(mult=1000)
             effect
             plots(only)=(dist effect)
             ;
   population group=State event=Death total=PYear;
   reference  total=PYear;
   strata Sex Age / effect;
run;

