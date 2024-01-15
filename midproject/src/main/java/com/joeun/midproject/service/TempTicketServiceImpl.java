package com.joeun.midproject.service;


import java.util.Calendar;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.joeun.midproject.dto.TempTicket;
import com.joeun.midproject.dto.Ticket;
import com.joeun.midproject.mapper.TempTicketMapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class TempTicketServiceImpl implements TempTicketService {

    @Autowired
    TempTicketMapper tempTicketMapper;

    // 게시글 번호로 임시 티켓 + 판매 티켓 매수 조회하기
    @Override
    public int listByBoardNo(int boardNo){
        int ticketCount = 0;
        try {
            TempTicket tempTicket = tempTicketMapper.listByBoardNo(boardNo);
            ticketCount = tempTicket.getTicketCount();
        } catch (Exception e) {
            log.info(e + "");
            e.printStackTrace();
        };
        return ticketCount;
    }
    
    // 티켓 구매 화면 진입 시 임시 티켓 테이블에 등록
    @Override
    public int insertTempTicket(Ticket ticket){
        int ticketCount = ticket.getCount();
        int result = 0;
        for(int i = 0; i < ticketCount; i++){
            try {
                result += tempTicketMapper.insertTempTicket(ticket);
            } catch (Exception e) {
                log.info(e + "");
                e.printStackTrace();
            }
        }
        return result;
    }
    
    // 결제 성공 시 전화번호로 임시 티켓 삭제
    @Override
    public int delete(Ticket ticket){
        int result = 0;
        
        try {
            result += tempTicketMapper.delete(ticket);
        } catch (Exception e) {
            log.info(e + "");
            e.printStackTrace();
        }
        
        return result;
    }
    
    // 스케줄러로 임시티켓 생성된지 5분 지났을 시 삭제
    @Override
    @Scheduled(fixedRate = 120000) // 2분(120,000 밀리초)마다 실행
    public void deleteTempTicket() {
        int result = 0;

        try {
            // 현재 시간에서 5분 이전의 시간을 계산
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, -3);
            Date thresholdTime = calendar.getTime();

            // 삭제 메소드 호출
            result = tempTicketMapper.deleteTempTicket(thresholdTime);
        } catch (Exception e) {
            log.error("Error in deleteTempTicket: {}", e.getMessage());
            e.printStackTrace();
        }

        log.info("Scheduled deleteTempTicket executed. Deleted {} rows.", result);
    }
    
}
