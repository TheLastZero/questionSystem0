<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'pay.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<!-- 引入支付组件 -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/pay9n/pay9n_md5.js"></script>
    <script src="http://www.9npay.com/Js/pay.js"></script>
    
    <script type="text/javascript">
    
	    $(document).ready(function(){
	    	
	    	
	    	function S4() {
		        return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
		    }
		    function guid() {
		        return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
		    }
	    	
	    
	    	var data = '{"pay_title":"1块钱体验vip","total_fee":1,"order_no":"'+guid()+'","remark":"成为VIP之后方可以享用评分条组件"}';
			pay_9n.shows_qr({
				appid: '100623',//APP_ID 在后台——支付配置 中查看
				data: data, //支付用户
				sign: md5(data+"&28cb77c584ed201f6051a1bb7d7c83c0"),//签名md5(data&你的秘钥)
				//way: ['H5', 'http://www.9napy.com'], //支付方式qr/H5,第二个为跳转参数
				//pay_type:'alipay',//pay_type表示微信、支付宝，weixin:微信，alipay:支付宝 （默认微信、支付宝全开）
				success:function(data){
					console.log(data);
					
					//支付成功后返回,你也可以在这里ajax更新网站订单,安全性自己处理,也可以使用异步回调
					
					alert(data.msg);
					
					//将信息保存到用户充值记录表中，并且更新用户的级别
					 $.ajax({
						url:"${pageContext.request.contextPath}/userInfo/paySuccess",
						type:"POST",
						data:"userId="+"${sessionScope.user.userId}"+
							"&rechargeMoney="+1+
							"&rechargeType="+"VIP"+
							"&rechargeExplain="+"1块钱体验VIP活动",
						success:function(){
							//支付保存成功后刷新父窗口并且关闭本身
							refreshParent();
						}
					});  
					
				}
			});
			
			 //刷新父窗口并且关闭本身
			 function refreshParent() {
			  window.opener.location.href = window.opener.location.href;
			  window.close();  
			 }   
			 
	    });
    
    	
    </script>
    
  </head>
  
  <body>
    
  </body>
</html>
