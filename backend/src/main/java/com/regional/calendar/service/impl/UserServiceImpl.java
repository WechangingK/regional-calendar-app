package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.common.exception.BusinessException;
import com.regional.calendar.common.result.ResultCode;
import com.regional.calendar.entity.User;
import com.regional.calendar.mapper.UserMapper;
import com.regional.calendar.service.UserService;
import com.regional.calendar.util.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

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
    public User register(String username, String password, String phone) {
        // 检查用户名是否已存在
        if (getByUsername(username) != null) {
            throw new BusinessException(ResultCode.USER_ALREADY_EXISTS);
        }
        // 检查手机号是否已存在
        if (phone != null && getByPhone(phone) != null) {
            throw new BusinessException(ResultCode.PHONE_ALREADY_EXISTS);
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setSalt("default");
        user.setPhone(phone);
        user.setStatus(1);
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        save(user);
        return user;
    }

    @Override
    public String login(String username, String password, String ip) {
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
        return token;
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
