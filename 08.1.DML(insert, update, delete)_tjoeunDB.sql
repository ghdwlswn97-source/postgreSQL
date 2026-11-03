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

-- NOT NULL인 JOB_CODE에 데이터값 입력 안하면 오류
insert into EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
values (302, '황반가','040111-4567895', CURRENT_DATE);


































