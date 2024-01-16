package com.joeun.midproject.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.joeun.midproject.dto.Comment;
import com.joeun.midproject.dto.LiveBoard;
import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.PageInfo;
import com.joeun.midproject.dto.Team;
import com.joeun.midproject.dto.Ticket;
import com.joeun.midproject.mapper.FileMapper;
import com.joeun.midproject.mapper.TeamMapper;
import com.joeun.midproject.service.CommentService;
import com.joeun.midproject.service.LiveBoardService;
import com.joeun.midproject.service.TempTicketService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/liveBoard")
public class LiveBoardApiController {
    @Autowired
    LiveBoardService liveBoardService;

    @Autowired
    TempTicketService tempTicketService;

    @Autowired
    FileMapper fileMapper;

    @Autowired
    private TeamMapper teamMapper;

    @Autowired
    private CommentService commentService;

    // 페이지 네이션을 이용한 게시글 목록 불러오기
    @GetMapping("/liveBoardPageList")
    public ResponseEntity<?> liveBoardPageList(Page page) {
        log.info("[GET] - /liveBoard/liveBoardPageList");
        try {
            List<LiveBoard> pageListResult = liveBoardService.liveBoardPageList(page);
            Map<String,Object> map = new HashMap<>();
            map.put("data", pageListResult);
            map.put("page", page);
            return new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 페이지네이션 번호수를 위해 페이지 정보를 불러오기
    @GetMapping("/pageInfoLiveBoard")
    public ResponseEntity<?> pageInfoLiveBoard(PageInfo pageInfo) {
        try {
            pageInfo.setTable("live_board");
            pageInfo.setTotalCount(teamMapper.totalCount(pageInfo));
        
        
            PageInfo pageInfoResult = teamMapper.pageInfo(pageInfo);
        
            return new ResponseEntity<>(pageInfoResult, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 공연 게시글 조회
    @GetMapping("/{boardNo}")
    public ResponseEntity<?> read(@PathVariable Integer boardNo) {
        try {
            log.info("[GET] - /liveBoard/:boardNo");

            // 데이터 요청
            LiveBoard liveBoard = liveBoardService.select(boardNo);     // 게시글 정보
            int totalTicketCount = liveBoard.getMaxTickets();
            int soldTicketCount = tempTicketService.listByBoardNo(boardNo);
            int nowTicketCount = totalTicketCount - soldTicketCount;
            liveBoard.setTicketLeft(nowTicketCount);
            return new ResponseEntity<>(liveBoard, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 공연 게시글 등록
    @PostMapping("/insert")
    public ResponseEntity<?> insertPro(LiveBoard liveBoard) {
        try {
            // 데이터 처리
            String liveStTime = liveBoard.getLiveStTime();
            String liveEndTime = liveBoard.getLiveEndTime();
            String liveTime = liveStTime + " ~ " + liveEndTime;
            liveBoard.setLiveTime(liveTime);
            int result = liveBoardService.insert(liveBoard);

            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error in insertPro:", e); // 로그 추가
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 공연 게시글 수정
    @PutMapping("/update")
    public ResponseEntity<?> update(LiveBoard liveBoard) {
        log.info("[PUT] - /api/liveBoard/update");
        try {
            int result = liveBoardService.update(liveBoard);
            int boardNo = liveBoard.getBoardNo();

            Map<String, Object> map = new HashMap<>();
            map.put("result", result);
            map.put("boardNo", boardNo);
    
            return new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
             log.error("Error in update:", e); // 로그 추가
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 티켓 수량 비동기 조회 & 구매 가능시 임시 티켓 생성
    @PostMapping("/ticketNum")
    public ResponseEntity<?> ticketNum(@RequestBody Ticket ticket) {
        Integer count = ticket.getCount();
        try {
            int boardNo = ticket.getBoardNo();
            int totalTicketCount = liveBoardService.select(boardNo).getMaxTickets();
            int purchaseTicketCount = tempTicketService.listByBoardNo(boardNo);
            int ticketLeft = totalTicketCount - purchaseTicketCount;
            // 티켓 수량이 0개 일때 응답
            if( (Integer)count == 0) return new ResponseEntity<>("TICKETZERO", HttpStatus.OK);
            // 잔여티켓보다 구매티켓이 많은경우의 응답
            if( ticketLeft < count) return new ResponseEntity<>("OVERCOUNT", HttpStatus.OK);

            // 잔여티켓의 수가 0 일때 매진 응답
            if( (Integer)ticketLeft == 0 ) return new ResponseEntity<>("ZERO", HttpStatus.OK);

            // 임시 티켓 발행
            int result = tempTicketService.insertTempTicket(ticket);
            if( result == 0){
                log.info("임시 티켓 발행 실패");
                return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
            }
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 티켓 구매 처리 & 임시 티켓 삭제
    @PostMapping("/purchase")
    public ResponseEntity<?> ticket(@RequestBody Ticket ticket) {
        Integer count = ticket.getCount();
        try {
            int boardNo = ticket.getBoardNo();
            int totalTicketCount = liveBoardService.select(boardNo).getMaxTickets();

            // 티켓 테이블에 등록
            int result = 0;
            for(int i = 0 ; i < count ; i++){
                result += liveBoardService.purchase(ticket);
            }

            // 임시 티켓 삭제
            int res = tempTicketService.delete(ticket);
            if( res == 0){
                log.info("결제 완료시 임시 티켓 삭제 실패");
                if( res == 0 ) return new ResponseEntity<>(" FAIL", HttpStatus.OK);
            }
            // 티켓 구매 실패 응답
            if( result == 0 ) return new ResponseEntity<>(" FAIL", HttpStatus.OK);

            //잔여티켓수 0 일시 매진으로 변환
            int afterTicketCount = tempTicketService.listByBoardNo(boardNo);
            int afterCount = totalTicketCount - afterTicketCount;
            if((Integer)afterCount == 0 ){
                int update = liveBoardService.soldOut(boardNo);
            }
            // 성공응답
            return  new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    

    @DeleteMapping("/{boardNo}")
    public ResponseEntity<?> destroy(@PathVariable Integer boardNo) {
        try {
            //TODO Implement Your Logic To Destroy Data And Return Result Through ResponseEntity
            return new ResponseEntity<>("Destroy Result", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }








}
