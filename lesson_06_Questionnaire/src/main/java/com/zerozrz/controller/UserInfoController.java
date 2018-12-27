package com.zerozrz.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zerozrz.bean.Msg;
import com.zerozrz.bean.UserInfo;
import com.zerozrz.bean.UserRecharge;
import com.zerozrz.service.UserInfoService;
import com.zerozrz.utils.MD5;

@Controller
@RequestMapping("/userInfo")
public class UserInfoController {

	@Autowired
	private UserInfoService userInfoService;
	
	/**
	 * 用户充值成功后我们，
	 * 1、更新用户的级别
	 * 2、同时用户充值记录表中保存数据
	 */
	@RequestMapping("/paySuccess")
	@ResponseBody
	public void paySuccess(UserInfo user,UserRecharge re,HttpSession session){
		user.setUserLevel(1);//将用户级别设置为VIP1
		System.out.println("接收到的user:"+user);
		
		//设置订单的创建时间
		Date d = new java.sql.Date(new Date().getTime());  
		re.setRechargeTime(d);
		
		System.out.println("接收到的充值记录："+re);
		
		userInfoService.updateAndSaveUR(user,re);
		
		//更新用户成功后，我们查询出刚刚更新的用户并且保存到session中
		getUserById(user,session);
	}
	
	/**
	 * 在session中清除user的值
	 * @param session
	 */
	@RequestMapping("/clearUserSession")
	@ResponseBody
	public void clearUserSession(HttpSession session){
		session.setAttribute("user", null);
	}
	
	/**
	 * 由于用户在输入框
	 * 检查用户唯一性，此用户名是否被创建过
	 */
	@RequestMapping("/checkUserNameUn")
	@ResponseBody
	public Msg checkUserUn(UserInfo user){
		System.out.println("前台获取注册的userName信息为："+user);
		//先判断用户名是否是合法的表达式
		String regx = "(^[a-zA-Z0-9_-]{6,16})|(^[\u2E80-\u9FFF]{2,5})";
		if(!user.getUserName().matches(regx)){
			return Msg.fail().add("va_msg","用户名必须是6-16位数字和字母的组合或者2-5位中文");
		}
		
		//数据库用户名重复校验
		UserInfo u = userInfoService.selectByUserName(user.getUserName());
		
		if(u==null){
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "用户名已经被使用");
		}
				
	}
	
	/**
	 * 注册
	 * 1、使用JSR303校验每一条数据
	 * 2、校验成功之后再保存
	 * @return
	 */
	@RequestMapping("/register")
	@ResponseBody
	public Msg register(@Valid UserInfo user,BindingResult result){
		System.out.println("前台获取注册的user信息为："+user);
		
		//是否存在错误信息
		if(result.hasErrors()){
			Map<String, Object> map = new HashMap<String, Object>();
			
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors){
				System.out.println("错误的字段名："+fieldError.getField());
				System.out.println("错误信息："+fieldError.getDefaultMessage());
				
				//校验时，每有一个不通过，就将错误信息添加到map中
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			
			return Msg.fail().add("errorFields", map);
		}else {
			//若没有存在错误信息，开始进行保存操作
			
			//更新用户状态为登录
			user.setUserStatus(1);
			
			//设置用户等级为普通用户
			user.setUserLevel(0);
			
			//设置用户创建时间
			Date d = new java.sql.Date(new Date().getTime());  
			System.out.println("当前的时间为："+d);
			user.setUserCreatetime(d);
			
			//用户密码采用盐值加密
			String s = MD5.encryptPassword(user.getUserPassword(), user.getUserName());//加密的数据，和盐值
			user.setUserPassword(s);
			
			userInfoService.saveOrUpdate(user);//保存
			
			return Msg.success();
		}
		
	}
	
	/**
	 * 通过用户id获取user，主要是做记住登录做的这一步，所以还需要把user
	 * 信息存在session中
	 */
	@RequestMapping("/getUserById")
	@ResponseBody
	public Msg getUserById(UserInfo user,HttpSession session){
		System.out.println("前台获取有id的user信息为："+user);
		
		UserInfo userData = userInfoService.selectById(user.getUserId());
		
		if(userData==null){
			return Msg.fail().add("error_user", "用户不存在");
		}
		
		//为了安全我们返回的user不包含密码
		userData.setUserPassword(null);
		
		//将用户信息存在session中
		session.setAttribute("user", userData);
		
		return Msg.success().add("user", userData);
	}
	/**
	 * 通过账号密码登录
	 */
	@RequestMapping("/login")
	@ResponseBody
	public Msg checkLogin(UserInfo user,HttpSession session){
		System.out.println("有账号密码的user信息为："+user);
		
		//1、根据用户名查询用户名是否存在，若用户名都不存在，直接返回eror的Msg
		UserInfo userData = userInfoService.selectByUserName(user.getUserName());
		
		if(userData==null){
			return Msg.fail().add("error_userName", "用户名不存在");
		}
		
		//用户输入的密码，采用盐值加密后和数据库中的密码进行对比
		String pswMD5 =MD5.encryptPassword(user.getUserPassword(), user.getUserName());//加密的数据，和盐值
		
		//2、比对用户名和密码和刚刚查询到的用户是否一致，若不存在，返回error的Msg
		if((userData.getUserName().equals(user.getUserName()) && userData.getUserPassword().equals(pswMD5))==false){
			return Msg.fail().add("error_userPassword", "密码有误");
		}
		
		//3、若存在，将用户id保存到session中，然后返回Msg
		//设置登录状态为1，登录
		userData.setUserStatus(1);
		//根据id保存其登录状态
		userInfoService.updateStatusById(userData);
		
		
		//为了安全我们返回的user不包含密码
		userData.setUserPassword(null);
		session.setAttribute("user", userData);
		
		return Msg.success().add("user", userData);
		
		
		
	}
	
	/**
	 * saveOrUpdate,qq登录用户的保存或者修改 
	 */
	@RequestMapping("/saveOrUpdateByQQ")
	@ResponseBody
	public String saveOrUpdate(UserInfo user,HttpSession session){
		System.out.println("获取到的user信息为："+user);
		
		//先判断之前有没有保存过此qq，保存过的话返回用户id，没有的话返回null
		UserInfo uo = userInfoService.getUserByOpenId(user.getQqOpenid());
		if(uo!=null){
			user.setUserId(uo.getUserId());
		}
		
		
		if(user.getUserId()==null){//新增
			//设置用户昵称，默认等同于qq昵称
			user.setUserNickname(user.getUserQqname());
			//设置登录状态，刚刚保存的我们都默认为登录状态
			user.setUserStatus(1);
			//设置用户级别
			user.setUserLevel(0);
			//设置用户的创建时间
			Date d = new java.sql.Date(new Date().getTime());  
			System.out.println("当前的时间为："+d);
			user.setUserCreatetime(d);
			userInfoService.saveOrUpdate(user);//保存
			
		}else {//修改
			//设置用户昵称，默认等同于qq昵称
			user.setUserNickname(user.getUserQqname());
			//设置登录状态，刚刚保存的我们都默认为登录状态
			user.setUserStatus(1);
			
			userInfoService.updateById(user);//修改
		}
		
		/**
		 * 	当qq用户登录保存信息后，我们根据openid，
		 * 	查询这个user的信息，放到session中
		 * 
		 */
		UserInfo u = userInfoService.getUserByOpenId(user.getQqOpenid());
		
		//为了安全我们返回的user不包含密码
		u.setUserPassword(null);
		session.setAttribute("user", u);
		
		
		return "1";
	}
	
	
}
