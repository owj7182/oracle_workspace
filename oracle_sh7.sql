--=================================================
-- DDL
--=================================================
-- Data Definition Language 데이터 정의어
-- db객체에 대한 Create, Alter, Drop을 지원
-- 명령 실행과 동시에 commit처리되므로 DML과 혼용시 주의해야 한다.

-- db객체
-- table
-- user
-- view
-- sequence
-- package
-- procedure
-- function
-- trigger
-- synonym
-- job.....

-------------------------------------------------------
-- CREATE
-------------------------------------------------------
-- db객체 생성 명령어
-- create table, create user, create view와 같이 사용한다.
-- 동일한 이름의 권한이 있어야 실행가능

create table member (
        -- 컬럼명, 자료형, 기본값, null여부
        id number
        , username varchar2(50)
        , name varchar2(100)
        , created_at date default sysdate
);
--drop table member;

-- 주석달기 (테이블, 컬럼)
-- 테이블명, 컬럼명외에 부가정보를 주석으로 달아둔다.
-- 생성/수정/삭제방법 모두 동일

comment on table member is '회원 관리 테이블';
comment on table member is ''; -- '' = null

comment on column member.id is '회원고유식별번호';
comment on column member.username is '회원아이디';
comment on column member.name is '회원명';
comment on column member.created_at is '회원가입일';

-- 주석 확인
-- Data Dictionary(db객체에 대한 메타정보 테이블(뷰), 읽기가능)로 부터 확인 가능

select * from user_tab_comments;
select * from user_col_comments where table_name = 'MEMBER';

-------------------------------------------------------------------
-- ALTER
-------------------------------------------------------------------
-- 테이블객체에 대한 alter문
-- 컬럼 | 제약조건에 대한 수정할 수 있다.

-- 서브명령어
-- add 컬럼/제약조건 추가
-- modify 컬럼에 대해서만 수정 가능 
-- - 제약조건은 이름말고는 변경할 수 없다.
-- - not null / null 제약조건은 modify를 통해 변경
-- rename 컬럼/제약조건 모두 수정 가능
-- drop 컬럼/제약조건 모두 삭제 가능

-- add 컬럼
create table member (
        id number 
);

-- username컬럼, name컬럼 추가
alter table member add username varchar2(20) default '' not null;
alter table member add name varchar2(50) not null;

-- 제약조건 pk, uq(username)추가
alter table member add constraints pk_member_id primary key(id);
alter table member add constraints uq_member_username unique(username);

-- modify 컬럼
-- 자료형/기본값/null여부
alter table member modify username varchar2(30) default 'honggd' null;
alter table member modify username default null; -- 기본값 null로 변경
alter table member modify username not null; -- not null 또는 null로 변경

-- rename 컬럼/제약조건
alter table member rename column username to member_name;
alter table member rename constraints SYS_C008444 to nn_member_name;

-- drop 컬럼/제약조건
alter table member drop column member_name;

alter table member drop constraints PK_MEMBER_ID;

alter table member drop constraints SYS_C008441;
alter table member modify name null;

-- 테이블명 변경
alter table member rename to member2;

rename member2 to member;

select * from user_constraints where table_name = 'MEMBER';
desc member2;
select * from member2;
drop table member2;

--------------------------------------------------------
-- DROP
--------------------------------------------------------
-- db객체 제거시 사용하는 ddl
drop table member;




--========================================================
-- CONSTRAINTS
--========================================================
-- 제약조건
-- 테이블 컬럼에 대하여 데이터 무결성(정확성/일관성을 지키는 것)을 지키기 위한 제한 모음.

-- 1. not null 필수값
-- 2. unique 중복허용X - nickname, id, 주민번호
-- 3. primary key (기본키) 고유식별컬럼 (이 컬럼값으로 행을 구분가능), 테이블당 1개만 허용 - 회원번호, 아이디 (주민번호 사용안함)
-- 4. foreign key (외래키) 다른 테이블 컬럼값만 사용가능. RDBMS의 핵심 - 부서코드, 직급코드
-- 5. check 도메인지정 - 남/여, y/n, 1 ~ 100

