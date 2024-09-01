# Elasticsearch 기본 이미지 설정
FROM docker.elastic.co/elasticsearch/elasticsearch:8.14.3

# 환경 변수 설정
ENV discovery.type=single-node
ENV xpack.security.enabled=false
ENV xpack.security.transport.ssl.enabled=false

# Nori 플러그인 설치
RUN elasticsearch-plugin install analysis-nori

# 포트 설정 (선택 사항)
EXPOSE 9200
EXPOSE 9300
