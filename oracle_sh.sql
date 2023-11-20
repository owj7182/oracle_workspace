
-- 2023-10-17 (1일차)

show user;

-- sh 계정이 가진 테이블 조회
select * from tab;

select * from department; -- 부서 테이블 
select * from employee; -- 사원 테이블
select * from job; -- 직급 테이블
select * from location; -- 지역 테이블
select * from nation; -- 국가테이블
select * from sal_grade; -- 급여 등급별 급여 범위 테이블

-- table 객체 구분
-- table(entity, relation) data를 보관하는 주체
-- column(field, attribute) 테이블의 구조, 자료형별 구분
-- row(record, tuple) data를 구분하는 단위
-- domain 하나의 속성(컬럼)에서 가질수 있는 값의 범위, 그룹(남/여, 0 ~ 100,.....)

desc employee; -- 테이블 상세보기
-- nullable (null여부) : not null(필수) | nullable(선택)


--================================
-- DATA TYPE
--================================
-- 1. 문자형
-- 2. 숫자형
-- 3. 날짜형

--------------------------------------------
-- 문자형
---------------------------------------------
-- char 고정형(최대 2000byte)
-- char(10) 고정형 문자타입 최대크기 10byte
--      'korea'입력시, 영문자(1byte) * 5로 실제 데이터 5byte이지만, 저장된 데이터의 크기는 10byte
--      '오라클'입력시, 한글(3byte - xe, 2byte - ee) * 3로 실제 데이터는 9byte지만, 저장된 데이터의 크기는 10byte
--      '대한민국'입력시, 한글 * 4로 실제 데이터가 12byte여서 저장불가!
-- varchar2 가변형(최대 4000byte)
-- varchar2(10) 가변형 문자타입 최대크기 10byte
--      'korea'입력시, 영문자(1byte) * 5로 실제 데이터 5byte이지만, 저장된 데이터의 크기는 5byte
--      '오라클'입력시, 한글(3byte - xe, 2byte - ee) * 3로 실제 데이터는 9byte지만, 저장된 데이터의 크기는 9byte
--      '대한민국'입력시, 한글 * 4로 실제 데이터가 12byte여서 저장불가!

-- long 최대 2gb 가변형 문자타입(deprecated)
-- clob (Character Large Object) 최대 4gb 가변형 문자타입

-- 테이블명/컬러명 작성시_(언더스코어)로 연결처리(Snake case)
create table tb_datatype_char (
    a char(10),
    b varchar2(10)
);
desc tb_datatype_char;
-- 행 단위로 데이터 추가
insert into tb_datatype_char values ('korea','korea');
insert into tb_datatype_char values ('오라클','오라클');
-- insert into tb_datatype_char values ('대한민국','abc');  -- SQL 오류: ORA-12899: "SH"."TB_DATATYPE_CHAR"."A" 열에 대한 값이 너무 큼(실제: 12, 최대값: 10)

select * from tb_datatype_char;
select 
    a, lengthb(a), b, lengthb(b)    
from 
    tb_datatype_char;

-- dml처리 (insert, update, delete) 데이터는 메모리상에서만 작업이 진행됨. 실제 db반영은 commit명령어를 전송해야 함.
commit;
rollback; -- 실행 취소(commit이후에는 사용할 수 없음)

--------------------------------------------------
-- 숫자형
--------------------------------------------------
-- number타입으로 정수/실수를 통합해서 관리
-- number(3, 2)와 같이 전체 자릿수, 소수점 이하 자릿수 지정가능

-- number에 1234.567을 저장하면, 1234.567.로 저장됨.
-- number(7, 0)에 1234.567을 저장하면, 1235로 저장됨. number(7) 동일.
-- number(7, 1)에 1234.567을 저장하면, 1234.6.로 저장됨.
-- number(7, -2)에 1234.567을 저장하면, 1200로 저장됨.

create table tb_datatype_number(
    a number,
    b number(7),
    c number (7, 1),
    d number (7, -2)
);

