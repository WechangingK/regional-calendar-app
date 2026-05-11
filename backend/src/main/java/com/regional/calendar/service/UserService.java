package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.common.result.R;
import com.regional.calendar.dto.RegisterRequest;
import com.regional.calendar.entity.User;

import java.util.Map;

public interface UserService extends IService<User> {

	User getByUsername(String username);

	User getByPhone(String phone);

	User getByEmail(String email);

	User register(RegisterRequest req);

	Map<String, Object> login(String username, String password, String ip);

	void updateLoginInfo(Long userId, String ip);
}
