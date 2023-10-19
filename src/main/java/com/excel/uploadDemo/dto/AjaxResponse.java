package com.excel.uploadDemo.dto;

import java.util.List;

import lombok.Data;

@Data
public class AjaxResponse {

	private String status;
	
	private List<ManualAdhocDto> manualAdhocData;
}
