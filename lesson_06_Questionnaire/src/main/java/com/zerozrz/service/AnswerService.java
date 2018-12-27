package com.zerozrz.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zerozrz.bean.Answer;
import com.zerozrz.bean.AnswerExample;
import com.zerozrz.bean.Reply;
import com.zerozrz.bean.ReplyExample;
import com.zerozrz.bean.ReplyExample.Criteria;
import com.zerozrz.bean.Survey;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.dao.AnswerMapper;
import com.zerozrz.dao.ReplyMapper;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Service
public class AnswerService {
	
	@Autowired
	private AnswerMapper answerMapper;
	
	@Autowired
	private ReplyMapper replyMapper; 

	/**
	 * 保存答卷，和答卷每题情况表
	 * @param object
	 */
	public void insertAR(Object object) {
		
		/*
		 * 1、解析得到保存的答卷基本信息
		 */
		JsonConfig config  = new JsonConfig();
		config.setExcludes(new String[]{"questionList"});//排除掉不需要转换的json键值对
		
		//将json字符串转为json对象
		JSONObject jsonObject = JSONObject.fromObject(object,config);
		//System.out.println("转换后的json为："+jsonObject.toString());
		
		//将字符串的时间类型转为Date类型
		//指定时间格式
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Date start = null;
		Date end = null;
		
		Answer answer = new Answer();
		answer.setSurveyId(Integer.parseInt(jsonObject.get("surveyId").toString()));
		answer.setUserId(Integer.parseInt(jsonObject.get("surveyId").toString()));
		
		try {
			start = sdf.parse(jsonObject.getString("answerStart"));
			end = sdf.parse(jsonObject.getString("answerEnd"));
			
			//把时间赋值给answer
			answer.setAnswerStart(start);
			answer.setAnswerEnd(end);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		System.out.println("得到的答卷为："+answer.toString());
		
		//设置答卷所用的时间
		long from = answer.getAnswerStart().getTime();
		long to = answer.getAnswerEnd().getTime();
		
		//我们取试卷用时的时候，使用当前值减去1970-01-01 08:00:00就能得到用户作答的时间
		Date d = new java.sql.Date(to-from); 
		answer.setAnswerUsedtime(d);
		
		
		//保存答卷
		answerMapper.insertSelective(answer);
		
		/*
		 * 2、遍历解析得到每题情况的基本信息
		 */
		JSONObject jsonObject2 = JSONObject.fromObject(object);
		Object s = jsonObject2.get("questionList");//题目数组
		
		//2.1遍历题目
		JSONArray jsonArray = JSONArray.fromObject(s);
		for(int i=0 ;i<jsonArray.size();i++){
			
			//将json字符串转为json对象
			JSONObject jsonObject3 = JSONObject.fromObject(jsonArray.get(i));
			
			Reply reply = (Reply) JSONObject.toBean(jsonObject3,Reply.class);
			
			//设置每一题所属的答卷id
			reply.setAnswerId(answer.getAnswerId());
			
			//保存答题每题情况表
			replyMapper.insertSelective(reply);
		}
	}

	/**
	 * 先根据题目id，和答卷id查询reply
	 * @param questionId
	 * @param answerId
	 * @return
	 */
	public Reply getUserAnswerByQidTypeIdAId(Integer questionId, Integer answerId) {
		
		ReplyExample re = new ReplyExample();
		Criteria c = re.createCriteria();
		c.andAnswerIdEqualTo(answerId);
		c.andQuestionIdEqualTo(questionId);
		
		return replyMapper.selectByExample(re).get(0);
	}

	/**
	 * 根据id查询答卷
	 * @param answerId
	 * @return
	 */
	public Answer getByQuestionId(Integer answerId) {
		System.out.println("当前的答卷id为："+answerId);
		AnswerExample re = new AnswerExample();
		com.zerozrz.bean.AnswerExample.Criteria c = re.createCriteria();
		c.andAnswerIdEqualTo(answerId);
		
		return answerMapper.selectByExample(re).get(0);
	}

	/**
	 * 根据问卷id，答卷id获取上一页答卷的id
	 * 
	 * SELECT * FROM t_news AS n WHERE n.`News_ID` < 4 ORDER BY n.`News_ID` DESC  LIMIT 0,1;  
	 * @return
	 */
	public Integer selectPreById(Integer surveyId, Integer answerId) {
		AnswerExample re = new AnswerExample();
		re.setOrderByClause("answer_id DESC");
		re.setStartRow(0);
		re.setPageSize(1);
		com.zerozrz.bean.AnswerExample.Criteria c = re.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		c.andAnswerIdLessThan(answerId);
		
		if(answerMapper.selectByExample(re).size()==0){//如果不存在上一页的值就返回本身
			return answerId;
		}else{
			return answerMapper.selectByExample(re).get(0).getAnswerId();
		}
		
	}

	/**
	 * 根据问卷id，答卷id获取下一页答卷的id
	 * 
	 *   SELECT * FROM t_news AS n WHERE n.`News_ID` > 4 ORDER BY n.`News_ID` LIMIT 0,1;  
	 * @return
	 */
	public Integer selectNextById(Integer surveyId, Integer answerId) {
		AnswerExample re = new AnswerExample();
		re.setOrderByClause("answer_id");
		re.setStartRow(0);
		re.setPageSize(1);
		com.zerozrz.bean.AnswerExample.Criteria c = re.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		c.andAnswerIdGreaterThan(answerId);
		
		if(answerMapper.selectByExample(re).size()==0){//如果不存在下一页的值就返回本身
			return answerId;
		}else{
			return answerMapper.selectByExample(re).get(0).getAnswerId();
		}
	}

	/**
	 * 根据问卷id查询所有的答卷
	 * @param surveyId
	 * @return
	 */
	public List<Answer> getListBySurveyId(Integer surveyId) {
		AnswerExample re = new AnswerExample();
		com.zerozrz.bean.AnswerExample.Criteria c = re.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		return answerMapper.selectByExample(re);
	}

	/**
	 * 根据问卷id删除所有答卷
	 * @param answerId
	 */
	public void removeBySurveyId(Integer surveyId) {
		AnswerExample re = new AnswerExample();
		com.zerozrz.bean.AnswerExample.Criteria c = re.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		
		answerMapper.deleteByExample(re);
	}

	/**
	 * 查询第一份答卷
	 * @param surveyId 
	 * @return
	 */
	public Answer selectFirst(Integer surveyId) {
		AnswerExample re = new AnswerExample();
		re.setOrderByClause("answer_id DESC");
		com.zerozrz.bean.AnswerExample.Criteria c = re.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		
		return answerMapper.selectByExample(re).get(0);
		
	}

	
	
	
}
