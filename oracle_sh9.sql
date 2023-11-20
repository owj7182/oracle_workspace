-- 2023-10-27
-- 콘솔출력 set serveroutput on (세션마다)
set serveroutput on;

--=======================================================
-- PL/SQL 조건문
--=======================================================
-- 1. if 조건식 then 실행문 end if;
-- 2. if 조건식 then 실행문 else 실행문 end if;
-- 3. if 조건식 then 실행문1 elsif 조건식2 then 실행문2... end if;

begin
    if '&이름' = '홍길동' then
        dbms_output.put_line('홍길동이 맞습니다.');
        dbms_output.put_line('홍길동이 정말 맞습니다.');
    else
        dbms_output.put_line('홍길동이 아닙니다.');
        dbms_output.put_line('홍길동이 정말 아닙니다.');
    end if;
    
    dbms_output.put_line('끝!');
end;
/

declare
    n number := &숫자;
begin
    if mod(n, 3) = 0 then
        dbms_output.put_line('3의 배수입니다.');
    elsif mod (n, 3) = 1 then
        dbms_output.put_line('3으로 나눈 나머지가 1입니다.');
    else
        dbms_output.put_line('3으로 나눈 나머지가 2입니다.');
    end if;
end;
/

-- 사용자로부터 정수하나 입력 받아서 짝수/홀수 구별하는 익명블럭
declare
    n number := &숫자;
begin
    if mod(n, 2) = 0 then
        dbms_output.put_line('짝수입니다');
    else
        dbms_output.put_line('홀수입니다');
    end if;
end;
/

-- 가위바위보 게임 만들기
dbms_output.put_line(dbms_random.value(1, 4)); -- 1.0 ~ 4.0 미만의 실수 반환
-- 사용자 입력
-- 컴퓨터 난수 생성
-- 비교 및 결과 출력

declare
    user number := &정수; -- 1(가위), 2(바위), 3(보)
    com number := floor(dbms_random.value(1, 4));
begin         
        if user = com then
            dbms_output.put_line ('비겼습니다.');
        elsif (user = 2 and com =1) or (user = 3 and com = 2) or (user = 1 and com = 3) then
            dbms_output.put_line ('당신이 이겼습니다.');
        else
             dbms_output.put_line ('당신이 졌습니다.');
        end if;
end;
/

-- case문
/*
    문법1.
        case 표현식
            when 값1 then
                실행문1;
            when 값2 then
                실행문2;
            else
                기본실행문
        end case;
    문법2.
        case
            when 조건식1 then
                실행문1;
            when 조건식2 then
                실행문2;
            ....
            else
                기본실행문;
        end case;
    
*/
-- 문법1.
begin
    case '&이름'
        when '홍길동' then
            dbms_output.put_line('홍길동님 반갑습니다.');
        when '신사임당' then
            dbms_output.put_line('신사임당님 반갑습니다.');
        else
            dbms_output.put_line('누구십니까?');
    end case;
end;
/

-- 문법2.
declare
    name varchar2(100) := '&이름';
begin
    case 
        when name = '홍길동' then
            dbms_output.put_line('홍길동님 반갑습니다.');
        when name = '신사임당' then
            dbms_output.put_line('신사임당님 반갑습니다.');
        else
            dbms_output.put_line('누구십니까?');
    end case;
end;
/

-- 사용자는 가위를 냈습니다.
-- 컴퓨터는 보를 냈습니다.
-- > 당신이 이겼습니다.

declare
    user number := &정수; -- 1(가위), 2(바위), 3(보)
    com number := floor(dbms_random.value(1, 4));
