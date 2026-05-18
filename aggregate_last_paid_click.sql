SELECT
    s.visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    COUNT(s.visitor_id) AS visitors_count,
    COALESCE(SUM(vk.daily_spent), 0)
    + COALESCE(SUM(ya.daily_spent), 0) AS total_cost,
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

FROM sessions AS s

LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at

LEFT JOIN vk_ads AS vk
    ON
        s.source = vk.utm_source
        AND s.medium = vk.utm_medium
        AND s.campaign = vk.utm_campaign
        AND s.content = vk.utm_content
        AND DATE(s.visit_date) = vk.campaign_date

LEFT JOIN ya_ads AS ya
    ON
        s.source = ya.utm_source
        AND s.medium = ya.utm_medium
        AND s.campaign = ya.utm_campaign
        AND s.content = ya.utm_content
        AND DATE(s.visit_date) = ya.campaign_date

WHERE s.medium <> 'organic'

GROUP BY
    s.visit_date,
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
LIMIT 15;
