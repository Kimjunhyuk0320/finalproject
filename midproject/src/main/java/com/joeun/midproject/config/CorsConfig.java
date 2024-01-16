// package com.joeun.midproject.config;

// import java.util.Arrays;

// import org.apache.tomcat.util.file.ConfigurationSource;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.web.cors.CorsConfiguration;
// import org.springframework.web.cors.CorsConfigurationSource;
// import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

// @Configuration
// public class CorsConfig {
    
//     @Bean
//     public CorsConfigurationSource corsConfigurationSource(){
//         CorsConfiguration config = new CorsConfiguration();

//         config.setAllowCredentials(true);
//         config.setAllowedOrigins(Arrays.asList("http://10.0.0.2:8080","http://localhost:8080","*"));
//         config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
//         config.setAllowedHeaders(Arrays.asList("*"));
//         config.setExposedHeaders(Arrays.asList("*"));

//         UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//         source.registerCorsConfiguration("/**", config);
//         return source;
//     }
    
// }
