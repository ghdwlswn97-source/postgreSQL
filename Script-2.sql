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
select EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, POSITION('@' in EMAIL)-1) 아이디
from EMPLOYEE;

select EMP_NAME, EMAIL, SUBSTRING(EMAIL from 1 FOR POSITION('@' in EMAIL)-1) 아이디
from EMPLOYEE;

----------------------------------------------------------------------------------------
/*
  * LPAD / RPAD : 문자열 조회할 때 길이를 맞춰 통일감있게 조회하고자 할 때
  
    LPAD / RPAD ('문자열', 최종 반환할 문자의 길이, [덧붙이고자 하는 문자(생략가능]) 
 */
--20길이에 맞춰 EMAIL을 오른쪽 정렬하고 앞부분은 공백으로 채워서 출력
select EMP_NAME, LPAD(EMAIL, 25)		-- 덧붙이는 문자 생략시 기본값 공백
from EMPLOYEE;

select EMP_NAME, LPAD(EMAIL, 25,'#')
from EMPLOYEE;

select EMP_NAME, RPAD(EMAIL, 25, '#')
from EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 사원명, 주민번호 출력(주민번호는 123456-1******의 형식으로 출력)
select EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8),14, '*')
from EMPLOYEE;

select EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8)||'******' as 주민번호
from EMPLOYEE;

/*
  * LTRIM / RTRIM : 문자열에서 특정 문자를 제거하고 반환
  * TRIM : 문자의 앞/뒤 양쪽에 있는 특정 문자를 제거하고 반환
  
    LTRIM / RTRIM ('문자열',제거하고자 하는 문자) -> 제거하고자 하는 문자 생략시 공백제거
    TRIM([LEADING|TRAILING|BOTH]제거하고자 하는 문자 FROM '문자열')
 */
select LTRIM('     TJOEUM     ')|| '컴퓨터아카데미';
select rtrim('     THOEUM     ')|| '컴퓨터아카데미';

select LTRIM('DATADATABASE', 'DATA');
select LTRIM('BACABAADEIASDJ', 'ABC');
select LTRIM('4523ADKF5432', '0123456789');

select RTRIM('4523ADKF5432', '0123456789');

select TRIM('     TJOEUN     ')|| '컴퓨터아카데미';		-- 기본값 : 양쪽제거

-- 방향지정
select TRIM(LEADIGN'A' from 'AAAAVDFKSLDFSFEFSN');
select TRIM(trailing 'A' from 'AAAA34DAJFAAA');
select TRIM(both 'A' FROM 'AAADFK3847DDAA');
select TRIM('A' FROM 'AAADFK3847DDAA');

/*
  LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 앞글자만 대문자호 반환
  LOWER('문자열') 
 */

select LOWER('DATABASE PostgreSQL');
select upper('DATABASE PostgreSQL');
select initcap('dATABASE PostgreSQL');

-----------------------------------------------------------
/*
  * conact : 문자열 두개를 하나로 합친결과 반환
  * 
  * concat('문자열', '문자열',...)
 * */

select concat('sql', '포스트그레');
select canat('postgreSQL''데이터베이스', '02-1234-3456;');

select 'sql' || 포스트그레
--------------------------------------------------------------
/*
   * REPLACE : 기준 문자열을 새로운 문자열로 변경
   
    [표현법]
    REPLACE('문자열', '기존문자DUF', '바꿀문자열')
    FROM EMPLOYEE; 
 * */



--------------------------------단일행 함수------------------------------------

--==========================================================================
--								<숫자 처리 함수>
--==========================================================================
/*
 * ABS : 숫자의 절대값을 구하는 함구
 * ABL(NUMBER)
 * */
select ABS(-19);
select ABS(-13.67);

---------------------------------------------
/*
 * MOD / $ 나머즤 값 반환*/
select MOD(1-,3);
select 10%3;

-----------------------------------------
/*
 *  ROUND* : 반올림한 결과 반환
 * 
 	 [표현법]
 	 ROUND(NUMBER, [위치]
 	 */

select ROUND(1234.56);
select ROUND(12.34);

select ROUND(1234.5678, 2);
select ROUND(1234.56, 4);

select ROUND(1234.56, -1);
-----------------------------------------
/*
 * CEIL : 올림한 결과 반환
 * FLOOR : 내림한 결과 반환
 * */

select CEIL(123.234);
select CEIL(-123.234);

select FLOOR(123.234);
select FLOOR(-123.234);
-----------------------------------------
/*
 * TRUNC : 버림
 * TRUNC(NUMBER,[위치])
 */
