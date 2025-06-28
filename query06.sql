-- 6. 다양한 SQL 함수 사용하기
-- 6-1. 문자열 함수
-- 문자열과 문자열을 연결하는 함수 CONCAT
-- : 연결할 문자열을 괄호 안에 쉼표로 구분해 
-- 함수의 인자(함수가 호출될 때 함수에 전달되는 값)로 나열
-- CONCAT 함수 예
-- SELECT CONCAT('I', 'Love', 'MySQL') AS col_1;

-- sakila DataBase 사용
USE sakila;

-- CONCAT 함수로 열(column) 이름과 문자열 연결
SELECT CONCAT(first_name, ', ', last_name) AS customer_name 
FROM customer;

-- 여러 열(column)을 합칠 때 모든 열 이름 사이에 일일이 쉼표를 입력하기는 번거로움.
-- 이때 CONCAT_WS를 사용하면 구분자를 미리 정의해 자동으로 적용 가능
-- 1번째 인수에 나머지 인수를 구분하기 위한 기호를 넣어보면?

-- CONCAT_WS 함수로 구분자 지정
SELECT CONCAT_WS(', ', first_name, last_name, email) AS customer_name
FROM customer;
-- 연결할 문자열 사이에 구분 기호(, )가 추가된 걸 알 수 있다.

-- 만약 인수로 NULL을 입력하면?
SELECT CONCAT(NULL, first_name, last_name) AS customer_name
FROM customer;
-- 모두 NULL이 반환됨
-- NULL이 어떠한 문자열과 결합하거나 계산되더라도 결과가 NULL이기 때문이다.

-- CONCAT_WS 사용 시 합치려는 열에 NULL이 있으면?
-- 결과는 NULL이 아닌 NULL을 제외한 결합 문자가 출력됨
SELECT CONCAT_WS(', ', first_name, NULL, last_name) AS customer_name
FROM customer;

-- ※ in MySQL, +: 문자열끼리 연결할 때 사용
-- in MySQL, ||: 논리 연산자 OR
-- in Oracle, ||: 문자열끼리 연결할 때 사용
