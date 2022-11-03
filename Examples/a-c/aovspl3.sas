 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: AOVSPL3                                             */
 /*   TITLE: Split-Split-Split Plot ANOVA                        */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance,                               */
 /*   PROCS: ANOVA                                               */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

*--------split-split-split plot design: tire experiment--------*
|                                                              |
| Three types of fabric treatments were used.   Each was       |
| replicated five times, giving 15 lots.   The order of pre-   |
| paring these was at random.   Each treated fabric was sub-   |
| divided and treated with two different rubber compounds.     |
| Each fabricated unit was again subdivided into two parts and |
| each half given a different cure.  Finally each cure was sub-|
| divided into four test pieces, two pieces being tested at two|
| different temperatures.                                      |
*--------------------------------------------------------------*;

data tires;
   input fabric rubber rep @;
   do cure=1 to 2;
      do temp=1 to 2;
         do piece=1 to 2;
            input y @; output;
            end;
         end;
      end;
   datalines;
1 1  1  29  26  34  29  40  35  76  64
1 1  2  84  54  41  40 136  67  74  58
1 1  3  87  66  47  37  70  56  63  55
1 1  4  80  70  53  27  68  37  49  38
1 1  5  79  48  63  53  66  48  43  29
1 2  1 113  81  88  48  84  37  91  57
1 2  2 108  92  71  49  81  72  55  52
1 2  3 123 108  59  49 121 101  98  42
1 2  4  57  43  47  28 102  56  95  55
1 2  5  82  76  80  35  84  73  50  50
2 1  6   6   6  32  16   7   7  34  22
2 1  7   6   6  26  18  12  12  26  24
2 1  8  12  12  52  20  14  12  41  36
2 1  9   9   6  21  16   9   7  15  14
2 1 10  15  13  21  17  13   9  34  15
2 2  6   6   6  15  12  16   7  41  19
2 2  7   6   6  25  19   8   6  23  23
2 2  8   7   7  50  32  20  19  47  33
2 2  9  13   8  22  20  23  23  64  33
2 2 10   6   6  27  19  16  14  74  31
3 1 11  76  68  34  22  27  20 118  29
3 1 12  16  11  24  15  43  31  49  36
3 1 13  61  50  46  24  36  25  62  21
3 1 14  41  23  29  19  25  13  66  43
3 1 15   8   6  14  11   7   7  28  21
3 2 11  13  11  53  26  37  24  59  52
3 2 12  22  19  22  22  99  17  45  38
3 2 13  22  18  48  18  76  48  30  25
3 2 14  58  32  30  26  72  64  94  43
3 2 15   7   7  11  11  16  12  19  13
;

proc anova;
   classes fabric rubber rep cure temp piece;
   model y=fabric  rep(fabric)
           rubber  rubber*fabric
                   rubber*rep(fabric)
           cure    cure*fabric   cure*rubber
                   cure*rubber*fabric
                   cure*rubber*rep(fabric)
           temp temp*fabric temp*rubber temp*fabric*rubber
                temp*cure temp*cure*fabric temp*cure*rubber
                temp*cure*fabric*rubber
                temp*cure*rubber*rep(fabric);
   test h=fabric e=rep(fabric);
   test h=rubber rubber*fabric e=rubber*rep(fabric);
   test h=cure cure*fabric cure*rubber cure*rubber*fabric
        e=cure*rubber*rep(fabric);
   test h=temp temp*fabric temp*rubber temp*fabric*rubber
          temp*cure temp*cure*fabric temp*cure*rubber
          temp*cure*fabric*rubber
        e=temp*cure*rubber*rep(fabric);
   title 'Split-split-split Plot Design: Tire Experiment';
   run; quit;
