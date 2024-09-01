package com.mongddangnaeddang.UTRServer.common;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Schema(name = "BaseResponseBody", description = "응답 객체")

public class BaseResponseBody {
    @Schema(name = "message", example = "정상")
    String message;

    @Schema(name = "statusCode", example = "200")
    Integer statusCode;

    private BaseResponseBody() {
    }
//
//    public BaseResponseBody(Integer statusCode) {
//        this.statusCode = statusCode;
//    }
//
//    public BaseResponseBody(Integer statusCode, String message) {
//        this.statusCode = statusCode;
//        this.message = message;
//    }

    public static BaseResponseBody of(String message, Integer statusCode) {
        BaseResponseBody body = new BaseResponseBody();
        body.message = message;
        body.statusCode = statusCode;
        return body;
    }
}
