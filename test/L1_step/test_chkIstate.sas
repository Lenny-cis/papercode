options nonotes nosource nomprint nomlogic;

data work.test;
	infile cards dsd dlm=',';
	input obsid :$20. istate;
	cards;
001,0
002,1
003,
	;
run;
data work.test_res;
	infile cards dsd dlm=',';
	input obsid :$20. istate flag;
	cards;
001,0,1
002,1,0
003,,0
	;
run;
%macro test_chkIstate;
	%local aa;
	%chkIstate(flag=flag,istate=istate,res=aa);
	data test_cg;
		set work.test;
		%unquote(&aa.);
	run;
	%dsSame(a=work.test_res,b=work.test_cg,msg=pass);
%mend;

%test_chkIstate;
options notes source nomprint;
