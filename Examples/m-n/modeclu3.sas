 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MODECLU3                                            */
 /*   TITLE: MODECLUS Analysis of Mammals' Teeth Data            */
 /* PRODUCT: SAS                                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: CLUSTER                                             */
 /*   PROCS: MODECLUS                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

TITLE "Modeclus Analysis of Mammals' Teeth Data";

data teeth;
   input Mammal $ 1-16 @21 (v1-v8) (1.);
   label v1='Top Incisors'
         v2='Bottom Incisors'
         v3='Top Canines'
         v4='Bottom Canines'
         v5='Top Premolars'
         v6='Bottom Premolars'
         v7='Top Molars'
         v8='Bottom Molars';
   datalines;
Brown Bat           23113333
Mole                32103333
Silver Hair Bat     23112333
Pigmy Bat           23112233
House Bat           23111233
Red Bat             13112233
Pika                21002233
Rabbit              21003233
Beaver              11002133
Groundhog           11002133
Gray Squirrel       11001133
House Mouse         11000033
Porcupine           11001133
Wolf                33114423
Bear                33114423
Raccoon             33114432
Marten              33114412
Weasel              33113312
Wolverine           33114412
Badger              33113312
River Otter         33114312
Sea Otter           32113312
Jaguar              33113211
Cougar              33113211
Fur Seal            32114411
Sea Lion            32114411
Grey Seal           32113322
Elephant Seal       21114411
Reindeer            04103333
Elk                 04103333
Deer                04003333
Moose               04003333
;

proc modeclus data=teeth std list m=1 k=3 to 8;
   id mammal;
run;

proc modeclus data=teeth std list m=1 r=1.50 to 3.00 by .25;
   id mammal;
run;

proc modeclus data=teeth std list m=1 ck=3 r=1.50 to 3.00 by .25;
   id mammal;
run;
