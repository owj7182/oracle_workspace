-- 2023 -10 -18 (2일차)

--===========================================
-- BUILT-IN FUNCTION
--===========================================
-- oracle 안에 포함된 함수
-- 일련의 처리를 묶어서 작성해두고 호출 사용하는 것.
-- 반드시 리턴값이 존재한다.

-- 구분
-- 1. 단일행 함수 - 행별로 처리되는 함수
--      - 문자 처리 함수
--      - 숫자 처리 함수
--      - 날짜 처리 함수
--      - 형 변환 함수
--      - 기타 함수
-- 2. 그룹함수 - 행을 그룹핑하고 그룹별로 실행되는 함수

---------------------------------------------------
-- 문자 처리 함수
---------------------------------------------------
-- length(value) : number 길이값을 반환
-- lengthb(value) : number byte수를 반환
select
    emp_name,
    length(emp_name) "길이",
    lengthb(emp_name) " bytes",
    email,
    length(email) "길이",
    lengthb(email) " bytes"
from
    employee;
    
-- instr(src, search[, strart_position, occurence]) : index
-- src문자열에서 search 문자열의 인덱스를 반환
-- 검색 시작 위치, 출현횟수등을 지정가능
select
    instr('kh정보교육원 국가정보원 정보문화사', '정보'),
    instr('kh정보교육원 국가정보원 정보문화사', '정보', 1,2),
    instr('kh정보교육원 국가정보원 정보문화사', '정보', -1) -- 뒤에서부터 검색
from
    dual;
    
-- substr(src, start_index[, length]) : string    
-- src문자열에서 start_index부터 length개수의 문자열을 잘라 반환
select
    substr('show me the money', 6, 2),
    substr('show me the money', 6),
    substr('show me the money', -5) -- 뒤에서부터 검색
from
    dual;
    
-- 사원테이블에서 이메일 앞의 아이디만 조회
-- @인덱스를 알아내야한다.
select
    substr(email, 1, instr(email, '@') - 1)
from
    employee;
    
-- 사원테이블에서 사원들의 성만 가나다순 조회(중복제거) - 모든 성은 한글자임
select distinct
    substr(emp_name, 1, 1)
from
    employee
order by
     substr(emp_name, 1, 1) asc;

-- lpad(value, length, padding) :string
-- rpad(value, length, padding) :string
-- length에 value를 작성하고, 남은 공간에 padding 왼쪽/오른쪽 채우기
-- padding 공백이 기본문자
select
    lpad(email, 20, '#'),
    rpad(email, 20, '#'),
    lpad(email, 20),
    rpad(email, 20)
from
    employee;

select
    lpad(123, 5, 0),
    lpad(12, 5, 0),
    'kh-' || to_char(sysdate, 'yymmdd') || '-' || lpad(123, 5, 0) "주문번호" , -- kh-231018-00123
    floor(dbms_random.value() * 100000), -- 0 ~ 99999
    'kh-' || to_char(sysdate, 'yymmdd') || '-' || lpad(floor(dbms_random.value() * 100000), 5, 0) "주문번호"
from
    dual;
    
-- 정규 표현식 REGEXP함수
-- 문자 검색 특화된 표현식
-- regexp_replace(src, regexp, new_str) : string
-- src문자열에서 regexp와 일치하는 문자열을 new_str로 변환한 문자열 반환
select
    '2023/12/25 22:30:55',
    regexp_replace('2023/12/25 22:30:55', ' |/|:', ''), -- 정규 표현식에서 |는 or의미함. 20231225223055
    '1243124helloworld34151345143',
    regexp_replace('1243124helloworld34151345143', '[[:digit:]]', ''), -- helloworld
    regexp_replace('1243124helloworld34151345143', '[^[:digit:]]', '')
from
    dual;

-- regexp_like(src, regexp) : boolean
-- where절에서 사용
-- src문자열에서 regexp패턴이 있으면 true, 없으면 false

-- 김씨, 이씨 사원조회
select
    emp_name
from
    employee
where
--    substr(emp_name, 1, 1) like '이%' or substr(emp_name, 1, 1) like '김%'; 
--    substr(emp_name, 1, 1) in ('김','이');
    regexp_like(emp_name, '^(김|이)'); -- ^ 문자열의 시작
    
-- 남자 사원 조회
select
    *
from
    employee
where
--     substr(emp_no, 8, 1) in ('1','3');
    regexp_like(emp_no, '-(1|3)');

------------------------------------------------
-- 숫자 처리 함수
------------------------------------------------
-- mod(m, n) : remainder
-- sql %연산 지원안함.
select
    mod(10, 3),
    mod(10, 2)
from
    dual;
    
-- 생일이 짝수인 사원만 조회
select
    emp_name,
    substr(emp_no, 5, 2) "생일",
    mod(substr(emp_no, 5, 2), 2) "나머지"
from
    employee
