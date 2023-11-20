--=======================================
-- SUB-QUERY
--=======================================
-- 하나의 쿼리(main-query)안의 포함된 또 다른 쿼리(sub-query)
-- 존재하지 않는 조건에 근거해서 값을 검색하는 경우 유용함.
-- 메인쿼리안에 서브쿼리를 포함하는 종속관계. (메인쿼리 실행중에 서브쿼리를 먼저 실행하고 그 결과를 메인쿼리에 반환)

-- 조건
-- 1. 서브쿼리는 반드시 소괄호로 묶어서 처리
-- 2. 서브쿼리내 order by 지원하지 않음.

--- 구분
-- 1. 일반서브쿼리 - 메인쿼리와 상관없이 서브쿼리 단독실행 가능한 경우
-- 2. 상관서브쿼리 (상호연관) - 메인쿼리 값을 받아서 서브쿼리를 실행하는 경우

-- 3. 서브쿼리 실행결과에 따른 구분 - 1행1열, n행1열, 1행n열, n행m열
-- 4. 위치에 따른 구분 - select절(scala subquery), where절, from절(inline-view)

-- 맛보기 예제
-- 노옹철사원의 관리자 이름을 조회
-- 1. 셀프조인
select
    e1.emp_id 사번
    , e1.emp_name 사원이름
    , e1.manager_id 관리자번호
    , e2.emp_name 관리자이름
from
    employee e1 join employee e2
        on e1.manager_id = e2.emp_id
where
    e1.emp_name = '노옹철';
-- 2. 서브쿼리
-- 노옹철 행의 manager_id -> 일치하는 emp_id인 행의 emp_name 조회
select
    emp_name
from
    employee
where
    emp_id = (select manager_id from employee where emp_name = '노옹철');

select manager_id from employee where emp_name = '노옹철';

-- 노옹철사원의 같은 부서원을 출력
-- 노옹철사원의 부서코드 -> 해당부서의 사원명 출력
select
    emp_name
from
    employee
where   
    dept_code = (select dept_code from employee where emp_name = '노옹철');
    
------------------------------------------------------------
-- 일반서브쿼리 - 처리결과에 따른 구분
------------------------------------------------------------
-- 1행1열 - 단일 값을 반환하는 서브쿼리

-- 전사 급여평균보다 많은 급여를 받는 사원 조회
select
    *
from
    employee
where
    salary > (select avg(salary) from employee);
    
-- 윤은해와 급여가 같은 사원 조회(사번, 사원명, 급여) (단, 윤은해는 결과에서 제외)
select
    emp_id 사번,
    emp_name 사원명,
    salary 급여
from
    employee
where
    salary = (select salary from employee where emp_name = '윤은해')
    and emp_name != '윤은해';
-- 급여가 제일 많은 사원조회, 급여가 제일 적은 사원 조회 (이름, 급여)
select
    emp_name 이름,
    salary 급여
from
    employee
where
--    salary = (select max(salary) from employee)
--    or salary = (select min(salary) from employee);
    salary in (
            (select max(salary) from employee)
            , (select min(salary) from employee)
    );
    

-- D1, D2 부서원중에서 D5부서원의 평균급여보다 많은 급여를 받는 사원 조회
select
    *
from
    employee
where
    dept_code in ('D1','D2') 
    and salary > (select avg(salary) from employee where dept_code = 'D5');
    
-- n행 1열
-- = 사용불가, in, any, all, exists 연산자

-- 송종기, 하이유의 부서원 출력
select
    dept_code
from
    employee
where
    emp_name in ('송종기','하이유'); -- D9, D5

select
    emp_name, dept_code
from
    employee
where
    dept_code in (
                         select
                            dept_code
                         from
                            employee
                         where
                            emp_name in ('송종기','하이유')
                         );

-- 차태연, 박나라, 이오리와 같은 직급사원 조회 (사원명, 직급명)
select
    e.emp_name 사원명
    , j.job_name 직급명
from
    employee e join job j
        on e.job_code = j.job_code
where
    e.job_code in (
                        select 
                            job_code
                        from
                            employee
                        where
                            emp_name in ('차태연','박나라','이오리')
                    );

-- 직급이 대표, 부사장이 아닌 사원의 사원명, 부서명 조회
select
    e.emp_name 사원명
    , d.dept_title 부서명
    
from
    employee e left join department d
        on e.dept_code = d.dept_id
