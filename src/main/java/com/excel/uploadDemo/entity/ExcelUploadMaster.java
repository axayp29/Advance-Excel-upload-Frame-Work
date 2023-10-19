package com.excel.uploadDemo.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Entity
@Data
public class ExcelUploadMaster {

	@Id
	@GeneratedValue
	private Long id;
	
	private String type;
	
	private String fileName;
	
	private String location;
	
	private Long uploadedBy;
	
	private Date uploadedAt;
	
	private Long companyId;
	
	private Long branchId;
	
	private String md5HashCode;
}
