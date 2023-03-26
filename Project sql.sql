Show databases;
create database project;
use  project;
show tables;



## 1 Year wise loan amount Stats
select year(issue_d) year,sum(loan_amnt) sum ,round(avg(loan_amnt),2) avg ,count(loan_amnt) count , max(loan_amnt) max ,min(loan_amnt) min,
round(stddev(loan_amnt),2) dev,round(variance(loan_amnt),2) var 
from finance_1 
group by year(issue_d) 
order by year(issue_d);



## 2 Grade and sub grade wise revol_bal
select grade , sub_grade,sum(revol_bal) sum 
from finance_1 
inner join finance_2 
on finance_1.id=finance_2.id 
group by sub_grade 
order by sub_grade;
                           
                           
                           
## 3 Total Payment for Verified Status Vs Total Payment for Non Verified Status
SELECT finance_1.verification_status, round(sum(finance_2.total_pymnt), 1) as "Total Payment",
round(round(sum(finance_2.total_pymnt), 1) * 100 / 
(SELECT round(sum(finance_2.total_pymnt), 1) FROM finance_2 inner join finance_1 on finance_1.id=finance_2.id 
where finance_1.verification_status <> "Source Verified"), 1) as "Percentage of Total"
FROM finance_1
INNER JOIN finance_2
ON finance_1.id = finance_2.id
WHERE finance_1.verification_status <> "Source Verified"
GROUP BY finance_1.verification_status;
      
      
      
      
## 4 State wise and last_credit_pull_d wise loan status
SELECT addr_state, year(str_to_date(finance_2.last_credit_pull_d,"%b-%y")) as "year",
SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS 'Charged Off',
SUM(CASE WHEN loan_status = 'Current' THEN 1 ELSE 0 END) AS 'Current',
SUM(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END) AS 'Fully Paid'
FROM finance_1
inner join finance_2 on finance_1.id=finance_2.id
GROUP BY addr_state, year(str_to_date(finance_2.last_credit_pull_d,"%b-%y"))
ORDER BY addr_state;



# # 5 Home ownership Vs last payment date stats
SELECT  home_ownership, concat(left(MAX(STR_TO_DATE(last_pymnt_d,"%b-%y")), 8), "01") AS "Last payment date", ROUND(SUM(last_pymnt_amnt),2) AS "Total Payment Amount"
FROM finance_1
INNER JOIN finance_2 ON finance_1.id = finance_2.id
WHERE YEAR(str_to_date(last_pymnt_d,"%b-%y")) <> 0 
GROUP BY home_ownership ORDER BY home_ownership, YEAR(STR_TO_DATE(last_pymnt_d,"%b-%y"));                              
                                                                      
                                                                      
                                                                      
                                                                      
                               
