package com.regional.calendar.config;

import com.regional.calendar.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

	private final JwtUtil jwtUtil;

	private static final String AUTHORIZATION_HEADER = "Authorization";
	private static final String BEARER_PREFIX = "Bearer ";

	public JwtAuthenticationFilter(JwtUtil jwtUtil) {
		this.jwtUtil = jwtUtil;
	}

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		String token = extractToken(request);
		if (token != null && jwtUtil.validateToken(token)) {
			Long userId = jwtUtil.getUserId(token);
			String username = jwtUtil.getUsername(token);
			request.setAttribute("userId", userId);

			UsernamePasswordAuthenticationToken authentication =
					new UsernamePasswordAuthenticationToken(userId, null, Collections.emptyList());
			authentication.setDetails(username);
			SecurityContextHolder.getContext().setAuthentication(authentication);
		}
		filterChain.doFilter(request, response);
	}

	private String extractToken(HttpServletRequest request) {
		String header = request.getHeader(AUTHORIZATION_HEADER);
		if (StringUtils.hasText(header) && header.startsWith(BEARER_PREFIX)) {
			return header.substring(BEARER_PREFIX.length());
		}
		return null;
	}
}
