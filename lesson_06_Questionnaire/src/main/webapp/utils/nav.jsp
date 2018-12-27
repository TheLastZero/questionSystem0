<%@page import="com.zerozrz.bean.UserInfo"%>
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
		
		/**
			如果没有qq用户记住了登录状态，我们就检查用户是否记住了我们网站账户的登录状态
			有记住状态的用户我们就直接登录
		*/
		if(QC.Login.check()==false){//没有qq用户登录
				
			//先从session找是否有userId
			var userId = ${sessionScope.user.userId}+"";	
			if(userId==0){//表示session中没有值，我们再去查cookie中的值
				//检查用户的cookie是否记住了登录
				userId = $.cookie("userId");
			} 
			if(userId!=undefined && userId!="null"){//记住了登录
				
				$.ajax({
		    			url:"${pageContext.request.contextPath}/userInfo/getUserById",
		    			type:"POST",
		    			data:"userId="+userId,
		    			success:function(result){
		    				console.log(result);
		    				
		    				if(result.code==200){//200表示处理失败
		    					//这里处理失败的原因只有，当前id没有查询到用户，不用做任何处理
   					
		    				}else{//100表示处理成功
		    					$("#loginBtn").hide();//隐藏登录按钮
		    					$("#loginAfter").show();//显示用户下拉框
									   			
						   		//先清空再添加
						   		$("#loginAfter button").empty();
						   		
						   		//下拉菜单标题
						   		$("#loginAfter button").append(
						            //昵称
						            '<span>'+result.extend.user.userNickname+'</span>'+
						            '<span class="caret"></span>');//倒三角图标
						        
						        //先清空再添加
						        $("#loginAfter li:eq(4)").empty();    
						        //下拉退出按钮
						        $("#loginAfter li:eq(4)").append(//退出
						         '<a href="javascript:QC.Login.signOut();" class="btn btn-danger">退出</a>');		
						         
		    				}
		    				
			   			}
					});
			}
			
		}
		
		/*
			***每次加载页面，或者点击qq登录时都会加载QC.Login方法
		*/
		QC.Login({
		       //btnId：插入按钮的节点id，必选
		       btnId:"qqLoginBtn",	
		       //用户需要确认的scope授权项，可选，默认all
		       scope:"all",
		       //按钮尺寸，可用值[A_XL| A_L| A_M| A_S|  B_M| B_S| C_S]，可选，默认B_S
		       size: "B_M"
		   }, function(reqData, opts){//登录成功
		   		//登录成功后关闭模态框
		   		$('#userLoginModal').modal('hide');
		   		$("#loginBtn").hide();//隐藏登录按钮
		   		$("#loginAfter").show();//显示用户下拉框
		   		
		   		
		   		//先清空再添加
		   		$("#loginAfter button").empty();
		   		
		   		//下拉菜单标题
		   		$("#loginAfter button").append(//头像
		            '<span><img src='+reqData.figureurl+' class="img-circle"/></span>'+
		            //昵称
		            '<span>'+reqData.nickname+'</span>'+
		            '<span class="caret"></span>');//倒三角图标
		        
		        //先清空再添加
		        $("#loginAfter li:eq(4)").empty();    
		        //下拉退出按钮
		        $("#loginAfter li:eq(4)").append(//退出
		         '<a href="javascript:QC.Login.signOut();" class="btn btn-danger">退出</a>');
		        
		        var qq_openId;
		        var qq_accessToken;
		       //获取当前登录用户的Access Token以及OpenID
				QC.Login.getMe(function(openId, accessToken){
				  
					  	qq_openId = openId;
					  	qq_accessToken = accessToken;
					  	
					/* 
				       	QQ登录流程
				       		1、发送ajax请求，保存用户登录信息，比对数据库中的OpenID信息，没有表示第一次登录则创建用户，保存用户的Access Token以及OpenID
				       		2、非第一次登录，就更新用户的登录状态，同时更新用户的Access Token(Access Token三个月qq会更新一次)
				       		3、重要：如果我们从新获取了QC.Login.getMe(function(openId, accessToken),那么保存值的操作一定要写在getMe()方法的方法体里面，否则会取不到值
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
				  	
				  });
		       
		   }, function(opts){//注销成功
				//alert('QQ登录 注销成功');
				//注销成功隐藏用户栏
				$("#loginAfter").hide();
				$("#loginBtn").show();//显示登录按钮
		
				//退出时，我们就删除原本如果存在的cookie，和session
				$.cookie('userId',null,{ expires: -1,path:'/'});
				
				//退出时把session中的user清空
				$.ajax({
					url:"${pageContext.request.contextPath}/userInfo/clearUserSession",
					type:"GET"
				});
				
				//按理来说在这里也应该发送ajax请求将用户的登录状态改为0，
				//但是由于后面都没有使用到登录状态来判定用户是否登录，所以我们暂时就不发送了
		   }
		);
		
		/**
			当弹出模态框按钮被点击时
			1、我们清除模态框中的所有的input的成功失败样式，注意要除去qq的样式，否则qq登录图标就没有了
			2、同时也清除所有的提示信息
			3、并且同时清除所有文本框中的内容
			4、显示登陆form，隐藏注册form
			5、注册选项卡移除被选中样式，登录选项卡添加被选中样式
			6、在模态框底部隐藏注册按钮,切换为登录的按钮
		*/
		$("#loginBtn").click(function(){
			$("#userLoginModal div").removeClass("has-success has-error");
			$("#userLoginModal span:not(#qqLoginBtn)").text("");
			
			$("#userLoginModal form")[0].reset();
			$("#userLoginModal form")[1].reset();
			
			$("#loginForm").show();
			$("#registerForm").hide();
			
			
			$("#registerModel").parent().removeClass("active");
			$("#loginModel").parent().addClass("active");
			
			
			$("#userRegisterButton").hide();
			$("#userLoginButton").show();
		});
		
		/*
			***点击切换登录注册按钮
		*/
		//切换注册按钮被点击时
		$("#registerModel").click(function(){
			
			//1、登录选项卡移除li被选中样式，注册选项卡添加被选中样式
			$("#loginModel").parent().removeClass("active");
			$("#registerModel").parent().addClass("active");
			
			//1.1移除登录模态框中所有div的成功失败样式，清空span中文字
			$("#loginForm div").removeClass("has-success has-error");
			$("#loginForm span").text("");
			
			//2、重置注册表单数据
			$("#registerForm")[0].reset();
			
			//3、在modal-body中显示注册模块的代码，隐藏登录的form
			$("#registerForm").show();
			$("#loginForm").hide();
			
			//4、在模态框底部隐藏登录按钮,切换为注册的按钮，
			$("#userLoginButton").hide();
			$("#userRegisterButton").show();
			
			
			return false;
		});
		
		//切换登录按钮被点击时
		$("#loginModel").click(function(){
			
			//1、注册选项卡移除被选中样式，登录选项卡添加被选中样式
			$("#registerModel").parent().removeClass("active");
			$("#loginModel").parent().addClass("active");
			
			//1.1移除注册模态框中所有div的成功失败样式，清空span中文字
			$("#registerForm div").removeClass("has-success has-error");
			$("#registerForm span").text("");
			
			//2、重置登录表单数据
			$("#loginForm")[0].reset();
			
			//3、在modal-body中显示登录模块的代码，隐藏注册的代码
			$("#loginForm").show();
			$("#registerForm").hide();
			
			//4、在模态框底部隐藏注册按钮,切换为登录的按钮，
			$("#userRegisterButton").hide();
			$("#userLoginButton").show();
			
			return false;
		});
		
		
		/**
			***显示校验结果的提示信息
		*/
    	function show_validate_msg(ele,status,msg){
    		
    		//清除当前元素的校验状态
    		$(ele).parent().parent().removeClass("has-success has-error");
    		$(ele).next("span").text("");
    		
    		if("success"==status){
    			
    			$(ele).parent().parent().addClass("has-success");
				$(ele).next("span").text(msg);
    			
    		}else if("error" == status){
    			$(ele).parent().parent().addClass("has-error");
				$(ele).next("span").text(msg);
    		}
    		
    	}
		
		/*提交登录表单方法*/
		function submitLogin(){
			$.ajax({
    			url:"${pageContext.request.contextPath}/userInfo/login",
    			type:"POST",
    			data:$("#loginForm").serialize(),//序列化表单数据
    			success:function(result){
    				console.log(result);
    				
    				if(result.code==200){//200表示处理失败
    					
    					//用户名验证失败
   						if(result.extend.error_userName!=undefined){	
   							show_validate_msg("#userName","error",result.extend.error_userName);
   							
   							return false;
   						}
   						
   						//密码验证失败
   						if(result.extend.error_userPassword!=undefined){	
   							show_validate_msg("#userPassword","error",result.extend.error_userPassword);
   							return false;
   						}
   						
    				}else{//100表示处理成功
    					
    					//用户是否选中记住登录
    					var isRemember = $("#isRemember").is(":checked");
    					
    					//清除记住登录
    					$("#isRemember").prop("checked",false);
    					
    					//清除span的值
    					show_validate_msg("#userName","success","");
    					show_validate_msg("#userPassword","success","");
    					
    					//登录成功清除的样式
    					$("#userName").parent().parent().removeClass("has-success has-error");
    					$("#userPassword").parent().parent().removeClass("has-success has-error");
    					//清除文本内容
    					$("#userName").val("");
    					$("#userPassword").val("");
						
						
						//登录成功后关闭模态框
				   		$('#userLoginModal').modal('hide');
				   		$("#loginBtn").hide();//隐藏登录按钮
				   		$("#loginAfter").show();//显示用户下拉框
				   		
				   		
				   		//先清空再添加
				   		$("#loginAfter button").empty();
				   		
				   		//下拉菜单标题
				   		$("#loginAfter button").append(
				            //昵称
				            '<span>'+result.extend.user.userNickname+'</span>'+
				            '<span class="caret"></span>');//倒三角图标
				        
				        //先清空再添加
				        $("#loginAfter li:eq(4)").empty();    
				        //下拉退出按钮
				        $("#loginAfter li:eq(4)").append(//退出
				         '<a href="javascript:QC.Login.signOut();" class="btn btn-danger">退出</a>');
						
						
						/**
							登录成功之后判断用户是否选择了，记住登录状态
						*/
						//如果是记住登录，我们创建cookie信息来保存此用户的id
						if(isRemember==true){
							//记录cookie的值，可以用作单点登录  
							//expires表示cookie需要存几天
						    $.cookie('userId',result.extend.user.userId, { expires:7,path:'/'});
						}else{
						    //未记住登录时我们在session范围做单点登录，因为在登录时后台会把值存进session中
						    //所以这里也不用做操作了
						} 
								
    				}
    				
    			}
    		});
		}
		
		/*
			***点击登录提交按钮			
		*/
		$("#submitLogin").click(function(){
			
			submitLogin();
			
		});
		
		//当注册框form中用户名文本改变的时候，也去调用检查此用户名是否被创建过的方法，
		$("#registerUserName").keyup(function(){
			$.ajax({
	    			url:"${pageContext.request.contextPath}/userInfo/checkUserNameUn",
	    			type:"POST",
	    			data:$("#registerForm").serialize(),//序列化表单数据
	    			success:function(result){
	    				console.log(result);
    				
	    				if(result.code==100){
	    					show_validate_msg("#registerUserName","success","用户名可用");
	    					//ajax-va表示的是校验之后成功失败的状态，在提交时可以用来判断是否真正要提交
	    					$("#registerUserName").attr("ajax-va","success");
	    				}else{
	    				
	    					show_validate_msg("#registerUserName","error",result.extend.va_msg);
	    					$("#registerUserName").attr("ajax-va","error");
	    				}
	    			}
    			});
		});
		
		/*
			***点击注册提交按钮
		*/
		$("#submitRegister").click(function(){
			
				$.ajax({
	    			url:"${pageContext.request.contextPath}/userInfo/register",
	    			type:"POST",
	    			data:$("#registerForm").serialize(),//序列化表单数据
	    			success:function(result){
	    				console.log(result);
    				    
	    				if(result.code==200){//200表示处理失败
	    					//显示失败信息
	    					//有那个字段的错误信息就显示哪个字段的：
	    					
	    					if(undefined != result.extend.errorFields.userName){
	    						//显示用户错误信息
	    						show_validate_msg("#registerUserName","error",result.extend.errorFields.userName);
	    					}else{//成功
	    						show_validate_msg("#registerUserName","success","用户名可用");
	    					}
	    					
	    					if(undefined != result.extend.errorFields.userPassword){
	    						//显示密码错误信息
	    						show_validate_msg("#registerUserPassword","error",result.extend.errorFields.userPassword);
	    					}else{
	    						show_validate_msg("#registerUserPassword","success","");
	    					} 
	    					
	    					if(undefined != result.extend.errorFields.userNickname){
	    						//显示昵称错误信息
	    						show_validate_msg("#registerUserNickname","error",result.extend.errorFields.userNickname);
	    					}else{
	    						show_validate_msg("#registerUserNickname","success","");
	    					}
		    					
		   						
	    				}else{//100表示处理成功
	    					
	    					//alert("校验成功");
	    					//1、校验成功后关闭模态框
	    					$('#userLoginModal').modal('hide');
	    					
	    					//2、模拟登陆，在登录表单中的值设置为，注册表单中的值进行登录
	    					$("#userName").val($("#registerUserName").val());
	    					$("#userPassword").val($("#registerUserPassword").val());
	    					
	    					//调用表单登录方法
	    					submitLogin();
	    					
	    				}
    				}
    			});
			
		});
		
	});
	
	</script>

  </head>
  
  <body style="margin: 0px;padding: 0px; ">
    <div id="nav" style="height: 50px; background-color: #222">
    	<div class="row" style="width: 100%;color: #fff;">
    		<div class="col-md-6">
    			
    			<a class="navbar-brand" style="color:#bbb;" href="${pageContext.request.contextPath }/index.jsp">
    				<span class="glyphicon glyphicon-home" aria-hidden="true"></span>
    				Home
    			</a>
				
    		</div>
    		<div class="col-md-2 col-md-offset-4">
    			<!-- 登录注册模态框按钮 -->
		    	<!-- Button trigger modal -->
				<button type="button" style="background: none;" id="loginBtn" class="btn navbar-brand" data-toggle="modal" data-target="#userLoginModal">
				
				<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
				 登录使用
				</button>
				
    			<!-- 登录成功后的按钮下拉框 -->
    			<div class="btn-group navbar-brand" style="display: none;" id="loginAfter">
				  <button type="button" style="background: none;border:none;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    
				  </button>
				  <ul class="dropdown-menu">
				    <li><a href="#">---</a></li>
				    <li><a href="${pageContext.request.contextPath }/survey/suevryHome.jsp">问卷管理</a></li>
				    <li><a href="#">---</a></li>
				    <li role="separator" class="divider"></li>
				    <li></li>
				  </ul>
				</div>
    		</div>
     </div>
    	
		<!-- 用户登录模态框 -->
		<!-- Modal -->
		<div class="modal fade" id="userLoginModal" tabindex="-1" role="dialog" aria-labelledby="userLoginModalLabel">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <!-- <div class="modal-header"> -->
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        
		        <ul class="nav nav-tabs">
				  <li role="presentation" class="active"><a href="" id="loginModel">登录</a></li>
				  <li role="presentation"><a href="" id="registerModel">注册</a></li>
				</ul>
		      <!-- </div> -->
		      <div class="modal-body">
					
					<!-- 登陆form -->
					<form class="form-horizontal" id="loginForm">
						
						  <div class="form-group">
						    <label for="inputEmail3" class="col-sm-2 control-label">用户名:</label>
						    <div class="col-sm-10">
						      <input name="userName" class="form-control" id="userName" placeholder="用户名">
						      <span id="helpBlock2" class="help-block"></span>
						    </div>
						  </div>
						  
						  <div class="form-group">
						    <label for="inputPassword3" class="col-sm-2 control-label">密码:</label>
						    <div class="col-sm-10">
						      <input name="userPassword" type="password" class="form-control" id="userPassword" placeholder="Password">
						      <span id="helpBlock2" class="help-block"></span>
						    </div>
						  </div>
						  
						  <div class="row">
							<div class="checkbox text-center">
								    <label>
								      <input type="checkbox" id="isRemember">记住登录
								    </label>
							</div>	
						  </div>
						  
					</form>
					
					<!-- 注册form -->
					<form class="form-horizontal" id="registerForm" style="display: none;">
						
						  <div class="form-group">
						    <label for="exampleInputName2" class="col-sm-2 control-label">用户名:</label>
						    <div class="col-sm-10">
						      <input name="userName" class="form-control" id="registerUserName" placeholder="用户名必须是6-16位数字和字母的组合或者2-5位中文">
						      <span class="help-block"></span>
						    </div>
						  </div>
						  
						  <div class="form-group">
						    <label for="inputPassword3" class="col-sm-2 control-label">密码:</label>
						    <div class="col-sm-10">
						      <input name="userPassword" type="password" class="form-control" id="registerUserPassword" placeholder="密码长度在3-20位之间">
						      <span class="help-block"></span>
						    </div>
						  </div>
						  
						  <div class="form-group">
						    <label for="exampleInputName2" class="col-sm-2 control-label">用户昵称:</label>
						    <div class="col-sm-10">
						      <input name="userNickname" class="form-control" id="registerUserNickname" placeholder="社交名字，随便写什么都可以啦(*^▽^*)">
						      <span class="help-block"></span>
						    </div>
						  </div>
						  
						  <div class="form-group">
						    <label for="exampleInputName2" class="col-sm-2 control-label">性别:</label>
						    <div class="col-sm-10">
							    <label class="radio-inline">
								  <input type="radio" name="userSex" id="inlineRadio1" value="男" checked="checked"> 男
								</label>
								<label class="radio-inline">
								  <input type="radio" name="userSex" id="inlineRadio2" value="女"> 女
								</label>
						      
						    </div>
						  </div>
						 
						
						  
					</form>
					
		      </div>
		      <div class="modal-footer">
				
				<!-- 登录模块时按钮 -->
				<div class="row" id="userLoginButton">
					<div class="col-md-offset-4 col-md-4  text-center">
			        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			        	<button id="submitLogin" type="button" class="btn btn-primary">登录</button>
			        </div>
			        <div class="col-md-4 text-right" style="margin-top: 5px">
                            <span id="qqLoginBtn" class="text-right" style="widows: 100%;"></span>
                    </div>
			        
		        </div>
		        
		        <!-- 注册模块时按钮 -->
		        <div class="row" id="userRegisterButton" style="display: none;">
					<div class="text-center">
			        	<button id="submitRegister"  type="button" style="width: 50%" class="btn btn-info">注册</button>
			        </div>
			        <br>
			        <div class="text-center">
			        	<button type="button" style="width: 50%" class="btn btn-default" data-dismiss="modal">关闭</button>
			        </div>
		        </div>
		        
		        
		      </div>
		    </div>
		  </div>
		</div>
    </div>
    
   
  </body>
</html>