------------------------------------------------------------
-- NOT NULL
------------------------------------------------------------
-- null을 허용하지 않음. 기본값 null을 not null로 변경
-- 컬럼레벨에만 작성가능, 제약조건명을 보통 작성하지 않음.

create table member (
        -- 컬럼명, 자료형 기본값 null여부
        id number not null -- 컬럼레벨
        , username varchar2(50) not null
        , name varchar2(100) not null
        , created_at date default sysdate
        -- 테이블레벨
);
--drop table member;

insert into member values(1, 'honggd', '홍길동', default);
insert into member values(2, null, '신사임당', default); -- SQL 오류: ORA-01400: NULL을 ("SH"."MEMBER"."USERNAME") 안에 삽입할 수 없습니다

select * from member;

----------------------------------------------------
-- UNIQUE
----------------------------------------------------
-- 테이블의 특정컬럼값에 중복을 허용하지 않는 제약조건
-- PK컬럼외에 중복하지 않는 컬럼에 지정.
-- 복합 unique도 지정할 수 있다. (여러 컬럼을 묶어서 중복허용하지 않음.)

create table member (
        -- 컬럼명, 자료형 기본값 null여부
        id number not null -- 컬럼레벨
        , username varchar2(50) not null
        , name varchar2(100) not null
        , email varchar2(150)
        , created_at date default sysdate
        ,
        -- 테이블레벨
        constraints uq_member_email unique(email)
);
--drop table member;

insert into member values (1, 'honggd', '홍길동', 'honggd@naver.com', default);
insert into member values (2, 'hongdgd', '홍길동길동', 'honggd@naver.com', default); -- ORA-00001: 무결성 제약 조건(SH.UQ_MEMBER_EMAIL)에 위배됩니다
insert into member values (2, 'hongdgd', '홍길동길동', null, default); -- null값은 여러번 등록가능
insert into member values (3, 'sinsa', '신사임당', null, default);

select * from member;

------------------------------------------------------
-- PRIMARY KEY
------------------------------------------------------
-- 기본키(주키), 고유식별컬럼 지정 (해당 컬럼값으로 행을 구분)
-- not null기능, unique기능을 가지고 있으며, 테이블당 1개만 선언 가능.
-- 주로 where절에 행을 식별하기 위한 용도로 사용.
-- 한번 값이 지정되면 값을 변경하지 않는다.
-- 복합 pk로 사용가능

create table member (
        -- 컬럼명, 자료형 기본값 null여부
        id number  -- 컬럼레벨
        , username varchar2(50) not null
        , name varchar2(100) not null
        , email varchar2(150)
        , created_at date default sysdate
        ,
        -- 테이블레벨
        constraints pk_member_id primary key(id)
        , constraints uq_member_username unique(username)
        , constraints uq_member_email unique(email)
);
--drop table member;

insert into member values (1, 'honggd', '홍길동', 'honggd@naver.com', default);
insert into member values (1, 'sinsa', '신사임당', 'sinsa@naver.com', default); -- ORA-00001: 무결성 제약 조건(SH.PK_MEMBER_ID)에 위배됩니다
insert into member values (null, 'sinsa', '신사임당', 'sinsa@naver.com', default); -- SQL 오류: ORA-01400: NULL을 ("SH"."MEMBER"."ID") 안에 삽입할 수 없습니다

insert into member values (2, 'sinsa', '신사임당', 'sinsa@naver.com', default);

select * from member;
select * from member where id = 1; -- pk컬럼 조회시1행 또는 0행 반환
select * from member where username = 'honggdddddd'; -- uq컬럼 조회시 1행 또는 0행 반환

-- 복합 pk 예제
-- 주문테이블
create table tb_order_composite (
        prod_no number -- 상품 고유번호
        , user_id varchar2(50) -- 회원 아이디
        , order_date date default sysdate -- 주문일
        , cnt number default 1
        , constraints pk_tb_order_composite primary key(prod_no, user_id, order_date)
);
insert into tb_order_composite values(100, 'honggd', default, 10);
insert into tb_order_composite values(100, 'sinsa', default, 5);

