FROM redis:latest

# Redis 설정 파일을 복사
COPY redis.conf /usr/local/etc/redis/redis.conf

# Redis 서버를 실행할 때 사용할 설정 파일을 지정
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
