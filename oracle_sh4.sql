-- 2023-10-20 (금요일) 4일차

-------------------------------------------------
-- NON-EQUI JOIN
-------------------------------------------------
-- 조인 기준 작성이 = 연산자(!=, >, <, >=, <=, between and, is null)를 사용한 경우

-- 사원 테이블의 급여레벨을 지정하기
-- (employee.sal_level 컬럼이 존재하지 않는다고 가정)
select * from employee;
select * from sal_grade;
    
-- employee.salary가 sal_grade의 범위와 일치(동등비교 연산 아님)하면 행을 연결
select
    e.emp_name,
    e.salary,
    s.sal_level,
    s.min_sal,
    s.max_sal
from
    employee e join sal_grade s
        on e.salary between s.min_sal and s.max_sal;
        
-- emplotee - department
select
    *
    from
        employee e join department d
            on e.dept_code != d.dept_id;
            
-- employee - employee
select
    *
from
    employee e1 join employee e2
        on e1.salary > e2.salary;
 
 --==================================================
 -- SET OPERATOR
 --==================================================
 -- 집합연산. 열과 열을 합쳐서 relation을 생성하는 문법
 -- 열의 개수가 동일해야 한다.
 -- 대응되는 열의 자료형이 상호호환 되어야 한다. (문자형끼리, 숫자형끼리, 날짜형끼리 합해질 수 있다.)
 
 -- 구분
 -- 1. union | union all
 -- 2. intersect
 -- 3. minus
 
----------------------------------------------------------------
-- UNION | UNION ALL
----------------------------------------------------------------
-- 합집합
-- union : 합집합, 중복을 제거.
-- union all : 합집합. 이어붙이기만 지원

-- 1. D5부서원 결과집합
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    dept_code = 'D5';
    
-- 2. 급여가 300만원보다 많은 사원 결과집합
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    salary > 3000000;
    
-- union all
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    dept_code = 'D5'
union all
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    salary > 3000000; -- 15행
    
-- union
-- 열의 수가 다른경우 : ORA-01789 : 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
-- 대응하는 열의 자료형이 다른경우 : ORA-01790 : 대응하는 식과 같은 데이터 유형이어야 합니다.
-- 컬럼명이 다른 경우 첫번째 결과집합의 컬럼명사용.
-- order by는 마지막에 한번만 사용
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    dept_code = 'D5'
union
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    salary > 3000000 -- 13행
order by
    emp_id; -- order by는 마지막에 한번만 사용가능
    
--------------------------------------------------------
-- INTERSECT
--------------------------------------------------------
-- 교집합
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    dept_code = 'D5'
intersect
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    salary > 3000000; -- 중복행 찾는거 2행
    
---------------------------------------------------
-- MINUS
---------------------------------------------------
-- 차집합
-- A - B
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    dept_code = 'D5'
minus
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    salary > 3000000; 
-- B - A
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    salary > 3000000
minus
select
    emp_id, emp_name, dept_code, salary
from
    employee
where
    dept_code = 'D5';
    

-- 과자 판매 데이터 관리
create table tb_sales (
    p_name varchar2(100),
    p_count number,
    sale_date date
    );
-- 두달전 판매 데이터
insert into tb_sales values('무뚝뚝 고구마칩', 10, '20230801');
insert into tb_sales values('꼬북칩', 15, '20230802');
insert into tb_sales values('맛동산', 20, '20230805');
insert into tb_sales values('감자깡', 15, '20230810');
insert into tb_sales values('쿠크다스', 7, '20230812');
insert into tb_sales values('무뚝뚝 고구마칩', 27, '20230820');
insert into tb_sales values('감자깡', 30, '20230825');
insert into tb_sales values('참크래커', 24, '20230826');
insert into tb_sales values('맛동산', 10, '20230829');
insert into tb_sales values('참크래커', 24, '20230831');
-- 한달전 판매 데이터
insert into tb_sales values('무뚝뚝 고구마칩', 10, '20230901');
insert into tb_sales values('꼬북칩', 15, '20230902');
insert into tb_sales values('맛동산', 20, '20230905');
insert into tb_sales values('감자깡', 15, '20230910');
insert into tb_sales values('쿠크다스', 7, '20230912');
insert into tb_sales values('무뚝뚝 고구마칩', 27, '20230920');
insert into tb_sales values('감자깡', 30, '20230925');
insert into tb_sales values('참크래커', 24, '20230926');
insert into tb_sales values('맛동산', 10, '20230929');
insert into tb_sales values('참크래커', 24, '20230930');
-- 이번달 판매 데이터
insert into tb_sales values('무뚝뚝 고구마칩', 10, '20231001');
insert into tb_sales values('꼬북칩', 15, '20231002');
insert into tb_sales values('맛동산', 20, '20231005');
insert into tb_sales values('감자깡', 15, '20231010');
insert into tb_sales values('쿠크다스', 7, '20231012');
insert into tb_sales values('무뚝뚝 고구마칩', 27, '20231020');
insert into tb_sales values('감자깡', 30, '20231025');
insert into tb_sales values('참크래커', 24, '20231026');
insert into tb_sales values('맛동산', 10, '20231029');
insert into tb_sales values('참크래커', 24, '20231030');

