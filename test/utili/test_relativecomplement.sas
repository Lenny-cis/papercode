options nonotes nosource nomprint nomlogic minoperator;

%macro test_relativecomplement;
	%local a b exp case;
	%local tres;%let tres=%createTemp(V);%local &tres;

	%let a=%str(a b c);
	%let b=%str(b d f);
	%let exp=%str(a c);
	%relativecomplement(sources=&a,targets=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a a c d a);
	%let b=%str(b e f c a);
	%let exp=%str(d);
	%relativecomplement(sources=&a,targets=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(aa bb cc 11 22);
	%let b=%str(33 22 11 cc xx yy);
	%let exp=%str(aa bb);
	%relativecomplement(sources=&a,targets=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a='1' b='aBc' c='456');
	%let b=%str(c='777' a='1' B='Abc');
	%let exp=%str(b='aBc' c='456');
	%relativecomplement(sources=&a,targets=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

	%let a=%str(a='1' b='aBc' c='456');
	%let b=%str(c='777' A='1' B='Abc');
	%let exp=%str(a='1' b='aBc' c='456');
	%relativecomplement(sources=&a,targets=&b,res=&tres);
	%put exp=&exp.;
	%put res=&&&tres.;

%mend;
%test_relativecomplement;
options notes source mprint;
