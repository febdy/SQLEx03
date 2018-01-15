/*문제1.
평균 급여보다 적은 급여을 받는 직원은 몇 명이나 있습니까?
//56명
*/
SELECT COUNT(salary)
FROM employees
WHERE salary < (SELECT AVG(salary)
                FROM employees);
                
                
/*
문제2.
각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 성(last_name)과 급여(salary)
부서번호(department_id)를 조회하세요 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야
합니다.
//11명
*/
SELECT em.employee_id, em.last_name, em.salary, em.department_id
FROM employees em, (SELECT department_id, MAX(salary) salary
                    FROM employees
                    GROUP BY department_id) ms
WHERE em.department_id = ms.department_id
AND em.salary = ms.salary
ORDER BY em.salary DESC;


/*
문제3.
각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다. 연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오  
//19부서
*/
SELECT jobs.job_title, ss.salary
FROM jobs, (SELECT SUM(salary) salary, em.job_id
            FROM employees em
            GROUP BY em.job_id) ss
WHERE jobs.job_id = ss.job_id
ORDER BY ss.salary DESC;


/*
문제4.
자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 성(last_name)과 급여(salary)을 조회하세요  
//38명
*/
SELECT em.employee_id, em.last_name, em.salary
FROM employees em, (SELECT department_id, AVG(salary) salary
                    FROM employees
                    GROUP BY department_id) avs
WHERE em.salary > avs.salary
AND em.department_id = avs.department_id;