where
--    substr (emp_no, 6,1) in ('0','2','4','6','8');
    mod(substr(emp_no,5, 2), 2) = 0;
    
-- ceil(n)
-- floor(n) | trunc(n, 소수점 이하 자리수)
-- round(n, 소수점 이하 자리수)
select
    ceil(123.456), -- 124
    ceil(123.456 * 100) / 100, --123.46
    floor(123.456), -- 123
    round(123.456), -- 123
    round(123.567), -- 124
    round(123.456, 2), -- 123.46
    trunc(123.456, 2) -- 123.45
from
    dual;

------------------------------------------------
-- 날짜 처림 함수
------------------------------------------------
-- add_months(date, number) : date
-- 1달후 날짜, 3달후 날짜 조회
-- 말일관련 처리 주의
select
    add_months(sysdate, 1),
    add_months(sysdate, -1),
    add_months(to_date('20230131', 'yyyymmdd'), 1),  -- 2023/02/28 00:00:00
    add_months(to_date('20230228', 'yyyymmdd'), 1)  -- 2023/03/31 00:00:00
from
    dual;    
    
-- 입사 후 3개월째 정식사원으로 계약하게 된다.
-- 사원들이 정식사원이 된 날을 조회 (이름, 날짜)
select
    emp_name,
    add_months(hire_date, 3)
from
    employee;

-- months_between(future_date, past_date) : number
-- 두 날짜 사이의 개월수 반환
select
   trunc(months_between('20240101', sysdate), 1) -- 2.4개월
from
    dual;

-- 근무 개월수 조회
-- 이름 | n개월 | m년k개월
-- 퇴사자에 필요한 정확한 계산

select
    emp_name,
    trunc(months_between(nvl(quit_date, sysdate), hire_date )) "근무 개월수",
--    trunc(x / 12) || ' 년 ' || trunc()mod(x, 12)) || '개월' "근무개월수"
    trunc((trunc(months_between(nvl(quit_date, sysdate), hire_date )) / 12)) || '년' || trunc(mod(months_between(nvl(quit_date, sysdate), hire_date), 12))
    || '개월' "근무개월수",
    floor(nvl(quit_date,sysdate) - hire_date)
from
    employee;

-- extract(년월일시분초 from date/timestamp) : number
select
    extract(year from sysdate) year,
    extract(month from sysdate) month,
    extract(day from sysdate) day, 
    extract(hour from cast(sysdate as timestamp)) hour,
    extract(minute from cast(sysdate as timestamp)) minute,
    extract(second from cast(sysdate as timestamp)) second
from
    dual;

-- 2001년 입사자의 정보 조회
select
    *
from
    employee
where
    extract(year from hire_date) = 2001; 

-- trunc(date) : date
-- 시분초정보 제거
select
    sysdate,
    trunc(sysdate)
from
    dual;
    
---------------------------------------------
-- 형변환 함수
---------------------------------------------
-- 문자/숫자/날짜 사이의 형변환 지원
/*
                to_char             to_date
                ---------->     ----------->
    number              char                date
                <----------     <-----------
                to_number          to_char
*/

-- to_char(number, format) : char
-- 숫자에 형식부여
-- 9 : 해당자리의 숫자, 값이 없는 경우, 소수점 이상은 공백, 소수점 이하는 0으로 처리
-- 0 : 해당자리의 숫자, 값이 없는 경우, 소수점 이상, 소수점 이하 0으로 처리
-- format의 자릿수는 항상 실제값보다 커야함.
select
    to_char(123456789,'999,999,999'),
    to_char(123456789,'9,999'), -- #####
    to_char(123.456,'fm9,999.99999'), -- fm FM 포맷으로 생긴 앞쪽 공백 제거
    to_char(123.456,'0,000.00000'),
    to_char(123456, 'fmL9,999,999')
from
    dual;

-- to_char(date, format) : char
-- 형식문자는 대소문자 구분안함.
select
    sysdate,
    to_char(sysdate, 'yy-mm-dd hh24:mi'),
    to_char(sysdate, 'yyyy"년" mm"월" dd"일"(day)') -- 요일 d dy day모두 가능 . d 일(1) ~ 토(7)
from
    dual;
    
-- 사원테이블에서 사원명, 급여, 보너스율, 입사일 조회
-- 급여 : 세자리 콤마
-- 보너스율 : %로 표현
-- 입사일 : 년월일(요일)
select
    emp_name,
    to_char(salary, 'fml99,999,999') "급여",
--   nvl(to_char(bonus, 'fm99.9'), 0) || '%' "보너스율",
    to_char(nvl(bonus, 0) * 100) || '%' "보너스율", 
    to_char(hire_date, 'yyyy"년" mm"월" dd"일"(day)') "입사일"
from
    employee;
    
-- to_number(char, format) : number
select
    to_number('1,234,567', '9,999,999') + 1,
    to_number('￦123,456', 'fml9,999,999') + 1
--    '1,234,567' + 1    -- 01722. 00000 -  "invalid number" 오류
from
    dual;
    
