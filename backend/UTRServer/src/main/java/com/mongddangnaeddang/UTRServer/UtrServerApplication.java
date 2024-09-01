package com.mongddangnaeddang.UTRServer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@EnableDiscoveryClient
@SpringBootApplication
public class UtrServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(UtrServerApplication.class, args);
    }
}
