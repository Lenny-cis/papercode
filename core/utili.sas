* 创建随机宏变量;
%macro createTemp(type);
	%if %isBlank(&type.) %then %let type=V;
	%let type=%upcase(&type.);
	&type.%substr(%sysfunc(md5(%sysfunc(datetime(),B8601DT15.)%sysfunc(rand(uniform))),$hex32.),2)
%mend;
* 缺失;
%macro isBlank(param);
	%eval(%length(%quote(&param))=0)
%mend;
* 错误日志;
%macro error(msg);
	%put &msg.;
	%abort;
%mend;
*宏变量是否存在;
%macro refExist(ref);
	%local res;
	%let res=1;
	%if %isBlank(&ref) %then %let res=0;
	%else %if not %symexist(&ref) %then %let res=0;
	&res.
%mend;
* 数据集是否存在;
%macro dsExist(ds);
	%local res;
	%if %isBlank(&ds) %then %let res=0;
	%else %let res=%sysfunc(exist(&ds));
	&res.
%mend;
* 获取数据集变量集;
%macro getDsVarsList(ds=,res=,out=);
	%local temp;
	%if not %refExist(&res) %then %error(RES is invalid!);
	%let &res=%str();
	%if not %dsExist(&ds) %then %return;
	%let temp=&out.;
	%if %isBlank(&out.) %then %let temp=%createTemp(D);
	proc contents data=&ds. out=&temp(keep=name) noprint varnum;
	quit;
	proc sql noprint;
		select name into :&res separated by ' ' from &temp;
	quit;
	%if %isBlank(&out.) %then %dropDs(&temp);
%mend;
* 获取数据集观测数;
%macro getDsObs(ds=,res=);
	%local dsid anobs whstmt err;
	%if not %refExist(&res) %then %error(RES is invalid!);
	%let &res=0;
	%if not %dsExist(&ds) %then %return;
	%let dsid=%sysfunc(open(&ds., IS));
	%let anobs=%sysfunc(attrn(&dsid, ANOBS));
	%let whstmt=%sysfunc(attrn(&dsid, WHSTMT));
	%if &anobs=1 and &whstmt=0 %then %do;
		%let &res=%sysfunc(attrn(&dsid, NLOBS));
		%let err=%sysfunc(close(&dsid));
		%return;
	%end;
	%else %do;
		%let err=%sysfunc(close(&dsid));
	%end;
%mend;
* 删除数据集;
%macro dropDs(ds);
	%local i d lib table;
	%if not %dsExist(&ds) %then %return;
	proc delete data=&ds;
	run;
%mend;
* 数据集比较;
%macro dsSame(a=,b=,msg=);
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%local avarsds bvarsds t_ds;
	%let avarsds=%createTemp(D);
	%let bvarsds=%createTemp(D);
	%let t_ds=%createTemp(D);

	%getDsVarsList(ds=&a.,res=&tres.,out=&avarsds.);
	%getDsVarsList(ds=&b.,res=&tres.,out=&bvarsds.);
	proc compare compare=&avarsds. base=&bvarsds. noprint out=&t_ds. outnoequal ;
	run;
	%getDsObs(ds=&t_ds.,res=&tres.);
	%dropDs(&t_ds.);
	%dropDs(&avarsds.);
	%dropDs(&bvarsds.);
	%if &&&tres. ne 0 %then %error(VARS in &a. ne &b.!);

	proc compare compare=&a. base=&b. noprint out=&t_ds. outnoequal ;
	run;
	%getDsObs(ds=&t_ds.,res=&tres.);
	%dropDs(&t_ds.);
	%if &&&tres. ne 0 %then %error(&a. ne &b.!);
	%else %put &a. &b. &msg.;

%mend dsSame;
* 时间格式转换;
%macro dsToDtv(ds);
	%sysfunc(inputn(&ds.000000,B8601DJ18.))
%mend;
%macro dtvToDs(dtv);
	%sysfunc(putn(&dtv,B8601DN.))
%mend;
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
	%let vars=%upcase(&vars.);

	%local varsN var i;
	%varsCount(vars=&vars.,res=&tres.);%let varsN=&&&tres.;
	%do i=1 %to &varsN.;
		%varsN(vars=&vars.,n=&i.,res=&tres.);%let var=&&&tres.;
		%if &i. eq 1 %then %let &res.=&var.;
		%else %if not(&var. in (&&&res.)) %then %let &res.=&&&res. &var.;
	%end;

%mend;
* 宏变量交集;
%macro intersection(a=,b=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&a.) or %isBlank(&b.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();
	%let a=%upcase(&a.);
	%let b=%upcase(&b.);

	%local aN avar i;

	%varsUnique(vars=&a.,res=&tres.);%let a=&&&tres.;
	%varsUnique(vars=&b.,res=&tres.);%let b=&&&tres.;
	%varsCount(vars=&a.,res=&tres.);%let aN=&&&tres.;
	%do i=1 %to &aN.;
		%varsN(vars=&a.,n=&i.,res=&tres.);%let avar=&&&tres.;
		%if &avar. in (&b.) %then %let &res.=&&&res. &avar.;
	%end;

%mend intersection;
* 宏变量并集;
%macro union(a=,b=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&a.) or %isBlank(&b.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();
	%let a=%upcase(&a.);
	%let b=%upcase(&b.);

	%local bN bvar i;

	%varsUnique(vars=&a.,res=&tres.);%let a=&&&tres.;
	%varsUnique(vars=&b.,res=&tres.);%let b=&&&tres.;
	%varsCount(vars=&b.,res=&tres.);%let bN=&&&tres.;
	%let &res.=&a.;
	%do i=1 %to &bN.;
		%varsN(vars=&b.,n=&i.,res=&tres.);%let bvar=&&&tres.;
		%if not(&bvar. in (&a.)) %then %let &res.=&&&res. &bvar.;
	%end;

%mend union;
* 宏变量相对补集（差集）;
%macro RelativeComplement(sources=,targets=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&sources.) or %isBlank(&targets.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();
	%let sources=%upcase(&sources.);
	%let targets=%upcase(&targets.);

	%local sourcesN source i;

	%varsUnique(vars=&sources.,res=&tres.);%let sources=&&&tres.;
	%varsUnique(vars=&targets.,res=&tres.);%let targets=&&&tres.;
	%varsCount(vars=&sources.,res=&tres.);%let sourcesN=&&&tres.;
	%do i=1 %to &sourcesN.;
		%varsN(vars=&sources.,n=&i.,res=&tres.);%let source=&&&tres.;
		%if not(&source. in(&targets.)) %then %let &res.=&&&res. &source.;
	%end;

%mend RelativeComplement;
* sas变量格式转为引用变量，以逗号隔开;
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
* flag标识观测删除;
%macro flagfilter(inds=,outds=,flags=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local varsList;
	%local dsVarsN dsVar i;
	%local flagsN flag j;
	%getDsVarsList(ds=&inds.,res=&tres.);%let varslist=&&&tres.;
	%if %isBlank(&flags.) %then %do;
		%varsCount(vars=&varsList.,res=&tres.);%let dsVarsN=&&&tres.;
		%do i=1 %to &dsVarsN.;
			%varsN(vars=&varsList.,n=&i.,res=&tres.);%let dsVar=&&&tres.;
			%if %length(&dsVar.) gt 3 %then %do;
				%if %substr(&dsVar.,1,3) eq _F_ %then %let flags=&flags. &dsVar.;
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
