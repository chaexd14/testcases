package com.example.testcase.controller;

import com.example.testcase.entity.TestRun;
import com.example.testcase.service.TestCaseService;
import com.example.testcase.service.TestRunService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/dashboard")
public class DashboardController { // for example here just pass the (HttpSession session)

    // and just create conditional statements to check the users sesson

    private final TestCaseService caseService;
    private final TestRunService runService;

    public DashboardController(TestCaseService caseService, TestRunService runService) {
        this.caseService = caseService;
        this.runService = runService;
    }

    @GetMapping
    public String dashboard(Model model) {
        List<TestRun> runs = runService.findAll();
        int passed = 0, failed = 0, notTested = 0, skipped = 0;
        LocalDateTime lastRun = null;

        for (TestRun r : runs) {
            if (r.getStatus() != null) {
                switch (r.getStatus()) {
                    case PASSED -> passed++;
                    case FAILED -> failed++;
                    case NOT_TESTED -> notTested++;
                    case SKIPPED -> skipped++;
                }
            }
            if (r.getCreatedAt() != null) {
                lastRun = (lastRun == null || r.getCreatedAt().isAfter(lastRun)) ? r.getCreatedAt() : lastRun;
            }
        }

        int totalCases = caseService.findAll().size();
        model.addAttribute("runsPassed", passed);
        model.addAttribute("runsFailed", failed);
        model.addAttribute("runsNotTested", notTested);
        model.addAttribute("runsSkipped", skipped);
        model.addAttribute("totalCases", totalCases);
        model.addAttribute("lastRun", lastRun);

        // Human-friendly last run date, e.g., "November 3, 2025 at 22:55"
        if (lastRun != null) {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMMM d, yyyy 'at' HH:mm");
            model.addAttribute("lastRunFormatted", lastRun.format(fmt));
        }

        // Passed/Failed ratio as string "P : F"
        String ratio = String.format("%d : %d", passed, failed);
        model.addAttribute("passFailRatio", ratio);

        // Most failed modules (group by test case module)
        Map<String, Integer> failPerModule = new HashMap<>();
        for (TestRun r : runs) {
            if (r.getStatus() == TestRun.Status.FAILED && r.getTestCase() != null) {
                String module = Optional.ofNullable(r.getTestCase().getModule()).filter(s -> !s.isBlank()).orElse("Uncategorized");
                failPerModule.merge(module, 1, Integer::sum);
            }
        }
        List<Map.Entry<String, Integer>> topFailedModules = failPerModule.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("topFailedModules", topFailedModules);

        return "dashboard";
    }
}
