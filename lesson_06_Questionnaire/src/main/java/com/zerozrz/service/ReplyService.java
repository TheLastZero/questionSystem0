package com.zerozrz.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zerozrz.bean.Reply;
import com.zerozrz.bean.ReplyExample;
import com.zerozrz.bean.ReplyExample.Criteria;
import com.zerozrz.dao.ReplyMapper;

@Service
public class ReplyService {

	@Autowired
	private ReplyMapper replyMapper;

	//某一题所有有效reply的集合
	private static List<Reply> replyList;
	
	//某一题所有有效答案id的集合
	private static Map<Integer, Integer> optionRatioMap;
	
	
	private static Integer persionTime=0;//此题被有效填写总次数
	/**
	 * 根据题目id，获取本题目有效填写的人次
	 * @param questionId
	 * @return
	 */
	public Integer getPersonTime(Integer questionId) {
		
		ReplyExample re = new ReplyExample();
		Criteria c = re.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		replyList = replyMapper.selectByExample(re);
		
		persionTime=0;
		
		for(Reply r : replyList){
			String ids = r.getReplyIds();
			//如果ids结果集不等于空，或者空字符串，那么表示此答题情况表有作答，视为有效作答
			if(!("".equals(ids)) && ids!=null){
				persionTime++;
			}
			
		}
		return persionTime;
	}

	/**
	 * 根据题目id，题目类型，和选项的id，获取选项被选择的次数
	 */
	public Integer getOptionCheckedNum(Integer questionId,Integer questionType, Integer optionId) {
		
		//查询出当前题目所有的回答集合
		replyList = null;
		ReplyExample re = new ReplyExample();
		Criteria c = re.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		replyList = replyMapper.selectByExample(re);
		
		//System.out.println("查到的replyList："+replyList);
		
		getPersonTime(questionId);
		
		Integer optionCheckedNum=0;
		
		optionRatioMap = null;
		optionRatioMap = new HashMap<Integer, Integer>();
		
		for(Reply r : replyList){
			String ids = r.getReplyIds();
			//如果ids结果集不等于空，或者空字符串，那么表示此答题情况表有作答，视为有效作答
			if(!("".equals(ids)) && ids!=null){
				
				if(questionType==0 || questionType ==3){//单选和下拉框一样，答案只有一个值
					
					if(optionId==Integer.parseInt(ids)){//如果相等表示被选择了
						optionCheckedNum++;
						if(optionRatioMap.containsKey(optionId)==false){
							optionRatioMap.put(optionId, 1);
						}else{
							optionRatioMap.put(optionId, optionRatioMap.get(optionId)+1);
						}
					}
					
				}else if(questionType==1){//多选可能有一个或者多个值
					String [] idArr = ids.split(",");//根据逗号来分割
					
					for(String s : idArr){
						if(Integer.parseInt(s)==(optionId)){
							
							//将选中项+1，放到map中
							optionCheckedNum++;
							
							if(optionRatioMap.get(optionId)==null){
								optionRatioMap.put(optionId, 1);
							}else{
								optionRatioMap.put(optionId, optionRatioMap.get(optionId)+1);
							}
						}
					}
					
				}
				
				
			}
			
		}
		System.out.println("当前的optionMap为:"+optionRatioMap);
		return optionCheckedNum;
	}

	/**
	 * 选项的id，获取选项被选择的比例
	 */
	public Double getOptionRatio(Integer optionId) {
		
		//System.out.println("选项："+optionRatioMap);
		
		if(optionRatioMap.get(optionId)==null){
			return 0.00;
		}
		
		Double d = Double.parseDouble(optionRatioMap.get(optionId).toString())/persionTime;
		Double d2= (double)Math.round(d*100)/100;
		return d2;
	}

	/**
	 * 根据题目id获取，当前选项的平均分
	 * @param questionId
	 * @return
	 */
	public Integer getAverageScore(Integer questionId) {
		
		ReplyExample re = new ReplyExample();
		Criteria c = re.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		
		//总分
		int sum = 0;
		
		List<Reply> replyList = replyMapper.selectByExample(re);
		for(Reply r : replyList){
			if(r.getReplyContent()==null || "".equals(r.getReplyContent())){
				
			}else{
				sum += Integer.parseInt(r.getReplyContent());
			}
		}
		
		if(replyList.size()==0){
			return 0;
		}
		
		sum = sum/replyList.size();
		
		return sum;
	}

	/**
	 * 根据题目id，获取分页的reply的List集合
	 * @param questionId
	 * @return
	 */
	public List<Reply> getReplyListByQuestionId(Integer questionId) {
		ReplyExample re = new ReplyExample();
		Criteria c = re.createCriteria();
		c.andQuestionIdEqualTo(questionId);
		
		return replyMapper.selectByExample(re);
	}

	/**
	 * 根据答卷id，删除所有的reply
	 * @param answerId
	 */
	public void removeByAnswerId(Integer answerId) {
		ReplyExample re = new ReplyExample();
		Criteria c = re.createCriteria();
		c.andAnswerIdEqualTo(answerId);

		replyMapper.deleteByExample(re);
	} 
	
	
	
}
