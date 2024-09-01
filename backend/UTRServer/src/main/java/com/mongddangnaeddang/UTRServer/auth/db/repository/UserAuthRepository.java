package com.mongddangnaeddang.UTRServer.auth.db.repository;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserAuth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAuthRepository extends JpaRepository<UserAuth, String> {
    UserAuth findByAuthUuid(String authUuid);
}
