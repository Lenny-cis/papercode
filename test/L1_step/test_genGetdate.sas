options nonotes nosource nomprint nomlogic;

%macro test_genGetdate(s=,fvalue=,ovalue=);
	%local aa;

	%genGetdate(flag=flag,out=nfcs,dgetdate=d,res=aa);
	data test_cg_nfcsDate;

		d=&s.;
		%unquote(&aa.);
		call symput('flag',flag);
		call symput('out',nfcs);
	run;
	%put &flag.;
	%put &out.;
	%put &ovalue.;

%mend;

%test_genGetdate(s=%dsToDtv(20091212),fvalue=200,ovalue=.);
%test_genGetdate(s=.,fvalue=100,ovalue=.);
%test_genGetdate(s=%dsToDtv(20121212),fvalue=0,ovalue=1670889600);
%test_genGetdate(s=%dsToDtv(20501212),fvalue=300,ovalue=.);
options notes source nomprint;
