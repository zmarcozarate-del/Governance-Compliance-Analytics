SELECT
    d.department_name,
    d.risk_level,
    
ROUND(AVG(r.residual_risk_score), 2) AS avg_residual_risk,
    
COUNT(r.risk_id) AS total_risks

FROM risks r

JOIN departments d
    ON r.department_id = d.department_id

GROUP BY d.department_name, d.risk_level

ORDER BY avg_residual_risk DESC;



SELECT
    d.department_name,
    
COUNT(*) AS critical_open_risks

FROM risks r

JOIN departments d
    ON r.department_id = d.department_id

WHERE r.residual_risk_score >= 8
    
AND r.status = 'Open'

GROUP BY d.department_name

ORDER BY critical_open_risks DESC;


SELECT
    risk_id,
    
risk_category,
    
inherent_risk_score,
   
residual_risk_score,
    (inherent_risk_score - residual_risk_score) AS risk_reduction

FROM risks

ORDER BY risk_reduction ASC;


query 4 weak control analysis

SELECT
    r.risk_id,
    r.risk_category,
    c.control_name,
    c.control_effectiveness,
    c.control_status
FROM controls c
JOIN risks r
    ON c.risk_id = r.risk_id
WHERE c.control_effectiveness IN ('Ineffective', 'Not Tested')
ORDER BY c.control_effectiveness;

Query 5 — Open Compliance Incidents by Department

SELECT
    d.department_name,
    COUNT(*) AS open_incidents
FROM compliance_incidents ci
JOIN departments d
    ON ci.department_id = d.department_id
WHERE ci.status <> 'Closed'
GROUP BY d.department_name
ORDER BY open_incidents DESC;

Query 6 — High Severity Incidents by Department

SELECT
    d.department_name,
    ci.severity,
    COUNT(*) AS incident_count
FROM compliance_incidents ci
JOIN departments d
    ON ci.department_id = d.department_id
WHERE ci.severity IN ('High', 'Critical')
GROUP BY d.department_name, ci.severity
ORDER BY incident_count DESC;

Query 7 — Average Resolution Time by Department

SELECT
    d.department_name,
    ROUND(AVG(ci.resolution_time_days), 2) AS avg_resolution_days,
    COUNT(*) AS total_incidents
FROM compliance_incidents ci
JOIN departments d
    ON ci.department_id = d.department_id
WHERE ci.status = 'Closed'
GROUP BY d.department_name
ORDER BY avg_resolution_days DESC;

Query 8 — Audit Findings by Department
SELECT
    d.department_name,
    SUM(a.findings_count) AS total_findings,
    COUNT(a.audit_id) AS total_audits
FROM audits a
JOIN departments d
    ON a.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_findings DESC;

Query 9 — Failed Audits by Department

SELECT
    d.department_name,
    a.audit_result,
    COUNT(*) AS failed_audits
FROM audits a
JOIN departments d
    ON a.department_id = d.department_id
WHERE a.audit_result IN ('Fail', 'Adverse')
GROUP BY d.department_name, a.audit_result
ORDER BY failed_audits DESC;

Query 10 — Executive Governance KPI Summary

SELECT
    (SELECT COUNT(*) FROM risks) AS total_risks,

    (SELECT COUNT(*)
     FROM risks
     WHERE status = 'Open') AS open_risks,

    (SELECT COUNT(*)
     FROM compliance_incidents
     WHERE status <> 'Closed') AS open_incidents,

    (SELECT COUNT(*)
     FROM controls
     WHERE control_effectiveness IN ('Ineffective', 'Not Tested')) AS weak_controls,

    (SELECT COUNT(*)
     FROM audits
     WHERE audit_result IN ('Fail', 'Adverse')) AS failed_audits;

Query 11 — Compliance Incidents Trend by Year

SELECT
    YEAR(incident_date) AS incident_year,
    COUNT(*) AS total_incidents
FROM compliance_incidents
GROUP BY YEAR(incident_date)
ORDER BY incident_year;

Query 12 — Governance Risk Heatmap

SELECT
    impact_level,
    likelihood,
    COUNT(*) AS total_risks,
    ROUND(AVG(residual_risk_score), 2) AS avg_residual_risk
FROM risks
GROUP BY impact_level, likelihood
ORDER BY avg_residual_risk DESC;
