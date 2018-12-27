package com.zerozrz.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zerozrz.bean.UserInfo;
import com.zerozrz.bean.UserInfoExample;
import com.zerozrz.bean.UserInfoExample.Criteria;
import com.zerozrz.bean.UserRecharge;
import com.zerozrz.dao.UserInfoMapper;
import com.zerozrz.dao.UserRechargeMapper;

@Service
public class UserInfoService {

	@Autowired
	private UserInfoMapper userInfoMapper;
	
	@Autowired
	private UserRechargeMapper userRechargeMapper;

	/**
	 * 保存或者更新user
	 * @param user
	 */
	public void saveOrUpdate(UserInfo user) {
		userInfoMapper.insertSelective(user);
	}

	//根据openid查询用户的id
	public UserInfo getUserByOpenId(String qqOpenid) {
		
		UserInfoExample u = new UserInfoExample();
		Criteria c = u.createCriteria();
		c.andQqOpenidEqualTo(qqOpenid);
		
		List<UserInfo> uList = userInfoMapper.selectByExample(u);
		System.out.println("查询到的集合为:"+uList);
		
		if(uList.size()!=0){//查询到返回整个user
			return uList.get(0);
		}
		
		return null;
	}

	/**
	 * 根据id修改
	 * @param user
	 */
	public void updateById(UserInfo user) {
		UserInfoExample u = new UserInfoExample();
		Criteria c = u.createCriteria();
		c.andUserIdEqualTo(user.getUserId());
		
		userInfoMapper.updateByExampleSelective(user, u);
	}

	/**
	 * 根据用户名返回用户
	 * @param userName
	 * @return
	 */
	public UserInfo selectByUserName(String userName) {
		UserInfoExample u = new UserInfoExample();
		Criteria c = u.createCriteria();
		c.andUserNameEqualTo(userName);
		
		List<UserInfo> uList = userInfoMapper.selectByExample(u);
		
		if(uList.size()!=0){//查询到就返回整个user
			return uList.get(0);
		}
		
		return null;
	}

	

	/**
	 * 根据用户id跟新
	 * @param userId
	 */
	public void updateStatusById(UserInfo userData) {
		
		UserInfoExample u = new UserInfoExample();
		Criteria c = u.createCriteria();
		c.andUserIdEqualTo(userData.getUserId());
		
		userInfoMapper.updateByExampleSelective(userData, u);
	}
	/**
	 * 根据id返回user
	 * @param userId
	 * @return
	 */
	public UserInfo selectById(Integer userId) {
		UserInfoExample u = new UserInfoExample();
		Criteria c = u.createCriteria();
		c.andUserIdEqualTo(userId);
		
		List<UserInfo> uList = userInfoMapper.selectByExample(u);
		
		if(uList.size()!=0){//查询到就返回整个user
			return uList.get(0);
		}
		
		return null;
	}
	
	/***
	 * 
	 * 1、更新用户的级别
	 * 2、同时用户充值记录表中保存数据
	 */
	public void updateAndSaveUR(UserInfo user, UserRecharge re) {
		UserInfoExample u = new UserInfoExample();
		Criteria c = u.createCriteria();
		c.andUserIdEqualTo(user.getUserId());
		
		userInfoMapper.updateByExampleSelective(user, u);//更新用户级别
		
		userRechargeMapper.insertSelective(re);//新增用户充值记录
		
	}
	

	
	
	
	
}
