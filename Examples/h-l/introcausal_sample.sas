proc causalgraph;
   model "MyModel"
      Age    ==> Parity PFAS Education,
      Parity ==> PrevBF Duration PFAS,
      PrevBF ==> PFAS Duration,
      PFAS   ==> Duration,
      Education ==> Duration Employment PFAS BMI Alcohol Smoking,
      Employment ==> Duration PFAS BMI Alcohol Smoking,
      BMI Alcohol Smoking ==> Duration;
   identify PFAS ==> Duration;
run;

proc causalmed data=birthwgt;
   class LowBirthWgt Smoking Death AgeGroup Race Drinking;
   mediator LowBirthWgt = Smoking;
   model Death = LowBirthWgt | Smoking;
   covar AgeGroup Race Drinking;
run;

proc causaltrt data=drugs;
   class Gender;
   psmodel Drug = Age Gender BMI;
   model Diabetes = Age Gender BMI;
run;

proc psmatch data=School;
   class Music Gender;
   psmodel Music = Gender Absence;
   match method=optimal;
   output out(obs=match)=OutMatch;
run;

proc ttest data=OutMatch;
   class Music;
   var GPA;
   weight _MATCHWGT_;
run;

