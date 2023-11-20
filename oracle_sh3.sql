-- 2023-10-19(목요일) 3일차

-------------------------------------------
-- 그룹행 함수
-------------------------------------------
-- 그룹당 한번 처리되는 함수
-- group by구문이 없다면 모든 행이 하나의 그룹으로 간주된다.

-- sum(value)
-- 존재하는 컬럼/가상컬럼의 행별 합계 반환
select * from employee;

select
-- emp_name, -- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다
    sum(salary) 급여합,
    sum(salary + (salary * nvl(bonus, 0))) 실급여합
from
    employee;
    
-- avg(value)
select
    floor(avg(salary))
from
    employee;
    
-- 남자 사원의 총급여
select
    sum(salary) 남자사원총급여
from
    employee
where   
    substr(emp_no, 8, 1) in ('1','3');
    
-- count(value)
-- null이 아닌 행의 수를 반환
select
    count(*) , -- 전체 행수
    count(bonus) -- bonus가 null이 아닌 행수
from
    employee;
    
-- 부서가 지정된 사원수를 조회
select
    count(dept_code) as "부서가 지정된 사원 수"
from
    employee;

select
   count(*) as "부서가 지정된 사원 수"
from
    employee
where
    dept_code is not null;
    
-- sum을 이용해서 처리하기
-- 1. dept_code가 null이 아닌경우 1, null인 경우 0을 부여하는 가상컬럼
-- 2. 가상 컬럼 sum을 구하기
select
    sum(
        case
            when dept_code is not null then 1
            else 0
        end
    ) as "부서가 지정된 사원",
     sum(
        case
            when dept_code is null then 1
            else 0
        end
    )  as "부서가 지정되지 않은 사원"
from
    employee;
    
-- max(value)
-- min(value)
select
    max(salary),
    min(salary),
    max(hire_date),
    min(hire_date),
    max(emp_name),
    min(emp_name)
from
    employee;
    
--===============================================
-- DQL2
--===============================================
-- group by 그룹핑기준
-- having 조건절 - 그룹핑 이후에 필터링

--------------------------------------------------------------
-- GROUP BY
--------------------------------------------------------------
-- 존재하는 컬럼/가상컬럼 기준으로 행을 그룹핑할 수 있다
-- 그룹함수와 함께 사용.
-- group by와 관계없는 일반행의 컬럼을 동시에 조회할 수 없다.

-- 부서별 평균급여
select
    dept_code, -- group by에 명시한 컬럼만 작성가능
--    emp_name, --ORA-00979: GROUP BY 표현식이 아닙니다.
    floor(avg(salary))
from
    employee
group by
    dept_code
order by
    dept_code;
    

-- 직급별 평균급여, 인원수를 조회
select
    job_code 직급,
   to_char(floor(avg(salary)), 'fml9,999,999') 평균급여,
    count(*) 인원수
from
    employee
group by
    job_code
order by
    1 ;
    
-- 부서별 인원수, 보너스를 받는 인원수 조회 (부서지정이 안된 경우, "인턴"이라고 표시)
select
    nvl(dept_code, '인턴'),
    count(*),
    count(bonus)
from
    employee
group by
    dept_code
order by
    1;
    
-- group by 가상컬럼 가능
-- 입사년도별 사원수 조회
select
    emp_name,
    extract(year from hire_date) hire_year
from
    employee;

select
    extract(year from hire_date) hire_date,
    count(*)
from
    employee
group by
    extract(year from hire_date)
order by
    hire_date;
    
 -- 성씨별 인원수 조회 (1글자 성만 존재함)
 select
    substr(emp_name, 1, 1) 성씨,
    count(substr(emp_name, 1, 1)) as "성씨별 인원수"
 from
    employee
group by
    substr(emp_name, 1, 1)
order by
    1;
 
-- group by 컬럼1, 컬럼2....
-- 컬럼1, 컬럼2의 값을 동시에 그룹핑에 사용 (컬럼순서 상관없음)

-- 부서별 직급별 인원수 조회
select
    dept_code,
    job_code,
    count(*)
from
    employee
group by
    dept_code, job_code -- 나열한 순서는 상관이 없다.
order by    
    1, 2;
    
-- 부서별 성별 인원수 조회
select
    dept_code,
    case
        when substr(emp_no, 8, 1) in ('1','3') then '남'
        else '여'
    end,
    count(*)
from
    employee
group by
    dept_code,
    case
        when substr(emp_no, 8, 1) in ('1','3') then '남'
        else '여'
    end
