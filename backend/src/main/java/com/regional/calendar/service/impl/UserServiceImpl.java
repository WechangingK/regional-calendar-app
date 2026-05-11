package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.common.exception.BusinessException;
import com.regional.calendar.common.result.ResultCode;
import com.regional.calendar.dto.RegisterRequest;
import com.regional.calendar.entity.User;
import com.regional.calendar.mapper.UserMapper;
import com.regional.calendar.service.UserService;
import com.regional.calendar.util.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

	private final PasswordEncoder passwordEncoder;
	private final JwtUtil jwtUtil;

	public UserServiceImpl(PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
		this.passwordEncoder = passwordEncoder;
		this.jwtUtil = jwtUtil;
	}

	@Override
	public User getByUsername(String username) {
		return getOne(new LambdaQueryWrapper<User>()
				.eq(User::getUsername, username));
	}

	@Override
	public User getByPhone(String phone) {
		return getOne(new LambdaQueryWrapper<User>()
				.eq(User::getPhone, phone));
	}

	@Override
	public User getByEmail(String email) {
		return getOne(new LambdaQueryWrapper<User>()
				.eq(User::getEmail, email));
	}

	@Override
	public User register(RegisterRequest req) {
		if (getByUsername(req.getUsername()) != null) {
			throw new BusinessException(ResultCode.USER_ALREADY_EXISTS);
		}
		if (req.getPhone() != null && getByPhone(req.getPhone()) != null) {
			throw new BusinessException(ResultCode.PHONE_ALREADY_EXISTS);
		}
		if (req.getEmail() != null && getByEmail(req.getEmail()) != null) {
			throw new BusinessException(ResultCode.EMAIL_ALREADY_EXISTS);
		}

		User user = new User();
		user.setUsername(req.getUsername());
		user.setPassword(passwordEncoder.encode(req.getPassword()));
		user.setSalt("default");
		user.setNickname(req.getNickname());
		user.setPhone(req.getPhone());
		user.setEmail(req.getEmail());
		user.setGender(req.getGender());
		user.setRegionId(req.getRegionId());
		user.setStatus(1);
		user.setCreateTime(LocalDateTime.now());
		user.setUpdateTime(LocalDateTime.now());
		save(user);
		return user;
	}

	@Override
	public Map<String, Object> login(String username, String password, String ip) {
		User user = getByUsername(username);
		if (user == null) {
			throw new BusinessException(ResultCode.USER_NOT_FOUND);
		}
		if (user.getStatus() != 1) {
			throw new BusinessException(ResultCode.FORBIDDEN);
		}
		if (!passwordEncoder.matches(password, user.getPassword())) {
			throw new BusinessException(ResultCode.PASSWORD_ERROR);
		}
		String token = jwtUtil.generateToken(user.getId(), user.getUsername());
		updateLoginInfo(user.getId(), ip);

		user.setPassword(null);
		user.setSalt(null);

		Map<String, Object> result = new HashMap<>();
		result.put("token", token);
		result.put("user", user);
		return result;
	}

	@Override
	public void updateLoginInfo(Long userId, String ip) {
		lambdaUpdate()
				.eq(User::getId, userId)
				.set(User::getLastLoginTime, LocalDateTime.now())
				.set(User::getLastLoginIp, ip)
				.setSql("login_count = login_count + 1")
				.update();
	}
}
