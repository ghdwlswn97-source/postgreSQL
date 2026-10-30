/*
	<SUBQUERY>
  	- 하나의 SQL문 안에 포함된 또 다른 SELECT문 
  	- 메인 SQL문을 위해 보조 역할을 하는 쿼리문
*/

-- 박서준과 같은 부서에 속한 사원들 조회
-- 1. 박서준의 부서코드 조회
select DEPT_CODE
from EMPLOYEE
where EMP_NAME = '박서준';		-- D9

-- 2. 부서코드가 D9인 사원들 조회
select EMP_NAME
from EMPLOYEE
where DEPT_CODE = 'D9';

-- 3.
select EMP_NAME
from EMPLOYEE
where DEPT_CODE = (select DEPT_CODE
					from EMPLOYEE
					where EMP_NAME = '박서준');

-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 급여 조회
-- 1. 평균 급여
select ROUND(AVG(SALARY))
from EMPLOYEE;		-- 3,047,663

-- 2. 평균 급여가 3,047,663보다 많이 받는 사람
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY > 3047663;

-- 3.
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY > (select ROUND(AVG(SALARY))
				from EMPLOYEE);			

-----------------------------------------------------
/*
  * 서브쿼리의 구분
    : 서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라 구분
    
    - 단일행 서브쿼리 : 서브쿼리의 결과값이 오로지 1개 일 때(한행 한열)
    - 다중행 서브쿼리 : 서브쿼리의 결과값이 여러행 일 때(여러행 한열)
    - 다중열 서브쿼리 : 서브쿼리의 결과값이 여러열 일 때(한행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리의 결과값이 여러행 여러열 일 때(여러행 여러열)
    
    >> 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
  1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
  	: 서브쿼리의 결과값이 오로지 1개 일 때(한행 한열)
  		일반 비교연산자 사용 가능
  		=, !=, >, ...
*/

-- 1) 전 직원의 평균급여보다 급여를 적게 받는 사원들의 사원명, 직급코드, 급여 조회
select EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where SALARY < (select AVG(SALARY)
				from EMPLOYEE);

-- 2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
select EMP_ID, EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
where SALARY =(select MIN(SALARY)
				from EMPLOYEE);

-- 3) 조정연 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 급여 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > (select salary 
				from employee 
				where EMP_NAME='조정연');

-- JOIN
-- 4) 조정연 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서명, 급여 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
where SALARY > (select salary 
				from employee 
				where EMP_NAME = '조정연');

-- 5) 왕건우 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회
select EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
where DEPT_CODE = (select DEPT_CODE
					from employee 
					where EMP_NAME='왕건우');
-- 왕건우 사원 제외
select EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
where DEPT_CODE = (select DEPT_CODE
					from employee 
					where EMP_NAME='왕건우')
and EMP_NAME != '왕건우';

-- GROUP BY
-- 6) 부서별 급여합계가 가장 큰 부서의 부서코드, 급여합계 조회
-- 6-1 부서별 급여합 중에서 가장 큰 값 조회
/*
select MAX(SUM(SALARY))
from EMPLOYEE
group by DEPT_CODE;		-- 부서는 여러개인데 최대급여합은 하나여서 오류
*/

select SUM(SALARY)
from EMPLOYEE
group by dept_code
order by 1 desc
limit 1;		-- 17700000

-- 6-2
select DEPT_CODE, SUM(SALARY)
from EMPLOYEE
group by dept_code 
having SUM(SALARY) = (select SUM(SALARY)
						from EMPLOYEE
						group by dept_code
						order by 1 desc
						limit 1);

--select MAX(총급여)
--from (select SUM(SALARY) as 총급여
--		from EMPLOYEE
--		group by DEPT_CODE);




















