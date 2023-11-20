--========================================
-- 춘대학 학사관리 시스템
--========================================
select * from tb_department;
select * from tb_student;
select * from tb_class;
select * from tb_professor;
select * from tb_class_professor;
select * from tb_grade;

-------------------------------------------
-- 춘 대학 basic select 실습문제
-------------------------------------------
-- 1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 한다.
select
    department_name as "학과 명",
    category 계열
from
    tb_department;
    
-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
select
    department_name || '의 정원은 ' || capacity || '명 입니다.' as "학과별 정원"
from
    tb_department;
    
-- 3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 누구인가?
-- (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
select
    student_name 
from
    tb_student
where
    department_no = 001
    and absence_yn = 'Y'
    and substr(student_ssn, 8, 1) in ('2','4');
    
-- 4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 
--그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 sql 구문을 작성하시오.
select
    student_name
from
    tb_student
where
    student_no = 'A513079'
    or student_no = 'A513090'
    or student_no = 'A513091'
    or student_no = 'A513110'
    or student_no = 'A513119'
order by
    1 desc;

-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오.
select
    department_name,
    category
from
    tb_department
where
    capacity >= 20
    and capacity <= 30
order by
     2 asc, 1 asc;
     
-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속학과를 가지고 있다.
-- 그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 sql 문장을 작성하시오.
select
    professor_name
from
    tb_professor
where
    department_no is null;
    
-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
-- 어떠한 sql 문장을 사용하면 될 것인지 작성하시오.
select
    student_name
from
    tb_student
where
    department_no is null;
    
-- 8. 수강 신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수 과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오
select
    class_no
from
    tb_class
where
    preattending_class_no is not null;
    
-- 9. 춘 대학에는 어떤 계열(category)들이 있는지 조회해보시오.
select distinct
    category
from
    tb_department
order by
 1 asc;

-- 10. 02 학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
select
    student_no,
    student_name,
    student_ssn
from
    tb_student
where
    absence_yn = 'N'
    -- entrance_date는 date형식이기 때문에 형변환을 해줘야 됨
    and substr(to_char(entrance_date, 'yyyy'), 3, 2) = '02'
    and student_address like '%전주%'
order by
    2 asc;
    
select * from tb_department;
select * from tb_student;
select * from tb_class;
select * from tb_professor;
select * from tb_class_professor;
select * from tb_grade;

-----------------------------------------------------
-- 춘 대학 Additional Select 함수 실습문제2
-----------------------------------------------------
-- 1. 영어영문학과 (학과코드 002) 학생들의 학번과 이름, 입학년도를 입학 년도가 빠른 순으로 표시하는 sql 문장을 작성하시오
-- (단, 헤더는 "학번", "이름", "입학년도"가 표시되도록 한다.)
select
    student_no 학번,
    student_name 이름,
    to_char(entrance_date, 'yyyy-mm-dd') 입학년도
from
    tb_student
where
    department_no = '002'
order by
    3 asc;
    
-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 sql 문장을 작성해 보자.
-- (* 이때 올바르게 작성한 sql 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)
select
    professor_name,
    professor_ssn
from
    tb_professor
where 
    professor_name not like  '___';
    
-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 sql문장을 작성하시오. 단 이때 나이가 적은 사람에서 많은 사람 순서로
-- 화면에 출력되도록 만드시오. (단, 교수 중 2000년 이후 출생자는 없으며  출력 헤더는 "교수이름", "나이"로 한다. 나이는 '만'으로 계산한다.
select
    professor_name 교수이름,
     trunc(
        months_between(
            sysdate, 
            to_date((decode(substr(professor_ssn,8,1),'1',1900,'2',1900)+substr(professor_ssn,1,2)) || substr(professor_ssn,3,4), 'yyyymmdd')
        ) / 12
    ) 나이
from
    tb_professor
where
    substr(professor_ssn, 8, 1) in ('1','3')
order by
    2 asc;

-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 sql 문장을 작성하시오.
-- 출력 헤더는 "이름" 이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정하시오)
select
    substr(professor_name,2) 이름
from
    tb_professor;

-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.
select
    student_no,
    student_name
from
    tb_student
where
    (to_number (substr(entrance_date,3,2), '999') + decode(substr(entrance_date,1,1),'1',1900,'2',2000)) -
    (to_number(substr(student_ssn,1,2), '999') +1900) >= 20;
    
-- 6. 2020년 크리스마스는 무슨 요일인가?
select
  case to_char(to_date('201225','yymmdd'), 'D')
    when '1' then '일요일'
    when '2' then '월요일'
    when '3' then '화요일'
    when '4' then '수요일'
    when '5' then '목요일'
    when '6' then '금요일'
    when '7' then '토요일'
  end as 요일
from dual;

-- 7. to_date('99/10/11', 'YY/MM/DD'), to_date('49/10/11', 'YY/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까?
-- 또 to_date('99/10/11', 'RR/MM/DD'), to_date('49/10/11', 'RR/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미할까?

-- yy 현재세기 기준 (2000~2099사이)
-- rr 이전세기 50 ~ 현재세기 49사이 (1950 ~ 2049사이)
-- yy, rr 차이를 물어보는 문제
select
    to_date('991011', 'yy/mm/dd'), -- 2099년 10월 11일
    to_date('991011', 'rr/mm/dd'), -- 1999년 10월 11일
    to_date('491011', 'yy/mm/dd'), -- 2049년 10월 11일
    to_date('491011', 'rr/mm/dd') -- 2049년 10월 11일
from
    dual;
    
-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작되게 되어있다. 2000년도 이전 학번을 받은 학생들의 학번과 이름을
-- 보여주는 sql 문장을 작성하시오
select
    student_no,
    student_name
from
    tb_student
where
    substr(student_no,1,1) not like ('A');
    
-- 9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 sql문을 작성하시오.
-- 단, 이때 출력 화면의 헤더는 "평점"이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
select
   round(avg(point),1) 평점
from
    tb_grade
where 
    student_no = 'A517178';

-- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)"의 형태로 헤더를 만들어 결과 값이 출력되도록 하시오.
select distinct
    d.department_no 학과번호,
    count(*) as "학생수(명)"
from
    tb_department d join tb_student s
        on d.department_no = s.department_no
group by
    d.department_no
order by
    1 asc;

-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 sql문을 작성하시오.
select
    count(*)
from
    tb_student
where
    coach_professor_no is null;

-- 12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 sql문을 작성하시오. 단, 이때 출력 화면의 헤더는
-- "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
select 
    substr(term_no,1, 4) "년도",
    round(avg(point),1) as "년도 별 평점"
from
    tb_student s join tb_grade g
        on s.student_no = g.student_no
where
    s.student_no like 'A112113'
group by
    substr(term_no,1, 4);
    
-- 13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 sql문장을 작성하시오
select
    department_no 학과코드명,
    sum(decode(absence_yn, 'Y', 1, 'N', 0)) "휴학생 수"
from
    tb_student
group by
    department_no
order by
    1 asc;

-- 14.  춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다. 어떤 sql문장을 사용하면 가능하겠는가?
select
    student_name 동일이름,
    count(*) as "동명인 수"
from
    tb_student
group by
    student_name
having
    count(*) >= '2'
order by 
    1 asc;

-- 15. 학번이 A112113인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점, 총 평점을 구하는 sql문을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
select 
    substr(term_no,1, 4) 년도,
    nvl(substr(term_no,5,2), ' ') 학기,
    round(avg(point),1)  평점
from
    tb_student s join tb_grade g
        on s.student_no = g.student_no
where
    s.student_no like 'A112113'
group by
    rollup(substr(term_no,1, 4), substr(term_no,5,2))
order by
    1 asc;
    
----------------------------------------------
-- 조인 실습문제@chun
----------------------------------------------
-- 1. 학번, 학생명, 계열, 학과명 조회 (학과 지정이 안된 학생은 존재하지 않는다.)
select
    s.student_no 학번,
    s.student_name 학생명,
    d.category 계열,
    d.department_name 학과명
from
    tb_student s join tb_department d
        on s.department_no = d.department_no;

-- 2. 수업번호, 수업명, 교수번호, 교수명 조회 (교수/수업이 모두 지정된 수업만 조회)
select
    c.class_no 수업번호,
    c.class_name 수업명,
    p.professor_no 교수번호,
    p.professor_name 교수명
from
    tb_class c join tb_class_professor cp
        on c.class_no = cp.class_no
    join tb_professor p
        on cp.professor_no = p.professor_no;

-- 3. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select
    -- 좀 더 알아보기 쉽게 년도도 추가했다.
    substr(term_no,1,4) 년도,
    substr(term_no,5,2) 학기,
    s.student_no 학번,
    s.student_name 학생명,
    c.class_name 수업명,
    g.point 점수
from
    tb_class c join tb_grade g
        on c.class_no = g.class_no
    join tb_student s
        on g.student_no = s.student_no
where
    s.student_name = '송박선';
    
-- 4. 학생별 전체 평점(소수점 이하 첫째자리 버림)조회 (학번, 학생명, 평점) 같은 학생이 여러학기에 걸쳐 같은 과목을 이수한 데이터 있으나,
-- 전체 평점으로 계산함
select
    s.student_no 학번,
    s.student_name 학생명,
    trunc(avg(g.point),1) 평점
from
    tb_student s join tb_grade g
        on s.student_no = g.student_no
group by
    s.student_no, s.student_name;
    
-- 5. 교수번호, 교수명, 담당학생명수 조회 (단, 5명 이상의 학생을? 담당하는 교수만 출력)
select
    p.professor_no 교수번호,
    p.professor_name 교수명,
    count(*)  as "담당 학생 수"
from
    tb_student s join tb_professor p
        on s.coach_professor_no = p.professor_no
group by
    p.professor_no, p.professor_name
having 
    count(s.coach_professor_no) >= 5;
    
-- 6. 선수과목이 있는 수업만 조회 (수업번호/수업명/선수과목번호/선수과목명)
-- ex1) 조인 문제라 셀프 조인을 사용해보았다. 선수 과목 번호를 이용해서 조인 했는데 내부조인시 null값은 나오지 않는 특징을 이용했다.
select
    "c1".class_no 수업번호,
    "c1".class_name 수업명,
    "c1".preattending_class_no 선수과목번호,
    "c2".class_name 선수과목명
from
    tb_class "c1" join tb_class "c2"
        on "c1".preattending_class_no = "c2".class_no;

---------------------------------------------------------------------
-- 2023-10-25
-- 춘대학 AdditionalSelectOption 실습문제3
---------------------------------------------------------------------
-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록한다.
select
    student_name as "학생 이름"
    , student_address 주소지
from
    tb_student
order by
    1 asc;

-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오
select
    student_name
    , student_ssn
from
    tb_student
where
    absence_yn = 'Y'
order by
    2 desc;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오.
-- 단, 출력헤더는 "학생 이름", "학번", "거주지 주소"가 출력되도록 한다.
select
    student_name 학생이름
    , student_no 학번
    , student_address "거주지 주소"
from
    tb_student
where
    (student_address like ('%강원도%')
    or student_address like ('%경기도%'))
    and substr(student_no,1,2) between '90' and '99'
order by
    1 asc;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 sql문장을 작성하시오.
-- (법학과의 '학과코드'는 학과 테이블(tb_department)을 조회해서 찾아내도록 하자.)
select
    professor_name
    , professor_ssn
from
    tb_department d join tb_professor p
        on d.department_no = p.department_no
where
    department_name = '법학과'
order by
    2 asc;

-- 5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다.
-- 학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오
select
    s.student_no
    , g.point
from
    tb_grade g join tb_student s
        on g.student_no = s.student_no
where
    term_no ='200402'
    and class_no = 'C3118100'
order by
    2 desc, 1 asc;

--6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 sql문을 작성하시오.
select
    student_no
    , student_name
    , (select department_name from tb_department where department_no = s.department_no) DEPARTMENT_NAME
from
    tb_student s
order by
    substr(student_name, 2) asc; -- 이름 기준
    
-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 sql문장을 작성하시오.
select
    class_name
    , department_name
from
    tb_class c join tb_department d
        on c.department_no =d.department_no;
        
-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 sql문을 작성하시오
select
   class_name 
   , professor_name
from
    tb_class_professor cp join tb_class c
        on cp.class_no = c.class_no
    join tb_professor p
        on cp.professor_no = p.professor_no;

-- 9. 8번의 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다.
-- 이에 해당하는 과목 이름과 교수 이름을 출력하는 sql문을 작성하시오.
select
   class_name 
   , professor_name
from
    tb_class_professor cp join tb_class c
        on cp.class_no = c.class_no
    join tb_professor p
        on cp.professor_no = p.professor_no
    join tb_department d
        on p.department_no = d.department_no
where
    category = '인문사회';

-- 10. '음악학과' 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 sql 문장을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
select
    s.student_no 학번
    , s.student_name "학생 이름"
    , round(avg(point), 1) "전체 평점"
from
    tb_student s join tb_grade g
        on s.student_no = g.student_no
    join tb_department d
        on s.department_no = d.department_no
where
    department_name = '음악학과'
group by
    s.student_no, s.student_name;

-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다.
-- 이때 사용할 sql문을 작성하시오.
select
    (select department_name from tb_department where department_no = s.department_no) "학과 이름"
    , student_name "학생 이름"
    , (select professor_name from tb_professor where professor_no = s.coach_professor_no) "지도 교수 이름"
from
    tb_student s
where
    student_no = 'A313047';
    
-- 12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 sql문장을 작성하시오.
select
    student_name
    , term_no
from
    tb_grade g join tb_student s
            on g.student_no = s.student_no
where
    substr(term_no,1,4) = '2007'
    and (select class_name from tb_class where class_no = g.class_no) = '인간관계론';

-- 13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을
-- 출력하는 sql문장을 작성하시오.
select
    c. class_name
    , d.department_name
from
    tb_department d left join tb_class c
        on d.department_no = c.department_no
    left join tb_class_professor cp
        on c.class_no =cp.class_no
where
    d.category = '예체능'
    and cp.class_no is null;
  
-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다.
-- 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정"으로 표시하도록
-- 하는 sql문을 작성하시오. 단, 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
select
    student_name 학생이름
    , nvl(p.professor_name, '지도교수 미지정') 지도교수
from
    tb_student s 
        left join tb_professor p
            on s.coach_professor_no = p.professor_no
        join tb_department d
            on s.department_no = d.department_no
where
    department_name = '서반아어학과';

-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 sql문을 작성하시오.
select
    s.student_no 학번
    , s.student_name 이름
    , d.department_name "학과 이름"
    , round(avg(g.point),1) 평점
from
    tb_student s left join tb_department d
        on s.department_no = d.department_no
    join tb_grade g
        on s.student_no = g.student_no
where
    absence_yn = 'N'
group by
    s.student_no
    , student_name
    , department_name
having
    avg(g.point) >= 4.0
order by
    1 ;

-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL문을 작성하시오.
select distinct
    c.class_no
    , c.class_name
    , round(avg(point)over(partition by c.class_no),1) as "AVG(POINT)"
from
    tb_class c join tb_grade g
        on c.class_no = g.class_no
where
    (select department_name from tb_department where department_no = c.department_no) = '환경조경학과'
    and class_type like '전공%';
    
-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL문을 작성하시오.
select
    student_name
    , student_address
from
    tb_student
where
    department_no = (select department_no from tb_student where student_name = '최경희');

-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 sql문을 작성하시오.
select
    student_no
    , student_name
from(
        select distinct
            s.student_no
            , s.student_name
            , avg(point) over(partition by s.student_no)
        from
            tb_student s join tb_grade g
                on s.student_no = g.student_no
        where
            department_no in (select department_no from tb_department where department_name = '국어국문학과')
        order by
            3 desc
)
where
    rownum = 1;
    
-- 19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL문을 찾아내시오.
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고,
-- 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
select distinct
    department_name as "계열 학과명"
    , round(avg(point) over(partition by department_name), 1) 전공평점
from
    tb_department d
        join tb_class c
            on d.department_no = c.department_no
        join tb_grade g
            on c.class_no = g.class_no
where
    category in (select category from tb_department where department_name = '환경조경학과');



-- 자연과학

select * from tb_department;
select * from tb_student;
select * from tb_class;
select * from tb_professor;
select * from tb_class_professor;
select * from tb_grade;


-----------------------------------------------------------------
-- 2023-10-26
-- 춘대학 DDL/DML 실습문제4
-----------------------------------------------------------------
-- DDL
-----------------------------------------------------------------
-- 1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
create table tb_category (
        name varchar2(10)
        , use_yn char(1) default 'Y'
);
desc tb_category;

-- 2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
create table tb_class_type (
        no varchar2(5) primary key
        , name varchar2(10)
);
desc tb_class_type;

-- 3. tb_category 테이블의 name 컬럼에 primary key를 생성하시오.
-- (key 이름을 생성하지 않아도 무방함. 만일 key 이름을 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.)
alter table tb_category add constraints pk_tb_category_name primary key(name);
select * from user_constraints where table_name = 'TB_CATEGORY';

-- 4. tb_class_type 테이블의 name 컬럼에 null 값이 들어가지 않도록 속성을 변경하시오.
alter table tb_class_type modify name not null;

-- 5. 두 테이블에서 컬럼 명이 NO인 것은 기존 타입을 유지하면서 크기는 10으로, 컬럼명이 name인 것은 
-- 마찬가지로 기존 타입을 유지하면서 크기 20으로 변경하시오.
alter table tb_category modify name varchar2(20);

alter table tb_class_type modify name varchar2(20);
alter table tb_class_type modify no varchar2(10);

-- 6. 두 테이블의 NO 컬럼과 Name 컬럼의 이름을 각각 TB_를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.
-- (ex. CATEGORY_NAME)
alter table tb_category rename column name to category_name;

alter table tb_class_type rename column no to class_type_no;
alter table tb_class_type rename column name to class_type_name;

-- 7. tb_category 테이블과 tb_class_type 테이블의 primary key 이름을 다음과 같이 변경하시오.
-- primary key의 이름은 "PK_ + 컬럼이름"으로 지정하시오. (ex. PK_CATEGORY_NAME)
alter table tb_category rename constraints PK_TB_CATEGORY_NAME to PK_CATEGORY_NAME;

alter table tb_class_type rename constraints SYS_C008473 to pk_class_type_no;

-- 8. 다음과 같은 insert문을 수행한다.
insert into tb_category values ('공학', 'Y');
insert into tb_category values ('자연과학', 'Y');
insert into tb_category values ('의학', 'Y');
insert into tb_category values ('예체능', 'Y');
insert into tb_category values ('인문사회', 'Y');
commit;

-- 9. tb_department의 category 컬럼이 tb_category테이블의 category_name컬럼을 부모값으로 참조하도록
-- foreign key를 지정하시오. 이 때 key 이름은 fk_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY)
-- tb_category - 부모
-- tb_department - 자식
alter table tb_department add constraints fk_department_category foreign key(category) references tb_category(category_name);

