<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'nav.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	

	<style type ="text/css">
		
	 /*
	  	使元素在父容器中垂直居中
	  */
	  .center-vertical{
        position: relative;
        top: 50%;
        transform: translateY(-50%);
    	} 
		
	</style>

	<script type="text/javascript">
	
	$(document).ready(function(){
		QC.Login({
		       //btnId：插入按钮的节点id，必选
		       btnId:"qqLoginBtn",	
		       //用户需要确认的scope授权项，可选，默认all
		       scope:"all",
		       //按钮尺寸，可用值[A_XL| A_L| A_M| A_S|  B_M| B_S| C_S]，可选，默认B_S
		       size: "B_M"
		   }, function(reqData, opts){//登录成功
		   		//登录成功后关闭模态框
		   		$('#myModal').modal('hide');
		   		$("#qqLogin").hide();//隐藏登录按钮
		   		$("#loginAfter").show();//显示用户下拉框
		   		
		   		
		   		//下拉菜单标题
		   		$("#loginAfter button").append(//头像
		            '<span><img src='+reqData.figureurl+' class="img-circle"/></span>'+
		            //昵称
		            '<span>'+reqData.nickname+'</span>'+
		            '<span class="caret"></span>');//倒三角图标
		            
		        //下拉退出按钮
		        $("#loginAfter li:eq(4)").append(//退出
		         '<a href="javascript:QC.Login.signOut();" class="btn btn-danger">退出</a>');
		        
		        var qq_openId;
		        var qq_accessToken;
		       //获取当前登录用户的Access Token以及OpenID
				  QC.Login.getMe(function(openId, accessToken){
				  	qq_openId = openId;
				  	qq_accessToken = accessToken;
				  });
		       /* 
		       	QQ登录流程
		       		1、发送ajax请求，保存用户登录信息，比对数据库中的OpenID信息，没有表示第一次登录则创建用户，保存用户的Access Token以及OpenID
		       		2、非第一次登录，就更新用户的登录状态，同时更新用户的Access Token(Access Token三个月qq会更新一次)
		       */
		   		$.ajax({
		   			url:"${pageContext.request.contextPath}/userInfo/saveOrUpdateByQQ",
		   			type:"post",
		   			//由于是qq登录，我们需要传入Access Token以及OpenID，用户的qq名字，头像url，和性别
		   			data:"qqAccesstoken="+qq_accessToken+
		   					"&qqOpenid="+qq_openId+
		   					"&userQqname="+reqData.nickname+
		   					"&userIconurl="+reqData.figureurl+
		   					"&userSex="+reqData.gender,
		   			success:function(result){
		   				console.log("添加或更新用户成功"+result);
		   			}
		   		});
		   		
		   		
		       
		              
		   }, function(opts){//注销成功
				//alert('QQ登录 注销成功');
				//注销成功隐藏用户栏
				$("#loginAfter").hide();
				$("#qqLogin").show();//显示登录按钮
		
		   }
		);
	});
	
	</script>

  </head>
  
  <body style="margin: 0px;padding: 0px;background-color: #222;">
  	
    <div style="height: 50px;" id="nav">
    	<div class="row center-vertical" style="width: 100%;">
    		<div class="col-md-6">
    			零界问卷
    		</div>
    		<div class="col-md-2 col-md-offset-3 text-right">
    			
    			<!-- 登录模态框 -->
		    	<!-- Button trigger modal -->
				<button type="button" id="qqLogin" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
				  登录
				</button>
				
    			<!-- 登录成功后的按钮下拉框 -->
    			<div class="btn-group" style="display: none;" id="loginAfter">
				  <button type="button" style="background: none;border:none;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    
				  </button>
				  <ul class="dropdown-menu">
				    <li><a href="#">Action</a></li>
				    <li><a href="#">Another action</a></li>
				    <li><a href="#">Something else here</a></li>
				    <li role="separator" class="divider"></li>
				    <li></li>
				  </ul>
				</div>
    		</div>
    	</div>
    	
		<!-- 用户登录模态框 -->
		<!-- Modal -->
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="myModalLabel">登录</h4>
		      </div>
		      <div class="modal-body">
					
					<!-- 登陆文本框 -->
					<form class="form-horizontal">
					  <div class="form-group">
					    <label for="inputEmail3" class="col-sm-2 control-label">用户名:</label>
					    <div class="col-sm-10">
					      <input type="email" class="form-control" id="inputEmail3" placeholder="Email">
					    </div>
					  </div>
					  <div class="form-group">
					    <label for="inputPassword3" class="col-sm-2 control-label">密码:</label>
					    <div class="col-sm-10">
					      <input type="password" class="form-control" id="inputPassword3" placeholder="Password">
					    </div>
					  </div>
					  
					 
					</form>
					
		      </div>
		      <div class="modal-footer">
				
				<div class="text-center">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		        	<button type="button" class="btn btn-primary">登录</button>
		        </div>
		        
		        <span id="qqLoginBtn" class="text-right" style="height: 100%;widows: 100%"></span>
		        
		      </div>
		    </div>
		  </div>
		</div>
    </div>
    
   
  </body>
</html>
