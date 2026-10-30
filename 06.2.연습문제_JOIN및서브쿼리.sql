-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 이씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회 
select EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join JOB using (JOB_CODE)
where EMP_NO in (select EMP_NO
				from EMPLOYEE
				where EMP_NO like '7_____-2%' and EMP_NAME like '이%');
   
-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT A.EMP_ID, A.EMP_NAME, DEPT_TITLE,JOB_NAME
FROM (SELECT EMP_ID, EMP_NAME,EMP_NO,
           RANK() OVER(ORDER BY SUBSTR(EMP_NO, 1, 6) DESC) AS 막내
    FROM EMPLOYEE) A
JOIN EMPLOYEE E ON (A.EMP_ID = E.EMP_ID)
JOIN DEPARTMENT ON (E.DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE 막내 = 1;

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select A.EMP_ID, A.EMP_NAME, JOB_NAME
from (select EMP_ID, EMP_NAME
		from employee 
		where EMP_NAME like '%하%') A
join employee e ON(A.EMP_ID=E.EMP_ID)
join JOB using (JOB_CODE);

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select A.EMP_NAME, JOB_NAME, A.DEPT_CODE, DEPT_TITLE
from (select EMP_NAME, DEPT_CODE
		from EMPLOYEE
		where DEPT_CODE in ('D5','D6'))A
join employee e  on (A.EMP_NAME=E.EMP_NAME)
join DEPARTMENT on (A.DEPT_CODE = DEPT_ID)
join JOB using (JOB_CODE);

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select A.EMP_NAME, A.BONUS, DEPT_TITLE, LOCAL_NAME
from (select EMP_NAME, BONUS
		from EMPLOYEE
		where BONUS is not NULL) A
join employee e using (EMP_NAME)
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE);

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
select A.EMP_NAME, JOB_NAME, A.SALARY
from (select EMP_NAME, SALARY
		from EMPLOYEE
		where BONUS is null and JOB_CODE IN('J4','J7') )A
join employee e using (EMP_NAME)
join JOB using (JOB_CODE);


-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select case when END_DATE is null then '재직'
			when END_DATE is not null then '퇴사'
		end as 퇴사
		, COUNT(*)
from EMPLOYEE
group by END_DATE;

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
select  EMP_ID, DEPT_TITLE, JOB_NAME, HIRE_DATE
from (select EMP_ID, HIRE_DATE
		, rank()OVER(order by SALARY*(1+BONUS)*12 desc) as 순위
		from EMPLOYEE )A
JOIN EMPLOYEE E using (EMP_ID)
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join JOB using (JOB_CODE)
where 순위<= 5;
-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용                
--	12-2. 인라인 뷰 사용      
--	12-3. WITH 사용

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)

-- 14. WITH를 이용하여 급여합과 급여평균 조회