insert into tb_datatype_number values (1234.567, 1234.567, 1234.567, 1234.567);
-- insert into tb_datatype_number values (123456789, 123456789, 1234.567, 1234.567); -- SQL 오류 : 01438. 00000 -  "value larger than specified precision allowed for this column"

select * from tb_datatype_number;
commit;

---------------------------------------------
-- 날짜형
---------------------------------------------
-- data 년/월/일 시/분/초 관리
-- timestamp 년/월/일 시/분/초  하위 상세 시각까지 관리
-- timestamp with timezone 지역대 추가

-- 현재 시각 확인
-- sysdate : 현재 시스템(os) 시각
-- systimestamp : 현재 시스템(s) 시각 timestamp with timezone
select sysdate, systimestamp from dual; -- dual 1행짜리 가상테이블

-- 날짜형 연산
-- 1. 날짜 +- 숫자(1 = 1일) : 날짜
-- 2. 날짜 - 날짜 : 숫자 두 날짜 차이(일) 반환

select
    sysdate + 1" 내일",
    sysdate"오늘",
    sysdate - 1"어제",
    to_date('231225','yymmdd') - sysdate -- 68.5일
from 
    dual;
    
create table tb_datatype_date (
    a date,
    b timestamp,
    c timestamp with time zone
);
insert into tb_datatype_date values (sysdate, systimestamp, systimestamp);
select * from tb_datatype_date;

desc employee;

-- ==========================================
-- DQL
-- ===========================================
-- DML 하위 분류
-- Data Query Language 데이터 질의 언어
-- 테이블의 데이터를 검색/조회하는 명령어
-- 조회결과를 ResultSet(결과집합)이라 한다.
-- 조회 결과는 0행 이상이고, 시각화할 컬럼을 선택할 수 있다.


/*
    DQL구조        !!중요!!
    
    select 컬러명 (5) -- 필수
    from 테이블 (1) -- 필수
    where 조건절(필터링) (2)
    group by 그룹핑 (3)
    having 조건절(그룹핑에 대해 필터링) (4)
    oreder by 정렬기준 (6)
    
*/
-- job 테이블에서 job_name정보만 출력
select job_name from job;
-- department 테이블에서 컬럼 전체를 출력
select * from department;
-- employee 테이블에서 이름, 이메일, 전화번호, 고용일만 출력
select Emp_name, email, phone, hire_date from employee;
-- employee 테이블에서 이름,급여,고용일 출력 (이름 가나다순)
select emp_name, salary, hire_date from employee order by emp_name asc;
-- employee 테이블에서 급여가 250만원 이상인 사원 정보 출력 = != > <  >= <=
select * from employee where salary >= 2500000;
-- employee 테이블에서 급여가 350만원 이상이면서, 직급 코드가 J3인 사원의 이름과 전화번호 출력 (and, or 연결)
select emp_name, phone from employee where salary >= 3500000 and job_code = 'J3';

---------------------------------------
-- SELECT
---------------------------------------
-- 결과 집합에 포함 시킬 컬럼명을 지정
-- 존재하는 컬럼, 연산결과 등의 가상컬럼 가능

select
    emp_name, 
    salary, 
    salary *12,
    bonus,
    nvl(bonus, 0),
    salary + (salary * nvl(bonus, 0)) "실급여" -- 연산에 null값이 포함되면 결과는 무조건 null
from 
    employee;
-- nvl함수 : null일 경우, 기본값 지정

-- 사원 테이블에서 이름, 연봉(보너스 포함), 실수령액(매달 3%) 조회 
select
    emp_name "이름",
    (salary + (salary * nvl(bonus, 0))) * 12 "연봉(보너스 포함)",
     salary + (salary * nvl(bonus, 0)) * 0.97 "매달 실수령액"
from 
    employee;

-- 사원 테이블에서 사원명, 입사일, 근무일수 조회 (floor()버림함수)
select
    emp_name,
    hire_date,
 --  floor(sysdate - hire_date) "근무일수"
    floor(nvl(quit_date, sysdate) - hire_date) "근무일수"
