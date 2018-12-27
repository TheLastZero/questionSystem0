<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html ng-app="app" lang="en">
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'surveyCreate.jsp' starting page</title>
    
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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/wui/css/wui.min.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/wui/css/style.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/wui/js/angular.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/wui/js/wui-date.js" charset="utf-8"></script>

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
	
	<style type="text/css">	
	
		/* div{
			border: 1px solid red;
			} */
		
	</style>
	<script type="text/javascript">
			
			$(document).ready(function(){
				
				//加载导航条
				$("#m").load("utils/nav.jsp");
				
				/* $("#timeStart input").on("click",function(){
					alert($("#timeStart input").val());
				}); */
				
				/* $("#timeStart input").change(function(){
					alert($("#timeStart input").val());
				}); */
				
				/*
					根据有无id判断当前是修改还是创建
				*/
				if($("#surveyId").val()==""){//无id，表示创建
				
				}else{//有id表示修改
					
					//根据id查出问卷基本信息，
					$.ajax({
						url:"${pageContext.request.contextPath}/survey/getById",
						type:"POST",
						data:"surveyId="+$("#surveyId").val(),
						success:function(result){
							console.log(result);
							
							$("#surveyName").val(result.extend.survey.surveyName);
							$("#surveyExplain").val(result.extend.survey.surveyExplain);
							$("#timeStart input").val(result.extend.survey.timeStart);
							$("#timeEnd input").val(result.extend.survey.timeEnd);
						}
					});
					
					
					
					$("#submitSurvey").text("保存修改并编辑题目");
				
				}
				
				
				//加载完成时清除错误信息
				$("#timeError").text("");
				
				/*
					提交问卷表单进行保存
				*/
				$("#submitSurvey").on("click",function(){
				
					$.ajax({
						url:"${pageContext.request.contextPath}/survey/saveOrUpdate",
						type:"POST",
						data:$("#createForm").serialize()+
							"&surveyId="+$("#surveyId").val()+
							"&tStart="+$("#timeStart input").val()+
							"&tEnd="+$("#timeEnd input").val()+
							"&userId="+"${sessionScope.user.userId}",
						success:function(result){
							console.log(result);
							
							if(result.code==200){//200表示处理失败
							
		    					//显示提示信息
		    					$("#timeError").text(result.extend.error);
		    					
		    					//加入错误提示样式
		    					$("#timeError").parent().addClass(" has-error");
   					
		    				}else{//100表示处理成功
		    					
		    					//成功后跳转至问卷编辑页面
		    					window.location.href="${pageContext.request.contextPath}/survey/surveyEdit.jsp?surveyId="+result.extend.surveyId;
		    					
		    				}
						}
					});


				});
				
				
			});
			
	</script>

  </head>
  
  <body>
    
	 <!-- 导航条 -->
	<div id="m" style="background-color: #222;position: fixed; top: 0px; width: 100%; z-index:9999">
		
	</div>
	
	<!-- 问卷ID-->	
	<input type="hidden" id="surveyId" name="surveyId" value="${param.surveyId }">
	
	<!-- survey问卷管理首页 -->
	<div class="container" style=" margin-top: 5%; width: 100%;">
		
		<div class="row col-md-4 col-md-offset-4">
		
			<form class="form-horizontal" id="createForm">
			  
			  <!-- 问卷类型 -->	
			  <input type="hidden" name="surveyType" value="${param.surveyType }">
			
			  <div class="form-group form-group-lg">
			    <label for="exampleInputName2" class="col-sm-2 control-label">问卷名字</label>
			    <div class="col-sm-10">
			      <input id="surveyName" name="surveyName" type="text" class="form-control">
			    </div>
			  </div>
			  
			  <div class="form-group form-group-lg">
			    <label for="exampleInputName2" class="col-sm-2 control-label">问卷说明</label>
			    <div class="col-sm-10">
			      <textarea id="surveyExplain" name="surveyExplain" class="form-control" rows="3"></textarea>
			    </div>
			  </div>
			  
			  <div class="form-group form-group-lg">
				    <label for="exampleInputName2" class="col-sm-2 control-label">开始时间</label>
				    <div class="col-sm-10" >
				    	<!-- 
				    		ng-model 参数，当有多个时间控件的时候，以此来区分不同控件
				    		若不同控件ng-model值相同，那么这些控件的值都一致维持相同
				    		无论点击哪一个控件都会影响其他控件的时间
				    	-->
				      	<wui-date 
								format="yyyy-mm-dd hh:mm:ss" 
								placeholder="请选择开始日期" 
								id="timeStart" 
								btns="{'ok':'确定','now':'此刻'}" 
								ng-model="date1"
							>
						</wui-date>
				    </div>
			  </div>
			  
			  <div class="form-group form-group-lg">
				    <label for="exampleInputName2" class="col-sm-2 control-label">截止时间</label>
			    	<div class="col-sm-10">
				      	<wui-date 
								format="yyyy-mm-dd hh:mm:ss" 
								placeholder="请选择结束日期" 
								id="timeEnd" 
								btns="{'ok':'确定','now':'此刻'}" 
								ng-model="date2"
							>
						</wui-date>
						<span id="timeError" class="help-block"></span>
				    </div>
			  </div>
			  
			 
			 
			 
			  <div class="form-group form-group-lg">
			    <div class="col-sm-offset-2 col-sm-10">
			      <button id="submitSurvey" type="button" class="btn btn-primary btn-lg btn-block">创建问卷</button>
			    </div>
			  </div>
			  
			</form>
		</div>
		
		<script type="text/javascript">
				//引入wuiDate依赖
				var app = angular.module('app',["wui.date"]);
		</script>
	</div>
	

  </body>
</html>
