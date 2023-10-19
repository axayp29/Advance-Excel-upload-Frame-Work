package com.excel.uploadDemo.utils;

import org.apache.poi.ss.usermodel.Cell;
import org.springframework.stereotype.Service;

@Service
public class ExcelUtils {

	public static String getCellValueAsString(Cell cell) {
	    String cellValue = "";

	    if (cell != null) {
	        switch (cell.getCellType()) {
	            case STRING:
	                cellValue = cell.getStringCellValue();
	                break;
	            case NUMERIC:
	                cellValue = String.format("%.0f", cell.getNumericCellValue());
	                break;
	            case BOOLEAN:
	                cellValue = String.valueOf(cell.getBooleanCellValue());
	                break;
	            case FORMULA:
	                cellValue = cell.getCellFormula();
	                break;
	            default:
	                // Handle other cell types as needed
	                cellValue = "";
	        }
	    }

	    return cellValue;
	}
}
