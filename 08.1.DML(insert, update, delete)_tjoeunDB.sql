/*
 * DML
   INSERT : 테이블에 데이터 삽입
   UPDATE : 테이블의 데이터를 수정
   DELETE : 테이블의 데이터(행)을 삭제
 */
--========================================
/*
 1. INSERT
 	테이블에 새로운 생을 추가하는 구문
 	
 	[표현식]
 	1) INSERT INTO 테이블명 VALUES (값1, 값2, 값3,...);
 		테이블의 모든 컬럼에 대한 값을 한행을 넣고 할 때 사용
 		컬럼의 순서를 지켜 VALUES에 값을 나열해야 함
 */
insert into EMPLOYEE_COPY VALUES(300, '더조은', '031103-3452576', 'tjoeun@google.com'
							, '01012345678', 'D3','J7',3500000, 0.1, 208
							, '2025-08-15', null, DEFAULT);

-------------------------------------------------------------------------------------
/*
	2) INSERT INTO 테이블명(컬럼명1, 컬럼명2,...) VALUES (값1, 값2,...);
		테이블에 내가 선택한 컬럼에 대한 값만 삽입할 때 사용
		그래도 한 행 단위로 추가됨
		** 주의 : NOT NULL인 컬럼은 반드시 값이 들어가야 함
		- 기본값이 지정되어 있는 것은 값을 안넣으면(컬럼을 아예 안넣음) 자동으로 기본값이 들어감
*/
insert into EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
values (301, '이티어','051111-4567895', 'J5', CURRENT_DATE);

-- 컬럼을 제시할 때 순서와 상관없이 해도 됨
-- 그러나 데이터값은 제시한 컬럼의 순서와 동일해야 됨
insert into EMPLOYEE_COPY( HIRE_DATE, JOB_CODE, EMP_NO,EMP_ID, EMP_NAME)
values (CURRENT_DATE, 'J5','051111-4567895',303, '이티어' );

-- NOT NULL인 JOB_CODE에 데이터값 입력 안하면 오류
insert into EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
values (302, '황반가','040111-4567895', CURRENT_DATE);

-----------------------------------------------------------------------
/*
 	3) INSERT INTO 테이블명(서브쿼리);
 		VALUES로 값을 직접 명시하는 대신에 서브쿼리로 조회된 결과값을 모두 INSERT함
 		여러행도 가능
 * */
-- EMP_01 테이블생성
create table EMP_01(
	EMP_ID VARCHAR(3),
	EMP_NAME VARCHAR(20),
	DEPT_NAME VARCHAR(35)
);

-- 전체 사원들의 사번, 이름, 부서명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE=DEPT_ID);

-- EMP_01 테이블에 데이터 삽입
insert into EMP_01
select EMP_ID, EMP_NAME, DEPT_TITLE
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE=DEPT_ID);

-----------------------------------------------------
/*
 	4) WITH절로 두개 이상의 테이블에 한꺼번에 INSERT
 		WITH절 안에서 INSERT, UPDQTE, DELETE 같은 데이터 변경 작업도 수행 가능
 		이름 CTE(DATA-MODIFYING)라고 부름
*/
-- 테이트할 테이블 2개 생성
create table EMP_DEPT
as select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
	from EMPLOYEE
	where 1=0;

create table EMP_MANAGER
as select EMP_ID, EMP_NAME, MANAGER_ID
	from EMPLOYEE
	where 1=0;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
from EMPLOYEE
where DEPT_CODE='D1';

