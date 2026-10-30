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

--------------------------------------------------------
/*
 2. 다중행 서브쿼리
 	: 서브쿼리의 결과값이 여러행 일 때(여러행 한열)
 		IN 서브쿼리 : 여러개의 결과값 중에서 항개라도 일치하는 값이 있다면
 		> ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
 						(여러개의 결과값 중 가장 작은값 보다 클 경우)
 		< ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
 						(여러개의 결과값 중 가장 큰값 보다 작을 경우)
 						
 	비교대상 > ANY (ARRAY[값1, 값2, 값3,...])
 	비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/

-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1.1 조정연 또는 전지연 사원의 직급
select JOB_CODE
from EMPLOYEE
where EMP_NAME in ('조정연', '전지연');

-- 1.2 J3, J7인 사원들 조회
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where JOB_CODE in ('J3','J7');

--
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where JOB_CODE in (select JOB_CODE
					from EMPLOYEE
					where EMP_NAME in ('조정연', '전지연'));

-- 2) 대리 직급임에도 불구하고 과장 직급 급여 중 최소 급여보다 많이 받는 직원 사번, 사원명, 직급, 급여 조회
-- 2.1 과장 직급인 사원들의 급여 조회
select SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME ='과장';		-- 2200000, 2500000, 3760000

-- 2.2 직급이 대리이면서 급여값이 위의 목록들중에 하나라도 큰 급여를 받는 사원
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME ='대리' 
		and SALARY > ANY(array[2200000, 2500000, 3760000]); 


select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME ='대리' 
		and SALARY > ANY(select SALARY
							from EMPLOYEE
							join JOB USING(JOB_CODE)
							where JOB_NAME ='과장'); 

-- 3) 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME ='차장'
		and SALARY < ANY(select SALARY
							from employee 
							join JOB USING(JOB_CODE)
							where JOB_NAME ='과장');


-- 4) 과장 직급임에도 차장 직급인 사원들의 모든 급여보다 더 많이 받는 사원의 사번, 사원명, 직급명, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB using (JOB_CODE)
where JOB_NAME='과장'
		and SALARY > ANY(select SALARY
					from employee 
					join JOB using (JOB_CODE)
					where JOB_NAME='차장');

-- 차장의 가장 많이 받는 급여보다 더 많이 받는 과장
-- > ANY : 비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
--			가장 작은값보다 큰값 모두
-- ALL : 비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
--			가장 큰값보다 큰값 모두
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB using (JOB_CODE)
where JOB_NAME='과장'
		and SALARY > all(select SALARY
							from employee 
							join JOB using (JOB_CODE)
							where JOB_NAME='차장')

-----------------------------------------------------------
/*
 3. 다중열 서브쿼리
 	: 한행 여러열
*/

-- 1) 장예은 사원과 같은 부서코드, 같은 직급코드에 해당하는 직원들의 사원명, 부서코드, 직급코드, 입사일 조회
select emp_name, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE = (장예은의 부서코드, and JOB_CODE = 장예은의 직급코드)

select emp_name, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE = (select dept_code 
					from EMPLOYEE
					where EMP_NAME = '장예은')
	 and JOB_CODE =(select JOB_code 
					from EMPLOYEE
					where EMP_NAME = '장예은');

-- >> 다중열 서브쿼리로
select emp_name, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where (DEPT_CODE, JOB_CODE) = (select DEPT_CODE, JOB_code 
								from EMPLOYEE
								where EMP_NAME = '장예은')

-- 지민재 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회
select EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
from EMPLOYEE
where ()















