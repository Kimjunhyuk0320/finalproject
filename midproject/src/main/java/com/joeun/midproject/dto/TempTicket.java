package com.joeun.midproject.dto;

import lombok.Data;

@Data
public class TempTicket {
    private int tempNo;
    private int boardNo;
    private String phone;
    private String regDate;
    private int ticketCount;
}