with DATA_INFO as (
	select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
	from EMPLOYEE
	where DEPT_CODE='D1'
),
INFO1 as (
	insert into EMP_DEPT (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
	select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
	from DATA_INFO
)
--INFO2 as (
--	insert into EMP_NAME (EMP_ID, EMP_NAME, MANAGER_ID)
--	select EMP_ID, EMP_NAME, MANAGER_ID
--	from DATA_INFO
--);

insert into EMP_MANAGER (EMP_ID, EMP_NAME, MANAGER_ID)
	select EMP_ID, EMP_NAME, MANAGER_ID from DATA_INFO;


--========================================
/*
 2. UPDATE
  	테이블에 기록되어 있는 기존 데이터를 수정하는 구문
  	
  	[표현법]
  	UPDATE 테이블명
  	SET 컬럼명 = 바꿀값, 
  		컬럼명 = 바꿀값,
  		...
  	[WHERE 조건];		--> 주의 : 생략하면 전체 모든 행의 데이터가 변경됨
 */
-- 테이블 생성
create table DEPT_COPY
as select * from DEPARTMENT;

-- D9 부서의 부서명을 '전략기획팀'으로 수정
update DEPT_COPY
set DEPT_TITLE = '전략기획팀'		-- WHERE절 작성 안하면 모든 부서명이 바뀜

update DEPT_COPY
set DEPT_TITLE = '전략기획팀'
where DEPT_ID ='D9';
COMMIT;

-- 복사본 테이블 생성
create table EMP_SALARY
as select EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
	from EMPLOYEE;
commit;

-- 지민재 사원의 급여를 200만원으로 변경
update EMP_SALARY 
set SALARY = 2000000
where EMP_NAME = '지민재';

select * from EMP_SALARY;

-- 이정하 사원의 급여를 700만원으로 바꾸고 보너스를 0.2로 변경
update EMP_SALARY
set SALARY=7000000,
	BONUS =0.2
where EMP_NAME='이정하';
--> select * from EMP_SALARY; 또 작성할 필요없이 
--	위에있는 select * from EMP_SALARY; 실행

-- 전체사원의 급여를 10% 인상
update EMP_SALARY
set SALARY = SALARY*1.1;
commit;

update EMP_SALARY
set SALARY=7000000,
	BONUS =0.2
where EMP_NAME='박서준';

------------------------
/* 
  - UPDATE시 서브쿼리 사용 가능
	[표현법]
	UPDATE 테이블명
	SET 컬럼명 = (서브쿼리)
	WHERE 조건;
*/
-- 정훈 사원의 급여와 보너스를 조정연 사원의 급여와 보너스로 변경
-- 단일 컬럼 서브쿼리
update EMP_SALARY
set SALARY = (select salary 
				from EMP_SALARY
				where EMP_NAME ='조정연'),
	BONUS = (select BONUS 
				from EMP_SALARY
				where EMP_NAME ='조정연')
where EMP_NAME = '정훈';
select * from EMP_SALARY;

-- 다중열 서브쿼리
update EMP_SALARY
set (SALARY, BONUS)= (select salary, BONUS
						from EMP_SALARY
						where EMP_NAME ='조정연')
where EMP_NAME ='황승현';

-- 전지연, 선우진, 현준혁, 배윤서, 전재민 사원들의 보너스와 급여를 강태윤 사원과 같은 금액으로 변경
update emp_salary 
set (SALARY, BONUS) = (select SALARY, bonus 
						from emp_salary 
						where EMP_NAME ='강태윤')
where EMP_NAME in ('전지연', '선우진','현준혁','배윤서','전재민');

-- ASIA2 지역에 근무하는 사원들의 보너스를 0.6으로 변경
-- ASIA2 지역에 근무하는 사원 조회
select EMP_ID, EMP_NAME
from EMP_SALARY
join DEPARTMENT on (DEPT_CODE=DEPT_ID)
join location on (LOCATION_ID=LOCAL_CODE)
where LOCAL_NAME like 'ASIA2';

update EMP_SALARY
set BONUS = 0.6
where EMP_ID IN(select EMP_ID
				from EMP_SALARY
				join DEPARTMENT on (DEPT_CODE=DEPT_ID)
				join location on (LOCATION_ID=LOCAL_CODE)
				where LOCAL_NAME like 'ASIA2');

commit;

-------------------------------------------------------------
-- UPDATE시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨
-- 사번이 200번인 사원의 이름을 NULL로 변경
update EMPLOYEE
set EMP_NAME=null
where EMP_ID='200';

-- PRIMARY KEY 제약조건 위배 오류
update EMPLOYEE
set EMP_ID='200'
where EMP_NAME ='이정하';

-- 외래키오류
update EMPLOYEE
set DEPT_CODE = 'D0'
where EMP_NAME = '이정하';

--================================================
/*
 3. DELETE
 	테이블의 데이터를 행단위로 삭제하는 구문
 	
 	[표현법]
 	DELECT FROM 테이블명
 	[WHERE 조건];		-- 조건을 안 넣으면 테이블 전체 행이 삭제됨
 */

DELETE from EMPLOYEE_COPY
where EMP_ID = '201';

select * from EMPLOYEE_COPY;

-- 외래키 때문에 삭제 거부됨
delete from DEPARTMENT
where DEPT_ID = 'D1';

/*
 * TRUNCATE : 테이블 전체 행을 삭제할 때 사용하는 구문
 	DELETE보다 수행속도가 빠름
 	
 	 [표현법]
 	 TRUNCATE TABLE 테이블명; 
 */
truncate table EMP_SALARY;
truncate table EMP_01;
select * from EMP_SALARY;
rollback;














