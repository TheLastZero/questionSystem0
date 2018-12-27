package com.zerozrz.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zerozrz.bean.Answer;
import com.zerozrz.bean.Msg;
import com.zerozrz.bean.Reply;
import com.zerozrz.bean.Survey;
import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.service.AnswerService;
import com.zerozrz.service.ReplyService;
import com.zerozrz.service.SurveyOptionService;
import com.zerozrz.service.SurveyQuestionService;
import com.zerozrz.service.SurveyService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RequestMapping("/answer")
@Controller
public class AnswerController {

	@Autowired
	private AnswerService answerService;
	
	@Autowired
	private ReplyService replyService;
	
	@Autowired
	private SurveyService surveyService;
	
	@Autowired
	private SurveyQuestionService surveyQuestionService;
	
	@Autowired
	private SurveyOptionService SurveyOptionService;
	
	/**
	 * 根据问卷id，答卷id，上一页或者下一页，来返回上一页或者下一页的答卷
	 */
	@RequestMapping("/getPageperNext")
	public String getPageperNext(Integer surveyId,Integer answerId,String type,HttpServletRequest request){
		
		Integer newAnswerId = null;
		if("pre".equals(type)){//请求答卷的上一页
			
			newAnswerId = answerService.selectPreById(surveyId,answerId);
			
		}else if("next".equals(type)){//请求答卷的下一页
			newAnswerId = answerService.selectNextById(surveyId,answerId);
		}
		
		return "redirect:answerShow.jsp?surveyId="+surveyId+"&answerId="+newAnswerId;
	}
	
	/**
	 * 根据id，查询答卷基本信息
	 */
	@RequestMapping("/getByQuestionId")
	@ResponseBody
	public Msg getByQuestionId(Integer answerId,Integer surveyId){
		
		Answer a=null;
		if(answerId==-1){//-1表示查询查询第一份答卷
			a = answerService.selectFirst(surveyId);
		}else {
			a = answerService.getByQuestionId(answerId);
		}
		
		
		
		return Msg.success().add("answer", a);
	}
	
