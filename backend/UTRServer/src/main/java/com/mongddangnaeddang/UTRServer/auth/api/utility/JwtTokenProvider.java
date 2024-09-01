package com.mongddangnaeddang.UTRServer.auth.api.utility;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtTokenProvider {
//    @Value("${jwt.key}")
    private String key="mdndmdndmdndmdndmdndmdndmdndmdndmdndmdndmdnd";
//    @Value("${jwt.issuer}")
    private String issuer="mongddangnaeddang.com";
//    @Value("${jwt.expseconds}")
    private long expseconds=315360000000L;

    public String createToken(String authUuid) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + expseconds);

        System.out.println(now);
        System.out.println(validity);

        return Jwts.builder()
                .setHeaderParam("alg", "HS256") // 기본값
                .setHeaderParam("typ", "JWT") // 기본값
                .setSubject(authUuid)
                .setIssuer(issuer)
                .setIssuedAt(now)
                .setExpiration(validity)
                .signWith(SignatureAlgorithm.HS256, key)
                .compact();
    }

    // 변조 검사
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token);
            System.out.println("변조되지 않은 토큰");
            return true;
        } catch (SignatureException e) {
            // 서명 검증 실패
            System.out.println("변조된 토큰");
        }
        return false;
    }

    public String getTokenData(String token) {
        Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
        Date exp = claims.getExpiration();
        System.out.println(claims.getSubject());
        System.out.println(claims.getIssuer());
        System.out.println(claims.getIssuedAt());
        System.out.println(claims.getExpiration());
        return token;
    }

    public boolean checkTokenExpiration(String token) {
        Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
        Date exp = claims.getExpiration();
        Date now = new Date();
        return now.before(exp);
    }
}