-- 10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 view를 만들고자 한다.
-- 아래 내용을 참고하여 적절한 SQL문을 작성하시오.
grant create view to chun;

create or replace view vw_학생일반정보 
as
select
   student_no 학번
   , student_name 학생이름
   , student_address 주소
from
    tb_student;

-- 11. 춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도면담을 진행한다.
-- 이를 위해 사용할 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 view를 만드시오.
-- 이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오
-- (단, 이 view는 단순 select만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
create or replace view vw_지도면담
as
select
    student_name 학생이름
    , (select department_name from tb_department where department_no = s.department_no) 학과이름
    , (select professor_name from tb_professor where professor_no = s.coach_professor_no) 지도교수이름
from
    tb_student s
order by
    2 asc;

-- 12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 view를 작성해 보자.
create or replace view vw_학과별학생수
as
select
    department_name
    , count(*) STUDENT_COUNT
from
    tb_student s join tb_department d
        on s.department_no = d.department_no
group by
    department_name;

-- 13. 위에서 생성한 학생일반정보 view를 통해서 학번이 A213046인 학생의 이름을 본인 이름으로 변경하는 SQL문을 작성하시오.
update
    vw_학생일반정보
set
    학생이름 = '서가람'
where
    학번 = 'A213046';
-- 확인    
select 학생이름 from vw_학생일반정보; where 학번 = 'A213046';
    
-- 14. 13번에서와 같이 view를 통해서 데이터가 변경될 수 있는 상황을 막으려면 view를 어떻게 생성해야 하는지 작성하시오.
create or replace view vw_학생일반정보 
as
select
   student_no 학번
   , student_name 학생이름
   , student_address 주소
from
    tb_student
with read only; -- view 생성시 with read only를 붙여주면 된다.

-- 15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 
-- 최근 3년을 기준으로 수강인원이 가장 많았던 3과목을 찾는 구문을 작성해보시오.
select 
    *
from (
        select 
            class_no 과목번호, 
            class_name 과목이름, 
            count(student_no) "수강생수(명)"
        from tb_class 
            join tb_grade  
                using (class_no)
        where 
            substr(term_no, 1, 4) in ( 
                                        select 년도
                                        from (
                                                select distinct substr(term_no, 1, 4) 년도
                                                from tb_grade
                                                order by 1 desc
                                            )
                                        where rownum <= 5
                                    )
        group by class_no, class_name
        order by 3 desc, 1)
where rownum <= 3;
    
---------------------------------------------------------------------
-- DML
---------------------------------------------------------------------
-- 1. 과목유형 테이블 (tb_class_type)에 아래와 같은 데이터를 입력하시오.
insert into tb_class_type values ('01', '전공필수');
insert into tb_class_type values ('02', '전공선택');
insert into tb_class_type values ('03', '교양필수');
insert into tb_class_type values ('04', '교양선택');
insert into tb_class_type values ('05', '논문지도');

-- 2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다.
-- 아래 내용을 참고하여 적절한 SQL문을 작성하시오. (서브쿼리를 이용하시오.)
create table tb_학생일반정보 
as
select
    student_no 학번
    , student_name 학생이름
    , student_address 주소
from
    tb_student;

-- 3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다.
-- 아래 내용을 참고하여 적절한 SQL문을 작성하시오.
-- (힌트 : 방법은 다양함, 소신껏 작성하시오.)
create table tb_국어국문학과
as
select
    s.student_no 학번
    , s.student_name 학생이름
    , (decode(substr(student_ssn, 8, 1), '1', 1900, '2', 1900, 2000) + substr(student_ssn, 1, 2)) 출생년도
    , (select professor_name from tb_professor where professor_no = s.coach_professor_no) 교수이름
from
    tb_student s
where
    department_no = '001';

drop table tb_국어국문학과;

-- 4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용할 SQL문을 작성하시오.
-- (단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다.)
create table tb_department_ex 
as
select * from tb_department;

update tb_department_ex
set capacity = round(capacity * 1.1);

select * from tb_department_ex;

-- 5. 학번 A413042인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21"로 변경되었다고 한다.
-- 주소지를 정정하기 위해 사용할 SQL문을 작성하시오.
-- 기존 테이블이 변경되는걸 방지하기 위해 tb_학생일반정보를 이용하겠습니다.

update tb_학생일반정보
set
    주소 = '서울시 종로구 숭인동 181-21'
where
    학번 = 'A413042';

select * from tb_학생일반정보 where 학번 = 'A413042';

-- 6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다..
-- 이 내용을 반영할 적절한 SQL문장을 작성하시오.
create table tb_student_ex 
as
select * from tb_student;

update
   tb_student_ex 
set
    student_ssn = substr(student_ssn,1,6);

-- 7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강한 '피부생리학' 점수가 잘못되었다는 것을 발견하고는 정정을 요청하였다.
-- 담당 교수의 확인 받은 결과 해당 과목의 학점을 3.5로 변경시키기로 결정되었다. 적절한sql문을 작성하시오.
create table tb_grade_ex
as
select * from tb_grade;

update
    tb_grade_ex
set
    point = '3.5'
where
    student_no in (select student_no from tb_student_ex where student_name = '김명훈' 
    and department_no = (select department_no from tb_department_ex where department_name = '의학과' ))
    and term_no = '200501'
    and class_no in (select class_no from tb_class where class_name = '피부생리학');

-- 8. 성적 테이블(tb_grade_ex)에서 휴학생들의 성적항목을 제거하시오.

delete from 
    tb_grade_ex 
where 
    student_no in (select student_no from tb_student where absence_yn = 'Y');
-- 제약조건 확인
select * from user_constraints where table_name = 'TB_CATEGORY';
select * from user_constraints where table_name = 'TB_CLASS_TYPE';
select * from user_constraints where table_name = 'TB_DEPARTMENT';
select * from user_constraints where table_name = 'TB_STUDENT';

-- 타입 확인
desc tb_category;
desc tb_class_type;

-- DDL 생성 테이블/뷰
select * from tb_category;
select * from tb_class_type;
select * from vw_학생일반정보;
select * from vw_지도면담;
select * from vw_학과별학생수;
select * from tb_학생일반정보;
select * from tb_국어국문학과;
select * from tb_department_ex;
select * from tb_student_ex;
select * from tb_grade_ex;

-- 기존 춘 테이블
select * from tb_department;
select * from tb_student;
select * from tb_class;
select * from tb_professor;
select * from tb_class_professor;
select * from tb_grade;

commit;