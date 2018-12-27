<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'index.jsp' starting page</title>
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
	
	/*设置图片放大效果*/
	.item img{  
      cursor: pointer;  
      transition: all 0.6s;  
		}  
	.item img:hover{  
	       transform: scale(1.4);  
	  }
	  
	  /*
	  	使元素在父容器中垂直居中
	  */
	  .center-vertical{
        position: relative;
        top: 50%;
        transform: translateY(-50%);
    	} 
    
    /* div{
    	border: 1px solid;
    } */

</style>

	<script type="text/javascript">
		
		$(document).ready(function(){
			/*设置轮播图的时间间隔*/
			$('.carousel').carousel({
			  interval: 2000
			});
			
			
			//加载nav.jsp中的导航栏到本页面的导航条中
			/* $("nav").load("utils/nav.jsp #nav");
			$("#m").load("utils/nav.jsp #myModal");//,可以选择多个不同元素s
			 */
			/* $.ajax({
				url:"utils/nav.jsp",
				success:function(result){
					$("#m").html(result);
				}
			}); */
			
			$("#m").load("utils/nav.jsp");
			
			/* $("#test").click(function(){//测试按钮
				$.ajax({
		   			url:"${pageContext.request.contextPath}/userInfo/saveOrUpdateByQQ",
		   			type:"post",
		   			//由于是qq登录，我们需要传入Access Token以及OpenID，用户的qq名字，头像url，和性别
		   			data:"qqAccesstoken="+"1"+
		   					"&qqOpenid="+"22"+
		   					"&userQqname="+"3"+
		   					"&userIconurl="+"4"+
		   					"&userSex="+"5",
		   			success:function(result){
		   				alert("保存成功");
		   			}
		   		});
			}); */
			
		   		
		   		
		});
		
	</script>
</head>

