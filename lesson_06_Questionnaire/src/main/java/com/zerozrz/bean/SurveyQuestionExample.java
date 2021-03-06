package com.zerozrz.bean;

import java.util.ArrayList;
import java.util.List;

public class SurveyQuestionExample {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    protected String orderByClause;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    protected boolean distinct;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    protected List<Criteria> oredCriteria;

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public SurveyQuestionExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public String getOrderByClause() {
        return orderByClause;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public boolean isDistinct() {
        return distinct;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andQuestionIdIsNull() {
            addCriterion("question_id is null");
            return (Criteria) this;
        }

        public Criteria andQuestionIdIsNotNull() {
            addCriterion("question_id is not null");
            return (Criteria) this;
        }

        public Criteria andQuestionIdEqualTo(Integer value) {
            addCriterion("question_id =", value, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdNotEqualTo(Integer value) {
            addCriterion("question_id <>", value, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdGreaterThan(Integer value) {
            addCriterion("question_id >", value, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdGreaterThanOrEqualTo(Integer value) {
            addCriterion("question_id >=", value, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdLessThan(Integer value) {
            addCriterion("question_id <", value, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdLessThanOrEqualTo(Integer value) {
            addCriterion("question_id <=", value, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdIn(List<Integer> values) {
            addCriterion("question_id in", values, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdNotIn(List<Integer> values) {
            addCriterion("question_id not in", values, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdBetween(Integer value1, Integer value2) {
            addCriterion("question_id between", value1, value2, "questionId");
            return (Criteria) this;
        }

        public Criteria andQuestionIdNotBetween(Integer value1, Integer value2) {
            addCriterion("question_id not between", value1, value2, "questionId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdIsNull() {
            addCriterion("survey_id is null");
            return (Criteria) this;
        }

        public Criteria andSurveyIdIsNotNull() {
            addCriterion("survey_id is not null");
            return (Criteria) this;
        }

        public Criteria andSurveyIdEqualTo(Integer value) {
            addCriterion("survey_id =", value, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdNotEqualTo(Integer value) {
            addCriterion("survey_id <>", value, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdGreaterThan(Integer value) {
            addCriterion("survey_id >", value, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdGreaterThanOrEqualTo(Integer value) {
            addCriterion("survey_id >=", value, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdLessThan(Integer value) {
            addCriterion("survey_id <", value, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdLessThanOrEqualTo(Integer value) {
            addCriterion("survey_id <=", value, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdIn(List<Integer> values) {
            addCriterion("survey_id in", values, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdNotIn(List<Integer> values) {
            addCriterion("survey_id not in", values, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdBetween(Integer value1, Integer value2) {
            addCriterion("survey_id between", value1, value2, "surveyId");
            return (Criteria) this;
        }

        public Criteria andSurveyIdNotBetween(Integer value1, Integer value2) {
            addCriterion("survey_id not between", value1, value2, "surveyId");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeIsNull() {
            addCriterion("question_type is null");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeIsNotNull() {
            addCriterion("question_type is not null");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeEqualTo(Integer value) {
            addCriterion("question_type =", value, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeNotEqualTo(Integer value) {
            addCriterion("question_type <>", value, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeGreaterThan(Integer value) {
            addCriterion("question_type >", value, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeGreaterThanOrEqualTo(Integer value) {
            addCriterion("question_type >=", value, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeLessThan(Integer value) {
            addCriterion("question_type <", value, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeLessThanOrEqualTo(Integer value) {
            addCriterion("question_type <=", value, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeIn(List<Integer> values) {
            addCriterion("question_type in", values, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeNotIn(List<Integer> values) {
            addCriterion("question_type not in", values, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeBetween(Integer value1, Integer value2) {
            addCriterion("question_type between", value1, value2, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTypeNotBetween(Integer value1, Integer value2) {
            addCriterion("question_type not between", value1, value2, "questionType");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleIsNull() {
            addCriterion("question_title is null");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleIsNotNull() {
            addCriterion("question_title is not null");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleEqualTo(String value) {
            addCriterion("question_title =", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleNotEqualTo(String value) {
            addCriterion("question_title <>", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleGreaterThan(String value) {
            addCriterion("question_title >", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleGreaterThanOrEqualTo(String value) {
            addCriterion("question_title >=", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleLessThan(String value) {
            addCriterion("question_title <", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleLessThanOrEqualTo(String value) {
            addCriterion("question_title <=", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleLike(String value) {
            addCriterion("question_title like", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleNotLike(String value) {
            addCriterion("question_title not like", value, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleIn(List<String> values) {
            addCriterion("question_title in", values, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleNotIn(List<String> values) {
            addCriterion("question_title not in", values, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleBetween(String value1, String value2) {
            addCriterion("question_title between", value1, value2, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionTitleNotBetween(String value1, String value2) {
            addCriterion("question_title not between", value1, value2, "questionTitle");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainIsNull() {
            addCriterion("question_explain is null");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainIsNotNull() {
            addCriterion("question_explain is not null");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainEqualTo(String value) {
            addCriterion("question_explain =", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainNotEqualTo(String value) {
            addCriterion("question_explain <>", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainGreaterThan(String value) {
            addCriterion("question_explain >", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainGreaterThanOrEqualTo(String value) {
            addCriterion("question_explain >=", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainLessThan(String value) {
            addCriterion("question_explain <", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainLessThanOrEqualTo(String value) {
            addCriterion("question_explain <=", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainLike(String value) {
            addCriterion("question_explain like", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainNotLike(String value) {
            addCriterion("question_explain not like", value, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainIn(List<String> values) {
            addCriterion("question_explain in", values, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainNotIn(List<String> values) {
            addCriterion("question_explain not in", values, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainBetween(String value1, String value2) {
            addCriterion("question_explain between", value1, value2, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andQuestionExplainNotBetween(String value1, String value2) {
            addCriterion("question_explain not between", value1, value2, "questionExplain");
            return (Criteria) this;
        }

        public Criteria andIsrequiredIsNull() {
            addCriterion("isRequired is null");
            return (Criteria) this;
        }

        public Criteria andIsrequiredIsNotNull() {
            addCriterion("isRequired is not null");
            return (Criteria) this;
        }

        public Criteria andIsrequiredEqualTo(String value) {
            addCriterion("isRequired =", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredNotEqualTo(String value) {
            addCriterion("isRequired <>", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredGreaterThan(String value) {
            addCriterion("isRequired >", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredGreaterThanOrEqualTo(String value) {
            addCriterion("isRequired >=", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredLessThan(String value) {
            addCriterion("isRequired <", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredLessThanOrEqualTo(String value) {
            addCriterion("isRequired <=", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredLike(String value) {
            addCriterion("isRequired like", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredNotLike(String value) {
            addCriterion("isRequired not like", value, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredIn(List<String> values) {
            addCriterion("isRequired in", values, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredNotIn(List<String> values) {
            addCriterion("isRequired not in", values, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredBetween(String value1, String value2) {
            addCriterion("isRequired between", value1, value2, "isrequired");
            return (Criteria) this;
        }

        public Criteria andIsrequiredNotBetween(String value1, String value2) {
            addCriterion("isRequired not between", value1, value2, "isrequired");
            return (Criteria) this;
        }

        public Criteria andQuestionSortIsNull() {
            addCriterion("question_sort is null");
            return (Criteria) this;
        }

        public Criteria andQuestionSortIsNotNull() {
            addCriterion("question_sort is not null");
            return (Criteria) this;
        }

        public Criteria andQuestionSortEqualTo(String value) {
            addCriterion("question_sort =", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortNotEqualTo(String value) {
            addCriterion("question_sort <>", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortGreaterThan(String value) {
            addCriterion("question_sort >", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortGreaterThanOrEqualTo(String value) {
            addCriterion("question_sort >=", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortLessThan(String value) {
            addCriterion("question_sort <", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortLessThanOrEqualTo(String value) {
            addCriterion("question_sort <=", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortLike(String value) {
            addCriterion("question_sort like", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortNotLike(String value) {
            addCriterion("question_sort not like", value, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortIn(List<String> values) {
            addCriterion("question_sort in", values, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortNotIn(List<String> values) {
            addCriterion("question_sort not in", values, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortBetween(String value1, String value2) {
            addCriterion("question_sort between", value1, value2, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionSortNotBetween(String value1, String value2) {
            addCriterion("question_sort not between", value1, value2, "questionSort");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreIsNull() {
            addCriterion("question_score is null");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreIsNotNull() {
            addCriterion("question_score is not null");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreEqualTo(Integer value) {
            addCriterion("question_score =", value, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreNotEqualTo(Integer value) {
            addCriterion("question_score <>", value, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreGreaterThan(Integer value) {
            addCriterion("question_score >", value, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreGreaterThanOrEqualTo(Integer value) {
            addCriterion("question_score >=", value, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreLessThan(Integer value) {
            addCriterion("question_score <", value, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreLessThanOrEqualTo(Integer value) {
            addCriterion("question_score <=", value, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreIn(List<Integer> values) {
            addCriterion("question_score in", values, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreNotIn(List<Integer> values) {
            addCriterion("question_score not in", values, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreBetween(Integer value1, Integer value2) {
            addCriterion("question_score between", value1, value2, "questionScore");
            return (Criteria) this;
        }

        public Criteria andQuestionScoreNotBetween(Integer value1, Integer value2) {
            addCriterion("question_score not between", value1, value2, "questionScore");
            return (Criteria) this;
        }

        public Criteria andIsrandomIsNull() {
            addCriterion("isRandom is null");
            return (Criteria) this;
        }

        public Criteria andIsrandomIsNotNull() {
            addCriterion("isRandom is not null");
            return (Criteria) this;
        }

        public Criteria andIsrandomEqualTo(Integer value) {
            addCriterion("isRandom =", value, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomNotEqualTo(Integer value) {
            addCriterion("isRandom <>", value, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomGreaterThan(Integer value) {
            addCriterion("isRandom >", value, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomGreaterThanOrEqualTo(Integer value) {
            addCriterion("isRandom >=", value, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomLessThan(Integer value) {
            addCriterion("isRandom <", value, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomLessThanOrEqualTo(Integer value) {
            addCriterion("isRandom <=", value, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomIn(List<Integer> values) {
            addCriterion("isRandom in", values, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomNotIn(List<Integer> values) {
            addCriterion("isRandom not in", values, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomBetween(Integer value1, Integer value2) {
            addCriterion("isRandom between", value1, value2, "israndom");
            return (Criteria) this;
        }

        public Criteria andIsrandomNotBetween(Integer value1, Integer value2) {
            addCriterion("isRandom not between", value1, value2, "israndom");
            return (Criteria) this;
        }
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table survey_question
     *
     * @mbg.generated do_not_delete_during_merge Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table survey_question
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}