where
    job_code not in (select job_code from job where job_name in ('대표','부사장'));
    
-- Asia1지역에 근무하는 사원 정보 출력 (사원명, 부서명) - 메인쿼리 조인 사용하지 않기
select
    e.emp_name 사원명
    , d.dept_title 부서명
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    emp_name in (
                            select 
                                emp_name 
                            from 
                                employee e join department d
                                   on e.dept_code = d.dept_id
                                join location l
                                    on d.location_id = l.local_code
                            where 
                                local_name in ('ASIA1')
                        );

-- any/some(values...)
-- values중에 하나
select
    *
from
    employee
where
    salary >= any(2000000, 3000000); -- 급여가 값들중의 최소값보다 크거나 같은 경우 true

-- all(values....)
-- 모든 value
select
    *
from
    employee
where
    salary >= all(1000000, 2000000); -- 급여가 값들중의 최대값보다 크거나 같은 경우 true
    
-- D5 부서원 중에 D1부서 부서원 보다 많은 급여를 받는 사원 조회
select
    *
from
    employee
where
    dept_code = 'D5'
    and salary > all(select salary from employee where dept_code = 'D1');

-- J2 직급 중에 J3보다 적은 급여를 받는 사원 조회
select
    *
from
    employee
where
    job_code = 'J2'
    and salary < any(select salary from employee where job_code = 'J3'); 
    
-- 1행 n열 서브쿼리
-- 비교하는 좌우의 컬럼수가 동일해야 한다.

-- 퇴사한 사원과 동일한 부서, 동일한 직급의 사원을 조회하라.
--ex1)
select
    *
from
    employee
where
    dept_code = (select dept_code from employee where quit_yn = 'Y')
    and job_code = (select job_code from employee where quit_yn = 'Y')
    and quit_yn = 'N';
    
-- ex2)
select
    *
from
    employee
where
    (dept_code, job_code) = (select dept_code, job_code from employee where quit_yn = 'Y') -- 서브쿼리 할때만 가능
    -- (dept_code, job_code) = ('D8','J6') -- 이런식으로 불가능
    and quit_yn = 'N';
    
-- 우항의 서브쿼리 결과가 n행인 경우 = 연산 실패함.

-- n행m열 서브쿼리
-- = 대신 in 사용

-- 임시환, 이중석과 같은 부서 같은 직급 사원조회(D2 J4)
select
    *
from
    employee
where
--    (dept_code, job_code) = (select dept_code, job_code from employee where emp_name in('임시환','이중석')); 
-- ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
--ORA-00913: 값의 수가 너무 많습니다 -> 컬럼 수가 맞지 않는 경우
     (dept_code, job_code) in (select dept_code, job_code from employee where emp_name in('임시환','이중석'));

-- 부서별 최대급여를 받는 사원 조회. (사번, 사원명, 부서명)
-- (부서, 급여)
-- 부서별 최대급여를 조회 - 서브쿼리로 활용하기
select
    emp_id 사번
    , emp_name 사원명
    , dept_title 부서명
from
    employee e join department d
        on e.dept_code = d.dept_id
where
    (dept_code, salary) in (select dept_code, max(salary) from employee group by dept_code);

-- 직급별 최대급여/최소급여를 받는 사원 조회
select
    emp_name 사원명
    , job_code 직급코드
    , salary 급여
from
    employee
where
    (job_code, salary) in (select job_code, max(salary) from employee group by job_code)
    or (job_code, salary) in (select job_code, min(salary) from employee group by job_code);

-----------------------------------------------------------
-- 상관 서브쿼리
-----------------------------------------------------------
-- 상호연관 서브쿼리
-- 메인쿼리로 부터 가져온 값을 이용해 서브쿼리 실행하고, 그 결과 집합을 메인쿼리에 반환
-- 블럭을 잡아 단독실행이 불가능하다.
-- 메인 쿼리의 별칭 꼭 사용

-- 직급별 평균급여보다 많은 급여를 받는 사원 조회
-- ex1) -- 조인 사용
select
    e.job_code 직급
    , e.emp_name 이름
    , e.salary 급여
    , avg.avg_sal
from
    employee e join (
                                select 
                                    job_code
                                    , floor(avg(salary)) avg_sal 
                                from 
                                    employee 
                                group by 
                                    job_code
                            ) avg
        on e.job_code = avg.job_code
where
    e.salary > avg.avg_sal;