begin
        -- case 첫번째 문법
        case user
            when 1 then dbms_output.put_line ('사용자는 가위를 냈습니다.');
            when 2 then dbms_output.put_line ('사용자는 바위를 냈습니다.');
            when 3 then dbms_output.put_line ('사용자는 보를 냈습니다.');
        end case;
        case com
            when 1 then dbms_output.put_line ('컴퓨터는 가위를 냈습니다.');
            when 2 then dbms_output.put_line ('컴퓨터는 바위를 냈습니다.');
            when 3 then dbms_output.put_line ('컴퓨터는 보를 냈습니다.');
        end case;
        -- case 두번째 문법
        case
            when user = com then
                dbms_output.put_line ('비겼습니다.');
             when (user = 2 and com =1) or (user = 3 and com = 2) or (user = 1 and com = 3) then
                dbms_output.put_line ('당신이 이겼습니다.');
            else
                 dbms_output.put_line ('당신이 졌습니다.');
            end case;
end;
/

-- 반복문
-- 1. loop
-- 2. while loop
-- 3. for loop

-- 기본 loop
declare
    n number := 1;
begin
    loop
        dbms_output.put_line(n);
        n := n+1;
        
--        if n > 10 then
--            exit;
--            end if;
            exit when n > 10;
    end loop;
end;
/

-- while loop
declare
    i number := 1;
begin
    while i <= 10 loop
        dbms_output.put(i);
        i := i + 1;    
    end loop;
    dbms_output.new_line;
end;
/

-- 구구단 2단 출력
declare
    dan number := 2;
    n number := 1;
begin
    while n < 10 loop
        dbms_output.put_line(dan || ' * ' || n || ' = ' || dan * n);
        n := n + 1;
    end loop;   
end;
/

-- 모든 구구단 출력
declare
    dan number := 2;
    n number := 1;
begin
    while dan < 10 loop
        n := 1; -- 매번 1로 초기화
        while n < 10 loop
            dbms_output.put_line(dan || ' * ' || n || ' = ' || dan * n);
            n := n + 1;
        end loop;
         dan := dan + 1;
    end loop;
end;
/

-- for loop
begin
    -- 증감변수의 선언
    -- 증감변수 증감처리 (step +1로 고정), 마이너스 처리를 위해서는 reverse 키워드 사용
    -- exit
    for n in reverse 1 .. 5 loop
        dbms_output.put_line(n);   
    end loop;
end;
/

-- employee 사원 조회
select * from employee;

declare
    erow employee%rowtype;
begin
    for n in 200 .. 223 loop
        select
            *
        into 
            erow
        from
            employee
        where
            emp_id = n;
        dbms_output.put_line(erow.emp_id || ' : ' || erow.emp_name);
    end loop;
end;
/

--===============================================
-- DATABASE OBJECT2
--===============================================

--------------------------------------------------------------
-- STORED FUNCTION
--------------------------------------------------------------
-- 리턴값이 반드시 존재하는 프로시져
-- 저장된 함수/프로시져등은 미리 컴파일 되어서 즉시 실행가능한 상태로 대기중.
-- 요청 처리속도 빠르다는 장점.
-- 일반 sql문, 다른 프로시져 객체에서 호출가능

/*
    create or replace function fn_함수명(매개변수1 자료형, 매개변수2 자료형, ...)
    return 자료형
        is
           [변수선언]
        
        begin
            실행부
            
            return 리턴값
    [
        exception
            예외처리부
    ]
    end;
    /
*/

-- 찜질방 양모자 함수
create or replace function fn_hello(p_name employee.emp_name%type)
return varchar2 -- 자료형 크기 x
is
    result varchar2(500); -- 자료형 크기 명시
begin
    return 'd' || p_name || 'b';
    return result;
end;
/
-- 일반 함수에서 호출 가능
select
    fn_hello(emp_name)
from
    employee;
-- 익명블럭(프로시져)에서 호출
begin
    dbms_output.put_line(fn_hello('&이름'));
end;
/

-- dd에서 확인
select * from user_procedures where object_type = 'FUNCTION';

-- 연봉 계산 함수
-- 급여, 보너스를 입력 받고 연봉을 반환하는 함수 fn_annual_pay(salary, bonus)
create or replace function fn_annual_pay(p_salary employee.salary%type, p_bonus employee.bonus%type)
return number
is
begin
    return (p_salary + (p_salary * nvl(p_bonus, 0))) * 12;   
end;
/

