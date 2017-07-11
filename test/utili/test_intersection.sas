options nonotes nosource nomprint nomlogic minoperator;

%macro test_intersection;
	%local a b exp case;
	%local tres;%let tres=%createTemp(V);%local &tres;

	%let a=%str(a b c);
	%let b=%str(b d f);
	%let exp=b;
	%intersection(a=&a,b=&b,caseSensitive=&case,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a b c d a);
	%let b=%str(b a d c c a);
	%let exp=%str(a b c d);
	%intersection(a=&a,b=&b,caseSensitive=&case,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(aa bb cc 11 22);
	%let b=%str(33 22 11 cc xx yy);
	%let exp=%str(cc 11 22);
	%intersection(a=&a,b=&b,caseSensitive=&case,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a='1' b='aBc' c='456');
	%let b=%str(c='777' a='1' B='aBc');
	%let exp=%str(a='1');
	%intersection(a=&a,b=&b,caseSensitive=&case,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a='1' b='aBc' c='456');
	%let b=%str(c='777' A='1' B='Abc');
	%let exp=%str();
	%intersection(a=&a,b=&b,caseSensitive=&case,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

%mend;
%test_intersection;
options notes source mprint;
