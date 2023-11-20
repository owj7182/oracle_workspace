-- 2023-10-26

--==========================================================
-- DATABASE OBJECT 1
--==========================================================
-- db를 효율적으로 운영하기 위해 미리 생성해둔 개체(구조)

select object_type from all_objects;

---------------------------------------------------------------------------
-- DATA DICTIONARY
---------------------------------------------------------------------------
-- db모든 객체에 대한 메타정보를 갖는 뷰
-- 관리자 소유이지만, 읽기권한 부여받아 사용
-- 사용자는 dd에 대해 쓰기 할 수 없다.
-- DDL등을 통해 객체의 정보를 변경하면, dd에는 자동으로 변경된 사항이 반영된다.

-- 3가지 구분
-- 1. user_xxx 자신이 생성한 객체에 대한 dd
-- 2. all_xxx user_xxx포함해서, 사용권한을 부여받은 객체에 대한 dd
-- 3. dba_xxx 관리자만 열람가능한 dd (db의 모든 정보를 열람가능)

select * from sh.employee;

-- 모든 dd 조회
select * from dict;

-- 소유한 테이블 조회
select * from user_tables;
select * from tabs; -- synonym user_tables에 대한 별칭
select * from tab; -- 간단버젼

-- 권한/롤 확인
select * from user_sys_privs;
select * from user_role_privs;

select * from role_sys_privs; -- 롤/권한 모두 조회

-- 제약조건 조회
select * from user_constraints;

-- 뷰
select * from user_views;
-- 인덱스
select * from user_indexes;
-- 시퀀스
select * from user_sequences;

-- all_xxxx
-- 자신이 소유한 객체와 사용권한을 부여받은 객체를 조회
select * from all_tables;

-- view
-- data dictionary는 모두 sys소유이며, 사용권한을 부여받아 읽기 가능
select * from all_views;
select * from all_views where owner = 'SYS' and view_name like 'USER_%';

-- dba_xxx
-- 관리자만 접근 가능
select * from dba_tables;

select * from dba_tables where owner = 'SH';



-- 사용자별 권한 확인
select * from dba_sys_privs;
select * from dba_sys_privs where grantee = 'SH';
select * from dba_role_privs where grantee = 'SH';

-- 테이블 관련 권한 확인
select * from dba_tab_privs;
select * from dba_tab_privs where owner = 'SH';

grant select, insert on sh.tbl_coffee to qwerty;

---------------------------------------------------------------------
-- STORED VIEW
---------------------------------------------------------------------
-- 하나 이상의 테이블에서 원하는 데이터를 선별해 새로운 가상 테이블을 생성
-- 실제 데이터를 가지고 있지 않으며, 실제 테이블에 대한 창구 역할.
-- view용량은 매우 작다.
-- inline view는 1회성인데 비해, stored view는 view객체를 저장해서 재사용이 가능.
-- create view권한 resource롤에 포함이 되어있지 않으므로, 별도로 권한부여 필요.
-- or replace 옵션 : 없으면 생성하고, 있으면 대체
-- (system계정) create view 권한 부여
grant create view to sh;

create or replace view view_emp
as
select
    e.*
    , trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12) age
    , decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
    , (select job_name from job where job_code = e.job_code) job_name
    , (select dept_title from department where dept_id = e.dept_code) dept_title
from
    employee e;
    
select * from view_emp;

-- DD에서 확인
select * from user_views;
    
-- qwerty에게 읽기 권한 부여
grant select on view_emp to qwerty;
-- qwerty에게 읽기 권환 회수
revoke select on view_emp from qwerty;

-- (employee_ex테이블)'D5'부서원의 사번, 사원명, 직급명, 급여, 입사일을 출력하는 view_emp_d5를 생성
create or replace view view_emp_d5
as
select
    emp_id 사번
    , emp_name 사원명
    , dept_code 부서코드
    , (select job_name from job where job_code = e. job_code) 직급명
    , salary 급여
    , hire_date 입사일
from
    employee_ex e
where
    dept_code = 'D5'
with check option;

select * from view_emp_d5;

-- view를 통해서 dml처리하기
-- 가상컬럼은 변경할 수 없다.
update
    view_emp_d5
set
    급여 = 급여 + 500000;

