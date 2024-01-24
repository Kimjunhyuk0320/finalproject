package com.joeun.midproject.dto;

import lombok.Data;

/*
 * 현재 페이지 번호
 * 페이지당 게시글 수
 * 전체 개시글 수
 * 노출 페이지 개수 (웹 페이지네이션 용)
 * 페이지박스 시작번호 (웹 페이지네이션 용)
 * 페이지박스 끝번호 (웹 페이지네이션 용)
 * 전체 게시글 첫 번호 (웹 페이지네이션 용)
 * 전체 게시글 마지막 번호 (웹 페이지네이션 용)
 */

@Data
public class Page {
    private static final int PAGE_NUM = 1; // 현재 페이지 기본값
    private static final int ROWS = 10; // 페이지당 게시글 수 기본값
    private static final int COUNT = 10; // 노출 페이지 개수

    // 필수 데이터
    private int page; // 현재 페이지 번호
    private int rows; // 페이지 당 개시글 수
    private int count; // 노출 페이지 개수
    private int total; // 전체 데이터 수

    // 수식 데이터
    private int start; // 페이지박스 시작 번호
    private int end; // 페이지박스 끝 번호
    private int prev; // 페이지박스 이전 번호
    private int next; // 페이지박스 다음 번호
    private int first; // 전체 게시글 첫 번호
    private int last; // 전체 게시글 마지막 번호

    private int index; // 데이터 순서 번호

    private int nextIndex; // 스켈레톤 UI용 다음 인덱스 수
    private int nextCount; // 스켈레톤 UI용 데이터 수

    //검색조건
    private String keyword;
    private int searchType;
    private int order;

    //회원조건
    private String username;

    //댓글조건
    private String parentTable;
    private int parentNo;

    // 생성자
    public Page() {
        this(0);
    }

    public Page(int total) {
        this(PAGE_NUM, total);
        this.total = total;
    }

    public Page(int page, int total) {
        this(page, ROWS, COUNT, total);
    }

    public Page(int page, int rows, int count, int total) {
        this.page = page;
        this.rows = rows;
        this.count = count;
        this.total = total;
        this.searchType = 0;
        this.order = 0;
        this.keyword = "";
        this.username = "GUEST";
        calc();
    }

    //setter
    public void setTotal(int total){
        this.total = total;
        calc();
    }

    // 페이지 처리
    public void calc() {
        // 시작번호
        this.start = this.total != 0 ? (this.page - 1 / this.count) * this.count + 1 : 1;

        // 끝 번호
        this.end = this.total != 0 ? ((this.page - 1) / this.count + 1) * this.count : 1;
        if (this.end > this.last) this.end = this.last;

        // 시작 번호
        this.first = 1;

        // 마지막 번호
        this.last = this.total != 0 ? (this.total - 1) / this.rows + 1 : 1;

        // 이전번호
        this.prev = this.page > 1 ? this.page - 1 : 1;

        // 이전번호
        this.next = this.page < this.last ? this.page + 1 : this.last;

        // 데이터 시작 순서 번호
        this.index = (this.page - 1) * this.rows;

        // 다음 인덱스 번호
        this.nextIndex = (this.page) * this.rows;

    }
}
