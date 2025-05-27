-- 5-1. JOIN (조인)?
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

-- RIGHT OUTER JOIN으로 외부 조인하기
-- => A와 B의 벤 다이어그램에서 B에 해당한다.

-- RIGHT OUTER JOIN한 결과 조회
SELECT
a.address, a.address_id AS a_address_id, 
b.address_id AS b_address_id, b.store_id 
FROM address AS a
RIGHT OUTER JOIN store AS b 
ON a.address_id = b.address_id;

-- RIGHT OUTER JOIN 결과에서 NULL이 있는 데이터 조회
-- => A와 B의 벤 다이어그램에서 B-A에 해당한다.
-- ex) 왼쪽: store 테이블, 오른쪽 address 테이블이 있고, 
-- 오른쪽 address 테이블 기준으로 store 테이블과 RIGHT OUTER JOIN한 뒤, 
-- address 테이블에 있는 데이터만 조회하는 쿼리?
SELECT 
a.address_id AS a_address_id, a.store_id, 
b.address, b.address_id AS b_address_id 
FROM store AS a
RIGHT OUTER JOIN address AS b ON a.address_id = b.address_id 
WHERE a.address_id IS NULL;

-- FULL OUTER JOIN으로 외부 조인하기
-- FULL OUTER JOIN? 
-- LEFT OUTER JOIN + RIGHT OUTER JOIN이라 생각해보기~
-- 단점: FULL OUTER JOIN은 양쪽 테이블에서 일치하지 않는 행도 모두 조회한다.
-- 즉, 조인 조건에 일치하지 않는 항목, 일치하는 항목 모두 표시되므로 실제 사용하는 경우는 드물다.
-- 사용하는 경우: 가끔 데이터베이스 디자인 or 데이터에 
-- 몇 가지 문제가 있어 데이터의 누락이나 오류를 찾아낼 때 사용함.
-- => A와 B의 벤 다이어그램에서 A+B에 해당한다.

-- MySQL에서는 FULL OUTER JOIN을 지원하지 않는다.
-- 따라서, FULL OUTER JOIN 효과를 내려면
-- LEFT OUTER JOIN의 결과와 RIGHT OUTER JOIN의 결과를 합치는 식으로 명령어 UNION을 사용한다.

-- FULL OUTER JOIN한 결과 조회 (왼쪽:store(tb), 오른쪽:address(tb))
SELECT 
a.address_id AS a_address_id, a.store_id, 
b.address, b.address_id AS b_address_id
FROM store AS a
LEFT OUTER JOIN address AS b 
ON a.address_id = b.address_id

UNION

SELECT
a.address_id AS a_address_id, a.store_id,
b.address, b.address_id AS b_address_id
FROM store AS a
RIGHT OUTER JOIN address AS b
ON a.address_id = b.address_id;
-- 결과를 조회하면 LEFT OUTER JOIN과 RIGHT OUTER JOIN의 결과가 합쳐진(UNION) 
-- FULL OUTER JOIN의 결과를 가져온다.

-- 왼쪽 테이블과 오른쪽 테이블에서 두 테이블의 데이터를 합한 데이터에서 
-- 공통된 데이터를 제외한 데이터만 추출하려면?
-- NULL 데이터를 조회한다.
-- => A와 B의 벤 다이어그램에서 (A-B)+(B-A)와 같다.

-- FULL OUTER JOIN으로 조회한 결과에서 NULL만 조회
-- 왼쪽 테이블: store, 오른쪽 테이블: address
SELECT
a.address_id AS a_address_id, a.store_id, 
b.address, b.address_id AS b_address_id
FROM store AS a
LEFT OUTER JOIN address AS b 
ON a.address_id = b.address_id
WHERE b.address_id IS NULL

UNION

SELECT
a.address_id AS a_address_id, a.store_id, 
b.address, b.address_id AS b_address_id
FROM store AS a
RIGHT OUTER JOIN address AS b 
ON a.address_id = b.address_id
WHERE a.address_id IS NULL;

