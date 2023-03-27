ods _all_ close;
ods html file='MyFile.html';

proc reg data=sashelp.class;
   model height=weight;
quit;

ods html close;

ods _all_ close;
ods listing;

proc reg data=sashelp.class;
   model height=weight;
quit;

* The ODS LISTING destination is not closed,
  which is not recommended for efficiency reasons;

ods html file='Reg.htm';

proc reg data=sashelp.class;
   model height=weight;
quit;

ods html close;

