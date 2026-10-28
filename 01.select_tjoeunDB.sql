/*
 여러줄 주석 : ctrl + shift + /
 */
-- 한줄 주석 : ctrl + /
/*
 DML(Data Manipulation Language) : 데이터 조작언어
 	: 테이블에 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete) 하는 구문
 	*/
--========================================================================================
/*
 (') 홉따옴표 : 문자열을 감싸주는 기호
 (") 쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/

/*
 <select>
 	데이터 조회할 때 사용
 	>> Result set : 행들의 집합
 	
 	[표현법]
 	SELECT 조회하고자 하는 컬럼, 컬럼, ...
 	FROM 테이블명;
 */

-- EMPLOYEE 테이블에 있는 모든 컬럼(*)조회
select *
from employee;

-- EMPLOYEE테이블에서 사번, 이름, 급여 조회
select emp_id, emp_name, salary
from employee;

-- JOB테이블의 모든 컬럼 조회
select *
from job;

--------------------------------------------실습문제-------------------------------------------
--1. JOB테이블에서 직급명만 조회
select job_name
from job;

--2. DEPARTMENT테이블에서 모든 컬럼 조회
select *
from department;

--3. DEPARTMENT테이블에서 테이블의 부서코드, 부서명 조회
select dept_id, dept_title
from department;

--4. EMPLOYEE테이블에서 사번, 사원명, 이메일, 전화번호, 입사일, 급여 조회
select emp_id, emp_name, email, phone, hire_date, salary
from employee;

/*
  <컬럼값을 통한 산술연산>
  SELECT절 컬럼명 작성부분에 산술연산 가능
  */
-- EMPLOYEE테이블에서 사원명, 사원의 연봉 조회
select EMP_NAME, SALARY*12
from EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 보너스, 급여 조회
select EMP_NAME, BONUS, SALARY
from EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스포함연봉 조회
select EMP_NAME, SALARY, BONUS, SALARY*12, (BONUS*SALARY)+SALARY*12
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사일, 근무일수
-- DATE형식끼리 연산 가능 : +,-
-- 오늘날짜 CURRENT_DATE
select EMP_NAME, HIRE_DATE, current_DATE-HIRE_DATE
from EMPLOYEE;

-------------------------------------------------------------------
/*
 <컬럼명에 별칭 지정하기>
 산술연산시 컬럼명이 ?COLUMN?으로 나옴. 별칭을 부여하여 처리
 
 [표현법]
 컬럼명 별칭 / 컬럼명 as 별칭 / 컬럼명 "별칭" / 컬럼명 as "별칭"
 
 * 반드시 별칭에 쌍따옴표("")가 들어가야 할 때
	-> 별칭에 띄어쓰기 포함, 특수문자 포함
 */

select EMP_NAME, SALARY, BONUS, SALARY*12 연봉, (BONUS*SALARY)+SALARY*12 as 총소득
from EMPLOYEE;

select EMp_name, SALARY, BONUS, SALARY*12 "연봉(원)", (BONUS*SALARY)+SALARY*12 as "총 소득"
from EMPLOYEE;

-----------------------------------------------------------------------------------------------
/*
 <리터럴>
 임의로 지정한 문자열('')
 
 select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회 가능
 조회 된 result set의 모든 행에 반복적으로 같이 출력
 */

-- employee에 사번, 사원명, 급여 조회
select emp_id, emp_name, salary, '원' as 단위
from employee;

--------------------------------------------------------------------------------
/*
 <연결 연산자 : ||>
 여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있다
 * 숫자를 그냥 결합하면 타입 에러
   숫자형을 문자로 명시적 변환(::text)
 */
-- employee에서 사번, 이름, 급여를 하나의 컬럼으로 조회
select emp_id|| emp_name|| salary as id_name
from employee;

-- 컬럼값과 리터럴을 연결
select emp_name||'의 월급은 '||salary||'원 입니다' as 급여
from employee;

------------------------------------------------------------------------------------
/*
 	<DISTINCT>
 	컬럼에 중복된 값들을 한번씩만 표시하고자 할 때
 	
 	-> 하나의 컬럼씩 가능
 */
-- employee에서 직급코드 조회
select job_code from employee;

-- 중복 제거
select distinct job_code from employee;

-- 부서코드 중복제거
select distinct dept_code from employee;

-- 하나의 컬럼씩 가능
-- 두개 이상의 컬럼은 dept_code, job_code값을 한쌍으로 취급, 두 값이 모두 중복되는 데이터만 제거 됨
select distinct dept_code, job_code from employee;		

