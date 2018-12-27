<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'suevryHome.jsp' starting page</title>
    
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
	
		 /*  div{
			border: 1px solid red;
			}  */ 
		
	</style>
	
	<script type="text/javascript">
		
		$(document).ready(function(){
			
			
			var surveyStatus=-1;//查询问卷的状态
			var searchSurveyName="-1"; 
			
			
			//加载导航条
			$("#m").load("utils/nav.jsp");
			
			
			//根据页码加载问卷信息
			function getPage(pn){//页码，问卷状态，-1表示查询所有
			
				$.ajax({
					url:"${pageContext.request.contextPath}/survey/getPageListByStatus",
					type:"POST",
					data:"pn="+pn+
						"&surveyStatus="+surveyStatus+
						"&userId=${sessionScope.user.userId}"+
						"&surveyName="+searchSurveyName,
					success:function(result){
						console.log(result);
						
						/*
							1、开始拼接问卷信息
						*/
						
						//清空surveyBody中所有元素
						$("#surveyBody").empty();
						
						//遍历问卷
						$(result.extend.pageInfo.list).each(function(index,data){
							
							//问卷类型
							var surveyType;
							
							if(data.surveyType==0){
								surveyType="（问卷调查）";
							}else if(data.surveyType==1){
								surveyType="（在线考试）";
							}else if(data.surveyType==2){
								surveyType="（在线投票）";
							}
							
							//问卷状态，草稿0，运行中1，暂停2，可恢复删除状态3
							var headStatus;//头部状态
							var bodyStatus;//身体状态
							var statusColor;//发布停止的颜色
							if(data.surveyStatus==0){//草稿
								headStatus="<span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span>草稿中"
								bodyStatus="<span class=\"glyphicon glyphicon-send\" aria-hidden=\"true\"></span>发布"
								statusColor="color: #30a6f5;";//发布的颜色
							}else if(data.surveyStatus==1){//运行中
								headStatus="<span class=\"glyphicon glyphicon-play\" aria-hidden=\"true\"></span>运行中"
								bodyStatus="<span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span>停止"
								statusColor="color: #fa911e;";//停止的颜色
							}else if(data.surveyStatus==2){//暂停中
								headStatus="<span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span>已暂停"
								bodyStatus="<span class=\"glyphicon glyphicon-send\" aria-hidden=\"true\"></span>发布"
								statusColor="color: #30a6f5;";//发布的颜色
							}
							
							
							//运行<span class=\"glyphicon glyphicon-play\" aria-hidden=\"true\"></span>
							//暂停<span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span>
							//发布<span class=\"glyphicon glyphicon-send\" aria-hidden=\"true\"></span>
							//停止<span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span>
							
							var answerNum=0;
							
							//根据当前问卷的id，查询其所有的答卷
							$.ajax({
								url:"${pageContext.request.contextPath}/survey/getAnswerNum",
								type:"POST",
								data:"surveyId="+data.surveyId,
								success:function(result){
									console.log(result);
									
									answerNum = result.extend.answerNum;
									
									$("#surveyBody").append(
							"<div class=\"row col-md-8 col-md-offset-2\" style=\"margin-top: 2%\">"+
		"				    	<div class=\"panel panel-info\">"+
		"					      <div class=\"panel-heading\">"+
		"					      	<div class=\"row\">"+
		"					      		<div class=\"col-md-6\">"+
		"					      		"+data.surveyName+surveyType+
		"						      	</div>"+
		"						      	<div class=\"col-md-6 text-right\">"+
		"						      		"+headStatus+
		"						      		&nbsp"+
		"						      		<a class='toAnswer' value='"+answerNum+"' href='${pageContext.request.contextPath}/answer/answerShow.jsp?surveyId="+data.surveyId+"&answerId=-1'>答卷:"+answerNum+"份 </a>&nbsp"+
		"						      		"+data.timeCreate+
		"						      	</div>"+
		"					      	</div>"+
		"					      	"+
		"					        "+
		"					      </div>"+
		"					      <div class=\"panel-body\">"+
		"					      "+
		"					      	"+
		"					        <div class=\"row\">"+
		"					      		<div class=\"col-md-6\" style=\"color: #808080;\">"+
		"					      			<button value=\""+data.surveyId+"\" surveyStatus=\""+data.surveyStatus+"\" type=\"button\" class=\"btn editSurvey\" style=\"background: none;\">"+
		"					      				<span class=\"glyphicon glyphicon-edit\" aria-hidden=\"true\"></span>"+
		"					      				编辑问卷"+
		"					      			</button>"+
		"					      			"+
		"					      			<button surveyId=\""+data.surveyId+"\" surveyStatus=\""+data.surveyStatus+"\" type=\"button\" class=\"btn sendSurvey\" style=\"background: none;\">"+
		"					      				<span class=\"glyphicon glyphicon-qrcode\" aria-hidden=\"true\"></span>"+
		"					      				发送问卷"+
		"					      			</button>"+
		"					      			"+
		"					      			<button surveyId=\""+data.surveyId+"\" type=\"button\" class=\"btn surveyGraph\" style=\"background: none;\">"+
		"					      				<span class=\"glyphicon glyphicon-signal\" aria-hidden=\"true\"></span>"+
		"					      				分析问卷"+
		"					      			</button>"+
		"					      			"+
		"						      	</div>"+
		"						      	<div class=\"col-md-6 text-right\">"+
		"						      		<button surveyId=\""+data.surveyId+"\" value=\""+data.surveyStatus+"\" type=\"button\" class=\"btn changeStatus\" style=\"background: none;"+statusColor+"\">"+
		"					      				"+bodyStatus+
		"					      				"+
		"					      			</button>"+
		"					      			"+
		"					      			<button surveyId=\""+data.surveyId+"\" type=\"button\" class=\"btn removeSurvey\" style=\"background: none; color:  #d9534f;\">"+
		"					      				<span class=\"glyphicon glyphicon-floppy-remove\" aria-hidden=\"true\"></span>"+
		"					      				删除"+
		"					      			</button>"+
		"						      	</div>"+
		"					      	</div>"+
		"					      </div>"+
		"					    </div>"+
		"				    </div>"
							);
								}
							});
							
								
							
							
							
							
						});
						
						/*
							2、拼接分页条信息
						*/
						
						//分页总数信息
						$("#pageSumInfo").empty();
						$("#pageSumInfo").append("查出"+result.extend.pageInfo.total+"条数据，总共"+result.extend.pageInfo.pages+"页");
						
						$("#surveyFoot ul").empty();//先清空
						
						//上一页
						var previous = $('<li class="previous"><a ><span aria-hidden="true">&larr;</span>上一页</a></li>');
						
						//绑定去哪一页的点击事件
		    			previous.click(function(){
		    				getPage(result.extend.pageInfo.prePage);
		    			});
		    			$("#surveyFoot ul").append(previous);
						
						//中间页码
						//1,2,3遍历给ul中添加页码提示
			    		$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
			    			
			    			var numLi = $("<li></li>");
			    			var a = $("<a>"+item+"</a>");
			    			
			    			//如果当前页码等于我们正在遍历的页码，我们就给当前li加上高亮提示
			    			if(result.extend.pageInfo.pageNum == item){
			    				a.attr("style","background-color: #337ab7;color:white;");
			    			}
			    			
			    			$(numLi).append(a);
			    			
			    			//绑定去哪一页的点击事件
			    			numLi.click(function(){
			    				getPage(item);
			    			});
			    			
			    			$("#surveyFoot ul").append(numLi);
			    			
			    		});
						
						//下一页
						var next = $('<li class="next"><a >下一页<span aria-hidden="true">&rarr;</span></a></li>');
						//绑定去哪一页的点击事件
		    			next.click(function(){
		    				getPage(result.extend.pageInfo.nextPage);
		    			});
		    			$("#surveyFoot ul").append(next);
						
					}
				});
			
			}
			
			//页面加载好时，加载第一页的问卷数据
			getPage(1);
			
			/*
				创建问卷被点击时
			*/
			$("#selectCreateSurvey button").on("click",function(){
				//alert($(this).val());
				$(window).attr('location','${pageContext.request.contextPath}/survey/surveyCreate.jsp?surveyType='+$(this).val());
			});
			
			/*
				问卷状态下拉框
			*/
			to_Page = function(pn,status){
				surveyStatus = status;//根据当前的状态选择来查询的问卷状态属性
				
				if(status==0){
					$("#downStatusBtn").text("草稿");
				}else if(status==1){
					$("#downStatusBtn").text("运行中");
				}else if(status==2){
					$("#downStatusBtn").text("暂停");
				}else if(status==-1){
					$("#downStatusBtn").text("所有问卷");
				}
				
				getPage(pn);
			}
			
			/*
				搜索框每当有值改变，都去发送一次根据名字查询的请求
			*/
			$("#searchSurveyBtn").keyup(function(){
			
				if($(this).val()==""){//搜索框的值为空时，查询所有
					searchSurveyName=-1;
				}else{//搜索框有值时按照搜索框中的值搜索
					searchSurveyName=$(this).val();
				}
				
				getPage(1);
			});
			
			
			/*
				点击编辑问卷时跳转到问卷编辑页面
			*/
			$(document).on("click",".editSurvey",function(){
				//alert($(this).val());
				
				//判断问卷的运行状态，如果正在运行则提示用户
				if($(this).attr("surveyStatus")==1){
					if(confirm("现在修改会暂停问卷的发布，确认编辑?")){
					
					}else{
						return false;
					}
				};
				
				//带着问卷id，跳转到问卷编辑页面
				window.location="${pageContext.request.contextPath}/survey/surveyCreate.jsp?surveyId="+$(this).val();
				
			});
			
			var surveyId;
			
			/*
				点击发送问卷按钮
			*/
			$(document).on("click",".sendSurvey",function(){
			
				//1、判断当前问卷的状态，如果是已经发布的状态，才可以发送问卷否则返回false
				if($(this).attr("surveyStatus")==1){
					
					//当前点击的答卷id
					surveyId = $(this).attr("surveyId");
					
					//答卷地址
					var url = "http://questionnaire.zerozrz.com/answer/answer.jsp?surveyId="+$(this).attr("surveyId"); 
					
					//input填充问卷地址
					$("#answeURLInput").val(url);
					
					//填充二维码地址
					$("#QRcodeImg").attr("src","https://zxing.org/w/chart?cht=qr&chs=350x350&chld=L&choe=UTF-8&chl="+url);
					
					
					//显示二维码模态框
					$("#sendSurveyModal").modal("show");
					
				}else{
					//弹框提示，发布问卷之后才能发送问卷
					alert("只有发布了问卷之后，才可以发送问卷哦!");
				}
			});
			
			
			//模态框，直接打开答卷页面
			$("#GoAnswer").on("click",function(){
				window.open("${pageContext.request.contextPath}/answer/answer.jsp?surveyId="+surveyId);
			});
			
			/*
				点击分析问卷按钮
			*/
			$(document).on("click",".surveyGraph",function(){
				window.location = "${pageContext.request.contextPath}/graph/graph.jsp?surveyId="+$(this).attr("surveyId");
			});
			
			/*
				点击发布或停止按钮
			*/
			$(document).on("click",".changeStatus",function(){
				
				//alert($(this).val());
				var surveyStatus = $(this).val();
				
				if(surveyStatus==0 || surveyStatus==2){//草稿和暂停状态点击之后变为发布状态
					surveyStatus = 1;
				}else if(surveyStatus==1){//如果是发布状态，则改为暂停状态
					surveyStatus = 2;
				}
				
				$.ajax({
					url:"${pageContext.request.contextPath}/survey/releaseOrStop",
					type:"POST",
					data:"surveyId="+$(this).attr("surveyId")+
							"&surveyStatus="+surveyStatus,
					success:function(result){
						console.log(result);
						
						//成功返回后刷新本页面
						window.location = "${pageContext.request.contextPath}/survey/suevryHome.jsp";
						
					}
				});
				
			});
			
			/*
				点击删除问卷按钮
			*/
			$(document).on("click",".removeSurvey",function(){
				
				var v = $(this).parents("div[class='panel-body']").prev().find("div[class='col-md-6']").text();
				v   =   v.replace(/^\s+|\s+$/g,"");
				if(confirm("是否要删除："+v+"，警告!同时会删除所有答卷")){
					$.ajax({
						url:"${pageContext.request.contextPath}/survey/removeSurvey",
						type:"POST",
						data:"surveyId="+$(this).attr("surveyId"),
						success:function(result){
							console.log(result);
							
							//成功返回后刷新本页面
							window.location = "${pageContext.request.contextPath}/survey/suevryHome.jsp";
							
						}
					});
				}else{
					
				}
			
				
				
			});
			
			
			var clipboard3 = new ClipboardJS('#copyUrl'); 
			   clipboard3.on('success', function(e) {
				   console.log(e);
			        alert("复制问卷地址成功！")
				    });
			   clipboard3.on('error', function(e) {
				           console.log(e);
				           alert("复制失败！请手动复制")
				 	});
				 	
		 	/*
		 		跳转答卷被点击时
		 	*/
			$(document).on("click","a[class='toAnswer']",function(){
				
				if($(this).attr("value")==0){
					return false;
				}
				
			});

		   	
		});
		
	</script>

  </head>
  
  <body>
    
    <!-- 导航条 -->
	<div id="m" style="background-color: #222;position: fixed; top: 0px; width: 100%; z-index:9999">
		
	</div>
	
	<!-- survey问卷管理首页 -->
	<div class="container" style=" margin-top: 5%; width: 100%;">
		
		<!-- 创建问卷模态框 -->
		<!-- Large modal -->
		<div id="createSurveyModal" style="z-index:9999" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
		  <div class="modal-dialog modal-lg" role="document">
		    <div class="modal-content">
		    	<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title" id="myModalLabel">选择创建问卷的类型</h4>
			    </div>
		      
		      	 <div class="modal-body container col-md-12" style="background-color:#fff ;">
			      	 	<div class="row col-md-8 col-md-offset-2" id="selectCreateSurvey">
					        <button type="button" class="btn btn-default btn-lg btn-block" value="0">调查问卷</button>
							<button type="button" class="btn btn-default btn-lg btn-block" value="1" disabled="disabled">在线考试</button>
							<button type="button" class="btn btn-default btn-lg btn-block" value="2" disabled="disabled">在线投票</button>
						</div>
			     </div>
		    </div>
		  </div>
		</div>
		
		<div class="container">
		  
			  <!-- 
			  	1、问卷头部
			  	创建问卷，问卷搜索框，问卷状态，回收站 
			  -->
			  <div class="row">
			  
			    <div class="col-md-2 text-left">
			    	<button id="createSurveyBtn" type="button" class="btn btn-warning btn-lg" style="border-radius: 30px;" data-toggle="modal" data-target="#createSurveyModal">
			    		<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
			    		创建问卷
			    	</button>
			    </div>
			    
			     <div class="col-md-2 text-left" style="height: 48px">
			     	
			     	<div class="input-group" style="margin: auto;  position: absolute;  top: 0; left: 0; bottom: 0; right: 0;">
			     
			     	 <!-- 问卷状态下拉菜单 -->
						 <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						    	 <span id="downStatusBtn">问卷状态</span> <span class="caret"></span>
						  </button>
						  <ul class="dropdown-menu">
						    <li><a onclick="to_Page(1,0)">草稿</a></li>
						    <li><a onclick="to_Page(1,1)">运行中</a></li>
						    <li><a onclick="to_Page(1,2)">暂停</a></li>
						    <li role="separator" class="divider"></li>
						    <li><a onclick="to_Page(1,-1)">查询所有</a></li>
						  </ul>
						  
					</div>
			     </div>
			   
			    <div class="col-md-5" style="height: 48px">
			    	<div class="input-group" style="margin: auto;  position: absolute;  top: 0; left: 0; bottom: 0; right: 0;">
					      <input id="searchSurveyBtn" type="text" class="form-control" placeholder="Search for...">
					      <span class="input-group-btn">
					        <button class="btn btn-default" type="button">
					        	<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
					        	搜索
					        </button>
					      </span>
					 </div>

				
			    </div>
			    
			    
			    <div class="col-md-3 text-right">
			    	
			    	<button type="button" class="btn btn-default btn-lg" disabled="disabled">
					  <span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 
					 	 回收站
					</button>
			    </div>
			    
			  </div>
			  
			   <div id="pageSumInfo" class="row col-md-12" style="margin-top: 2%">
			     	
			   </div>
			  
			 
			  <!-- 
			  	2、问卷分页部分 
			  -->
			  <div id="surveyBody" class="row" >
			    
				    <div class="row col-md-8 col-md-offset-2" style="margin-top: 2%">
				    	<div class="panel panel-info">
					      <div class="panel-heading">
					      	<div class="row">
					      		<div class="col-md-6">
					      		问卷标题
						      	</div>
						      	<div class="col-md-6 text-right">
						      		<span class="glyphicon glyphicon-pause" aria-hidden="true"></span>
						      		已暂停  &nbsp
						      		答卷:5份 &nbsp
						      		10月16日00:26:40
						      	</div>
					      	</div>
					      	
					        
					      </div>
					      <div class="panel-body">
					      
					      	
					        <div class="row">
					      		<div class="col-md-6" style="color: #808080;">
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
					      				编辑问卷
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-qrcode" aria-hidden="true"></span>
					      				发送问卷
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-signal" aria-hidden="true"></span>
					      				分析问卷
					      			</button>
					      			
						      	</div>
						      	<div class="col-md-6 text-right">
						      		<button type="button" class="btn" style="background: none;color: #30a6f5;">
					      				<span class="glyphicon glyphicon-send" aria-hidden="true"></span>
					      				发布
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none; color:  #d9534f;">
					      				<span class="glyphicon glyphicon-floppy-remove" aria-hidden="true"></span>
					      				删除
					      			</button>
						      	</div>
					      	</div>

					      </div>
					    </div>
				    </div>
				    
				    <div class="row col-md-8 col-md-offset-2" style="margin-top: 2%">
				    	<div class="panel panel-info">
					      <div class="panel-heading">
					      	<div class="row">
					      		<div class="col-md-6">
					      		问卷标题
						      	</div>
						      	<div class="col-md-6 text-right">
						      		<span class="glyphicon glyphicon-pause" aria-hidden="true"></span>
						      		已暂停  &nbsp
						      		答卷:5份 &nbsp
						      		10月16日00:26:40
						      	</div>
					      	</div>
					      	
					        
					      </div>
					      <div class="panel-body">
					      
					      	
					        <div class="row">
					      		<div class="col-md-6" style="color: #808080;">
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
					      				编辑问卷
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-qrcode" aria-hidden="true"></span>
					      				发送问卷
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-signal" aria-hidden="true"></span>
					      				分析问卷
					      			</button>
					      			
						      	</div>
						      	<div class="col-md-6 text-right">
						      		<button type="button" class="btn" style="background: none;color: #30a6f5;">
					      				<span class="glyphicon glyphicon-send" aria-hidden="true"></span>
					      				发布
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none; color:  #d9534f;">
					      				<span class="glyphicon glyphicon-floppy-remove" aria-hidden="true"></span>
					      				删除
					      			</button>
						      	</div>
					      	</div>

					      </div>
					    </div>
				    </div>
				    
				    <div class="row col-md-8 col-md-offset-2" style="margin-top: 2%">
				    	<div class="panel panel-info">
					      <div class="panel-heading">
					      	<div class="row">
					      		<div class="col-md-6">
					      		问卷标题
						      	</div>
						      	<div class="col-md-6 text-right">
						      		<span class="glyphicon glyphicon-play" aria-hidden="true"></span>
						      		运行中  &nbsp
						      		答卷:5份 &nbsp
						      		10月16日00:26:40
						      	</div>
					      	</div>
					      	
					        
					      </div>
					      <div class="panel-body">
					      
					      	
					        <div class="row">
					      		<div class="col-md-6" style="color: #808080;">
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
					      				编辑问卷
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-qrcode" aria-hidden="true"></span>
					      				发送问卷
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none;">
					      				<span class="glyphicon glyphicon-signal" aria-hidden="true"></span>
					      				分析问卷
					      			</button>
					      			
						      	</div>
						      	<div class="col-md-6 text-right">
						      		<button type="button" class="btn" style="background: none;color: #fa911e;">
					      				<span class="glyphicon glyphicon-pause" aria-hidden="true"></span>
					      				停止
					      			</button>
					      			
					      			<button type="button" class="btn" style="background: none; color:  #d9534f;">
					      				<span class="glyphicon glyphicon-floppy-remove" aria-hidden="true"></span>
					      				删除
					      			</button>
						      	</div>
					      	</div>

					      </div>
					    </div>
				    </div>
			  </div>
		  
		   <!-- 
			  	2、分页条部分 
			  -->
			  <div id="surveyFoot" class="row" style="margin-top: 3%;">
			  
			  			<!-- 分页条信息 -->
			  			<div class="col-md-6 col-md-offset-3" id="page_nav_area">
			  				<nav aria-label="...">
							  <ul class="pager">
							    <li class="previous"><a href="#"><span aria-hidden="true">&larr;</span>上一页</a></li>
							    <li class=""><a href="#">*</a></li>
							    <li class=""><a href="#">*</a></li>
							    <li class=""><a href="#">*</a></li>
							    <li class=""><a href="#">*</a></li>
							    <li class=""><a href="#">*</a></li>
							    <li class="next"><a href="#">下一页<span aria-hidden="true">&rarr;</span></a></li>
							  </ul>
							</nav>
			  			</div>
			  		
			  </div>
		  
		 
		 </div>
	
	
	</div>
	
	
		<div id="sendSurveyModal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" style="display: none;margin-top: 5%;">
	    <div class="modal-dialog" role="document">
	      <div class="modal-content">
	
	        <div class="modal-header">
	          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
	          <h4 class="modal-title" id="myLargeModalLabel">分享问卷二维码和链接</h4>
	        </div>
	        <div class="modal-body">
				
				<div class="row">
					
					<div class="col-md-12 text-center">
						<img id="QRcodeImg" alt="" src="">
					</div>
					
					<div class="col-md-8 col-md-offset-2 text-center">
						<div class="input-group">
					      <input id="answeURLInput" type="text" class="form-control" placeholder="Search for...">
					      <span class="input-group-btn">
					        <button id="copyUrl" class="btn btn-default" type="button"  data-clipboard-action="copy" data-clipboard-target="#answeURLInput">复制链接</button>
					      </span>
					    </div><!-- /input-group -->
					</div>
				</div>
				
				<div class="row text-center" style="margin-top: 10px">
			        
			        <button id="GoAnswer" class="btn btn-default" type="submit">
			        	直接打开
			        </button>
				</div>
					          
				

	        </div>
	      </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	  </div>
    
  </body>
</html>
