--1번
select department_name as "학과 명", category as "계열"
from tb_department;

--2번
select department_name||' 정원은' ||capacity||'명 입니다' as "학과별 정원"
from tb_department;

--3번
select student_name
from tb_student
where student_no in ('A513079','A513090', 'A513110','A513091', 'A513119');

--4번
select department_name, category
from tb_department 
where capacity between 20 and 30;

--5번
select professor_name
from tb_professor 
where department_no is NULL;

-- 6번
select student_name
from tb_student
where department_no is null;

--7번
select class_no
from tb_class
where preattending_class_no is not null;

--8번
select category
from tb_department;

--9번
--select student_no, student_name, student_ssn
--from tb_student 
--where entrance_date like '2002%' and student_address like '%전주%';

