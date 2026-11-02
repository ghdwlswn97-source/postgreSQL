-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 이씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회 
select EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join JOB using (JOB_CODE)
-- TO_CHAR()
WHERE TO_CHAR(TO_DATE('19'||SUBSTR(EMP_NO, 1, 2), 'YYYY'), 'YYYY')::INT		
		between 1970 and 1979
		and SUBSTR(EMP_NO, 8, 1) in ('2','4')
		and EMP_NAME like '이%';

--EXTRACT()
--where EXTRACT(year from TO_DATE('19' || SUBSTR(EMP_NO, 1, 2), 'YYYY'))
--		between 1970 and 1979
--		and SUBSTR(EMP_NO, 8, 1) in ('2','4')
--		and EMP_NAME like '이%';

-- SUBSTR()
--where SUBSTR(EMP_NO, 1,2) > '70' and SUBSTR(EMP_NO, 1,2) <= '79'
--		and SUBSTR(EMP_NO, 8, 1) in ('2','4')
--		and EMP_NAME like '이%';

--LIKE
--where EMP_NO in (select EMP_NO
--				from EMPLOYEE
--				where EMP_NO like '7_____-2%' and EMP_NAME like '이%');
   
-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
select EMP_ID, EMP_NAME
		, extract(year from CURRENT_DATE)-extract(year from TO_DATE(SUBSTR(EMP_NO, 1, 2), 'YY')) as 나이
		, DEPT_TITLE, JOB_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join JOB using (JOB_CODE)
order by 3 
limit 1;

--SELECT A.EMP_ID, A.EMP_NAME, DEPT_TITLE,JOB_NAME
--FROM (SELECT EMP_ID, EMP_NAME,EMP_NO,
--           RANK() OVER(ORDER BY SUBSTR(EMP_NO, 1, 2)) AS 막내
--    FROM EMPLOYEE) A
--JOIN EMPLOYEE E ON (A.EMP_ID = E.EMP_ID)
--JOIN DEPARTMENT ON (E.DEPT_CODE = DEPT_ID)
--JOIN JOB USING (JOB_CODE)
--order by 막내 DESC
--limit 1;

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select EMP_ID, EMP_NAME, JOB_NAME
from employee
join JOB using (JOB_CODE)
where EMP_NAME like '%하%';

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
from employee   
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join JOB using (JOB_CODE)
where DEPT_CODE in ('D5','D6');

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
from employee  
LEFT join DEPARTMENT on (DEPT_CODE=DEPT_ID)
left join location on (LOCATION_ID=LOCAL_CODE)
where BONUS is not NULL;

-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
select EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE=DEPT_ID)
left join location on (LOCATION_ID=LOCAL_CODE)
left join JOB using (JOB_CODE);

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
select EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE)
join national using (NATIONAL_CODE)
where NATIONAL_CODE in ('KO','JP');

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
select EMP_NAME, DEPT_CODE
from EMPLOYEE
where DEPT_CODE = (select DEPT_CODE
					from EMPLOYEE
					where EMP_NAME ='하정연');

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회
select EMP_NAME, JOB_NAME, SALARY
from employee 
join JOB using (JOB_CODE)
where BONUS is null and JOB_CODE IN('J4','J7');


-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select ENT_YN, COUNT(*)
from EMPLOYEE
group by ENT_YN;

--select case when END_DATE is null then '재직'
--			when END_DATE is not null then '퇴사'
--		end as 퇴사
--		, COUNT(*)
--from EMPLOYEE
--group by END_DATE;

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
select  *
from (select EMP_ID, DEPT_TITLE, JOB_NAME, HIRE_DATE
		, ROW_NUMBER()OVER(order by SALARY*(1+BONUS)*12 desc) as 순위
		from EMPLOYEE 
		join DEPARTMENT on (DEPT_CODE=DEPT_ID)
		join JOB using (JOB_CODE))
LIMIT 5;
-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용       
select DEPT_TITLE, SUM(SALARY)
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
group by DEPT_TITLE
having SUM(SALARY) > (select SUM(SALARY)*0.2
						from EMPLOYEE);

--	12-2. 인라인 뷰 사용      
select * 
from (select DEPT_TITLE, SUM(SALARY) as 급여총합
		from EMPLOYEE
		join DEPARTMENT on (DEPT_CODE=DEPT_ID)
		group by DEPT_TITLE)
where 급여총합 > (select SUM(SALARY)*0.2
						from EMPLOYEE);

--	12-3. WITH 사용
with TOTAL_SAL as (select DEPT_TITLE, SUM(SALARY) as 급여총합
		from EMPLOYEE
		join DEPARTMENT on (DEPT_CODE=DEPT_ID)
		group by DEPT_TITLE)
select *
from TOTAL_SAL
where 급여총합 > (select SUM(SALARY)*0.2
						from EMPLOYEE);


-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
select DEPT_TITLE, SUM(SALARY) as 급여합계
from employee 
left join DEPARTMENT ON(DEPT_CODE=DEPT_ID)
group by DEPT_TITLE;

-- 14. WITH를 이용하여 급여합과 급여평균 조회
-- 14-1 UNION 사용하여 2행에
with SUM_SAL as (select '급여합계' as 구분, SUM(SALARY) as 금액 from EMPLOYEE),
	AVG_SAL as (select '급여평균' as 구분, ROUND(AVG(SALARY)) as 금액 from EMPLOYEE)
select *
from SUM_SAL 
union
select *
from AVG_SAL;

-- 14-2 1행에 2열로
with SUM_AVG as (select SUM(SALARY) as 급여합계, ROUND(AVG(SALARY)) as 급여평균 from EMPLOYEE)
select * from SUM_AVG;