order by
    1;
    
-------------------------------------------------
-- HAVING
-------------------------------------------------
-- 그룹핑된 결과에 대해서 필터링 처리
-- 조건절이므로 boolean을 반환하는 식을 작성

-- 부서별 급여평균 조회 (300만원 이상인 부서만 출력)
select
    dept_code,
    floor(avg(salary))
from
    employee
--where
--    avg(salary) > 3000000 --ORA-00934: 그룹 함수는 허가되지 않습니다
group by
    dept_code
having
    avg(salary) > 3000000
order by
    1;
    
-- 부서별 인원수가 3명보다 많은 부서 조회(인원수 내림차순)
select
    dept_code,
    count(*)
from
    employee
group by
    dept_code
having
    count(dept_code) > 3
order by
    1;
    
-- 부서별 직급별 인원수가 3명 이상인 경우만 조회
select
    dept_code,
    job_code,
    count(*)
from
    employee
group by
    dept_code, job_code
having
    count(*) >= 3
order by
    2 desc;
    
-- 관리하는 사원이 2명이상인 매니저의 사원아이디와 관리하는 사원수 조회
select * from employee;

select
    manager_id,
    count(*)
from
    employee
where
    manager_id is not null
group by
    manager_id
having
    count(*) >= 2
order by
    1;

select
    manager_id,
    count(*)
from
    employee
group by
    manager_id
having
    count(manager_id) >= 2
order by
    1;

-- rollup/cube 소계
-- rollup : group by 결과에 추가적으로 단방향 소계 지원
-- cube : group by 결과에 추가적으로 양방향 소계 지원

-- 부서별 인원수 조회
select
    dept_code,
    grouping(dept_code), -- 실제데이터 0, 소계데이터 1
    decode(grouping(dept_code), 0, nvl(dept_code,'인턴'), 1, '총계') dept_code,
    count(*)
from
    employee
group by
    rollup(dept_code)
order by
    1;

-- 부서별 직급별 인원수 조회 (소계포함)
select
    dept_code, job_code,
    count(*)
from
    employee
group by
    rollup(dept_code, job_code)
order by
    1, 2;

commit;

-- 그룹함수 실습문제

-- 1. EMPLOYEE 테이블에서 여자사원의 급여 총 합을 계산
select
    sum(salary)
from
    employee
where
    substr(emp_no, 8, 1) in ('2','4');
-- 2. 부서코드가 D5인 사원들의 급여총합, 보너스 총합 조회
select
    sum(salary) D5급여합,
    sum(salary * nvl(bonus, 0)) as "D5 보너스 총합"
from
    employee
where
    dept_code = 'D5';
-- 3. 부서코드가 D5인 직원의 보너스 포함 연봉의 총합 을 계산
select
    sum(salary + (salary * nvl(bonus,0)))*12 as "보너스 포함 연봉"
from
    employee
where
    dept_code = 'D5';
-- 4. 남/여 사원 급여합계를 동시에 표현(가공된 컬럼의 합계)
select
    decode(substr(emp_no, 8, 1), '1','남', '3', '남','여') as "남여 별",
    sum(salary)
from
    employee
group by
    decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여');

select
    sum (decode(substr(emp_no, 8, 1), '1',salary, '3', salary)) "남자사원급여",
    sum (decode(substr(emp_no, 8, 1), '2',salary, '4', salary)) "여자사원급여"
from
    employee;
-- 5. 사원들이 속해있는 부서의 수를 조회 (NULL은 제외하고, 중복된 부서는 하나로 카운팅)
select  
    count(distinct dept_code)
from
    employee;
    
-- 1. EMPLOYEE 테이블에서 직급이 J1을 제외하고, 직급별 사원수 및 평균급여를 출력하세요.
select
    job_code,
    trunc(avg(salary))
from
    employee
where
    job_code != 'J1'
group by
    job_code
order by
    1;
-- 2. EMPLOYEE테이블에서 직급이 J1을 제외하고, 입사년도별 인원수를 조회해서, 입사년 기준으로 오름차순 정렬하세요.
select
--    hire_date,
    extract(year from hire_date),
    count(*)
from
    employee
where
    job_code != 'J1'
group by
    extract(year from hire_date)
order by
    1;
-- 3. 성별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬 하시오.
select 
	decode(substr(emp_no, 8, 1), 1, '남', 3,'남', '여') as 성별, 
	trunc(avg(salary)) as 평균,
	sum(salary) as 합계,
	count(*) as 인원수
