package com.zerozrz.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zerozrz.bean.Survey;
import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyOptionExample;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.bean.SurveyQuestionExample;
import com.zerozrz.bean.SurveyQuestionExample.Criteria;
import com.zerozrz.dao.SurveyQuestionMapper;

@Service
public class SurveyQuestionService {

	@Autowired
	private SurveyQuestionMapper surveyQuestionMapper;

	/**
	 * 通过问卷id查询所有的题目
	 * @param surveyId
	 * @return
	 */
	public List<SurveyQuestion> selectListBySurveyId(Integer surveyId) {
		SurveyQuestionExample sq = new SurveyQuestionExample();
		sq.setOrderByClause("question_sort");//列名
		Criteria c = sq.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		
		
		return surveyQuestionMapper.selectByExample(sq);
		
	}

	/**
	 * 根据问卷id删除所有题目
	 * @param surveyId
	 */
	public void removeBySurveyId(Integer surveyId) {
		SurveyQuestionExample sq = new SurveyQuestionExample();
		Criteria c = sq.createCriteria();
		c.andSurveyIdEqualTo(surveyId);
		
		surveyQuestionMapper.deleteByExample(sq);
		
	}

	/**
	 * 根据问题id，取问卷id
	 * @param questionId
	 * @return
	 */
	public Integer selectSurveyByquestonId(Integer questionId) {
		SurveyQuestionExample sq = new SurveyQuestionExample();
		Criteria c = sq.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		
		return surveyQuestionMapper.selectByExample(sq).get(0).getSurveyId();
	}

}
