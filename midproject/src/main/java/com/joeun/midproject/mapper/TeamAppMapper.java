package com.joeun.midproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.TeamApp;

@Mapper
public interface TeamAppMapper {

  
  public int insert(TeamApp teamApp);
  
  public int listByLeaderTotalCount(Page page);
  
  public List<TeamApp> listByLeader(Page page);

  public int listByMemberTotalCount(Page page);

  public List<TeamApp> listByMember(Page page);

  public int delete(TeamApp teamApp);

  public TeamApp read(TeamApp teamApp);

  public int accept(TeamApp teamApp);

  public int denied(TeamApp teamApp);

  public int deniedAll(TeamApp teamApp);

  public int confirmed(TeamApp teamApp);

  public List<TeamApp> listByTeamNo(int teamNo);
  
  public int insertLive(TeamApp teamApp);

  public int maxPk();



}
