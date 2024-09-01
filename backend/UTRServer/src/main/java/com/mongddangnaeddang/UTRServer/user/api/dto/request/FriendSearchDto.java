package com.mongddangnaeddang.UTRServer.user.api.dto.request;

import jakarta.persistence.Column;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class FriendSearchDto {
    @Column(name = "authUuid")
    private String authUuid;

    @Column(name = "nickname")
    private String nickname;
}
