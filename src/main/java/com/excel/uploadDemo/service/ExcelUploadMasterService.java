package com.excel.uploadDemo.service;

public interface ExcelUploadMasterService {

	void saveExcelMasterData(String type,String fileName,String fileLocation,long userId,long companyId,long branchId);
}
