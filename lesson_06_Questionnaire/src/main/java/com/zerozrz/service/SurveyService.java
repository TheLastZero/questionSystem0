package com.zerozrz.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zerozrz.bean.Answer;
import com.zerozrz.bean.Survey;
import com.zerozrz.bean.SurveyExample;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.bean.SurveyQuestionExample;
import com.zerozrz.bean.SurveyExample.Criteria;
import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyOptionExample;
import com.zerozrz.dao.SurveyMapper;
import com.zerozrz.dao.SurveyOptionMapper;
import com.zerozrz.dao.SurveyQuestionMapper;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Service
public class SurveyService {

	@Autowired
	private SurveyMapper surveyMapper;
	
	@Autowired
	private SurveyQuestionMapper surveyQuestionMapper;
	
	@Autowired
	private SurveyOptionMapper SurveyOptionMapper;

	@Autowired
	private SurveyQuestionService surveyQuestionService;
	
	@Autowired
	private SurveyOptionService surveyOptionService;
	
	@Autowired
	private AnswerService answerService;
	
	@Autowired
	private ReplyService replyService;
	
	public List<Survey> getPageListByStatus(Integer surveyStatus,String surveyName, Integer userId) {
		
		SurveyExample s = new SurveyExample();
		Criteria c = s.createCriteria();
		c.andUserIdEqualTo(userId);//用户id必须作为查询条件
		
		if(!surveyName.equals("-1")){//不等于-1表示，此时问卷名字也需要作为查询条件
			c.andSurveyNameLike("%"+surveyName+"%");
		}
		
		if(surveyStatus==-1){//-1表示查询全部直接返回，但是唯独不包括删除状态的问卷
			c.andSurveyStatusNotEqualTo(3);
			return surveyMapper.selectByExample(s);
		}
		
		//有状态的话按照状态查询
		c.andSurveyStatusEqualTo(surveyStatus);
		return surveyMapper.selectByExample(s);
	}


	/**
	 * 保存问卷
	 * @param survey
	 */
	public int saveOrUpdate(Survey survey) {
		
		if(survey.getSurveyId()==null){//新增
			surveyMapper.insertSelective(survey);
			System.out.println("插入成功后返回的id值为："+survey.getSurveyId());
		}else{//修改
			SurveyExample se = new SurveyExample();
			Criteria c = se.createCriteria();
			c.andSurveyIdEqualTo(survey.getSurveyId());
			surveyMapper.updateByExampleSelective(survey,se);
		}
		
	
		return survey.getSurveyId();
	}


	/*
	 * 根据id返回问卷
	 * */
	public Survey selectById(Integer surveyId) {
		
		SurveyExample s = new SurveyExample();
		Criteria c = s.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		
		if(surveyMapper.selectByExample(s).size()==0){
			return null;
		}
		
		return surveyMapper.selectByExample(s).get(0);
	}