from
    employee;
    
-- 별칭 as "별칭"
-- as ""모두 생략이 가능
-- 숫자로 시작하거나, 공백등 특수문자가 포함되어 있다면, ""  생략불가

select
    emp_name as "사원명",
    emp_no  "주민번호",
    phone 전화번호
from
    employee;

-- distinct
-- 컬럼에 포함된 중복을 제거해서 유일값 목록으로 반환
-- select 딱 한번만 사용이 가능
-- 여러 컬럼을 나열하면, 여러컬럼을 묶어서 유일한 값 반환

select distinct
    job_code
from
    employee
order by
    job_code;
    
select distinct
    dept_code,job_code
from
    employee
order by
    dept_code, job_code;

-- 문자열 연결연산자 ||
-- sql에서 + 연산은 숫자 사이에만 가능.
select
    emp_name,
    salary,
    '원' "단윈",
    salary || '원'
from
    employee;
    
-----------------------------------------
-- WHERE
-----------------------------------------
-- from 테이블 다음에 실행
-- 지정한 테이블에서 결과집합에 포함시킬 대상행을 판별하는 구문
-- 조건절을 행단위로 수행하고, 결과값이 true인 경우만 결과집합에 포함됨.
select 
    * 
from 
    employee
where
    dept_code = 'D5'; -- 동등비교 연산자

-- 비교 연산자
-- 1, 동등  =  !=  <>  ^=
-- 2. 비교  >  >=  <  <=
-- 3. 범위  between 시작값 and 종료값
-- 4. 문자패턴  like
-- 5. null비교 is null ( != null 작동하지 않음)
-- 6. 값목록 비교 in (값1, 값2...)
-- 7. 논리비교 and or not ( && || 사용불가)

-- 부서코드가 D6인 사원조회
select
    emp_name "사원"
from
    employee
where
    dept_code = 'D6';
    
-- 부서코드가 D6 아닌 사원조회
select
    emp_name "사원"
from
    employee
where
    dept_code != 'D6';
    
-- 부서 코드가 D6이고 급여를 300만원 보다 많이 받는 사원 조회
select
    *   
from
    employee
where
    dept_code = 'D6' and salary > 3000000;

-- 부서 코드가 D5이거나 D6이고 급여를 300만원 보다 많이 받는 사원 조회
select
    *   
from
    employee
where
    (dept_code = 'D5' or dept_code = 'D6') 
    and 
    salary > 3000000;
    
-- 직급 코드가 J1이 아닌 사원들의 급여 등급(sal_level)을 중복없이 출력
select distinct
    sal_level
from
    employee
where
    job_code != 'J1';
-- 20년 이상 근속자의 이름,월급,급여,보너스율(없는 경우 0)을 출력

select
    emp_name,
    salary,
    nvl(bonus, 0)
from
    employee
where
    quit_yn != 'Y' 
    and
    (sysdate - hire_date) >= 20 * 365;

-- 범위 연산 between and
-- 숫자/날짜
-- 급여가 3500000원 이상 6000000원 이하인 사원 조회
select
    *
from
    employee
where
--    salary between 3500000 and 6000000;
   salary >= 3500000 
   and
   salary <= 6000000;
--    salary not between 3500000 and 6000000;
--    salary < 3500000 
--   or
--   salary > 6000000;

-- 날짜 - 90년대 입사자 조회 (90/01/01 ~ 99/12/31)
select
    *
from
    employee
where
    hire_date between to_date('1990/01/01','yyyy/mm/dd') and to_date('1999/12/31', 'yyyy/mm/dd');

-- 문자열 패턴비교 like
-- 와일드카드(대체문자) 사용
--  % 0개 이상의 문자를 의미
-- _ 1개 문자를 의미

-- 전씨 성을 가진 사원 조회
select
    *   
from
    employee
where
--    emp_name like '전%';
    emp_name like '전__';
    
-- 이름에 '옹'이 들어가는 사원 조회
select
    *
from
    employee
