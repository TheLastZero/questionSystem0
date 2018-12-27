<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'answerShow.jsp' starting page</title>
    
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
	
	<!-- 引入样式 -->
	<link href="${pageContext.request.contextPath}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
		rel="stylesheet">
	
	<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
	<script src="${pageContext.request.contextPath}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
	
	<script type="text/javascript"  charset="utf-8"
		    src="http://connect.qq.com/qc_jssdk.js" 
		    data-appid="101507637" 
		    data-redirecturi="http://questionnaire.zerozrz.com/qq/qq.jsp" >
	</script>
	
	<!-- 引入剪贴板的js -->
	<script src="${pageContext.request.contextPath}/static/js/clipboard.min.js"></script>
	
	<style type="text/css">	
	
		   /* div,table,td,p,h1,span,small{
				border: 1px solid red;
			}   */         
		  
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
		  
	</style>
	
	<script type="text/javascript">
			
			$(document).ready(function(){
				
				var answerId=0;
				
				//加载导航条
				$("#m").load("utils/nav.jsp");
				
				/*
					根据答卷id初始化本答卷基本信息
				*/
				$.ajax({
					url:"${pageContext.request.contextPath}/answer/getByQuestionId",
					type:"POST",
					data:"answerId="+$("#answerId").val()+""+
						"&surveyId="+$("#surveyId").val(),
					async: false,
					success:function(result){
						console.log(result);
						
						$("h3").empty().append(
			'				  	<br>'+
			'				  		开始时间：'+result.extend.answer.answerStart+'，'+
			'				  		提交时间：'+result.extend.answer.answerEnd+
			'				  	<br>'+
			'				  	总共用时:'+result.extend.answer.answerUsedtime+
			'				  	<br>'
						);
						
						//赋值新的answerid
						//$("#answerId").val(result.extend.answer.answerId);
						
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
						$("h1 span").text(result.extend.survey.surveyName);
						
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
						$("#surveyExplain").text(result.extend.survey.surveyExplain);
						
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
							
								//在table中追加1个tbody题目
								$("#surveyBody table").append(
									'<tbody questionNum='+(index+1)+' questionType="'+questionType+'" questionId='+question.questionId+'>'+
			'								<tr>'+
			'									<th class="col-md-1 text-right" style="border: none;">'+
			'										<span class="titleNum">'+(index+1)+'、</span>'+
			'									</th>'+
			'									<th class="col-md-11">'+
			'										<span class="title">点击编辑问题</span>'+'（单选题）'+
			'									</th>'+
			'								</tr>'+
			'								'+
			'							</tbody>'
								);
								
								
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);
								
								/*
									2、根据题目id，题目类型，和答卷id，查询答案
								*/
								
								 $.ajax({
									url:"${pageContext.request.contextPath}/answer/getUserAnswerByQidTypeIdAId",
									type:"POST",
									data:"questionId="+question.questionId+
										"&questionType="+questionType+
										"&answerId="+$("#answerId").val()+"",
									success:function(result2){
										console.log(result2);
										
										$(tbody).append(
												'<tr>'+
												'  <td>'+
												'  </td>'+
												'  <td>'+
												'    <label class="radio-inline">'+
												'      <span>'+result2.extend.context+'</span>'+
												'    </label>'+"<hr>"+
												'  </td>'+
												'</tr>'
											);
										
										
									}
								}); 
								
								
							}else if(questionType==1){//复选
								
								//在table中追加1个tbody题目
								$("#surveyBody table").append(
									'<tbody questionNum='+(index+1)+' questionType="'+questionType+'" questionId='+question.questionId+'>'+
			'								<tr>'+
			'									<th class="col-md-1 text-right" style="border: none;">'+
			'										<span class="titleNum">'+(index+1)+'、</span>'+
			'									</th>'+
			'									<th class="col-md-11">'+
			'										<span class="title">点击编辑问题</span>'+'（多选题）'+
			'									</th>'+
			'								</tr>'+
			'								'+
			'							</tbody>'
								);
								
								
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								
								//题目标题 questionTitle 把值换成数据库中查到的
								$(tbody).find("span[class='title']").text(question.questionTitle);
								
								
								/*
									2、根据题目id，题目类型，和答卷id，查询答案
								*/
								 $.ajax({
									url:"${pageContext.request.contextPath}/answer/getUserAnswerByQidTypeIdAId",
									type:"POST",
									data:"questionId="+question.questionId+
										"&questionType="+questionType+
										"&answerId="+$("#answerId").val()+"",
									success:function(result2){
										console.log(result2);
										
										$(tbody).append(
												'<tr>'+
												'  <td>'+
												'  </td>'+
												'  <td>'+
												'    <label class="radio-inline">'+
												'      <span>'+result2.extend.context+'</span>'+
												'    </label>'+"<hr>"+
												'  </td>'+
												'</tr>'
											);
										
										
									}
								}); 
								
							
							}else if(questionType==2){//填空
								//在table中追加1个tbody题目
								$("#surveyBody table").append(
									'<tbody questionNum='+(index+1)+' questionType="'+questionType+'" questionId='+question.questionId+'>'+
			'								<tr>'+
			'									<th class="col-md-1 text-right" style="border: none;">'+
			'										<span class="titleNum">'+(index+1)+'、</span>'+
			'									</th>'+
			'									<th class="col-md-11">'+
			'										<span class="title">点击编辑问题</span>'+'（填空题）'+
			'									</th>'+
			'								</tr>'+
			'							</tbody>'
								);
								
								/*
									2、根据题目id，题目类型，和答卷id，查询答案
								*/
								 $.ajax({
									url:"${pageContext.request.contextPath}/answer/getUserAnswerByQidTypeIdAId",
									type:"POST",
									data:"questionId="+question.questionId+
										"&questionType="+questionType+
										"&answerId="+$("#answerId").val()+"",
									success:function(result2){
										console.log(result2);
										
										$(tbody).append(
												'<tr>'+
												'  <td>'+
												'  </td>'+
												'  <td>'+
												'    <label class="radio-inline">'+
												'      <span>'+result2.extend.context+'</span>'+
												'    </label>'+"<hr>"+
												'  </td>'+
												'</tr>'
											);
										
										
									}
								}); 
							
							var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								
							//题目标题 questionTitle 把值换成数据库中查到的
							$(tbody).find("span[class='title']").text(question.questionTitle);
							
							}else if(questionType==3){//下拉框
								
								//在table中追加1个tbody题目
								$("#surveyBody table").append(
									'<tbody questionNum='+(index+1)+' questionType="'+questionType+'" questionId='+question.questionId+'>'+
			'								<tr>'+
			'									<th class="col-md-1 text-right" style="border: none;">'+
			'										<span class="titleNum">'+(index+1)+'、</span>'+
			'									</th>'+
			'									<th class="col-md-11">'+
			'										<span class="title">点击编辑问题</span>'+'（下拉框）'+
													'<select></select>'+
			'									</th>'+
			'								</tr>'+
			'								'+
			'							</tbody>'
								);
								
								
								var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								
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
										
										$.each(result2.extend.optionList,function(index2,option){
											
											$(tbody).find("select").append(
												'<option value="'+option.optionContent+'" optionsort="'+(index+1)+'" optionId='+option.optionId+'>'+option.optionContent+'</option>'
											);

										});
										
										
									}
								});
								
								/*
									3、根据题目id，题目类型，和答卷id，查询答案
								*/
								 $.ajax({
									url:"${pageContext.request.contextPath}/answer/getUserAnswerByQidTypeIdAId",
									type:"POST",
									data:"questionId="+question.questionId+
										"&questionType="+questionType+
										"&answerId="+$("#answerId").val()+"",
									success:function(result2){
										console.log(result2);
										
										$(tbody).append(
												'<tr>'+
												'  <td>'+
												'  </td>'+
												'  <td>'+
												'    <label class="radio-inline">'+
												'      <span>'+result2.extend.context+'</span>'+
												'    </label>'+"<hr>"+
												'  </td>'+
												'</tr>'
											);
										
										
									}
								}); 
							
							

							}else if(questionType==4){//评分条
								
								//在table中追加1个tbody题目
								$("#surveyBody table").append(
									'<tbody questionNum='+(index+1)+' questionType="'+questionType+'" questionId='+question.questionId+'>'+
			'								<tr>'+
			'									<th class="col-md-1 text-right" style="border: none;">'+
			'										<span class="titleNum">'+(index+1)+'、</span>'+
			'									</th>'+
			'									<th class="col-md-11">'+
			'										<span class="title">点击编辑问题</span>'+
													'<span class="source" style="color: red;"></span>'+'（评分条）'+
			'									</th>'+
			'								</tr>'+
										
			'							</tbody>'
								);
								
								/*
									2、根据题目id，题目类型，和答卷id，查询答案
								*/
								 $.ajax({
									url:"${pageContext.request.contextPath}/answer/getUserAnswerByQidTypeIdAId",
									type:"POST",
									data:"questionId="+question.questionId+
										"&questionType="+questionType+
										"&answerId="+$("#answerId").val()+"",
									success:function(result2){
										console.log(result2);
										
										$(tbody).append(
												'<tr>'+
												'  <td>'+
												'  </td>'+
												'  <td>'+
												'    <label class="radio-inline">'+
												'      <span>'+result2.extend.context+'</span>'+
												'    </label>'+"<hr>"+
												'  </td>'+
												'</tr>'
											);
										
										
									}
								}); 
							
							var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								
							//题目标题 questionTitle 把值换成数据库中查到的
							$(tbody).find("span[class='title']").text(question.questionTitle);


							}
							

							
							
							
						});
						
						
					}
					
				});
				
				/*
					根据tbody，根据题目id，题目类型，和答卷id，查询答案的统一方法
				*/
				
				
				
				var f = false;
				
				//当进度条控件被点击到移动组件鼠标未抬起时，f=true
				$(document).on("mousedown vmousedown",".myProgress button",function(){
					f = true;
				});
				
				//当进度条控件被点击到移动组件鼠标抬起时，f=false
				$(document).on("mouseup vmouseup",function(){
					f = false;
				});
				
				$(document).on("mousemove vmousemove",".myProgress",function(e){//
					
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
						}else if(result<=0){
							px = 0;
							result=0;
						}
						
							
						//设置按钮跟随鼠标移动的位置
						$(this).find("button").attr("style","position: absolute;height:50px;margin-top:-14px;margin-left:"+px+" ;");
					
						//将当前的百分比设置为进度条的值
						$(this).find("div").attr("style","width: "+result+"%");
						
						//将进度条以数字显示在问题旁
						$(this).parents("tbody").find("span[class='source']").text(result);
					}
				});
				
			
				$(".pager a").on("click",function(){
					$(this).attr("href","${pageContext.request.contextPath}/answer/getPageperNext"
							+"?surveyId="+$("#surveyId").val()
							+"&answerId="+$("#answerId").val()
							+"&type="+$(this).attr("value"));	
				});
			
			});
	</script>
  </head>
  
  <body  data-role="page" data-theme="d" data-role="content">
    <!-- 导航条 -->
	<div id="m" style="background-color: #222;position: fixed; top: 0px; width: 100%; z-index:9999">
		
	</div>
	
	<!-- 问卷ID，答卷ID-->	
	<input type="hidden" id="surveyId" name="surveyId" value="${param.surveyId }">
	<input type="hidden" id="answerId" name="answerId" value="${param.answerId }">
	
	<!-- 选项类型选择 -->
	<div style="margin-top:60px; width: 100%;">
		<div class="col-md-2">
			<!-- 根据用户id查询答卷
			<button id="isRandom" value="0" type="button" class="btn btn-default"></button> -->
		</div>
		
	</div>
	
	<!-- 编辑问卷页面 -->
	<div class="container" >
		
		<div class="col-md-12 col-xs-12">
			
			<div class="row" >
					
				<div class="page-header">
				  <h1 style="text-align: center;">
				  	<span></span>
				  	<small>问卷调查</small>
				  </h1>
				  <h3 style="text-align: center;">
				  	XXX用户作答
				  	<br>
				  		开始时间：2018年10月29日00:41:33，
				  		提交时间：2018年10月29日00:41:45
				  	<br>
				  	总共用时:00:43:59
				  	<br>
				  </h3>
				</div>
				
				<div class="panel panel-default text-left">
				  <div class="panel-heading">问卷说明</div>
				  	<br>
				  	<p id="surveyExplain" style="width: 80%; top:20;bottom:20; left: 0;right: 0;margin: auto;"></p>
				  	<br>
				</div>
					
			</div> 
			
			<div class="row text-left" id="surveyBody">
				<table style="font-size: 16px;" class="table">
							
				    	
				   
				</table>
					
					
			</div>
			
		</div>
		
		<div class="row">
				<nav aria-label="...">
				  <ul class="pager">
				    <li class="previous"><a value="pre"><span aria-hidden="true">&larr;</span> 上一份答卷</a></li>
				    <li class="next"><a value="next">下一份答卷 <span aria-hidden="true">&rarr;</span></a></li>
				  </ul>
				</nav>
			</div>
		
	</div>

	<div style="height: 100px"></div>
	
	
  </body>
</html>
