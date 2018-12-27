package com.zerozrz.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zerozrz.bean.Msg;
import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.service.SurveyOptionService;

@RequestMapping("/option")
@Controller
public class SurveyOptionController {

	@Autowired
	private SurveyOptionService surveyOptionService;
	
	/**
	 * 根据题目id加载所有的选项
	 */
	@RequestMapping("/getOptionByQuestionId")
	@ResponseBody
	public Msg getQuestionOptionById(@RequestParam("questionId")Integer questionId){
		
		//1、根据问卷id查询所有的题目
		List<SurveyOption> optionList = surveyOptionService.selectListByQuestionId(questionId);
		
		
		return Msg.success().add("optionList", optionList);
	}
	
}
