select s.visitor_id,
s.visit_date,
s.source as utm_source,
s.medium as utm_medium,
s.campaign as utm_campaign,
l.lead_id,
l.created_at,
l.amount,
l.closing_reason,
l.status_id
from sessions s 
left join leads l 
on s.visitor_id = l.visitor_id 
where s.medium <> 'organic'
ORDER BY
    amount DESC NULLS LAST,
    visit_date ASC,
    utm_source ASC,
    utm_medium ASC,
    utm_campaign asc
    limit 10;