-- 교차 조인(CROSS JOIN, = 카르테시안(cartesian) 곱)
-- 각 테이블의 모든 경우의 수를 조합한 데이터가 필요할 경우 사용
-- 
-- CROSS JOIN의 기본 형식
-- SELECT [column]
-- FROM [table 1]
-- CROSS JOIN [table 2]
-- WHERE [search condition(검색 조건)]

-- 교차 조인의 경우, 조건(WHERE) 설정을 안하면
-- 데이터의 양이 기하급수적으로 늘어나므로 주의할 것.
-- 보통, sample data를 만들거나 각 행에 같은 숫자의 데이터를 만들어야 할 때 활용함

-- 샘플 데이터 생성
CREATE TABLE doit_cross1(num INT);
CREATE TABLE doit_cross2(name VARCHAR(10));
-- 삽입
INSERT INTO doit_cross1 VALUES (1), (2), (3);
INSERT INTO doit_cross2 VALUES ('Do'), ('It'), ('SQL');

-- 교차 조인(CROSS JOIN)을 적용한 쿼리
SELECT
a.num, b.name
FROM doit_cross1 AS a 
CROSS JOIN doit_cross2 AS b
ORDER BY a.num;

-- num이 1인 데이터를 교차 조인을 통해 조회하는 쿼리
SELECT
a.num, b.name
FROM doit_cross1 AS a 
CROSS JOIN doit_cross2 AS b 
WHERE a.num = 1;

-- 셀프 조인(SELF JOIN)
-- 같은 테이블을 사용하는 특수한 조인.
-- 내부 조인(INNER JOIN), 외부 조인(OUTER JOIN), 교차 조인(CROSS JOIN)은 모두
-- 2개 이상의 테이블을 조인한 반면,
-- 셀프 조인은 자기 자신과 조인할 때 사용함.
--
-- 셀프 조인을 사용할 때 알아둘 점
-- 1) 자기 자신을 조인에 사용함
-- 2) ※ 반드시 테이블의 별칭을 사용해야 함 
-- 소스는 한 테이블이지만, 2개의 테이블처럼 사용하므로 각 테이블에 서로 다른 별칭을 사용해야하기 때문에.

-- SELF JOIN을 적용한 쿼리_1
SELECT a.customer_id AS a_customer_id, b.customer_id AS b_customer_id
FROM customer AS a
INNER JOIN customer AS b 
ON a.customer_id = b.customer_id;
-- 이 쿼리는 INNER JOIN을 통해 같은 테이블이지만 마치 2개의 테이블인 것처럼 조인해서 사용한 것. => 단, 별칭 사용 필수!

-- SELF JOIN을 적용한 쿼리_2
-- payment 테이블에서 전일 대비 수익이 얼마인지 조회하는 쿼리
SELECT
a.payment_id, a.amount AS yesterday_amount, b.payment_id, b.amount AS today_amount, 
b.amount - a.amount AS profit_amount
FROM payment AS a
LEFT OUTER JOIN payment AS b
ON a.payment_id = b.payment_id -1;
-- 오늘의 가격 b.amount와 어제의 가격 a.amount를 통해 매출을 비교해 수익의 증감을 알 수 있다.

--
-- 5-2. 쿼리 안에 또 다른 쿼리, 서브쿼리(subqueries)
-- 서브쿼리(subqueries): 쿼리 안에 포함되어 있는 또 다른 쿼리
-- 서브쿼리는 조인하지 않은 상태에서 다른 테이블과 일치하는 행을 찾거나
-- 조인 결과를 다시 조인할 때 사용할 수 있음.
--
-- 서브 쿼리의 특징
-- 1. 서브쿼리는 반드시 소괄호()로 감싸서 사용
-- 2. 서브쿼리는 주 쿼리(main query)를 실행하기 전에 1번만 실행됨
-- 3. 비교 연산자와 함께 서브쿼리를 사용할 경우, 서브쿼리를 연산자 오른쪽에 기술해야함
-- 4. 서브쿼리 내부에는 정렬 구문인 ORDER BY 절을 사용할 수 없음

