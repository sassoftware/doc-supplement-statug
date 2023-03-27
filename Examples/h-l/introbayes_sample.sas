data perfect;
   call streaminit(12345);
   do n = 1 to 4000;
      gamma = rand("normal")+2.75;
      output;
   end;
run;

proc sgplot data=perfect;
   series y = gamma x = n;
   xaxis label='Simulation Number';
run;

data notburned;
   call streaminit(12345);
   do n = 1 to 4000;
      if n < 2000 then
         gamma = exp(-n/100+3)+rand("normal")+2.75;
      else
         gamma = rand("normal")+2.75;
      output;
   end;
run;

proc sgplot data=notburned;
   series y = gamma x = n;
   xaxis label='Simulation Number';
run;

data margmix;
   call streaminit(34567);
   retain old 1;
   retain gamma 1;
   do n = 1 to 4000;
      mix = rand ("binomial",0.96,1);
      if mix = old then
         gamma = gamma + rand("normal")*5;
      else
         gamma = rand("normal")/2;
      output;
   end;
   old = mix;
run;

proc sgplot data=margmix;
   series y = gamma x = n;
   xaxis label='Simulation Number';
run;

data badmix;
   retain gamma -10;
   call streaminit(23456);
   do n = 1 to 1000;
      up = rand("binomial",0.575,1);
      gamma = gamma+(-1)**(1-up)*abs(rand("normal"));
      output;
   end;
run;

proc sgplot data=badmix;
   series y = gamma x = n;
   xaxis label='Simulation Number';
run;

