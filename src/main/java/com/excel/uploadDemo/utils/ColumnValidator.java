package com.excel.uploadDemo.utils;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.springframework.stereotype.Service;

@Service
public class ColumnValidator {
	
	
	public static Map<Integer, DataType> columnAndDataType(List<DataType> dataTypes){
		
		return  IntStream.range(0, dataTypes.size())
        	    .boxed()
        	    .collect(Collectors.toMap(key -> key, key -> dataTypes.get(key)));
	}

	
	/*
	 * public static boolean isTypeValid(Cell cell,DataType expectedType) { try {
	 * 
	 * 
	 * switch (expectedType) { case STRING: return cell.getCellType() ==
	 * CellType.STRING; case NUMERIC: return cell.getCellType() == CellType.NUMERIC;
	 * case BOOLEAN: return cell.getCellType() == CellType.BOOLEAN; case FORMULA:
	 * return cell.getCellType() == CellType.FORMULA;
	 * 
	 * default: return false; }
	 * 
	 * } catch (Exception e) { // TODO: handle exception e.printStackTrace(); }
	 * return false;
	 * 
	 * }
	 */
	
	
	public static boolean isTypeValid(String stringValue, DataType expectedType) {
		try {

			// if data type is empty then no need check any string you can provide or not it's not affect in validation
			if(expectedType != DataType.EMPTY)
			if (stringValue == null || stringValue.isBlank() || stringValue.isEmpty())
				return false;

			switch (expectedType) {
			
			case EMPTY:
				return true; // Any string is valid for STRING.
			
			case STRING:
				return true; // Any string is valid for STRING.
			case NUMERIC:
				// Check if the string can be parsed as a numeric value.
				try {
					Double.parseDouble(stringValue);
					return true;
				} catch (NumberFormatException e) {
					return false;
				}
			case BOOLEAN:
				// Check if the string can be parsed as a boolean value.
				String lowercaseValue = stringValue.toLowerCase();
				return lowercaseValue.equals("true") || lowercaseValue.equals("false");
			case FORMULA:
				// You may need additional validation for formulas.
				return true;
			default:
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	
		
}
