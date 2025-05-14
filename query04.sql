-- query03.sql에서 생성한 doitsql DB 사용
-- sakila 데이터베이스 선택
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

-- REGEXP(regular expression)으로 더 다양하게 데이터 조회하기
-- regular expression: 정규 표현식 => 앞 세 글자씩 따서 REGEXP로 표현.
-- 정규 표현식은 특정 패턴의 문자열을 표현하기 위해 사용.

-- MySQL에서 지원하는 정규 표현식 (표현식 : 설명)
-- . : 줄 바꿈 문자(\n)를 제외한 임의의 한 문자를 의미
-- * : 해당 문자 패턴이 0번 이상 반복
-- + : 해당 문자 패턴이 1번 이상 반복
-- ^ : 문자열의 처음을 의미
-- $ : 문자열의 끝을 의미
-- | : OR을 의미
-- [...] : 대괄호[] 안에 있는 어떠한 문자를 의미
-- [^...] : 대괄호[] 안에 있지 않은 어떠한 문자를 의미
-- {n} : 반복되는 횟수를 지정
-- {m,n} : 반복되는 횟수의 최솟값과 최댓값을 지정

-- 정규 표현식을 사용해 customer 테이블의 first_name 열에서 
-- K로 시작하거나 N으로 끝나는 모든 데이터를 조회하면?
SELECT * FROM customer WHERE first_name REGEXP '^K|N$';

-- 정규 표현식을 사용해 customer 테이블의 first_name 열에서
-- K와 함께 L과 N 사이의 문자를 포함한 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name REGEXP 'K[L-N]';

-- 정규 표현식을 사용해 customer 테이블의 first_name 열에서 
-- K와 함께 L과 N 사이의 문자를 포함하지 않는 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name REGEXP 'K[^L-N]';

-- 와일드카드 더 활용해 보기 (와일드카드를 잘 조합하면 원하는 대로 데이터를 조회할 수 있다.)
-- customer 테이블의 first_name 열에서 S로 시작하는 문자열 데이터 중에 
-- A 뒤에 L과 N 사이의 문자가 있는 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE 'S%' AND first_name REGEXP 'A[L-N]';

-- customer 테이블의 first_name 열에서 총 7글자이고, 
-- A 뒤에 L과 N 사이의 글자가 있고, 마지막 글자는 O인 문자열 데이터를 모두 조회하면?
SELECT * FROM customer WHERE first_name LIKE '_______' 
AND first_name REGEXP 'A[L-N]' 
AND first_name REGEXP 'O$';

-- 4-5. GROUP BY 절로 데이터 묶기
-- GROUP BY 절: 데이터를 그룹화하고 싶을 때 사용
-- HAVING 절: 데이터 그룹을 필터링할 때 사용
-- 
-- SELECT [column] FROM [table] 
-- WHERE [column] = [condition] 
-- GROUP BY [column] HAVING [column] = [condition]

-- GROUP BY 절로 데이터 그룹화하기
-- 데이터를 그룹화할 때는 반드시 '그룹화할 기준 열'을 지정해야 한다.
--
-- film 테이블에서 special_features 열의 데이터를 그룹화하여 조회하면?
SELECT special_features FROM film GROUP BY special_features;

-- film 테이블에서 rating 열의 데이터를 그룹화하여 조회하면?
SELECT rating FROM film GROUP BY rating;

-- 2개 이상의 열을 기준으로 그룹화하기
-- 열을 2개 이상 지정해 그룹화할 때는 GROUP BY에 열을 순서대로 작성하면
-- 그 순서대로 데이터를 그룹화한다.
--
-- film 테이블에서 special_features와 rating을 그룹화하고 조회하면?
SELECT special_features, rating FROM film 
GROUP BY special_features, rating;

-- 반대로 film 테이블에서 rating과 special_features를 그룹화하고 조회하면?
SELECT rating, special_features FROM film 
GROUP BY rating, special_features;
-- 열 순서만 바뀌었고, 쿼리 결과는 모두 같은 개수의 데이터(행)를 조회한다.

-- COUNT로 그룹화한 열의 데이터 개수 세기
-- COUNT는 집계 함수 중 하나이다.
-- 
-- film 테이블에서 special_features 열을 기준으로 데이터를 그룹화하고, 
-- special_features 열과 각 데이터 그룹에 속한 데이터가 몇 개인지 cnt라는 별칭으로 조회하면?
SELECT special_features, COUNT(*) AS cnt 
FROM film 
GROUP BY special_features;

-- film 테이블에서 special_features, rating 열을 기준으로 데이터를 그룹화하고, 
-- 각 그룹의 데이터와 데이터가 몇 개인지 cnt 라는 별칭으로 조회하면?
-- (단, 해당 조회 데이터들 기준으로 내림차순 정렬할 것.)
SELECT special_features, rating, COUNT(*) AS cnt 
FROM film 
GROUP BY special_features, rating 
ORDER BY special_features, rating, cnt DESC;

