package com.zerozrz.dao;

import com.zerozrz.bean.UserRecharge;
import com.zerozrz.bean.UserRechargeExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface UserRechargeMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    long countByExample(UserRechargeExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    int deleteByExample(UserRechargeExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    int insert(UserRecharge record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    int insertSelective(UserRecharge record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    List<UserRecharge> selectByExample(UserRechargeExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    int updateByExampleSelective(@Param("record") UserRecharge record, @Param("example") UserRechargeExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user_recharge
     *
     * @mbg.generated Tue Oct 16 13:36:40 GMT+08:00 2018
     */
    int updateByExample(@Param("record") UserRecharge record, @Param("example") UserRechargeExample example);
}