package com.mongddangnaeddang.UTRServer.team.db.repository;

import com.mongddangnaeddang.UTRServer.team.db.entity.TeamDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.List;

public interface TeamSearchRepository extends ElasticsearchRepository<TeamDocument, String> {

    List<TeamDocument> findByNameStartingWith(String name);

    void deleteByTeamId(int teamId);
}