-- 데이터를 그룹화할 때는?
-- '기준이 되는 열이 필요하므로 SELECT 문에 사용한 열을 반드시 GROUP BY 절에도 사용해야 한다.'
-- SELECT 문과 GROUP BY 절의 열 이름을 다르게 하면?
-- 당연히 오류가 발생한다.

-- HAVING 절로 그룹화한 데이터 필터링하기
--
-- 그룹화한 데이터에서 데이터를 필터링하려면?
-- HAVING 절을 사용한다.
-- WHERE 절 (cf) HAVING 절
-- WHERE 절: 테이블에 있는 열에 대해 적용
-- HAVING 절: SELECT문으로 조회한 열 / GROUP BY 절에 그룹화한 열에만 필터링 적용
-- 
-- film 테이블에서 special_features, rating 열을 기준으로 그룹화한 뒤, 
-- rating 열에서 G인 데이터만 필터링해 조회하면?
SELECT special_features, rating 
FROM film 
GROUP BY special_features, rating 
HAVING rating = 'G';

-- film 테이블에서 special_features 열을 기준으로 그룹화한 뒤, 
-- 해당 열과 각 그룹에서 데이터의 개수가 70보다 큰 것을 cnt란 별칭으로 조회하면?
SELECT special_features, COUNT(*) AS cnt 
FROM film 
GROUP BY special_features 
HAVING cnt > 70; 

-- 그룹화하지 않은 열에 HAVING 절을 사용하면?
-- SELECT special_features, COUNT(*) AS cnt 
-- FROM film 
-- GROUP BY special_features 
-- HAVING rating = 'G'; 
-- 당연히 에러 발생

-- 위 에러 쿼리에서 film 테이블에서 special_features, rating 열을 기준으로 그룹화한 뒤,  
-- rating이 R인 값과 데이터의 개수가 8보다 큰 값을 조회하여 쿼리문 수정해보기 
-- (단, 개수는 별칭 'cnt'로 사용할 것.)
SELECT special_features, rating, COUNT(*) AS cnt 
FROM film
GROUP BY special_features, rating 
HAVING rating = 'R' AND cnt > 8;

-- DISTINCT로 중복된 데이터 제거하기
-- 
-- GROUP BY 절을 사용하지 않고 같은 열에 있는 중복 데이터를 제거하고 싶다면?
-- DISTINCT를 사용한다.
-- 기본 형식:
-- SELECT DISTINCT [column] FROM [table]

-- DISTINCT로 film 테이블의 special_features, rating 열에서 
-- 중복된 데이터를 제거하여 조회하면?
SELECT DISTINCT special_features, rating 
FROM film;

-- 쿼리 실행 결과는 GROUP BY 절로 얻은 결과와 같다.
SELECT special_features, rating FROM film 
GROUP BY special_features, rating;

-- DISTINCT와 COUNT 함수를 같이 사용하여 열을 조회해보기
-- 
-- SELECT DISTINCT special_features, rating, COUNT(*) AS cnt 
-- FROM film;
-- 
-- 에러가 발생한다. 이유는?
-- GROUP BY 절을 사용하지 않아서.
-- COUNT 함수는 그룹별로 집계를 하는 '집계함수' 중 하나이므로 반드시 GROUP BY와 함께 사용한다.
SELECT special_features, rating, COUNT(*) AS cnt 
FROM film 
GROUP BY special_features, rating
ORDER BY rating, cnt DESC;
-- 예를 들면 이런 식으로.

-- 4-6. 테이블 생성 및 조작하기
CREATE DATABASE IF NOT EXISTS doitsql;
-- database exists.

-- AUTO_INCREMENT로 데이터 입력하기
-- doitsql 데이터베이스 선택
USE doitsql;

-- 첫번째 열에 AUTO_INCREMENT를 적용하여 테이블 생성
DROP TABLE doit_increment; -- 기존 테이블 삭제

CREATE TABLE doit_increment (
col_1 INT AUTO_INCREMENT PRIMARY KEY, 
col_2 VARCHAR(50), 
col_3 INT
);

SELECT * FROM doit_increment;

INSERT INTO doit_increment (col_2, col_3) VALUES ('1 자동 입력', 1);
INSERT INTO doit_increment (col_2, col_3) VALUES ('2 자동 입력', 2);

SELECT * FROM doit_increment; 
-- 테이블 생성 시 AUTO_INCREMENT로 지정했기 때문에 col_1 열의 값이 자동 증가함.

-- AUTO_INCREMENT가 정의된 열에 값을 입력하면?
INSERT INTO doit_increment (col_1, col_2, col_3) 
VALUES (3, '3 자동 입력', 3);

SELECT * FROM doit_increment;
-- 정상적으로 값이 삽입된 결과 확인~

