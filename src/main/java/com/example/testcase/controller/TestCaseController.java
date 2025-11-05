package com.example.testcase.controller;

import com.example.testcase.entity.TestCase;
import com.example.testcase.entity.TestRun;
import com.example.testcase.service.TestCaseService;
import com.example.testcase.service.TestRunService;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
    public String list(@RequestParam(name = "q", required = false) String query, Model model) {
        List<TestCase> cases;

        // If a search query is present, filter results; otherwise load all
        if (query != null && !query.trim().isEmpty()) {
            cases = service.search(query.trim());
        } else {
            cases = service.findAll();
        }
        model.addAttribute("testcases", cases);
        model.addAttribute("q", query); // so Freemarker remembers the search term

        // Aggregate latest run status per test case (best-effort)
        Map<String, String> lastStatus = new HashMap<>();
        EnumMap<TestRun.Status, Integer> counts = new EnumMap<>(TestRun.Status.class);
        for (TestRun.Status s : TestRun.Status.values())
            counts.put(s, 0);

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

    @GetMapping("/export/csv")
    public ResponseEntity<byte[]> exportCsv(@RequestParam(name = "q", required = false) String query) {
        List<TestCase> cases;

        if (query != null && !query.trim().isEmpty()) {
            cases = service.search(query.trim());
        } else {
            cases = service.findAll();
        }

        Map<Long, String> statusMap = new HashMap<>();
        for (TestRun run : runService.findAll()) {
            if (run.getTestCase() != null && run.getTestCase().getId() != null) {
                statusMap.put(run.getTestCase().getId(), String.valueOf(run.getStatus()));
            }
        }

        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PrintWriter writer = new PrintWriter(new OutputStreamWriter(baos, StandardCharsets.UTF_8));

            writer.println("ID,Title,Module,Description,Test Steps,Expected Results,Status");

            for (TestCase tc : cases) {
                String status = statusMap.getOrDefault(tc.getId(), "NOT_TESTED");
                writer.println(String.format("%s,%s,%s,%s,%s,%s,%s",
                        escapeCsv(String.valueOf(tc.getId())),
                        escapeCsv(tc.getName()),
                        escapeCsv(tc.getModule()),
                        escapeCsv(tc.getDescription()),
                        escapeCsv(tc.getTestSteps()),
                        escapeCsv(tc.getExpectedResults()),
                        escapeCsv(status)));
            }

            writer.flush();
            writer.close();

            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String filename = "test_cases_" + timestamp + ".csv";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType("text/csv"));
            headers.setContentDispositionFormData("attachment", filename);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(baos.toByteArray());

        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    private String escapeCsv(String value) {
        if (value == null)
            return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

}
