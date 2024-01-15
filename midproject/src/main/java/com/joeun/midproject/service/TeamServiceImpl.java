package com.joeun.midproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.PageInfo;
import com.joeun.midproject.dto.Team;
import com.joeun.midproject.mapper.TeamMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TeamServiceImpl implements TeamService{

  @Autowired
  private TeamMapper teamMapper;

  @Override
  public List<Team> list() {

    List<Team> teamList = teamMapper.list();

    return teamList;

  }

  @Override
  public int insert(Team team) {

    int result = teamMapper.insert(team);
    if(result>0){
      return teamMapper.maxPk();
    }else return 0;
  }

  @Override
  public int update(Team team) {

    int result = teamMapper.update(team);
    if(result>0){
      return team.getTeamNo();
    }else return 0;
  }
  
  @Override
  public int delete(Team team) {
    team.setRecStatus(teamMapper.read(team).getRecStatus());
    int result = teamMapper.delete(team);
  
    if(result>0){
      return team.getTeamNo();
    }else return 0;
  }
  
  @Override
  public Team read(Team team) {

    int resultView = teamMapper.addView(team);
    Team resultTeam = new Team();

    if(resultView>0){

      resultTeam = teamMapper.read(team);
      return resultTeam;
    }
    else{

      return resultTeam;

    }

  
  
  }

  @Override
  public List<Team> listByConfirmedLive(String username) {

    List<Team> listByConfirmedList = teamMapper.listByConfirmedLive(username);

    return listByConfirmedList;
    
  }

  @Override
  public PageInfo pageInfo(PageInfo pageInfo) {

    PageInfo pageInfoResult = teamMapper.pageInfo(pageInfo);

    return pageInfoResult;
  }

  @Override
  public List<Team> pageList(Page page) {
    PageInfo pageInfo = new PageInfo();
    pageInfo.setKeyword(page.getKeyword() == null ? "" : page.getKeyword());
    pageInfo.setSearchType(page.getSearchType());
    pageInfo.setTable("team_recruitments");
    page.setTotal(teamMapper.totalCount(pageInfo));

    List<Team> teamList = teamMapper.pageList(page);

    log.info(page.toString());

    return teamList;

  }

  @Override
  public List<Team> listByConfirmedLive2(Page page) {

    page.setTotal(teamMapper.listByConfirmedLive2TotalCount(page));
    List<Team> teamList = teamMapper.listByConfirmedLive2(page);

    log.info(page.toString());

    return teamList;

  }


  
}
