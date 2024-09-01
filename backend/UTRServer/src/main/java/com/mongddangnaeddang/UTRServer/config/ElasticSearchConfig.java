package com.mongddangnaeddang.UTRServer.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchConfiguration;


@Configuration
public class ElasticSearchConfig extends ElasticsearchConfiguration {

    @Value("${spring.elasticsearch.uris}")
    private String esHost;

    @Override
    public ClientConfiguration clientConfiguration() {
        // ES 클라이언트 연결 구성
        return ClientConfiguration.builder()
                .connectedTo(esHost)
                .build();
    }


}