-- pk컬럼중 일부라도 null을 대입할 수 없다
insert into tb_order_composite values(null, 'sinsa', default, 5); -- SQL 오류: ORA-01400: NULL을 ("SH"."TB_ORDER_COMPOSITE"."PROD_NO") 안에 삽입할 수 없습니다


select * from tb_order_composite;

--------------------------------------------------
-- FOREIGN KEY
--------------------------------------------------
-- 외래키. 참조무결성을 위한 제약조건
-- 참조하는 테이블에서 제공하는 값만 사용할 수 있게 제한을 거는 것
-- FK로 두 테이블간의 참조관계를 형성, RDBMS의 핵심
-- 부모테이블의 컬럼값(PK, UQ)을 자식테이블의 FK컬럼에서 참조.

select * from employee;
select * from department;

-- 제약조건 확인
select * from user_constraints where table_name = 'EMPLOYEE';
select * from user_constraints where table_name = 'DEPARTMENT';
select * from user_cons_columns where table_name = 'EMPLOYEE'; -- 컬럼명 확인
select * from user_cons_columns where table_name = 'DEPARTMENT'; -- 컬럼명 확인

-- 외래키 예제
create table shop_member(
        username varchar2(20)
        , name varchar2(100) not null
        , constraints pk_shop_member_username primary key(username)
);
insert into shop_member values('honggd', '홍길동');
insert into shop_member values('sinsa', '신사임당');
insert into shop_member values('leess', '이순신');

select * from shop_member;

-- fk 삭제옵션 (부모레코드 삭제시 옵션)
-- 1. on delete restricted (기본값)
-- 2. on delete set null 부모레코드 삭제시 해당 fk컬럼값을 null로 변경
-- 3. on delete cascade 부모레코드 삭제시 자식레코드 삭제

-- drop table shop_buy;
create table shop_buy (
        id number -- pk
        , username varchar2(20) -- fk
        , prod_id varchar2(20)
        , cnt number default 1
        , created_at date default sysdate
        , constraints pk_shop_buy_id primary key(id)
--        , constraints fk_shop_buy_username foreign key(username) references shop_member(username) on delete set null -- on delete set null
        , constraints fk_shop_buy_username foreign key(username) references shop_member(username) on delete cascade -- on delete cascade
);

insert into shop_buy values (1, 'honggd', 'kb123', 10, default);
insert into shop_buy values (2, 'sejong', 'kb123', 5, default); -- ORA-02291: 무결성 제약조건(SH.FK_SHOP_BUY_USERNAME)이 위배되었습니다- 부모 키가 없습니다
insert into shop_buy values (2, 'sinsa', 'americano', 5, default);
insert into shop_buy values (3, null, 'latte', 3, default); -- fk컬럼에 null 대입가능
insert into shop_buy values (4, 'honggd', 'americano', 5, default);

select * from shop_member;
select * from shop_buy;
commit;
rollback;

-- 데이터 삭제 fk제약
-- 자식데이터 삭제
delete from shop_buy where id = 1;
-- 부모데이터 삭제
delete from shop_member where username = 'honggd'; -- ORA-02292: 무결성 제약조건(SH.FK_SHOP_BUY_USERNAME)이 위배되었습니다- 자식 레코드가 발견되었습니다
-- 자식 레코드 삭제 -> 부모레코드 삭제
delete from shop_buy where username = 'honggd';
delete from shop_member where username = 'honggd';


-- fk 식별관계 - fk컬럼을 pk/uq제약조건을 걸어 사용하는 경우 (딱 한번만 참조가능) 1:1 관계 형성. 
-- - shop_member.username(1) -> shop_nickname.username(1)
create table shop_nickname (
        username varchar2(20) -- pk, fk
        , nickname varchar2(50) -- uq
        , constraints pk_shop_nickname_username primary key(username)
        , constraints fk_shop_nickname_username foreign key(username) references shop_member(username)
);

insert into shop_nickname values ('leess', '세젤귀 리순신');
insert into shop_nickname values ('sinsa', '신사임당최고~');
insert into shop_nickname values ('leess', '엄근진 리순신'); -- ORA-00001: 무결성 제약 조건(SH.PK_SHOP_NICKNAME_USERNAME)에 위배됩니다
select * from shop_nickname;


