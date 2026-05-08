package com.regional.calendar.common.result;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 响应状态码枚举
 */
@Getter
@AllArgsConstructor
public enum ResultCode {

    SUCCESS(200, "操作成功"),
    FAILURE(500, "操作失败"),

    // 参数校验 4xx
    PARAM_ERROR(400, "参数错误"),
    UNAUTHORIZED(401, "未登录或token已过期"),
    FORBIDDEN(403, "没有权限"),
    NOT_FOUND(404, "资源不存在"),

    // 业务错误 1xxx
    USER_NOT_FOUND(1001, "用户不存在"),
    USER_ALREADY_EXISTS(1002, "用户已存在"),
    PASSWORD_ERROR(1003, "密码错误"),
    PHONE_ALREADY_EXISTS(1004, "手机号已被注册"),
    EMAIL_ALREADY_EXISTS(1005, "邮箱已被注册"),
    VERIFY_CODE_ERROR(1006, "验证码错误或已过期"),
    TOKEN_INVALID(1007, "Token无效"),
    TOKEN_EXPIRED(1008, "Token已过期"),

    // 数据错误 2xxx
    DATA_NOT_FOUND(2001, "数据不存在"),
    DATA_ALREADY_EXISTS(2002, "数据已存在"),
    DATA_SAVE_FAILED(2003, "数据保存失败"),
    DATA_UPDATE_FAILED(2004, "数据更新失败"),
    DATA_DELETE_FAILED(2005, "数据删除失败"),

    // 系统错误 9xxx
    SYSTEM_ERROR(9001, "系统内部错误"),
    SERVICE_UNAVAILABLE(9002, "服务不可用"),
    REQUEST_TOO_FREQUENT(9003, "请求过于频繁");

    private final int code;
    private final String message;
}
