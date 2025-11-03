package com.example.testcase.service;

import com.example.testcase.entity.TestCase;
import com.example.testcase.repository.TestCaseRepository;
import com.example.testcase.repository.TestRunRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TestCaseService {
    private final TestCaseRepository repo;
    private final TestRunRepository runRepo;

    public TestCaseService(TestCaseRepository repo, TestRunRepository runRepo) {
        this.repo = repo;
        this.runRepo = runRepo;
    }

    public List<TestCase> findAll() { return repo.findAll(); }

    public TestCase findById(Long id) { return repo.findById(id).orElse(null); }

    public TestCase save(TestCase testCase) { return repo.save(testCase); }

    // Ensure child rows are deleted first to avoid FK constraint violations
    @Transactional
    public void delete(Long id) {
        // Remove dependent test runs, then the test case
        runRepo.deleteByTestCase_Id(id);
        repo.deleteById(id);
    }
}
