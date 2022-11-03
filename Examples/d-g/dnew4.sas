 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: Dnew4                                               */
 /*   TITLE: TESTS FOR %DISTANCE NOMISS OPTION                   */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: DISTANCE                                            */
 /*   PROCS: TRANSPOSE PRINT SUMMARY CONTENTS SQL                */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

*include xmacro.sas stdize.sas distnew.sas;
%sdsfname(xmacro,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(stdize,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(distnew,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
******************************************************************;
title 'distan4.sas: test options=nomiss';

data x;
   length id $ 1;
   do by=1 to 3; do x=1 to by+1;
      y=abs(x-2);
      z=abs(x-3);
      id=substr('abcd',x,1);
      output;
      end; end;
      run;

data sub(drop=by);
   set x;
   if by=3;
   if mod(_n_,2)=0 then m=_n_;
   run;

proc print data=sub;
   run;

title 'METHOD=EUCLID';
title2 'DATA=SUB, OPTION=NOMISS';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=nomiss print
          ,method=euclid);
title2 'DATA=SUB';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=print
          ,method=euclid);

title 'METHOD=SIZE';
title2 'DATA=SUB, OPTION=NOMISS';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=nomiss print
          ,method=size);
title2 'DATA=SUB';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=print,method=size);

title 'METHOD=SHAPE';
title2 'DATA=SUB, OPTION=NOMISS';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=nomiss print
          ,method=shape);
title2 'DATA=SUB';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=print,method=shape);

******************************************************************;

data sub2(drop=by);
   set x;
   if by=3;
   if mod(_n_,2)=0 then do;
      m=_n_;
      x=.; y=.;
      end;
   else z=.;
   run;

proc print data=sub2;
   run;

title 'METHOD=COV';
title2 'DATA=SUB, OPTION=NOMISS';
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=nomiss print
          ,method=cov);
%distance(data=sub,var=x y z m,id=id,prefix=xyz,options=print,method=cov);
title2 'DATA=SUB2(NOMINAL & SYMMETRIC BINARY VARIABLES)';
%distance(data=sub2,var=x y z m,id=id,prefix=xyz,options=nomiss print
          ,method=cov);
%distance(data=sub2,var=x y z m,id=id,prefix=xyz,options=print,method=cov);
