/*
문제 1. VW_PRACTICE_COUNTRY 뷰를 생성
조회할 컬럼:
- 사번(EMP_ID)
- 사원명(EMP_NAME)
- 부서명(DEPT_TITLE)
- 급여(SALARY)
- 국가명(NATIONAL_NAME)
*/
CREATE VIEW VW_PRACTICE_COUNTRY
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
	JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
	JOIN NATIONAL USING (NATIONAL_CODE);

/*
문제 2. 문제 1에서 만든 VW_PRACTICE_COUNTRY 뷰를 이용하여 다음 국가에서 근무하는 사원의 모든 정보를 각각 조회
1) 한국
2) 러시아
3) 일본
*/
select *
from VW_PRACTICE_COUNTRY
where national_NAME in ('한국','러시아','일본');


/*
문제 3. VW_PRACTICE_EMP_JOB 뷰를 생성
조회할 컬럼:
- 사번
- 사원명
- 직급명
- 성별
- 근무년수
*/
create view VW_PRACTICE_EMP_JOB
as select EMP_ID, EMP_NAME, JOB_NAME,
		case when SUBSTR(EMP_NO, 8,1) in ('1','3') then '남'
			when SUBSTR(EMP_NO, 8, 1) in ('2','4') then '여'
		end as 성별,
		extract(year from AGE(CURRENT_DATE, HIRE_DATE))
	from EMPLOYEE
	join JOB using (JOB_CODE);

/*
문제 4. VW_PRACTICE_EMP_JOB 뷰를 CREATE OR REPLACE VIEW로 다시 정의하기
이번에는 CREATE VIEW 뒤에 컬럼 별칭 목록을 작성하여 다음 이름으로 조회되도록 하기
> 사번, 이름, 직급명, 성별, 근무년수
*/
drop view VW_PRACTICE_EMP_JOB;

create or replace view VW_PRACTICE_EMP_JOB (사번, 이름, 직급명, 성별, 근무년수)
as select EMP_ID, EMP_NAME, JOB_NAME,
		case when SUBSTR(EMP_NO, 8,1) in ('1','3') then '남'
			when SUBSTR(EMP_NO, 8, 1) in ('2','4') then '여'
		end as 성별,
		extract(year from AGE(CURRENT_DATE, HIRE_DATE))
	from EMPLOYEE
	join JOB using (JOB_CODE);

/*
문제 5. VW_PRACTICE_EMP_SAL 뷰를 생성
조회할 컬럼:
- 사번
- 사원명
- 급여
- 연봉(급여 * 12) 별칭지정

연봉이 40,000,000 이상인 사원을 조회
*/ 
create view VW_PRACTICE_EMP_SAL
as select EMP_ID, EMP_NAME, SALARY, SALARY*12 as 연봉
	from EMPLOYEE;

select * from VW_PRACTICE_EMP_SAL where 연봉 >= 40000000;

/*
문제 6.
JOB 복사 테이블에서 JOB_CODE와 JOB_NAME만 조회하는 VW_PRACTICE_JOB 뷰 생성

그다음 트랜잭션 안에서 다음 작업을 순서대로 수행
1) 직급코드 J8, 직급명 '인턴' INSERT
2) J8의 직급명을 '아르바이트'로 UPDATE
3) J8 데이터 DELETE
4) ROLLBACK하여 원본 JOB 테이블을 원래 상태로 복구
*/
create table JOB_COPY
as select *
	from JOB;

create view VW_PRACTICE_JOB
as select JOB_CODE, JOB_NAME
	from JOB_COPY;

insert into VW_PRACTICE_JOB VALUES('J8','인턴');

update VW_PRACTICE_JOB
set JOB_NAME='아르바이트'
where JOB_CODE='J8';

delete from VW_PRACTICE_JOB 
where JOB_CODE ='J8';

rollback;


