-- 한줄 주석
/*
    여러줄 주석
    여러줄 주석
    여러줄 주석
*/
show user;

-- sh계정 생성(관리자만 생성)
-- sql문은 대소문자를 구별하지 않는다.(데이터부분만 빼고)
-- 계정 생성시 비밀번호는 대소문자 구분
alter session set "_oracle_script" = true; -- c## 접두사 우회설정

create user sh
identified by sh
default tablespace users;

--alter user sh identified by sh; -- 비번 바꾸는 법

-- ORA-65096: 공통 사용자 또는 롤 이름이 부적합합니다.
-- oracle12c 이후에는 일반계정명은 c##접두사를 이용합니다.

-- 상태: 실패 -테스트 실패: ORA-01045: 사용자 SH는 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다.
-- grant create session to sh; -- create session권한을 sh에게 부여
-- grant create table to sh; -- table 생성 권한
grant connect, resource to sh; -- 롤 (권한묶음)로써 부여해도 동일 위에 2코드를 한 줄로 처리 가능
alter user sh quota unlimited on users; -- tablespace(실제데이터가 보관되는 장소) 사용용량 무제한으로 수정

-- chun/chun계정 생성
-- sqldeveloper 접속정보

alter session set "_oracle_script" = true;

create user chun
identified by chun
default tablespace users;

grant connect,resource to chun;
alter user chun quota unlimited on users;

