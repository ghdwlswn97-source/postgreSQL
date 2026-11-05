/*
 <SEQUENCE>
 자동으로 번호 발생시켜주는 역할을 하는 객체
 정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
 
 EX) 회원번호, 사원번호, 게시글번호,...
 
 1. SEQUENCE 생성
 	[표현식]
 	CREATE SEQUENCE 시퀀스명
 	[START WITN 시작숫자]			-> 처음 발생시킬 시작값 지정(기본값 1)
 	[INCREAMENT BY 증가값]		-> 몇씩 증가시킬것인지(기본값 1)
 	[MAXVALUE 숫자]				-> 최대값 지정(기본값 무지큼)
 	[MINVALUE 숫자]				-> 최소값 지정(기본값 1)
 	[CYCLE | NO CYCLE]			-> 값 순환 여부 지정(기본값 NO CYCLE)
 	[CACHE 미리 만들어둘번호의개수]	-> 미리 확보할 시퀀스 번호 개수

 	테이블명 : TB_
 	뷰명 : VW_
 	시퀀스명 : SEQ_
 	트리거명 : TRG_
*/
create sequence SEQ_TEST;

create sequence SEQ_EMPNO
start with 300
increment by 5
maxvalue 310
no cycle
cache 1;
