-- with check option   
update
    view_emp_d5
set
    부서코드 = 'D6'
where
    사번 = '206'; -- SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
    
-- view option
-- 1. or replace : 존재하면 대체
-- 2. with check option : view지정시에 사용한 where절 컬럼값 변경 방지
-- 3. with read only : 읽기전용


----------------------------------------------------------------------
-- SEQUENCE
----------------------------------------------------------------------
-- 정수값을 순차적으로 발행하는 객체, 채번기
-- 테이블의 pk컬럼의 식별값으로 주로 사용.

/*
        create sequence 시퀀스명
        [start with 시작값] 기본값 1
        [increment by 증감값] 기본값 1
        [maxvalue 최대값 | nomaxvalue] 기본값 nomaxvalue
        [minvalue 최솟값 | nominvalue] 기본값 nominvalue
        [cycle | nocycle] 기본값 nocycle
        [cache 메모리캐싱개수 | nocache] 기본값 20
*/

create table mac_order (
        no number primary key
);
create sequence seq_mac_order
start with 1
Increment by 1
nomaxvalue
nominvalue
nocycle
cache 20;


insert into mac_order values(seq_mac_order.nextval);

select * from mac_order;

select seq_mac_order.currval from dual;

-- DD에서 확인
select * from user_sequences;
-- last_number 다음번호

-- 주문테이블 예제
create table tb_order (
        no number
        , prod_no number -- 상품 고유번호
        , user_id varchar2(50) -- 회원 아이디
        , order_date date default sysdate -- 주문일
        , cnt number default 1
        , constraints pk_tb_order_no primary key(no)
        , constraints uq_tb_order unique(prod_no, user_id, order_date)
);
create sequence seq_tb_order_no;

insert into 
        tb_order
values (
        seq_tb_order_no.nextval
        , 123
        , 'honggd'
        , default
        , 30
);

select * from tb_order;

-- pk 복합문자열 처리
-- kh-20231026-0123
create table tb_order2 (
        id varchar2(30)
        , prod_no number -- 상품 고유번호
        , user_id varchar2(50) -- 회원 아이디
        , order_date date default sysdate -- 주문일
        , cnt number default 1
        , constraints pk_tb_order2_id primary key(id)
        , constraints uq_tb_order2 unique(prod_no, user_id, order_date)
);
insert into 
        tb_order2
values (
        'kh-' || to_char(sysdate, 'yyyymmdd') || '-' || to_char(seq_tb_order_no.nextval, 'fm0000')
        , 123
        , 'sinsa'
        , default
        , 10
);

select * from tb_order2;

-- 시퀀스 수정
-- increment by 값만 변경 가능.
-- start with값은 절대 변경불가. (시퀀스객체 삭제 후 새로 생성)
alter sequence seq_tb_order_no increment by 10;

-------------------------------------------------------------------------
-- INDEX
-------------------------------------------------------------------------
-- 색인 
-- 테이블 데이터의 처리속도 향상을 위해서 컬럼에 대해서 생성하는 객체
-- key-value형태로 저장. key = 컬럼값, value = 레코드의 주소(rowid)
-- 검색속도 빨라지고, 시스템 부하가 줄어서 전체 성능향상 시킴.
-- 추가적인 공간 필요. DML작업시 매번 함께 수정.

-- 어떤 컬럼을 대상으로 인데스를 생성해야 하는가?
-- 1. 선택도(중복값이 없는 정도)가 좋은 컬럼
--         - 선택도 좋은 컬럼 : emp_id, email, emp_no, emp_name
--         - 선택도 보통 : dept_code, job_code
--         - 선택도 나쁜 컬럼 : quit_yn, gender
-- 2. 조인시 기준컬럼, where절에 자주 사용되는 컬럼
-- 3. 데이터가 수백만이상인 경우 필수적으로 인덱스를 사용해야함.


-- 인덱스 조회
-- pk uq 제약조건 생성시 해당 컬럼에 대한 인덱스는 자동생성 
select * from user_indexes;
select * from user_ind_columns; -- 컬럼확인

-- 한행 조회
select * from employee where job_code = 'J1';
select rowid, e.* from employee e where emp_id = '201';

-- 사원명
select * from employee where emp_name = '송종기';

