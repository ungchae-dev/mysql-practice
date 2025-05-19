-- JOIN (조인)?
-- 다수의 테이블에서 데이터를 조회하는 쿼리 작성 방법들 중 가장 유용하게 활용할 수 있는 방법

-- INNER JOIN, 내부 조인: 벤 다이어그램의 교집합과 같다.
-- INNER JOIN의 기본 형식:
-- SELECT [column_name]
-- FROM [table_name1]
-- INNER JOIN [table_name2] ON [table_name1.column_name] = [table_name2.column_name]
-- WHERE [condition]

-- sakila 데이터베이스 사용
USE sakila;

-- customer 테이블과 address 테이블을 INNER JOIN(내부 조인)하여 first_name이 ROSA인 데이터를 조회하면?
SELECT 
	c.customer_id, c.store_id, c.first_name, c.last_name, c.email, c.address_id AS c_address_id, 
    a.address_id AS a_address_id, a.address, a.district, a.city_id, a.postal_code, a.phone, a.location 
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
WHERE c.first_name = 'ROSA';
