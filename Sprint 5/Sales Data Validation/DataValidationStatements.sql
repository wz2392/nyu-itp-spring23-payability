
#Statements for customer 1
SELECT financial_event_group_id, financial_event_group_start, financial_event_group_end, original_total_amount,processing_status,beginning_balance_amount
FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2022, 2023) AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074'
ORDER BY financial_event_group_start DESC, financial_event_group_end DESC;


#Sales for Customer 1


