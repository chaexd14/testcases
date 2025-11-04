package com.example.testcase.repository;

import com.example.testcase.entity.TestCase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TestCaseRepository extends JpaRepository<TestCase, Long> {

    @Query("""
        SELECT t FROM TestCase t
        WHERE LOWER(t.name) LIKE LOWER(CONCAT('%', :keyword, '%'))
           OR LOWER(t.description) LIKE LOWER(CONCAT('%', :keyword, '%'))
    """)
    List<TestCase> search(@Param("keyword") String keyword);
}
