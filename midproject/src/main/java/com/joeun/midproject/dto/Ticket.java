package com.joeun.midproject.dto;

import lombok.Data;

@Data
public class Ticket {
    private int ticketNo;
    private String reservationNo;
    private String title;
    private int boardNo;
    private int thumbnail;
    private String name;
    private String phone;
    private String liveDate;
    private String liveTime;
    private int price;
    private String location;
    private String address;
    private String updDate;
    private int refund;
    private int qrNo;
    private Integer count;
}