from 
	employee
group by 
	decode(substr(emp_no, 8, 1), 1, '남', 3,'남', '여')
order by 
	인원수 desc;
-- 4. 직급별 인원수가 3명이상이 직급과 총원을 조회
select
	nvl(job_code, '총원') job_code,
	count(*)
from
	employee
group by 
	cube(job_code)
having 
	count(*) >= 3
order by
	2;
    
--=================================================
-- JOIN
--=================================================
-- 두 개 이상의 테이블 레코드(행)를 연결해서 하나의 가상테이블(relation)을 생성
-- 데이터는 서로 연관성을 가지고 독립적으로 존재 (테이블 정규화)

select * from employee;
select * from department;

-- relation을 만드는 2가지 방법
-- 1. join : 특정컬럼 기준으로 행과 행을 합치는 기술
-- 2. 집합연산(union) : 열과 열을 합치는 기술

-- join 구분하기
-- 1. equi join 동등비교에 의한 조인 (조인 조건에 = 연산자 사용)
-- 2. non-equi join 동등 비교를 사용하지 않은 조인 (조인 조건에 !=, between and, in 등 연산자 사용)

-- equi-join 구분
-- 1. 내부조인
-- 2. 외부조인 - 좌외부조인, 우외부조인
-- 3. 크로스조인
-- 4. 자가조인
-- 5. 다중조인

-- join 문법
-- 1. ANSI 표준문법 join on (using)
-- 2. Oracle 전용문법 , (+)

-- 송종기 사원의 부서명 조회
select dept_code from employee where emp_name = '송종기';
select dept_title from department where dept_id = 'D9';

select
    *
from
    employee  join department 
        on employee.dept_code = department.dept_id
where
    employee.emp_name = '송종기';

-- 테이블 별칭
select
    *
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    e.emp_name = '송종기';
    
    
-- [oracle 전용문법]
select
    *
from
    employee e, department d
where
    e.dept_code = d.dept_id
    and
    e.emp_name = '송종기';
    
-----------------------------------------------------
-- INNER JOIN
-----------------------------------------------------
-- 기본 join, 두 테이블간의 공통된 부분만 결과집합에 포함된다. (교집합)
-- 조인 기준 컬럼값이 null이거나, 상대 테이블에 매칭되는 행이 없다면 제외.
-- inner는 생략 가능
-- join 키워드 기준으로 좌우 테이블이 바뀌어도 결과는 같다.
select * from employee; -- 24
select * from department; --9
select * from job;
select* from location;
select * from nation;
select * from sal_grade;

-- employee.dept_code = department.dept_id
select
    *
from
    employee e inner join department d
        on e.dept_code = d.dept_id; -- 22 (employee - 2, department - 3)
        
-- [oracle 전용문법]
select
    *
from
    employee e, department d
where
    e.dept_code = d.dept_id;
    


-- employee.job_code = job.job_code
select
    *
from
    employee e inner join job j
        on e.job_code = j.job_code;
        
-- [oracle 전용문법]
select
    *
from
    employee e, job j
where
    e.job_code = j.job_code;
    

-- employee.sal_level = sal_grade.sal_level
select
    *
from
    employee e inner join sal_grade s
        on e.sal_level = s.sal_level;  
        
-- [oracle 전용문법]
select
    *
from
    employee e, sal_grade s
where
    e.sal_level = s.sal_level;

-- department.location_id = location.local_code
select
    *
from
    department d inner join location l
        on d.location_id = l.local_code;
        
-- [oracle 전용문법]
select
    *
from
    department d, location l
where
    d.location_id = l.local_code;
    
    
-- location.national_code = nation.national_code
select
    *
from
    location l inner join nation n
        on l.national_code = n.national_code;
        
-- [oracle 전용문법]
select
    *
from
    location l, nation n
where
    l.national_code = n.national_code;

--------------------------------------------------------------
-- OUTER JOIN
--------------------------------------------------------------
-- 외부조인
-- outer 키워드 생략 가능
-- outer left join : inner join + 좌측 테이블의 제외된 행
-- outer right join : inner join + 우측 테이블의 제외된 행
-- outer full join : inner join + 좌우측테이블의 제외된 행

-- left outer join
select
    *
from
    employee e left join department d
        on e.dept_code = d.dept_id; -- 24 (22+2)   e.dept_code가 null이었던 2행 추가
        
 -- [oracle 전용문법]
