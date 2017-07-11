options nonotes nosource nomprint nomlogic minoperator;

%macro test_union;
	%local a b exp case;
	%local tres;%let tres=%createTemp(V);%local &tres;

	%let a=%str(a b c);
	%let b=%str(b d f);
	%let exp=%str(a b c d f);
	%union(a=&a,b=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a a c d a);
	%let b=%str(b e f c a);
	%let exp=%str(a c d b e f);
	%union(a=&a,b=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(aa bb cc 11 22);
	%let b=%str(33 22 11 cc xx yy);
	%let exp=%str(aa bb cc 11 22 33 xx yy);
	%union(a=&a,b=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a='1' b='aBc' c='456');
	%let b=%str(c='777' A='1' B='Abc');
	%let exp=%str(a='1' b='aBc' c='456' c='777');
	%union(a=&a,b=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a='1' b='aBc' c='456');
	%let b=%str(c='777' A='1' B='Abc');
	%let exp=%str(a='1' b='aBc' c='456' c='777' A='1' B='Abc');
	%union(a=&a,b=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

%mend;
%test_union;
options notes source mprint;
