package com.excel.uploadDemo.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.excel.uploadDemo.entity.ManualAdhocEntity;

@Repository
public interface ManualAdhocEntityRepo extends JpaRepository<ManualAdhocEntity, Long>{

}
