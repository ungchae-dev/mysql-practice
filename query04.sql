-- query03.sql에서 생성한 doitsql DB 사용
-- 데이터베이스 선택
USE sakila;

-- 4-1. SELECT 문으로 데이터 조회하기
-- sakila 데이터베이스의 customer 테이블 조회하기
-- first_name 열을 조회
SELECT first_name FROM customer;

-- 2개의 열 조회
SELECT first_name, last_name FROM customer;
-- 전체 열 조회(※ 전체 열 조회는 자원을 많이 소비)
SELECT * FROM customer;

-- SHOW COLUMNS FROM [테이블명];
-- :테이블의 구조(schema)를 확인할 때 사용하는 쿼리
-- customer 테이블의 열 정보 조회
SHOW COLUMNS FROM sakila.customer;

-- 4-2. WHERE 절로 조건에 맞는 데이터 조회하기
-- WHERE 절, = 연산자로 특정 값 조회
SELECT * FROM customer
WHERE first_name = 'MARIA';

-- address_id가 200인 행 조회
SELECT * FROM customer 
WHERE address_id = 200;

-- address_id가 200 미만인 행 조회
SELECT * FROM customer 
WHERE address_id < 200;

-- first_name이 MARIA인 행 조회
SELECT * FROM customer 
WHERE first_name = 'MARIA';

-- first_name이 MARIA 미만인 행 조회
-- (first_name 열에서 데이터가 A, B, C 순으로 
-- MARIA 보다 앞에 위치한 행들)
SELECT * FROM customer 
WHERE first_name < 'MARIA';

-- payment 테이블에서 
-- payment_date가 2005-07-09 13:24:07인 행 조회
SELECT * FROM payment 
WHERE payment_date = '2005-07-09 13:24:07';

-- payment 테이블에서 
-- payment_date가 2005년 7월 9일 미만인 행 조회
SELECT * FROM payment 
WHERE payment_date < '2005-07-09';
-- WHERE 절에서 비교 연산자 사용 Fin.

-- WHERE절에서 논리 연산자 사용하기
-- customer 테이블에서 BETWEEN을 통한 데이터 조회
SELECT * FROM customer 
WHERE address_id BETWEEN 5 AND 10;

-- payment 테이블에서 2005년 6월 17일 ~ 2005년 7월 19일을 포함한 날짜로 전체 데이터 조회
SELECT * FROM payment 
WHERE payment_date BETWEEN '2005-06-17' AND '2005-07-19';

-- payment 테이블에서 2005년 7월 8일 오전 7시 33분 56초의 날짜로 전체 데이터 조회
SELECT * FROM payment 
WHERE payment_date = '2005-07-08 07:33:56';

-- customer 테이블에서 first_name 열에서 M~O 범위의 데이터 조회(M, N, O)
SELECT * FROM customer 
WHERE first_name BETWEEN 'M' AND 'O';

-- customer 테이블에서 first_name 열에서 M~O 범위의 값을 제외한 데이터 조회
SELECT * FROM customer 
WHERE first_name NOT BETWEEN 'M' AND 'O';

-- ...
-- AND와 OR을 이용한 데이터 조회하기
-- city 테이블에서 city 열이 'Sunnyvale'이면서 
-- country_id 열이 103인 데이터 조회
SELECT * FROM city 
WHERE city = 'Sunnyvale' AND country_id = 103;

-- payment 테이블에서 날짜(payment_date)가 
-- 2005년 6월 1일부터 2005년 7월 5일까지 포함하는 데이터 조회
SELECT * FROM payment 
WHERE payment_date >= '2005-06-01' AND payment_date <= '2005-07-05';

-- customer 테이블에서 first_name 열에서 'MARIA' 또는 'LINDA'인 데이터 조회
SELECT * FROM customer 
WHERE first_name = 'MARIA' OR first_name = 'LINDA';

-- customer 테이블에서 OR을 2개 이상 사용한 경우의 쿼리
SELECT * FROM customer 
WHERE first_name = 'MARIA' OR first_name = 'LINDA' OR first_name = 'NANCY';

-- 위 쿼리문 개선 => customer 테이블에서 IN을 활용한 데이터 조회
SELECT * FROM customer 
WHERE first_name IN ('MARIA','LINDA','NANCY');

-- city 테이블에서 country_id 열이 103 또는 country_id 열이 86이면서 
-- city 열이 'Cheju', 'Sunnyvale', 'Dallas'인 데이터 조회
SELECT * FROM city 
WHERE country_id = 103 OR country_id = 86 
	AND city IN ('Cheju', 'Sunnyvale', 'Dallas');
