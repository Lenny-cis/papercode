* flag标识观测删除;
%macro flagfilter(inds=,outds=,flags=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local varsList;
	%local dsVarsN dsVar i;
	%local flagsN flag j;
	%getDsVarsList(inds=&inds.,res=&tres.);%let varslist=&&&tres.;
	%if %isBlank(&flags.) %then %do;
		%varsCount(vars=&varsList.,res=&tres.);%let dsVarsN=&&&tres.;
		%do i=1 %to &dsVarsN.;
			%varsN(vars=&varsList.,n=&i.,res=&tres.);%let dsVar=&&&tres.;
			%if %length(&dsVar.) gt 3 %then %do;
				%substr(&dsVar.,1,3) eq _F_ %then %let flags=&flags. &dsVar.;
			%end;
		%end;
	%end;
	%else %do;
		%intersection(a=&flags.,b=&varsList.,res=&tres.);%let flags=&&&tres.;
	%end;
	data &outds.;
		set &inds.;
		%varsCount(vars=&flags.,res=&tres.);%let flagsN=&&&tres.;
		%do j=1 %to &flagsN.;
			%varsN(vars=&flags.,n=&j.,res=&tres.);%let flag=&&&tres.;
			if &flag.;
		%end;
		drop &flags.;
	run;

%mend flagfilter;
* 宏变量个数;
%macro varsCount(vars=,res=);
	%local sw res var i;
	%let sw=1;
	%let i=1;
	%if not %refExist(&res) %then %error(RES is not valid!);
	%let &res=0;
	%if %isBlank(&vars) %then %return;
	%do %while(&sw);
		%let var=%qscan(&vars,&i,,QS);
		%if %isBlank(&var) %then %let sw=0;
		%else %do;
			%let &res=&i;
			%let i=%eval(&i+1);
		%end;
	%end;
%mend varsCount;
* 第N个宏变量;
%macro varsN(vars=,n=,res=);
	%if not %refExist(&res) %then %error(RES is not valid!);
	%let &res=%str();
	%if %isBlank(&vars) or %isBlank(&n) %then %return;
	%if &n=0 %then %return;
	%let &res=%qscan(&vars,&n,,QS);
%mend;
* 宏变量去重;
%macro varsUnique(vars=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&vars.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();

	%local varsN var i;
	%varsCount(vars=&vars.,res=&tres.);%let varsN=&&&tres.;
	%do i=1 %to &varsN.;
		%varsN(vars=&vars.,n=&i.,res=&tres.);%let var=&&&tres.;
		%if not(&var. in(&&&res.)) %then %let &res.=&&&res. &var.;
	%end;
%mend;
* 宏变量交集;
%macro intersection(a=,b=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&a.) or %isBlank(&b.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();

	options minoperator;

	%local aN bN avar bvar i j;

	%varsUnique(vars=&a.,res=&tres.);%let a=&&&tres.;
	%varsUnique(vars=&b.,res=&tres.);%let b=&&&tres.;
	%varsCount(vars=&a.,res=&tres.);%let aN=&&&tres.;
	%varsCount(vars=&b.,res=&tres.);%let bN=&&&tres.;
	%do i=1 %to &aN.;
		%varsN(vars=&a.,n=&i.,res=&tres.);%let avar=&&&tres.;
		%if &avar. in (&b.) %then %let &res.=&res. &avar.;
	%end;
	%do j=1 %to &bN.;
		%varsN(vars=&b.,n=&j.,res=&tres.);%let bvar=&&&tres.;
		%if &bvar. in (&a.) %then %let &res.=&res. &bvar.
	%end;

	options nominoperator;
%mend intersection;
* 宏变量并集;
%macro union(a=,b=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&a.) or %isBlank(&b.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=&b.;

	options minoperator;

	%local aN avar i;

	%varsUnique(vars=&a.,res=&tres.);%let a=&&&tres.;
	%varsUnique(vars=&b.,res=&tres.);%let b=&&&tres.;
	%varsCount(vars=&a.,res=&tres.);%let aN=&&&tres.;
	%do i=1 %to &aN.;
		%varsN(vars=&a.,n=&i.,res=&tres.);%let avar=&&&tres.;
		%if not(&avar. in (&b.)) %then %let &res.=&res. &avar.;
	%end;

	options nominoperator;
%mend union;
* 宏变量相对补集（差集）;
%macro RelativeComplement(sources=,targets=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&sources.) or %isBlank(&targets.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();

	options minoperator;

	%local sourcesN source i;

	%varsUnique(vars=&sources.,res=&tres.);%let sources=&&&tres.;
	%varsUnique(vars=&targets.,res=&tres.);%let targets=&&&tres.;
	%varsCount(vars=&sources.,res=&tres.);%let sourcesN=&&&tres.;
	%do i=1 %to &sourcesN.;
		%varsN(vars=&sources.,n=&i.,res=&tres.);%let source=&&&tres.;
		%if not(&source. in(&targets.)) %then %let &res.=&&&res. &source.;
	%end;

	options nominoperator;
%mend RelativeComplement;
* 生成业务时间;
%macro genBusiDate(flag=,out=,date=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&flag.) or %isBlank(&out.) or %isBlank(&date.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);

	%local tstmt;

	%let tstmt=%str(%quote(
		&flag.=(not missing(&date.));
		if &flag. then do;
			&flag.=(&BIZ_START_DATE. le &date. lt &BIZ_END_DATE.);
		end;
		if &flag. then &out.=&date.;
		else &out.=.;
	));
	%let &res.=&tstmt.;
%mend genBusiDate;
%macro sasVarsToQuote(vars);
	%local sw res var qvar i;
	%let sw=1;
	%let i=1;
	%let res=%str();
	%do %while(&sw);
		%let var=%qscan(&vars,&i,,QS);
		%if %isBlank(&var) %then %let sw=0;
		%else %do;
			%if &i=1 %then %let res=%str(%')&var%str(%');
			%else %let res=&res%str(,)%str(%')&var%str(%');
			%let i=%eval(&i+1);
		%end;
	%end;
	&res.
%mend sasVarsToQuote;
%macro base_person(inds=,outds=,baseds=,dropVars=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if (not %dsExist(&inds)) or (not %dsExist(&baseds.)) %then %error(INDS or BASEDS doesnot exist! &syspbuff);
	%if %isBlank(&outds.) %then %let outds=&inds;

	%local dsVars baseVars baseKeyVars baseDataVars;

	%let baseKeyVars=iid;
	%let baseDataVars=&KEY_PERSON.;
	%let baseVars=&baseKeyVars. &baseDataVars.;
	%getDsVarsList(inds=&baseds.,res=&tres.);%let dsVars=&&&tres.;
	%RelativeComplement(sources=&baseVars.,targets=&dsVars.,res=&tres.);
	%if not %isBlank(&&&tres.) %then %error(&&&tres. does not in &baseds.);

	%let baseKeyVars=%sasVarsToQuote(&baseKeyVars.);
	%let baseDataVars=%sasVarsToQuote(&baseDataVars.);

	%local orgcodeStmt getdateStmt istateStmt dropStmt;

	%if not %isBlank(&dropVars.) %then %let dropStmt=%str(%quote(
		drop &dropVars.;
	));
	%genOrgcode(flag=_F_orgcode,sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genGetdate(flag=_F_getdate,dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%chkIstate(flag=_F_istate,istate=istate,res=&tres.);%let istateStmt=&&&tres.;

	data &outds;
		if _n_ eq 1 then do;
			if 0 then set &baseDs.(keep=&baseVars.);
			declare hash cert(dataset:"&baseDs.(keep=&baseVars.)");
			cert.definekey(&baseKeyVars.);
			cert.definedata(&baseDataVars.);
			cert.definedone();
		end;
		set &inds;
		length orgcode $ &LENGTH_ORGCODE;
		format 	getDate &FORMAT_DATE;
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		if not cert.find(key:ipersonid);
	run;

%mend;
