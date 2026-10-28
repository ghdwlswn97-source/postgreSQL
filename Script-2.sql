/*
 <함수 FUNCTION>
 전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
 
  - 단일행 함수 : N개의 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행) 
  - 그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
  
  >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
  >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
 */

--------------------------------단일행 함수------------------------------------

--==========================================================================
--								<문자 처리 함수>
--==========================================================================
/*
 	* LENGTH / OCTET_LENGTH => INTEGER로 반환
 	 
 	  LENGTN(컬럼명 | '문자열') : 해당 글자수 반환
 	  OCTET_LENGTH(컬럼명 | '문자열') : 해당 문자열의 BYTE수 반환
 	  	- 한글 : 1글자당 3BYTE / 영문, 숫자, 공백 : 1글자당 1BYTE 
 */
  
select LENGTH('데이터베이스'), OCTET_LENGTH('데이터베이스');

select LENGTH('postgreSQL'), octet_length('postgreSQL');

select emp_name, length(emp_name), octet_length(emp_name), email, length(email)
		, octet_length(email)
from employee;


----------------------------------------------------------------------
/*
  * left / right('문자열', 글자수) : 왼쪽/오른쪽 끝에서 부터 지정한 개수만큼 문자열 반환
  	> 글자수에 음수를 넣으면 맨 뒤/앞의 글자수 만큼 제외하고 나머지 전부 
 */

select left('databaseprostgresql',4);
select right('databaseprostgresql',3);
select right('서울특별시', 3);

select right('dataBasepostgreSQL', -8);		-- 맨 뒤의 글자 3개를 제외하고 반환
select left('dataBasepostgreSQL', -8);		-- 맨 앞의 글자 8개를 제외하고 반환

select right('data', 100);		-- 글자수보다 지정한 수가 커도 상관없음
select right('data', 0);		-- 0 입력시 빈 문자열 반환

------------------------------------------------------------------------
/*
  * POSITION / STRPOS : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(1부터 시작, 없으면 0) 
 */

select POSITION('A' in 'DATABASE');
select STRPOS('DATABASE', 'A');		-- 결과 동일
select POSITION('A' in REVERSE('DATABASE'));		-- 결과 3 -> 뒤에서부터 1번으로 INDEX도 뒤집힌다

select EMAIL
	,POSITION('_'in EMAIL) as "_위치"
	,POSITION('@' in EMAIL) as "@위치"
from EMPLOYEE;

------------------------------------------------------------
/*
  * SUBSTR / SUBSTRING : 문자열에서 특정 문자열을 추출
  
  
  - SUBSTR('문자열', POSITION, [LENGTH])
  	> POSITION : 문자열을 추출할 시작위치 INDEX
  	> LENGTH : 추출할 문자 개수(생략시 맨 끝까지 추출)
  - SUBSTRING('문자열', FROM POSIRION [FOR LENGTH])
 */

select SUBSTR('DATABASESQL', 5);
select SUBSTRING('DATABASESQL' from 5)

select SUBSTRING('DATABASESQL', 5,4);
select SUBSTRING('DATABASESQL'from 5 for 4);

select SUBSTR('DATABASESQL', 3, 6);
select SUBSTRING('DAGABASESQL' from 3 FOR 6);

-- EMPLOYEE테이블에서 주민번호, 성별만 추출하여 주민번호, 사원명, 성별 조회
--select EMP_NO like '%-1%' as M, EMP_NO like '%-2%' as F, EMP_NAME
select EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
from EMPLOYEE;

-- EMPLOYEE에서 여자사원들만 사번, 사원명, 성별(1~4중 하나) 조회
select EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
from EMPLOYEE
--where EMP_NO like '%-2%' OR EMP_NO like '%-4%';
where SUBSTR(EMP_NO, 8, 1)= '2' or SUBSTR(EMP_NO, 8, 1) ='4';

--EMPLOYEE에서 남자사원들만 사번, 사원명, 성별(1~4중 하나) 조회
select EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in ('1', '3');

--EMPLOYEE에서 EMAIL의 아이디만 추출하여 사원명, 이메일, 아이디 조회
select EMP_NAME, EMAIL, 
from EMPLOYEE


