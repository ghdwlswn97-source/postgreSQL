/*
 * ALTER
 	객체를 변경하는 구문
 	
 	[표현식]
 	ALTER TABLE 테이블명 변경할 내용;
 	
 	- 변경할 내용
 		1) 컬럼추가 / 수정 / 삭제
 		2) 제약조건추가 / 삭제	-> 수정불가(수정하려면 삭제하고 다시 새로 추가)
 		3) 컬럼명 / 제약조건명 / 테이블명 변경
 */

-----------------------------------------------------------------------
/*
  1. 컬럼 추가 / 수정 / 삭제
  	1.1 컬럼 추가(ADD)
  	
  	 [표현법]
  	 ADD 컬럼명 데이터타입 [DEFAULT 기본값] 
*/
create table DEPT_CP
as select *
	from DEPARTMENT;

-- DEPT_CP에 CNAME컬럼 추가
alter table DEPT_CP add CNAME VARCHAR(20);

-- LNAME 컬럼 추가, 기본값도 추가
alter table DEPT_CP add LNAME VARCHAR(20) default '한국';
--> 새로운 컬럼이 만들어지고 내가 지정한 기본값으로 채워짐

/*
  	1.2 컬럼수정 : ALTER COLUMN
  	
  	[표현법]
  	- 데이터 타입 수정
  		ALTER COLUMN 컬럼명 TYPE 바꾸고자하는데이터타입
  		
  	- DEFAULT 값 수정
  		ALTER COLUMN 컬럼명 SET DEFAULT 바꾸고자하는기본값
*/
-- DEPT_CP 테이블에서 DEPT_ID의 데이터타입을 CHAR(3)으로 변경
alter TABLE DEPT_CP alter column DEPT_ID type CHAR(3);

-- 컬럼값에 문자가 들어있는 경우 컬럼의 데이터 타입을 숫자형으로 변경 못함
alter table DEPT_CP ALTER column DEPT_ID type numeric;

































