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
select COUNT(*) as 총사원수, COUNT(BONUS) as 보너스받는사원, SUM(SALARY) as 급여합, ROUND(AVG(SALARY), -1) as 급여평균, MIN(SALARY) as 최저급여, MAX(SALARY) as 최대급여
from EMPLOYEE
group by JOB_CODE
order by 1;

-- 남성, 여성별 사원 수
select case when SUBSTR(EMP_NO, 8, 1) IN('1','3') then '남성'
			when SUBSTR(EMP_NO, 8, 1) IN('2','4') then '여성'
		end as 성별
		, COUNT(*)
from EMPLOYEE
group by  case when SUBSTR(EMP_NO, 8, 1) IN('1','3') then '남성'
				when SUBSTR(EMP_NO, 8, 1) IN('2','4') then '여성'
			end;
--GROUP BY에는 별칭으로 추출 가능
--select case when SUBSTR(EMP_NO, 8, 1) IN('1','3') then '남성'
--			when SUBSTR(EMP_NO, 8, 1) IN('2','4') then '여성'
--		end as 성별
--		, COUNT(*)
--from EMPLOYEE
--group by  성별;

-- GROUP BY 절에 여러 컬럼 기술 가능
select DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE, JOB_CODE;

-- 입사년도별 급여의 합계
select extract(year from HIRE_DATE) as 입사년도, SUM(SALARY) as 급여합계
from EMPLOYEE
group by 입사년도
order by 1;

select TO_CHAR(HIRE_DATE, 'YYYY') as 입사년도, SUM(SALARY) as 급여합계
from EMPLOYEE
group by 입사년도
order by 1;

---------------------------------------------------------------------------
/*
 <HAVINT 절>
 그룹에 대한 조건을 제시할 때 사용
 * */
-- 각 부서별 급여 평균 조회
select DEPT_CODE, AVG(SALARY)
from EMPLOYEE
group by DEPT_CODE;

-- 각 부서별 급여 평균이 300만원 이상인 부서들 조회
/*select DEPT_CODE, AVG(SALARY)
from EMPLOYEE
where AVG(SALARY) >=3000000		-- 그룹에 대한 조건은 WHERE절이 아닌 HAVIGN 사용
group by DEPT_CODE
*/

select DEPT_CODE, ROUND(AVG(SALARY))
from EMPLOYEE
group by DEPT_CODE
having AVG(SALARY) >=3000000;

/*
 <실행 순서>
 FROM 
 WHERE
 GROUP BY (SELECT에서 별칭을 사용할 수 있도록 예외 처리)
 HAVING
 SELECT
 DISINCT
 ORDER BY
 */

--------------------------------------실습문제-------------------------------------------
--1. 직급별 급여합(급여합이 1000만원 이상인 직급만 조회), 직급코드, 급여합 조회
select JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by JOB_CODE
having SUM(SALARY) >=10000000;

--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회
select DEPT_CODE
from EMPLOYEE
group by DEPT_CODE
having SUM(BONUS) is null;














