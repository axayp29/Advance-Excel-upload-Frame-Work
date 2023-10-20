package com.excel.uploadDemo.service.impl;

import java.util.Date;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.excel.uploadDemo.entity.ExcelUploadMaster;
import com.excel.uploadDemo.repo.ExcelUploadMasterRepo;
import com.excel.uploadDemo.service.ExcelUploadMasterService;
import com.excel.uploadDemo.utils.MD5ExcelHashCodeSevice;

@Service
public class ExcelUploadServiceImpl implements ExcelUploadMasterService {
	
	
	@Autowired
	private ExcelUploadMasterRepo excelUploadMasterRepo;

	@Override
	@Transactional
	public void saveExcelMasterData(String type, String fileName, String fileLocation, long userId, long companyId,
			long branchId) {
		
		
		ExcelUploadMaster uploadMaster = new ExcelUploadMaster();
		
		uploadMaster.setType(type);
		uploadMaster.setFileName(fileName);
		uploadMaster.setLocation(fileLocation);
		uploadMaster.setUploadedAt(new Date());
		uploadMaster.setCompanyId(companyId);
		uploadMaster.setBranchId(branchId);
		uploadMaster.setUploadedBy(userId);
		
		// convert excel file to the md5 hashcode
		uploadMaster.setMd5HashCode(MD5ExcelHashCodeSevice.convertExcelFileToMD5HashCode(fileLocation));
		
		excelUploadMasterRepo.save(uploadMaster);
		
	}

}
