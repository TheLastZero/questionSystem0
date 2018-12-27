<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'surveyEdit.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	
	<!-- 加载jQuery的cookie相关的js -->
	<script src="${pageContext.request.contextPath}/static/js/jquery.cookie.js"></script>
	
	<!-- 引入时间插件所需js和css -->
	<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/wui/css/wui.min.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/wui/css/style.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/wui/js/angular.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/wui/js/wui-date.js" charset="utf-8"></script>
 --%>
	<!-- 引入样式 -->
	<link href="${pageContext.request.contextPath}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
		rel="stylesheet">
	
	<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
	<script src="${pageContext.request.contextPath}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
	
	<!-- 引入qq登录组件 -->
	<script type="text/javascript"  charset="utf-8"
		    src="http://connect.qq.com/qc_jssdk.js" 
		    data-appid="101507637" 
		    data-redirecturi="http://questionnaire.zerozrz.com/qq/qq.jsp" >
	</script>
	
	<style type="text/css">	
	
		    /* div,table,td{
				border: 1px solid red;
			}  */      
		  
		  /*去除table的td，th顶部边框*/
		  .table>tbody>tr>td, .table>tbody>tr>th, 
		  .table>tfoot>tr>td, .table>tfoot>tr>th, 
		  .table>thead>tr>td, .table>thead>tr>th{
		  	border: none;
		  }
		  
		  td{
		  	width: 45px;
		  }
		  
		  table {
		    border-spacing: 0;
		    border-collapse: inherit;
		}
		  
		  .colRow{
		  	margin-top: 10px;
		  }
		  
		 /*给按钮组添加一层div设置毛玻璃效果*/
		.btnGroup{
			filter:blur(10px);
			-webkit-filter:blur(10px);
			-moz-filter:blur(10px);
			-ms-filter:blur(10px);
			-o-filter:blur(10px);
			}
		  
	</style>
	
	<script type="text/javascript">
			
			$(document).ready(function(){
				
				var questionNum=5;
				  
				//加载导航条
				$("#m").load("utils/nav.jsp");
				
				/*
					点击更改问卷出题顺序按钮时
				*/
				$("#isRandom").on("click",function(){
					
					if($("#isRandom").val()==0){//从顺序改为乱序
						$("#isRandom").val(1);
						$("#isRandom").text("乱序");
					}else{//从乱序改为顺序
						$("#isRandom").val(0);
						$("#isRandom").text("顺序");
					}
					
				});
				
				/*
					点击改变题目编辑栏展开状态
				*/
				$("#isEdit").on("click",function(){
					if($("#isEdit").val()==0){//从全部展开状态改为全部收起
						$("#isEdit").val(1);
						$("#isEdit").text("全部收起");
						/* <div class="collapse" id="coll_1" aria-expanded="false" style="height: 0px;"> */
						
						$("div[class='collapse in']")
							.attr("class","collapse")
							.attr("aria-expanded","false")
							.arrt("style","height: 0px;");
						
					}else{//从全部收起状态改为全部展开
						$("#isEdit").val(0);
						$("#isEdit").text("全部展开");
						 /* <div class="collapse in" id="coll_'+questionNum+'" aria-expanded="true" style>' */
						$("div[class='collapse']")
							.attr("class","collapse in")
							.attr("aria-expanded","true")
							.attr("style","");
					}
				});
				
				
				/*
					根据问卷id加载问卷基本信息,题目和题目说明，还有题目类型
				*/
				var surveyId = $("#surveyId").val();
				
				$.ajax({
					url:"${pageContext.request.contextPath}/survey/getById",
					type:"POST",
					data:"surveyId="+surveyId,
					success:function(result){
					
						//console.log(result);
						
						//1、将问卷标题设置为查询到的标题
						$("h1 input").val(result.extend.survey.surveyName);
						
						//2、将问卷类型设置为查询到的类型
						var type = result.extend.survey.surveyType;
						if(type==0){
							type = "问卷调查";
						}else if(type==1){
							type = "在线考试";
						}else if(type==2){
							type = "在线投票";
						}
						
						$("h1 small").text(type);
						
						//3、将问卷说明设置为查询到的说明
						$("#surveyExplain").val(result.extend.survey.surveyExplain);
						
						//4、把题目的排序方式设置为查询到的
						if(result.extend.survey.israndom==1){
							$("#isRandom").val(1);
							$("#isRandom").text("乱序");
						}else{
							$("#isRandom").val(0);
							$("#isRandom").text("顺序");
						}
						
					}
					
				});
				
				/*
					根据问卷id加载所有的题目
				*/
				$.ajax({
					url:"${pageContext.request.contextPath}/question/getQuestionBySurveyId",
					type:"POST",
					data:"surveyId="+surveyId,
					success:function(result){
						console.log(result);
						
						//遍历所有的题目信息
						$.each(result.extend.questionList,function(index,question){
							
							/*0、如果是答卷的显示，需要先判断问卷中是否选择了随机出题
								如果是随机出题，我们需要按照随机顺序显示每一道题*/
							
							/*
								1、先判断题目的类型，不同类型有不同题目的拼接方式
							*/
							var questionType = question.questionType;
							if(questionType==0){//单选
							
								$("#radioOne").click();//模拟点击单选
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								var nowThis = $(tbody).next();//获取控制条tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);
								
								/*
									2、根据题目id查询旗下所有选项
								*/
								$.ajax({
									url:"${pageContext.request.contextPath}/option/getOptionByQuestionId",
									type:"POST",
									data:"questionId="+question.questionId,
									success:function(result2){
										console.log(result2);
										
										$.each(result2.extend.optionList,function(index,option){
											
											
											//每当有一个选项，我们就模拟点击一下本控制条中的添加按钮
											//如果不加:first，每多一个选项就会多一个添加按钮，为了不重复添加我们只取第一个新增按钮即可
											$(nowThis).find("button[val='create']:first").click();
											
											//将tbody和控制条input中的值与数据库同步
											$(tbody).find("tr[optionsort='"+option.optionSort+"']").find("span").text(option.optionContent);
											$(nowThis).find("div[optionsort='"+option.optionSort+"']").find("input").val(option.optionContent);
										});
										
										
									}
								});
								
								
							}else if(questionType==1){//复选
								
								$("#checkboxMany").click();//模拟点击复选
								
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								var nowThis = $(tbody).next();//获取控制条tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);
								
								/*
									2、根据题目id查询旗下所有选项
								*/
								$.ajax({
									url:"${pageContext.request.contextPath}/option/getOptionByQuestionId",
									type:"POST",
									data:"questionId="+question.questionId,
									success:function(result2){
										console.log(result2);
										
										$.each(result2.extend.optionList,function(index,option){
											
											//每当有一个选项，我们就模拟点击一下本控制条中的添加按钮
											//如果不加:first，每多一个选项就会多一个添加按钮，为了不重复添加我们只取第一个新增按钮即可
											$(nowThis).find("button[val='create']:first").click();
											
											//将tbody和控制条input中的值与数据库同步
											$(tbody).find("tr[optionsort='"+option.optionSort+"']").find("span").text(option.optionContent);
											$(nowThis).find("div[optionsort='"+option.optionSort+"']").find("input").val(option.optionContent);
										});
										
										
									}
								});
								
							
							}else if(questionType==2){//填空
								$("#fillBtn").click();//模拟点击填空
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								var nowThis = $(tbody).next();//获取控制条tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);
							
							}else if(questionType==3){//下拉框
								
								$("#selectBtn").click();//模拟点击下拉框
								
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								var nowThis = $(tbody).next();//获取控制条tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);
								/*
									2、根据题目id查询旗下所有选项
								*/
								$.ajax({
									url:"${pageContext.request.contextPath}/option/getOptionByQuestionId",
									type:"POST",
									data:"questionId="+question.questionId,
									success:function(result2){
										console.log(result2);
										
										$.each(result2.extend.optionList,function(index,option){
											
											//每当有一个选项，我们就模拟点击一下本控制条中的添加按钮
											//如果不加:first，每多一个选项就会多一个添加按钮，为了不重复添加我们只取第一个新增按钮即可
											$(nowThis).find("button[val='create']:first").click();
											
											//将tbody和控制条input中的值与数据库同步
											$(tbody).find("option[optionsort='"+option.optionSort+"']").text(option.optionContent);
											$(nowThis).find("div[optionsort='"+option.optionSort+"']").find("input").val(option.optionContent);
										});
										
										
									}
								});
							
							

							}else if(questionType==4){//评分条
								
								//1、判断其用户权限，是否可以使用此功能
								var userLevel = ${sessionScope.user.userLevel}+"";
								if(userLevel<1){//如果用户权限不足直接返回false
								
									return false;
								}
								
								
								$("#sorceBarBtn").click();//模拟点击填空
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								var nowThis = $(tbody).next();//获取控制条tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);


							}
							

							
							
							
						});
						
						
					}
					
				});
				
				
				
				
				var f = false;
				
				//当进度条控件被点击到移动组件鼠标未抬起时，f=true
				$(document).on("mousedown",".myProgress button",function(){
					f = true;
				});
				
				//当进度条控件被点击到移动组件鼠标抬起时，f=false
				$(document).on("mouseup",function(){
					f = false;
				});
				
				$(document).on("mousemove",".myProgress",function(e){//
					
					if(f==true){
						//鼠标位置相对于div的宽度
						var px = e.clientX-$(this).offset().left;
						
						//鼠标当前位置与div总宽度的百分比
						var pre = px/$(this).width()+"";
						
						//取pre取小数点后3位，就是进度条的百分比
						var result = pre.substring(0,4); 
						
						result = result*100;
						
						result = Math.floor(result);
						
						console.log(result);
						
						if(result>=100){
							px = $(this).width();
							result=100;
						}
						
						//设置按钮跟随鼠标移动的位置
						$(this).find("button").attr("style","position: absolute;height:50px;margin-top:-14px;margin-left:"+px+" ;");
						
						//将当前的百分比设置为进度条的值
						$(this).find("div").attr("style","width: "+result+"%");
						
						//将进度条以数字显示在问题旁
						$(this).parents("tbody").find("span[class='source']").text(result);
					}
				});
				
				/*
					单选框或多选框被点击时，我们添加一个单选的模板
				*/
				$("#radioOne,#checkboxMany").on("click",function(){
					var id = $(this).attr("id");
					var questionType;
					if(id=="radioOne"){
						questionType = 0;
					}else if(id=="checkboxMany"){
						questionType = 1;
					}
					
					//在table中追加两个tbody，第一个tbody是题目，第二个tbody是控制条
					$("#surveyBody table").append(
						'<tbody questionNum='+questionNum+' questionType="'+questionType+'" data-toggle="collapse" data-target="#coll_'+questionNum+'" aria-expanded="true" aria-controls="collapseExample">'+
'								<tr>'+
'									<th class="col-md-1 text-right" style="border: none;">'+
'										<span class="titleNum">'+questionNum+'、</span>'+
'									</th>'+
'									<th class="col-md-11">'+
'										<span class="title">点击编辑问题</span>'+
'									</th>'+
'								</tr>'+
'								'+
'							</tbody>'+
'							<tbody>'+
'								<tr>'+
'									<td colspan="2">'+
'										<!-- <div class="collapse in" id="collapseExample" aria-expanded="true" style="">'+
'									      <div class="well">'+
'									        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident.'+
'									    </div> -->'+
'									    '+
'									    '+
'									    <div class="collapse in" id="coll_'+questionNum+'" aria-expanded="true" style>'+
'									      <div class="well">'+
'									        '+
'									        	<div class="container" style="width: 100%">'+
'									        		<div class="row">	'+
'									        		<div class="row">'+
'									        			<div class="col-md-12 text-center">'+
'									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>'+
'									        			</div>	'+
'									        		</div>'+
'									        		<div class="row">'+
'									        			<div class="col-md-4">'+
'									        				选项文本'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				操作'+
'									        			</div>'+
'									        			'+
'										        		</div>'+
'										        		'+
'									        		<div class="row option_crudBtn" style="margin-top: 10px">'+
'									        			<div class="col-md-4">'+
'									        				<!-- <input type="text"> -->'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				<button val="create" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>'+
'									        					新增选项'+
'									        				</button>'+
'									        				<button val="remove" removeType="question" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>'+
'									        					删除本题	'+
'									        				</button>'+
'									        				'+
'									        			</div>'+
'									        			'+
'									        		</div>'+
'									        	</div>'+
'									      </div>'+
'										</div>'+
'									</td>'+
'								</tr>'+
'							</tbody>'
					);
					
				
				//整页题目序号重置
				sortQuestion();
				
					
				}); 
				
				/*
					下拉框被点击时，我们添加一个下拉框的模板
				*/
				$("#selectBtn").on("click",function(){
				
					$("#surveyBody table").append(
						' <tbody questionNum='+questionNum+' questionType="3" data-toggle="collapse" data-target="#coll_'+questionNum+'" aria-expanded="true" aria-controls="collapseExample">'+
'								<tr>'+
'									<th class="col-md-1 text-right" style="border: none;">'+
'										<span class="titleNum">'+questionNum+'、</span>'+
'									</th>'+
'									<th class="col-md-11">'+
'										<span class="title">点击编辑下拉框</span>'+
'										<select>'+
'										<!-- <option>请选择</option>'+
'										<option>湖北省</option>'+
'										<option>江西省</option> -->'+
'									</select>'+
'									</th>'+
'								</tr>'+
'							</tbody>'+
'							<tbody>'+
'								<tr>'+
'									<td colspan="2">'+
'									   <div class="collapse in" id="coll_'+questionNum+'" aria-expanded="true" style>'+
'									      <div class="well">'+
'									        '+
'									        	<div class="container" style="width: 100%">'+
'									        		<div class="row">	'+
'									        		<div class="row">'+
'									        			<div class="col-md-12 text-center">'+
'									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>'+
'									        			</div>	'+
'									        		</div>'+
'									        		<div class="row">'+
'									        			<div class="col-md-4">'+
'									        				选项文本'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				操作'+
'									        			</div>'+
'									        			'+
'										        		</div>'+
'										        		'+
'									        		<div class="row option_crudBtn" style="margin-top: 10px">'+
'									        			<div class="col-md-4">'+
'									        				<!-- <input type="text"> -->'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				<button val="create" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>'+
'									        					新增选项'+
'									        				</button>'+
'									        				<button val="remove" removeType="question" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>'+
'									        					删除本题	'+
'									        				</button>'+
'									        				'+
'									        			</div>'+
'									        			'+
'									        		</div>'+
'									        	</div>'+
'									      </div>'+
'										</div>'+
'									</td>'+
'								</tr>'+
'							</tbody>'
					);
				
				//整页题目序号重置
				sortQuestion();
					
				});
				
				
				/*
					填空被点击时，我们添加一个填空的模板
				*/
				$("#fillBtn").on("click",function(){
					
					
					$("#surveyBody table").append(
						' <tbody questionNum='+questionNum+' questionType="2" data-toggle="collapse" data-target="#coll_'+questionNum+'" aria-expanded="true" aria-controls="collapseExample">'+
'								<tr>'+
'									<th class="col-md-1 text-right" style="border: none;">'+
'										<span class="titleNum">'+questionNum+'、</span>'+
'									</th>'+
'									<th class="col-md-11">'+
'										<span class="title">填空题问题</span>'+
'									</th>'+
'								</tr>'+
'								<tr>'+
'									<td></td>'+
'									<td>'+
'										<input type="text" style="border: none;border-bottom: 1px solid;">'+
'									</td>'+
'								</tr>'+
'							</tbody>'+
'							'+
'							<tbody>'+
'								<tr>'+
'									<td colspan="2">'+
'									    '+
'									    <div class="collapse in" id="coll_'+questionNum+'" aria-expanded="true" style>'+
'									      <div class="well">'+
'									        '+
'									        	<div class="container" style="width: 100%">'+
'									        		<div class="row">	'+
'									        		<div class="row">'+
'									        			<div class="col-md-12 text-center">'+
'									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>'+
'									        			</div>	'+
'									        		</div>'+
'									        		<div class="row">'+
'									        			<div class="col-md-4">'+
'									        				'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				操作'+
'									        			</div>'+
'									        			'+
'										        		</div>'+
'										        		'+
'									        		<div class="row option_crudBtn" style="margin-top: 10px">'+
'									        			<div class="col-md-4">'+
'									        				<!-- <input type="text"> -->'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				<button val="remove" removeType="question" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>'+
'									        					删除本题	'+
'									        				</button>'+
'									        				'+
'									        			</div>'+
'									        			'+
'									        		</div>'+
'									        	</div>'+
'									      </div>'+
'										</div>'+
'									</td>'+
'								</tr>'+
'							</tbody>'
					);

				//整页题目序号重置
				sortQuestion();
					
				});
				
				/*
					评分条（程度条）被点击时
				*/
				$("#sorceBarBtn").on("click",function(){
					
					//1、判断其用户权限，是否可以使用此功能
					var userLevel = ${sessionScope.user.userLevel}+"";
					if(userLevel<1){//如果用户权限不足则弹出充值页面
					
						if(confirm("花1块钱即可体验VIP功能，评分条，是否充值体验？"))
					    {//如果是true ，那么就把页面转向支付页面
					     	
					     	//在转向支付页面之前，我们自动保存当前的问卷信息，并且不跳转页面
					     	var jsonSurvey =  submitSurvey();
					
							//4、将拼接好的json发送给后台解析保存
							$.ajax({
								url:"${pageContext.request.contextPath}/survey/saveOrUpdateSQO",
								type:"POST",
								contentType:'application/json;charset=utf-8',
								data:jsonSurvey,
								success:function(result){
									console.log(result);
									
						    		
								}
							});
					     	
					     	//弹出支付页面   
					        var w = window.open ("${pageContext.request.contextPath}/utils/pay.jsp") ;
							
					    }
					    else
					    {
					        //alert("你按了取消，那就是返回false");
					    }
						
						
						return false;
					}
				
				
					//2、将评分条控件添加到页面中
					$("#surveyBody table").append(
						' <tbody questionNum='+questionNum+' questionType="4" data-toggle="collapse" data-target="#coll_'+questionNum+'" aria-expanded="true" aria-controls="collapseExample">'+
'								<tr>'+
'									<th class="col-md-1 text-right" style="border: none;">'+
'										<span class="titleNum">'+questionNum+'、</span>'+
'									</th>'+
'									<th class="col-md-11">'+
'										<span class="title">给你妈妈做的辣椒打个分</span>'+
'										<span class="source" style="color: red;"></span>'+
'									</th>'+
'								</tr>'+
'								<tr>'+
'									<td></td>'+
'									<td>'+
'										<div id="p" class="progress myProgress" style="width: 50%;z-index: 1;">'+
'										  <button style="position: absolute;height:50px;margin-top:-14px;" class="btn btn-default" type="button"></button>'+
'										  <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 0%">'+
'										    <span class="sr-only">40% Complete (success)</span>'+
'										    '+
'										  </div>'+
'										  '+
'										</div>'+
'									</td>'+
'								</tr>'+
'							</tbody>'+
'							'+
'							<tbody>'+
'								<tr>'+
'									<td colspan="2">'+
'									    '+
'									    <div class="collapse in" id="coll_'+questionNum+'" aria-expanded="true" style>'+
'									      <div class="well">'+
'									        '+
'									        	<div class="container" style="width: 100%">'+
'									        		<div class="row">	'+
'									        		<div class="row">'+
'									        			<div class="col-md-12 text-center">'+
'									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>'+
'									        			</div>	'+
'									        		</div>'+
'									        		<div class="row">'+
'									        			<div class="col-md-4">'+
'									        				'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				操作'+
'									        			</div>'+
'									        			'+
'										        		</div>'+
'										        		'+
'									        		<div class="row option_crudBtn" style="margin-top: 10px">'+
'									        			<div class="col-md-4">'+
'									        				<!-- <input type="text"> -->'+
'									        			</div>	'+
'									        			<div class="col-md-8 text-right">'+
'									        				<button val="remove" removeType="question" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>'+
'									        					删除本题	'+
'									        				</button>'+
'									        				'+
'									        			</div>'+
'									        			'+
'									        		</div>'+
'									        	</div>'+
'									      </div>'+
'										</div>'+
'									</td>'+
'								</tr>'+
'							</tbody>'
					);
					
					
					
					
				//整页题目序号重置
				sortQuestion();
					
				});
				
				//整页题目序号重置
				function sortQuestion(){
					
					questionNum = 1;
					
					//获取所有题目的tbody
					var questionTbodys = $("table tbody[questionNum]");
					
					$.each(questionTbodys,function(index,item){
					
						index = index+1;
						
						$(item).attr("questionNum",index);
						$(item).attr("data-target","#coll_"+index);
						$(item).find("span[class='titleNum']").text(index+"、");
						$(item).next().find("div[aria-expanded]").attr("id","coll_"+index);
					});
				}
				
				//Collapse中  的crud按钮被点击的时候(增加，删除，上移，下移)
				$(document).on("click",".option_crudBtn button",function(){
					//1、取得显示的tbody元素
					var tbody = $(this).parents("tbody").prev();
					
					//2、取得当前元素的祖先元素class为row option_crudBtn的div
				 	var nowThis = $(this).parent().parent();
					
					//3、判断题目的类型，不同题目类型的crud是不太一样的
					var qType = $(tbody).attr("questionType");
					
					//4、取得按钮的操作类型
					var btnVal = $(this).attr("val");
					
					//5、取得当前点击按钮的题目顺序
					var optionSort = $(nowThis).attr("optionSort");
					
					//调用不同按钮的操作方法
					if(btnVal=="create"){
						addOption(nowThis,tbody,qType,optionSort);
					}else if(btnVal=="remove"){
						
						//获取删除按钮的类型是题目，还是选项
						var removeType= $(this).attr("removeType"); 
					
						if(removeType=="question"){//删除本题
							
							//1、先删除选项tbody，再删除控制条tbody
							$(nowThis).parents("tbody").prev().remove();
							$(nowThis).parents("tbody").remove();
							
							//2、维护题目的顺序关系
							//整页题目序号重置
							sortQuestion();
							
							
						}else if(removeType=="option"){//删除选项
							deleteOption(nowThis,tbody,qType,optionSort);
						}
						
					}else if(btnVal=="up"){
						
						//选项中支持上移下移的只有单选，多选和下拉框
						//单选和多选可以写在一起，下拉框需要单独写
						if(qType==0 || qType==1){//单选&复选
						
							//如果up的题目顺序本身就为1，则不予理会
							if(optionSort==1){
								return false;
							}
							
							//i、交换控制条的值
							var change1 = $(nowThis).find("input[type='text']");
							var change2 = $(nowThis).prev().find("input[type='text']");
							
							//alert(change1+"--"+change2);
							
							var c3 = $(change1).val();
							$(change1).val($(change2).val());
							$(change2).val(c3);
							
							//ii、交换tbody中的内容
							var prev = parseInt(optionSort)-1;
							
							var tbodyInput = $(tbody).find("tr[optionSort='"+optionSort+"']").find("span");
							var tbodyPrevInput = $(tbody).find("tr[optionSort='"+prev+"']").find("span");
							
							var c4 = $(tbodyInput).text();
							$(tbodyInput).text($(tbodyPrevInput).text());
							$(tbodyPrevInput).text(c4);
							
							//iii、更新radio或者checkbox的value值
							$(tbodyInput).prev().val($(tbodyInput).text());
							$(tbodyPrevInput).prev().val($(tbodyPrevInput).text());
						
						}else if(qType==3){//下拉框option的上移
							
							//如果up的题目顺序本身就为1，则不予理会
							if(optionSort==1){
								return false;
							}
							
							//i、交换控制条的值
							var change1 = $(nowThis).find("input[type='text']");
							var change2 = $(nowThis).prev().find("input[type='text']");
							
							//alert(change1+"--"+change2);
							
							var c3 = $(change1).val();
							$(change1).val($(change2).val());
							$(change2).val(c3);
							
							//ii、交换tbody中的内容
							var prev = parseInt(optionSort)-1;
							
							var tbodyInput = $(tbody).find("option[optionSort='"+optionSort+"']");
							var tbodyPrevInput = $(tbody).find("option[optionSort='"+prev+"']");
							
							var c4 = $(tbodyInput).text();
							$(tbodyInput).text($(tbodyPrevInput).text());
							$(tbodyPrevInput).text(c4);
							
							//iii、更新option的value值
							$(tbodyInput).val($(tbodyInput).text());
							$(tbodyPrevInput).val($(tbodyPrevInput).text());
						
							
						}
						
						
						//alert("up");
					}else if(btnVal=="down"){
						
						//选项中支持上移下移的只有单选，多选和下拉框
						//单选和多选可以写在一起，下拉框需要单独写
						if(qType==0 || qType==1){//单选&复选
							
							//取得当前元素上class为row option_crudBtn的div的下一个div
							//如果下一个div的optionSort不为undefined则可以与下一个交换选项值
							var next = $(nowThis).next().attr("optionSort");
							
							if(next==undefined){
								return false;
							}
							
							//i、交换控制条的值
							var change1 = $(nowThis).find("input[type='text']");
							var change2 = $(nowThis).next().find("input[type='text']");
							
							//alert(change1+"--"+change2);
							
							var c3 = $(change1).val();
							$(change1).val($(change2).val());
							$(change2).val(c3);
							
							//ii、交换tbody中的内容
							var next2 = parseInt(optionSort)+1;
							
							var tbodyInput = $(tbody).find("tr[optionSort='"+optionSort+"']").find("span");
							var tbodyNextInput = $(tbody).find("tr[optionSort='"+next2+"']").find("span");
							
							var c4 = $(tbodyInput).text();
							$(tbodyInput).text($(tbodyNextInput).text());
							$(tbodyNextInput).text(c4);
							
							//iii、更新radio或者checkbox的value值
							$(tbodyInput).prev().val($(tbodyInput).text());
							$(tbodyNextInput).prev().val($(tbodyNextInput).text());
						
							
						}else if(qType==3){//下拉框option的下移
							//取得当前节点的下一个节点
							//如果下一个元素的optionSort不为undefined则可以与下一个交换选项值
							var next = $(nowThis).next().attr("optionSort");
							
							if(next==undefined){
								return false;
							}
							
							//i、交换控制条的值
							var change1 = $(nowThis).find("input[type='text']");
							var change2 = $(nowThis).next().find("input[type='text']");
							
							//alert(change1+"--"+change2);
							
							var c3 = $(change1).val();
							$(change1).val($(change2).val());
							$(change2).val(c3);
							
							//ii、交换tbody中的内容
							var next2 = parseInt(optionSort)+1;
							
							var tbodyInput = $(tbody).find("option[optionSort='"+optionSort+"']");
							var tbodyNextInput = $(tbody).find("option[optionSort='"+next2+"']");
							
							var c4 = $(tbodyInput).text();
							$(tbodyInput).text($(tbodyNextInput).text());
							$(tbodyNextInput).text(c4);
							
							//iii、更新radio或者checkbox的value值
							$(tbodyInput).val($(tbodyInput).text());
							$(tbodyNextInput).val($(tbodyNextInput).text());
						
						}
						
						
						//alert("down");
					}
				});
				
				function deleteOption(nowThis,tbody,qType,optionSort){
				
					if(qType==0 || qType==1){//单选&复选
						
						//1、删除控制条
						var nowThis2 = $(nowThis).prev();//先保存一个节点用于等下排序
						$(nowThis).remove();
						
						//2、删除显示的选项
						//我们从tbody找到对应顺序的删除节点，再删除
						var i =$(tbody).find("tr[optionSort='"+optionSort+"']");
						$(i).remove();
						
						//重置控制条和选项显示顺序
						resetSort(nowThis2,tbody);
						
					}else if(qType==2){//填空
						
					}else if(qType==3){//下拉框
						
						//1、删除控制条
						var nowThis2 = $(nowThis).prev();//先保存一个节点用于等下排序
						$(nowThis).remove();
						
						//2、删除显示的选项
						//我们从tbody找到对应顺序的删除节点，再删除
						var i =$(tbody).find("option[optionSort='"+optionSort+"']");
						$(i).remove();
						
						//重置控制条和选项显示顺序
						resetSort(nowThis2,tbody);
						
					}else if(qType==4){//评分条
						
					}
				
					
				}
				
				//1）、nowThis当前操作的包含控制按钮的thbody
				//2）、tbody显示题目和选项的tbody
				//3）、qType题目类型
				//4）、optionSort当前点击按钮的题目顺序
				function addOption(nowThis,tbody,qType,optionSort){
					
					/*
						选项添加顺序
					*/
					//单选框和复选框都是有其顺序的，
					if(optionSort==undefined){//如果没有选项，或者点击的按钮是删除本题旁边的新增按钮，我们把optionSort值设置为1
						optionSort = 1 ;
					}else{//如果之前有选项则取选项最大值+1作为下一个选项的optionSort值
						optionSort = parseInt(optionSort)+1 ;
					}
					
					
					if(qType==0 || qType==1){//单选&复选，单选和复选唯一的不同是radio变为了checkbox
						
						var span = $("<span>待填选项</span>");
						var inputROrC;
						var label;
						
						var questionnum2 = $(tbody).attr("questionnum");
						
						if(qType==0){
							inputROrC = $('<input type="radio" name="r'+questionnum2+'"  value=""> ');
							
							label = $(
								'<label class="radio-inline">'+
	'							 </label>'
							); 
							
						}else if(qType==1){
							inputROrC = $('<input type="checkbox" name="c'+questionnum2+'" value=""> ');
							label = $(
								'<label class="checkbox-inline">'+
	'							 </label>'
							); 
						}
						
						//2.1给选项文本添加键盘抬起事件，每当键盘抬起时改变tbody中选项文本内容
						var input = $("<input type='text'>");
						
						//2、2中需要添加文本框的改变事件，
						//每当键盘抬起的时候同步更新选项文本
						$(input).on("keyup",function(){
							$(span).text($(this).val());//改变显示文本的值
							$(span).prev().attr("value",$(this).val());//改变input的value的值
						});
						
						//1、给tbody，添加显示选项
						
						var tr = $(
							'<tr optionSort="'+optionSort+'">'+'</tr>'
						);
						
						var td1 = $('<td></td>');
						
						$(label)
						.append(inputROrC)
						.append(span);
						
						var td2 = $('<td>'+
'										'+
'									</td>').append(label);
						
						var oShow = $(tr).append(td1).append(td2);
						
						//我们从tbody找到对应顺序的插入点
						var insert = optionSort-1;
						var i =$(tbody).find("tr[optionSort='"+insert+"']");
						
						if($(i).attr("optionSort")==undefined){//当前插入点若没有,表示为第一个选项直接添加到tbody中
							$(tbody).append(
								oShow
							); 
						}else{//若存在插入点，那么我们就将新的选项放在插入点后面
							$(i).after(
								oShow
							); 
						}
						
						//2、在本身row下一行添加控制选项
						var row=$(//行
							'<div class="row option_crudBtn"  style="margin-top: 10px" optionSort="'+optionSort+'">'+'</div>'
						);
						
						var di=$(//控制input框
						   '<div class="col-md-4">'+
'							</div>	'
						).append(input);
						
						var button = $(//控制按钮
							'<div class="col-md-8 text-right">'+
'									        				<button val="create" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>'+
'									        				</button>'+
'									        				<button val="remove" removeType="option" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>	'+
'									        				</button>'+
'									        				<button val="up" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span>'+
'									        				</button>'+
'									        				<button val="down" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span>	'+
'									        				</button>'+
'									        				'+
'									        			</div>'
						);
						
						var result = $(row).append(di).append(button);
						
						
						if(optionSort==1){
							$(nowThis).parent().append(//如果没有选项，或者点击的按钮是删除本题旁边的新增按钮，我们把选项添加到末尾
								result
							);
						}else{
							$(nowThis).after(
								result
							);
						}
						
						
					//添加选项完成后，重新计算选项顺序 ，nowThis,tbody
					resetSort(nowThis,tbody);
					
						
					
					}else if(qType==2){//填空
						
					}else if(qType==3){//下拉框
						
						var option = $("<option optionSort="+optionSort+">待填选项</option>");

						
						//2.1给选项文本添加键盘抬起事件，每当键盘抬起时改变tbody中选项文本内容
						var input = $("<input type='text'>");
						
						//2、2中需要添加文本框的改变事件，
						//每当键盘抬起的时候同步更新选项文本
						$(input).on("keyup",function(){
							$(option).text($(this).val());//改变显示文本的值
							$(option).attr("value",$(this).val());//改变input的value的值
						});
						
						//1、给tbody，添加显示选项
						
						//我们从tbody找到对应顺序的插入点
						var insert = optionSort-1;
						var select =$(tbody).find("select");
						
						var op = $(select).find("option[optionSort='"+insert+"']");
						
						if($(op).attr("optionSort")==undefined){//当前插入点若没有,表示为第一个选项直接添加到tbody中
							$(select).append(
								option
							); 
						}else{//若存在插入点，那么我们就将新的选项放在插入点后面
							$(op).after(
								option
							); 
						}
						
						//2、在本身row下一行添加控制选项
						var row=$(//行
							'<div class="row option_crudBtn"  style="margin-top: 10px" optionSort="'+optionSort+'">'+'</div>'
						);
						
						var di=$(//控制input框
						   '<div class="col-md-4">'+
'							</div>	'
						).append(input);
						
						var button = $(//控制按钮
							'<div class="col-md-8 text-right">'+
'									        				<button val="create" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>'+
'									        				</button>'+
'									        				<button val="remove" removeType="option" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>	'+
'									        				</button>'+
'									        				<button val="up" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span>'+
'									        				</button>'+
'									        				<button val="down" class="btn btn-default">'+
'									        					<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span>	'+
'									        				</button>'+
'									        				'+
'									        			</div>'
						);
						
						var result = $(row).append(di).append(button);
						
						
						if(optionSort==1){
							$(nowThis).parent().append(//如果没有选项，或者点击的按钮是删除本题旁边的新增按钮，我们把选项添加到末尾
								result
							);
						}else{
							$(nowThis).after(
								result
							);
						}
						
						
					//添加选项完成后，重新计算选项顺序 ，nowThis,tbody
					resetSort(nowThis,tbody);
					
						
					}else if(qType==4){//评分条
						
					}
					
				}
				
				/*
					重置题目选项和控制条的顺序
				*/
				function resetSort(nowThis,tbody){
					//i、重新计算nowThis的选项顺序
					//parent对应的是<div class="row">
					var nowSort= $(nowThis).parent().find("[optionsort]");
					$.each(nowSort,function(index,item){
						//alert($(item).attr("optionsort"));
						$(item).attr("optionsort",index+1);
					});
					
					//ii、重新计算tbody的选项顺序
					var tbodySort= $(tbody).find("[optionsort]");
					$.each(tbodySort,function(index,item){
						//alert($(item).attr("optionsort"));
						$(item).attr("optionsort",index+1);
					});
					
				}
				
				/*
					题目输入框键盘抬起改变题目事件
				*/
				$(document).on("keyup",".title",function(){
					
					//获取要改变文本的节点
					var span =$(this).parents("tbody").prev().find("span[class='title']");
					$(span).text($(this).val());
				});
				
				//防止点击下拉框的时候控制栏一直展开收起，故返回return false;
				$(document).on("click","select",function(){
					return false;
				});
				
				/*
					当我们点击保存问卷时
				*/
				$("#submitSurvey").on("click",function(){
					
					var jsonSurvey =  submitSurvey();
					
					//4、将拼接好的json发送给后台解析保存
					$.ajax({
						url:"${pageContext.request.contextPath}/survey/saveOrUpdateSQO",
						type:"POST",
						contentType:'application/json;charset=utf-8',
						data:jsonSurvey,
						success:function(result){
							console.log(result);
							
							//弹出模态框，提示保存成功，三秒钟之后跳转到问卷管理页面
							$('#saveSuccessModal').modal({
				    			backdrop:"static" //点击背景不删除模态框，不指定的话点击背景模态框就会删除
				    		});
				    		
				    		var second = 3;
				    		$('#saveSuccessModal span[class="second"]').text(second);
				    		//计时跳转
				    		var time = setInterval(function() {
				    			$('#saveSuccessModal span[class="second"]').text(second);
				    			
				    			if(second==0){//等于0就跳转
				    				window.location="${pageContext.request.contextPath }/survey/suevryHome.jsp";
				    			}else{
				    				second--;
				    			}
				    			
				    			
				    		}, 1000);
				    		
						}
					});
					
					
					
				});
				
				function submitSurvey(){
					/*
						1、遍历所有的题目tbody
						用json拼接好题目信息
					*/
					var tbodys = $("tbody[questionnum]");
					//alert(tbodys.length);
					
					var jsonQuestion = "[";
					
					$.each(tbodys,function(index,item){
						
						//alert($(item).attr("questionType"));
						var questionType = $(item).attr("questionType");
					
						//2、判断题目的类型，不同题目类型的json拼接不同，验证也不同	
						//虽然下面大部分代码一样，但是为了以后的拓展保留这种写法
						if(questionType==0){//单选
							jsonQuestion = jsonQuestion + jsonRadio(item);
						}else if(questionType==1){//多选
							jsonQuestion = jsonQuestion + jsonRadio(item);
						}else if(questionType==2){//填空
							jsonQuestion = jsonQuestion + jsonRadio(item);
						}else if(questionType==3){//下拉框
							jsonQuestion = jsonQuestion + jsonSelect(item);
						}else if(questionType==4){//评分条
							jsonQuestion = jsonQuestion + jsonRadio(item);
						}
						
					});
					
					if(tbodys.length!=0){//如果题目数量不等于0
						//将最后一个逗号，截取去掉
						jsonQuestion = jsonQuestion.substr(0, jsonQuestion.length-1);
					}
					
					jsonQuestion = jsonQuestion+"]";
					
					
					/*
						3、json拼接好问卷基本信息
						
						问卷ID surveyId
						问卷名称 surveyName
						问卷说明 surveyExplain
						发起人ID userId
						问卷状态 surveyStatus
						问卷是否需要随机排列 israndom
						问卷题目数量 questionNums
						
						题目list
					*/
					//最终保存的问卷json部分
	                var jsonSurvey = '{'+
	                    '"surveyId":'+$("#surveyId").val()+
	                    ',"surveyName":"'+$("h1 input").val()+
	                    '","surveyExplain":"'+$("#surveyExplain").val()+
	                    '","userId":'+'${sessionScope.user.userId}'+
	                    ',"surveyStatus":'+0+
	                    ',"israndom":'+$("#isRandom").val()+
	                    ',"questionNums":'+tbodys.length+
	                    ',"questionList":'+jsonQuestion+
	                '}';
					
					console.log(jsonSurvey);
					
					return jsonSurvey;
				}
				
				//单选字符串拼接
				function jsonRadio(item){
					
					/*
						1、拼接选项数组信息
					
						选项需要的值题目ID questionId，(题目也还没有添加，在后台添加了题目之后再补充此字段)
						选项标题，（当前版本用不到，暂不考虑）
						选项内容 optionContent，
						选项排序码 optionSort
					*/
					var jsonOption = "[";
					
					$.each($(item).find("tr[optionsort]"),function(index,opt){
						
						var o = '{'+
				                    '"optionContent":"'+$(opt).find("span").text()+
				                    '","optionSort":"'+$(opt).attr("optionsort")+
				                '"},';
						
						jsonOption = jsonOption + o;
					});
					
					if($(item).find("tr[optionsort]").length!=0){//如果选项个数不等于0
						//将jsonOption最后一个逗号，截取掉
						jsonOption = jsonOption.substr(0, jsonOption.length-1);
					
					}
					
					
					jsonOption = jsonOption +"]";
					
					
					/*
						2、拼接题目基本信息
						 
						问卷id，（由最外层问卷json保存）
						题目类型 questionType
						题目标题 questionTitle
						题目说明 (考试部分填写)
						题目排序码 questionSort
						题目是否需要随机排列 israndom
						
						选项list  
					*/
					/* var q = '{'+
			                    '"questionType":"'+$(item).attr("questionType")+
			                    '","questionTitle":"'+$(item).find("span[class='title']").text()+
			                    '","questionSort":"'+$(item).attr("questionnum")+
			                    '","optionList":'+jsonOption+
			                '},'; */
			        var q = '{'+
			                    '"questionType":'+$(item).attr("questionType")+
			                    ',"questionTitle":"'+$(item).find("span[class='title']").text()+
			                    '","questionSort":'+$(item).attr("questionnum")+
			                    ',"optionList":'+jsonOption+
			                '},';
					
					//console.log(q);
					
					return q;
				}
				
				
				//下拉框字符串拼接
				function jsonSelect(item){
					
					/*
						1、拼接选项数组信息
					
						选项需要的值题目ID questionId，(题目也还没有添加，在后台添加了题目之后再补充此字段)
						选项标题，（当前版本用不到，暂不考虑）
						选项内容 optionContent，
						选项排序码 optionSort
					*/
					var jsonOption = "[";
					
					$.each($(item).find("option[optionsort]"),function(index,opt){
						
						var o = '{'+
				                    '"optionContent":"'+$(opt).text()+
				                    '","optionSort":"'+$(opt).attr("optionsort")+
				                '"},';
						
						jsonOption = jsonOption + o;
					});
					
					if($(item).find("option[optionsort]").length!=0){//如果选项个数不等于0
						//将jsonOption最后一个逗号，截取掉
						jsonOption = jsonOption.substr(0, jsonOption.length-1);
					
					}
					
					
					jsonOption = jsonOption +"]";
					
					
					/*
						2、拼接题目基本信息
						 
						问卷id，（由最外层问卷json保存）
						题目类型 questionType
						题目标题 questionTitle
						题目说明 (考试部分填写)
						题目排序码 questionSort
						题目是否需要随机排列 israndom
						
						选项list  
					*/
					var q = '{'+
			                    '"questionType":"'+$(item).attr("questionType")+
			                    '","questionTitle":"'+$(item).find("span[class='title']").text()+
			                    '","questionSort":"'+$(item).attr("questionnum")+
			                    '","optionList":'+jsonOption+
			                '},';
					
					//console.log(q);
					
					return q;
				}
				
				
			});
	</script>
  </head>
  
  <body>
    <!-- 导航条 -->
	<div id="m" style="background-color: #222;position: fixed; top: 0px; width: 100%; z-index:9999">
		
	</div>
	
	<!-- 问卷ID-->	
	<input type="hidden" id="surveyId" name="surveyId" value="${param.surveyId }">
	
	<!-- 选项类型选择 -->
	<div class="btnGroup" style="position: fixed; margin: auto; top:60px; left: 0px;right: 0px;z-index:9997;width: 100%;background-color:rgba(255,255,255,0.8);height: 50px">
		
	</div>
	<div style="position: fixed; margin: auto; top:60px; left: 0px;right: 0px;z-index:9998;width: 100%;">
		<div class="col-md-4">
			当前出题顺序：
			<button id="isRandom" value="0" type="button" class="btn btn-default" disabled="disabled">顺序</button>
			&nbsp
			题目编辑状态:
			<button id="isEdit" value="0" type="button" class="btn btn-default">全部展开</button>
		</div>
		<div style="height: 100%" class="btn-group btn-group-lg col-md-4" role="group" aria-label="Large button group">
		<center>
			<div style="height: 100%" class="btn-group btn-group-lg" role="group" aria-label="Large button group">
		      <button id="radioOne" type="button" class="btn btn-default">单选</button>
		      <button id="checkboxMany" type="button" class="btn btn-default">多选</button>
		      <button id="fillBtn" type="button" class="btn btn-default">填空</button>
		      <button id="selectBtn" type="button" class="btn btn-default">下拉框</button>
		      <button id="sorceBarBtn" type="button" class="btn btn-warning dropdown-toggle">程度条</button>
		      <button id="submitSurvey" type="button" class="btn btn-info">保存问卷</button>
		      
		      
				<div id="saveSuccessModal" class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
				  <div class="modal-dialog modal-sm" role="document">
				    <div class="modal-content" style="margin-top: 50%;">
				    	<button type="button" class="btn btn-success btn-lg">
				    		<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>
				      		保存成功(<span class="second"></span>)
				    	</button>
				    </div>
				  </div>
				</div>
		      
		      </div>
	    </center>
	    </div>
	</div>
	
	<!-- 编辑问卷页面 -->
	<div class="container" style=" margin-top: 5%; width: 100%;text-align: center;">
		
		<div class="col-md-6 col-md-offset-3">
		
			<div class="row" >
					<center>
						<div class="page-header">
						  <h1>
						  	<input type="text" value="年轻人每天的运动情况" style="text-align:center;border: none;">
						  	<small>问卷调查</small>
						  </h1>
						</div>
						
						<div class="panel panel-default text-left">
						  <div class="panel-heading">问卷说明</div>
						    <textarea id="surveyExplain" rows="3" style="width: 100%;"></textarea>
						</div>
						
					</center>
			</div> 
			
			<div class="row text-left" id="surveyBody">
						<table style="font-size: 16px;" class="table">
							<!-- <tbody questionType="0" data-toggle="collapse" data-target="#coll_1" aria-expanded="true" aria-controls="collapseExample">
								<tr>
									<th class="col-md-1 text-right" style="border: none;">
										<span class="titleNum">1、</span>
									</th>
									<th class="col-md-11">
										<span class="title">点击编辑问题</span>
									</th>
								</tr>
								
							</tbody>
							<tbody>
								<tr>
									<td colspan="2">
									    <div class="collapse" id="coll_1" aria-expanded="false" style="height: 0px;">
									      <div class="well">
									        
									        	<div class="container" style="width: 100%">
									        		<div class="row">	
									        		<div class="row">
									        			<div class="col-md-12 text-center">
									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>
									        			</div>	
									        		</div>
									        		<div class="row">
									        			<div class="col-md-4">
									        				选项文本
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				操作
									        			</div>
									        			
										        		</div>
										        		
									        		<div class="row option_crudBtn" style="margin-top: 10px">
									        			<div class="col-md-4">
									        				<input type="text">
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				<button val="create" class="btn btn-default">
									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
									        					新增选项
									        				</button>
									        				<button val="remove" removeType="question" class="btn btn-default">
									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>
									        					删除本题	
									        				</button>
									        				
									        			</div>
									        			
									        		</div>
									        	</div>

									      </div>
										</div>
									</td>
								</tr>
							</tbody>
							
							<tbody questionType="1" data-toggle="collapse" data-target="#coll_2" aria-expanded="true" aria-controls="collapseExample">
								<tr>
									<th class="col-md-1 text-right" style="border: none;">
										<span class="titleNum">2、</span>
									</th>
									<th class="col-md-11">
										<span class="title">点击编辑问题</span>
									</th>
								</tr>
							</tbody>
							
							<tbody>
								<tr>
									<td colspan="2">
									    
									    <div class="collapse" id="coll_2" aria-expanded="false" style="height: 0px;">
									      <div class="well">
									        
									        	<div class="container" style="width: 100%">
									        		<div class="row">	
									        		<div class="row">
									        			<div class="col-md-12 text-center">
									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>
									        			</div>	
									        		</div>
									        		<div class="row">
									        			<div class="col-md-4">
									        				选项文本
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				操作
									        			</div>
									        			
										        		</div>
										        		
									        		<div class="row option_crudBtn" style="margin-top: 10px">
									        			<div class="col-md-4">
									        				<input type="text">
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				<button val="create" class="btn btn-default">
									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
									        					新增选项
									        				</button>
									        				<button val="remove" removeType="question" class="btn btn-default">
									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>
									        					删除本题	
									        				</button>
									        				
									        			</div>
									        			
									        		</div>
									        	</div>

									      </div>
										</div>
									</td>
								</tr>
							</tbody>
						   <tbody questionType="3" data-toggle="collapse" data-target="#coll_3" aria-expanded="true" aria-controls="collapseExample">
								<tr>
									<th class="col-md-1 text-right" style="border: none;">
										<span class="titleNum">3、</span>
									</th>
									<th class="col-md-11">
										<span class="title">你所在的省份</span>
										<select>
										<option>请选择</option>
										<option>湖北省</option>
										<option>江西省</option>
									</select>
									</th>
								</tr>
							</tbody>
							<tbody>
								<tr>
									<td colspan="2">
									    <div class="collapse" id="coll_3" aria-expanded="false" style="height: 0px;">
									      <div class="well">
									        
									        	<div class="container" style="width: 100%">
									        		<div class="row">	
									        		<div class="row">
									        			<div class="col-md-12 text-center">
									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>
									        			</div>	
									        		</div>
									        		<div class="row">
									        			<div class="col-md-4">
									        				选项文本
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				操作
									        			</div>
									        			
										        		</div>
										        		
									        		<div class="row option_crudBtn" style="margin-top: 10px">
									        			<div class="col-md-4">
									        				<input type="text">
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				<button val="create" class="btn btn-default">
									        					<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
									        					新增选项
									        				</button>
									        				<button val="remove" removeType="question" class="btn btn-default">
									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>
									        					删除本题	
									        				</button>
									        				
									        			</div>
									        			
									        		</div>
									        	</div>

									      </div>
										</div>
									</td>
								</tr>
							</tbody>
							
							<tbody questionType="2" data-toggle="collapse" data-target="#coll_4" aria-expanded="true" aria-controls="collapseExample">
								<tr>
									<th class="col-md-1 text-right" style="border: none;">
										<span class="titleNum">4、</span>
									</th>
									<th class="col-md-11">
										<span class="title">你最喜欢的一道菜</span>
									</th>
								</tr>
								<tr>
									<td></td>
									<td>
										<input type="text" style="border: none;border-bottom: 1px solid;">
									</td>
								</tr>
							</tbody>
							
							<tbody>
								<tr>
									<td colspan="2">
									    
									    <div class="collapse" id="coll_4" aria-expanded="false" style="height: 0px;">
									      <div class="well">
									        
									        	<div class="container" style="width: 100%">
									        		<div class="row">	
									        		<div class="row">
									        			<div class="col-md-12 text-center">
									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>
									        			</div>	
									        		</div>
									        		<div class="row">
									        			<div class="col-md-4">
									        				
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				操作
									        			</div>
									        			
										        		</div>
										        		
									        		<div class="row option_crudBtn" style="margin-top: 10px">
									        			<div class="col-md-4">
									        				<input type="text">
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				<button val="remove" removeType="question" class="btn btn-default">
									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>
									        					删除本题	
									        				</button>
									        				
									        			</div>
									        			
									        		</div>
									        	</div>

									      </div>
										</div>
									</td>
								</tr>
							</tbody>
							
							<tbody questionType="4" data-toggle="collapse" data-target="#coll_5" aria-expanded="true" aria-controls="collapseExample">
								<tr>
									<th class="col-md-1 text-right" style="border: none;">
										<span class="titleNum">5、</span>
									</th>
									<th class="col-md-11">
										<span class="title">给你妈妈做的辣椒打个分</span>
										<span class="source" style="color: red;"></span>
									</th>
								</tr>
								<tr>
									<td></td>
									<td>
										<div id="p" class="progress myProgress" style="width: 50%;z-index: 1;">
										  <button style="position: absolute;height:50px;margin-top:-14px;" class="btn btn-default" type="button"></button>
										  <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
										    <span class="sr-only">40% Complete (success)</span>
										    
										  </div>
										  
										</div>
									</td>
								</tr>
							</tbody>
							
							<tbody>
								<tr>
									<td colspan="2">
									    
									    <div class="collapse" id="coll_5" aria-expanded="false" style="height: 0px;">
									      <div class="well">
									        
									        	<div class="container" style="width: 100%">
									        		<div class="row">	
									        		<div class="row">
									        			<div class="col-md-12 text-center">
									        				题目：<textarea rows="3" class="col-md-12 title"></textarea>
									        			</div>	
									        		</div>
									        		<div class="row">
									        			<div class="col-md-4">
									        				
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				操作
									        			</div>
									        			
										        		</div>
										        		
									        		<div class="row option_crudBtn" style="margin-top: 10px">
									        			<div class="col-md-4">
									        				<input type="text">
									        			</div>	
									        			<div class="col-md-8 text-right">
									        				<button val="remove" removeType="question" class="btn btn-default">
									        					<span class="glyphicon glyphicon-minus-sign" aria-hidden="true"></span>
									        					删除本题	
									        				</button>
									        				
									        			</div>
									        			
									        		</div>
									        	</div>

									      </div>
										</div>
									</td>
								</tr> -->
							</tbody>
				    	
				    
				</table>
					
					
					
					
			</div>
			
		</div>
	</div>

  </body>
</html>