---------------------------------------------------------------------------------------
/*
 <WHEHE 절>
 조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때 WHERE절에 조건식을 쓴다
 조건식에는 다양한 연산자들을 사용 가능
 
 [표현법]
 SELECT 컬럼, 컬럼,...
 FROM 테이블명
 WHERE 조건식;
 
 * 비교 연산자
 	<,>,<=,>=		-> 대소 비교
 	= 				-> 같은값 비교
 	!=, <>			-> 같지 않음 비교
 */
-- EMPLOYEE에서 부서코드가 'D9'인 사원의 모든 컬럼 조회
select *
from employee 
where DEPT_CODE='D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee 
where DEPT_CODE='D1';

-- EMPLOYEE에서 부서코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee 
where DEPT_CODE!='D1';		-- where DEPT_CODE<>'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from employee 
where SALARY >= 4000000;

-- EMPLOYEE에서 재직중인 사원들의 사번, 사원명, 입사일, 재직여부 조회
select EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
from EMPLOYEE 
where ENT_YN='N';		-- where ENT_YN!='Y';

---------------------------- 실습문제 -------------------------------------------
--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
select EMP_NAME, SALARY, HIRE_DATE, SALARY*12 as 연봉
from EMPLOYEE
where SALARY >= 3000000

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select EMP_NAME, SALARY, SALARY*12 as 연봉, DEPT_CODE
from employee 
where SALARY*12 >= 50000000;

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
select EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
from EMPLOYEE
where JOB_CODE != 'J3'

---------------------------------------------------------------------------------
/*
 <논리 연산자>
 여러개의 조건을 제시하고자 할 때
 
 AND (~이면서, 그리고)
 OR	 (~이거나, 또는)
 */
-- 부서코드가 'D9'이면서, 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from employee 
where DEPT_CODE ='D9' and SALARY >= 5000000;

-- 부서코드가 'D6'이거나, 급여가 300만원 이상인 사원의 사원명, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D6' or SALARY >= 3000000;

-- 급여가 350만원 이상, 600만원 이하인 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from employee
where SALARY >=3500000 and SALARY <=6000000;

------------------------------------------------------------------------
/*
 <BETWEEN AND>
 조건식에서 사용되는 구문으로 ~ 이상, ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
 
 [표현법]
 비교대상컬럼 BETWEEN 하한값 AND 상한값
 */

-- 급여가 350만원 이상, 600만원 이하인 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from employee
where SALARY between 3500000 and 6000000;		

-- 급여가 350만원 이상, 600만원 이하인 사원들을 제외한 나머지 사원들의 사원명, 사번, 급여 조회		-> 제외 : NOT 조건문 사용
select EMP_NAME, EMP_ID, SALARY
from employee
where not SALARY between 3500000 and 6000000;

-- 입사일이 '1990-01-01~2004-12-31'사이인 사람들의 모든 컬럼 조회
select *
from EMPLOYEE
where HIRE_DATE between '1990-01-01' and '2004-12-31';

--------------------------------------------------------------------------------------
/*
 <LIKE>
 비교하고자 하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우 조회
 
 [표현법]
 비교대상컬럼 LIKE '특정패턴' 
 	: '특정패턴'에는 와일드카드(%, _)로 쓸 수 있다
 	
 	* % : 0글자 이상
 	* 	EX) 비교대상컬럼 LIKE '문자%' -> 비교대상의 컬럼값이 '문자'로 시작되는 것 조회
 	* 		비교대상컬럼 LIKE '%문자' -> 비교대상의 컬럼값이 '문자'로 끝나는 것 조회
 	* 		비교대상컬럼 LIKE '%문자%' -> 비교대상의 컬럼값이 '문자'가 포함되는 것 조회
 	 
 	* _ : 1글자
 		EX) 비교대상컬럼 LIKE '_문자'		-> 비교대상의 컬럼값이 '문자'앞에 무조건 한글자가 오는 것 조회
 			비교대상컬럼 LIKE '__문자'	-> 비교대상의 컬럼값이 '문자'앞에 무조건 두글자가 오는 것 조회
 			비교대상컬럼 LIKE '_문자_'	-> 비교대상의 컬럼값이 '문자'앞, 뒤에 무조건 한글자가 오고는 것 조회
 */
-- 사원들 중에서 성이 전씨인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
where EMP_NAME like '전%';

-- 사원들 이름 중에 '하'가 포함되어있는 사원의 사번, 사원명, 전화번호 조회
select EMP_ID, EMP_NAME, PHONE
from EMPLOYEE
where EMP_NAME like '%하%';

