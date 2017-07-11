options nonotes nosource nomprint nomlogic;

data work.test;
	infile cards dsd dlm=',';
	input obsid :$20. sorgcode :$20.;
	cards;
001,111111111
002,Q10151000H220
003,A1015110AH2200
004,Q10151000H2212
005,Q10151 0AH2200
006,Q1015100AH2200
;
run;
data work.test_res;
	infile cards dsd dlm=',';
	input obsid :$20. sorgcode :$20. flag out :$20.;
	cards;
001,111111111,0,
002,Q10151000H220,0,
003,A1015110AH2200,0,
004,Q10151000H2212,0,
005,Q10151 0AH2200,0,
006,Q1015100AH2200,1,Q1015100AH2200
;
run;
%macro test_cg_orgcode;
	%local aa;
	%genOrgcode(flag=flag,out=out,sorgcode=sorgcode,res=aa);
	data test_cg;
		length out $ 100;
		set work.test;
		%unquote(&aa.);
	run;
	%dsSame(a=test_cg,b=test_res,msg=pass);
%mend;

%test_cg_orgcode;
options notes source mprint mlogic;
