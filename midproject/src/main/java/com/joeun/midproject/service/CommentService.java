package com.joeun.midproject.service;

import java.util.List;

import com.joeun.midproject.dto.Comment;
import com.joeun.midproject.dto.Page;


public interface CommentService {
  
  public List<Comment> commentList(Page page);

  public int commentInsert(Comment comment);

  public int commentDelete(Comment comment);

  public int commentUpdate(Comment comment);

}