-- ex2) 상관서브쿼리 사용
select
    *
from
    employee e
where
    salary > (select avg(salary) from employee where job_code = e.job_code);
    
-- 부서별 평균급여보다 적은 급여를 받는 사원 조회 (사번, 사원명, 부서코드, 급여)
select
    emp_id 사번
    , emp_name 사원명
    , dept_code 부서코드
    , salary 급여
from
    employee e
where
    salary < (select avg(salary) from employee where dept_code = e.dept_code);
    
-- exists(서브쿼리) 연산자
-- true/false를 반환. exists안의 서브쿼리 실행결과행이 1행 이상이면 true, 0행이면 false 반환
select
    *
from
    employee
where
--    1 = 1; -- true
    1 = 0; -- false
select
    *
from
    employee
where
    exists  (select * from job where job_code = 'J100');
    
-- 부하직원이 존재하는 사원 출력
select
    *
from
    employee e
where
    exists(select * from employee where manager_id = e.emp_id);
    
 select * from employee where manager_id = '200';   
 
 -- 실제 부서원이 존재하는 부서만 추려서 출력 (부서코드, 부서명)
 -- department
 select
    d.dept_id
    , d.dept_title
 from
    department d
where
    exists(select 1 from employee e where e.dept_code = d.dept_id);
    
-- 최대/최소값을 가진 행 조회하기
select
    *
from
    employee e
where
--    not exists (select 1 from employee where salary > e.salary); -- (최대) -- 행이 존재하면 false, 행이 존재하지 않으면 true
    not exists (select 1 from employee where salary < e.salary); -- (최소) 

-- 가장 최근에 입사한 사원조회
select
    *
from
    employee e
where
--    not exists (select 1 from employee where hire_date > e.hire_date); -- 가장 최근에 입사
    not exists (select 1 from employee where hire_date < e.hire_date); -- 가장 먼저 입사
    
-- 스칼라 서브쿼리
-- 스칼라값이란 단일값을 의미
-- 서브쿼리의 결과가 1행1열인 상관서브쿼리(select절)

-- 전 사원의 사번, 사원명, 관리자 사번, 관리자 사원명 조회
select
    emp_id
    , emp_name
    , manager_id
    , (select emp_name from employee where emp_id = e.manager_id) manager_name
from
    employee e;

-- 사번, 사원명, 부서코드, 부서명 조회
select
    emp_id 사번
    , emp_name 사원명
    , nvl(dept_code, 'D0') 부서코드
    , nvl((select dept_title from department where dept_id = e.dept_code), '인턴') 부서명
from
    employee e;

-- 사번, 사원명, 직급명, 부서명, 급여, 부서별 평균 급여 조회
select
    emp_id 사번
    , emp_name 사원명
    , (select job_name from job where job_code = e.job_code) 직급명
    , (select dept_title from department where dept_id = e.dept_code) 부서명
    , salary 급여
    , (select floor(avg(salary)) from employee where dept_code = e.dept_code) as "부서별 평균 급여"
from
    employee e;
    
-------------------------------------------------------
-- INLINE VIEW
-------------------------------------------------------
-- from절에 사용한 서브쿼리를 가리킴.
-- 복잡한 연산처리를 함에 있어 중복을 제거가능


-- 남자 사원만 조회 (사번, 사원명, 성별)
select
    emp_id
    , emp_name
    , decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from
    employee e
where
    decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') = '남';

-- employee + 성별
select
    *
from (
            select
                 e.emp_id 사번
                 , e.emp_name 이름 
                 , decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별
            from
                employee e
        )
where
    성별 = '남';

-- 1990(1990 ~ 1999)년도 입사자만 조회 (사번, 사원명, 입사년도 출력)
select
    *
from (
            select
                emp_id 사번
                , emp_name 사원명
                , extract(year from hire_date) 입사년도
            from
                employee
        ) e
where
     입사년도 between '1990' and '1999'
order by
    입사년도; 
-- 30, 40대(30 ~ 49) 여자사원 조회 (사번, 사원명, 나이, 성별 출력)
select
    *
from (
            select
                emp_id 사번
                , emp_name 사원명
                , trunc(
                        months_between(
                                            sysdate, 
                                                    to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')
                                        ) / 12
                            ) as "만 나이"
                , decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별
            from 
                employee e
         ) e
where
    "만 나이" between '30' and '49'
    and 성별 = '여';

