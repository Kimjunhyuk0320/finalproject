package com.joeun.midproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.joeun.midproject.dto.Comment;
import com.joeun.midproject.dto.Page;

@Mapper
public interface CommentMapper {

  public List<Comment> commentList(Page page);

  public Comment select(Integer commentNo);

  public int totalCount(Page page);

  public int commentInsert(Comment comment);

  public int commentDelete(Comment comment);

  public int commentUpdate(Comment comment);

  public int maxPk();
  
}
