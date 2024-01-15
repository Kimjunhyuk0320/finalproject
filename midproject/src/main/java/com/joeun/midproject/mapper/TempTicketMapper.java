package com.joeun.midproject.mapper;


import java.util.Date;

import org.apache.ibatis.annotations.Mapper;

import com.joeun.midproject.dto.TempTicket;
import com.joeun.midproject.dto.Ticket;

@Mapper
public interface TempTicketMapper {
    // 게시글 번호로 임시 티켓 + 판매 티켓 매수 조회하기
    public TempTicket listByBoardNo(int boardNo) throws Exception;

    // 티켓 구매 화면 진입 시 임시 티켓 테이블에 등록
    public int insertTempTicket(Ticket ticket) throws Exception;
    
    // 결제 성공 시 전화번호로 임시 티켓 삭제
    public int delete(Ticket ticket) throws Exception;
    
    // 스케줄러로 임시티켓 생성된지 5분 지났을 시 삭제
    public int deleteTempTicket(Date thresholdTime) throws Exception;


}
