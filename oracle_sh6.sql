------------------------------------------------------
-- Top-N 분석
------------------------------------------------------
-- 특정 컬럼값 기준으로 가장 큰(작은) n개의 값을 질의
-- ex)
-- 급여 제일 많이 받는 사원 5명 조회
-- 이번달 가장 많이 팔린 상품 3
-- 좋아요를 가장 많이 받은 게시글 10개

-- rowid
-- 테이블 특정 레코드(행)을 가리키는 논리적 주소값(식별값)
select
    rowid
    , e.*
from
    employee e
where
    rowid = 'AAASs7AAHAAAAFkAAG';

-- rownum
-- 각행에 대한 순서(번호)
-- result set이 만들어질때 순서대로 부여됨. 임의로 변경을 불가
-- inline view 또는 where절 사용시 새로 부여
select
    rownum
    , e.*
from
    employee e
where
    dept_code = 'D5';
    
-- 급여 Top-5 조회
select
    rownum
    , e.*
from (
            select
                emp_name
                , salary
            from
                employee
            order by
                salary desc
        ) e
where
    rownum between 1 and 5;

-- D5부서원 중에 급여 top3
select
    rownum
    , e.*
from (
        select
            emp_name
            , dept_code
            , salary
        from
          employee
        order by
            salary desc
        ) e
where
    dept_code = 'D5'
    and rownum between 1 and 3;

-- 부서별 급여 평균 top3 (부서코드, 부서명, 급여평균)
-- join사용
select
    rownum
    , ee.*
from (
        select
            e.dept_code 부서코드
            , d.dept_title
            , floor(avg(salary))
        from
            employee e join department d
                on e.dept_code = d.dept_id
        group by
            e.dept_code, d.dept_title
        order by
            3 desc
        ) ee
where
    rownum  between 1 and 3;

-- 스칼라 서브쿼리 사용
select
    rownum
    , ee.*
from (
        select
            dept_code 부서코드
            , (select dept_title from department where dept_id = e.dept_code)부서명
            , floor(avg(salary))
        from
            employee e
        group by
            dept_code
        order by
            3 desc
        ) ee
where
    rownum  between 1 and 3;

-- offset이 있는 랭킹 구하기
-- 급여 Top-n 6~10위 구하기
-- rownum은 from/where절이 끝난 이후 완벽히 부여된다.
-- where절에서 1부터 순차적인 접근은 허용.
-- offset이 있는 경우, inline view를 한번 더 사용해야 한다.
select
    *
from (
        select
            rownum rnum
            , e.*
        from (
                select
                    emp_name
                    , salary
                from
                    employee
                order by
                    salary desc
                ) e
        )
where
    rnum between 6 and 10;
    
-- with
-- 서브쿼리의 이름을 붙여서 하위에서 참조하는 문법
-- 입사일순 Top-5

with emp_by_hire_date
as (
    select
        emp_name
        , hire_date
    from
        employee
    order by
        hire_date
)
select
    *
from
    emp_by_hire_date
where
    rownum between 1 and 10;
    
-- 급여 Top-n with절로
with emp_by_salary_avg
as (
        select
            dept_code 부서코드
            , (select dept_title from department where dept_id = e.dept_code)부서명
            , floor(avg(salary))
        from
            employee e
        group by
            dept_code
        order by
            3 desc
        ) 
select
    *
from
    emp_by_salary_avg
where
    rownum  between 1 and 3;
    
-------------------------------------------------------
-- WINDOW FUNCTION
-------------------------------------------------------
-- 행과 행간의 관계를 쉽게 정의해주는 sql 표준함수
-- select절에서만 사용가능

-- 순위/집계/순서/비율/통계관련 함수 지원
-- 순서 max() keep(), min() keep()

-- 문법
-- 윈도우 함수 (arguments) over ([partition by절][order by 절][windowing 절])
-- args : 윈도우함수의 인자로 0 ~ n개의 컬럼 제공
-- over절 : 행 그룹핑, 순서, 대상행등을 지정
-- * partition by절 : 윈도우 함수의 group by
-- * order by절 : 순서
-- * windowing절 : 대상행을 지정

-- 순위관련 윈도우 함수
-- rank() over()
-- 행간의 순위를 지정. 중복된 값이 있는 경우, 그 다음 순위는 건너뛴다.
select
    emp_name
    , salary
    , rank() over(order by salary desc) salary_rank
from
    employee;
    
-- dense_rank() over()
-- 행간의 순위를 지정. 중복된 값이 있어도 순위를 건너뛰지 않는다.
select
    emp_name
    , salary
    , dense_rank() over(order by salary desc) salary_rank