-- 인덱스 생성
create index idx_employee_emp_name on employee(emp_name);

-- 인덱스 사용시 유의사항
-- 1. 인덱스컬럼에 변형이 가해지는 경우 ex) substr(emp_no, 8, 1)
-- 2. 인덱스컬럼에 null 비교 emp_name is null
-- 3. not 비교하는 경우
-- 4. 인덱스컬럼의 자료형과 비교하는 값의 자료형이 다른 경우
-- 5. db옵티마이저 실행계획 선택 (힌트)

select * from employee where emp_no = '621225-1985634'; -- index unique scan
select * from employee where substr(emp_no, 1, 6) = '621225'; -- table full scan

select * from employee where emp_name is null; -- table full scan

select * from employee where emp_id != '201';

select * from employee where emp_id = 201; -- table full scan

-- index 삭제
-- drop index 인덱스명
-- pk, uq로 만들어지는 인덱스는 직접 삭제할 수 없고, 제약조건 제거하면 인덱스도 함께 제거된다.


--=============================================
-- PL/SQL
--=============================================
-- Procedural Language extension to SQL
-- 절차적언어확장판

-- pl/sql 유형
-- 1. 익명블럭 1회용 실행블럭
-- 2. db객체 (procedure | function | trigger...)

-- 콘솔출력 set serveroutput on (세션마다)
set serveroutput on;
/*
         익명블럭 구조
         
         declare
                변수선언부(선택)
         begin
                실행부(필수)
         exception
                예외처리부(선택)
        end;
        /
        
*/        

-- hello world
begin
        -- 콘솔출력
        dbms_output.put_line('Hello PL/SQL~');
        dbms_output.put_line('Hello PL/SQL~');
        dbms_output.put_line('Hello PL/SQL~');
end;
/

-- employee 사번으로 사원명 조회
declare
        v_emp_id char(3) := '&사번';
        v_emp_name varchar2(20);
begin
--        v_emp_id := '&사번';
        -- 1행 조회
        select
            emp_name
        into
            v_emp_name
        from
            employee
        where
            emp_id = v_emp_id;
            
        dbms_output.put_line('사원명 : ' || v_emp_name);
exception
        when no_data_found then dbms_output.put_line('조회된 사원이 없습니다.');
end;
/

-- declare절 변수 선언
-- 변수명 [constant] 자료형 [not null] [:= 초기값];
-- constant 상수(대입된 값을 변경불가)
-- not null 필수입력

-- 자료형
-- pl/sql 자료형 사용
-- char/varchar2, date, number 모두 사용가능. 자료형의 크기가 다름.
-- 1. 기본 자료형
        -- 문자형 varchar2, char
        -- 숫자형 number, binary integer, pls_integer
        -- 날짜형 date, timestamp
        -- 논리형 boolean
-- 2. 복합 자료형
        -- record
        -- cursor
        -- collection (배열,리스트,맵)
        
declare
    v_num number := 100;
    v_num2 constant number := 80; -- 초기화 필수
    v_bool boolean;
    v_today date := sysdate;
begin
--    v_num2 := 80; -- ORA-06550: 줄 5, 열5:PLS-00363: 'V_NUM2' 식은 피할당자로 사용될 수 없습니다

    dbms_output.put_line(v_num);
    
    v_bool := 2 = 2;
    if v_bool then
        dbms_output.put_line('참');
    end if;
    
    dbms_output.put_line(v_today);
end;
/

-- 참조변수 : 다른 테이블 컬럼타입을 참조해 선언
-- 1. %type
-- 2. %rowtype
-- 3. record 자료형

declare
    -- 테이블.컬럼%type
    v_emp_id employee.emp_id%type := '&사번';
    v_emp_name employee.emp_name%type;
    v_phone employee.phone%type;
begin
    select
        emp_name, phone
    into
        v_emp_name, v_phone
    from
        employee
    where
        emp_id = v_emp_id;
    
    dbms_output.put_line('사원명 : ' || v_emp_name);
    dbms_output.put_line('전화번호 : ' || v_phone);
end;
/

declare
    erow employee%rowtype;
begin
    select
        *
    into
        erow
    from
        employee
    where
        emp_id = '&사번';
        
        dbms_output.put_line('사원명 : ' || erow.emp_name);
        dbms_output.put_line('이메일 : ' || erow.email);