select
    emp_name
    , fn_annual_pay(salary, bonus)
from
    employee;
    
-- 주민번호를 받아서 성별을 반환하는 fn_gender(emp_no)
create or replace function fn_gender(emp_no employee.emp_no%type)
return char
is
begin
    return case substr(emp_no, 8, 1)
        when '1' then '남'
        when '3' then '남'
        else '여'
        end;
end;
/

select
    emp_name
    , emp_no
    , fn_gender(emp_no)
from
    employee
order by
    1;
-- 주민번호를 받아서 나이를 반환하는 fn_age(emp_no)
-- ex1)
create or replace function fn_age(emp_no employee.emp_no%type)
return number
is
begin
    return trunc(months_between(sysdate, to_date((case substr(emp_no,8,1)
                                            when '1' then 1900
                                            when '2' then 1900
                                            else 2000 end + substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12);
end;
-- ex2)
create or replace function fn_age(emp_no employee.emp_no%type)
return number
is
    birthday date;
begin
    birthday := case
                        when substr (emp,_no, 8, 1) in ('1', '2') then 1900 + substr(emp_no, 1, 2) || substr(emp_no, 3, 4)
                        else 2000 + substr(emp_no, 1, 2) || substr(emp_no, 3, 4)
                    end;
    return floor(months_between(sysdate, birthday) / 12);
end;
/
select
    emp_name
    , emp_no
    , fn_age(emp_no)
from
    employee
order by
    1 ;
    
--------------------------------------------------------------------------
-- STORED PROCEDURE
--------------------------------------------------------------------------
-- 일련의 작업절차를 객체에 선언한 후 호출해서 사용.
-- 반환값이 없다. 대신 in/out모드 매개변수를 통해 호출부로 값을 전달할 수 있다.
-- 미리 컴파일된 채로 db에 저장되어있으므로 효율적인 실행이 가능.
-- select문에서는 사용불가. 익명블럭 또는 다른 프로시져에서 호출 가능

-- in모드 매개변수 : 호출부에서 프로시져로 전달된 값(매개인자)
-- out모드 매개변수 : 호출부에서 프로시져로 전달한 공간. 프로시져에서 값을 대입하면 호출부에서 그대로 확인 가능

/*
        create or replace procedure proc_프로시져명 (매개변수 모드 자료형, .....)
        is
            지역변수 선언
        begin
            실행부
        [exception]
        
        end;
        /
*/
-- 매개변수 없는 프로시져
select * from employee_ex;

create or replace procedure proc_del_all_emp
is
begin
    delete from employee_ex;
    commit;
end;
/

begin
    proc_del_all_emp; -- 매개인자 없는 프로시져호출
end;
/

-- dd에서 확인
select  * from user_procedures;

-- 매개변수 있는 프로시져 : 사번을 받아 이름을 조회
create or replace procedure proc_find_emp(
        p_emp_id in employee.emp_id%type
        , p_emp_name out employee.emp_name%type
         , p_email out employee.email%type
)
is
begin
    select
        emp_name, email
    into
        p_emp_name, p_email
    from
        employee
    where
        emp_id = p_emp_id;
end;
/

declare
    v_emp_id employee.emp_id%type := '&사번';
    v_emp_name employee.emp_name%type;
    v_email employee.email%type;
begin
    proc_find_emp(v_emp_id, v_emp_name, v_email); -- in(값 전달), out(값 반환용 공간)
    dbms_output.put_line('사번 : ' || v_emp_id);
    dbms_output.put_line('사원명 : ' || v_emp_name);
    dbms_output.put_line('이메일 : ' || v_email);
end;
/

-- upsert 예제
-- 데이터가 존재하지 않으면 insert, 존재하면, update처리
create table job_ex
as
select * from job;

select * from job_ex;

alter table job_ex
add constraints pk_job_ex_job_code primary key(job_code)
modify job_code varchar2(10)
modify job_name not null;

-- 직급코드/직급명 upsert procedure
create or replace procedure proc_upsert_job_ex(
        p_job_code job_ex.job_code%type
        , p_job_name job_ex.job_name%type
)
is
    cnt number;
begin
    -- 존재 여부 검사
    select
        count(*)
    into
        cnt
    from
        job_ex
    where
        job_code = p_job_code;
        
    dbms_output.put_line(cnt);
    if cnt = 0 then
        -- 기존 데이터가 없는 경우
        insert into
            job_ex
        values (p_job_code, p_job_name);
    else
        -- 기존테이터가 있는 경우
         update
            job_ex
        set
            job_name = p_job_name
        where
            job_code = p_job_code;
    end if;
    commit;   
end;
/

begin
    proc_upsert_job_ex('&직급코드', '&직급명');
end;
/
    
select * from job_ex;    
delete from job_ex where job_code = 'D7';    
update
    job_ex
set
    job_name = '신입'
where
    job_code = 'J8';

-- 해당사원의 보너스율을 인상하는 프로시져 생성
-- proc_increse_bonus(emp_id, bonus)
-- 201, 0.1 : 기존 보너스 0.15 -> 0.25
-- 210 0.05 : 기존 보너스 null -> 0.05
insert into employee_ex(select * from employee);
commit;
select * from employee_ex;

create or replace procedure proc_increse_bonus (
        p_emp_id employee_ex.emp_id%type
        , p_bonus employee_ex.bonus%type
)
is
begin 
        update
            employee_ex
        set
            bonus = nvl(bonus, 0) + p_bonus
        where
            emp_id = p_emp_id;
        commit;
end;
/

begin
    proc_increse_bonus('200', 0.05);
    proc_increse_bonus('201', 0.1);
end;
/

select emp_id, bonus from employee_ex;

------------------------------------------------------------
-- CURSOR
------------------------------------------------------------
-- sql문 처리결과 ResultSet(DQL, DML)을 가리키는 포인터 타입.

-- 암시적 커서 : 오라클 쿼리 실행후 자동 생성되는 커서
-- 명시적 커서 : 여러행 처리를 위한 자료형

-- 커서의 상태변화
-- OPEN
-- FETCH 한행씩 접근/다음행으로 포인터가 이동
-- CLOSE

-- 커서 속성
-- %rowcount 처리된 행의 수
-- %notfound open후 fetch될 행이 없는 경우 true 반환
-- %found open후 fetch될 행이 있는 경우 true 반환
-- %isopen 현재커서가 open되었는지 여부 true/false

-- 명시적 커서 : 여러행 처리를 위한 자료형
declare
    cursor emp_cursor
    is
    select * from employee; -- 커서 선언
    emprow employee%rowtype;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into emprow;
        exit when emp_cursor%notfound;
        dbms_output.put_line(emprow.emp_id || ' ' || emprow.emp_name || ' ' || emprow.email);
    end loop;
    close emp_cursor;
end;
/

-- 파라미터가 있는 커서
declare
    cursor cs_emp(p_dept_code employee.dept_code%type)
    is
    select * from employee where dept_code = p_dept_code;
    
    erow employee%rowtype;
begin
    open cs_emp('&부서코드'); -- 쿼리 실행
    loop
        fetch cs_emp into erow;
        exit when cs_emp%notfound;
        dbms_output.put_line(erow.emp_name || ' ' || erow.dept_code);
    end loop;
    close cs_emp;
end;
/

-- for loop으로 cursor제어하기
declare
    cursor emp_cursor
    is
    select * from employee; -- 커서 선언
begin
    -- open/close 처리
    -- fetch처리
    -- 행을 담을 변수선언
    for emprow in emp_cursor loop
        dbms_output.put_line(emprow.emp_id || ' ' || emprow.emp_name || ' ' || emprow.email);
    end loop;
end;
/

-- 커서변수 -매법 쿼리를 커서에 전달해서 실행
-- sys_refcursor 오라클 지원 커서 변수
declare
    -- 커서 상수(실행쿼리 고정)
    cursor cs_emp(p_dept_code employee.dept_code%type)
    is
    select * from employee where dept_code = p_dept_code;
begin
    for erow in cs_emp('&부서코드') loop
        dbms_output.put_line(erow.emp_name || ' ' || erow.dept_code);
    end loop;
end;
/

-- 커서변수 - 매번 쿼리를 커서에 전달해서 실행
-- sys_refcursor 오라클지원 커서변수

declare
    mycursor sys_refcursor;
    erow employee%rowtype;
begin
    -- for in문 사용불가
    open mycursor for select * from employee;
    loop
        fetch mycursor into erow;
        exit when mycursor%notfound;
        dbms_output.put_line(erow.emp_id || ' ' || erow.emp_name);
    end loop;
    
    dbms_output.new_line;
    
    open mycursor for select * from employee where dept_code = 'D5';
    loop
        fetch mycursor into erow;
        exit when mycursor%notfound;
        dbms_output.put_line(erow.emp_id || ' ' || erow.emp_name);
    end loop;
    close mycursor;
    
end;
/

-- 커서를 out모드 매개변수로 사용하기
create or replace procedure proc_find_employee(
        cs out sys_refcursor)
is
begin
    open cs for select * from employee;
        -- fetch/close 안함.
end;
/

declare
    my_cs sys_refcursor;
    erow employee%rowtype;
begin
    proc_find_employee(my_cs);
    
    loop
        fetch my_cs into erow;
        exit when my_cs%notfound;
        dbms_output.put_line(erow.emp_id || ' ' || erow.emp_name || ' ' || erow.dept_code);
        end loop;
        close my_cs;
end;
/

-- 직급코드를 전달받고 해당 직급의 사원을 조회한 out모드 매개변수 커서를 사용하는 프로시져 생성 
-- proc_find_emp_by_job_code(job_code, cursor)
create or replace procedure proc_find_emp_by_job_code (
        p_job_code employee.job_code%type
        , cs out sys_refcursor)
is
begin
    open cs for select * from employee where job_code = p_job_code;
end;
/
declare
    my_cs sys_refcursor;
    erow employee%rowtype;
begin
     proc_find_emp_by_job_code('&job_code', my_cs);
    
    loop
        fetch my_cs into erow;
            exit when my_cs%notfound;
            dbms_output.put_line(erow.emp_name || ' ' || erow.job_code);
        end loop;
end;
/

-----------------------------------------------------------------------
-- TRIGGER
-----------------------------------------------------------------------
-- 사전적으로 방아쇠, 연쇄반응을 의미
-- 특정이벤트(DML, DDL등)이 있을때 일련을 동작을 수행하는 db객체

-- 트리거 종류
-- 1. DML 트리거
-- 2. DDL 트리거
-- 3. Logon/off 트리거

/* 
        트리거문법
        create [or replace] trigger trig_트리거명
                before | after                                      -- 원DML 실행 전/후 트리거 실행
                insert | update | delete on 테이블명
                [for each row]                                     -- 행레벨 트리거(원DML 적응행마다 실행), 생략하면 문장레벨 트리거
        [ declare
                지역변수 선언 ]
        begin
                실행문                                                 -- 트랜잭션 처리를 하지 않음. 원DML문과 같은 트랜잭션에 자동으로 속하게 됨.
        end;
        /
*/

create table tb_user (
        id varchar2(20)
        , name varchar2(50) not null
        , constraints pk_tb_user_id primary key(id)
);

create table tb_user_log (
        no number
        , user_id varchar2(20)
        , content varchar2(4000)
        , created_at date default sysdate
        , constraint pk_tb_user_log_no primary key(no)
        , constraint fk_tb_user_log_user_id foreign key(user_id) references tb_user(id)
);

alter table tb_user_log drop constraints fk_tb_user_log_user_id;

create sequence seq_tb_user_log_no;

-- 의사레코드(행레벨 트리거에서만) :old :new
--                                      원DML 실행
-- insert                                               :new
-- update       :old                                 :new
-- delete        :old                                 
create or replace trigger trig_tb_user_log
        after
        insert or update or delete on tb_user
        for each row
begin
        if inserting then -- insert시 true인 속성
        insert into 
                tb_user_log (no, user_id, content)
        values (
                seq_tb_user_log_no.nextval
                , :new.id
                , :new.id || '회원이 가입했습니다.'
        );
        
         elsif updating then -- update시 true인 속성
                insert into 
                        tb_user_log (no, user_id, content)
                values (
                        seq_tb_user_log_no.nextval
                        , :new.id -- :old.id
                        , :old.name || ' 에서 ' || :new.name || ' 으로 변경했습니다.'
        );
         elsif delating then -- delete시 true인 속성
                 insert into 
                        tb_user_log (no, user_id, content)
                values (
                        seq_tb_user_log_no.nextval
                        , :old.id -- :old.id
                        , :old.id || ' 회원님 탈퇴했습니다.'
        
        end if;
        
end;
/

insert into tb_user (id, name) values('honggd', '홍길동');
-- trigger로 실행된 dml문은 원dml문과 같은 트랜잭션으로 묶인다.
-- 1. 원dml이 commit되면 trigger의 dml문도 함께 commit
-- 2. 원dml이 rollback되면 trigger의 dml문도 함께 rollback

update
        tb_user
set
        name = name || '길동'
where
        id = 'honggd';
        
delete from tb_user where id = 'honggd';

select * from tb_user;
select * from tb_user_log;

--drop table tb_product;
--drop table tb_product_io;

-- 제품 재고 (입출고 내역) 트리거로 관리하기
create table tb_product(
        pcode varchar2(20)
        , pname varchar2(50)
        , price number
        , stock number default 0 -- 재고
        , constraints pk_tb_prodeuct_pcode primary key(pcode)
        , constraints ck_tb_prodeuct_stock check(stock >= 0)
);

create table tb_product_io (
        no number
        , pcode varchar2(20)
        , status char(1) -- I, O
        , cnt number
        , created_at date default sysdate
        , constraints pk_tb_product_io_no primary key(no)
        , constraints fk_tb_product_io_pcode foreign key(pcode) references tb_product(pcode)
        , constraints ck_tb_product_io_status check(status in ('I', 'O'))
);
--drop sequence seq_tb_product_io_no;

create sequence seq_tb_product_io_no;

insert into tb_product values ('apple_iphone_15', '아이폰15', 1500000, default);
insert into tb_product values ('samsung_galaxy_23', '갤럭시23', 1300000, default);

select * from tb_product;
select * from tb_product_io;

-- 입출고 아이폰
insert into 
        tb_product_io (no, pcode, status, cnt)
values (
        seq_tb_product_io_no.nextval
        , 'apple_iphone_15'
        , 'I'
        , 15);
insert into 
        tb_product_io (no, pcode, status, cnt)
values (
        seq_tb_product_io_no.nextval
        , 'apple_iphone_15'
        , 'O'
        , 10);      
        
-- 입출고 갤럭시
insert into 
        tb_product_io (no, pcode, status, cnt)
values (
        seq_tb_product_io_no.nextval
        , 'samsung_galaxy_23'
        , 'I'
        , 15);
insert into 
        tb_product_io (no, pcode, status, cnt)
values (
        seq_tb_product_io_no.nextval
        , 'samsung_galaxy_23'
        , 'O'
        , 6);

-- 입출고 내역에 따라 재고를 갱신하는 트리거
create or replace trigger trig_update_product_stock
        after
        insert on tb_product_io
        for each row
begin
        
        if :new.status = 'I' then
                -- 입고시 stock + :new.cnt
                update
                        tb_product
                set
                        stock = stock + :new.cnt
                where
                        pcode = :new.pcode;
                
        else
                -- 출고시 stock - : new.cnt
                  update
                            tb_product
                    set
                            stock = stock - :new.cnt
                    where
                            pcode = :new.pcode;
        end if;
end;
/

--------------------------------------------------------
-- 트리거 실습문제
--------------------------------------------------------
-- 1. 퇴사자 관리 
-- employee_ex 테이블의 퇴사자관리를 별도의 테이블 tbl_emp_quit에서 하려고 한다.
-- 다음과 같이 tbl_emp_join, tbl_emp_quit테이블을 생성하고, tbl_emp_join에서 delete시 자동으로 퇴사자 데이터가 
-- tbl_emp_quit에 insert되도록 트리거를 생성하라.

-- TBL_EMP_JOIN 테이블 생성 : QUIT_DATE, QUIT_YN 제외
CREATE TABLE TBL_EMP_JOIN
AS
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
FROM EMPLOYEE_EX
WHERE QUIT_YN = 'N';

SELECT * FROM TBL_EMP_JOIN;
-- TBL_EMP_QUIT : EMPLOYEE테이블에서 QUIT_YN 컬럼제외하고 복사
CREATE TABLE TBL_EMP_QUIT
AS
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
FROM EMPLOYEE_EX
WHERE QUIT_YN = 'Y';

SELECT * FROM TBL_EMP_QUIT;

drop trigger trig_delete_tbl_emp_quit;

-- 트리거
create or replace trigger trig_delete_tbl_emp_quit
    after
    delete on tbl_emp_join 
    for each row
begin
        if deleting then 
         insert into
                    tbl_emp_quit
            values (
                    :old.emp_id
                    , :old.emp_name
                    , :old.emp_no
                    , :old.email
                    , :old.phone
                    , :old.dept_code
                    , :old.job_code
                    , :old.sal_level
                    , :old.salary
                    , :old.bonus
                    , :old.manager_id
                    , :old.hire_date
                    , sysdate);      
    end if;
end;
/

delete from tbl_emp_join where emp_id = 212;
-- 2. 사원변경 내역 관리
-- 사원변경 내역을 기록하는 employee_ex_log테이블을 생성하고, employee_ex 사원테이블의 insert, update가 있을 때마다
-- 신규데이터를 기록하는 트리거를 생성하라.

-- 로그테이블명 employee_ex_log : 컬럼 log_no(시퀀스객체로부터 채번함. pk), log_date(기본값 sysdate, not null), ex_employee테이블의 모든 컬럼
-- 트리거명 trg_employee_ex_log
CREATE TABLE employee_ex_log 
as
select 
	123 log_no
  , sysdate log_date
  , e.*
from 
	employee_ex e
where 
	1 = 0;--테이블의 구조만 복사한다.

select * from employee_ex_log;

-- 테이블 제약조건 추가 및 변경

alter table employee_ex_log
add constraint pk_employee_ex_log_no primary key(log_no)
modify log_date default sysdate not null;

-- 컬럼 nullable, data_default 확인
select * from user_tab_columns where table_name = 'EMPLOYEE_EX_LOG';

-- 제약조건 확인 (컬럼명 포함)
select * 
from user_constraints uc join user_cons_columns ucc using(constraint_name)
where uc.table_name = 'EMPLOYEE_EX_LOG';

create sequence seq_employee_ex_log ;--옵션없이 기본값으로 시퀀스 생성

--트리거 생성
create or replace trigger trig_employee_ex_log
    after 
    insert or update on employee_ex 
    for each row
begin
    if inserting or updating then 
        insert into 
                employee_ex_log
        values (
                seq_employee_ex_log.nextval,
                default,
                :new.emp_id
                , :new.emp_name
                , :new.emp_no
                , :new.email
                , :new.phone
                , :new.dept_code
                , :new.job_code
                , :new.sal_level
                , :new.salary
                , :new.bonus
                , :new.manager_id
                , :new.hire_date
                , :new.quit_date
                ,:new.quit_yn
                );
    end if;
end;
/

insert into employee_ex
    values ( '333', '오우진', '980323-111111', 'woo@naver.com', '01050494444', 'D1', 'J1', 'S1', 5000000, null, null, sysdate, null, 'N');

update
    employee_ex
set
    emp_name = '우진'
where
    emp_id ='333';
select * from employee_ex;
select * from employee_ex_log;
-- fn_annual_pay 연봉 함수
-- fn_gender 성별 함수
-- fn_age 만 나이 함수