select * from tb_sales;
commit;

-- 이번달 판매데이터 조회
-- ex)
select
    *
from
    tb_sales
where
    (extract(month from sale_date) = extract(month from sysdate))
    and
    (extract(year from sale_date) = extract(year from sysdate));
    
-- ex2)
 select
    *
 from
    tb_sales
where
    to_char(sale_date, 'yyyy-mm') = to_char(sysdate, 'yyyy-mm');
-- 지난달 판매데이터 조회
-- ex)
select
    *
from
    tb_sales
where
    (extract(month from sale_date) = extract(month from sysdate)-1)
    and
    (extract(year from sale_date) = extract(year from add_months(sysdate, -1)));
 
-- ex2)
 select
    *
 from
    tb_sales
where
    to_char(sale_date, 'yyyy-mm') = to_char(add_months(sysdate, -1), 'yyyy-mm');

-- 두달전 판매데이터 조회
-- ex)
select
    *
from
    tb_sales
where
    (extract(month from sale_date) = extract(month from sysdate)-2)
    and
    (extract(year from sale_date) = extract(year from add_months(sysdate, -2)));
    
-- ex2)
 select
    *
 from
    tb_sales
where
    to_char(sale_date, 'yyyy-mm') = to_char(add_months(sysdate, -2), 'yyyy-mm');
    
-- 테이블 쪼개기
-- 이번달 데이터만 tb_sales에서 관리
-- 달이 바뀌면, 지난 달 데이터는 tb_sales_2310 테이블을 생성해서 데이터 이전

-- 두달전 데이터 이전
create table tb_sales_2308
as
 select
    *
 from
    tb_sales
where
    to_char(sale_date, 'yyyy-mm') = to_char(add_months(sysdate, -2), 'yyyy-mm');
    
select * from tb_sales_2308;

-- 지난달 데이터 이전
create table tb_sales_2309
as
 select
    *
 from
    tb_sales
where
    to_char(sale_date, 'yyyy-mm') = to_char(add_months(sysdate, -1), 'yyyy-mm');
    
select * from tb_sales_2309;

-- tb_sales에서 지난달 데이터 삭제
delete from
    tb_sales
where
    to_char(sale_date, 'yyyy-mm') != to_char(sysdate, 'yyyy-mm');
    
commit;

-- 지난 3개월 판매내역을 모두 출력하세요. (판매일 역순)   
-- *대신 컬럼명 명시 (별칭 쓰지 말기) - order by관련
select * from tb_sales
union all
select * from tb_sales_2308
union all
select * from tb_sales_2309
order by
     3 desc;
     
select p_name, p_count, sale_date from tb_sales
union all
select p_name, p_count, sale_date from tb_sales_2308
union all
select p_name, p_count, sale_date from tb_sales_2309
order by
     sale_date desc;
     
-- 지난 3개월간 제품별 판매총합 조회
-- 결과집합은 다시 하나의 테이블처럼 사용할 수 있다. (inline-view)
select
    p_name,
    sum(p_count)
from
    (
        select p_name, p_count, sale_date from tb_sales
        union all
        select p_name, p_count, sale_date from tb_sales_2308
        union all
        select p_name, p_count, sale_date from tb_sales_2309
        order by
         sale_date desc
    )
group by
    p_name
order by
    2 desc;

-- 월별 제품별 총 판매량을 조회하세요
select
    p_name,
    sum(p_count),
    lpad(to_char(sale_date, 'yyyy-mm'),50)
from
    (
        select p_name, p_count, sale_date from tb_sales
        union all
        select p_name, p_count, sale_date from tb_sales_2308
        union all
        select p_name, p_count, sale_date from tb_sales_2309
        order by
         sale_date desc
    )
group by
    p_name,
    (to_char(sale_date, 'yyyy-mm'))
order by
   3 desc, 2 desc;
   


