SELECT
    DATE(s.visit_date) AS visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,

    COUNT(DISTINCT s.visitor_id) AS visitors_count,

    COALESCE(MAX(vk.daily_spent), 0)
+
COALESCE(MAX(ya.daily_spent), 0) AS total_cost,

    COUNT(DISTINCT l.lead_id) AS leads_count,

    COUNT(
        DISTINCT CASE
            WHEN
                l.closing_reason = 'Успешно реализовано'
                OR l.status_id = 142
            THEN l.lead_id
        END
    ) AS purchases_count,

    SUM(
        CASE
            WHEN
                l.closing_reason = 'Успешно реализовано'
                OR l.status_id = 142
            THEN l.amount
        END
    ) AS revenue

FROM sessions s

LEFT JOIN leads l
    ON s.visitor_id = l.visitor_id
    AND s.visit_date <= l.created_at

LEFT JOIN vk_ads vk
    ON s.campaign = vk.utm_campaign
    AND DATE(s.visit_date) = vk.campaign_date

LEFT JOIN ya_ads ya
    ON s.campaign = ya.utm_campaign
    AND DATE(s.visit_date) = ya.campaign_date

WHERE s.medium IN (
    'cpc',
    'cpm',
    'cpa',
    'youtube',
    'cpp',
    'tg',
    'social'
)

GROUP BY
    DATE(s.visit_date),
    s.source,
    s.medium,
    s.campaign

ORDER BY
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign ASC
    limit 15;
