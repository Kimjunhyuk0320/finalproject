package com.joeun.midproject.api;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.PageInfo;
import com.joeun.midproject.dto.Team;
import com.joeun.midproject.dto.TeamApp;
import com.joeun.midproject.mapper.TeamMapper;
import com.joeun.midproject.service.CommentService;
import com.joeun.midproject.service.TeamAppService;
import com.joeun.midproject.service.TeamService;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@RequestMapping("/api/user/team")
@RestController
public class MypageTeamApiController {

    @Autowired
    private TeamService teamService;

    @Autowired
    private TeamAppService teamAppService;

    @Autowired
    private TeamMapper teamMapper;

    @Autowired
    private CommentService commentService;


    @GetMapping("/listByLeader")
    public ResponseEntity<Map<String,Object>> listByLeader( Page page, Principal principal) {

        try {
            // teamApp.setUsername(principal.getName());
            List<TeamApp> teamAppList = teamAppService.listByLeader(page);
            Map<String,Object> map = new HashMap<>();
            map.put("data", teamAppList);
            map.put("page", page);
            return new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/listByMember")
    public ResponseEntity<Map<String,Object>> listByMember(Page page, Principal principal) {

        try {
            List<TeamApp> teamAppList = teamAppService.listByMember(page);
            Map<String,Object> map = new HashMap<>();
            map.put("data", teamAppList);
            map.put("page", page);
            return new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/pageInfo")
    public ResponseEntity<PageInfo> pageInfo(PageInfo pageInfo) {
        log.info(pageInfo.toString());
        pageInfo.setTable("confirmed_live");
        pageInfo.setTotalCount(teamMapper.totalCount(pageInfo));
        log.info(pageInfo.toString());

        try {
            PageInfo pageInfoResult = teamService.pageInfo(pageInfo);
            log.info(pageInfoResult.toString());
            return new ResponseEntity<>(pageInfoResult, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/confirmedLiveList")
    public ResponseEntity<Map<String,Object>> confirmedLiveList(Page page) {
        
        try {
            List<Team> pageListResult = teamService.listByConfirmedLive2(page);
            Map<String,Object> map = new HashMap<>();
            map.put("data", pageListResult);
            map.put("page", page);
            return new ResponseEntity<>(map, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/readApp")
    public ResponseEntity<TeamApp> readApp( TeamApp teamApp) {
        
        try {
            TeamApp readApp = teamAppService.read(teamApp);
            return new ResponseEntity<>(readApp, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
