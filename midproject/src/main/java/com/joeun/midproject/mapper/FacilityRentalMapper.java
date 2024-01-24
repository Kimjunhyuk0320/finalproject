package com.joeun.midproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.joeun.midproject.dto.Comment;
import com.joeun.midproject.dto.FacilityRental;
import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.Team;

@Mapper
public interface FacilityRentalMapper {

    // 게시글 목록
    public List<FacilityRental> list() throws Exception;

    //페이지네이션 게시글 조회 카운트
    public int pageFrListTotalCount(Page page) throws Exception;

    //스켈레톤 UI용 다음 데이터 갯수
    public int nextPageListCount(Page page) throws Exception;

    //페이지네이션 게시글 조회
    public List<FacilityRental> pageFrList(Page page) throws Exception;
    
    // 게시글 조회
    public FacilityRental select(int frNo) throws Exception;

    // 조회수 1 상승
    public int viewsUp(Comment comment) throws Exception;

    // 게시글 등록
    public int insert(FacilityRental facilityRental) throws Exception;
    // 게시글 수정
    public int update(FacilityRental facilityRental) throws Exception;
    // 게시글 삭제
    public int delete(int frNo) throws Exception;

    // 게시글 번호(기본키) 최대값
    public int maxPk() throws Exception;
}
