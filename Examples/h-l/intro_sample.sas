proc reg data=sashelp.class;
   model weight = height;
quit;

ods select none;
proc contents data=sashelp._all_;
   ods output members=m;
run;
ods select all;

proc print;
   where memtype = 'DATA';
run;

proc contents data=sashelp._all_;
run;