-- 논리 연산자의 우선순위는 OR보다 AND가 '높다'.
-- 쿼리 실행 순서 1
-- SELECT * FROM city WHERE country_id = 103;
-- 쿼리 실행 순서 2
-- SELECT * FROM city 
-- WHERE country_id = 86
-- 	AND city IN ('Cheju', 'Sunnyvale', 'Dallas');

-- 만약에 WHERE 조건절에서 103과 86의 순서가 바뀐다면 쿼리 결과는 어떻게 될까?
SELECT * FROM city 
WHERE country_id = 86 OR country_id = 103 
	AND city IN ('Cheju', 'Sunnyvale', 'Dallas');
    
-- 원하는 결과를 도출하려면?
-- () 소괄호 사용!
-- city 테이블에서 소괄호로 우선순위를 다시 정해 전체 데이터 조회
SELECT * FROM city 
WHERE (country_id = 103 OR country_id = 86) 
	AND city IN ('Cheju', 'Sunnyvale', 'Dallas');

-- city 테이블에서 IN, AND를 결합해 전체 데이터 조회
SELECT * FROM city 
WHERE country_id IN (103, 86) 
	AND city IN ('Cheju', 'Sunnyvale', 'Dallas');
-- 결국, 어떤 결과를 얻기 위한 코드에 정답은 없다.
-- 좋은 코드 또는 좋은 쿼리란 가독성이 좋으면서 
-- 요구사항을 정확히 반영하고 성능도 효율적인 거니까.

-- address 테이블에서 NULL이 있는 데이터 조회
SELECT * FROM address;

-- = 연산자를 사용해 NULL 데이터 조회
SELECT * FROM address WHERE address2 = NULL;
-- NULL은 정의되지 않은 값이므로 일반적인 연산자로 조회 불가

-- address 테이블에서 address2 열이 NULL인 데이터 조회
SELECT * FROM address 
WHERE address2 IS NULL;

-- address 테이블에서 address2 열이 NULL이 아닌 데이터 조회
SELECT * FROM address 
WHERE address2 IS NOT NULL;

-- address 테이블에서 address2 열이 공백인 행 조회
SELECT * FROM address 
WHERE address2 = '';

-- ...
-- 4-3. ORDER BY 절로 데이터 정렬하기
-- SELECT [column] FROM [table] 
-- WHERE [column] = [condition] ORDER BY [column] [ASC or DESC]
-- ORDER BY: 조회한 데이터를 정렬하기 위한 구문
-- [column]: 정렬할 열 이름을 입력
-- [ASC or DESC]: 정렬 기준, 오름차순(ASC) 또는 내림차순(DESC(descending))
-- 생략 시 default는 오름차순(ASC(ascending))
-- ...
-- customer 테이블에서 first_name 열 기준으로 오름차순 정렬하여 모든 데이터 조회
SELECT * FROM customer 
ORDER BY first_name;

-- customer 테이블에서 last_name 열 기준으로 오름차순 정렬하여 모든 데이터 조회
SELECT * FROM customer 
ORDER BY last_name;

-- ※ 2개 이상의 열 기준으로 정렬 시 쉼표를 사용해 열 이름을 나열한다.
-- 이 때, 입력 순서에 따라 정렬 우선순위가 정해진다.
-- customer 테이블에서 store_id, first_name 순으로 모든 데이터를 오름차순 정렬해 조회하면?
SELECT * FROM customer 
ORDER BY store_id, first_name;
-- 먼저 store_id 열 기준 정렬한 다음, store_id 열에 같은 값이 있는 경우 
-- first_name 열을 기준으로 데이터를 오름차순 정렬한다.

-- 반대로 customer 테이블에서 first_name, store_id 순으로 모든 데이터를 오름차순 정렬해 조회하면?
SELECT * FROM customer 
ORDER BY first_name, store_id;
-- first_name 열 기준으로 먼저 오름차순 정렬 후, 다음 store_id 열 기준에 따라 데이터를 오름차순 정렬한다.

-- customer 테이블에서 first_name 열에 대해 모든 데이터를 오름차순 정렬하면? (ASC 사용할 것!)
SELECT * FROM customer 
ORDER BY first_name ASC;

-- 반대로 customer 테이블에서 first_name 열에 대해 모든 데이터를 내림차순 정렬하면?
SELECT * FROM customer 
ORDER BY first_name DESC;

