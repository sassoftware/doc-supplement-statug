 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: Dnew3                                               */
 /*   TITLE: TESTS FOR %DISTANCE                                 */
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

title 'Test 3 for DISTANCE macro';
%let _test_=2; %* echoes macro invocation in title2;
*include xmacro.sas stdize.sas distnew.sas;
%sdsfname(xmacro,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(stdize,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";
%sdsfname(distnew,idvd=stat,isubdir=sampsrc);
%inc "&sdsfname";

******************************************************************;

data x;
   length id $ 1;
   do by=1 to 3; do x=1 to by+1;
      y=abs(x-2);
      z=abs(x-3);
      id=substr('abcd',x,1);
      output;
      end; end;
run;

%let opt=print;

%distance() proc print; run;
%distance(data=x) proc print; run;
%distance(data=x,options=&opt)
%distance(data=x,var=x y z,options=&opt)

%*** defalut type for VAR= list: INTERVAL ***;
%distance(data=x,var=x y z id,options=&opt,method=gower)
%distance(data=x,var=x y z id,options=&opt,method=dgower)
%distance(data=x,var=x y z,options=&opt,method=euclid)
%distance(data=x,var=x y z,options=&opt,method=sqeuclid)
%distance(data=x,var=x y z,options=&opt,method=size)
%distance(data=x,var=x y z,options=&opt,method=shape)
%distance(data=x,var=x y z,options=&opt,method=cov)
%distance(data=x,var=x y z,options=&opt,method=corr)
%distance(data=x,var=x y z,options=&opt,method=dcorr)
%distance(data=x,var=x y z,options=&opt,method=sqcorr)
%distance(data=x,var=x y z,options=&opt,method=dsqcorr)
%distance(data=x,var=x y z,options=&opt,method=l(2))
%distance(data=x,var=x y z,options=&opt,method=l(1.5))
%distance(data=x,var=x y z,options=&opt,method=city)
%distance(data=x,var=x y z,options=&opt,method=chebyche)
%distance(data=x,var=x y z,options=&opt,method=power(2,2))

%*** defalut type for VAR= list: RATIO ***;
%distance(data=x,var=x y z,options=&opt,method=simratio)
%distance(data=x,var=x y z,options=&opt,method=disratio)
%distance(data=x,var=x y z,options=&opt,method=nonmetri)
%distance(data=x,var=x y z,options=&opt,method=cosine)
%distance(data=x,var=x y z,options=&opt,method=dot)
%distance(data=x,var=x y z,options=&opt,method=overlap)
%distance(data=x,var=x y z,options=&opt,method=doverlap)
%distance(data=x,var=x y z,options=&opt,method=chisq)
%distance(data=x,var=x y z,options=&opt,method=chi)
%distance(data=x,var=x y z,options=&opt,method=phisq)
%distance(data=x,var=x y z,options=&opt,method=phi)

%*** defalut type for VAR= list: NOMINAL ***;
%distance(data=x,var=x y z,options=&opt,method=hamming)
%distance(data=x,var=x y z,options=&opt,method=match)
%distance(data=x,var=x y z,options=&opt,method=dmatch)
%distance(data=x,var=x y z,options=&opt,method=dsqmatch)
%distance(data=x,var=x y z,options=&opt,method=hamann)
%distance(data=x,var=x y z,options=&opt,method=rt)
%distance(data=x,var=x y z,options=&opt,method=ss1)
%distance(data=x,var=x y z,options=&opt,method=ss3)

%*** defalut type for VAR= list: ANOMINAL ***;
%distance(data=x,var=x y z,options=&opt,method=jaccard)
%distance(data=x,var=x y z,options=&opt,method=djaccard)
%distance(data=x,var=x y z,options=&opt,method=dice)
%distance(data=x,var=x y z,options=&opt,method=rr)
%distance(data=x,var=x y z,options=&opt,method=blwnm)
%distance(data=x,var=x y z,options=&opt,method=k1)

%distance(data=x,var=x y z,by=by,options=&opt)
%distance(data=x,var=x y z,by=by,id=id,options=&opt)
%distance(data=x,var=x y z,by=by,prefix=xyz,options=&opt)
%distance(data=x,var=x y z,by=by,id=id,prefix=xyz,options=&opt)
%distance(data=x,by=by,id=id,prefix=xyz,options=&opt)
%distance(data=x,var=x y z,by=by,id=id,copy=z,options=&opt)
%distance(data=x,var=x y z,by=by,copy=id z,options=&opt)
