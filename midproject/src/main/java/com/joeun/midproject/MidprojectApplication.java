package com.joeun.midproject;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class MidprojectApplication {

	public static void main(String[] args) {
		SpringApplication.run(MidprojectApplication.class, args);
	}

}
