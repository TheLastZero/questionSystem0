<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'graph.jsp' starting page</title>
    
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
	
	<script src="${pageContext.request.contextPath}/static/js/echarts.js"></script>
	<script src="${pageContext.request.contextPath}/static/js/echarts-gl.js"></script>
	<style type="text/css">	
	
		    /* div,td{
			border: 1px solid red;
			}  */  
		
	</style>
	
	<script type="text/javascript">
	
		$(document).ready(function(){
			//加载导航条
			$("#m").load("${pageContext.request.contextPath}/utils/nav.jsp");
			
			/*
				根据问卷id加载答卷的分析信息
				
				问卷需要
					得到问卷的标题，类型
				
				题目需要，
					每题的标题，类型
				
				选项需要：
				
				1、单选
					选项文本		选项被选择的次数	此选项被选中的比例
					有效填写人次
					饼状图	柱状图
				
				2、复选
					选项文本		选项被选择的次数	此选项被选中的比例
					有效填写人次
					饼状图	柱状图
				
				3、填空题
					直接以分页的形式展示所有答题者此题的信息
					序号		提交答卷时间		答案文本		查看答卷
					
				4、下拉框
					选项文本		选项被选择的次数	此选项被选中的比例
					有效填写人次
					饼状图	柱状图
						
				5、评分条
					直接取所有答案的平均值即可
					
			*/
			var questionNum=1;//题目序号
			$.ajax({
				url:"${pageContext.request.contextPath}/answer/surveyAnalyze",
				type:"POST",
				data:"surveyId="+$("#surveyId").val(),
				success:function(result){
					console.log(result);
					var surveyMap = result.extend.surveyMap;
					
					//赋值标题
					$("h1").text(surveyMap.surveyName);
					
					//1、判断问卷的类型
					if(surveyMap.surveyType==0){//问卷调查
						
						/*
							2、遍历题目
						*/
						$.each(surveyMap.questionList,function(index,question){
						
							var questionType;
							if(question.questionType==0){//单选
								questionType = "（单选题）";
							}else if(question.questionType==1){//多选
								questionType = "（多选题）";
							}else if(question.questionType==2){//填空
								questionType = "（填空）";
							}else if(question.questionType==3){//下拉框
								questionType = "（下拉框）";
							}else if(question.questionType==4){//评分条
								questionType = "（评分条）";
							}
						
							$("table").append(
								'<tbody questionNum='+questionNum+'>'+
				'					<tr>'+
				'						<td colspan="3">'+
				'							<h3 style="color: #676767">'+
				'								 <span>第'+questionNum+'题</span>'+
				'								 <span style="font-size: 18px;color: black;">'+question.questionTitle+questionType+'</span>	'+
				'							</h3>'+
				'							'+
				'							'+
				'						</td>'+
				'					</tr>'+

				
				
			'			      </tbody>'
							);
							
							/*
								3、判断题目的类型，是否需要遍历选项
							*/
							//单选，多选，下拉框
							if(question.questionType==0 || question.questionType==1 || question.questionType==3){
								
								$("tbody[questionNum="+questionNum+"]").find("tr:eq(0)").after(
													'			        <tr class="active">'+
				'			          <th width="45%">选项文本</th>'+
				'			          <th width="10%">小计</th>'+
				'			          <th width="45%">比例</th>'+
				'			        </tr>'
								);
								
								/*
									4、遍历选项
								*/
								var num =0;//本题有效填写人次
								var optionNum=1;//选项序号
								$.each(question.optionList,function(index2,option){
									
									num += option.optionCheckedNum;
									
									var r = option.optionRatio*100;//比例
									$("tbody[questionNum="+questionNum+"]").find("tr:eq(1)").after(
										'			        <tr optionNum='+optionNum+'>'+
										'			          <td>'+option.optionContent+'</td>'+
										'			          <td>'+option.optionCheckedNum+'</td>'+
										'			            <td>'+
										'			            <div class="progress" style="margin: 0px;">'+
										'							  <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: '+r+'%;">'+
										'							    '+r+'%'+
										'							  </div>'+
										'						</div> '+
										'						</td>'+
										'			        </tr>'
									);
									
								});
								
								if(question.questionType==1){//如果类型为多选题，有效人次如下
									num = question.personTime;
								}
								
								//总计
								$("tbody[questionNum="+questionNum+"]").find("tr:last").after(
										' <tr>'+
						'			          <th>本题有效填写人次</th>'+
						'			          <th>'+num+'</th>'+
						'			          <th></th>'+
						'			        </tr>'+
						'			         <tr>'+
				'			       	  <td colspan="3" class="text-center">'+
				'			       	  		<button value="0" class="btn btn-default barGraph" type="submit">柱状图</button>'+
				'			       	  		<button value="0" class="btn btn-default pieChart" type="submit">饼状图</button>'+
				'			       	  </td>'+
				'			         '+
				'			        </tr>'+
				'			        <tr style="display: none;">'+
				'			        	<td colspan="3" style="height: 400px;">'+
				'				        	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->'+
				'			   				<div id="graph_'+questionNum+'" style="width: 100%;height:100%;"></div>'+
				'		   				</td>'+
				'			        </tr>'+
				'				'+
				'			        	'
									);
									
								
								
							}else if(question.questionType==2){//填空
								
								$("tbody[questionNum="+questionNum+"]").find("tr:last").after(
									' <tr class="active"> '+
			'						    <th>用户填写的文本</th>  '+
			'						    <th></th>  '+
			'						    <th>查看答卷</th> '+
			'						  </tr> '
								);
								
								//遍历填空分页list数据
								$.each(question.replyList.list,function(index2,reply){
									
									var context;
									if(reply.replyContent=="" || reply.replyContent==undefined){
										context = "此用户没有填写";
									}else{
										context = reply.replyContent;
									}
									
									$("tbody[questionNum="+questionNum+"]").find("tr:last").after(
										'<tr replyContent="1"> '+
				'						    <td>'+context+'</td>  '+
				'						    <td></td>  '+
				'						    <td> '+
				'						      <a href="${pageContext.request.contextPath}/answer/answerShow.jsp?surveyId='+$("#surveyId").val()+'&answerId='+reply.answerId+'">查看答卷</a>'+
				'						    </td> '+
				'						  </tr>'
									);
									
								});
								
								//添加分页条信息
								$("tbody[questionNum="+questionNum+"]").find("tr:last").after(
									
									'<tr> '+
			'						    <td colspan="3">'+
			'						    	<nav aria-label="...">'+
			'								  <ul class="pager">'+
			'								    <li class="previous"><a class="pagePre" href="#" url="${pageContext.request.contextPath}/answer/getPageInfoByQuestionIdPn/?questionId='+question.questionId+'&pn='+question.replyList.prePage+'"><span aria-hidden="true">&larr;</span> 上一页</a></li>'+
			'								    <li class="next"><a class="pageNext" href="#" url="${pageContext.request.contextPath}/answer/getPageInfoByQuestionIdPn/?questionId='+question.questionId+'&pn='+question.replyList.nextPage+'">下一页<span aria-hidden="true">&rarr;</span></a></li>'+
			'								  </ul>'+
			'								</nav>	'+
			'						    </td>  '+
			'						  </tr>'
									
								);
								
								
							}else if(question.questionType==4){//评分条
								
								
								
								$("tbody[questionNum="+questionNum+"]").find("tr:eq(0)").after(
								' <tr class="active"> '+
		'						    <th width="45%">选项文本</th>  '+
		'						    <th width="10%"></th>  '+
		'						    <th width="45%">平均分</th> '+
		'						  </tr>  '+
								
									'<tr optionnum="1"> '+
			'						    <td>'+question.questionTitle+'</td>  '+
			'						    <td></td>  '+
			'						    <td> '+
			'						      '+question.averageScore+'分'+
			'						    </td> '+
			'						  </tr>  '
								);
								
							}
							
							questionNum++;
						});
						
						
						
					}else if(surveyMap.surveyType==1){//在线考试
					
					}else if(surveyMap.surveyType==1){//在线投票
					
					}
					
					
					
					
				}
			});
			
			
			/*
				当柱状图被点击时
			*/
			$(document).on("click",".barGraph",function(){
				//当前题目序号
				var qNum = $(this).parents("tbody").attr("questionNum");
				
				//重置div
				$(this).parent().parent().next().find("td").empty().append(
					'<div id="graph_'+qNum+'" style="width: 100%;height:100%;"></div>'
				);
				
				if($(this).val()==0){//从未选中状态变为选中状态
					//清除本行其他按钮选中样式
					$(this).parent().find("button").removeClass("btn-info");
					//将其他按钮值改为0
					$(this).parent().find("button").val(0);
					$(this).val(1);
					
					$(this).addClass("btn-info");//添加被选中样式
					
					
					//显示图表
					$(this).parent().parent().next().attr("style","");
					
				}else{//从选中状态变为未选中状态
					$(this).removeClass("btn-info");
					$(this).val(0);
					
					//隐藏图表
					$(this).parent().parent().next().attr("style","display: none;");
				}
				
				
				/*
					初始化图表数据
				*/
				var optionist = $("tbody[questionNum="+qNum+"]").find("tr[optionNum]");
				
				//XY轴数据
				var dx = new Array();
				var dy = new Array();
				$.each(optionist,function(index,option){
					dx[index] = $(option).find("td:eq(0)").text();
					dy[index] = $(option).find("td:eq(1)").text();
				});
				
				// 基于准备好的dom，初始化echarts实例
		        var myChart = echarts.init(document.getElementById('graph_'+qNum));
				
				
				option = {
				    color: ['#3398DB'],
				    tooltip : {
				        trigger: 'axis',
				        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
				            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
				        }
				    },
				    grid: {
				        left: '3%',
				        right: '4%',
				        bottom: '3%',
				        containLabel: true
				    },
				    xAxis : [
				        {
				            type : 'category',
				            data : dx,
				            axisTick: {
				                alignWithLabel: true
				            }
				        }
				    ],
				    yAxis : [
				        {
				            type : 'value'
				        }
				    ],
				    series : [
				        {
				            name:'选择次数',
				            type:'bar',
				            barWidth: '60%',
				            data:dy
				        }
				    ]
				};
		
		
		        // 使用刚指定的配置项和数据显示图表。
		        myChart.setOption(option);
				
			});
			
			/*
				当饼状图被点击时
			*/
			$(document).on("click",".pieChart",function(){
			
				//当前题目序号
				var qNum = $(this).parents("tbody").attr("questionNum");
				
				//重置div
				$(this).parent().parent().next().find("td").empty().append(
					'<div id="graph_'+qNum+'" style="width: 100%;height:100%;"></div>'
				);
			
				if($(this).val()==0){//从未选中状态变为选中状态
					//清除本行其他按钮选中样式
					$(this).parent().find("button").removeClass("btn-info");
					//将其他按钮值改为0
					$(this).parent().find("button").val(0);
					$(this).val(1);
					
					$(this).addClass("btn-info");//添加被选中样式
					
					
					//显示图表
					$(this).parent().parent().next().attr("style","");
					
				}else{//从选中状态变为未选中状态
					$(this).removeClass("btn-info");
					$(this).val(0);
					
					//隐藏图表
					$(this).parent().parent().next().attr("style","display: none;");
				}
				
				
				/*
					初始化图表数据
				*/
				var optionist = $("tbody[questionNum="+qNum+"]").find("tr[optionNum]");
				
				var data = new Array();
				$.each(optionist,function(index,option){
					
					//value的值越大，颜色对比越明显
					var v = parseInt($(option).find("td:eq(1)").text());
					data[index] =  {value:v*100, name:$(option).find("td:eq(0)").text()};
				});
				
				//alert(data);
				// 基于准备好的dom，初始化echarts实例
		        var myChart = echarts.init(document.getElementById('graph_'+qNum));
				
				option = {
			    backgroundColor: '#2c343c',
			    visualMap: {
			        show: false,
			        min: 80,
			        max: 600,
			        inRange: {
			            colorLightness: [0, 1]
			        }
			    },
			    series : [
			        {
			            name: '访问来源',
			            type: 'pie',
			            radius: '55%',
			            data:data,
			            roseType: 'angle',
			            label: {
			                normal: {
			                    textStyle: {
			                        color: 'rgba(255, 255, 255, 0.3)'
			                    }
			                }
			            },
			            labelLine: {
			                normal: {
			                    lineStyle: {
			                        color: 'rgba(255, 255, 255, 0.3)'
			                    }
			                }
			            },
			            itemStyle: {
			                normal: {
			                    color: '#c23531',
			                    shadowBlur: 200,
			                    shadowColor: 'rgba(0, 0, 0, 0.5)'
			                }
			            }
			        }
			    ]
			};
		
		
		        // 使用刚指定的配置项和数据显示图表。
		        myChart.setOption(option);
				
				
			});
			
			
			/*
				当填空题的上一页或下一页被点击时
				ajax刷新填空题分页信息
			*/
			$(document).on("click",".pagePre,.pageNext",function(){
				
				var tbody = $(this).parents("tbody");
				
				 $.ajax({
					url:$(this).attr("url"),
					type:"POST",
					success:function(result){
						console.log(result);
						
						
						//将大于第二行的元素全部删除
						$(tbody).find("tr:gt(1)").remove();
						
						var questionId=0;
						
						//遍历填空分页list数据
						$.each(result.list,function(index,reply){
							
							questionId = reply.questionId;
							
							var context;
							if(reply.replyContent=="" || reply.replyContent==undefined){
								context = "此用户没有填写";
							}else{
								context = reply.replyContent;
							}
							
							$(tbody).append(
								'<tr replyContent="1"> '+
		'						    <td>'+context+'</td>  '+
		'						    <td></td>  '+
		'						    <td> '+
		'						      <a href="${pageContext.request.contextPath}/answer/answerShow.jsp?answerId='+reply.replyId+'">查看答卷</a>'+
		'						    </td> '+
		'						  </tr>'
							);
							
						});
						
						var nextPageNum;
						if(result.nextPage==0){//如果下一页是去首页，我们就把它停留在最后一页
							nextPageNum = result.navigateLastPage;
						}else{
							nextPageNum = result.nextPage;
						}
						
						//添加分页条信息
						$(tbody).append(
							'<tr> '+
	'						    <td colspan="3">'+
	'						    	<nav aria-label="...">'+
	'								  <ul class="pager">'+
	'								    <li class="previous"><a class="pagePre" url="${pageContext.request.contextPath}/answer/getPageInfoByQuestionIdPn/?questionId='+questionId+'&pn='+result.prePage+'"><span aria-hidden="true">&larr;</span> 上一页</a></li>'+
	'								    <li class="next"><a class="pageNext" url="${pageContext.request.contextPath}/answer/getPageInfoByQuestionIdPn/?questionId='+questionId+'&pn='+nextPageNum+'">下一页<span aria-hidden="true">&rarr;</span></a></li>'+
	'								  </ul>'+
	'								</nav>	'+
	'						    </td>  '+
	'						  </tr>'
							
						);
						
					}
				}); 
				
				return false;
				
				
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
	
	<div class="container" style="margin-top: 60px;width: 40%">
		
		<div class="row text-center">
			<h1>XXX答卷的统计分析</h1>
		</div>
		
		<div class="row">
			
			<table class="table table-condensed">
					<!-- <tbody questionnum="9"> 
						  <tr> 
						    <td colspan="3"> 
						      <h3 style="color: #676767"> 
						        <span>第1题</span>  
						        <span style="font-size: 18px;color: black;">单选第一个问题（单选题）</span> 
						      </h3> 
						    </td> 
						  </tr>  
						  <tr class="active"> 
						    <th>用户填写的文本</th>  
						    <th></th>  
						    <th>查看答卷</th> 
						  </tr> 
						  <tr optionnum="1"> 
						    <td>单选第二个选项</td>  
						    <td></td>  
						    <td> 
						      <a href="">查看答卷</a>
						    </td> 
						  </tr>  
						  <tr optionnum="1"> 
						    <td colspan="3">
						    	<nav aria-label="...">
								  <ul class="pager">
								    <li class="previous"><a href="#"><span aria-hidden="true">&larr;</span> Older</a></li>
								    <li class="next"><a href="#">Newer <span aria-hidden="true">&rarr;</span></a></li>
								  </ul>
								</nav>	
						    </td>  
						  </tr>
						
			    </tbody> -->
				
			</table>
			
			

		
		
		
		
	</div>
  </body>
</html>
