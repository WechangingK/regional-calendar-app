package com.regional.calendar.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

	@Bean
	public OpenAPI openAPI() {
		return new OpenAPI()
				.info(new Info()
						.title("地区特色日历App API")
						.description("提供地区、民族、节日、活动、放假安排等数据查询，以及用户注册登录、收藏、日程管理等功能")
						.version("1.0.0"))
				.addSecurityItem(new SecurityRequirement().addList("Bearer"))
				.components(new Components()
						.addSecuritySchemes("Bearer", new SecurityScheme()
								.type(SecurityScheme.Type.HTTP)
								.scheme("bearer")
								.bearerFormat("JWT")
								.description("输入登录接口返回的 JWT Token")));
	}
}
