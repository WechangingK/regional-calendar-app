package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.User;

public interface UserService extends IService<User> {

    /**
     * 根据用户名查询用户
     */
    User getByUsername(String username);

    /**
     * 根据手机号查询用户
     */
    User getByPhone(String phone);

    /**
     * 根据邮箱查询用户
     */
    User getByEmail(String email);

    /**
     * 用户注册
     */
    User register(String username, String password, String phone);

    /**
     * 用户登录（返回JWT Token）
     */
    String login(String username, String password, String ip);

    /**
     * 更新最后登录信息
     */
    void updateLoginInfo(Long userId, String ip);
}
