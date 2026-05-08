package com.regional.calendar.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	private final JwtAuthenticationFilter jwtAuthenticationFilter;
	private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

	public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter, JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint) {
		this.jwtAuthenticationFilter = jwtAuthenticationFilter;
		this.jwtAuthenticationEntryPoint = jwtAuthenticationEntryPoint;
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
				.csrf(AbstractHttpConfigurer::disable)
				.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
				.authorizeHttpRequests(auth -> auth
						// Swagger
						.requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/swagger-ui.html").permitAll()
						// 公开接口：注册、登录
						.requestMatchers("/v1/user/register", "/v1/user/login").permitAll()
						// 公开接口：基础数据查询（只读）
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/region/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/ethnicity/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/festival/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/festival-image/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/activity/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/holiday/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/content/**").permitAll()
						.requestMatchers(org.springframework.http.HttpMethod.GET, "/v1/config/**").permitAll()
						// 需要登录的接口
						.requestMatchers("/v1/user/info").authenticated()
						.requestMatchers("/v1/favorite/**").authenticated()
						.requestMatchers("/v1/schedule/**").authenticated()
						// 其余请求放行
						.anyRequest().permitAll()
				)
				.exceptionHandling(exception -> exception.authenticationEntryPoint(jwtAuthenticationEntryPoint))
				.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
		return http.build();
	}
}