from
    employee;

-- row_number() over()
-- 행간의 순위를 지정. 중복된 값이 있어도 고유한 순위를 부여한다.
select
    emp_name
    , salary
    , row_number() over(order by salary desc) salary_rank
from
    employee;
    
-- top-n 분석에 활용
select
    *
from (
        select
            emp_name
            , salary
            , dense_rank() over(order by salary desc) rnum
        from
            employee
)
where
    rnum between 6 and 10;
    
-- 입사일 순으로 top10 조회 (순위, 사번, 사원명, 입사일)
select
    *
from (
        select
            rank() over(order by hire_date asc) 순위
            , emp_id 사번
            , emp_name 사원명
            , hire_date 입사일
        from
            employee
)
where
    "순위" <= 10;
    
-- 그룹핑 후에 순위부여
-- 부서별 급여 순위
select
    emp_name
    , dept_code
    , salary
    , rank () over(partition by dept_code order by salary desc) rank_sal_by_dept
    , rank () over(order by salary desc) rank_sal
from
    employee
order by
    dept_code;
    
-- 직급별 최고급여 받는 사원 조회
select
    *
from (
        select
            emp_id 사번
            , emp_name 사원명
            , salary 급여
            , job_code 직급
            , rank() over(partition by job_code order by salary desc) 최고급여
        from
            employee e
        order by
            3 asc
        )
where
    "최고급여" <= 1;
    
-- 집계함수
-- 일반 그룹함수와 동일한 이름으로 윈도우함수 지원.
-- 그룹함수 결과를 일반컬럼과 동시에 조회.

-- sum() over()
select
    emp_name
    , salary
    , sum(salary) over() "전체급여"
    , sum(salary) over(order by salary desc) "급여누계"
from
    employee;
    
select
    emp_name
    , dept_code
    , salary
    , sum(salary) over(partition by dept_code) "부서별 급여합계"
    , sum(salary) over(partition by dept_code order by emp_name) "부서별 급여누계"
from
    employee;
    
-- 지난 3개월간의 제품 판매데이터
-- 판매월, 상품명, 판매수량, 제품별 누계, 3개월 전체 누계
with sum_3month
as (
    select 
        p_name
        , p_count
        , sale_date 
    from 
        tb_sales
    union all
    select 
        p_name
        , p_count
        , sale_date 
    from 
        tb_sales_2308
    union all
    select 
        p_name
        , p_count
        , sale_date 
    from 
        tb_sales_2309
    order by
         sale_date desc
     )
select
    extract(year from sale_date) || lpad(extract(month from sale_date), 2, 0) "판매월"
    , p_name 상품명
    , p_count 판매수량
    , sum(p_count) over(partition by p_name order by p_name,sale_date) "제품별 누계"
    , sum(p_count) over(order by p_name, sale_date) "3개월 전체 누계"
from
    sum_3month;
    
-- avg() over()
-- count() over()
-- min() over()
-- max() over()
select
    emp_name
    , salary
    , floor(avg(salary) over()) "전체급여평균"
    , salary - floor(avg(salary) over()) "평균급여와의 차"
    , count(*) over() "전체사원수"
    , min(salary) over() "최소급여"
    , max(salary) over() "최대급여"
from
    employee;
    
-- 비율함수
-- ratio_to_report() over()
-- 전체합중 차지하는 비율 반환
select
    emp_name
    , salary
    , round (ratio_to_report(salary) over(), 2) "급여총합 대비 비율"
    , round(salary / sum(salary) over(), 2) "급여총합 대비 비율"
from
    employee;
    
--======================================================
-- DML
--======================================================
-- Data Manipulation Language
-- 데이터 조작어
-- 테이블 데이터에 대해 CRUD 명령어
-- (Create, Read, Update, Delete 데이터에 대한 생성, 조회, 수정, 삭제)

-- insert
-- select DQL
-- update
-- delete

-------------------------------------------------------------------------
-- INSERT
-------------------------------------------------------------------------
-- 테이블에 데이터를 추가하는 명령
-- 행단위 작성, 명령에 성공했다면, 테이블 행이 증가함.

-- 문법1. insert into 테이블명 values(컬럼값1, 컬럼값2, ...)
--  - 테이블 선언된 구조와 같이 순서, 개수를 모두 작성


-- 문법2. insert into 테이블명 (컬럼명1, 컬럼명2, ...) values(컬럼값1, 컬럼값2, ...)
--  - 데이터를 추가할 컬럼만 작성가능
--  - 생략된 컬럼은 기본값 처리 (기본값이 지정되지 않은 not null컬럼은 생략할 수 없음.)

