package com.example.testcase.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Entity
@Data
public class TestCase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    private String name;

    // Optional: categorize cases by module/feature for dashboard stats
    private String module;

    private String description;
    private String testSteps;
    private String expectedResults;
}
