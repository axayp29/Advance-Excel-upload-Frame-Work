package com.excel.uploadDemo.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.excel.uploadDemo.entity.ExcelUploadMaster;

@Repository
public interface ExcelUploadMasterRepo extends JpaRepository<ExcelUploadMaster, Long>{

}
