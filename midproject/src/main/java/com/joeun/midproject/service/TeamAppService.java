package com.joeun.midproject.service;

import java.util.List;

import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.TeamApp;

public interface TeamAppService {
  
  public int insert(TeamApp teamApp) throws Exception;
  
  public List<TeamApp> listByLeader(Page page);

  public List<TeamApp> listByMember(Page page);

  public int delete(TeamApp teamApp);

  public TeamApp read(TeamApp teamApp);

  public int accept(TeamApp teamApp);

  public int denied(TeamApp teamApp);

  public int confirmed(TeamApp teamApp) throws Exception;

}