select TRUNC(123.789);
select TRUNC(123.789, 1);

select TRUNC(-123.789);

select TRUNC(125.456, -1);

--------------------------------단일행 함수------------------------------------

--==========================================================================
--								<날짜 처리 함수>
--==========================================================================
/*
 *  CURRENT_DATE : 시스템 날짜(오늘날짜)
 *  NOW() : 시스템 날짜와 시간
 */
select CURRENT_DATE;
select NOW();

select EMP_NAME, HIRE_DATE, CURRENT_DATE - HIRE_DATE 근무일수
from EMPLOYEE;

-----------------------------------------
/*
 * INTEVAL 'n MONTH' : 특정 날짜에 해당 숫자만큼 개월수를 더해 날짜를 리턴
 */
select CURRENT_DATE + interval '1 MONTH' as 다음달;
select (CURRENT_DATE + interval '1 MONTH')::DATE as 다음달;		-- DATE 타입으로 형변환 -> ::DATE

--EMPLOYEE에서 사원명, 입사일, 입사후 정직원된 날짜(6개월 후) 조회
select EMP_NAME, HIRE_DATE, (HIRE_DATE + interval '6 MONTH')::DATE as "정직원된 날짜"
from EMPLOYEE;

-----------------------------------------
/*
 * EXTRACT : 특정날짜로부터 년|월|일 값을 추출하여 반환
 * 
 * EXTRACT(YEAR FROM DATE) : 년도만 추출
 * EXTRACT(MONTH FROM DATE) : 월만 추출
 * EXTRACT(DAY FROM DATE) : 일만 추출
 */
--EMPLOYEE에서 사원명, 입사년도, 입사월, 입사일 조회
select EMP_NAME
	, EXTRACT(year from HIRE_DATE) as 입사년도
--	EXTRACT(year from HIRE_DATE)::TEXT as 입사년도  ::TEXT -> 문자열로 형변환
	, EXTRACT(month from HIRE_DATE) as 입사월
	, EXTRACT(day from HIRE_DATE) as 입사일
from EMPLOYEE;


--==========================================================================
--								<형 변환 함수>
--==========================================================================
/*
 * TO_CHAR : 숫자 또는 날짜를 문자로 변환
   
   - 특정형식에 맞게 출력 가능
     TO_CHAR(숫자|날짜, [포맷])
 */
-------------------------------숫자타입=>문자타입
/*
 	9 : 해당 자리의 숫자를 의미
 		- 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
 	0 : 해당 자리의 숫자를 의미
 		- 값이 없을 경우 0으로 표시
 	FM : 해당자리에 값이 없을 경우 자리차지하지 않음
 * */
select TO_CHAR(1234, '99999'), TO_CHAR(1234, '00000');
select TO_CHAR(123.45, '99999.9999'), TO_CHAR(123.45, '00000.0000');
select TO_CHAR(0.12, '9.99'), TO_CHAR(0.12,'0.00');

select '￦' || TO_CHAR(1234, '99,999');

select EMP_NAME
		, '￦' || TO_CHAR(SALARY, '999,999,999') as 급여
		, '￦' || TO_CHAR(SALARY*12, '999,999,999') as 연봉
from EMPLOYEE;

select TO_CHAR(0.1000, '999,990.999');	

select to_CHAR(123.456, 'FM99990.999')
		,TO_CHAR(1234.56, 'FM9990.99')
		, TO_CHAR(0.1000, 'FM9990.99')
		, TO_CHAR(0.1000, 'FM9999.999');


--postgreSQL에서만 사용
-- FML : L(LOCAL의 설정에 따라 통화 기호 나타냄)
select TO_CHAR(1234, 'FML999,999');

select EMP_NAME
	, TO_CHAR(SALARY, 'FML999,999,999') as 급여
	, TO_CHAR(SALARY*12, 'FML999,999,999') as 연봉

-----------------------------------------날짜타입 => 문자타입
-- DAY 제외 대소문자 상관 없음
select TO_CHAR(NOW(), 'YYYY') as 년도4자리
	, TO_CHAR(NOW(), 'YY') as 년도2자리
	, TO_CHAR(NOW(),'MM') as 월
	, TO_CHAR(NOW(), 'DD') as 일
	, TO_CHAR(NOW(), 'DAY') as 요일		-- day이면 소문자로 요일, DAY이면 대문자로 요일
	, TO_CHAR(NOW(), 'HH') as 시
	, TO_CHAR(NOW(), 'MI') as 분
	, TO_CHAR(NOW(), 'SS') as 초;
	




