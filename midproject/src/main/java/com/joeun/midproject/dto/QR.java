package com.joeun.midproject.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class QR {
    private int qrNo;
    private String parentTable;
    private int parentNo;
    private String url;
    private String name;
    private String filePath;
    private int fileSize;
    private Date regDate;
    private Date updDate;
}