	/**
	 * 根据题目id，题目类型，和答卷id，查询答案
	 */
	@RequestMapping("/getUserAnswerByQidTypeIdAId")
	@ResponseBody
	public Msg getUserAnswerByQidTypeIdAId(Integer questionId,Integer questionType,Integer answerId){
		
		if(answerId==-1){//-1表示查询查询第一份答卷
			
			//通过问题的id取得问卷的id
			Integer surveyId = surveyQuestionService.selectSurveyByquestonId(questionId);
			
			answerId = answerService.selectFirst(surveyId).getAnswerId();
		}
		
		//1、先根据题目id，和答卷id查询reply
		Reply r = answerService.getUserAnswerByQidTypeIdAId(questionId,answerId);
		
		
		//2、判断题目的类型，再来决定取哪一个字段的值，是否需要分割
		if(questionType==2 || questionType==4){//如果类型是填空，或者评分条，直接返回replyContent的值
			
			if(r.getReplyContent()==null){
				return Msg.success().add("context", "");
			}
			
			return Msg.success().add("context", r.getReplyContent());
		}else if(questionType==0 || questionType==3){
			//3、如果是单选下拉框，先去查询其选项的值，再返回
			String s = r.getReplyIds();
			
			if(s==null || "".equals(s) || "undefined".equals(s)){
				return Msg.success().add("context", "");
			}
			
			SurveyOption option = SurveyOptionService.selectByOptionId(Integer.parseInt(s));
			
			return Msg.success().add("context", option.getOptionContent());
			
		}else if(questionType==1){//如果是复选，我们需要分割id集，查询选项再拼接
			
			String s = r.getReplyIds();
			
			if(s==null || "".equals(s)){
				return Msg.success().add("context", "");
			}
			
			String [] sArr = s.split(",");
			
			String context=""; 
			
			for(String s1 : sArr){
				SurveyOption option = SurveyOptionService.selectByOptionId(Integer.parseInt(s1));
				context = context+"，"+option.getOptionContent();
			}
			
			context = (String) context.substring(1,context.length());
			
			return Msg.success().add("context", context);
			
		}
		
		
		
		
		return Msg.fail();
	}
	
	
	/**
	 * 根据问卷id，取得答卷分析所需字段
	 * 
	 * 
				根据问卷id加载答卷的分析信息
				
				问卷需要
					得到问卷的标题，类型
				
				题目需要，
					每题的标题，类型
				
				选项需要：
				
				1、单选
					选项文本		选项被选择的次数	此选项被选中的比例
					有效填写人次
					饼状图	柱状图
				
				2、复选
					选项文本		选项被选择的次数	此选项被选中的比例
					有效填写人次
					饼状图	柱状图
				
				3、填空题
					直接以分页的形式展示所有答题者此题的信息
					序号		提交答卷时间		答案文本		查看答卷
					
				4、下拉框
					选项文本		选项被选择的次数	此选项被选中的比例
					有效填写人次
					饼状图	柱状图
						
				5、评分条
					直接取所有答案的平均值即可
					
			
	 */
	@RequestMapping("/surveyAnalyze")
	@ResponseBody
	public Msg surveyAnalyze(@RequestParam("surveyId")Integer surveyId){
		
		//最外层问卷
		Map<String, Object> surveyMap = new HashMap<String, Object>();
		
		//1、先取得问卷基本信息
		//拼接问卷的标题，类型
		Survey survey = surveyService.selectById(surveyId);
		surveyMap.put("surveyName", survey.getSurveyName());
		surveyMap.put("surveyType", survey.getSurveyType());
		
		List<Object> questionList = new ArrayList<Object>();
		
		//2、根据问卷id，取得题目list，遍历此list
		List<SurveyQuestion> questionList2 = surveyQuestionService.selectListBySurveyId(surveyId);
		
		for(SurveyQuestion question : questionList2){
			
			//拼接题目的标题，类型
			Map<String, Object> questionMap = new HashMap<String, Object>();
			questionMap.put("questionId", question.getQuestionId());
			questionMap.put("questionTitle", question.getQuestionTitle());
			questionMap.put("questionType", question.getQuestionType());
			//本题有效填写的人次
			questionMap.put("personTime",getPersonTime(question.getQuestionId()));
			
			//判断题目的类型拼接对应数据，0、1、3是有选项的
			if(question.getQuestionType()==0 || question.getQuestionType()==1 ||question.getQuestionType()==3){
				
				List<Object> optionList = new ArrayList<Object>();
				
				//3、根据题目id查询所有选项
				List<SurveyOption> optionList2 = SurveyOptionService.selectListByQuestionId(question.getQuestionId());
				
				for(SurveyOption option : optionList2){
					Map<String, Object> optionMap = new HashMap<String, Object>();
					//选项文本
					optionMap.put("optionContent", option.getOptionContent());
					//选项被选择的次数
					optionMap.put("optionCheckedNum",getOptionCheckedNum(question.getQuestionId(),question.getQuestionType(),option.getOptionId()) );
					//选项被选中的比例
					optionMap.put("optionRatio", getOptionRatio(option.getOptionId()));
					
					optionList.add(optionMap);
					
				}
				
				questionMap.put("optionList", optionList);
				
				questionList.add(questionMap);
				
			}else if(question.getQuestionType()==2){//填空题，拼接答卷每题情况表的Page List
				
				questionMap.put("replyList",getReplyListByQuestionId(question.getQuestionId(),1));
				questionList.add(questionMap);
				
			}else if(question.getQuestionType()==4){//评分条，拼接所有答卷本题的平均分
				//根据题目id获取，当前选项的平均分
				questionMap.put("averageScore", getAverageScore(question.getQuestionId()));
				questionList.add(questionMap);
			}
			
			
			
		}
		
		surveyMap.put("questionList", questionList);
		
		return Msg.success().add("surveyMap", surveyMap);
	}

	/**
	 * 根据题目id，获取有效填写的人次
	 * @param questionId
	 * @return
	 */
	public Integer getPersonTime(Integer questionId){
		
		Integer personTime = replyService.getPersonTime(questionId);
		
		return personTime;
	}
	
	/**
	 * 根据题目id和选项的id，获取选项被选择的次数
	 */
	public Integer getOptionCheckedNum(Integer questionId,Integer questionType,Integer OptionId){
		
		return replyService.getOptionCheckedNum(questionId,questionType,OptionId);
		
	}
	
	/**
	 * 根据题目id和选项的id，获取选项被选择的比例
	 */
	public Double getOptionRatio(Integer OptionId){
		
		return replyService.getOptionRatio(OptionId);
	}
	
	/**
	 * 根据题目id获取，当前选项的平均分
	 * @param questionId
	 * @return
	 */
	private Integer getAverageScore(Integer questionId) {
		return replyService.getAverageScore(questionId);
	}
	
	/**
	 * 根据题目id，和所需页码，获取分页的reply的List集合
	 * @param questionId
	 * @return
	 */
	@RequestMapping("/getPageInfoByQuestionIdPn")
	@ResponseBody
	private PageInfo getReplyListByQuestionId(Integer questionId,Integer pn) {
		
		PageHelper.startPage(pn,3);//查询页码，每页三条数据
		
		//根据题目id，获取分页的reply的List集合
		List<Reply> replyList = replyService.getReplyListByQuestionId(questionId);
		
		//使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(replyList,3);
		
		return page;
	}
	
	
	/**
	 * 
	 * answer,reply答卷，答卷每题情况两张表的保存
	 * @return
	 */
	@RequestMapping("/save")
	@ResponseBody
	public Msg save(@RequestBody Object object){
		System.out.println("接收到的json为："+object);
		
		answerService.insertAR(object);
		
		return Msg.success().add("message", "添加答卷成功");
	}
	
	
}