<body>
	
	<!-- 导航条 -->
	<div id="m" style="background-color: #222;position: fixed;top: 0px;width: 100%;z-index:9999"></div>
	
	<!-- <button id="test" style="margin-top: 100px">测试保存</button> -->
	
	<div class="container text-center" style="background-color: #222;color: #bbb; margin-top: 50px; width: 100%;">
		<h3 style="margin-top: 0px;margin-bottom: 4%"><span style="color:#fff;">零界</span>问卷</h3>
		
		<h1 style="color:#fff;font-size: 48px;">帮助你快速准确的了解大众的想法</h1>
		<h2 style="font-size: 18px;margin-bottom: 4%">简单易用的构建问卷是我们一直坚持不懈的追求</h2>
		
		
		<div class="col-md-6 col-md-offset-3">
		
			<div id="carousel-example-generic" class="carousel slide" data-ride="carousel"  style="height: 50%">
			  <!-- Indicators -->
			  <ol class="carousel-indicators">
			    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
			    <li data-target="#carousel-example-generic" data-slide-to="1"></li>
			    <li data-target="#carousel-example-generic" data-slide-to="2"></li>
			  </ol>
			
			  
			  <!-- Wrapper for slides -->
			  <div class="carousel-inner" role="listbox"><!-- 如果不想图片放大时，高度被拉长，请在这里设置高度100% -->
			    <div class="item active">
			      <img src="static/img/homePageImg/2.jpg" alt="..." style="width: 100%;height: 100%">
			      <div class="carousel-caption">
				    <h3>调查问卷</h3>
				    <p>可以向大家进行各种简单的问卷提问</p>
				  </div>
			    </div>
			    <div class="item">
			      <img src="static/img/homePageImg/3.jpg" alt="..." style="width: 100%;height: 100%">
			       <div class="carousel-caption">
				    <h3>在线考试</h3>
				    <p>在问卷的基础之上加入了考试的功能</p>
				  </div>
			    </div>
			    <div class="item">
			      <img src="static/img/homePageImg/4.jpg" alt="..." style="width: 100%;height: 100%">
			       <div class="carousel-caption">
				    <h3>数据分析</h3>
				    <p>将问卷在结果通过条形图，柱状图等形象的展示</p>
				  </div>
			    </div>
			    ...
			  </div>
			
			  <!-- Controls -->
			  <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
			    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
			    <span class="sr-only">Previous</span>
			  </a>
			  <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
			    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
			    <span class="sr-only">Next</span>
			  </a>
			</div>
			
		</div>
	</div>
	
	<!-- 页面内容主体 -->
	<div class="container text-center" style="width: 100%;">
		
		<div class="row" style="margin-top: 5%">
			<div class="col-md-8 col-md-offset-2">
			    <div class="col-md-12" style="height: 50%;">
			      <div class="col-md-6 center-vertical">
			        <a href="#">
			          <img class="" data-src="holder.js/64x64" alt="64x64" src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+PCEtLQpTb3VyY2UgVVJMOiBob2xkZXIuanMvNjR4NjQKQ3JlYXRlZCB3aXRoIEhvbGRlci5qcyAyLjYuMC4KTGVhcm4gbW9yZSBhdCBodHRwOi8vaG9sZGVyanMuY29tCihjKSAyMDEyLTIwMTUgSXZhbiBNYWxvcGluc2t5IC0gaHR0cDovL2ltc2t5LmNvCi0tPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PCFbQ0RBVEFbI2hvbGRlcl8xNjY2M2Q0OGU2YiB0ZXh0IHsgZmlsbDojQUFBQUFBO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1mYW1pbHk6QXJpYWwsIEhlbHZldGljYSwgT3BlbiBTYW5zLCBzYW5zLXNlcmlmLCBtb25vc3BhY2U7Zm9udC1zaXplOjEwcHQgfSBdXT48L3N0eWxlPjwvZGVmcz48ZyBpZD0iaG9sZGVyXzE2NjYzZDQ4ZTZiIj48cmVjdCB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIGZpbGw9IiNFRUVFRUUiLz48Zz48dGV4dCB4PSIxMy4xNzk2ODc1IiB5PSIzNi41Ij42NHg2NDwvdGV4dD48L2c+PC9nPjwvc3ZnPg==" data-holder-rendered="true" style="width: 100%; height: 100%;">
			        </a>
			      </div>
			      <div class="col-md-6 center-vertical">
			        <h2 class="media-heading" style="color: #49505b;">1、什么是零界问卷</h2>
			        <span style="font-size: 1em;color: #767c84;">
			        	Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.
			        </span>
				      </div>
				 </div>
			</div>
		</div>
		
		<div class="row" style="margin-top: 10%">
				<div class="col-md-8 col-md-offset-2">
			    <div class="col-md-12" style="height: 50%;">
			      <div class="col-md-6 center-vertical">
			        <h2 class="media-heading" style="color: #49505b;">2、我们能为你做什么</h2>
			        <span style="font-size: 1em;color: #767c84;">
			        	Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.
			        </span>
			      </div>
			      <div class="col-md-6 center-vertical">
			        <a href="#">
			          <img class="" data-src="holder.js/64x64" alt="64x64" src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+PCEtLQpTb3VyY2UgVVJMOiBob2xkZXIuanMvNjR4NjQKQ3JlYXRlZCB3aXRoIEhvbGRlci5qcyAyLjYuMC4KTGVhcm4gbW9yZSBhdCBodHRwOi8vaG9sZGVyanMuY29tCihjKSAyMDEyLTIwMTUgSXZhbiBNYWxvcGluc2t5IC0gaHR0cDovL2ltc2t5LmNvCi0tPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PCFbQ0RBVEFbI2hvbGRlcl8xNjY2M2Q0OGU2YiB0ZXh0IHsgZmlsbDojQUFBQUFBO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1mYW1pbHk6QXJpYWwsIEhlbHZldGljYSwgT3BlbiBTYW5zLCBzYW5zLXNlcmlmLCBtb25vc3BhY2U7Zm9udC1zaXplOjEwcHQgfSBdXT48L3N0eWxlPjwvZGVmcz48ZyBpZD0iaG9sZGVyXzE2NjYzZDQ4ZTZiIj48cmVjdCB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIGZpbGw9IiNFRUVFRUUiLz48Zz48dGV4dCB4PSIxMy4xNzk2ODc1IiB5PSIzNi41Ij42NHg2NDwvdGV4dD48L2c+PC9nPjwvc3ZnPg==" data-holder-rendered="true" style="width: 100%; height: 100%;">
			        </a>
			      </div>
			 </div>
			 </div>
		</div>
		
		<div class="row" style="margin-top: 10%">
			<div class="col-md-8 col-md-offset-2">
			    <div class="col-md-12" style="height: 50%;">
			      <div class="col-md-6 center-vertical">
			        <a href="#">
			          <img class="" data-src="holder.js/64x64" alt="64x64" src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+PCEtLQpTb3VyY2UgVVJMOiBob2xkZXIuanMvNjR4NjQKQ3JlYXRlZCB3aXRoIEhvbGRlci5qcyAyLjYuMC4KTGVhcm4gbW9yZSBhdCBodHRwOi8vaG9sZGVyanMuY29tCihjKSAyMDEyLTIwMTUgSXZhbiBNYWxvcGluc2t5IC0gaHR0cDovL2ltc2t5LmNvCi0tPjxkZWZzPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+PCFbQ0RBVEFbI2hvbGRlcl8xNjY2M2Q0OGU2YiB0ZXh0IHsgZmlsbDojQUFBQUFBO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1mYW1pbHk6QXJpYWwsIEhlbHZldGljYSwgT3BlbiBTYW5zLCBzYW5zLXNlcmlmLCBtb25vc3BhY2U7Zm9udC1zaXplOjEwcHQgfSBdXT48L3N0eWxlPjwvZGVmcz48ZyBpZD0iaG9sZGVyXzE2NjYzZDQ4ZTZiIj48cmVjdCB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIGZpbGw9IiNFRUVFRUUiLz48Zz48dGV4dCB4PSIxMy4xNzk2ODc1IiB5PSIzNi41Ij42NHg2NDwvdGV4dD48L2c+PC9nPjwvc3ZnPg==" data-holder-rendered="true" style="width: 100%; height: 100%;">
			        </a>
			      </div>
			      <div class="col-md-offset-6 center-vertical">
			        <h2 class="media-heading" style="color: #49505b;">3、如何快速使用零界问卷</h2>
			        <span style="font-size: 1em;color: #767c84;">
			        	Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.
			        </span>
			   	 </div>
			 </div>
		</div>

</body>
</html>
