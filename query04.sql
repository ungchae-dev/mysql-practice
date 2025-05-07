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