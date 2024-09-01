package com.mongddangnaeddang.UTRServer.image.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@Schema
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class ImageRes {
    @Schema(name = "imageBytes", example = "바이트지롱")
    private byte[] imageBytes;
    @Schema(name = "mimeType", example = "contentType")

    private String mimeType;
}