select
    *
from
    employee e, department d
where
    e.dept_code = d.dept_id(+);       


-- right outer join
select
    *
from
    employee e right join department d
        on e.dept_code = d.dept_id; -- 25 (22+3)    d.dept_id가 매칭되지 않았던 3행 추가(D3, D4, D7)
        
-- [oracle 전용문법]
select
    *
from
    employee e, department d
where
    e.dept_code(+) = d.dept_id;

-- full outer join        
select
    *
from
    employee e full outer join department d
        on e.dept_code = d.dept_id;  -- 27 (22 + 2 + 3) 
        
-- [oracle 전용문법]에서는 full outer join을 지원하지 않는다.


------------------------------------------------------------
-- CROSS JOIN
------------------------------------------------------------
-- 상호조인
-- 카테시안의 곱(Cartesian's product). 모든 경우의 수를 의미
-- 두 테이블을 모든 경우의 수로 조인.

-- employee - department : 24 * 9
select  
    *
from
    employee cross join department;
    
-- [oracle 전용문법]
select
    *
from
    employee e, department d;


-- 사원별로 급여, 평균 급여와 차이를 조회
select
    
    emp_name,
    salary,
    salary - avg_sal
from
    employee cross join (select floor(avg(salary)) avg_sal from employee);

-------------------------------------------------------------
-- SELF JOIN
-------------------------------------------------------------
-- 같은 테이블을 좌/우에 위치시켜 조인
-- 같은 테이블내에 참조가 존재할때 사용. employee.manager_id은 employee_emp_id를 참조

-- 사번, 사원명, 관리자 사번, 관리자 명을 조회 
select 
    e.emp_id,
    e.emp_name,
    e.manager_id,
    m.emp_name
from 
    employee e join employee m
        on e.manager_id = m.emp_id;
        
-- [oracle 전용문법]
select
    e.emp_id,
    e.emp_name,
    e.manager_id,
    m.emp_name
from
    employee e, employee m
where
    e.manager_id = m.emp_id;
    

-- 내부조인 (e.manager_id가 null이면 제외/ m.emp_id가 e.manger_id가 매칭되지 않으면 제외)
select 
    *
from 
    employee e join employee m
        on e.manager_id = m.emp_id;
        
-- [oracle 전용문법]
select
    *
from
    employee e, employee m
where
    e.manager_id = m.emp_id;

-- left join
select 
    *
from 
    employee e left join employee m
        on e.manager_id = m.emp_id;
        
-- [oracle 전용문법]
select
    *
from
    employee e, employee m
where
    e.manager_id = m.emp_id(+);

-- right join
select 
    *
from 
    employee e right join employee m
        on e.manager_id = m.emp_id;
        
-- [oracle 전용문법]
select
    *
from
    employee e, employee m
where
    e.manager_id(+) = m.emp_id;
        
----------------------------------------------
-- MULTIPLE JOIN
----------------------------------------------
-- 다중 조인.
-- 한번에 2개의 테이블을 조인하고, 이를 여러번 처리할 수 있다.
-- 조인된 결과 ResultSet을 테이블처럼 취급할 수 있다.
-- 외부조인으로 연결되었다면, 끝까지 외부조인을 유지해야 데이터를 보존할 수 있다.
-- 조인되는 순서가 중요하다. (ANSI표준문법)

-- employee - department - location - nation
-- employee - job
select
    *
--    e.emp_name,
--    j.job_name,
--    d.dept_title,
--    l.local_name,
--    n.national_name
from
    employee e
        left join department d
            on e.dept_code = d.dept_id
        left join location l
            on d.location_id = l.local_code
        left join nation n
            on l.national_code = n.national_code
         left join job j
            on e.job_code = j.job_code;
            
-- [oracle 전용문법]
select
    *
from
    employee e, department d, location l, nation n, job j
where
    e.dept_code = d.dept_id(+)
    and
    d.location_id = l.local_code(+)
    and
    l.national_code = n.national_code(+)
    and
    e.job_code = j.job_code;
            
-- 직급이 대리 또는 과장이면서, ASIA지역에 근무하는 사원 조회
--(사번, 이름, 직급명, 부서명, 근무지역명, 급여)
select
    e.emp_id,
    e.emp_name,
    j.job_name,
    d.dept_title,
    l.local_name,
    e.salary
from
    employee e
        left join department d
            on e.dept_code = d.dept_id
         left join location l
            on d.location_id = l.local_code
         left join nation n
            on l.national_code = n.national_code
         left join job j
            on e.job_code = j.job_code    
            
where
   j.job_name in ('대리','과장')
   and l.local_name like 'ASIA%';
   

-- [oracle 전용문법]
select
    e.emp_id,
    e.emp_name,
    j.job_name,
    d.dept_title,
    l.local_name,
    e.salary
from
    employee e, department d, location l, nation n, job j
where
    e.dept_code = d.dept_id(+)
    and
    d.location_id = l.local_code(+)
    and
    l.national_code = n.national_code(+)
    and
    e.job_code = j.job_code
    and
    j.job_name in ('대리','과장')
   and
   l.local_name like 'ASIA%';


select * from employee; -- 24
select * from department; --9
select * from job;
select* from location;
select * from nation;
select * from sal_grade;            

commit;
rollback;
-- 함수 실습문제
-- 1. 직원명과 이메일, 이메일 길이를 출력하시오 
-- 홍길동이란 직원은 없어서 전체 출력 원하는 직원 있을 경우 where절의 사용하여 출력해주면 된다.
select
    emp_name,
    email,
    length(email)
from
    employee;
--where
--    emp_name = '송은희';

-- 2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
select
    emp_name,
    substr(email, 0,instr(email, '@', -1) - 1)  
from
    employee
where
    emp_name = '노옹철' or emp_name = '정중하';

-- 3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오 그때 보너스 값이 null인 경우에는 0이라고 출력 되게 만드시오
select
    emp_name 이름,
     decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) 생년,
    nvl(bonus,0) 보너스
