-- 문제 1. 시작값 700, 증가값 3, 최댓값 715, NO CYCLE, CACHE 2인
-- SEQ_LOGIN_LOG 시퀀스를 생성하고 NEXTVAL을 2회 실행한 뒤 CURRVAL을 조회
create sequence SEQ_LOGIN_LOG
start with 700
increment 3
maxvalue 715
no cycle
cache 2;

select NEXTVAL('SEQ_LOGIN_LOG');
select NEXTVAL('SEQ_LOGIN_LOG');
select CURRVAL('SEQ_LOGIN_LOG');

-- 문제 2. LOGIN_HISTORY 테이블을 생성하고
-- SEQ_LOGIN_LOG의 NEXTVAL과 CURRENT_DATE를 사용하여
-- 사원번호 200, 201, 202의 로그인 기록을 각각 INSERT한 뒤 전체 조회
create table LOGIN_HISTORY (
	LOG_NO SERIAL primary key,
	EMP_ID VARCHAR(20)
);

insert into LOGIN_HISTORY(EMP_ID)
values ('200');
insert into LOGIN_HISTORY(EMP_ID)
values ('201');
insert into LOGIN_HISTORY(EMP_ID)
values ('202');

select * from LOGIN_HISTORY;

-- 문제 3. SEQ_LOGIN_LOG의 증가값을 4로 변경한 뒤 NEXTVAL을 조회
-- 이어서 RESTART WITH 900, MAXVALUE 950으로 변경하고 NEXTVAL을 조회
alter sequence SEQ_LOGIN_LOG
increment by 4;

select NEXTVAL('SEQ_LOGIN_LOG');

alter sequence SEQ_LOGIN_LOG
RESTART WITH 900
MAXVALUE 950;

select NEXTVAL('SEQ_LOGIN_LOG');

-- 문제 4. VISIT_RECORD 테이블을 생성하고
-- VISIT_NO를 SERIAL PRIMARY KEY로 지정
-- 방문자명과 방문일을 입력하여 2건 INSERT한 뒤
-- PG_GET_SERIAL_SEQUENCE로 시퀀스 이름을 확인하고 전체 데이터 조회
CREATE table VISIT_RECORD(
	VISIT_NO SERIAL primary key,
	VISIT_NAME VARCHAR(20),
	VISIT_DATE VARCHAR(20)
);

insert into VISIT_RECORD (VISIT_NAME, VISIT_DATE)
values ('홍진주','2026-11-05');
insert into VISIT_RECORD (VISIT_NAME, VISIT_DATE)
values ('홍길동','2026-11-04');

select PG_GET_SERIAL_SEQUENCE('visit_record', 'visit_no');

select * from public.visit_record_visit_no_seq;

-- 문제 5. SEQ_TEMP_ORDER 시퀀스를 생성하고 NEXTVAL을 1회 실행
-- 이후 해당 시퀀스를 삭제
create sequence SEQ_TEMP_ORDER;

select nextval('SEQ_TEMP_ORDER');

drop sequence SEQ_TEMP_ORDER;


-- 문제 6. DO 블록에서 EMPLOYEE의 EMP_ID%TYPE, EMP_NAME%TYPE,
-- SALARY%TYPE을 참조하는 변수를 선언
-- 사번이 '209'인 사원의 사번, 이름, 급여를 SELECT INTO로 조회하고
-- RAISE NOTICE로 세 값을 출력
do $$
declare
	EID EMPLOYEE.EMP_ID%type;
	ENAME EMPLOYEE.EMP_NAME%type;
	SAL EMPLOYEE.SALARY%type;
begin
	select EMP_ID, EMP_NAME, SALARY 
	into EID, ENAME, SAL
	FROM EMPLOYEE
	where EMP_ID='209';
	raise notice '사번 : %',EID;
	raise notice '이름 : %', ENAME;
	RAISE NOTICE '급여 : %', SAL;
end;
$$;



-- 문제 7. DO 블록에서 EMPLOYEE%ROWTYPE 변수를 선언
-- 사번이 '212'인 사원의 전체 행을 조회하여 변수에 저장하고
-- 사원명, 직급코드, 입사일, 퇴직여부를 RAISE NOTICE로 출력
do $$
declare
	E EMPLOYEE%ROWTYPE;
begin
	select *
	into E
	from EMPLOYEE
	where EMP_ID ='212';
	raise notice '사원명 : %', E.EMP_NAME;
	raise notice '직급코드 : %', E.JOB_CODE;
	raise notice '입사일 : %', E.HIRE_DATE;
	raise notice '퇴직여부 : %', E.ENT_YN;
end;
$$;



-- 문제 8. DO 블록에서 사번이 '205'인 사원의 급여와 급여등급을 조회
-- SAL_GRADE의 MIN_SAL, MAX_SAL 범위를 이용하여 급여등급(SAL_LEVEL)을 찾고
-- 급여와 급여등급을 RAISE NOTICE로 출력
do $$
declare
	SAL EMPLOYEE.SALARY%type;
	GRADE SAL_GRADE.SAL_LEVEL%type;
begin
	select SALARY, SAL_LEVEL
	into SAL, GRADE
	from EMPLOYEE
	join SAL_GRADE on (SALARY between MIN_SAL AND MAX_SAL)
	where EMP_ID='205';
	raise notice '% %', SAL, GRADE;
end;
$$;


-- 문제 9. DO 블록에서 사번이 '207'인 사원의 직급코드와 직급명을 조회
-- CASE문을 사용하여 직급코드가 J1 또는 J2이면 '임원급',
-- J3 또는 J4이면 '관리자급', J5이면 '중간관리자급',
-- 그 외에는 '일반직원'으로 구분
-- 사원명, 직급명, 직급분류를 RAISE NOTICE로 출력
do $$
declare
	ENAME EMPLOYEE.EMP_NAME%type;
	JCODE JOB.JOB_CODE%type;
	JNAME JOB.JOB_NAME%TYPE;
	JGROUP VARCHAR(20);
begin
	select EMP_NAME, JOB_NAME
	into ENAME, JNAME
	from EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	where EMP_ID='207';
	case 
		when JCODE in ('J1','J2') then JGROUP:='임원급';
		when JCODE in ('J3','J4') then JGROUP:='관리자급';
		else JGROUP := '일반직원';
	end CASE;
	raise notice '사원명 : %', ENAME;
	raise notice '직급명 : %', JNAME;
	raise notice '직급분류 : %', JGROUP;
end;
$$;




-- 문제 10. DO 블록에서 FOR LOOP를 사용하여 1부터 5까지 반복
-- 각 숫자에 3을 곱한 결과를 RAISE NOTICE로 출력
-- 단, 결과가 9인 경우에는 '9는 건너뜁니다'를 출력하고
-- 곱셈 결과는 출력하지 않도록 IF 조건문을 사용
do $$
begin
	for I in 1..5
	loop
		if I*3 =9 then 
			raise notice '9는 건너뜁니다';
		else
			raise notice '% * 3=%', I, I*3;
		end if;
	end loop;
end;
$$;














