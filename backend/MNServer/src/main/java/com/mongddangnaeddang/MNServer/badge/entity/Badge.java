package com.mongddangnaeddang.MNServer.badge.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Badge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="badge_id")
    private int id;

    private String name;

    private int condition;

    @OneToMany(mappedBy="badge" , cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserBadge> userBadges = new ArrayList<>();

    //== add ==//
    // 사용자 뱃지 add
    public void addUserBadge(UserBadge userBadge) {
        this.userBadges.add(userBadge);
        userBadge.setBadge(this);
    }
}
