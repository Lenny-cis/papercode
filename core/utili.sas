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
%macro getDsVarList(ds=,res=,out=);
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

	%getDsVarList(ds=&a.,res=&tres.,out=&avarsds.);
	%getDsVarList(ds=&b.,res=&tres.,out=&bvarsds.);
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
