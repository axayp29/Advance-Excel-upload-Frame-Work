package com.excel.uploadDemo.entity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Entity
@Data
public class ManualAdhocEntity {

	@Id
	@GeneratedValue
	private Long id;
	
	private Date date;
	
	private Long empCd;
	
	private String employeeName;
	
	private String attendanceTime;
	
	private String attendanceType;
	
	private Long shiftCode;
	
	
	
	public static List<ManualAdhocEntity> convertListToEntity(List<List<String>> dataList) {

		List<ManualAdhocEntity> manualAdhocDataList = new ArrayList<>();
		try {

			for (List<String> data : dataList) {

				// if data is selected and valid then n then need to save
				if (data.get(0).equalsIgnoreCase("true") && data.get(7).equalsIgnoreCase("true")) {

					ManualAdhocEntity manualAdhoc = new ManualAdhocEntity();

					SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

					manualAdhoc.setDate(dateFormat.parse(data.get(1)));
					manualAdhoc.setEmpCd(Long.parseLong(data.get(2)));
					manualAdhoc.setEmployeeName(data.get(3));
					manualAdhoc.setAttendanceTime(data.get(4));
					manualAdhoc.setAttendanceType(data.get(5));
					manualAdhoc.setShiftCode(Long.parseLong(data.get(6)));

					manualAdhocDataList.add(manualAdhoc);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return manualAdhocDataList;
	}
	
}
