 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: DNEW1                                               */
 /*   TITLE: TESTS FOR %DISTANCE                                 */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: DISTANCE                                            */
 /*   PROCS: TRANSPOSE PRINT SUMMARY CONTENTS SQL ACECLUS        */
 /*          FASTCLUS UNIVARIATE                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Test 1 for DISTANCE macro';
%let _test_=2; %* echoes macro invocation in title2;
*include xmacro.sas stdize.sas distnew.sas;
%sdsfname(xmacro,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(stdize,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(distnew,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%*include 'distance.sas';
%*include 'stdize.sas';

******************************************************************;

title 'Mammals'' Teeth';
data teeth;
   input mammal $ 1-16
         @21 (v1-v8) (1.);
   label v1='Top incisors'
         v2='Bottom incisors'
         v3='Top canines'
         v4='Bottom canines'
         v5='Top premolars'
         v6='Bottom premolars'
         v7='Top molars'
         v8='Bottom molars';
   cards;
Armadillo           00000088
Mouse               11000033
Beaver              11002133
Groundhog           11002133
Rabbit              21003233
Moose               04003333
Mole                32103333
Wolf                33114423
Raccoon             33114432
Jaguar              33113211
;

%let opt=print;

%distance(data=teeth,options=&opt,method=euclid)
%distance(data=teeth,options=&opt,method=size)
%distance(data=teeth,options=&opt,method=shape)
%distance(data=teeth,options=&opt,method=corr)
%distance(data=teeth,options=&opt,method=dcorr)
%distance(data=teeth,options=&opt,method=l(1))
%distance(data=teeth,options=&opt,method=djaccard)
%distance(data=teeth,options=&opt,method=dmatch)

title2 'Method=Euclid';
%let _test_=3;
%distance(data=teeth,options=&opt,std=std)
%distance(data=teeth,options=&opt,std=range)
%distance(data=teeth,options=&opt,std=mad)
%distance(data=teeth,options=&opt,std=agk(.25))
