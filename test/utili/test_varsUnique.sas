options nonotes nosource nomprint nomlogic;

%macro test_varsUnique;
	%local a b exp case;
	%local tres;%let tres=%createTemp(V);%local &tres;

	%let a=%str(a b c);
	%varsUnique(vars=&a,res=&tres);
	%put a=&a.;
	%put res=&&&tres.;

	%let a=%str(a b c d a b a b);
	%varsUnique(vars=&a,res=&tres);
	%put a=&a.;
	%put res=&&&tres.;

	%let a=%quote(a=1 b=2 c=3 a=-1 b=2 c=3);
	%varsUnique(vars=&a,res=&tres);
	%put a=&a.;
	%put res=&&&tres.;

	%let a=%str(a=1 b=2 c=3 A=1 A=-1 B=3);
	%varsUnique(vars=&a,res=&tres);
	%put a=&a.;
	%put res=&&&tres.;

	%let a=%str(a=1 b=2 c=3 A=1 A=-1 B=3);
	%varsUnique(vars=&a,res=&tres);
	%put a=&a.;
	%put res=&&&tres.;

	%let a=%str(a='1' b=2 B=' abc ' b=' ABC ');
	%varsUnique(vars=&a,res=&tres);
	%put a=&a.;
	%put res=&&&tres.;

	%let a=abc a;
	%varsUnique(vars=%quote(&a),res=&tres);
	%put a=&a.;
	%put res=&&&tres.;
%mend;
%test_varsUnique;
%macro test_varsUnique_performance;

	%local tres;%let tres=%createTemp(V);%local &tres;
	%local i;
	%local var vars;


	%do i=1 %to 100;
		%let var=var&i;
		%let vars=&vars &var;
	%end;

	%varsUnique(vars=&vars,res=&tres);

%mend;

%test_varsUnique;
%test_varsUnique_performance;
options notes source mprint;
