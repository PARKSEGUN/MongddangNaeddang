package com.mongddangnaeddang.gateway.utility;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtTokenChecker {
    private final String key="mdndmdndmdndmdndmdndmdndmdndmdndmdndmdndmdnd";

    // 변조 검사
    public boolean checkTokenValidation(String accessToken) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(accessToken);
            return true; // 유효한 토큰
        } catch (UnsupportedJwtException e) {
            System.out.println("Unsupported JWT token");
            return false; // 유효하지 않은 토큰 : 변조, 만료
        } catch (MalformedJwtException e) {
            System.out.println("Malformed JWT token");
            return false;
        } catch (SignatureException e) {
            System.out.println("Invalid JWT token");
            return false;
        } catch (ExpiredJwtException e) {
            System.out.println("Expired JWT token");
            return false;
        }
    }
}
