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