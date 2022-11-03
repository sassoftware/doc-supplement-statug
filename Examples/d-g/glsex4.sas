/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsex4                                              */
/*   TITLE: Example 4 for PROC GLMSELECT                        */
/*    DESC: Simulated Tennis Camp Data                          */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multimember Effects, Spline Effects, Design Matrix  */
/*   PROCS: GLMSELECT, REG                                      */
/*                                                              */
/****************************************************************/

data TennisCamp;
   length forehandCoach $6 backhandCoach $6 volleyCoach $6 gender $1;
   input forehandCoach backhandCoach volleyCoach tLessons tPractice tPlay
         gender inRating nPastCamps age tForehand tBackhand tVolley
         improvement;
   label forehandCoach = "Forehand lesson coach"
         backhandCoach = "Backhand lesson coach"
         volleyCoach   = "Volley   lesson coach"
         tForehand     = "time (1/2 hours) of forehand lesson"
         tBackhand     = "time (1/2 hours) of backhand lesson"
         tVolley       = "time (1/2 hours) of volley lesson"
         tLessons      = "time (1/2 hours) of all lessons"
         tPractice     = "total practice time (hours)"
         tPlay         = "total play time (hours)"
         nPastCamps    = "Number of previous camps attended"
         age           = "age (years)"
         inRating      = "Rating at camp start"
         improvement   = "Rating improvement at end of camp";
   datalines;
