/*
一、
	1、用户表字段：user_info
    
序号	字段名称	数据库中字段	类型	是否可以为空
1.	用户ID	user_id		not null
2.	帐号	user_name		
3.	密码	user_password		
4.	用户昵称	user_nickname		
5.	登录状态	user_status		
6.	Access Token(三个月更换一次，用来获取QQ的OpenID)	qq_accessToken
7.	OpenID(qq用户的唯一标识)	qq_openid
8.	QQ昵称	user_qqName
9.	QQ头像路径	user_iconUrl
10.	性别(可自选也可以使用qq中的性别)	user_sex
11.	用户级别	user_level
12.	用户创建时间	user_createTime
*/
create table user_info(
	user_id int primary key NOT NULL AUTO_INCREMENT,
    user_name varchar(50),
    user_password varchar(50),
    user_nickname varchar(50),
    user_status int(2),
    
    qq_accessToken varchar(100),
    qq_openid varchar(100),
    user_qqName varchar(50),
    user_iconUrl varchar(100),
    user_sex varchar(2),
    user_level int(2),
    user_createTime datetime
);

/*
二、
	2、用户充值记录表字段：user_recharge

序号	字段名称	数据库中字段	类型	是否可以为空
1.	充值记录ID	recharge_id		not null
2.	用户ID	user_id		
3.	充值金额	recharge_money		
4.	充值时间	recharge_time		
5.	充值项目	recharge_type		
6.	充值说明	recharge_explain		

*/
create table user_recharge(
	recharge_id int primary key NOT NULL AUTO_INCREMENT,
    user_id int,
    recharge_money double,
    recharge_time datetime,
    recharge_type varchar(20),
    recharge_explain varchar(100)
);

/*
	3、问卷表字段：survey
    
序号	字段名称	数据库中字段	类型	是否可以为空
1.	问卷ID	survey_id		not null
2.	问卷类型：问卷调查、在线考试、在线投票	survey_type		
3.	问卷名称	survey_name
4.	问卷说明	survey_explain
5.	发起人ID	user_id		
6.	问卷创建时间	time_create
7.	开始时间	time_start
8.	截止时间	time_end
9.	问卷状态	survey_status
10.	问卷题目是否需要随机排列	isRandom
11.	问卷题目数量	question_nums
12.	问卷总分（如果为考试类型）	test_score
13.	考试时间（若问卷类型为考试，可以设置考试时间）	test_time	
*/
create table survey(
	survey_id int primary key NOT NULL AUTO_INCREMENT,
    survey_type int(2),
    survey_name varchar(50),
    survey_explain varchar(100),
    user_id int,
    time_create datetime,
    time_start datetime,
    time_end datetime,
    survey_status int(2),
    isRandom int(2),
    question_nums int(2),
    test_score int(10),
    test_time datetime
);

/*	
	4、问卷题目表字段：survey_question
序号	字段名称	数据库中字段	类型	是否可以为空
1.	题目ID	question_id		not null
2.	问卷ID（外键）	survey_id		
3.	题目类型	question_type		
4.	题目标题	question_title		
5.	题目说明	question_explain		
6.	
必填：默认勾选，处于勾选状态时在标题后用红色字体加上（必填）字样的提示
	isRequired		
7.	题目排序码	question_sort		
8.	题目分数（若为答卷为考试类型设置）	question_score		
9.	题目选项是否需要随机排列	isRandom		
*/
create table survey_question(
	question_id int primary key NOT NULL AUTO_INCREMENT,
    survey_id int,
    question_type int(2),
    question_title varchar(50),
    question_explain varchar(100),
    isRequired varchar(2),
    question_sort varchar(10),
    question_score int(10),
    isRandom int(2)
);

/*
	5、选项表字段： survey_option
序号	字段名称	数据库中字段	类型	是否可以为空
1、	选项ID	option_id		not null
2、	题目ID（外键）	question_id		
3、	选项Label（进度条的标题，或者投票的标题） option_label		
4、	选项内容（可以是文字，数字）	option_content		
5、	选项排序码	option_sort		
6、	是否是正确答案选项[在线考试类型问卷适用]	isCorrect		
7、	选项分数  option_score		
8、	选项当前所得票数（投票问卷类型使用）	option_votes		
*/
create table survey_option(
	 option_id int primary key NOT NULL AUTO_INCREMENT,
     question_id int,
     option_label varchar(50),
     option_content varchar(50),
     option_sort int(10),
     isCorrect int(10),
     option_score int(10),
     option_votes int
);

/*
	6、答卷表字段：answer
序号	字段名称	数据库中字段	类型	是否可以为空
1、	答卷ID	answer_id		not null
2、	问卷ID（外键）	survey_id		
3、	答卷人ID	user_id		
4、	答题开始时间：	answer_start		
5、	答题结束时间：	answer_end		
6、	答题用时	answer_usedTime		
7、	总得分	test_goal		
8、	答对题目数量	right_nums		
*/
create table answer(
	answer_id int primary key NOT NULL AUTO_INCREMENT,
    survey_id int,
    user_id int,
    answer_start datetime,
    answer_end datetime,
    answer_usedTime datetime,
    test_goal int(10),
    right_nums int(10)
);

/*
	7、答卷每题情况表： reply
    
序号	字段名称	数据库中字段	类型	是否可以为空
1、	答题ID	reply_id		not null
2、	答卷ID（外键）	answer_id		
3、	题目ID（外键）	question_id		
4、	每题回答选项ID集（单选：选项ID，多选：选项ID集，逗号隔开）	reply_ids		
5、	每题回答文本内容（可以是文字，数字）	reply_content		
6、	每题回答得分[在线考试类型问卷适用]	reply_goal		
7、	是否答对	isRight		
*/
create table reply(
	reply_id int primary key NOT NULL AUTO_INCREMENT,
    answer_id int,
    question_id int,
    reply_ids varchar(100),
    reply_content varchar(100),
    reply_goal int(10),
    isRight int(2)
);

/*更改时区为中国*/
show variables like '%time_zone%';
set global time_zone='+8:00';
