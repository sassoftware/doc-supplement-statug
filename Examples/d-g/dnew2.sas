 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: DNEW2                                               */
 /*   TITLE: TESTS FOR %DISTANCE                                 */
 /* PRODUCT: STAT                                                */
 /*   PROCS: TRANSPOSE PRINT SUMMARY CONTENTS SQL ACECLUS        */
 /*          FASTCLUS UNIVARIATE                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: DISTANCE                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Test 2 for DISTANCE macro';
%let _test_=2; %* echoes macro invocation in title2;
*include xmacro.sas stdize.sas distnew.sas;
%sdsfname(xmacro,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(stdize,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(distnew,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%*include 'distance.sas';

******************************************************************;

data bin; input a b c; cards;
0 0 0
0 0 1
0 1 0
0 1 1
1 0 0
1 0 1
1 1 0
1 1 1
1 1 .5
0 0 .5
run;

%let opt=print;

%distance(data=bin,options=&opt,method=disratio)
%distance(data=bin,options=&opt,method=djaccard)