-- 그럼, 자동 입력되는 값보다 큰 값을 입력한 경우는?
INSERT INTO doit_increment (col_1, col_2, col_3) 
VALUES (5, '4 건너뛰고 5 자동 입력', 5);

SELECT * FROM doit_increment;

-- 그럼 처음 상황으로 돌아가 1열을 다시 제외하고 데이터를 입력한 경우는?
INSERT INTO doit_increment (col_2, col_3) VALUES ('어디까지 입력되었을까?', 6);
SELECT * FROM doit_increment;
-- 5 다음 값인 6이 자동으로 잘 입력된다.

-- AUTO_INCREMENT로 자동 생성된 마지막 값 확인하기
-- 데이터를 입력하다 보면 숫자가 연속적으로 입력되는 것이 아니므로 
-- AUTO_INCREMENT가 적용됐을 때 데이터가 어디까지 입력됐는 지 확인하고 싶다면?
SELECT LAST_INSERT_ID();
-- LAST_INSERT_ID()?
-- 현재 마지막 AUTO_INCREMENT 값을 보여준다.

-- AUTO_INCREMENT 시작값 변경하기
-- AUTO_INCREMENT를 다시 적용했을 때 다른 값으로 시작하도록 설정해보면?
-- ※단, 이미 해당 열에 입력된 값이 있으므로 그 값보다 큰 값으로 설정할 것.

-- 다음 INSERT 시 시작할 숫자를 바꾸는 쿼리?
-- ALTER TABLE [table_name] AUTO_INCREMENT=[number];
-- 자동으로 입력되는 값을 100부터 시작하기
ALTER TABLE doit_increment AUTO_INCREMENT=100;
INSERT INTO doit_increment (col_2, col_3) VALUES ('시작값이 변경되었을까?', 0);

SELECT * FROM doit_increment;

-- AUTO_INCREMENT 증가값 변경하기
-- 자동으로 입력되는 값이 1이 아닌 5씩 증가하도록 수정할 수 있을까?
-- 
-- MySQL에서는 SET을 사용해서 시스템 변수나 사용자 변수의 값을 설정할 수 있다.
-- 형식: SET [시스템 변수] = [값];
-- 
-- @@? 
-- MySQL의 시스템 변수(system variable)를 참조할 때 사용하는 특별한 문법
-- AUTO_INCREMENT가 자동 증가할 때 한 번에 5씩 증가하도록 설정하는 쿼리문은?
SET @@AUTO_INCREMENT_INCREMENT = 5;

INSERT INTO doit_increment (col_2, col_3) VALUES ('5씩 증가할까? (1)', 0);
INSERT INTO doit_increment (col_2, col_3) VALUES ('5씩 증가할까? (2)', 0);

SELECT * FROM doit_increment;
-- AUTO_INCREMENT의 col_1 데이터는 100 다음 101로 1 증가한 다음부터 5씩 자동 증가하게 된다.

-- 조회 결과를 다른 테이블에 입력하려면?
-- INSERT INTO ~ SELECT를 사용한다.
-- ※이 때 꼭 입력하려는 테이블과 조회한 열의 데이터 유형이 같을 것.

-- 1) 먼저 2개 테이블 doit_insert_select_from과 doit_insert_select_to를 생성한다.
-- 이 때 2개 열 col_1, col_2에 해당하는 데이터 유형을 
-- INT, VARCHAR(10)으로 두 테이블 모두 일치시킨다.
CREATE TABLE doit_insert_select_from (
col_1 INT, 
col_2 VARCHAR(10)
);

CREATE TABLE doit_insert_select_to (
col_1 INT, 
col_2 VARCHAR(10)
);

-- 2) 초기 데이터를 doit_insert_select_from에 삽입하기
INSERT INTO doit_insert_select_from VALUES (1, 'Do');
INSERT INTO doit_insert_select_from VALUES (2, 'It');
INSERT INTO doit_insert_select_from VALUES (3, 'MySQL');

-- 3) doit_insert_select_from 테이블의 모든 데이터를 조회해 
-- doit_insert_select_to 테이블로 삽입하기 (거꾸로 생각해서 쿼리 작성해보기)
SELECT * FROM doit_insert_select_from;
SELECT * FROM doit_insert_select_to;

INSERT INTO doit_insert_select_to 
SELECT * FROM doit_insert_select_from;

-- 4) doit_insert_select_to 테이블의 전체 데이터 조회하기
SELECT * FROM doit_insert_select_to;

-- 열 이름 입력 대신 SELECT 문을 통해 새로운 테이블 생성하기
-- AS와 ()를 통해 쿼리문을 작성한다.
CREATE TABLE doit_select_new 
AS (SELECT * FROM doit_insert_select_from);

SELECT * FROM doit_select_new;
-- 테이블 생성 시 기존 테이블 doit_insert_select_from에 있던
-- 컬럼들과 각 컬럼에 해당하는 데이터 그대로 삽입되어 생성됨.
