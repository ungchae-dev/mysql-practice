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
-- AS(Alias), 별칭 사용한 이유?
-- customer, address 테이블 모두 address_id를 열 이름으로 가지므로
-- 따로 별칭을 통해 지정하지 않으면 어느 테이블의 address_id 열 인지 애매(ambiguous)하기 때문에
-- 별칭 AS를 사용한다.

-- 2개의 조건으로 INNER JOIN한 테이블에서 조건에 맞는 데이터 조회
SELECT 
	c.customer_id, c.first_name, c.last_name, 
    a.address_id, a.address, a.district, a.postal_code 
FROM customer AS c 
INNER JOIN address AS a ON c.address_id = a.address_id 
AND c.create_date = a.last_update
WHERE c.first_name = 'ROSA';

-- INNER JOIN으로 table 3개 이상 JOIN 하기
-- 테이블을 3개 이상 JOIN할 때는 두 테이블의 관계가 다:다(many-to-many)인 경우가 많다.

-- 테이블이 3개 이상일 때 INNER JOIN의 기본 형식:
-- SELECT [column_name]
-- FROM [table_name1]
-- INNER JOIN [table2] ON [table1.column] = [table2.column]
-- INNER JOIN [table3] ON [table.column] = [table3.column]
-- WHERE [condition]

-- 3개의 테이블 customer, address, city를 INNER JOIN 하여 조건에 맞는 데이터 조회
SELECT
	cu.customer_id, cu.first_name, cu.last_name, 
    ad.address_id, ad.address, ad.district, ad.postal_code, -- postal_code: 우편 번호
    ci.city_id, ci.city
FROM customer AS cu
INNER JOIN address AS ad ON cu.address_id = ad.address_id -- address_id: 주소 번호
INNER JOIN city AS ci ON ad.city_id = ci.city_id -- city_id: 도시 번호
WHERE cu.first_name = 'ROSA';
