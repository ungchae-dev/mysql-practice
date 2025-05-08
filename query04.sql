-- query03.sql에서 생성한 doitsql DB 사용
-- 데이터베이스 선택
USE sakila;

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

