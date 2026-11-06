/*
	<TRIGGER>
	특정 테이블에 INSERT, UPDATE, DELETE등의 DML문에 의해 이벤트(변경사항) 발생시 자동으로 실행되는 객체
	자동으로 매번 실행할 내용을 미리 정의해 둘 수 있는 객체
	
	EX)
	회원 탈퇴시 탈퇴 회원 테이블에 자동으로 데이터 보관
	상품 입고시 재고수량 자동 증가
	상품 출고시 재고수량 자동 감소
	신고 횟수가 일정 기준을 넘으면 블랙리스트에 등록
	
	* 트리거 종류
		- 실행 시기에 따른 분류
		  > BEFORE TRIGGER : 명시한 테이블에 이벤트가 발생되기 전에 트리거 실행
		  > AFTER TRIGGER : 명시한 테이블에 이벤트가 발생한 후에 트리거 실행
		  > INSTEAD OF TRIGGER : 원래 작업 대신 트리거 실행(주로 VIEW)
		  
		- 실행 단위에 따른 분류
			> STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 하나당 한번 실행
			> ROW TRIGGER(행 트리거) : 영향을 받는 각 행마다 한번 실행
									(FOR EACH ROW 옵션 기술해야됨)
				 * old와 new											 
					 이벤트				old						new
					----------------------------------------------------------
					insert				사용불가				새로 삽입되는 데이터
					update				변경전 데이터			변경후 데이터
					delete				삭제되는 데이터			사용불가	  
  
	* 트리거 생성 방식
		1. 트리거 실행 함수 생성
			CREATE [OR REPLACE] FUNCTION 함수명()
			RETURN TRIGGER AS $$
			BEGIN
				실행내용
				RETURN NEW;
			[EXCEPTION]
			END;
			$$ LANGUAGE plpgsql;
			
		2. 트리거 생성
			CREATE [OR REPLACE] TRIGGER 트리거명
			BEFORE|AFTER  INSERT|UPDATE|DELETE ON 테이블명
			[FOR EACH ROW]
			EXECUTE FUNCTION 함수명();		  
		  
	* 트리거 삭제
	  DROP TRIGGER 트리거명 ON 테이블명;		  
*/	  
-- 1) 트리거 함수 생성
create function FN_TRG_01()
returns trigger as $$
begin 
	raise notice '신입사원님 환영합니다';
	return new;
end;
$$ language PLPGSQL;

-- 2) 트리거 바인딩
create trigger TRG_01
after insert on EMPLOYEE
for each row
execute function FN_TRG_01();

insert into EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
values ('500', '최미소','111111-1111111','J1',CURRENT_DATE);

insert into EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
values ('501', '박소미','111111-1111112','J2',CURRENT_DATE);

--==========================================================
-- 1. 회원탈퇴시 자동 백업
-- 회원테이블과 탈퇴회원을 넣을 테이블 생성
create table MEM(
	MEM_ID numeric,
	MEM_NAME VARCHAR(20),
	HIRE_DATE DATE
);

create table MEM_OUT(
	MEM_ID numeric,
	MEM_NAME VARCHAR(20),
	OUT_DATE DATE
);

insert into MEM VALUES(100, '김철수', '2025-01-20');
insert into MEM VALUES(101, '박철수', '2024-11-20');
insert into MEM VALUES(102, '이철수', '2023-01-21');

-- 트리거 실행 함수 정의 
create or REPLACE function FN_MEM_DELETE()
returnS trigger as $$
begin 
	insert into MEM_OUT
	VALUES(old.MEM_ID, old.MEM_NAME, CURRENT_DATE);
	return old;
end;
$$ language PLPGSQL;

-- 트리거 생성
create trigger TRG_MEM_DELETE
before delete
on MEM
for each row 
execute function FN_MEM_DELETE();

delete from MEM where MEM_ID=100;

--============================================
-- 2. 상품입고 및 출고가 되면 재고수량 자동 변경
-- 상품테이블(재고수량), 입고테이블, 출고테이블
create table TB_PRODUCT(
	PCODE numeric primary key, 
	PNAME VARCHAR(30) not null,
	BRAND VARCHAR(30) not null,
	STOCK_QUANT numeric default 0
);

-- 상품번호 시퀀스
create sequence SEQ_PCODE
start with 200
increment by 5;

-- 데이터 추가
insert into TB_PRODUCT VALUES(NEXTVAL('SEQ_PCODE'), '갤럭시50', '삼성', default);
insert into TB_PRODUCT VALUES(NEXTVAL('SEQ_PCODE'), '아이폰20', 'APPLE', 10);
insert into TB_PRODUCT VALUES(NEXTVAL('SEQ_PCODE'), '노트40', '샤오미', 20);

select * from TB_PRODUCT;

-- 2. 상품입고 테이블
create table TB_PROSTOCK(
	TCODE numeric primary key,
	PCODE numeric references TB_PRODUCT,
	TDATE DATE,
	STOCK_COUNT numeric not null,
	STOCK_PRICE numeric not NULL
);

-- 시퀀스
create sequence SEQ_TCODE;

-- 3. 판매테이블
create table TB_PROSALE(
	SCODE numeric primary key,
	PCODE numeric references TB_PRODUCT,
	SDATE date,
	SALE_COUNT numeric not null,
	SALE_PRICE numeric not NULL
);

create sequence SEQ_SCODE;

-- 200번 상품이 오늘 날짜로 10개 입고
insert into tb_prostock 
VALUES(NEXTVAL('SEQ_TCODE'), 200, CURRENT_DATE, 10, 2000000);

update tb_product 
set STOCK_QUANT= STOCK_QUANT+10
where PCODE = 200;

-- 입고 테이블(tb_product)에 입고 되었을 때 트리거 정의
-- 함수정의
create function FN_TRG_STOCK()
returns trigger 
as $$
begin
	update tb_product
	set STOCK_QUANT= STOCK_QUANT+new.STOCK_COUNT
	where PCODE = new.PCODE;
	return new;
end;
$$ language PLPGSQL;

-- 트리거생성
create trigger TRG_STOCK
after insert on TB_PROSTOCK
for each row
execute function FN_TRG_STOCK();

insert into TB_PROSTOCK
VALUES(NEXTVAL('SEQ_TCODE'), 205, CURRENT_DATE, 5,1500000);

insert into TB_PROSTOCK
VALUES(NEXTVAL('SEQ_TCODE'), 210, CURRENT_DATE, 100,2500000);


-- 판매
create function FN_TRG_PROSALE()
return trigger
as $$
begin
	update TB_PROSALE
	set SALE_COUNT = STOCK_QUANT-new.SALE_COUNT
	where PCODE =new.PCODE;
	return new;
end;
$$ language PLPGSQL;

create trigger TRG_PROSALE
after insert on TB_PROSALE
for each row
EXECUTE FUNCTION FN_TRG_PROSALE();


		  
		  
		  
