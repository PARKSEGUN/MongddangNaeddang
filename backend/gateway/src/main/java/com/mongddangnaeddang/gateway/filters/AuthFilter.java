package com.mongddangnaeddang.gateway.filters;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongddangnaeddang.gateway.dto.UserBody;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferFactory;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.http.*;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpRequestDecorator;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

@Component
public class AuthFilter extends AbstractGatewayFilterFactory<AuthFilter.Config> {

    public AuthFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            HttpHeaders headers = exchange.getRequest().getHeaders();
            System.out.println(headers);
            String vendorAccessToken = headers.getFirst("accessToken"); // vendor의 accessToken 추출

            // body 읽기
            return DataBufferUtils.join(exchange.getRequest().getBody())
                    .flatMap(dataBuffer -> {
                        byte[] bytes = new byte[dataBuffer.readableByteCount()];
                        dataBuffer.read(bytes);
                        DataBufferUtils.release(dataBuffer);  // DataBuffer 해제
                        String body = new String(bytes, StandardCharsets.UTF_8); // JsonString 인 body
                        String vendor = extractVendorFromBody(body); // body에서 vendor 추출

                        // vendor에 AT 전달
                        return authenticateVendor(vendor, vendorAccessToken)
                                .flatMap(authResponse -> {
                                    if (authResponse.equals("validation_failure")) { // vendor AT 만료된 경우 400 응답
                                        System.out.println("vendor AT 인증 실패. vendor의 AT이 만료됨.");
                                        exchange.getResponse().setStatusCode(HttpStatus.BAD_REQUEST);
                                        return exchange.getResponse().setComplete();
                                    } else { // validation 성공 시 authUuid -> 기존 요청의 헤더와 바디에 "authUuid" = authResponse 추가
                                        System.out.println("vendor AT 인증 성공. auth controller 로 전달.");
                                        String[] parts = authResponse.split(":");

                                        ObjectMapper objectMapper = new ObjectMapper();
                                        UserBody ub = null;
                                        String newBody = null;
                                        try {
                                            ub = objectMapper.readValue(body, UserBody.class);
                                            ub.setRawId(parts[0]);
                                            ub.setDefaultNickname(parts[1]);
                                            newBody = objectMapper.writeValueAsString(ub);
                                        } catch (JsonProcessingException e) {
                                            System.out.println("데이터 추가 실패");
                                            exchange.getResponse().setStatusCode(HttpStatus.BAD_REQUEST);
                                            return exchange.getResponse().setComplete();
                                        }
                                        byte[] newBytes = newBody.getBytes(StandardCharsets.UTF_8);

                                        ServerHttpRequest mutatedRequest = new ServerHttpRequestDecorator(exchange.getRequest()) {
                                            @Override
                                            public HttpHeaders getHeaders() {
                                                HttpHeaders headers = new HttpHeaders();
                                                headers.putAll(super.getHeaders());
                                                 int contentLength = newBytes.length;
                                                 headers.setContentLength(contentLength);
                                                return headers;
                                            }

                                            @Override
                                            public Flux<DataBuffer> getBody() {
                                                DataBufferFactory bufferFactory = exchange.getResponse().bufferFactory();
                                                return Flux.just(bufferFactory.wrap(newBytes));
                                            }
                                        };

                                        ServerWebExchange mutatedExchange = exchange.mutate()
                                                .request(mutatedRequest)
                                                .build();

                                        return chain.filter(mutatedExchange);
                                    }
                                });
                    });
        };
    }

    // 바디에서 벤더 추출
    private String extractVendorFromBody(String body) {
        ObjectMapper objectMapper = new ObjectMapper();
        String vendor = null;
        try {
            JsonNode jsonNode = objectMapper.readTree(body);
            vendor = jsonNode.get("vendor").asText();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return vendor;
    }

    // 벤더 인증 요청
    private Mono<String> authenticateVendor(String vendor, String accessToken) {
        ResponseEntity<String> response = null;
        RestTemplate restTemplate = new RestTemplate();
        ObjectMapper objectMapper = new ObjectMapper(); // Json 파싱용
        String rawId = "";
        String defaultNickname = "";

        if (vendor.equals("kakao")) {
            try { // 유효한 vendor AT 인지 확인
                String url = "https://kapi.kakao.com/v2/user/me";
                HttpHeaders headers = new HttpHeaders();
                headers.set("Authorization", "Bearer " + accessToken);
                HttpEntity<String> entity = new HttpEntity<>(headers);
                response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
            } catch (HttpClientErrorException e) {
                return Mono.just("validation_failure");
            }

            try {
                JsonNode rootNode = objectMapper.readTree(response.getBody());
                rawId = rootNode.path("id").asText();
                defaultNickname = rootNode.path("properties").path("nickname").asText();
            } catch (IOException e) {
                return Mono.just("validation_failure");
            }

        } else { // vendor.equals("naver")
            try { // 유효한 vendor AT 인지 확인
                String url = "https://openapi.naver.com/v1/nid/me";
                HttpHeaders headers = new HttpHeaders();
                headers.set("Authorization", "Bearer " + accessToken);
                HttpEntity<String> entity = new HttpEntity<>(headers);
                response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
            } catch (HttpClientErrorException e) {
                return Mono.just("validation_failure");
            }

            try {
                JsonNode rootNode = objectMapper.readTree(response.getBody());
                rawId = rootNode.path("response").path("id").asText();
                defaultNickname = rootNode.path("response").path("nickname").asText();
            } catch (IOException e) {
                return Mono.just("validation_failure");
            }
        }

        String authResponse = rawId + ":" + defaultNickname;
        return Mono.just(authResponse); // vendor 에서 받아온 id
    }

    public static class Config {
        // 필요한 경우 설정 속성을 여기에 추가
    }
}