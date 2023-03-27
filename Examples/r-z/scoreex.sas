/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: scoreex                                             */
/*   TITLE: Getting Started Example for PROC SCORE              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Scoring                                             */
/*   PROCS: SCORE, FACTOR, PRINT                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SCORE, Getting Started Example                 */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Schools;
   input Type $ English Math Biology @@;
   datalines;
p  52  55  45  p  42  49  40  p  63  64  54
p  47  50  51  p  64  69  47  p  63  67  54
p  59  63  42  p  56  61  41  p  41  44  72
p  39  42  45  p  56  63  44  p  63  73  42
p  62  68  46  p  51  61  51  p  45  56  54
p  63  66  63  p  65  67  57  p  49  50  47
p  47  48  34  p  53  54  46  p  49  40  43
p  50  41  50  p  82  72  80  p  68  61  62
p  68  61  46  p  63  53  48  p  77  72  74
p  50  47  60  p  61  49  48  p  64  54  45
p  60  53  40  p  80  69  75  p  76  69  77
p  55  48  51  p  85  76  80  p  70  64  48
p  61  51  61  p  51  47  58  p  78  72  79
p  52  47  46  u  49  47  58  u  64  72  45
u  36  44  46  u  32  43  46  u  52  57  42
u  45  47  53  u  44  52  43  u  54  63  42
u  39  45  49  u  48  51  46  u  53  61  54
u  28  32  33  u  52  59  44  u  54  61  51
u  60  65  66  u  60  63  63  u  47  52  49
u  28  31  32  u  43  46  45  u  40  42  48
u  66  51  48  u  79  68  77  u  58  52  49
u  34  29  33  u  47  35  40  u  60  49  49
u  62  50  51  u  69  50  47  u  59  41  52
u  56  44  43  u  76  61  74  u  50  36  52
u  69  56  52  u  57  41  55  u  56  44  51
u  52  42  42  u  51  36  42  u  44  31  57
u  79  68  77  u  61  44  41  r  38  28  22
r  35  28  24  r  50  47  48  r  36  28  38
r  69  65  53  r  55  44  41  r  62  58  45
r  57  55  32  r  47  42  66  r  45  38  45
r  56  55  42  r  39  36  33  r  63  51  42
r  42  41  48  r  51  44  52  r  47  42  44
r  53  42  47  r  62  59  48  r  80  74  81
r  95  79  95  r  65  60  43  r  67  60  53
r  42  43  50  r  70  68  55  r  63  56  48
r  37  33  34  r  49  47  49  r  42  43  50
r  44  46  47  r  62  55  44  r  67  64  52
r  77  77  69  r  43  42  52  r  51  54  45
r  67  65  45  r  65  73  49  r  34  29  32
r  50  47  49  r  55  48  46  r  38  36  51
;

proc factor data=Schools score outstat=Scores noprint;
   var english math biology;
run;

proc score data=schools score=Scores out=New;
   var english math biology;
   id type;
run;

title 'OUTSTAT= Data Set from PROC FACTOR';
proc print data=Scores;
run;

title 'First Two Observations of the DATA= Data Set from PROC SCORE';
proc print data=Schools(obs=2);
run;

title 'First Two Observations of the OUT= Data Set from PROC SCORE';
proc print data=New(obs=2);
run;

title 'Mean Score of Variable Factor1 by Each Type of Schools';
proc sgplot data=New;
   hbar type / stat = mean response=Factor1;
run;

