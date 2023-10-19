package com.excel.uploadDemo.utils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.excel.uploadDemo.service.ExcelUploadMasterService;

@Component
public class FileUploadService {

	@Autowired
	private ExcelUploadMasterService excelUploadMasterService;

	@Value("${file.path}")
	public String location;

	@Transactional
	public void uploadFile(long companyId, MultipartFile file, String type, long branch, long createdBy) {

		Path directoryPath = Paths.get(location, String.valueOf(companyId),
				String.valueOf(LocalDateTime.now().getYear()));

		try {
			if (!Files.exists(directoryPath)) {
				Files.createDirectories(directoryPath);
				System.err.println("Directory created successfully.");
			}

			String fileName = type + "_" + LocalDateTime.now().getMonth() + "_"
					+ LocalDateTime.now().getDayOfMonth() + "_"
					+ LocalDateTime.now().getHour() + "_"
					+ LocalDateTime.now().getMinute() + CommonConstant.XLSX;

			Path filePath = directoryPath.resolve(fileName);

			file.transferTo(filePath.toFile());
			System.err.println("File uploaded successfully to: " + filePath.toString());

			// saving data into the master table
			excelUploadMasterService.saveExcelMasterData(type, fileName, filePath.toString(), createdBy, companyId,
					branch);

		} catch (IOException e) {
			System.err.println("Failed to upload file: " + e.getMessage());
		}

	}

}