-- customer 테이블에서 먼저 store_id 열을 내림차순, first_name 열을 오름차순하여 모든 데이터를 정렬하면?
SELECT * FROM customer 
ORDER BY store_id DESC, first_name ASC;
-- 입력 순으로 정렬 우선순위가 정해지므로 store_id 열을 먼저 내림차순 정렬한 후,
-- 같은 데이터가 있는 경우 first_name 열을 오름차순 정렬한다.

-- LIMIT로 상위 데이터 조회하기
-- 특정 조건에 해당하는 데이터 중 상위 N개의 데이터만 보고 싶을 경우
-- SELECT 문에 LIMIT를 조합하면 된다.
-- ex) SELECT [column] FROM [table] ORDER BY [column] [ASC/DESC] LIMIT 10과 같이
-- LIMIT 다음에 조회하려는 행의 개수를 입력하면 된다.
-- ...
-- Q. customer 테이블에서 store_id는 내림차순으로, first_name은 오름차순으로 정렬 후, 
-- 상위 10개의 데이터를 조회하는 쿼리는?
SELECT * FROM customer 
ORDER BY store_id DESC, first_name ASC LIMIT 10;
-- 상위 N개 데이터 조회 시, 특히 ORDER BY 절을 사용하는 게 좋다.
-- 만약 정렬하지 않으면 어떤 값을 기준으로 정렬해 상위 N개의 데이터를 조회했는지 알 수 없기 때문이다.

-- 범위를 지정해 데이터 조회하기
-- LIMIT에 N1, N2라는 매개변수를 입력하면 상위 N1 다음 행부터 N2개의 행을 조회한다.
-- ...
-- customer 테이블에서 customer_id 열을 기준으로 오름차순한 뒤, 101번째 행부터 10개 행을 조회하는 쿼리는?
SELECT * FROM customer 
ORDER BY customer_id ASC LIMIT 100, 10;

-- OFFSET으로 특정 구간의 데이터 조회하기
-- ORDER BY 절로 데이터 정렬 후, 상위나 하위가 아닌 특정 구간의 데이터를 조회해야 할 때는 어떻게 할까?
-- LIMIT N2 OFFSET N1과 같이 작성하여
-- 데이터 N1개를 건너뛰고 N1+1번째 데이터부터 행 N2개를 조회하는 식으로 쓸 수 있다.
-- ※ OFFSET 사용 시 반드시 LIMIT와 함께 사용한다. ex) ... LIMIT N2 OFFSET N1
-- ...
-- customer 테이블에서 customer_id 열을 기준으로 오름차순 정렬 후, 
-- 데이터 100개를 건너뛰고 101번째 데이터부터 10개를 조회하는 쿼리는?
SELECT * FROM customer 
ORDER BY customer_id ASC LIMIT 10 OFFSET 100;

-- 4-4. 와일드카드로 문자열 조회하기
-- LIKE?
-- 자신이 뭘 조회해야할 지 모를 때 사용하는 키워드.
-- LIKE는 와일드카드로 지정한 패턴과 일치하는 문자열, 날짜, 시간 등을 조회한다.

-- LIKE의 기본 형식
-- SELECT [column] FROM [table] WHERE [column] LIKE [condition]

-- LIKE와 %로 특정 문자열을 포함하는 데이터 조회하기
-- A%: A로 시작하는 모든 문자열
-- %A: A로 끝나는 모든 문자열
-- %A%: A가 포함된 모든 문자열

-- customer 테이블의 first_name 열에서 A로 시작하는 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'A%';

-- customer 테이블의 first_name 열에서 AA로 시작하는 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'AA%';

-- customer 테이블의 first_name 열에서 A로 끝나는 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name LIKE '%A';

-- customer 테이블의 first_name 열에서 RA로 끝나는 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name LIKE '%RA';

-- customer 테이블의 first_name 열에서 A를 포함한 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name LIKE '%A%';

-- customer 테이블의 first_name 열에서 A로 시작하는 문자열을 제외한 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name NOT LIKE 'A%';

-- ...
-- ESCAPE로 특수 문자를 포함한 데이터 조회하기
-- %는 '예약어'이므로 %%와 같이 입력하는 식으로는 검색할 수 없음.
-- 예약어란?
-- 프로그래밍 언어에서 이미 문법으로 사용하고 있는 단어로, 
-- 이미 선점(예약)해서 사용되고 있는 단어.
-- 프로그래밍 언어마다 에약어의 종류는 다름.

