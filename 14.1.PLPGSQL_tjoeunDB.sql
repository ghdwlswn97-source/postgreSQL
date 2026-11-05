/*
 <PL/pgSQL>
 Procedural Language / PostgreSQL
 : PostgreSQL에서 사용하는 절차적 프로그래밍 언어
 	일반 sql문에 프로그래밍의 기능을 추가한 언어
 	
 	* 주요 기능
 	  1) 변수 선언
 	  2) 조건문(IF, CASE)
 	  3) 반복문(LOOP, WHILE, FOR)
 	  4) 예외처리(EXCEPTION)
 	  5) 함수 및 프로시저 작성
 	  
 	 * PL / pgSQL 기본구조
 	 
 	   DO $$		-- DO는 익명 블록을 즉시 실행할 때 사용
 	   DECLARE
 	   	-- 변수 선언 영역
 	   BEGIN
 	   	-- 실행할 SQL및 PL/pgSQL 구문
 	   [EXCEPTION]
 	   	-- 에외 처리 영억
 	   
 	   
 	   END $$;
 	   
 	   * 실행방법 : 익명블로(일회성 작업 적합)
 	   DO $$		
 	   DECLARE
 	   	-- 변수 선언 영역
 	   BEGIN
 	   	-- 실행할 SQL및 PL/pgSQL 구문
 	   [EXCEPTION]
 	   	-- 에외 처리 영억
 	   END $$;
 	   
 	   * 실행방법 2 : FUNCTION 또는 PROCEDUTE 생성
 	     >> FUNCTION 생성 및 실행
	 	     CREATE [OR REPLACE] FUNCTION 함수명()
	 	     RETURN VOID
	 	     AS %%
	 	     BEGIN
	 	     	-- 실행할 SQL 및 PL/pgSQL 구문
	 	     END;
	 	     $$ LANGUAGE plpgsql;
	 	     
	 	     실행시 : select 함수명();
 	     
 	     >> PROCEDURE생성 및 실행(RETURN 불필요)
 	     	CREATE [OR REPLACE] PROCEDURE 프로시저명()
 	     	AS $$
 	     	BEGIN;
 	     		-- 실행할 SQL 및 PL/pgSQL 구문
 	     	END;
*/
do $$
begin
	raise notice 'HELLO POSTGRESQL';
end;
$$

/*
 1. DECLARE 선언부
 	변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
 	일반타입 변수, 레퍼런스타입 변수, ROW타입 변수
 	
 	1.1) 일반타입 변수 선언 및 초기화
 		[표현식] 
 		변수명 [CONSTANT] 자료형 [:=값];
 * 
 * */






