-- 사원들 중 이름의 가운데에 '하'가 포함되어있는 사원의 사번, 사원명, 이메일 조회
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where EMP_NAME like '_하_';

-- 사원들 중 전화번호 3번째 자리가 1인 사원의 사번, 사원명, 전화번호, 이메일 조회
select EMP_ID, EMP_NAME, PHONE, EMAIL
from EMPLOYEE
where PHONE like '__1%';	-- -> '__1%' 3번째 자리가 1이고 위에 숫자가 몇개든 상관없는 값 

-- 이메일 중 _(언더바)앞에 글자가 3글자인 사원들의 사번, 이름, 이메일 조회
select EMP_ID,EMP_NAME, EMAIL 
from EMPLOYEE
where EMAIL like '___%'
-- 와일드카드로 사용되는 문자와 컬럼값에 들어있는 문자가 동일하기 때문에 조회가안됨
--> 어떤것이 와일드 카드이고 데이터값인지 구분해줘야 함
--> 데이터 값으로 취급하고자 하는 값 앞에 나만의 와일드카드 (숫자, 문자, 특수기호 다 가능)
--	나만의 와일드카드를 ESCAPE에 등록

select EMP_ID,EMP_NAME, EMAIL 
from EMPLOYEE
where EMAIL like '___$_%' escape '$';

-- 위의 사원을 제외한 사원들 조회
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
WHERE not EMAIL like '___$_%' escape '$';

------------------------------------ 실습문제 ---------------------------------------------
--1. EMPLOYEE에서 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 입사일 조회
select EMP_ID, EMP_NAME, HIRE_DATE
from EMPLOYEE
where EMP_NAME like '%연';

--2. EMPLOYEE에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select EMP_NAME, PHONE
from EMPLOYEE
where not PHONE like '010%';

--3. EMPLOYEE에서 이름에 '하'가 포함되고, 급여가 240만원 이상인 사원의 사번, 사원명, 급여
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where EMP_NAME like '%하%' and SALARY >=2400000;

--4. DEPARTMENT에서 해외영업부인 부서들의 부서코드, 부서명 조회
select DEPT_ID,DEPT_TITLE
from department
where DEPT_TITLE like '해외영업%';

----------------------------------------------------------------------------------
/*
 <IS NULL / IS NOT NULL>
 컬럼값에 NULL이 있을 경우 NULL값 비교에 이용하는 연산자
 */

-- EMPLOYEE에서 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, BONUS
from EMPLOYEE
where BONUS IS null;

-- EMPLOYEE에서 보너스를 받는 사원들의 사번, 이름, 급여, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, BONUS
from EMPLOYEE
where BONUS is not null;

-- ENPLOYEE에서 사수가 없는 사원의 사원명, 부서코드, 사수 조회
select EMP_NAME, DEPT_CODE, MANAGER_ID
from EMPLOYEE
where MANAGER_ID is null;

-- EMPLOYEE에서 부서배치를 받지않았지만 보너스는 받는 사원들의 이름, 보너스, 부서코드 조회
select EMP_NAME, BONUS, DEPT_CODE
from EMPLOYEE
where DEPT_CODE is null and BONUS is not null;

------------------------------------------------------------------
/*
 <IN / NOT IN>
 IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는것만 조회
 NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지 조회

 [표현법]
 비교대상컬럼 IN ('값1', '값2', '값3', '값4',.....) 
 */

-- EMPLOYEE에서 부서코드가 'D6'이거나 'D8'이거나 'D5'인 사원의 이름, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE in ('D6', 'D8','D5');		--WHERE DEPT_CODE ='D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';

-- 위 조건을 제외한 사원들
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE not in ('D6', 'D8','D5');

------------------------------------------------------------------------------------------
/*
 <연산자 우선순위>
 1. ()
 2. 산술 연산자
 3. 연결 연산자
 4. 비교 연산자
 5. IS NULL / LIKE '패턴' / IN
 6. BETWEEN AND
 7. NOT(논리연산자)
 8. AND(논리연산자)
 9. OR(논리연산자) 
 */

-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
select *
from EMPLOYEE
--where JOB_CODE = 'J7' or JOB_CODE = 'J2' and SALARY >=2000000;	-- AND가 우선순위가 높아서 J2이면서 급여가 200만원 이상인 사원과 JOB_CODE가 J7인 사원모두가 조회됨
where (JOB_CODE = 'J7' or JOB_CODE = 'J2') and SALARY >=2000000;


-------------------------- 실습문제------------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
select EMP_NAME, MANAGER_ID, DEPT_CODE
from EMPLOYEE
where MANAGER_ID is null and DEPT_CODE is null;