.        .        Tom     1   30   19   f   44   0   13   0   0   1    6
Greg     .        .       2   12   33   f   48   2   15   2   0   0   14
.        .        Mike    2   12   24   m   53   0   15   0   0   2   13
.        Mike     .       1   12   28   f   48   0   13   0   1   0   11
.        Bruna    .       2   13   34   f   57   0   16   0   2   0   12
.        Bruna    Mike    5   31   11   f   54   1   14   0   2   3   12
Tom      .        .       3   17   31   m   57   2   15   3   0   0   11
.        .        .       0   32   17   m   45   0   13   0   0   0    2
Tom      .        .       2   22   11   m   43   0   13   2   0   0    5
.        Greg     .       2   14   32   m   45   1   15   0   2   0   14
.        Tom      Tom     3   16   21   m   42   2   15   0   2   1    9
Bruna    Bruna    .       4   17   17   m   46   0   15   2   2   0   10
.        Tom      .       2   13   25   f   50   0   13   0   2   0   10
Elaine   Mike     .       4   13   34   m   43   0   15   2   2   0   16
.        .        Bruna   1   12   27   m   42   1   15   0   0   1    7
Bruna    .        .       1   28   17   m   47   0   15   1   0   0    3
.        Mike     .       2   10   35   m   56   0   13   0   2   0   15
.        .        .       0   11   37   m   48   0   15   0   0   0    8
.        Greg     .       1   28   17   f   54   0   14   0   1   0    7
Tom      .        .       2   17   31   m   44   0   13   2   0   0   10
.        .        Tom     3    8   27   f   44   1   14   0   0   3   12
.        .        .       0   15   33   m   56   0   14   0   0   0    8
.        .        .       0   26   18   f   48   0   14   0   0   0    3
.        Bruna    Mike    3   27   12   m   41   1   16   0   2   1   12
Bruna    .        .       2   28   19   f   39   0   15   2   0   0    5
.        .        Mike    3    9   28   m   51   0   14   0   0   3   14
.        Greg     .       2   28   12   f   52   0   15   0   2   0   10
.        .        Andy    3    6   34   f   44   0   15   0   0   3   12
.        .        .       0   21   23   f   51   2   16   0   0   0    5
Bruna    .        .       2   13   31   m   48   0   16   2   0   0   11
.        .        .       0   12   33   f   46   0   13   0   0   0    7
.        .        Greg    3   21   20   m   57   1   14   0   0   3   12
.        .        .       0   10   33   m   58   0   14   0   0   0    7
Bruna    .        .       2   21   27   f   45   0   15   2   0   0    8
Bruna    .        Bruna   2   15   30   f   51   0   14   1   0   1   10
.        Bruna    .       2   16   26   f   50   0   13   0   2   0    8
.        .        .       0   19   26   m   41   0   16   0   0   0    7
.        .        .       0   25   23   m   51   0   15   0   0   0    4
Tom      .        .       2    5   29   f   56   1   15   2   0   0   11
.        Bruna    .       2   10   38   f   45   0   16   0   2   0   11
.        Tom      .       2   30   17   m   56   0   15   0   2   0    4
Greg     .        .       2   20   16   m   59   2   15   2   0   0    9
Mike     .        Mike    3   25   20   m   46   0   13   2   0   1   12
.        .        Bruna   3   29   19   m   50   1   14   0   0   3    8
.        .        Greg    3   20   28   m   54   0   13   0   0   3   14
Mike     .        .       1   21   24   f   54   0   14   1   0   0   10
.        .        .       0   28   19   f   49   0   14   0   0   0    4
Greg     Greg     .       3    6   35   m   53   1   14   1   2   0   15
Tom      .        Greg    3    7   37   f   57   1   14   1   0   2   18
.        Tom      .       2   10   31   m   51   0   13   0   2   0    9
.        Bruna    .       2   32    9   m   46   0   16   0   2   0    4
Elaine   .        Greg    4    6   34   m   58   0   13   2   0   2   17
Bruna    .        Greg    3   30    0   m   47   0   14   1   0   2    7
.        .        Tom     1   29   10   f   55   0   16   0   0   1    3
.        .        Mike    3   16   21   m   55   0   14   0   0   3   13
.        Elaine   Greg    5   13   27   m   42   0   15   0   2   3   18
Greg     .        Tom     5   21   20   m   49   0   13   2   0   3   15
.        .        .       0   28   11   m   53   2   16   0   0   0    3
Mike     Bruna    .       3   23   20   m   43   1   14   2   1   0   12
.        Greg     .       2   17   19   m   57   1   15   0   2   0   14
Greg     .        .       1   11   34   f   47   0   15   1   0   0   13
Tom      .        Mike    4   20   19   m   55   1   16   2   0   2   16
Mike     .        .       2   10   37   f   48   2   15   2   0   0   14
Tom      .        .       1    7   34   m   48   0   14   1   0   0    9
Mike     Bruna    .       3   15   25   f   49   0   13   2   1   0   14
Tom      .        .       3   14   33   m   53   1   16   3   0   0   11
Bruna    .        Greg    3   22   10   m   51   1   15   2   0   1   12
.        .        .       0   25   17   m   58   0   16   0   0   0    2
Greg     Bruna    Tom     5   21   25   m   49   0   14   2   1   2   17
Bruna    Tom      Bruna   5   12   27   m   49   0   13   2   2   1   15
.        .        Mike    3   12   21   m   50   2   15   0   0   3   14
.        Greg     .       2   24   18   f   47   0   15   0   2   0   11
.        .        Bruna   3    9   33   f   53   0   14   0   0   3   11
.        .        Greg    2    8   33   f   59   2   15   0   0   2   14
.        .        .       0   30   11   m   55   0   14   0   0   0    2
.        Tom      .       1   28   19   m   57   0   13   0   1   0    5
.        Bruna    Tom     3    7   40   m   51   0   15   0   2   1   14
.        .        Tom     3   15   25   f   50   0   14   0   0   3    9
Tom      .        .       1   21   18   m   53   0   13   1   0   0    5
.        .        Bruna   3   16   20   m   47   0   13   0   0   3   10
.        .        Greg    2   17   32   f   46   0   14   0   0   2   15
Greg     .        .       1   16   32   m   48   0   13   1   0   0   11
.        .        Mike    1   15   26   m   48   0   13   0   0   1   11
.        .        .       0    5   33   m   45   0   13   0   0   0    8
.        Bruna    .       1   31   17   m   39   0   16   0   1   0    4
.        Greg     .       1    6   39   m   46   0   13   0   1   0   15
.        Greg     .       2   19   14   f   50   0   13   0   2   0   11
.        .        .       0   12   32   f   55   0   15   0   0   0    7
Bruna    .        .       2   25   20   f   49   0   15   2   0   0    8
Greg     .        .       1   18   19   m   56   0   13   1   0   0    9
.        .        Mike    1   32    9   m   53   0   13   0   0   1    6
Bruna    Greg     Tom     6   32   10   m   48   0   16   2   2   2   15
Greg     Bruna    .       3   18   25   f   51   0   13   1   2   0   13
.        .        Greg    1   16   21   m   53   0   13   0   0   1    9
Mike     .        .       2    8   36   f   50   0   13   2   0   0   14
.        Tom      .       3   16   22   f   51   0   15   0   3   0    9
Elaine   Tom      Mike    6   10   26   m   37   0   16   2   1   3   17
.        .        .       0   29   16   m   50   0   14   0   0   0    2
Mike     .        .       2   25   13   m   49   2   16   2   0   0   10
Greg     .        Mike    5    7   31   f   51   1   15   2   0   3   24
.        .        .       0   32    7   f   61   0   13   0   0   0    1
.        .        Bruna   1   17   29   m   49   0   14   0   0   1    8
Greg     .        .       2   12   29   m   53   0   14   2   0   0   14
Mike     .        .       2   13   36   m   48   0   13   2   0   0   15
Greg     .        .       2   30   10   f   47   0   15   2   0   0    7
.        Bruna    .       2   15   21   m   48   0   13   0   2   0    8
.        Mike     Mike    4   19   10   m   51   0   13   0   1   3   14
Mike     .        .       2   30   10   m   39   0   15   2   0   0    7
.        Greg     .       2   25   13   f   55   0   13   0   2   0    8
.        Tom      .       2    9   29   f   41   0   14   0   2   0   10
.        .        .       0   32   14   m   54   0   13   0   0   0    2
.        .        Tom     3   10   33   m   54   2   15   0   0   3   13
.        .        Bruna   2   11   36   m   49   0   16   0   0   2   11
.        .        Greg    2   24   15   m   58   2   15   0   0   2   10
Mike     .        Greg    4   11   35   m   49   0   14   2   0   2   23
.        Mike     Bruna   3   20   20   m   57   0   14   0   1   2   14
.        .        Tom     3   23   22   m   49   0   15   0   0   3    8
Tom      .        .       2    6   36   f   62   1   14   2   0   0   11
.        .        Tom     3   26   16   f   45   2   15   0   0   3    6
Bruna    .        .       2   19   24   m   55   0   13   2   0   0    7
.        .        .       0   29   12   m   51   1   15   0   0   0    3
Elaine   .        Greg    3    6   39   m   57   1   15   2   0   1   17
.        Greg     .       1   18   23   f   45   0   15   0   1   0   11
.        .        Tom     1    7   28   f   46   0   16   0   0   1    8
Bruna    .        .       2   18   22   f   53   2   15   2   0   0    7
.        Mike     .       2   23   25   f   46   0   13   0   2   0   11
.        .        .       0   17   33   m   49   1   16   0   0   0    7
Greg     .        .       1   15   16   m   55   0   13   1   0   0   10
.        Greg     Greg    6    5   32   m   55   0   13   0   3   3   19
.        Tom      .       1   22   20   f   55   0   13   0   1   0    6
.        .        Greg    1   23   22   m   52   0   14   0   0   1   10
.        .        .       0   18   31   f   52   0   14   0   0   0    7
Greg     .        .       2   20   25   f   57   2   15   2   0   0   12
Mike     .        Bruna   5   32   13   m   54   0   15   2   0   3   12
Greg     Tom      .       3   13   26   m   53   0   13   1   2   0   15
Bruna    Greg     .       3    8   25   m   51   0   13   1   2   0   16
.        .        .       0   18   28   m   55   0   14   0   0   0    7
.        Bruna    .       1   21   23   m   50   0   15   0   1   0    5
.        .        Greg    3    8   34   m   48   0   16   0   0   3   15
Bruna    .        Tom     4   13   21   m   47   0   13   2   0   2   13
.        Tom      .       2   27   11   f   51   1   16   0   2   0    4
.        .        Andy    1    9   32   m   52   1   15   0   0   1    9
.        .        Tom     1   26   16   m   54   1   14   0   0   1    5
Tom      .        .       3   27   20   f   58   1   15   3   0   0    8
Tom      .        .       1   32   12   m   50   0   16   1   0   0    2
.        .        Mike    2   18   22   f   46   0   13   0   0   2   10
.        .        .       0   19   26   m   55   0   16   0   0   0    7
Elaine   Greg     .       2   30   14   m   53   0   15   1   1   0    9
Greg     .        Bruna   4   19   18   m   48   0   15   1   0   3   14
.        Bruna    Greg    4   32    5   m   47   0   13   0   2   2   12
.        Tom      .       2   17   19   m   51   1   14   0   2   0    7
Tom      .        .       1   28   18   f   56   0   13   1   0   0    5
.        .        Greg    2    9   28   m   45   0   14   0   0   2   15
Bruna    Bruna    .       3   26   22   m   55   1   15   1   2   0    8
.        Bruna    .       2   31   12   m   53   0   16   0   2   0    4
Mike     .        .       3   21   26   m   44   0   14   3   0   0   15
.        .        .       0   31   14   f   40   1   14   0   0   0    1
Tom      Greg     .       4   20   18   m   54   2   15   2   2   0   14
.        Bruna    .       2   17   31   m   43   1   14   0   2   0   10
.        .        Tom     3   21   25   m   53   0   13   0   0   3    9
.        Tom      .       2   26   14   m   47   0   13   0   2   0    5
Bruna    .        Greg    3   22   22   m   46   0   13   2   0   1   13
.        .        .       0    8   41   m   53   2   15   0   0   0    9
.        .        Andy    2    7   31   m   55   0   13   0   0   2   10
Mike     Greg     Bruna   7   18   20   f   51   0   14   2   2   3   23
Greg     .        Bruna   2   27    9   f   55   1   15   1   0   1    8
Greg     .        .       1    9   32   f   49   0   15   1   0   0   13
.        Mike     .       2   17   23   f   49   0   14   0   2   0   11
.        Bruna    .       2   30   18   f   54   0   13   0   2   0    5
.        .        Greg    2   22   20   f   52   2   16   0   0   2   12
.        .        .       0   20   23   m   54   0   15   0   0   0    6
Elaine   Tom      .       4   15   25   m   54   0   15   2   2   0   11
.        .        .       0   32    7   m   60   0   13   0   0   0    1
Greg     .        .       1   18   25   m   51   1   14   1   0   0   12
.        .        Greg    1    9   37   m   55   0   13   0   0   1   15
.        .        Greg    1    9   36   m   52   0   13   0   0   1   12
.        Mike     Tom     4    9   28   m   47   0   13   0   2   2   16
Greg     .        .       2   22   18   m   51   0   15   2   0   0   11
Greg     .        .       2   25   19   m   47   0   13   2   0   0   10
.        Mike     Greg    4   14   20   m   49   1   16   0   1   3   19
Greg     .        .       1   24   24   m   54   0   15   1   0   0   10
Greg     .        .       2   26   12   m   39   0   14   2   0   0    8
Greg     Bruna    .       2    6   29   m   44   1   15   1   1   0   14
Greg     Tom      .       3   19   25   m   50   0   13   2   1   0   17
Tom      Bruna    .       3   24   24   m   54   0   13   1   2   0    8
Bruna    .        .       2   12   36   f   55   0   13   2   0   0   11
Tom      Tom      Greg    5   25   20   m   52   0   14   1   2   2   16
.        Greg     .       2   16   33   f   54   0   15   0   2   0   14
.        .        .       0   10   41   m   52   0   15   0   0   0    9
.        .        .       0   25   26   m   55   0   13   0   0   0    3
Mike     .        .       2   32   14   m   47   0   15   2   0   0    9
.        Tom      .       2   14   27   f   56   0   13   0   2   0    9
Elaine   Mike     Andy    7   18   18   m   53   1   15   2   2   3   19
Bruna    .        .       2   23   22   f   43   0   14   2   0   0    9
Mike     .        .       3   21   23   m   55   2   15   3   0   0   13
.        Bruna    .       2   10   30   f   56   0   13   0   2   0    9
.        Bruna    .       2    5   39   f   48   0   13   0   2   0   12
Bruna    .        .       2   25   14   m   46   0   14   2   0   0    7
.        Greg     Greg    5   19   22   m   44   1   16   0   2   3   18
.        .        Bruna   3   28   20   m   55   0   13   0   0   3    9
.        Mike     Bruna   4    5   38   m   53   0   14   0   1   3   16
.        .        Bruna   3   10   38   m   46   0   13   0   0   3   10
.        .        .       0   12   38   m   47   1   15   0   0   0    8
Greg     Tom      Tom     6    3   41   m   48   2   15   2   1   3   19
.        Greg     Mike    5   30   16   m   52   0   13   0   2   3   18
;

proc glmselect data=TennisCamp outdesign=designCamp;
   class forehandCoach backhandCoach volleyCoach gender;

   effect coach    = mm(forehandCoach backhandCoach volleyCoach / noeffect
                         details weight=(tForehand tBackhand tVolley));
   effect practice = spline(tPractice/knotmethod=list(25) details);

   model improvement = coach practice tLessons tPlay age gender
                       inRating nPastCamps;
run;

proc print data=designCamp(obs=5);
run;

ods graphics on;

proc reg data=designCamp;
   model improvement = &_GLSMOD;
quit;

ods graphics off;
proc glmselect data=TennisCamp
     outdesign(fullmodel prefix=parm names)=designCampGeneric;
   class forehandCoach backhandCoach volleyCoach gender;

   effect coach    = mm(forehandCoach backhandCoach volleyCoach / noeffect
                         details weight=(tForehand tBackhand tVolley));
   effect practice = spline(tPractice/knotmethod=list(25) details);

   model improvement = coach practice tLessons tPlay age gender
                       inRating nPastCamps;
run;

proc print data=designCampGeneric(obs=5);
run;