------------------------------------------------
-- 서브쿼리 실습문제
------------------------------------------------
-- 1. 주민번호가 1970년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오
select
    emp_name 사원명
    , emp_no 주민번호
    , (select dept_title from department where dept_id = e.dept_code) 부서명
    , (select job_name from job where job_code = e.job_code)직급명
from
    employee e
where
    substr(emp_no, 1, 2) between '70' and '79'
    and decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') = '여'
    and emp_name like '전%';

-- 2. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오
trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12) 나이

select
    e.emp_id 사번
    , e.emp_name 사원명
    , trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12) 나이
    , (select dept_title from department where dept_id = e.dept_code) 부서명
    , (select job_name from job where job_code = e.job_code) 직급명
from
    employee e
where
    trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12)
    = (select min(trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12))
    from employee
    );
    
-- inline view
select
    *
from (
        select
            e.emp_id 사번
            , e.emp_name 사원명
            , trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12) 나이
            , (select dept_title from department where dept_id = e.dept_code) 부서명
            , (select job_name from job where job_code = e.job_code) 직급명
        from
            employee e
        )
where
    "나이" = (select min(trunc(months_between(sysdate, to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4), 'yyyymmdd')) / 12)) from employee
    );



-- 3. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오
select
    emp_id 사번
    , emp_name 사원명
    , (select dept_title from department where dept_id = e.dept_code)부서명
from
    employee e
where
    emp_name like '%형%';
-- 4. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오
select
    emp_name 사원명
    , (select job_name from job where job_code = e.job_code) 직급명
    , dept_code 부서코드
    , (select dept_title from department where dept_id = e.dept_code) 부서명
from
    employee e 
where
    dept_code in (select dept_id from department where dept_title like '해외영업%');
    
-- 5. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
select
    emp_name 사원명
    , bonus 보너스포인트
    , (select dept_title from department where dept_id = e.dept_code) 부서명
    , (select local_name from department d join location l on d.location_id = l.local_code where dept_id = e.dept_code) 근무지역명
from
    employee e
where
    bonus is not null;
-- 6. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select
    emp_name 사원명
    , (select job_name from job where job_code = e.job_code) 직급명
    , (select dept_title from department where dept_id = e.dept_code) 부서명
    , (select local_name from department d join location l on d.location_id = l.local_code where dept_id = e.dept_code) 근무지역명
from
    employee e
where
    dept_code = 'D2';

-- 7. 급여 등급 테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
select
    emp_name 사원명
    , (select job_name from job where job_code = e.job_code) 직급명
    , salary 급여
    , (salary + (salary * nvl(bonus,0))) * 12 연봉
from
    employee e
where
    salary > (select max_sal from sal_grade where sal_level = e.sal_level);
-- 8. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select
    emp_name 사원명
    , (select job_name from job where job_code = e.job_code) 직급명
    , salary 급여
    , bonus as "보너스 확인"
from
    employee e
where
    bonus is null
    and job_code in (select job_code from job where job_name in ('차장','사원'));

select * from employee; -- 24
select * from department; --9
select * from job;
select* from location;
select * from nation;
select * from sal_grade;

desc 

commit;

-- ncs 테스트
select
    emp_name
    , emp_no
    , dept_code
    , salary
from
    employee
where
    (dept_code = 'D9' or dept_code = 'D6') 
    and salary >= 3000000 and email like '___#_%' escape '#' 
    and bonus is not null
    and decode(substr(emp_no,8,1), '1', '남', '3', '남', '여') = '남';
    
select 
    *
from 
    employee
where
    bonus is null 
    and Manager_id is not null;
    
SELECT 
    DEPT_code, SUM(SALARY) 합계, FLOOR(AVG(SALARY)) 평균, COUNT(*) 인원수

FROM employee
--where SALARY > 2800000
GROUP BY DEPT_code
having FLOOR(AVG(SALARY)) > 2800000
ORDER BY DEPT_code ASC;

select distinct
    dept_code
    , sum(salary) over(partition by dept_code) 합
    , avg(salary) over(partition by dept_code) 평균
    , count(*) over(partition by dept_code) 인원수
from 
    employee
where
    salary > 2800000
order by
    dept_code asc;
    
SELECT ROWNUM, EMPNAME, SAL_level
FROM EMPloyee
WHERE ROWNUM <= 3
ORDER BY SAL_level DESC;

select * from employee;

select dept_code, count(*) from employee group by dept_code;


