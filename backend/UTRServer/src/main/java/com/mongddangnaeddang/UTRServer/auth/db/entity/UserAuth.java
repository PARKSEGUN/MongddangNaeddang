package com.mongddangnaeddang.UTRServer.auth.db.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserAuth {
    @Id
    @Column(name = "auth_uuid")
    private String authUuid;
    @Column(name = "vendor")
    private String vendor;
    @Column(name = "token")
    private String token;
    @Column(name = "raw_id")
    private String rawId;
}
