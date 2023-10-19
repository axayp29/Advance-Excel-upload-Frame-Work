package com.excel.uploadDemo.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.excel.uploadDemo.utils.ColumnValidator;
import com.excel.uploadDemo.utils.CustomValidator;
import com.excel.uploadDemo.utils.DataType;

import lombok.Data;

@Data
public class ManualAdhocDto {
	
	private String id;
	
	private String date;
	
	private String empCd;
	
	private String employeeName;
	
	private String attendanceTime;
	
	private String attendanceType;
	
	private String shiftCode;
	
	private boolean isValid = true;
	
	private String error;
	
	
	public static List<ManualAdhocDto> convertListToDto(List<List<String>> dataList
			,Map<Integer, DataType> expectedDataTypes) {

		List<ManualAdhocDto> manualAdhocDataList = new ArrayList<>();
		try {

			for (List<String> data : dataList) {

				ManualAdhocDto manualAdhocData = new ManualAdhocDto();
				manualAdhocData.setId(data.get(0));
				manualAdhocData.setDate(data.get(1));
				manualAdhocData.setEmpCd(data.get(2));
				manualAdhocData.setEmployeeName(data.get(3));
				manualAdhocData.setAttendanceTime(data.get(4));
				manualAdhocData.setAttendanceType(data.get(5));
				manualAdhocData.setShiftCode(data.get(6));
				
				  // checked rows values if not validate with column data type any single entry then not consider in calculation 
	            boolean allValid = expectedDataTypes.keySet()
	                    .stream()
	                    .map(key -> ColumnValidator.isTypeValid(data.get(key), expectedDataTypes.get(key)))
	                    .allMatch(Boolean::booleanValue);
				
						if(!allValid)
						{
							manualAdhocData.setValid(false);
							manualAdhocData.setError("Column Data Type Not Matched");
						}
						else {
							manualAdhocData.setValid(CustomValidator.ValidateManualAdhocData(manualAdhocData));

						}
	            

				manualAdhocDataList.add(manualAdhocData);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return manualAdhocDataList;
	}
	

}


