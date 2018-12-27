<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'qqBack.jsp' starting page</title>
    
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
	
	<script type="text/javascript"  charset="utf-8"
	    src="http://connect.qq.com/qc_jssdk.js" 
	    data-appid="101507637" 
	    data-redirecturi="http://questionnaire.zerozrz.com/qq/qq.jsp" >
	</script>
	
	
	<script type="text/javascript">
		
		QC.Login({
		       //btnId：插入按钮的节点id，必选
		       btnId:"qqLoginBtn",	
		       //用户需要确认的scope授权项，可选，默认all
		       scope:"all",
		       //按钮尺寸，可用值[A_XL| A_L| A_M| A_S|  B_M| B_S| C_S]，可选，默认B_S
		       size: "A_L"
		   }, function(reqData, opts){//登录成功
		       //根据返回数据，更换按钮显示状态方法
		       var dom = document.getElementById(opts['btnId']),
		       _logoutTemplate=[
		            //头像
		            '<span><img src="{figureurl}" class="{size_key}"/></span>',
		            //昵称
		            '<span>{nickname}</span>',
		            //退出
		            '<span><a href="javascript:QC.Login.signOut();">退出</a></span>'	
		                     ].join("");
		       dom && (dom.innerHTML = QC.String.format(_logoutTemplate, {
		           nickname : QC.String.escHTML(reqData.nickname),
		           figureurl : reqData.figureurl
		              }));
		   }, function(opts){//注销成功
				alert('QQ登录 注销成功');
		
		                  }
		);
		
		/*登录成功的回调函数*/
		/*
			回调函数的参数如下: 
			oInfo：{
		        "ret":0,
		        "msg":"",
		        "nickname":"遲來の垨堠",
		        "figureurl":"http://qzapp.qlogo.cn/qzapp/100229030/ECCC463F76A2E3C1D9217BBC30418164/30",
		        "figureurl_1":"http://qzapp.qlogo.cn/qzapp/100229030/ECCC463F76A2E3C1D9217BBC30418164/50",
		        "figureurl_2":"http://qzapp.qlogo.cn/qzapp/100229030/ECCC463F76A2E3C1D9217BBC30418164/100",
		        "gender":"男",
		        "vip":"1",
		        "level":"7"
		      }
		       oOpts：回传初始化参数，多个按钮时可用来区分来源，用来区分一个页面多个登录按钮的情况。
		*/
		/* QC.Login({btnId:"qqLoginBtn"}, function(oInfo, oOpts){
		     
		   alert(oInfo.nickname+"-"+oInfo.gender+"图片地址为"+oInfo.figureurl);
		  
		  //获取当前登录用户的Access Token以及OpenID
		  QC.Login.getMe(function(openId, accessToken){
		  	alert(openId);
		  });
		}); */
		
		
	</script>
	
  </head>
  
  <body style="margin: 0px;padding: 0px; height: 100%;widows: 100%">
    <span id="qqLoginBtn" style="height: 100%;widows: 100%">QQ登录</span>
	<!-- <script type="text/javascript">
	    QC.Login({
	       btnId:"qqLoginBtn"    //插入按钮的节点id
	});
	</script> -->
  </body>
</html>
