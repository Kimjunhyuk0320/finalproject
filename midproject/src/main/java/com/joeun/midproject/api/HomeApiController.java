package com.joeun.midproject.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.joeun.midproject.dto.FacilityRental;
import com.joeun.midproject.dto.LiveBoard;
import com.joeun.midproject.dto.Page;
import com.joeun.midproject.dto.Team;
import com.joeun.midproject.service.FacilityRentalService;
import com.joeun.midproject.service.LiveBoardService;
import com.joeun.midproject.service.TeamService;

@RestController
@RequestMapping("/api/home")
public class HomeApiController {

    @Autowired
    private TeamService teamService;

    @Autowired
    private LiveBoardService liveBoardService;

    @Autowired
    private FacilityRentalService facilityRentalService;

    // @GetMapping({ "", "/" })
    // public String home(HttpServletRequest request) {
        // CsrfToken csrf = (CsrfToken) request.getAttribute(CsrfToken.class.getName());

        // if (csrf != null) {
            // String token = csrf.getToken();
            // 여기에서 token을 어떻게 활용할지에 대한 로직 추가
        // } else {
            // CSRF 토큰이 없을 때의 처리 로직
        // }
        // return "index";
    // }

    @GetMapping("/totalSearch")
    public ResponseEntity<Map<String, List<?>>> searchPro(Page page) {
        try {
            page.setRows(4);
            page.setOrder(2);
            List<LiveBoard> liveBoardList = liveBoardService.liveBoardPageList(page);
            List<FacilityRental> frList = facilityRentalService.pageFrList(page);
            List<Team> teamList = teamService.pageList(page);

            Map<String, List<?>> responseMap = new HashMap<>();
            responseMap.put("liveBoardList", liveBoardList);
            responseMap.put("frList", frList);
            responseMap.put("teamList", teamList);

            return new ResponseEntity<>(responseMap, HttpStatus.OK);
        } catch (Exception e) {
            // 예외 처리 로직
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/moveTotalSearch")
    public String search() {
        return "totalSearch";
    }

}
