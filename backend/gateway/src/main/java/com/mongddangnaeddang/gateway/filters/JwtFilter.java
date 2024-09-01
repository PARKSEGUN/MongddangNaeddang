package com.mongddangnaeddang.gateway.filters;

import com.mongddangnaeddang.gateway.utility.JwtTokenChecker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

@Component
public class JwtFilter extends AbstractGatewayFilterFactory<JwtFilter.Config> {
    @Autowired
    JwtTokenChecker jwtTokenChecker;

    public JwtFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            System.out.println("jwt filter!");

            HttpHeaders headers = exchange.getRequest().getHeaders();
            String accessToken = headers.getFirst("accessToken");

            if(accessToken==null) {
                System.out.println("no accessToken");
                exchange.getResponse().setStatusCode(HttpStatus.BAD_REQUEST);
                return exchange.getResponse().setComplete();
            }

            if(!jwtTokenChecker.checkTokenValidation(accessToken)) {
                System.out.println("accessToken is not valid.");
                exchange.getResponse().setStatusCode(HttpStatus.BAD_REQUEST);
                return exchange.getResponse().setComplete();
            }

            System.out.println("accessToken has been validated.");
            return chain.filter(exchange);
        };
    }

    public static class Config {
        // 필요한 경우 설정 속성을 여기에 추가
    }
}