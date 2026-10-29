/*
 <GROUP BY절>
 그룹기준을 제시할 수 있는 구문(그룹 기준별로 여러 그룹으로 묶을 수 있다)
 여러개위 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
 */

select SUM(SALARY)
from EMPLOYEE;

-- 각 부서별 총 급여의 합
select DEPT_CODE, SUM(SALARY)
from employee 
group by DEPT_CODE;

-- 각 부서별 사원 수
select DEPT_CODE, COUNT(*)
from EMPLOYEE
group by DEPT_CODE;

-- 각 부서별 급여의 합과 사원TN 오름차순
select DEPT_CODE, SUM(SALARY), COUNT(*)
from EMPLOYEE
group by DEPT_CODE
order by DEPT_CODE;

-- 직급별 인원수와 급여의 합
select JOB_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by JOB_CODE;

-- 각 직급별 총사원수, 보너스를 받는 사원수, 급여합, 급여평균, 최저급여, 최고급여
select COUNT(*), COUNT(BONUS), SUM(SALARY), AVG(SALARY), MIN(SALARY), MAX(SALARY)
from EMPLOYEE;




