create table sample (
        a number
        , b varchar2(20) default 'ㅋㅋㅋ'
        , c varchar2(20) not null
        , d date default sysdate not null
        );

desc sample;

-- 문법1.
insert into sample values(123, '안녕', '잘가', to_date('2023/12/25', 'yyyy/mm/dd'));
insert into sample values(123, '안녕', '잘가'); -- SQL 오류 : ORA-00947: 값의 수가 충분하지 않습니다.
insert into sample values(456,default, 'ㅎㅎㅎ',default);

-- 문법2.
-- 생략가능한 컬럼 : nullable 컬럼, 기본값 지정이 된 not null 컬럼
-- 생략불가한 컬럼 : 기본값 지정이 안된 not null 컬럼
insert into sample (c) values ('캬캬캬');
insert into sample (a, b) values (789,'ㅎㅎㅎ'); -- ORA-01400: null을 ("SH"."SAMPLE"."C")안에 삽입할 수 없습니다.
insert into sample (c, b, a) values ('ccc', 'bbb', 999);

select * from sample;

--drop table employee_ex;

-- emp연습테이블 employee_ex
create table employee_ex
as
select * from employee;

-- subquery를 이용한 create table은 not null을 제외한 제약조건과 기본값 설정등이 모두 제거된다.
-- 기본키, 외래키, 유니크, 체크, 기본값을 추가

alter table employee_ex
add constraints pk_employee_ex primary key(emp_id) -- 기본키
add constraints pk_employee_ex_emp_no unique(emp_no) -- 유니크(중복허용x)
add constraints fk_employee_ex_dept_code foreign key(dept_code) references department(dept_id) -- 외래키 (참조테이블의 값만 사용가능)
add constraints fk_employee_ex_job_code foreign key(job_code) references job(job_code)
add constraints fk_employee_ex_manager_id foreign key(manager_id) references employee_ex(emp_id) 
add constraints ck_employee_ex_quit_yn check(quit_yn in ('Y', 'N')) -- 체크 (도메인 지정)
modify quit_yn default 'N'
modify hire_date default sysdate;

select * from employee_ex;

-- 문법1. 추가
insert into employee_ex values('301', '함지민', '781020-2123453', 'hamham@kh.or.kr', '01012343334', 'D1', 'J4', 'S3', 4300000, 0.2, '200', default, default, default);
-- 문법2. 추가
insert into employee_ex(emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id)
        values('302', '장채현', '901123-1080503','jang_ch@kh.or.kr','01033334444','D2','J7','S3',3500000, null, '201');
        
-------------------------------------------------------------------
-- Data Migration
-------------------------------------------------------------------
-- 기존 데이터를 다른 테이블로 이전하거나, 합치는 작업을 지원하는 insert문이있다.

-- subquery를 이용한 insert
-- 사원 간단보기 테이블 생성
create table emp_simple(
        emp_id varchar2(3)
        , emp_name varchar2(50)
        , job_name varchar2(50)
        , dept_title varchar2(50)      
);

insert into emp_simple (
        select
            emp_id
            , emp_name
            , (select job_name from job where job_code = e.job_code) job_code
            , (select dept_title from department where dept_id = e.dept_code) dept_title
        from
            employee e
);

select * from emp_simple;

-- insert all
-- 두 개 이상의 테이블에 데이터 이전시 적합
-- 입사일을 관리하는 테이블 emp_hire_date
-- 사원/관리자 정보를 확인하는 테이블 emp_manager

-- 테이블 생성시 기존테이블 구조만 복사(데이터추가 안함)
create table emp_hire_date
as
select
    emp_id, emp_name, hire_date
from
    employee
where
    1 = 2; -- false

select * from emp_hire_date;
desc emp_hire_date;

create table emp_manager
as
select
    emp_id, emp_name, manager_id, emp_name "MANAGER_NAME"
from
    employee
where
    1 = 2; -- false

select * from emp_manager;
desc emp_manager;

alter table emp_manager
modify manager_name null;

-- 기존 employee 데이터를 emp_hire_date, emp_manager로 각각 이전
insert all
        into emp_hire_date values (emp_id, emp_name, hire_date)
        into emp_manager values (emp_id, emp_name, manager_id, manager_name)

select
    e.*
    , (select emp_name from employee where emp_id = e.manager_id) manager_name
from
    employee e;

select * from emp_hire_date;
select * from emp_manager;

