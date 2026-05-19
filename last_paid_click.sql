SELECT DISTINCT ON (l.lead_id)
    s.visitor_id,
    s.visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    l.lead_id,
    l.created_at,
    l.amount,
    l.closing_reason,
    l.status_id
FROM sessions AS s
LEFT JOIN leads AS l
    ON s.visitor_id = l.visitor_id
    AND s.visit_date <= l.created_at
WHERE s.medium IN (
    'cpc',
    'cpm',
    'cpa',
    'youtube',
    'cpp',
    'tg',
    'social'
)
ORDER BY
    l.lead_id,
    s.visit_date DESC;
