/*문제1.
가장 늦게 입사한 직원의 이름(first_name last_name)과
연봉(salary)과 근무하는 부서 이름(department_name)은?
*/
SELECT em.first_name || ' ' || em.last_name name,
    em.salary,
    de.department_name,
    em.hire_date
FROM employees em, departments de, (SELECT MAX(hire_date) hire_date
                                    FROM employees) maxHireDate
WHERE em.hire_date = maxHireDate.hire_date
AND em.department_id = de.department_id;


/*
문제2.
평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name),
성(last_name)과  업무(job_title), 연봉(salary)을 조회하시오.
*/
SELECT em.employee_id, em.first_name, em.last_name, jobs.job_title, em.salary
FROM employees em, jobs, (SELECT department_id
                          FROM (SELECT department_id, AVG(salary) salary
                                FROM employees
                                GROUP By department_id) idAvgS, (SELECT MAX(salary) salary
                                                                  FROM (SELECT department_id, AVG(salary) salary
                                                                        FROM employees
                                                                        GROUP By department_id)) maxAvgS
                          WHERE idAvgS.salary = maxAvgS.salary) maxAvgDe
WHERE em.department_id = maxAvgDe.department_id
AND em.job_id = jobs.job_id;


/*
문제3.
평균 급여(salary)가 가장 높은 부서는? 
*/
SELECT de.department_name
FROM departments de, (SELECT department_id
                        FROM (SELECT department_id, AVG(salary) salary
                                FROM employees
                                GROUP BY department_id) idAvgS, (SELECT MAX(salary) salary
                                                                FROM (SELECT department_id, AVG(salary) salary
                                                                        FROM employees
                                                                        GROUP BY department_id)) maxAvgS
                        WHERE idAvgS.salary = maxAvgS.salary) maxAvgDe
WHERE de.department_id = maxAvgDe.department_id;


/*
문제4.
평균 급여(salary)가 가장 높은 지역은? 
*/
SELECT region_name
FROM(SELECT MAX(salary) salary
     FROM (SELECT AVG(salary) salary, region_name
     FROM(SELECT em.salary, re.region_name
          FROM employees em, departments de, locations lo, countries co, regions re
          WHERE em.department_id = de.department_id
          AND de.location_id = lo.location_id
          AND lo.country_id = co.country_id
          AND co.region_id = re.region_id)
     GROUP BY region_name)) maxAvgSalary,
    
     (SELECT AVG(salary) salary, region_name
      FROM(SELECT em.salary, re.region_name
           FROM employees em, departments de, locations lo, countries co, regions re
           WHERE em.department_id = de.department_id
           AND de.location_id = lo.location_id
           AND lo.country_id = co.country_id
           AND co.region_id = re.region_id)
      GROUP BY region_name) avgSalaryByRegion
WHERE maxAvgSalary.salary = avgSalaryByRegion.salary;


/*
문제5.
평균 급여(salary)가 가장 높은 업무는? 
*/
SELECT job_title
FROM(SELECT AVG(salary) salary, job_title
    FROM (SELECT em.salary, jobs.job_title
          FROM employees em, jobs
          WHERE em.job_id = jobs.job_id)
    GROUP BY job_title) avgSalaryByJob,
    (SELECT MAX(salary) salary
    FROM (SELECT AVG(salary) salary
          FROM (SELECT em.salary, jobs.job_title
                FROM employees em, jobs
                WHERE em.job_id = jobs.job_id) avgSalaryByJob
    GROUP BY job_title)) maxAvgS
WHERE avgSalaryByJob.salary = maxAvgS.salary;