-------------------------------------------------------
-- UPDATE
-------------------------------------------------------
-- 테이블 데이터(행)를 수정
-- where절에 지정된 행의 컬럼 값을 수정.
-- where절 지정되지 않으면 모든 행의 컬럼값을 수정.
select * from employee_ex;

update
    employee_ex
set
    dept_code = 'D2', job_code = 'J4'
where
    emp_id = 301;

rollback; -- 마지막 commit시점으로 변경. undo가 아님
commit;

-- where절 작성하지 않으면??
update
    employee_ex
set
    salary = 5000000;
    
-- 장채현 사원의 급여를 500000원 인상하기
update
    employee_ex
set
    salary = salary + 500000
where
    emp_name = '장채현';
    
-- 임시환 사원의 직급을 과장, 부서를 해외영업3부로 변경 (서브쿼리)
update
    employee_ex
set
    job_code = (select job_code from job where job_name = '과장')
    , dept_code = (select dept_id from department where dept_title = '해외영업3부')
where
    emp_name = '임시환';
    
-------------------------------------------------------
-- DELETE
-------------------------------------------------------
-- 테이블 행 삭제하는 명령어.
-- 성공시 행의 수가 줄어든다.
-- where절을 사용하지 않으면, 모든 행이 삭제된다.

delete from
        employee_ex
where
        emp_name = '장채현';
        
-------------------------------------------------------
-- TRUNCATE
-------------------------------------------------------
-- 테이블 전체행을 잘라내는(삭제) 하는 DDL
-- 실행 즉시 db에 반영. 취소 불가능(rollback없음)
-- 실행속도 빠르다. (DML 처리시 before image 작업이 없음)

delete from employee_ex;

truncate table employee_ex;

select * from employee_ex;
rollback;

-- employee에서 다시 데이터 복사해오기 (위에 있음)
insert into employee_ex(
    select * from employee
    );
    
-- DML/DDL 혼용시 주의
-- DDL 실행시, 해당 세션의 모든 작업내용은 함께 커밋된다.
create table tb_abc(
        id number
);
insert into tb_abc values(1);
insert into tb_abc values(2);
insert into tb_abc values(3);

delete from tb_abc where id = 3;

select * from tb_abc;

rollback;

create table tb_xyz (
    id number
    );
    
    
----------------------------------------------
-- DML 데이터 Migration 실습문제
----------------------------------------------
--# 사원테이블 분리하기
--
--테이블 관련 정책이 변경되었다. 
--
--EMPLOYEE 테이블의 구조를 복사하여 테이블 EMP_OLD와 EMP_NEW를 생성하세요
--
--- `EMP_OLD` 2000년 1월 1일 이전 입사자의 데이터만 관리하는 테이블
--- `EMP_NEW` 2000년 1월 1일 이후 입사자의 데이터만 관리하는 테이블
--- 두 테이블의 구조는 사번,이름,입사일,급여 컬럼을 각각 가지고 있다.
--- `EMPLOYEE`로 부터 데이터가 없이 구조만 복사해서 생성한다.
--- `INSERT ALL` 문법을 사용해 `EMP_OLD` `EMP_NEW`테이블에 데이터 이전.
--- 입사일 기준에 따라 분기 처리할 것.
--    
--    ```sql
--    insert all
--    	when 조건1 then into 테이블명 values (컬럼명, ...)
--    	when 조건2 then into 테이블명 values (컬럼명, ...)
--    서브쿼리
--    ```
-- 리셋 버튼
--drop table emp_old;
--drop table emp_new;

-- 1. employee로 부터 데이터가 없이 구조만 복사해서 생성한다.
create table emp_old
as
select
    emp_id, emp_name, hire_date, salary
from
    employee
where
    1 = 2;

create table emp_new
as
select
    emp_id, emp_name, hire_date, salary
from
    employee
where
    1 = 2;

-- 2. insert all 문법을 사용해 emp_old, emp_new 테이블에 데이터 이전. (조건에 맞게)   
insert all
        when  to_char(hire_date,'yyyymmdd') < 20000101 then into emp_old values (emp_id, emp_name, hire_date,salary)
         when  to_char(hire_date,'yyyymmdd') > 20000101 then into emp_new values (emp_id, emp_name, hire_date,salary)
select
    *
from
    employee;

-- 3. 테이블 확인
select * from emp_old;
select * from emp_new;

-----------------------------------------------------------------
-- DQL 종합 실습문제@sh
-----------------------------------------------------------------

-- 1. 기술 지원부에 속한 사람들의 사람의 이름, 부서코드, 급여를 출력하시오
select
    emp_name 이름
    , dept_code 부서코드
    , salary 급여
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    dept_title = '기술지원부';
    
