package com.joeun.midproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.joeun.midproject.dto.Comment;
import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.PageInfo;
import com.joeun.midproject.dto.Team;

@Mapper
public interface TeamMapper {

  public List<Team> list();

  public int insert(Team team);

  public int update(Team team);

  public int delete(Team team);

  public Team read(Team team);  

  public int addView(Team team);

  public List<Team> listByConfirmedLive(String username);

  public int listByConfirmedLive2TotalCount(Page page);

  public List<Team> listByConfirmedLive2(Page page);

  public PageInfo pageInfo(PageInfo pageInfo);

  public List<Team> pageList(Page page);

  public int nextPageListCount(Page page);

  public int totalCount(PageInfo pageInfo);

  public int confirmed(Team team);

  public int maxPk();

  public int viewUp(Comment comment);
  
}
