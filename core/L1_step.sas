libname L0 "&Ltest_PATH.";
libname L1 "&L1_PATH.";

%macro base_certification(inds=,outds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local certIdStmt orgcodeStmt getdateStmt istateStmt;

	%genCertId(flag=_F_certid,out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genOrgcode(flag=_F_orgcode,out=orgcode,sorgcode=sorgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genGetdate(flag=_F_getdate,out=getdate,dgetdate=dgetdate,res=&tres.);%let getdateStmt=&&&tres.;
	%chkIstate(flag=_F_istate,istate=istate,res=&tres.);%let istateStmt=&&&tres.;

	data &outds.;
		set &inds.;
		length certId $&LENGTH_CERTID. orgcode $&LENGTH_ORGCODE.;
		format getdate &FORMAT_DATE.;
		%unquote(&certidStmt.);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&istateStmt.);
	run;
%mend;
