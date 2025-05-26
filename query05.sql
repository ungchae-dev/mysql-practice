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

-- 외부 조인
-- 두 테이블을 조인해 둘 중 한 테이블에만 있는 데이터를 조회해야 하는 경우엔?
-- 외부 조인(OUTER JOIN)을 사용함
-- ex) 상품을 주문한 고객과 상품을 주문하지 않은 고객 데이터를 모두 조회하는 경우라면
-- 외부 조인 사용 가능. 외부 조인은 열(column)의 일치 여부를 고려하지 않고
-- 한 쪽 테이블과 다른 쪽 테이블에 조인할 때 사용
--
-- 외부 조인(OUTER JOIN)의 기본 형식
-- SELECT
-- [column]
-- FROM [table1]
-- [LEFT | RIGHT | FULL] OUTER JOIN [table2] ON [table1.column] = [table2.column]
-- WHERE [condition(검색 조건)]
-- 
-- OUTER JOIN은 LEFT, RIGHT, FULL 중 한 옵션을 지정해 사용
-- ex) A, B 테이블이 좌우에 나란히 있는 경우라면, 
-- A 테이블을 기준으로 B 테이블을 조인하고 싶다면? LEFT를 사용
-- B 테이블을 기준으로 A 테이블을 조인하고 싶다면? RIGHT를 사용

-- LEFT OUTER JOIN한 결과 조회
SELECT
a.address, a.address_id AS a_address_id, 
b.address_id AS b_address_id, b.store_id
FROM address AS a
LEFT OUTER JOIN store AS b 
ON a.address_id = b.address_id;
-- sakila DB의 두 테이블 address와 store의 
-- 열(column) address_id를 사용해 address 테이블을 기준으로 외부 조인한 쿼리문.
-- store 테이블에 없는 address_id의 경우 NULL로 출력된 걸 알 수 있다.
-- => A와 B의 벤 다이어그램에서 A에 해당함

-- LEFT OUTER JOIN으로 조회한 결과에서 NULL만 조회
SELECT
a.address, a.address_id AS a_address_id, 
b.address_id AS b_address_id, b.store_id 
FROM address AS a 
LEFT OUTER JOIN store AS b ON a.address_id = b.address_id 
WHERE b.address_id IS NULL;
-- OUTER JOIN한 결과에서 NULL을 조회하면 
-- 기준 테이블(여기서 왼쪽 테이블)에만 존재하는 데이터를 조회할 경우에 사용한다.
-- => A와 B의 벤 다이어그램에서 A-B에 해당함
