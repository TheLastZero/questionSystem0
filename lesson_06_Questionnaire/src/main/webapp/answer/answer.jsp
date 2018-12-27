<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>问卷调查</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
	<!-- <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script> -->
	<!-- 导入jQuery Mobile -->
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.css">
	<script src="http://libs.baidu.com/jquery/1.11.3/jquery.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.js"></script>
	
	
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
				
				var questionNum=1;//题目顺序
				var answerStart;//考试开始时间
				
				//考试开始时间
				var date = new Date();
				answerStart = 
					date.getFullYear() + "-" + 
					(date.getMonth() + 1) + "-" + 
						date.getDate() + " " +
						date.getHours()+ ":" + 
						date.getMinutes()+":"+
						date.getSeconds();
						
				//加载导航条
				$("#m").load("utils/nav.jsp");
				
				/*
					根据问卷id加载问卷基本信息,题目和题目说明，还有题目类型
				*/
				var surveyId = $("#surveyId").val();
				
				$.ajax({
					url:"${pageContext.request.contextPath}/survey/getByIdCheck",
					type:"POST",
					data:"surveyId="+surveyId,
					success:function(result){
					
						//0、判断当前的时间是否小于问卷的截止时间
						
						//0.1，判断当前的问卷状态，如果问卷是草稿，未发布状态则直接返回false
						//result.date.getTime()
						if(result.code==200){//验证问卷和时间失败
							
							$("div[class='container']").empty().append(
								"<h1 class='text-center'>"+result.extend.error+"</h1>"
							);
							
							return false;
						}
						
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
			'										<span class="title">点击编辑问题</span>'+
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
											
											$(tbody).append(
												'<tr optionsort="'+(index+1)+'">'+
												'  <td/>'+
												'  <td>'+
												'    <label class="radio-inline">'+
												'      <input type="radio" name="r'+(index+1)+'" optionId='+option.optionId+' value="" />'+
												'      <span>'+option.optionContent+'</span>'+
												'    </label>'+
												'  </td>'+
												'</tr>'
											);

										});
										
										
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
			'										<span class="title">点击编辑问题</span>'+
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
											
											$(tbody).append(
												'<tr optionsort="'+(index+1)+'">'+
												'  <td/>'+
												'  <td>'+
												'    <label class="checkbox-inline">'+
												'      <input type="checkbox" name="r'+(index+1)+'" optionId='+option.optionId+' value=""/>'+
												'      <span>'+option.optionContent+'</span>'+
												'    </label>'+
												'  </td>'+
												'</tr>'
											);

										});
										
										
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
			'										<span class="title">点击编辑问题</span>'+
			'									</th>'+
			'								</tr>'+
											'<tr> '+
											'  <td/>  '+
											'  <td> '+
											'    <input type="text" style="border: none;border-bottom: 1px solid;"/> '+
											'  </td> '+
											'</tr>'+
			'								'+
			'							</tbody>'
								);
							
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
			'										<span class="title">点击编辑问题</span>'+
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
													'<span class="source" style="color: red;"></span>'+
			'									</th>'+
			'								</tr>'+
											'<tr> '+