where
--    emp_name like '옹__' or
--    emp_name like '_옹_' or
--    emp_name like '__옹';
    emp_name like '%옹%';
    
-- 이메일 조회 아이디 부분의 언더스코어 앞글자가 3글자인 사원을 조회
select * from employee where email like '___\_%' escape '\'; -- escape 문자를 직접 선언. \가 가장 무난하다.

-- 값몰록 비교 in
-- D5 또는 D6 부서원 조회
select
    *
from
    employee
where
--    dept_code = 'D5' or dept_code = 'D6';
--    dept_code in ('D5','D6'); -- 1개 이상의 값목록에 해달컬럼값이 포함되어 있다면 true 반환

--   dept_code not in ('D5', 'D6'); -- 뒤질을때는 not
--     not(dept_code = ('D5') or
--        dept_code = ('D6'));
    dept_code != 'D5' and dept_code != 'D6';
    
 -- null값 비교
 -- bonus가 null인 사원조회
 -- dept_code가 null인 사원조회
 select
    *
from
    employee
where
--    dept_code is null;
    nvl(dept_code, 'D0') = 'D0';
--    dept_code is not null;


----------------------------
-- ORDER BY
----------------------------
-- 결과집합 처리시 가장 마지막에 수행되는 정렬 작업구문.
-- 컬럼명, 별칭, 컬럼순서를 기준으로 정렬
-- 정렬이 필요한 경우 반드시 명시적으로 order by를 사용해야 한다.

-- 기본 정렬 (asc)
-- 숫자형 : 작은 수 -> 큰수
-- 날짜형 : 과거 -> 미래
-- 문자형 : 가나다, abc순
-- null : last (nulls first로 설정 가능)

select
    *
from
    employee
order by
    dept_code asc nulls first, emp_name desc;
    
select
    emp_name "이름",
    salary "급여"
from
    employee
order by
    2 desc;

commit;
-- 1. Employee테이블에서 이름 끝이 연으로 끝나는 사원의 이름을 출력하시오.
select
    emp_name
from
    employee
where
    emp_name like '%연';

-- 2. Employee 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 출력하시오.
select
    emp_name,
    phone
from
    employee
where
    phone not like '010%'; 
    
-- 3. Employee 테이블에서 메일주소 '_'의 앞이 4자이면서, Dept_code가 D9 또는 D5이고 고용일이 90/01/01 ~ 01/12/31이면서,
-- 월급이 270만원 이상인 사원의 전체 정보를 출력하시오
select
    *
from
    employee
where
    email like '____\_%' escape '\' and
    (dept_code = 'D9' or dept_code = 'D5')  and
    hire_date between to_date('1990/01/01','yyyy/mm/dd') and to_date('2001/12/31', 'yyyy/mm/dd') and
    salary >= 2700000;
    
 -- 4. tbl_escape_watch 테이블에서 description 컬럼에 99.99%라는 글자가 들어있는 행만 추출하세요.
 -- 테이블 및 데이터 등록후 문제풀이
create table tbl_escape_watch(
	watchname varchar2(40)
 ,description varchar2(200)
);
--drop table tbl_escape_watch;
insert into tbl_escape_watch values('금시계', '순금 99.99% 함유 고급시계');
insert into tbl_escape_watch values('은시계', '고객 만족도 99.99점를 획득한 고급시계');
commit;
select * from tbl_escape_watch;

select * from tbl_escape_watch where description like'%99.99\%%' escape '\';

-- 5. employee테이블에서 현재 근무중인 사원을 이름 오름차순으로 정렬해서 출력
select
    emp_name
from
    employee
where 
    quit_yn = 'N'
order by
    emp_name asc;
    
-- 6 사원별 입사입, 퇴사일. 근무기간을 조회하세요. 퇴사자 역시 조회되어야 합니다.
select
    emp_name,
    hire_date 입사일,
    quit_date 퇴사일,
    hire_date || ' ~ ' || quit_date "근무기간",
     floor(nvl(quit_date, sysdate) - hire_date) "근무일수"
from
    employee;

commit;
