package com.zerozrz.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zerozrz.bean.Msg;
import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.service.SurveyOptionService;
import com.zerozrz.service.SurveyQuestionService;

@RequestMapping("/question")
@Controller
public class SurveyQuestionController {

	@Autowired
	private SurveyQuestionService surveyQuestionService;
	
	/**
	 * 根据问卷id加载所有的题目
	 */
	@RequestMapping("/getQuestionBySurveyId")
	@ResponseBody
	public Msg getQuestionOptionById(@RequestParam("surveyId")Integer surveyId){
		
		//根据问卷id查询所有的题目
		List<SurveyQuestion> questionList = surveyQuestionService.selectListBySurveyId(surveyId);
		
		
		return Msg.success().add("questionList", questionList);
	}
	
}
