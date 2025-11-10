-- ====================================================================
-- Candidate Activation Verification Script
-- ====================================================================
-- Use this to check if candidates are being properly activated
-- after QR payment approval
-- ====================================================================

-- 1. Check QR Payments with Candidate IDs
-- ====================================================================
SELECT 
    qp.payment_id,
    qp.user_id,
    qp.candidate_id,
    qp.transaction_id,
    qp.amount,
    qp.payment_status,
    qp.submitted_date,
    qp.verified_date,
    qp.verified_by,
    u.full_name as user_name,
    c.candidate_name
FROM qr_payments qp
LEFT JOIN users u ON qp.user_id = u.user_id
LEFT JOIN candidates c ON qp.candidate_id = c.candidate_id
WHERE qp.candidate_id IS NOT NULL
ORDER BY qp.submitted_date DESC;


-- 2. Check Candidate Payment Status
-- ====================================================================
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.user_id,
    c.payment_status,
    c.transaction_id,
    c.payment_date,
    c.is_payment_verified,
    c.account_status,
    u.full_name as user_name,
    u.email
FROM candidates c
JOIN users u ON c.user_id = u.user_id
ORDER BY c.created_at DESC
LIMIT 20;


-- 3. Find Candidates with Verified QR Payment but Still Pending
-- ====================================================================
-- This should return ZERO rows if fix is working
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.account_status,
    c.payment_status,
    c.is_payment_verified,
    qp.payment_status as qr_payment_status,
    qp.transaction_id,
    qp.verified_date
FROM candidates c
JOIN qr_payments qp ON c.candidate_id = qp.candidate_id
WHERE qp.payment_status = 'verified'
  AND (c.account_status != 'active' 
       OR c.payment_status != 'completed'
       OR c.is_payment_verified != 1);


-- 4. Count Candidates by Status
-- ====================================================================
SELECT 
    account_status,
    payment_status,
    COUNT(*) as count
FROM candidates
GROUP BY account_status, payment_status
ORDER BY account_status, payment_status;


-- 5. Recent Activations (Last 24 hours)
-- ====================================================================
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.payment_date,
    c.transaction_id,
    c.account_status,
    qp.verified_date,
    u.full_name as verified_by_admin
FROM candidates c
LEFT JOIN qr_payments qp ON c.candidate_id = qp.candidate_id
LEFT JOIN users u ON qp.verified_by = u.user_id
WHERE c.payment_date >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
ORDER BY c.payment_date DESC;


-- 6. Matching QR Payment and Candidate Transaction IDs
-- ====================================================================
SELECT 
    qp.payment_id,
    qp.transaction_id as qr_transaction_id,
    c.candidate_id,
    c.transaction_id as candidate_transaction_id,
    CASE 
        WHEN qp.transaction_id = c.transaction_id THEN 'MATCH ✓'
        ELSE 'MISMATCH ✗'
    END as transaction_match,
    qp.payment_status,
    c.account_status
FROM qr_payments qp
JOIN candidates c ON qp.candidate_id = c.candidate_id
WHERE qp.candidate_id IS NOT NULL
ORDER BY qp.submitted_date DESC;


-- 7. Problem Cases - Need Manual Fix
-- ====================================================================
-- Shows candidates that should be active but aren't
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.account_status,
    c.payment_status,
    c.is_payment_verified,
    qp.payment_status as qr_status,
    qp.verified_date,
    'NEEDS MANUAL FIX' as issue
FROM candidates c
JOIN qr_payments qp ON c.candidate_id = qp.candidate_id
WHERE qp.payment_status = 'verified'
  AND c.account_status != 'active';


-- ====================================================================
-- MANUAL FIX SCRIPT (If needed)
-- ====================================================================
-- Run this for each candidate ID that needs fixing
-- Replace [CANDIDATE_ID] with actual ID

/*
UPDATE candidates 
SET 
    payment_status = 'completed',
    is_payment_verified = 1,
    account_status = 'active',
    payment_date = NOW(),
    transaction_id = (
        SELECT transaction_id 
        FROM qr_payments 
        WHERE candidate_id = [CANDIDATE_ID] 
        LIMIT 1
    )
WHERE candidate_id = [CANDIDATE_ID];
*/


-- ====================================================================
-- VERIFICATION AFTER FIX
-- ====================================================================
-- Run this to verify a specific candidate was fixed
-- Replace [CANDIDATE_ID] with actual ID

/*
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.payment_status,
    c.is_payment_verified,
    c.account_status,
    c.transaction_id,
    c.payment_date,
    qp.payment_status as qr_payment_status,
    qp.verified_date
FROM candidates c
LEFT JOIN qr_payments qp ON c.candidate_id = qp.candidate_id
WHERE c.candidate_id = [CANDIDATE_ID];
*/


-- ====================================================================
-- STATISTICS
-- ====================================================================

-- Total QR Payments by Status
SELECT 
    'QR Payments' as category,
    payment_status,
    COUNT(*) as count
FROM qr_payments
GROUP BY payment_status
UNION ALL
-- Total Candidates by Status
SELECT 
    'Candidates' as category,
    account_status,
    COUNT(*) as count
FROM candidates
GROUP BY account_status
ORDER BY category, payment_status;


-- ====================================================================
-- END OF VERIFICATION SCRIPT
-- ====================================================================
