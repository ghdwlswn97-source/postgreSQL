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
where JOB_CODE = (select JOB_CODE
					from EMPLOYEE
					where EMP_NAME ='지민재')
	and MANAGER_ID=(select manager_id 
						from EMPLOYEE
						where EMP_NAME='지민재');
				
-- >> 다중열 서브쿼리로
select EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
from EMPLOYEE
where (JOB_CODE, MANAGER_ID) = (select JOB_CODE, manager_id 
									from EMPLOYEE
									where EMP_NAME ='지민재');

-----------------------------------------------------------
/*
 4. 다중행 다중열 서브쿼리
 	: 여러행 여러열
*/
-- 1) 각 직급별 최소급여 금액을 받는 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1.1 각 직급별 최소급여 금액과 직급코드 조회
select JOB_CODE, MIN(SALARY)
from EMPLOYEE
group by JOB_CODE
order by 1;

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
group by JOB_CODE = 'J1' and SALARY =8000000
	  or JOB_CODE = 'J2' and SALARY = 3700000
	  .
	  .
	  .;


select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where (JOB_CODE, SALARY) = ('J1', 8000000)
	or (JOB_CODE, SALARY) = ('J2', 3700000)
	...;


select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where (JOB_CODE, SALARY) in (('J1', 8000000), ('J2', 3700000)..)

-->> 서브쿼리 적용
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where (JOB_CODE, SALARY) in (select JOB_CODE, MIN(SALARY)
								from EMPLOYEE
								group by JOB_CODE)
order by 3;

-- 2) 각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where (DEPT_CODE, SALARY) in (select DEPT_CODE, MAX(SALARY)
								from EMPLOYEE
								group by DEPT_CODE)
order by 3;

-----------------------------------------------------------
/*
 5. INLINE VIEW
 	FROM절에 서브쿼리 작성
 	서브쿼리를 수행할 결과를 마치 테이블처럼 사용
 	
 	* PostgreSQL 16 버전 이상은 인라인뷰에 별칭을 안붙여도 알아서 매칭
 	* PostgreSQL 16 버전 미만 이거나 다른 DBMS(My SQL등)은 인라인뷰에 반드시 별칭을 붙여둬야된다
*/
-- 사원들의 사번, 이름, 보너스포함한 연봉(별칭부여), 부서코드 조회
-- 단, 보너스 포함 연봉이 4000만원 이상인 사원들만 조회
select EMP_ID, EMP_NAME, SALARY*(1+coalesce(BONUS,0))*12 as 연봉, DEPT_CODE
from EMPLOYEE
where SALARY*(1+coalesce(BONUS,0))*12 >=40000000;

--WHERE절에 별칭을 사용하려면 INLINE VIEW사용
select *
from (select EMP_ID, EMP_NAME, SALARY*(1+coalesce(BONUS,0))*12 as 연봉, DEPT_CODE
		from EMPLOYEE)
where 연봉 >=40000000;

--select EMP_ID, EMP_NAME, SALARY*(1+coalesce(BONUS,0))*12 as 연봉, DEPT_CODE
--from (select SALARY*(1+coalesce(BONUS,0))*12
--		from EMPLOYEE
--		where 연봉>40000000);

-- INLINE VIEW 서브쿼리의 컬럼명만 메인 쿼리에서 호출가능


-----------------------------------------------------------
/*
 6. WITH 
 	서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM 절에 기술가능
 	
 	WITH 이름(마음대로) AS (서브쿼리)
 	최종실행메인쿼리;
 	
 	WITH 이름(마음대로) AS (서브쿼리)
 			이름(마음대로) AS (서브쿼리)
 	최종실행메인쿼리;
 */
with TOPN_SAL1 as (select DEPT_CODE, ROUND(AVG(SALARY)) as 평균급여
					from EMPLOYEE
					group by dept_code 
					order by 2 desc)
select *
from TOPN_SAL1
limit 2;

with TOPN_SAL1 as (select DEPT_CODE, ROUND(AVG(SALARY)) as 평균급여
					from EMPLOYEE
					group by dept_code 
					order by 2 desc
					LIMIT 2)
select * from TOPN_SAL1; 

--------------------------------------------------------------------
/*
  7. 순위 매기는 함수(WINDOW FUNCTION)
  	RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
  	- RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너띄고 순위
  							EX) 공동 1위가 2명이면 그 다음 순위는 3위
  	- DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
  							EX) 공동 1위가 2명이면 그 다음 순위는 2위
 	>> SELECT절에서만 사용 가능
*/

-- 급여가 높은 순서대로 순위를 매겨서 조회
select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE;

select EMP_NAME, SALARY, DENSE_RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE;

-- 급여가 상위 5위인 사원의 사원명, 급여, 순위 조회
/*
select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE
where RANK() OVER(order by SALARY DESC) <=5;
*/-- SELECT절에서만 사용 가능

--> INLINE VIEW사용
select *
from (select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
		from EMPLOYEE)
where 순위 <= 5;

-->> WITH 사용
with TOPN_SAL as (select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
		from EMPLOYEE)
select *
from TOPN_SAL
where 순위 <= 5;

-->> TOP-N 분석
/*
 원하는 기능			PostgreSQL문법
 -----------------------------------------
 상위 5개				LIMIT 5
 상위 3개				LIMIT 3
 상위 6~10위			LIMIT 5 OFFSET 5
 결과에 순번 출력 		ROW_NUMBER() OVER(정렬기준)
 표준 SQL 상위 5개		FETCH FIRST 5 ROWS ONLY
 */

-- 급여가 높은 상위 5명 조회
select EMP_NAME, SALARY
from EMPLOYEE
order by SALARY desc
limit 5;

-- 순번까지 출력
select ROW_NUMBER() OVER(order by SALARY DESC) as 순위, EMP_NAME, SALARY
from EMPLOYEE
order by SALARY desc
limit 5;

-- 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
order by HIRE_DATE desc
LIMIT 5;

-- 부서별 평균급여가 높은 상위 3개 부서 조회
select DEPT_CODE, ROUND(AVG(SALARY)) as 평균급여
from EMPLOYEE
group by DEPT_CODE
order by 평균급여 desc
limit 3;

-- 급여가 높은 상위 6~8위 조회
select EMP_NAME, SALARY
from EMPLOYEE
order by SALARY desc
limit 4 offset 5;

-- 급여가 낮은 하위 4위 조회
select EMP_NAME, SALARY
from EMPLOYEE
order by SALARY 
limit 4;		-- 4위 2명이어도 4행만 가져옴
-- 정확히 4위까지 가져오려면 INLINE VIEW 사용
select *
from (select EMP_NAME, SALARY, DENSE_RANK() OVER(order by SALARY ) as 순위
		from EMPLOYEE)
where 순위 <= 4;	

-- 2) 집계(GROUP BY) 후 다른 테이블과 조인(JOIN)할 때
-- 부서별 평균급여를 구한 뒤에 부서 정보와 조인
select *
from (select DEPT_CODE, ROUND(AVG(SALARY)) as 평균급여
		from EMPLOYEE
		group by DEPT_CODE)
join DEPARTMENT on (DEPT_CODE=DEPT_ID);