-- to_date(char, format) : date
select
    to_date('19990909', 'yyyymmdd'),
    to_date('1990년 02월 06일(화요일)', 'yyyy"년"mm"월"dd"일"(day)'),
    -- yyyy | rrrr 네자리 년도 읽을때는 동일
    to_date('990909', 'yymmdd'), -- 현재세기 기준 (2000~2099사이)
    to_date('990909', 'rrmmdd') -- 이전세기 50 ~ 현재세기 49사이 (1950 ~ 2049사이)
from
    dual;
    
---------------------------------------------------
-- 기타 함수
---------------------------------------------------
-- null처리
-- nvl(value, null일때 값)
-- nvl2(value, null이 아닐때 값, null일때 값)
select
    emp_name,
    bonus,
    nvl2(bonus, '0', 'x') 보너스여부
from
    employee;
    
-- 선택함수
-- decode(expression, result1, value1, result2, value2, .... [, default value]) : value
-- 성별 조회
select
    emp_name,
    emp_no,
    decode(substr(emp_no, 8, 1), '1','남', '3', '남', '2', '여', '4', '여') gender,
    decode(substr(emp_no, 8, 1), '1','남', '3', '남', '여') gender,
    decode(substr(emp_no, 8, 1), '2', '여', '4', '여', '남') gender
from
    employee;

-- 직급명 조회
-- (job테이블 참고)
select * from job;

select
    emp_name,
    job_code,
    decode(job_code, 'J1', '대표', 'J2', '부사장', 'J3', '부장', 'J4', '차장', 'J5', '과장', 'J6', '대리', 'J7', '사원') 직급별
from
    employee;

-- case1 (decode와 동일)
/*
        case expression
            when result1 then value1
            when result2 then value2
            ...
            elsel default_value
        end
*/
select
    emp_name,
    emp_no,
    case substr(emp_no, 8, 1)
        when '1' then '남'
        when '2' then '여'
        when '3' then '남'
        when '4' then '여'
    end gender,
    case substr(emp_no, 8, 1)
        when '1' then '남'
        when '3' then '남'
        else '여'
    end gender,
    case substr(emp_no, 8, 1)
        when '2' then '여'
        when '4' then '여'
        else '남'
    end gender
from
    employee;
-- case2 (if else if와 비슷)

/*
    case
        when condition1 then value1
        when condition2 then value2
        ...
        [else default_value]
    end
*/
 
 select
    emp_name,
    emp_no,
    case
        when substr(emp_no, 8, 1) = '1' then '남'
        when substr(emp_no, 8, 1) = '2' then '여'
        when substr(emp_no, 8, 1) = '3' then '남'
        when substr(emp_no, 8, 1) = '4' then '여'
    end gender,
    case
        when substr(emp_no, 8, 1) in ('1', '3') then '남'
        else '여'
    end gender,
    case 
        when substr(emp_no, 8, 1) in ('2','4') then '여'
        else '남'
    end gender
from
    employee;
 
 -- 직급명 출력 J1 = 대표, J2/J3 = 임원, 나머지 평사원 출력
 select
    emp_name,
    job_code,
    case
        when job_code = 'J1' then '대표'
        when job_code in ('J2','J3') then '임원'
        else '평사원'
    end job
 from
    employee;
    
-- 나이계산
select
    emp_name,
    emp_no,
    to_date(substr(emp_no, 1, 2), 'yy'), -- 실패
    to_date(substr(emp_no, 1, 2), 'rr'), -- 실패
--    () age -- 현재년도 - 출생년도
    decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) birth_year,
    extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) age, -- 현재년도 - 출생년도
--    () 만나이 -- (현재날짜 - 생일) / 365, months_between(현재날짜, 생일) / 12
    floor (
            months_between(
                sysdate,
                (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) || (substr(emp_no, 3, 4)))) /12
            ) as "만나이"
from
    employee;
    
-- 단일행 함수 실습문제
-- 1. employee 테이블에서 남자만 사원번호, 사원명,주민번호, 연봉을 나타내세요. 단, 주민번호의 뒷 6자리는 *처리하세요.

select
    emp_id 사원번호,
    emp_name 사원명,
    substr(emp_no, 0, 8) || '******' 주민번호,
    salary 연봉
from
    employee
where
        substr(emp_no, 8, 1) in ('1','3');
        
-- 2. 파일경로를 제외하고 파일명만 아래와 같이 출력하세요.
-- 테이블/데이터 설정
create table tbl_files (
	fileno number(3)
  ,filepath varchar2(500)
);
insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
insert into tbl_files values(2, 'c:\music.mp3');
insert into tbl_files values(3, 'c:\documents\resume.hwp');
commit;
select * from tbl_files;

select
   rpad(fileno,1) 파일번호,
   substr(filepath, instr(filepath, '\', -1)  + 1) 파일명
from
    tbl_files;

commit;