package com.zerozrz.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyOptionExample;
import com.zerozrz.bean.SurveyOptionExample.Criteria;
import com.zerozrz.dao.SurveyOptionMapper;

@Service
public class SurveyOptionService {

	@Autowired
	private SurveyOptionMapper surveyOptionMapper;

	/**
	 * 根据题目id获取该题目的所有选项
	 * @param questionId
	 * @return
	 */
	public List<SurveyOption> selectListByQuestionId(Integer questionId) {
		SurveyOptionExample so = new SurveyOptionExample();
		Criteria c = so.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		
		return surveyOptionMapper.selectByExample(so);
	}

	/**
	 * 根据题目id删除所有选项
	 * @param questionId
	 */
	public void deleteByQuestionId(Integer questionId) {
		SurveyOptionExample so = new SurveyOptionExample();
		Criteria c = so.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		
		surveyOptionMapper.deleteByExample(so);
		
	}

	/**
	 * 根据选项id，返回选项
	 * @param parseInt
	 * @return
	 */
	public SurveyOption selectByOptionId(Integer optionId) {

		System.out.println("当前的选项id为："+optionId);
		
		SurveyOptionExample se = new SurveyOptionExample();
		Criteria c = se.createCriteria();
		c.andOptionIdEqualTo(optionId);
		
		return surveyOptionMapper.selectByExample(se).get(0);
	}

	/**
	 * 根据题目id删除所有选项
	 * @param questionId
	 */
	public void removeByQuestionId(Integer questionId) {
		SurveyOptionExample se = new SurveyOptionExample();
		Criteria c = se.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		
		surveyOptionMapper.deleteByExample(se);
		
	}
	
}