-- WHERE 절에 서브쿼리 사용하기
-- 중첩 서브쿼리(nested subquery): 서브쿼리 중에 WHERE 절에 사용하는 서브 쿼리
-- 중첩 서브쿼리는 또 다른 SELECT 문을 사용한 결과를 주 쿼리의 조건값으로 사용함.
-- 서브쿼리를 비교 연산자와 함께 사용할 때는 반드시 서브쿼리의 반환 결과가 1건이라도 있어야 함
-- 만약 서브쿼리의 반환 결과가 2건 이상인 경우, 비교 연산자가 아닌 다중 행 연산자를 사용해야 함.

-- => 다중 행 연산자?
-- 다중 행 : 서브쿼리의 결과가 2건 이상인 것
-- 다중 행을 처리하기 위해 사용되는 연산자 (연산자: 설명)
-- IN: 서브쿼리의 결과에 존재하는 임의의 값과 동일한 조건 검색
-- ALL: 서브쿼리의 결과에 존재하는 모든 값을 만족하는 조건 검색
-- ANY: 서브쿼리의 결과에 존재하는 어느 하나의 값이라도 만족하는 조건 검색
-- EXISTS: 서브쿼리의 결과를 만족하는 값이 존재하는지 여부 확인

-- 단일 행 서브쿼리: 서브쿼리의 결과로 1행만 반환되는 쿼리
-- 단일 행 서브쿼리의 기본 형식
-- SELECT [column]
-- FROM [table]
-- WHERE [column] = (SELECT [column] FROM [table])

-- sakila DB 사용
USE sakila;

-- 단일 행 서브쿼리 적용
SELECT * FROM customer
WHERE customer_id = (
	SELECT customer_id FROM customer 
	WHERE first_name = 'ROSA'
);

-- 만약 WHERE 절에 사용한 서브쿼리가 여러 행을 반환하면?
-- 비교 연산자 규칙에 어긋나므로 오류 발생
SELECT * FROM customer
WHERE customer_id = (
	SELECT customer_id FROM customer 
    WHERE first_name IN ('ROSA', 'ANA')
);

SELECT * FROM customer
WHERE customer_id = (
	SELECT customer_id FROM customer 
	WHERE first_name IN ('ROSA', 'ANA')
 );
-- Error Code: 1242. Subquery returns more than 1 row
-- 서브쿼리 반환값이 1행 이상이어서 오류가 발생한 것.

-- 다중 행 서브쿼리 사용하기
-- 다중 행 서브쿼리: 서브쿼리에서 결과로 2행 이상이 반환되는 경우를 말함
-- 서브쿼리가 다중 행을 반환하기 위해선 다중 행 연산자
-- IN, ANY, EXISTS, ALL 등을 활용함.

-- IN 연산자를 활용한 다중 행 서브쿼리의 기본 형식
-- SELECT [column]
-- FROM [table] 
-- WHERE [column] IN (SELECT [column] FROM [table])

-- IN 연산자를 활용한 다중 행 서브쿼리 적용_1
SELECT * FROM customer
WHERE first_name IN ('ROSA', 'ANA');

-- IN 연산자를 활용한 다중 행 서브쿼리 적용_2
SELECT * FROM customer
WHERE customer_id IN (
	SELECT customer_id FROM customer 
    WHERE first_name IN ('ROSA', 'ANA')
);

-- 테이블 3개를 조인하는 쿼리
SELECT
	a.film_id, a.title
FROM film AS a
	INNER JOIN film_category AS b ON a.film_id = b.film_id
    INNER JOIN category AS c ON b.category_id = c.category_id
WHERE c.name = 'Action';

-- IN을 활용한 서브쿼리 적용 <= 테이블 3개를 조인하는 쿼리와 같은 결과를 내는 쿼리
SELECT
	film_id, title
FROM film 
WHERE film_id IN (
	SELECT a.film_id
    FROM film_category AS a
		INNER JOIN category AS b ON a.category_id = b.category_id
	WHERE b.name = 'Action'
);

-- NOT IN을 활용한 서브쿼리 적용_film이 Action이 아닌 행 조회
SELECT
	film_id, title
