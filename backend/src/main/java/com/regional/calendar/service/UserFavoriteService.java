package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.UserFavorite;

import java.util.List;

public interface UserFavoriteService extends IService<UserFavorite> {

    /**
     * 切换收藏状态（收藏/取消收藏）
     */
    boolean toggleFavorite(Long userId, Integer targetType, Long targetId);

    /**
     * 检查是否已收藏
     */
    boolean isFavorite(Long userId, Integer targetType, Long targetId);

    /**
     * 获取用户收藏列表
     */
    List<UserFavorite> getByUserId(Long userId, Integer targetType);
}
