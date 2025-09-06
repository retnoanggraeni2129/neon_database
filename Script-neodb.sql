select 
	e.id as employee_id,
	e.name as employee_name,
	p.name as position_name,
	date_trunc('week', sa.activity_date)::date as week_start,
	    
         
    -- Hitung IN_OFFICE
    count(case when sa.activity_template_type = 'IN_OFFICE' then 1 end) as in_office_count,
    1 as in_office_target,
    case 
        when count(case when sa.activity_template_type = 'IN_OFFICE' then 1 end) >= 1 
        then 'OK' else 'NOT OK' 
    end as in_office_status,
    
    -- Hitung MARKET_VISIT (JOIN_SALESMAN + VISIT_OUTLET)
    count(case when sa.activity_template_type in ('JOIN_SALESMAN', 'VISIT_OUTLET') then 1 end) as market_visit_count,
    3 as market_visit_target,
    case 
        when count(case when sa.activity_template_type in ('JOIN_SALESMAN', 'VISIT_OUTLET') then 1 end) >= 3 
        then 'OK' else 'NOT OK' 
    end as market_visit_status
    
from spv_activity sa
join employee e 
    on sa.employee_id = e.id
join position p
    on e.position_id = p.id
where p.name in ('ASS', 'ASM')
group by 
    e.id, e.name, p.name, DATE_TRUNC('week', sa.activity_date)
order by 
    e.id, week_start;