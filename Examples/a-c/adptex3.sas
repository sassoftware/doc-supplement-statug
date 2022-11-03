/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: adptex3                                             */
/*   TITLE: Example 3 for PROC ADAPTIVEREG                      */
/*    DESC: SPAM data set                                       */
/*     REF: UCI machine learning repository                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ADAPTIVEREG                                         */
/*                                                              */
/****************************************************************/

proc adaptivereg data=sashelp.junkmail seed=10359;
   model class = Address     Addresses    All       Bracket    Business
                 CS          CapAvg       CapLong   CapTotal   Conference
                 Credit      Data         Direct    Dollar     Edu
                 Email       Exclamation  Font      Free       George
                 HP          HPL          Internet  Lab        Labs
                 Mail        Make         Meeting   Money      Order
                 Original    Our          Over      PM         Paren
                 Parts       People       Pound     Project    RE
                 Receive     Remove       Report    Semicolon  Table
                 Technology  Telnet       Will      You        Your
                 _000        _85          _415      _650       _857
                 _1999       _3D / additive dist=binomial;
   partition fraction(test=0.333);
   output out=spamout p(ilink);
run;

data test;
   set spamout(where=(_ROLE_='TEST'));
   if ((pred>0.5 & class=0) | (pred<0.5 & class=1))
   then Error=0;
   else error=1;
run;

proc freq data=test;
   tables class*error/nocol;
run;

proc adaptivereg data=sashelp.junkmail seed=10359;
   model class = Address     Addresses    All       Bracket    Business
                 CS          CapAvg       CapLong   CapTotal   Conference
                 Credit      Data         Direct    Dollar     Edu
                 Email       Exclamation  Font      Free       George
                 HP          HPL          Internet  Lab        Labs
                 Mail        Make         Meeting   Money      Order
                 Original    Our          Over      PM         Paren
                 Parts       People       Pound     Project    RE
                 Receive     Remove       Report    Semicolon  Table
                 Technology  Telnet       Will      You        Your
                 _000        _85          _415      _650       _857
                 _1999       _3D / maxbasis=61 additive dist=binomial;
   partition fraction(test=0.333);
   output out=spamout2 p(ilink);
run;
