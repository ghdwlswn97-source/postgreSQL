--[DML]
--1. 과목유형 테이블(TB-CLASS-TYPE)에 아래와 같은 데이터를 입력하시오.
--번호, 유형이름
--01, 전공필수
--02, 전공선택
--03, 교양필수
--04, 교양선택
--05. 논문지도
create table TB_CLASS_type(
	NO varchar(5) primary KEY ,
	name varchar(10)
	);
insert into TB_CLASS_type values(01, '전공필수');
insert into TB_CLASS_type values(02, '전공선택');
insert into TB_CLASS_type values(03, '교양필수');
insert into TB_CLASS_type values(04, '교양선택');
insert into TB_CLASS_type values(05, '논문지도');

--2. 춘 기술대학교 학생들의 정보가 포합되어 있는 학생일반정보 테이를을 만들고자 한다.
--아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오)
--테이블이름
--TB_학생일반정보
--컬럼
--학번
--학생이름
--주소
create table tb_학생일반정보(학번, 학생이름, 주소)
as select STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
	from TB_STUDENT;

--3. 국어국문학과 학생들의 정보만이 포항되어 있는 학과정보 테이블을 만들고자 한다.
--아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (힌트 : 방법은 다양함. 소신껏작성하시오)
--테이블이름
--TB_국어국문학과
--컬럼
--학번
--학생이름
--출생년도 수 네자리 년도로 표기
--교수이름
create table TB_국어국문학과(학번, 학생이름, 출생년도, 교수이름)
as select S.STUDENT_NO, S.STUDENT_NAME
		, EXTRACT(year from TO_DATE(SUBSTR(S.STUDENT_SSN, 1, 2),'YY'))
		, P.PROFESSOR_NAME
from TB_STUDENT S
left join TB_PROFESSOR P on (S.COACH_PROFESSOR_NO= P.PROFESSOR_NO)
left join TB_DEPARTMENT D ON (D.DEPARTMENT_NO= S.DEPARTMENT_NO)
where DEPARTMENT_NAME = '국어국문학과';

--4. 현 학과들의 정원을 10% 증가시기게 되었다. 이에 사용할 SQL 문을 작성하시오. (단.
--반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)
update TB_DEPARTMENT
set CAPACITY = ROUND(CAPACITY*1.1);

--5. 학번 A413042인 박건우 학생의 주소가 •서울시 종로구 숭인동 181-21 •로 변경되었다고
--한다. 주소지를 정정하기 위해 사용할 SQL 문을 작성하시오.
update TB_STUDENT
set STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
where STUDENT_NO ='A413042';

select STUDENT_ADDRESS from tb_student 
where STUDENT_NO ='A413042';

--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로
--결정하였다. 이 내용을 반영할 적절한 SQL 문장을 작성하시오.
--(예. 8弼표-2124菂3 =〉 830530 )
update TB_STUDENT
set STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);
					
--7. 의학과 김명훈 학생은 2005년 1 학기에 자신이 수강한 •피부생리학 점수가
--잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인 받은 결과 해당
--과목의 학점을 3.5로 변경하기로 결정되었다. 적절한 SQL 문을 작성하시오.
update TB_GRADE
set POINT = 3.5
where STUDENT_NO =(select STUDENT_NO
					from TB_STUDENT 
					join tb_department USING(DEPARTMENT_NO)
					where STUDENT_NAME='김명훈'
					and DEPARTMENT_NAME = '의학과')
and TERM_NO = '200501'
and CLASS_NO =(select class_NO
				from TB_CLASS
				where CLASS_NAME='피부생리학');

--8. 성적 테이블(TB GRADE) 에서 휴학생들의 성적항목을 제거하시오.
delete from TB_GRADE
where STUDENT_NO IN (select student_no 
					from TB_STUDENT
					where ABSENCE_YN = 'Y');

select COUNT(*)
from TB_STUDENT
join TB_GRADE USING(STUDENT_NO)
group by absence_yn 
having ABSENCE_YN='Y';