from
    employee
where
    decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) >='1960' and
    decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) < '1970'
order by
    2;
    
-- 4. '010'핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
select 
    count(*) || '명' as 인원
from 
    employee
where 
    not phone like '010%';

--5. 직원명과 입사년월을 출력하시오 
--	단, 아래와 같이 출력되도록 만들어 보시오
--	    직원명		입사년월
--	ex) 전형돈		2012년 12월
--	ex) 전지연		1997년 3월

select 
    emp_name
    , extract(year from hire_date) || '년 '  || extract(month from hire_date) || '월' as 입사년월
from 
    employee;

--6. 직원명과 주민번호를 조회하시오
--	단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서출력 하시오
--	ex) 홍길동 771120-1******

select 
    emp_name, substr(emp_no, 1, 8) || '******' 
from 
    employee;
    
-- 7. 직원명, 직급코드, 연봉(원) 조회 단, 연봉은 57,000,000으로 표시되게 함.
-- (연봉은 보너스 포인트가 적용된 1년치 급여)
select
     emp_name 직원명,
     job_code 직급코드,
     to_char(salary + (salary * nvl(bonus, 0)), 'fml99,999,999')
from
    employee;
-- 8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
-- (사번, 사원명, 부서코드, 입사일)
select
    emp_id 사번,
    emp_name 사원명,
    dept_code 부서코드,
    hire_date 입사일
from
    employee
where
    dept_code in ('D5','D9')
    and substr(hire_date,1,4) like '2004';
    
-- 9. 직원명, 입사일, 오늘까지의 근무일수 조회
-- 주말도 포함, 소수점 아래는 버림
-- 퇴사자는 퇴사일 - 입사일로 계산
select
    emp_name 직원명,
    hire_date 입사일,
    floor(nvl(quit_date, sysdate) - hire_date) as "오늘까지의 근무일수"
from
    employee;

--10. 직원명, 부서코드, 생년월일, 만나이 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함

-- 한국나이 : 현재년도 - 출생년도 + 1
-- 만나이 : 생일기준  trunc(months_between(오늘, 생일) / 12)
select 
    emp_name, 
    dept_code, 
    decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2) || '년 ' || 
    substr(emp_no, 3, 2) || '월 ' || 
    substr(emp_no, 5, 2) ||'일 ' 생년월일,
    trunc(
        months_between(
            sysdate, 
            to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')
        ) / 12
    ) as "만 나이"
from employee;