/*
문제 7. JOB 테이블에서 JOB_CODE만 조회하는 VW_PRACTICE_JOB_NAME 뷰 생성

그다음 아래 작업이 왜 불가능한지 확인
- 뷰에 없는 JOB_NAME 컬럼을 INSERT 대상으로 지정
- 뷰에 없는 JOB_NAME 컬럼을 UPDATE
*/
create view VW_PRACTICE_JOB_NAME
as select JOB_CODE
	from JOB;

insert into VW_PRACTICE_JOB_NAME (JOB_NAME) values ('인턴');
update VW_PRACTICE_JOB_NAME
set JOB_NAME='본부장';


--문제 8. 다음 4개의 뷰를 각각 생성
--
--1) VW_PRACTICE_DEPT_SAL
--   - EMPLOYEE에서 부서코드별 급여 합계와 평균 급여 조회
--   - GROUP BY 사용
create view VW_PRACTICE_DEPT_SAL
as select DEPT_CODE, SUM(SALARY), CEIL(AVG(SALARY))
	from EMPLOYEE
	group by DEPT_CODE;

--
--2) VW_PRACTICE_DISTINCT
--   - EMPLOYEE에서 중복을 제거한 JOB_CODE 조회
--   - DISTINCT 사용
create view VW_PRACTICE_DISTINCT
as select distinct JOB_CODE
	from EMPLOYEE;

--
--3) VW_PRACTICE_JOIN
--   - EMPLOYEE와 DEPARTMENT를 JOIN하여
--     사번, 사원명, 부서명 조회
create view VW_PRACTICE_JOIN
as select EMP_ID, EMP_NAME, DEPT_TITLE
	from EMPLOYEE
	join DEPARTMENT on (DEPT_CODE=DEPT_ID);


--
--4) 위 뷰들을 조회
select * from VW_PRACTICE_DEPT_SAL;
select * from VW_PRACTICE_DISTINCT;
select * from VW_PRACTICE_JOIN;

/*
문제 9. VW_PRACTICE_CHECK 뷰를 생성
조건: SALARY >= 3000000

그다음 트랜잭션 안에서 사번 200의 급여를 2000000으로 변경하고,
EMPLOYEE와 VW_PRACTICE_CHECK를 각각 조회.


마지막에는 ROLLBACK하여 원본 데이터를 복구.
*/
begin;

create view VW_PRACTICE_CHECK
as select *
	from EMPLOYEE
	where SALARY >= 3000000;

update VW_PRACTICE_CHECK
set SALARY=2000000
where EMP_ID ='200';

select * from VW_PRACTICE_CHECK;
select * from EMPLOYE;

rollback;

/*
문제 10. VW_PRACTICE_CHECK 뷰를 CREATE OR REPLACE VIEW로 다시 정의
조건은 SALARY >= 3000000이며 WITH CHECK OPTION을 지정

그다음 다음 작업을 수행
1) 사번 200의 급여를 4000000으로 변경하는 UPDATE 실행
2) 변경 결과를 조회
3) ROLLBACK하여 원본 데이터 복구
*/
create or replace view VW_PRACTICE_CHECK
as select *
	from EMPLOYEE
	where SALARY >= 3000000
	with check OPTION;

begin;

update VW_PRACTICE_CHECK
set SALARY=4000000
where EMP_ID ='200';

select * from VW_PRACTICE_CHECK;

rollback;


-- 문제 11. 지금까지 만든 모든 view들을 삭제

drop view if exists VW_PRACTICE_COUNTRY;		-- 이미 삭제 된 뷰는 오류 뜸. if exists로 뷰가 있을 경우만 삭제
drop view VW_PRACTICE_EMP_JOB;
drop view VW_PRACTICE_EMP_SAL;
drop view VW_PRACTICE_JOB;
drop view VW_PRACTICE_JOB2;
drop view VW_PRACTICE_JOB3;
drop view VW_PRACTICE_JOB_NAME;
drop view VW_PRACTICE_DEPT_SAL;
drop view VW_PRACTICE_DISTINCT;
drop view VW_PRACTICE_DEPT_SAL;
drop view VW_PRACTICE_DEPT_SAL;