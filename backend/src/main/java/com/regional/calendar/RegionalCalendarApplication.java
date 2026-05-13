package com.regional.calendar;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.regional.calendar.mapper")
@EnableScheduling
public class RegionalCalendarApplication {

    public static void main(String[] args) {
        SpringApplication.run(RegionalCalendarApplication.class, args);
    }
}