-- fk 비식별관계 - fk컬럼을 pk/uq제약조건을 없이 사용하는 경우 (여러번 참조가능) 1:N 관계 형성.
-- - shop_member.username(1) -> shop_buy.username(N)
-- - department.dept_id(1) -> employee.dept_code(N)

-- 회원출력 (아이디, 이름, 별명, 구매내역, 개수, 구매일)
select
    sm.username 아이디
    , sm.name 이름
    , sn.nickname 별명
    , sb.prod_id 구매내역
    , sb.cnt 개수
    , sb.created_at 구매일
from
    shop_member sm left join shop_nickname sn
        on sm.username = sn.username
    full join shop_buy sb
        on sm.username = sb.username;
        
select * from shop_member;
select * from shop_buy;
select * from shop_nickname;

-------------------------------------------------------
-- CHECK
-------------------------------------------------------
-- 컬럼값으로 사용가능한 도메인 지정

create table member (
        -- 컬럼명, 자료형 기본값 null여부
        id number  -- 컬럼레벨
        , username varchar2(50) not null
        , name varchar2(100) not null
        , email varchar2(150)
        , gender char(1) -- M/F
        , point number
        , created_at date default sysdate
        ,
        -- 테이블레벨
        constraints pk_member_id primary key(id)
        , constraints uq_member_username unique(username)
        , constraints uq_member_email unique(email)
        , constraints ck_member_gender check(gender in ('M','F'))
        , constraints ck_member_point check(point >= 0)
);
--drop table member;

insert into member values (1, 'honggd', '홍길동', 'honggd@naver.com', 'M', 1000,  default);
insert into member values (2, 'sinsa', '신사임당', 'sinsa@naver.com', 'f', 1000,  default); -- ORA-02290: 체크 제약조건(SH.CK_MEMBER_GENDER)이 위배되었습니다
insert into member values (2, 'sinsa', '신사임당', 'sinsa@naver.com', 'F', -1000,  default); -- ORA-02290: 체크 제약조건(SH.CK_MEMBER_POINT)이 위배되었습니다
insert into member values (2, 'sinsa', '신사임당', 'sinsa@naver.com', null, null,  default);

update member set point = -10 where id = 2; -- ORA-02290: 체크 제약조건(SH.CK_MEMBER_POINT)이 위배되었습니다

select * from member;

-- DD에서 조회 user_constraints, user_cons_columns(컬럼)
select * from user_constraints where table_name = 'MEMBER';
select * from user_constraints where table_name = 'SHOP_BUY';

--====================================================
-- DCL
--====================================================
-- Data Control Language 데이터 제어어
-- 권한부여/회수 grant/revoke
-- TCL commit/rollback

-- 권한 system priviliege 사용자 할 수 있는 명령어
-- 롤 role 권한묶음
grant create session, create table to sh; -- 권한
grant connect, resource to sh; -- 롤

-- (system계정) 롤에 포함된 권한 조회
select
    *
from
    dba_sys_privs
where
    grantee in ('CONNECT', 'RESOURCE')
order by
    1;
    
-- (system계정) qwerty 계정 생성
-- qwerty/qwerty 계정 생성
alter session set "_oracle_script" = true;

create user qwerty
identified by qwerty
default tablespace users;

-- create session 권한 또는 connect 롤 부여
grant connect to qwerty;

-- create table 권한 또는 resource 롤 부여
grant resource to qwerty;

-- tablespace users에 대한 쓰기공간 허가
alter user qwerty quota unlimited on users;


-- sh.coffee테이브 예제
-- qwerty 계정에서 sh계정의 테이블 coffee에 대한 select/insert/update/delete권한 획득
create table tbl_coffee (
        name varchar2(30) primary key
        , price number
        , company varchar2(50)
);
insert into tbl_coffee values ('맥심', 3000, '동서식품');
insert into tbl_coffee values ('카누', 5000, '동서식품');
insert into tbl_coffee values ('네스카페', 4000, '네슬레');

select * from tbl_coffee;
commit;

