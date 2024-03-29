package com.joeun.midproject.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.joeun.midproject.dto.Files;
import com.joeun.midproject.dto.LiveBoard;
import com.joeun.midproject.dto.Ticket;
import com.joeun.midproject.dto.UserAuth;
import com.joeun.midproject.dto.Users;
import com.joeun.midproject.mapper.FileMapper;
import com.joeun.midproject.mapper.LiveBoardMapper;
import com.joeun.midproject.mapper.TicketMapper;
import com.joeun.midproject.mapper.UserMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private TicketMapper ticketMapper;

    @Autowired
    private LiveBoardMapper liveBoardMapper;

    @Autowired
    private FileMapper fileMapper;

    @Value("${upload.path}")
    private String uploadPath;

    @Override
    public int insert(Users user, HttpServletRequest request) throws Exception {
        // 비밀번호 암호화
        String password = user.getPassword();
        if (password != null) {
            String encodedPw = passwordEncoder.encode(password);
            user.setPassword(encodedPw);
        } else {
            // 처리할 내용이나 예외 처리를 추가할 수 있음
            throw new IllegalArgumentException("Password cannot be null");
        }
        // 회원 등록
        int result = userMapper.insert(user);

        // 권한 등록
        if (result > 0) {
            UserAuth userAuth = new UserAuth();
            userAuth.setUsername(user.getUsername());
            if (user.getAuth() == 0) {
                userAuth.setAuth("ROLE_USER");
            }
            if (user.getAuth() == 1) {
                userAuth.setAuth("ROLE_CLUB");
            }
            if (user.getAuth() == 2) {
                userAuth.setAuth("ROLE_BAND");
            }
            result = userMapper.insertAuth(userAuth);
        }

        if (result > 0) {
            // 파일 업로드
            MultipartFile file = user.getFile();

            if (file != null && !file.isEmpty()) {

                // 파일 정보 : 원본파일명, 파일 용량, 파일 데이터
                String originName = file.getOriginalFilename();
                long fileSize = file.getSize();
                byte[] fileData = file.getBytes();

                // 업로드 경로
                // 파일명 중복 방지 방법(정책)
                // - 날짜_파일명.확장자
                // - UID_파일명.확장자

                // UID_강아지.png
                String fileName = UUID.randomUUID().toString() + "_" + originName;

                // c:/upload/UID_강아지.png
                String filePath = uploadPath + "/" + fileName;

                // 파일업로드
                // - 서버 측, 파일 시스템에 파일 복사
                // - DB 에 파일 정보 등록
                File uploadFile = new File(uploadPath, fileName);
                FileCopyUtils.copy(fileData, uploadFile); // 파일 업로드

                // FileOutputStream fos = new FileOutputStream(uploadFile);
                // fos.write(fileData);
                // fos.close();

                Files uploadedFile = new Files();
                uploadedFile.setParentTable("users");
                uploadedFile.setParentUsername(user.getUsername());
                uploadedFile.setFileName(fileName);
                uploadedFile.setPath(filePath);
                uploadedFile.setOriginName(originName);
                uploadedFile.setFileSize(fileSize);
                uploadedFile.setFileCode(2);
                // 파일DB등록
                fileMapper.insert(uploadedFile);

                // 유저DB에서 방금등록한 fileNo가져와 객체에 담기
                user.setProfileNo(fileMapper.maxPk());
                result = userMapper.profileSet(user);
            }
        }
        return result;
    }

    @Override
    public Users select(String username) throws Exception {
        return userMapper.select(username);
    }

    @Override
    public void login(Users user, HttpServletRequest requset) throws Exception {

        String username = user.getUsername();
        String password = user.getUserPwCheck();
        log.info("username : " + username);
        log.info("password : " + password);
        // 아이디, 패스워드 인증 토큰 생성
        UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(username, password);

        // 토큰에 요청정보를 등록
        token.setDetails(new WebAuthenticationDetails(requset));

        // 토큰을 이용하여 인증(로그인)
        Authentication authentication = authenticationManager.authenticate(token);

        User authUser = (User) authentication.getPrincipal();
        log.info("인증된 사용자 아이디 : " + authUser.getUsername());

        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    @Override
    public int update(Users user, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 비밀번호 암호화
        String userPw = user.getPassword();

        String encodedPw = passwordEncoder.encode(userPw);
        user.setPassword(encodedPw);

        int result = userMapper.update(user);
        // 권한 등록
        if (result > 0) {
            UserAuth userAuth = new UserAuth();
            userAuth.setUsername(user.getUsername());
            log.info("테스트 : 권환 정보 = " + user.getAuth());
            if (user.getAuth() == 0) {
                userAuth.setAuth("ROLE_USER");
            }
            if (user.getAuth() == 1) {
                userAuth.setAuth("ROLE_CLUB");
            }
            if (user.getAuth() == 2) {
                userAuth.setAuth("ROLE_BAND");
            }
            result = userMapper.updateAuth(userAuth);
        }

        if (result > 0) {
            // 파일 업로드
            MultipartFile file = user.getFile();

            if (file != null && !file.isEmpty()) {

                // 파일 정보 : 원본파일명, 파일 용량, 파일 데이터
                String originName = file.getOriginalFilename();
                long fileSize = file.getSize();
                byte[] fileData = file.getBytes();

                // 업로드 경로
                // 파일명 중복 방지 방법(정책)
                // - 날짜_파일명.확장자
                // - UID_파일명.확장자

                // UID_강아지.png
                String fileName = UUID.randomUUID().toString() + "_" + originName;

                // c:/upload/UID_강아지.png
                String filePath = uploadPath + "/" + fileName;

                // 파일업로드
                // - 서버 측, 파일 시스템에 파일 복사
                // - DB 에 파일 정보 등록
                File uploadFile = new File(uploadPath, fileName);
                FileCopyUtils.copy(fileData, uploadFile); // 파일 업로드

                // FileOutputStream fos = new FileOutputStream(uploadFile);
                // fos.write(fileData);
                // fos.close();

                Files uploadedFile = new Files();
                uploadedFile.setParentTable("users");
                uploadedFile.setParentUsername(user.getUsername());
                uploadedFile.setFileName(fileName);
                uploadedFile.setPath(filePath);
                uploadedFile.setOriginName(originName);
                uploadedFile.setFileSize(fileSize);
                uploadedFile.setFileCode(2);
                // 파일DB등록
                fileMapper.insert(uploadedFile);

                Integer preProfileNo = userMapper.select(user.getUsername()).getProfileNo();

                if (preProfileNo != null) {

                    fileMapper.delete(preProfileNo);

                }

                // 유저DB에서 방금등록한 fileNo가져와 객체에 담기
                user.setProfileNo(fileMapper.maxPk());
                result = userMapper.profileSet(user);
            }
        }
        return result;
    }

    @Override
    public int delete(String userId) throws Exception {
        int result = userMapper.delete(userId);
        return result;
    }

    @Override
    public Users readOnlyPhone(String phone) {
        return userMapper.readOnlyPhone(phone);
    }

    @Override
    public List<Ticket> listByPhone(Users users) throws Exception {
        String phone = users.getPhone();
        List<Ticket> ticketList = ticketMapper.listByPhone(phone);
        for (int i = 0; i < ticketList.size(); i++) {
            int boardNo = ticketList.get(i).getBoardNo();
            LiveBoard LiveBoard = liveBoardMapper.select(boardNo);
            ticketList.get(i).setTitle(LiveBoard.getTitle());
            ticketList.get(i).setPrice(LiveBoard.getPrice());
            ticketList.get(i).setAddress(LiveBoard.getAddress());
            ticketList.get(i).setLiveDate(LiveBoard.getLiveDate());
            ticketList.get(i).setLiveTime(LiveBoard.getLiveTime());
            ticketList.get(i).setLocation(LiveBoard.getLocation());
            Files file = new Files();
            file.setParentTable("live_board");
            file.setParentNo(boardNo);
            file = fileMapper.selectThumbnail(file);
            ticketList.get(i).setThumbnail(file.getFileNo());
        }
        return ticketList;
    }

    @Override
    public List<Ticket> listByUserName(Users users) throws Exception {
        String username = users.getUsername();
        List<Ticket> ticketList = ticketMapper.listByUserName(username);

        return ticketList;
    }

    @Override
    public Users readOnlyNickname(String nickname) {
        return userMapper.readOnlyNickname(nickname);
    }

}