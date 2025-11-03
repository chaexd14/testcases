package com.example.testcase.controller;

import com.example.testcase.entity.TestCase;
import com.example.testcase.entity.TestRun;
import com.example.testcase.service.TestCaseService;
import com.example.testcase.service.TestRunService;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/testcases")
public class TestCaseController {
    private final TestCaseService service;
    private final TestRunService runService;

    public TestCaseController(TestCaseService service, TestRunService runService) {
        this.service = service;
        this.runService = runService;
    }

    @GetMapping
    public String list(Model model) {
        List<TestCase> cases = service.findAll();
        model.addAttribute("testcases", cases);

    // Aggregate latest run status per test case (best-effort)
    // Use String keys to make it easy to access from FreeMarker without ?api
    Map<String, String> lastStatus = new HashMap<>();
        EnumMap<TestRun.Status, Integer> counts = new EnumMap<>(TestRun.Status.class);
        for (TestRun.Status s : TestRun.Status.values()) counts.put(s, 0);
        for (TestRun run : runService.findAll()) {
            if (run.getTestCase() != null && run.getTestCase().getId() != null) {
                lastStatus.put(String.valueOf(run.getTestCase().getId()), String.valueOf(run.getStatus()));
            }
            if (run.getStatus() != null) {
                counts.put(run.getStatus(), counts.get(run.getStatus()) + 1);
            }
        }
        model.addAttribute("lastStatusByCaseId", lastStatus);
        model.addAttribute("runsPassed", counts.get(TestRun.Status.PASSED));
        model.addAttribute("runsFailed", counts.get(TestRun.Status.FAILED));
        model.addAttribute("runsNotTested", counts.get(TestRun.Status.NOT_TESTED));
        return "testcases";
    }

    @GetMapping("/new")
    public String form(Model model) {
        model.addAttribute("testcase", new TestCase());
        return "testcase_form";
    }

    @PostMapping
    public String save(@ModelAttribute TestCase testCase) {
        service.save(testCase);
        return "redirect:/testcases";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        model.addAttribute("testcase", service.findById(id));
        return "testcase_form";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirect) {
        try {
            service.delete(id);
            redirect.addFlashAttribute("toastSuccess", "Test case deleted.");
        } catch (DataIntegrityViolationException ex) {
            // Safety net: in case any other FK prevents deletion
            redirect.addFlashAttribute("toastError", "Cannot delete test case because it has related records.");
        }
        return "redirect:/testcases";
    }
}