-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 
--		사번, 사원명, 연봉, 보너스 조회
select EMP_ID, EMP_NAME, SALARY*12 as 연봉, BONUS
from EMPLOYEE
where SALARY*12 >=30000000 and BONUS is null;

-- 3. 입사일이 1995-01-01 이상이고 부서배치를 받은 사원들의 
--		사번, 사원명, 입사일, 부서코드 조회
select EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
from EMPLOYEE
where HIRE_DATE > '1995-01-01' and DEPT_CODE is not null;

-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 2001-01-01 이상이고 
--		보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
from EMPLOYEE
where SALARY between 2000000 and 5000000 and HIRE_DATE >= '2001-01-01' and BONUS is null;

-- 5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
--		사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)
select EMP_ID, EMP_NAME, SALARY, (BONUS*SALARY)+SALARY*12 as 소득
from EMPLOYEE
where BONUS*SALARY+SALARY*12 is not null and EMP_NAME LIKE '%하%';


------------------------------- 종합 문제 ----------------------------------
-- 1. JOB테이블에서 모든 정보 조회
select *
from JOB;

-- 2. JOB 테이블에서 직급 이름 조회
select JOB_NAME
from JOB;

-- 3. DEPARTMENT 테이블에서 모든 정보 조회
select *
from DEPARTMENT;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select EMP_NAME, EMAIL, PHONE, HIRE_DATE
from EMPLOYEE;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select HIRE_DATE, EMP_NAME, SALARY
from EMPLOYEE;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
select EMP_NAME, SALARY*12 as 연봉, BONUS*SALARY+SALARY*12 as 총수령액, (BONUS*SALARY+SALARY*12)-SALARY*12*0.03 as 실수령액
from EMPLOYEE;

-- 7. EMPLOYEE테이블에서 DEPT_CODE가 D5인 사원의 이름, 부서코드, 월급, 고용일, 연락처 조회
select EMP_NAME, DEPT_CODE, SALARY, HIRE_DATE, PHONE
from EMPLOYEE;

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select EMP_NAME, SALARY, BONUS*SALARY+SALARY*12-SALARY*12*0.03 as 실수령액, HIRE_DATE
from EMPLOYEE
where BONUS*SALARY+SALARY*12-SALARY*12*0.03 >=50000000;

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select *
from EMPLOYEE
where SALARY >=4000000 and JOB_CODE ='J2';

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select EMP_NAME, DEPT_CODE, HIRE_DATE
from EMPLOYEE
where (DEPT_CODE ='D9' or DEPT_CODE = 'D5') and HIRE_DATE <= '2002-01-01';

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
select *
from EMPLOYEE
where HIRE_DATE between '1990-01-01' and '2001-01-01';


-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
select EMP_NAME
from EMPLOYEE
where EMP_NAME like '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select EMP_NAME, PHONE
from EMPLOYEE
where not PHONE like '010%'


-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
select *
from EMPLOYEE
where (EMAIL like '____$_' escape '$') and (DEPT_CODE ='D9' or DEPT_CODE='D6') and (HIRE_DATE between '1990-01-01' and '2000-12-01') and SALARY >= 2700000;


------------------------------------------------------------------
/*
 <order by 절>
 SELECT문 가장 마지막 줄에 작성함. 실행순서도 맨 마지막에 실행
 
  [표현법]
  SELECT 조회할 컬럼, 컬럼, ....
  FROM 테이블명
  WHERE 조건식 
  ORDER BY 정렬 기준의 컬럼명 / 별칭 / 컬럼 순서[ASC(오름차순) | DESC(내림차순)] [NULLS FIRST | NULLS LAST]
  
  - ASC : 오름차순 정렬(생략 시 기본값)
  - DESC : 내림차순 정렬
  
  - NULLS FIRST : NULL데이터를 맨 앞에 배치(생략시 DESC 기본값)
  - NULLS LAST : NULL데이터를 맨 끝에 배치(생략시 ASC 기본값)
  
 */
select *
from EMPLOYEE
--order by BONUS;
--order by BONUS ASC;
--order by BONUS nulls FIRST;
--order by BONUS DESC;
order by BONUS desc, SALARY;		-- 보너스 내림차순 후 급여 오름차순.	 기준정렬 여러개 사용 가능

-- 전 사원의 사원명, 연봉조회(연봉의 내림차순 정렬 조회)
select EMP_NAME, SALARY*12 as 연봉
from EMPLOYEE
--order by SALARY*12 desc;
--order by 연봉 desc;
order by 2 desc;		-- 3개 모두 사용 가능





