	/**
	 * SQO：survey，question，option问卷，题目，选项三张表的保存
	 * @param object
	 * @return
	 */
	public long insertSQO(Object object) {
		
		/*
		 * 1、解析得到保存的问卷基本信息
		 */
		JsonConfig config  = new JsonConfig();
		config.setExcludes(new String[]{"questionList"});//排除掉不需要转换的json键值对
		
		//将json字符串转为json对象
		JSONObject jsonObject = JSONObject.fromObject(object,config);
		//System.out.println("转换后的json为："+jsonObject.toString());
		
		Survey survey = (Survey) JSONObject.toBean(jsonObject,Survey.class);
		//System.out.println("得到的问卷为："+survey.toString());
		
		/* 
		 * 在保存或者修改前，清空当前问卷的问题和选项
		 */
		//1)查询出问卷id为xxx的所有题目集合
		List<SurveyQuestion> questionList = surveyQuestionService.selectListBySurveyId(survey.getSurveyId());
		
		//2)遍历题目集合，删除
		for(SurveyQuestion sq : questionList){
			
			//删除此题所有选项
			surveyOptionService.deleteByQuestionId(sq.getQuestionId());
			
			//删除本题
			SurveyQuestionExample se = new SurveyQuestionExample();
			com.zerozrz.bean.SurveyQuestionExample.Criteria c = se.createCriteria();
			c.andQuestionIdEqualTo(sq.getQuestionId());
			
			surveyQuestionMapper.deleteByExample(se);
		}
		
		
		//1.1更新问卷
		SurveyExample se = new SurveyExample();
		Criteria cse = se.createCriteria();
		cse.andSurveyIdEqualTo(survey.getSurveyId());
		surveyMapper.updateByExampleSelective(survey, se);
		
		/*
		 * 2、遍历解析得到题目的基本信息
		 */
		JSONObject jsonObject2 = JSONObject.fromObject(object);
		Object s = jsonObject2.get("questionList");//题目数组
		
		//2.1遍历题目
		JSONArray jsonArray = JSONArray.fromObject(s);
		for(int i=0 ;i<jsonArray.size();i++){
			
			//2.2解析题目，排除掉选项字段
			JsonConfig config2  = new JsonConfig();
			config2.setExcludes(new String[]{"optionList"});//排除掉不需要转换的json键值对
			
			//将json字符串转为json对象
			JSONObject jsonObject3 = JSONObject.fromObject(jsonArray.get(i),config2);
			
			SurveyQuestion question = (SurveyQuestion) JSONObject.toBean(jsonObject3,SurveyQuestion.class);
			
			//2.3设置问题所属的问卷id
			question.setSurveyId(survey.getSurveyId());
			System.out.println("得到的题目为："+question.toString());
			
			//2.4保存或更新题目数据，
			//保存的话就返回保存题目的id
			if(question.getQuestionId()==null){//新增题目
				surveyQuestionMapper.insertSelective(question);
				
			}else{//更新题目
				SurveyQuestionExample sq = new SurveyQuestionExample();
				com.zerozrz.bean.SurveyQuestionExample.Criteria c = sq.createCriteria();
				c.andQuestionIdEqualTo(question.getQuestionId());//设置更新的条件为id等于xxx的数据
				
				surveyQuestionMapper.updateByExampleSelective(question, sq);
			}
			
			
			//2.5判断每一题的类型，只有部分题型支持选项
			Integer questionType = question.getQuestionType();
			if(questionType==0 || questionType==1 ||questionType==3){//单选，复选，下拉框才有选项
				
				JSONObject jsonObject4 = JSONObject.fromObject(jsonArray.get(i));
				Object s2 = jsonObject4.get("optionList");//选项数组
				
				/*
				 * 3、遍历选项，并解析
				 */
				JSONArray jsonArray2 = JSONArray.fromObject(s2);
				for(int i2=0 ;i2<jsonArray2.size();i2++){
					
					//将json字符串转为json对象
					JSONObject jsonObject5= JSONObject.fromObject(jsonArray2.get(i2));
					
					SurveyOption option = (SurveyOption) JSONObject.toBean(jsonObject5,SurveyOption.class);
					
					//2.3设置选项所属的题目id
					option.setQuestionId(question.getQuestionId());
					System.out.println("得到的选项为："+option.toString());
					
					//2.4保存选项数据
					if(option.getOptionId()==null){//新增
						SurveyOptionMapper.insertSelective(option);
					}else{//修改
						SurveyOptionExample so = new SurveyOptionExample();
						com.zerozrz.bean.SurveyOptionExample.Criteria c = so.createCriteria();
						c.andOptionIdEqualTo(option.getOptionId());
								
						SurveyOptionMapper.updateByExampleSelective(option, so);
					}
					
					
					
				}
				
				
			}
			
			
		}
		
		return 1;
	}

	
	/**
	 * 根据问卷id删除，旗下所有关联对象，
	 * 
	 * 问卷id找到答卷id，用答卷id删除所有reply，再用问卷id删除所有答卷
	 * 
	 * 问卷id找到所有题目，根据题目id删除所有选项，再根据问卷id删除所有题目
	 * 
	 * 最后删除问卷 
	 */
	public void removeAll(Integer surveyId) {
		
		//1、问卷id找到答卷id，
		List<Answer> answerList = answerService.getListBySurveyId(surveyId);
		
		for(Answer a : answerList){
			//2、用答卷id删除所有reply，
			replyService.removeByAnswerId(a.getAnswerId());
		}
		
		//3、再用问卷id删除所有答卷
		answerService.removeBySurveyId(surveyId);
		
		//4、问卷id找到所有题目，
		List<SurveyQuestion> questionList = surveyQuestionService.selectListBySurveyId(surveyId);
		for(SurveyQuestion q : questionList){
			
			//5、根据题目id删除所有选项，
			surveyOptionService.removeByQuestionId(q.getQuestionId());
			
		}
		
		//6、再根据问卷id删除所有题目
		surveyQuestionService.removeBySurveyId(surveyId);
		
		//最后删除问卷
		SurveyExample se = new SurveyExample();
		Criteria c = se.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		surveyMapper.deleteByExample(se);
		
	}


	
	
	
	
}
