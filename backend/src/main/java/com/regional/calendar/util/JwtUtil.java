package com.regional.calendar.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SecurityException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtUtil {

	@Value("${jwt.secret}")
	private String secret;

	@Value("${jwt.expiration}")
	private long expiration;

	private SecretKey getSigningKey() {
		return Keys.hmacShaKeyFor(secret.getBytes());
	}

	/**
	 * 生成 JWT Token
	 */
	public String generateToken(Long userId, String username) {
		Map<String, Object> claims = new HashMap<>();
		claims.put("userId", userId);
		claims.put("username", username);

		return Jwts.builder()
				.claims(claims)
				.subject(String.valueOf(userId))
				.issuedAt(new Date())
				.expiration(new Date(System.currentTimeMillis() + expiration))
				.signWith(getSigningKey())
				.compact();
	}

	/**
	 * 解析 Token，获取 Claims
	 */
	public Claims parseToken(String token) {
		return Jwts.parser()
				.verifyWith(getSigningKey())
				.build()
				.parseSignedClaims(token)
				.getPayload();
	}

	/**
	 * 从 Token 中获取用户ID
	 */
	public Long getUserId(String token) {
		Claims claims = parseToken(token);
		return claims.get("userId", Long.class);
	}

	/**
	 * 从 Token 中获取用户名
	 */
	public String getUsername(String token) {
		Claims claims = parseToken(token);
		return claims.get("username", String.class);
	}

	/**
	 * 验证 Token 是否有效
	 */
	public boolean validateToken(String token) {
		try {
			parseToken(token);
			return true;
		} catch (SecurityException | MalformedJwtException e) {
			// Token 签名无效或格式错误
		} catch (ExpiredJwtException e) {
			// Token 已过期
		} catch (UnsupportedJwtException e) {
			// 不支持的 Token
		} catch (IllegalArgumentException e) {
			// Token 为空
		}
		return false;
	}

	/**
	 * 判断 Token 是否过期
	 */
	public boolean isTokenExpired(String token) {
		try {
			Claims claims = parseToken(token);
			return claims.getExpiration().before(new Date());
		} catch (ExpiredJwtException e) {
			return true;
		}
	}
}
