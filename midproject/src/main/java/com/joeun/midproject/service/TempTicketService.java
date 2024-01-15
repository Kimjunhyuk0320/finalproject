package com.joeun.midproject.service;

import com.joeun.midproject.dto.Ticket;

public interface TempTicketService {
    // 게시글 번호로 임시 티켓 + 판매 티켓 매수 조회하기 - boardNo
    public int listByBoardNo(int boardNo);

    // 티켓 구매 화면 진입 시 임시 티켓 테이블에 등록 - boardNo, phone
    public int insertTempTicket(Ticket ticket);
    
    // 결제 성공 시 전화번호로 임시 티켓 삭제 - phone
    public int delete(Ticket ticket);
    
    // 스케줄러로 임시티켓 생성된지 5분 지났을 시 삭제
    void deleteTempTicket();

}