FROM film
WHERE film_id NOT IN (
	SELECT a.film_id
    FROM film_category AS a
		INNER JOIN category AS b ON a.category_id = b.category_id
	WHERE b.name = 'Action'
);

-- ANY를 사용하는 서브쿼리 3가지
-- ANY를 함께 사용해 서브쿼리의 결과값이 여러 개여도
-- 일치하는 모든 행을 메인쿼리에서 조회 가능
-- (1) = ANY를 활용한 서브쿼리
SELECT * FROM customer
WHERE customer_id = ANY (
	SELECT customer_id FROM customer
    WHERE first_name IN ('ROSA', 'ANA')
);
-- ROSA, ANA 각각 서브쿼리 결과값 customer_id가 112, 181인 데이터임.

-- 서브쿼리의 결과값보다 작은 값을 조건으로 하여 데이터(행)을 반환하는 쿼리
-- (2) < ANY를 활용한 서브쿼리
SELECT * FROM customer
WHERE customer_id < ANY (
	SELECT customer_id FROM customer
    WHERE first_name IN ('ROSA', 'ANA')
);
-- ROSA, ANA 각각 서브쿼리 결과값 customer_id가 112, 181인 데이터인데, 
-- 이보다 작은 값의 데이터를 조회한 것.

-- (3) > ANY를 활용한 서브쿼리
SELECT * FROM customer
WHERE customer_id > ANY (
	SELECT customer_id FROM customer 
    WHERE first_name IN ('ROSA', 'ANA')
);
-- ROSA, ANA 각각 서브쿼리 결과값 customer_id가 112, 181인데, 이 데이터들보다 큰 값의 데이터를 조회한 것.

-- 
-- EXISTS 연산자:
-- 서브쿼리의 결과값이 있는지 없는지를 확인해서 1행이라도 있으면 TRUE, 없으면 FALSE를 반환함.
-- WHERE 절에 EXISTS를 사용해 
-- 서브쿼리의 결과값이 1행이라도 있으면 TRUE를 반환해 메인쿼리를 실행하고
-- 메인쿼리에 작성된 전체 데이터를 검색하는 쿼리 작성해보기
SELECT * FROM customer
WHERE EXISTS(
	SELECT customer_id FROM customer 
    WHERE first_name IN ('ROSA', 'ANA')
);
-- WHERE 절에 사용된 서브쿼리의 결과가 2건이므로 TRUE를 반환해 메인쿼리가 실행됨.

-- 서브쿼리의 결과값이 없으면?
-- FALSE를 반환하여 메인쿼리를 실행하지 않고, 아무것도 나타나지 않음.
SELECT * FROM customer
WHERE EXISTS(
	SELECT customer_id FROM customer
    WHERE first_name IN ('KANG')
);
-- WHERE 절에 사용된 서브쿼리 결과값이 없어서 FALSE를 반환해 아무 결과가 없음(NULL)

-- EXISTS와 반대로 동작하는 NOT EXISTS를 사용한 서브쿼리
SELECT * FROM customer
WHERE NOT EXISTS(
	SELECT customer_id FROM customer
    WHERE first_name IN ('KANG')
);
-- WHERE 절에 사용된 서브쿼리 결과값이 없어서 FALSE로 판단하지만, 
-- NOT EXISTS를 선언했으므로 반대로 TRUE를 반환하여 메인 쿼리가 실행됨

-- ALL 연산자는 서브쿼리 결과값에 있는 모든 값을 만족하는 조건을 메인쿼리에서 검색하여 결과를 반환함.
SELECT * FROM customer
WHERE customer_id = ALL (
	SELECT customer_id FROM customer
    WHERE first_name IN ('ROSA', 'ANA')
);
-- 서브쿼리문에 해당하는 customer_id는 112, 181 두 가지.
-- 그렇다면 WHERE customer_id = ALL (112, 181)인데
-- 이는 'customer_id가 112와 같고, 181과도 같아야 한다'
-- 즉, 동시에 두 값 112, 181과 같아야 하므로 불가능한 조건이 된다.
-- 그래서 결과값이 NULL인 상태.
