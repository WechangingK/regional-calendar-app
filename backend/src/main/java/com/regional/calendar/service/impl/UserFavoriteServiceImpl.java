package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.UserFavorite;
import com.regional.calendar.mapper.UserFavoriteMapper;
import com.regional.calendar.service.UserFavoriteService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserFavoriteServiceImpl extends ServiceImpl<UserFavoriteMapper, UserFavorite> implements UserFavoriteService {

    @Override
    public boolean toggleFavorite(Long userId, Integer targetType, Long targetId) {
        UserFavorite existing = getOne(new LambdaQueryWrapper<UserFavorite>()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getTargetType, targetType)
                .eq(UserFavorite::getTargetId, targetId));

        if (existing != null) {
            // 已收藏，取消收藏
            removeById(existing.getId());
            return false;
        } else {
            // 未收藏，添加收藏
            UserFavorite favorite = new UserFavorite();
            favorite.setUserId(userId);
            favorite.setTargetType(targetType);
            favorite.setTargetId(targetId);
            favorite.setStatus(1);
            favorite.setCreateTime(LocalDateTime.now());
            favorite.setUpdateTime(LocalDateTime.now());
            save(favorite);
            return true;
        }
    }

    @Override
    public boolean isFavorite(Long userId, Integer targetType, Long targetId) {
        return count(new LambdaQueryWrapper<UserFavorite>()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getTargetType, targetType)
                .eq(UserFavorite::getTargetId, targetId)
                .eq(UserFavorite::getStatus, 1)) > 0;
    }

    @Override
    public List<UserFavorite> getByUserId(Long userId, Integer targetType) {
        return list(new LambdaQueryWrapper<UserFavorite>()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getStatus, 1)
                .eq(targetType != null, UserFavorite::getTargetType, targetType)
                .orderByDesc(UserFavorite::getCreateTime));
    }
}
