package com.zerozrz.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.aspectj.weaver.patterns.TypePatternQuestions.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zerozrz.bean.Msg;
import com.zerozrz.bean.Survey;
import com.zerozrz.bean.SurveyOption;
import com.zerozrz.bean.SurveyQuestion;
import com.zerozrz.service.AnswerService;
import com.zerozrz.service.SurveyOptionService;
import com.zerozrz.service.SurveyQuestionService;
import com.zerozrz.service.SurveyService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@RequestMapping("/survey")
@Controller
public class SurveyController {

	@Autowired
	private SurveyService surveyService;
	
	@Autowired
	private SurveyQuestionService surveyQuestionService;
	
	@Autowired
	private SurveyOptionService surveyOptionService;
	
	@Autowired
	private AnswerService answerService;
	
	/**
	 * 根据问卷id，取得答卷的数量
	 * 
	 */
	@RequestMapping("/getAnswerNum")
	@ResponseBody
	public Msg getAnswerNum(@RequestParam("surveyId")Integer surveyId){
		
		List l = answerService.getListBySurveyId(surveyId);
		
		return Msg.success().add("answerNum", l.size());
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
	@RequestMapping("/removeSurvey")
	@ResponseBody
	public Msg removeSurvey(@RequestParam("surveyId")Integer surveyId){
		
		surveyService.removeAll(surveyId);
		
		return Msg.success();
	}
	
	/**
	 * 发布问卷，暂停问卷，从删除变为草稿状态（修改问卷的状态）
	 */
	@RequestMapping("/releaseOrStop")
	@ResponseBody
	public Msg releaseOrStop(Survey survey){
		System.out.println("要修改的问卷为："+survey);
		surveyService.saveOrUpdate(survey);
		
		return Msg.success();
	}
	
	/**
	 * 
	 * SQO：survey，question，option问卷，题目，选项三张表的保存
	 * @return
	 */
	@RequestMapping("/saveOrUpdateSQO")
	@ResponseBody
	public Msg saveOrUpdateSQO(@RequestBody Object object){
		System.out.println("接收到的json为："+object);
		
		
		surveyService.insertSQO(object);
		
		return Msg.success().add("message", "添加问卷成功");
	}

	
	/**
	 * 根据问卷Id获取问卷基本信息getById
	 * @param surveyId
	 * @return
	 */
	@RequestMapping("/getById")
	@ResponseBody
	public Msg getById(@RequestParam("surveyId")Integer surveyId){
		
		System.out.println("获取到的surveyId为："+surveyId);
		
		Survey survey = surveyService.selectById(surveyId);
		
		return Msg.success().add("survey", survey);
	}
	
	
	/**
	 * 根据问卷Id验证问卷基本信息getByIdCheck
	 * @param surveyId
	 * @return
	 */
	@RequestMapping("/getByIdCheck")
	@ResponseBody
	public Msg getByIdCheck(@RequestParam("surveyId")Integer surveyId){
		
		System.out.println("获取到的surveyId为："+surveyId);
		
		Survey survey = surveyService.selectById(surveyId);
		
		if(survey==null){//问卷不存在
			return Msg.fail().add("error", "此问卷不存在哦，(づ￣3￣)づ╭❤～");
		}
		
		//1、判断当前时间，是否小于问卷截止时间
		long endtime = survey.getTimeEnd().getTime();
		//当前时间
		Date d = new java.sql.Date(new Date().getTime());  
		
		if(survey.getSurveyStatus()==0){
			return Msg.fail().add("error", "此问卷还在草稿中哦，(づ￣3￣)づ╭❤～");
		}else if(survey.getSurveyStatus()==2){
			return Msg.fail().add("error", "此问卷已经暂停了哦，(づ￣3￣)づ╭❤～");
		}else if(survey.getSurveyStatus()==3){
			return Msg.fail().add("error", "此问卷已经删除了哦，(づ￣3￣)づ╭❤～");
		}else if(d.getTime() > endtime){//如果超时，直接返回false
			return Msg.fail().add("error", "此问卷已经截止了哦，(づ￣3￣)づ╭❤～");
		}
		
		return Msg.success().add("survey", survey);
	}
	/**
	 * 问卷的创建和修改 
	 */
	@RequestMapping("/saveOrUpdate")
	@ResponseBody
	public Msg saveOrUpdate(Survey survey,
				@RequestParam("tStart")String timeStart,
				@RequestParam("tEnd")String timeEnd){
		
		System.out.println("前台传来的survey信息如下："+survey);
		System.out.println("开始结束时间:"+timeStart+"--"+timeEnd);
		
		//1、将字符串的时间类型转为Date类型
		//指定时间格式
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		boolean f=true;
		
		Date start = null;
		Date end = null;
		
		try {
			start = sdf.parse(timeStart);
			end = sdf.parse(timeEnd);
			
			//2、把时间赋值给survey
			survey.setTimeStart(start);
			survey.setTimeEnd(end);
			
		} catch (ParseException e) {
			//e.printStackTrace();
			f=false;
		}
		
		if(f==false){
			return Msg.fail().add("error", "时间格式有误");
		}
		//2.2验证，截止时间必须要大于开始时间，否则返回false
		if(start.getTime()>end.getTime()){
			return Msg.fail().add("error", "截止时间必须要大于开始时间");
		}
		
		if(survey.getSurveyId()==null){//只有新增才需要创建新的时间
			//3、
			//设置问卷创建时间
			Date d = new java.sql.Date(new Date().getTime());  
			survey.setTimeCreate(d);
		}
		
		
		//4、设置问卷状态
		survey.setSurveyStatus(0);
		
		//5、保存问卷
		int l = surveyService.saveOrUpdate(survey);
		
		if(l>0){
			return Msg.success().add("surveyId", l);
		}else {
			return Msg.fail().add("save_error", "保存失败");
		}
		
		
	}
	
	@RequestMapping("/getPageListByStatus")
	@ResponseBody
	public Msg getPageListByStatus(@RequestParam(value="pn",defaultValue="1")Integer pn,//查询页码，默认为第一页
							@RequestParam(value="surveyStatus",defaultValue="-1")Integer surveyStatus,//-1表示查询全部
							@RequestParam(value="surveyName",defaultValue="-1")String surveyName,//有名字的话，把名字的条件也带上
							@RequestParam(value="userId")Integer userId){//根据用户id查询
		
		PageHelper.startPage(pn,3);//查询页码，每页三条数据
		
		//按照问卷状态和用户id查询
		List<Survey> sList = surveyService.getPageListByStatus(surveyStatus,surveyName,userId);
		
		//使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(sList,5);
				
		
		return Msg.success().add("pageInfo", page);
	}
	
}
