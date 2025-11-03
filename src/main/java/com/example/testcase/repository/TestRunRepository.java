package com.example.testcase.repository;

import com.example.testcase.entity.TestRun;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TestRunRepository extends JpaRepository<TestRun, Long> {
	// Delete all runs belonging to a given test case
	void deleteByTestCase_Id(Long testCaseId);

	// Utility to check if a test case has any runs
	boolean existsByTestCase_Id(Long testCaseId);
}