--11. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
-- 아래형식으로 해당년도에 입사한 인원수를 조회하시오. (퇴사자 제외) 
-- 마지막으로 전체직원수도 구하시오 (decode, sum 사용)
--
--	----------------------------------------------------------------------------------------------------------
--	 1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
--	----------------------------------------------------------------------------------------------------------
select 
    count(decode(extract(year from hire_date),1998,1000000)) as "1998년"
    , count(decode(extract(year from hire_date),1999,100)) as "1999년"
    , count(decode(extract(year from hire_date),2000,100)) as "2000년"
    , count(decode(extract(year from hire_date),2001,1000000)) as "2001년"
    , count(decode(extract(year from hire_date),2002,1000)) as "2002년"
    , count(decode(extract(year from hire_date),2003,1)) as "2003년"
    , count(decode(extract(year from hire_date),2004,1)) as "2004년"
    , count(*) as 전체직원수
from 
    employee
where 
    quit_yn = 'N';

-- 12. 부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case사용)
-- 단, 부서코드가 D5, D6, D9인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
select
    emp_name,
    case 
        when dept_code = 'D5' then '총무부'
        when dept_code = 'D6' then '기획부'
        when dept_code = 'D9' then '영업부'
    end 부서
from
    employee
where 
    dept_code in ('D5', 'D6', 'D9')
order by
    2;
---------------------------------------------
-- 조인 실습문제
---------------------------------------------
-- 1. 2020년 12월 25일이 무슨 요일인지 조회하세요.
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

-- 2. 주민번호가 1970년생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하세요
select
    e.emp_name,
    e.emp_no,
    d.dept_title,
    j.job_name
from
    employee e
        left join department d
            on e.dept_code = d.dept_id
        left join job j
            on e.job_code = j.job_code    
where
    decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) >='1970' and
    decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2) < '1980' and
    substr(emp_no, 8, 1) in ('2','4') and
    e.emp_name like '전%';

--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
-- 나이가 가장 적은 사원 조회 쿼리
select 
	emp_id 사번
	, emp_name 사원명
	, extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2)+1 나이
	, dept_title 부서명
	, job_name 직급명
from 
	employee  cross join (select min(extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2))+1 min_age from employee)
    left join department on dept_code = dept_id
    left join job  using(job_code)
where 
    extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2)+1 = min_age;   

-- 4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select
    emp_id 사번,
    emp_name 사원명,
    dept_title 부서명
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    emp_name like '%형%';
    
-- 5. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.dept_code 부서코드,
    d.dept_title 부서명   
from
    department d join employee e
        on d.dept_id = e.dept_code
    join job j
        on e.job_code = j.job_code
where
    d.dept_title like '해외영업%';

-- 6. 보너스 포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
select
    e.emp_name 사원명,
    e.bonus as "보너스 포인트",
    d.dept_title 부서명,
    l.local_name 근무지역명
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
where
    e.bonus is not null;

-- 7. 부서 코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    d.dept_title 부서명,
    l.local_name 근무지역명
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
    join job j
        on e.job_code = j.job_code
where
    e.dept_code like 'D2';

-- 8. 급여등급테이블 sal_grade의 등급별 최대급여(MAX_SAL)보다 많이 받는
-- 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.salary 급여,
    salary + (salary * nvl(bonus,0))* 12 연봉,
    sa.max_sal
from
    employee e join sal_grade sa
        on e.sal_level = sa.sal_level
    join job j
        on e.job_code = j.job_code
where
    e.salary > sa.max_sal;
    
-- 9. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
select
    e.emp_name 사원명,
    d.dept_title 부서명,
    l.local_name 지역명,
    l.national_code 국가명
from
    employee e join department d
        on e.dept_code = d.dept_id
    join location l
        on d.location_id = l.local_code
where
    l.national_code in ('KO','JP');
    
-- 10. 같은 부서에 근무하는 직원들의 사원명, 부서명, 동료이름을 조회하시오.
select
    "e1".emp_name 사원명,
    d.dept_title 부서명,
    "e2".emp_name 동료이름
from
    employee "e1" join department d
        on "e1".dept_code = d.dept_id
    join employee "e2"
        on "e1".dept_code = "e2".dept_code
where
    "e1".emp_name != "e2".emp_name;

-- 11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회 하시오. 
-- 단, join과 in 연산자 사용할 것
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.salary
from
    employee e join job j
        on e.job_code = j.job_code
where
    e.bonus is null
    and j.job_name in ('차장','사원');
    
-- 12. 재직중인 직원과 퇴사한 직원의 수를 구하시오.
select 
	decode(quit_yn,'N','재직','퇴사') 재직여부,
	count(*) 인원수
from 
	employee
group by 
	quit_yn;
    
    
select * from employee; -- 24
select * from department; --9
select * from job;
select* from location;
select * from nation;
select * from sal_grade;

commit;