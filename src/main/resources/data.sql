-- ===========================
-- Test Cases (idempotent)
-- ===========================
INSERT INTO test_case (name, description, test_steps, expected_results)
SELECT * FROM (
    SELECT 'Login Test' AS name, 'Verifies login functionality' AS description,
           '1. Open login page\n2. Enter credentials\n3. Click Login' AS test_steps,
           'User is redirected to dashboard' AS expected_results
    UNION ALL
    SELECT 'Logout Test', 'Ensures logout functionality works',
           '1. Log in\n2. Click Logout', 'User is redirected to login page'
    UNION ALL
    SELECT 'Profile Update Test', 'Checks if user can update their profile info',
           '1. Go to profile\n2. Edit name and email\n3. Save changes', 'Profile information is updated successfully'
) AS tmp
WHERE NOT EXISTS (
    SELECT 1 FROM test_case tc WHERE tc.name = tmp.name
);

-- ===========================
-- Test Runs (idempotent, auto ID mapping)
-- ===========================
INSERT INTO test_run (test_case_id, status)
SELECT tc.id, tr.status
FROM (
    SELECT 'Login Test' AS name, 'PASSED' AS status
    UNION ALL
    SELECT 'Logout Test', 'FAILED'
    UNION ALL
    SELECT 'Profile Update Test', 'NOT_TESTED'
) AS tr
JOIN test_case tc ON tc.name = tr.name
WHERE NOT EXISTS (
    SELECT 1 FROM test_run t
    WHERE t.test_case_id = tc.id AND t.status = tr.status
);

-- ================================
-- account_db (idempotent)
-- ================================
INSERT INTO account_db (fullname, username, email, password)
SELECT tmp.fullname, tmp.username, tmp.email, tmp.password
FROM (
  SELECT 'Jumilyn Anne De Lima' AS fullname, 'jumilyn' AS username, 'jumilyn@example.com' AS email, 'password123' AS password
  UNION ALL
  SELECT 'Maria Santos', 'maria_s', 'maria@example.com', 'password456'
  UNION ALL
  SELECT 'Juan Dela Cruz', 'juan_dc', 'juan@example.com', 'password789'
  UNION ALL
  SELECT 'Anna Lopez', 'anna_lopez', 'anna@example.com', 'password000'
) AS tmp
WHERE NOT EXISTS (
  SELECT 1 FROM account_db a WHERE a.email = tmp.email
);

