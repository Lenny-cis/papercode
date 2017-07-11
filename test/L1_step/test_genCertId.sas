options nonotes nosource nomprint nomlogic;
data work.test;
	infile cards dsd dlm=',';
	input obsid :$20. idtype :$20. id :$20.;
	cards;
001,0,210101199803017394
010,,210101199803017394
011,0,
012,1,210101199803017394
002,0,210101199803017394123
003,0,A10101199803017394
004,0,210101199803017391
005,0,010101199803017397
006,0,210101199813017398
;
run;
data work.test_res;
	infile cards dsd dlm=',';
	input obsid :$20. idtype :$20. id:$20. flag out :$20.;
	cards;
001,0,210101199803017394,1,210101199803017394
010,,210101199803017394,0,
011,0,,0,
012,1,210101199803017394,0,
002,0,210101199803017394123,0,
003,0,A10101199803017394,0,
004,0,210101199803017391,0,
005,0,010101199803017397,0,
006,0,210101199813017398,0,
;
run;
%macro test_genCertId;
	%local aa;
	%genCertId(flag=flag,out=out,scerttype=idtype,scertno=id,res=aa);

	data work.test_cg;
		length out $ 100; 
		set work.test;
		%unquote(&aa.);
	run;
	%dsSame(a=work.test_res,b=work.test_cg,msg=pass);
%mend;

%test_genCertId;
options notes source nomprint;
