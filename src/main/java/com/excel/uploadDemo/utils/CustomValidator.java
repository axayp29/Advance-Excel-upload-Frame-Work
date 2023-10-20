package com.excel.uploadDemo.utils;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.excel.uploadDemo.dto.ManualAdhocDto;

@Service
public class CustomValidator {

	
	public static boolean ValidateManualAdhocData(ManualAdhocDto manualAdhoc) {
		
		// for checikng shift is validate or not
		Map<String,String> employeeShift = new HashMap<>();
		employeeShift.put("295", "23");
		
		// employee not found
		if (!employeeShift.keySet().contains(manualAdhoc.getEmpCd())) {
			manualAdhoc.setError("Employee Code Not Found");
			return false;
		}
			
		// employee and employee shift code not matched
		if(!manualAdhoc.getShiftCode().equals(employeeShift.get(manualAdhoc.getEmpCd()))) {
			manualAdhoc.setError("Employee Code And Shift Code Not Matched");
			return false;
		}
		
		// attendance time format validation 
		if(!isValidTimeFormat(manualAdhoc.getAttendanceTime())) {
			manualAdhoc.setError("Attendance time Format Not Valid");
			return false;
		}
		// attendance type only In and out
		if(!(manualAdhoc.getAttendanceType().equalsIgnoreCase("in") || manualAdhoc.getAttendanceType().equalsIgnoreCase("out"))) {
			manualAdhoc.setError("Attendance Type Should be always In and Out Only");
			return false;
		}
		
		return true;
		
	}
	
	
	// validate date format
	 public static boolean isValidTimeFormat(String timeString) {
		 
	        // Define regular expressions for "HH:mm" format and "WO"
	        String timePattern = "([01]?[0-9]|2[0-3]):[0-5][0-9]";
	        String woPattern = "WO";

	        // Check if the input matches either "HH:mm" or "WO"
	        return timeString.matches(timePattern) || timeString.equalsIgnoreCase(woPattern);
	    }
	 
	 // validate date format
	 public static boolean isValidDateFormat(String dateString) {
		    // Define a regular expression for "dd/MM/yyyy" format
		    String datePattern = "^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/(19|20)\\d\\d$";
		    
		    // Check if the input matches the "dd/MM/yyyy" format
		    return dateString.matches(datePattern);
		}

	
}
