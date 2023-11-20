-- 회원 1행 조회 프로시져
create or replace procedure proc_find_member_by_id(
    p_id in member.id%type
    , p_name out member.name%type
    , p_gender out member.gender%type
    , p_birthday out member.birthday%type
    , p_email out member.email%type
    , p_point out member.point%type
    , p_created_at out member.created_at%type
)
is
begin
    select
        name, gender, birthday, email, point, created_at
    into
        p_name, p_gender, p_birthday, p_email, p_point, p_created_at
    from
        member
    where
        id = p_id;
end;
/

select
        name, gender, birthday, email, point, created_at
    from
        member
    where
        id = 'honggd';

set serveroutput on;    
        
declare
      v_name member.name%type;
     v_gender member.gender%type;
     v_birthday member.birthday%type;
     v_email member.email%type;
     v_point member.point%type;
     v_created_at member.created_at%type;
begin
    proc_find_member_by_id('&id', v_name, v_gender, v_birthday, v_email, v_point, v_created_at);
    
    dbms_output.put_line(v_name);
    dbms_output.put_line(v_gender);
    dbms_output.put_line(v_birthday);
    dbms_output.put_line(v_email);
    dbms_output.put_line(v_point);
    dbms_output.put_line(v_created_at);
    
end;
/

-- 회원 전체 조회 프로시져
create or replace procedure proc_find_all_members(
        p_cursor out sys_refcursor)
is
begin
    open p_cursor for select * from member order by created_at desc;
end;
/

declare
    a_cursor sys_refcursor;
    mrow member%rowtype;
begin
    proc_find_all_members(a_cursor);
    loop fetch a_cursor into mrow;
        exit when a_cursor%notfound;
        dbms_output.put_line(mrow.id || '   ' || mrow.name || '     ' || mrow.birthday);
    end loop;
end;
/

-- 회원가입 프로시져
create or replace procedure proc_insert_member(
        result out number
        , p_id member.id%type
        , p_name member.name%type
        , p_gender member.gender%type
        , p_birthday member.birthday%type
        , p_email member.email%type
)
is
begin
    insert into
            member(id, name, gender, birthday, email)
    values(p_id, p_name, p_gender, p_birthday, p_email);
    -- 처리된 행의 수 (암묵적 커서)
    result := sql%rowcount;
    commit;
end;
/
declare
    result number;
begin 
    proc_insert_member(result, '&id', '&name', '&gender', '&birthday', '&email');
    dbms_output.put_line(result || '행이 삽입되었습니다');
end;
/

select * from member;