-- qwerty에게 tbl_coffee 읽기 권한 부여
grant select on tbl_coffee to qwerty;

-- qwerty에게 tbl_coffee insert, update, delete권한 부여
grant insert, update, delete on tbl_coffee to qwerty;

-- qwerty로부터 tbl_coffee insert, update, delete 권한 회수
revoke insert, update, delete on tbl_coffee from qwerty;
revoke select on tbl_coffee from qwerty;

------------------------------------------------------------
-- TCL
------------------------------------------------------------
-- Transaction Control Language 트랜잭션 제어어
-- commit, rollback, savepoint

-- 트랜잭션이란?
-- 한꺼번에 처리되어야 할 최소한 작업단위. 논리적 작업단위.
-- 트랜잭션 하위 작업은 반드시 모두 성공하거나, 전체 실패되어야 한다.

-- 계좌이체 처리하기
-- 1. 내 계좌에서 10만원 차감하기
-- 2. 친구계좌에 10만원 추가하기

-- commit 트랜잭션 작업이 모두 정상 완료되었을때 변경사항을 DB에 영구저장
-- rollback 트랜잭션 하위 작업중 일부가 실패한 경우, 모두 실패처리를 위해 변경사항을 모두 폐기

-----------------------------------------------------------------------------
-- DDL실습문제
-----------------------------------------------------------------------------
-- 1-1.테이블 생성
create table ex_member (
        member_code number
        , member_id varchar2(20)
        , member_pwd char(20)
        , member_name varchar2(30)
        , member_addr varchar2(100)
        , gender char(3)
        , phone char(11)
);
-- 1-2.컬럼 주석 달기
comment on table ex_member is '회원 테이블 예제';

comment on column ex_member.member_code is '회원전용코드'; -- 기본키
comment on column ex_member.member_id is '회원 아이디'; -- 중복금지(unique)
comment on column ex_member.member_pwd is '회원 비밀번호'; -- null값 허용금지(not null)
comment on column ex_member.member_name is '회원 이름';
comment on column ex_member.member_addr is '회원 거주지'; -- null값 허용금지(not null)
comment on column ex_member.gender is '성별'; -- 남/여로만 입력 가능 check
comment on column ex_member.phone is '회원 연락처'; -- null값 허용금지(not null)

-- 1-3. 제약조건 설정하기
-- 제약조건 pk, uq추가
alter table ex_member add constraints pk_ex_member_id primary key(member_code); -- 기본키
alter table ex_member add constraints uq_ex_member_username unique(member_id); -- 유니크
-- not null 추가
alter table ex_member modify member_pwd not null; -- not null
alter table ex_member modify member_addr not null; -- not null
alter table ex_member modify phone not null; -- not null
-- check 추가
alter table ex_member add constraints ck_ex_member_gender check(gender in ('남','여'));

-- 확인
select * from user_constraints where table_name = 'EX_MEMBER';
desc ex_member;
select * from ex_member;

-- 2-1 ex_member_nickname 테이블 생성(제약조건 이름 지정할 것)
-- (참조키를 다시 기본키로 사용할 것.)
create table ex_member_nickname (
        member_code number -- 중복금지
        , member_nickname varchar2(100) not null
        -- 제약조건
        , constraints fk_ex_member_nickname_member_code foreign key(member_code) references ex_member(member_code) -- 외래키 설정
        , constraints uq_ex_member_nickname_member_code unique(member_code)
);
-- 2-2 컬럼 주석 달기
comment on table ex_member_nickname is '회원 닉네임 테이블 예제';

comment on column ex_member_nickname.member_code is '회원전용코드'; -- 기본키
comment on column ex_member_nickname.member_nickname is '회원 이름'; -- 중복금지(unique)

-- 확인
select * from user_constraints where table_name = 'EX_MEMBER_NICKNAME';
desc ex_member_nickname;
select * from ex_member_nickname;

-- 3. 테이블 컬럼 주석 조회하는 쿼리
select * from user_tab_comments;
select * from user_col_comments where table_name = 'EX_MEMBER';
select * from user_col_comments where table_name = 'EX_MEMBER_NICKNAME';
