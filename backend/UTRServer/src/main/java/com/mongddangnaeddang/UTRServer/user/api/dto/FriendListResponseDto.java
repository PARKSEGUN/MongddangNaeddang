package com.mongddangnaeddang.UTRServer.user.api.dto;

import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class FriendListResponseDto {
    @Column(name = "nickname")
    private String nickname;

    @Column(name = "profile_image")
    private String profile_image;

    @Column(name = "total_distance")
    private double total_distance;

    @Column(name = "comment")
    private String comment;
}