'  <td/>  '+
'  <td> '+
'    <div id="p" class="progress myProgress" style="width: 50%;z-index: 1;"> '+
'      <button style="position: absolute;height:50px;margin-top:-14px;" class="btn btn-default" type="button"/>  '+
'      <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 0%"> '+
'        <span class="sr-only">40% Complete (success)</span> '+
'      </div> '+
'    </div> '+
'  </td> '+
'</tr>'+

			'								'+
			'							</tbody>'
								);
							
							var tbody = $("tbody[questionnum='"+(index+1)+"']");//tbody示题目部分tbody
								
							//题目标题 questionTitle 把值换成数据库中查到的
							$(tbody).find("span[class='title']").text(question.questionTitle);


							}
							

							
							
							
						});
						
						
					}
					
				});
				
				
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
				
				/*
					当我们点击提交问卷时
				*/
				$("#submitSurvey").on("click",function(){

					var jsonSurvey =  submitSurvey();
					
					//4、将拼接好的json发送给后台解析保存
					$.ajax({
						url:"${pageContext.request.contextPath}/answer/save",
						type:"POST",
						contentType:'application/json;charset=utf-8',
						data:jsonSurvey,
						success:function(result){
							console.log(result);
							
							//弹出模态框，提示保存成功，三秒钟之后跳转到问卷管理页面
							$('#saveSuccessModal').modal({
				    			backdrop:"static" //点击背景不删除模态框，不指定的话点击背景模态框就会删除
				    		});
				    		
				    		
						}
					}); 
					
					
					
				});
				
				function submitSurvey(){
					
					//考试结束时间
					var date = new Date();
					var answerEnd = 
						date.getFullYear() + "-" + 
						(date.getMonth() + 1) + "-" + 
							date.getDate() + " " +
							date.getHours()+ ":" + 
							date.getMinutes()+":"+
							date.getSeconds();
				
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
							jsonQuestion = jsonQuestion + jsonRadio(item)+",";
						}else if(questionType==1){//多选
							jsonQuestion = jsonQuestion + jsonRadio(item)+",";
						}else if(questionType==2){//填空
							jsonQuestion = jsonQuestion + jsonFill(item)+",";
						}else if(questionType==3){//下拉框
							jsonQuestion = jsonQuestion + jsonSelect(item)+",";
						}else if(questionType==4){//评分条
							jsonQuestion = jsonQuestion + jsonSourceBar(item)+",";
						}
						
					});
					
					if(tbodys.length!=0){//如果题目数量不等于0
						//将最后一个逗号，截取去掉
						jsonQuestion = jsonQuestion.substr(0, jsonQuestion.length-1);
					}
					
					jsonQuestion = jsonQuestion+"]";
					
					
					/*
						3、json拼接好答卷基本信息
						
						问卷ID surveyId
						答卷人ID userId
						答题开始时间： answerStart
						答题结束时间: answerEnd
						答题用时 (后台计算)
						
						每题情况list
					*/
					//最终保存的问卷json部分
					var userid2 = "${sessionScope.user.userId}";//如果当前有用户登录就记录答题者id
					if(userid2==""){//表示没有用户登录，id设置为-1表示匿名用户
						userid2=-1;
					}
					
	                var jsonSurvey = '{'+
	                    '"surveyId":'+$("#surveyId").val()+
	                    ',"userId":'+userid2+
	                    ',"answerStart":"'+answerStart+
	                    '","answerEnd":"'+answerEnd+
	                    
	                    '","questionList":'+jsonQuestion+
	                '}';
					
					console.log(jsonSurvey);
					
					return jsonSurvey;
				}
				
				//单选字符串拼接
				function jsonRadio(item){
					
					/*
						1、拼接答卷每题情况表中的单选
					
						答卷ID replyId (可以从最外层答卷获得)
						题目ID questionId
						每题回答选项ID集（单选：选项ID，多选：选项ID集，逗号隔开） replyIds
						每题回答文本内容（可以是文字，数字，单选复选下拉框不用管此字段）replyContent 
					*/
					var q = '{'+
				                    '"questionId":'+$(item).attr("questionid")+
				                    ',"replyIds":"';
				    var replyIds="";          
						
					var f=false;
					$.each($(item).find("input"),function(index,opt){
						
						//判断当前选项是否被选中，选中才添加进replyIds字符
						if($(opt).prop("checked")==true){
							f=true;
							replyIds = replyIds +$(opt).attr("optionid")+",";
						}
					});
					
					if(f==true){//如果选项个数不等于0
						//将jsonOption最后一个逗号，截取掉
						replyIds = replyIds.substr(0, replyIds.length-1);
					
					}
					
					q = q + replyIds + '"}';
					console.log(q);
					return q;
				}
				
				
				//填空字符串拼接
				function jsonFill(item){
					/*
						1、拼接答卷每题情况表中的填空
					
						答卷ID replyId (可以从最外层答卷获得)
						题目ID questionId
						每题回答选项ID集（单选：选项ID，多选：选项ID集，逗号隔开） replyIds
						每题回答文本内容（可以是文字，数字，单选复选下拉框不用管此字段）replyContent 
					*/
					var q = '{'+
				                    '"questionId":'+$(item).attr("questionid")+
				                    ',"replyContent":"'+$(item).find("input").val()+'"}';
					console.log(q);
					return q;
				}
				
				//下拉框字符串拼接
				function jsonSelect(item){
					
					/*
						1、拼接答卷每题情况表中的下拉框
					
						答卷ID replyId (可以从最外层答卷获得)
						题目ID questionId
						每题回答选项ID集（单选：选项ID，多选：选项ID集，逗号隔开） replyIds
						每题回答文本内容（可以是文字，数字，单选复选下拉框不用管此字段）replyContent 
					*/
					var v =$(item).find("select").val();
					var q = '{'+
				                    '"questionId":'+$(item).attr("questionid")+
				                    ',"replyIds":"'+$(item).find("option[value="+v+"]").attr("optionid")+'"}';
					console.log(q);
					return q;
				}
				
				//填空评分条拼接
				function jsonSourceBar(item){
					/*
						1、拼接答卷每题情况表中的评分条
					
						答卷ID replyId (可以从最外层答卷获得)
						题目ID questionId
						每题回答选项ID集（单选：选项ID，多选：选项ID集，逗号隔开） replyIds
						每题回答文本内容（可以是文字，数字，单选复选下拉框不用管此字段）replyContent 
					*/
					var q = '{'+
				                    '"questionId":'+$(item).attr("questionid")+
				                    ',"replyContent":"'+$(item).find("span[class='source']").text()+'"}';
					console.log(q);
					return q;
				}
				
				
				
			});
	</script>
  </head>
  
  <body  data-role="page" data-theme="d" data-role="content">
    <!-- 导航条 -->
	<div id="m" style="background-color: #222;position: fixed; top: 0px; width: 100%; z-index:9999">
		
	</div>
	
	<!-- 问卷ID-->	
	<input type="hidden" id="surveyId" name="surveyId" value="${param.surveyId }">
	
	<!-- 选项类型选择 -->
	<div style="margin-top:60px; width: 100%;">
		<div class="col-md-2">
			当前出题顺序：
			<button id="isRandom" value="0" type="button" class="btn btn-default">顺序</button>
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
					
				<div class="btn-group btn-group-lg col-md-4 col-xs-12 col-md-offset-4" role="group" aria-label="Large button group">
					<center>
						<div>
					      <button id="submitSurvey" type="button" class="btn btn-info btn-lg">提交问卷</button>
					      
							<div id="saveSuccessModal" class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
							  <div class="modal-dialog modal-sm" role="document">
							    <div class="modal-content" style="margin-top: 50%;">
							    	<button type="button" class="btn btn-success btn-lg">
							    		<span class="glyphicon glyphicon-ok" aria-hidden="true"></span>
							      		提交成功
							    	</button>
							    </div>
							  </div>
							</div>
					      
					      </div>
				    </center>
			    </div>	
					
			</div>
			
		</div>
	</div>

	<div style="height: 100px"></div>
	
	
  </body>
</html>