-- 공통 테이블 표현식을 통한 테이블 생성(실제 테이블 생성이 아님)
-- 특수 문자를 포함한 임의의 테이블 생성
-- WITH CTE (col_1) AS (
-- SELECT 'A%BC' UNION ALL 
-- SELECT 'A_BC' UNION ALL 
-- SELECT 'ABC'
-- )
-- SELECT * FROM CTE; 
-- 반드시 뒤에 SELECT, INSERT, UPDATE, DELETE 같은 주 쿼리(main query)가 따라와야한다.

-- SELECT * FROM CTE WHERE col_1 LIKE '%';
-- %는 검색할 수 있는 값이 아닌, 0개 이상의 문자를 의미하는 예약어이기 때문에 이같은 결과가 발생함.
-- % 기호가 포함된 A%BC 데이터를 조회하려면 어떻게 해야 할까?
-- WITH CTE (col_1) AS (
-- SELECT 'A%BC' UNION ALL 
-- SELECT 'A_BC' UNION ALL 
-- SELECT 'ABC'
-- )
-- SELECT * FROM CTE WHERE col_1 LIKE '%#%%' ESCAPE '#';
-- %를 포함한 쿼리문이 될 수 있는 이유는?
-- 쿼리 실행 시 ESCAPE이 #을 제거하고, 
-- 쿼리 명령 단계에선 %#%%가 호출되고 실제 실행 시 %%%로 해석된다.
-- 따라서 %를 포함하는 앞,뒤 어떤 문자가 와도 상관없는 데이터를 조회하는 것.

-- ESCAPE에 사용할 특수문자는 # 외에 &, !, / 등 여러 가지를 쓸 수 있다.
WITH CTE (col_1) AS (
SELECT 'A%BC' UNION ALL 
SELECT 'A_BC' UNION ALL 
SELECT 'ABC'
)
-- ESCAPE과 !로 특수문자 %를 포함한 데이터 조회
-- SELECT * FROM CTE WHERE col_1 LIKE '%!%%' ESCAPE '!'; 
-- 명령어가 전달될 때
SELECT * FROM CTE WHERE col_1 LIKE '%!%%' ESCAPE '!';
-- 데이터베이스 엔진이 SQL 명령을 수행할 때
-- SELECT * FROM CTE WHERE col_1 LIKE '%%%';

-- LIKE와 _로 길이가 정해진 데이터 조회하기
-- 특정 문자열을 포함하면서 문자열의 길이도 정해 데이터를 검색하려면 어떻게 할까?
-- underscore (_)를 사용한다.
-- %만 사용하면 검색된 데이터의 양이 많아 원하는 데이터를 빨리 찾지 못할 때가 있다.
-- 이 때, 찾으려는 문자열 일부와 문자열의 길이를 알고 있다면 _를 사용하자.

-- _의 사용 예)
-- A_: A로 시작하면서 뒷 글자는 무엇이든 상관없음. 전체 글자 수는 2개인 문자열.
-- _A: A로 끝나면서 앞의 문자는 무엇이든 상관없음. 전체 글자 수는 2개인 문자열.
-- _A_: 3글자로 된 문자열 중 가운데 글자만 A이며 앞,뒤로는 무엇이든 상관없는 문자열.
-- ...
-- customer 테이블의 first_name 열에서 A로 시작하면서 뒤의 글자가 하나 있는 문자열을 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'A_';

-- customer 테이블의 first_name 열에서 A로 시작하면서 문자열 길이가 3인 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'A__';

-- 반대로 customer 테이블의 first_name 열에서 A로 끝나면서 문자열 길이가 3인 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE '__A';

-- customer 테이블의 first_name 열에서 A로 시작하고 A로 끝나면서 문자열 길이가 4인 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'A__A'; -- face..?

-- customer 테이블에서 5글자인 이름(first_name)을 찾는 쿼리는??
SELECT * FROM customer WHERE first_name LIKE '_____'; -- lollollol

-- underscore(_)와 %로 문자열 조회하기
-- customer 테이블의 first_name 열에서 A와 R 사이에 한 글자를 포함하여 시작하며 이후는 상관없는 문자열을 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'A_R%';

-- customer 테이블의 first_name 열에서 R 앞에 두 글자를 포함해 시작하며 이후는 상관없는 문자열을 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE '__R%';

-- customer 테이블의 first_name 열에서 A로 시작하고 R과 함께 마지막 한 글자가 더있는 문자열을 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'A%R_';
