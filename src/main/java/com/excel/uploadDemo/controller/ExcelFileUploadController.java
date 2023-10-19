package com.excel.uploadDemo.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.excel.uploadDemo.dto.AjaxResponse;
import com.excel.uploadDemo.dto.ManualAdhocDto;
import com.excel.uploadDemo.utils.ColumnValidator;
import com.excel.uploadDemo.utils.CommonConstant;
import com.excel.uploadDemo.utils.CustomValidator;
import com.excel.uploadDemo.utils.DataType;
import com.excel.uploadDemo.utils.ExcelUtils;
import com.excel.uploadDemo.utils.FileUploadService;

@Controller
public class ExcelFileUploadController {

	@Autowired
	private FileUploadService fileUploadService;

	@GetMapping(value = "index")
	public String getDemoPage() {

		return "index";
	}

	@PostMapping(value = "/upload")
	@ResponseBody
	@Transactional
	public AjaxResponse excelUpload(@RequestPart("excelFile") MultipartFile files) {
	    try {
	        XSSFWorkbook workbook = new XSSFWorkbook(files.getInputStream());
	        XSSFSheet worksheet = workbook.getSheetAt(0);

	        List<ManualAdhocDto> manualAdhocs = new ArrayList<>();
	        
	        // at index 0 header row consider so loops start from 1 directly
	        for (int index = 1; index < worksheet.getPhysicalNumberOfRows(); index++) {
	            XSSFRow row = worksheet.getRow(index);

	            ManualAdhocDto manualAdhoc = new ManualAdhocDto();
	            
	            // column and Data Type Map creation
	            Map<Integer, DataType> expectedDataTypes = ColumnValidator.columnAndDataType(
	            		Arrays.asList( DataType.NUMERIC,
	   	            		 DataType.STRING,
		            		 DataType.STRING,
		            		 DataType.STRING,
		            		 DataType.STRING,
		            		 DataType.STRING,
		            		 DataType.NUMERIC)
	            		
	            		 );
	            
	            // Here all the column convert into the String 
				
					manualAdhoc.setId(ExcelUtils.getCellValueAsString(row.getCell(0)));
					manualAdhoc.setDate(ExcelUtils.getCellValueAsString(row.getCell(1)));
					manualAdhoc.setEmpCd(ExcelUtils.getCellValueAsString(row.getCell(2)));
					manualAdhoc.setEmployeeName(ExcelUtils.getCellValueAsString(row.getCell(3)));
					manualAdhoc.setAttendanceTime(ExcelUtils.getCellValueAsString(row.getCell(4)));
					manualAdhoc.setAttendanceType(ExcelUtils.getCellValueAsString(row.getCell(5)));
					manualAdhoc.setShiftCode(ExcelUtils.getCellValueAsString(row.getCell(6)));
			
					// checked rows values if not validate with column data type any single entry then not consider in calculation 
		            boolean allValid = expectedDataTypes.keySet()
		                    .stream()
		                    .map(key -> ColumnValidator.isTypeValid(ExcelUtils.getCellValueAsString(row.getCell(key)), expectedDataTypes.get(key)))
		                    .allMatch(Boolean::booleanValue);
					
		            // if the column data type not matched then simply this is not valid
					if(!allValid)
					{
						manualAdhoc.setValid(false);
						manualAdhoc.setError("Column Data Type Not Macthed");
					}
					else {
						// here applied custom validation is not valid then set valid false otherwise true
						manualAdhoc.setValid(CustomValidator.ValidateManualAdhocData(manualAdhoc));
					}
					manualAdhocs.add(manualAdhoc);
				
			}
	        AjaxResponse response = new AjaxResponse();
	        response.setManualAdhocData(manualAdhocs);
	        response.setStatus("SUCCESS");

	        // Upload and save the data into the database
	        fileUploadService.uploadFile(1, files, CommonConstant.ATTENDANCE_ADDHOC, 1, 9);

	        workbook.close();

	        return response;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return new AjaxResponse();
	}

	

	@PostMapping(value = "/syncData")
	@ResponseBody
	public AjaxResponse syncData(@RequestBody List<List<String>> selectedData) {
	    AjaxResponse response = new AjaxResponse();

	    try {
	    	
	    	  // column and Data Type Map creation
            Map<Integer, DataType> expectedDataTypes = ColumnValidator.columnAndDataType(
            		Arrays.asList( DataType.NUMERIC,
   	            		 DataType.STRING,
	            		 DataType.STRING,
	            		 DataType.STRING,
	            		 DataType.STRING,
	            		 DataType.STRING,
	            		 DataType.NUMERIC)
            		
            		 );
	    	
	        response.setManualAdhocData(ManualAdhocDto.convertListToDto(selectedData,expectedDataTypes));
	        response.setStatus("SUCCESS");
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return response;
	}

	
	
	
	
	

	


	
}