-- 2. 기술 지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름, 부서코드, 급여를 출력하시오
select
    사원명
    , 부서코드
    , 급여
from (
        select
            e.emp_name 사원명
            , e.dept_code 부서코드
            , e.salary 급여
            , d.dept_title 부서명
        from
            employee e join department d
                on e.dept_code = d.dept_id
        where
            quit_yn = 'N'
        order by
            salary desc
        ) e
where
    부서명 = '기술지원부'
    and rownum = 1;

-- 3. 매니저가 있는 사원중에 월급이 전체사원 평균보다 많은 사원의 사번, 이름, 매니저 이름, 월급을 구하시오
--  a. JOIN을 이용하시오
select
    e1.emp_id 사번
    , e1.emp_name 이름
    , e2.emp_name as "매니저 이름"
    , e1.salary 월급
from
    employee e1 join employee e2
        on e1.manager_id = e2.emp_id
where
    e1.manager_id is not null
    and e1.salary > (select avg(salary) from employee);
--  b. JOIN하지 않고, 스칼라 상관쿼리(select)를 이용하기
select
    e1.emp_id 사번
    , e1.emp_name 이름
    , (select emp_name from employee where emp_id = e1.manager_id) as "매니저 이름"
    , e1.salary 월급
from
    employee e1
where
    e1.manager_id is not null
    and e1.salary > (select avg(salary) from employee);
    
-- 4. 같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회
select
    이름
    , 직급코드
    , 급여
    , 급여등급
from (
        select
            e.emp_name 이름
            , job_code 직급코드
            , salary 급여
            , sal_level 급여등급
            , floor(avg(salary) over(partition by job_code)) "직급별 급여평균"
        from
            employee e
) e
where
    급여 >= "직급별 급여평균";    
   
-- 5. 부서별 평균 급여가 3000000이상인 부서명, 평균 급여 조회
-- 단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴' 처리
select
    부서명
    , "부서별 평균 급여"
from (
        select
            nvl((select dept_title from department where dept_id = e.dept_code), '인턴') 부서명
            , floor(avg(salary) over(partition by dept_code)) "부서별 평균 급여"
            , floor(avg(salary) over()) "전체 평균 급여"
        from
            employee e
        )
where
    "부서별 평균 급여" > 3000000;

-- 6. 직급의 연봉 평균보다 적게 받는 여자사원의 사원명, 직급명, 부서명, 연봉을 이름 오름차순으로 조회하시오.
select
    사원명
    , 직급명
    , 부서명
    , 연봉
from (
        select
            emp_name 사원명
            , (select job_name from job where job_code = e.job_code) 직급명
            , (select dept_title from department where dept_id = e.dept_code) 부서명
            , (salary + (salary * nvl(bonus,0))) * 12 연봉
            , floor(avg((salary + (salary * nvl(bonus,0))) * 12) over(partition by job_code)) "직급의 연봉 평균"
        from
            employee e
        where
            substr(emp_no, 8, 1) in ('2','4')
)
where
    "연봉" < "직급의 연봉 평균"
order by
    사원명 asc;
    
-- 7. 다음 도서목록 테이블을 생성하고, 공저인 도서만 출력하세요.
-- (공저 : 두명 이상의 작가가 함께 쓴 도서)
create table tbl_books (
	book_title varchar2(50)
	,author varchar2(50)
	,loyalty number(5)
);

insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);
insert into tbl_books values ('별의 하루', '대북혼', 300);
commit;
select * from tbl_books;

select
    *
from (
        select
            book_title 도서명
            , author 작가
            , loyalty 로열티
            , count(*)over(partition by book_title) 공저
        from
            tbl_books
)
where
    공저 >= 2;
    

commit;
   
select * from employee; -- 24
select * from department; --9
select * from job;
select* from location;
select * from nation;
select * from sal_grade;

select 
    rownum
    , e.emp_name
    , e.salary
from
    employee e
where
    rownum <= 3
order by 1 asc;

select * from employee;

select
    rownum
    , e.emp_name
    , e.salary
from (
            select
                emp_name
                , salary
            from
                employee
            order by
                salary desc
        ) e
where
    rownum <= 3;
    
select
    emp_no
    , emp_name
    , dept_code
    , dept_title
from
    employee e join department d
        on e.dept_code = d.dept_id;
        
select distinct
    dept_code as 부서
    , emp_name
from
    employee;
    
select
    emp_name
    , email
from
    employee
    email like '%@_%' escape '@';
where

select * from employee;

select emp_id from employee order by 1 asc;