end;
/

-- 사원명으로 전화번호, 이메일, 직급명, 부서명 출력
declare
    v_emp_name employee.emp_name%type := '&사원명';
    v_phone employee.phone%type;
    v_email employee.email%type;
    v_job_name job.job_name%type;
    v_dept_title department.dept_title%type;
begin
    select
        phone
        , email
        , (select job_name from job where job_code = e.job_code) job_name
        , (select dept_title from department where dept_id = e.dept_code) dept_title
    into
        v_phone, v_email, v_job_name, v_dept_title
    from
        employee e
    where
        emp_name = v_emp_name;
        
        dbms_output.put_line('전화번호 : ' || v_phone);
        dbms_output.put_line('이메일 : ' || v_email);
        dbms_output.put_line('직급명 : ' || v_job_name);
        dbms_output.put_line('부서명 : ' || v_dept_title);
end;
/

-- record 선언후 사용
-- 여러 컬럼 조합으로 자료형 생성
declare
    v_emp_name employee.emp_name%type := '&사원명';
    
    -- record 자료형 생성
    type my_type is record(
            v_phone employee.phone%type
            , v_email employee.email%type
            , v_job_name job.job_name%type
            , v_dept_title department.dept_title%type
    ); 
    
    myrow my_type;
   
begin
    select
        phone
        , email
        , (select job_name from job where job_code = e.job_code) job_name
        , (select dept_title from department where dept_id = e.dept_code) dept_title
    into
        myrow
    from
        employee e
    where
        emp_name = v_emp_name;
        
        dbms_output.put_line('전화번호 : ' || myrow.v_phone);
        dbms_output.put_line('이메일 : ' || myrow.v_email);
        dbms_output.put_line('직급명 : ' || myrow.v_job_name);
        dbms_output.put_line('부서명 : ' || myrow.v_dept_title);
end;
/

-- pl/sql에서도 dml 실행
-- commit처리도 반드시 함께 한다.
create table member (
        id number
        , name varchar2(50)
        , created_at date default sysdate
);
select * from member;

begin
    insert into
        member
    values (
        1, '홍길동', default
        );
        commit;
end;
/

begin
    update
        member
    set
        name = '홍길순'
    where
        id = 1;
    commit;
end;
/

begin
    delete from member 
    where
        id = 1;
    commit; 
end;
/

-- employee_ex 테이블에서 신입사원정보를 추가
-- 사번 : 마지막 번호 + 1 -- 303
-- 이름, 주민번호, 전화번호, 직급코드, 급여등급은 사용자 입력값으로 처리.
select * from employee_ex;
desc employee_ex;

ex1)
declare
    v_emp_id employee_ex.emp_id%type;
    v_emp_name employee_ex.emp_name%type := '&사원명';
    v_emp_no employee_ex.emp_no%type := '&주민번호';
    v_phone employee_ex.phone%type := '&전화번호';
    v_job_code employee_ex.job_code%type := '&직급번호';
    v_sal_level employee_ex.sal_level%type := '&급여등급';
begin
    -- 사번 구하기
    select
        max(emp_id) + 1
    into
        v_emp_id
    from
        employee_ex;
        
    -- 등록
    insert into
        employee_ex (emp_id, emp_name, emp_no, phone, job_code, sal_level)
    values (
    v_emp_id, v_emp_name, v_emp_no, v_phone, v_job_code, v_sal_level
    );
    -- 트랙잭션 추가
    commit;
end;
/
ex2)
declare
    v_emp_id employee_ex.emp_id%type;
begin
    -- 사번 구하기
    select
        max(emp_id) + 1
    into
        v_emp_id
    from
        employee_ex;
        
    -- 등록
    insert into
        employee_ex (emp_id, emp_name, emp_no, phone, job_code, sal_level)
    values (
    v_emp_id, '&emp_name', '&emp_no', '&phone', '&job_code', '&sal_level'
    );
    -- 트랙잭션 추가
    commit;
end;
/





set serveroutput on;
select * from view_emp;
select * from employee; -- 24
select * from department; --9
select * from job;
select* from location;
select * from nation;
select * from sal_grade;