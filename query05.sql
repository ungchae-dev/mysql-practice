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

-- FROM 절에 서브쿼리(= inline view, 인라인 뷰) 사용하기
-- FROM 절에 사용한 서브쿼리 결과는 테이블처럼 사용되어 다른 테이블과 다시 조인할 수 있음.
-- 
-- FROM 절에 사용하는 서브쿼리의 기본 형식
-- SELECT
-- [column_1], [column_2], .., [column_3]
-- FROM [table] AS a
--   INNER JOIN (SELECT [column] FROM [table] WHERE [column] = [value]) AS b ON [a.column] = [b.column]
-- WHERE [column] = [value]
-- => 내부 조인(INNER JOIN) 뿐만 아니라 외부 조인(OUTER JOIN)도 사용 가능

-- 테이블 조인하기 (INNER JOIN으로 구성된 쿼리)
-- 테이블 별칭) a: film 테이블, b: film_category 테이블, c: category 테이블
SELECT
	a.film_id, a.title, a.special_features, c.name
FROM film AS a
	INNER JOIN film_category AS b ON a.film_id = b.film_id
    INNER JOIN category AS c ON b.category_id = c.category_id
WHERE a.film_id > 10 AND a.film_id < 20;

-- FROM 절에 INNER JOIN을 사용해 서브쿼리로 작성해보기 => inline view, 인라인 뷰
-- 서브쿼리의 결과가 테이블처럼 동작해 다시 다른 테이블과 조인하는 방식으로 처리됨
-- 테이블 별칭) a: film 테이블, b: film_category 테이블, c: category 테이블
SELECT 
	a.film_id, a.title, a.special_features, x.name
FROM film AS a
	INNER JOIN (
		SELECT
			b.film_id, c.name
		FROM film_category AS b
			INNER JOIN category AS c ON b.category_id = c.category_id
		WHERE b.film_id > 10 AND b.film_id < 20
    ) AS x ON a.film_id = x.film_id;
-- 실행 결과 위의 쿼리문과 현재 쿼리문 모두 결과는 같음
-- 조인으로 나온 결과를 서브쿼리로도 똑같이 작성할 수 있다.
-- ps) 인라인 뷰, 소괄호 ()로 묶은 쿼리만 따로 드래그해 실행하는 것도 가능함.

-- 스칼라 서브쿼리(scalar subqueries)
-- SELECT 절에 사용하는 서브쿼리
-- SELECT 절에 사용하는 서브쿼리는 반드시 1개의 행을 반환해야 하므로
-- 집계함수인 SUM, COUNT, MIN, MAX 등과 함께 사용하는 경우가 많음.
-- 하지만 이럴 경우 성능 면에서 문제가 생기기 쉬워 집계 함수와 사용하는 걸 권하진 않는 편임.
-- 
-- problem) 서브쿼리 + 집계함수 성능 문제 발생 원인
-- 서브쿼리가 SELECT 절에 있을 때
-- 메인쿼리의 각 행마다 서브쿼리가 실행될 가능성이 큼.
-- >>> 서브쿼리 안에 SUM, COUNT, MIN, MAX 등 집계함수를 쓰면
-- 각 행별로 데이터를 집계하는 작업이 반복적으로 발생해 비용이 커질 수 있음
-- 특히, 데이터가 많거나 복잡한 조건일 때
-- 쿼리 실행 시간이 급격히 늘어나거나 서버 부하가 커질 수 있다. <<<
-- 
-- alternative) 대안 및 권장 사항
-- JOIN이나 GROUP BY, 윈도우 함수로 집계 처리
-- 한 번에 집계 결과를 얻도록 쿼리를 작성하는 게 성능상 훨씬 좋음
-- 서브쿼리 결과를 미리 계산해 임시 테이블로 만들기 => 중복 계산 방지
-- 인덱스 최적화 및 쿼리 튜닝 => 불가피하게 서브쿼리 + 집계가 필요한 경우에도 최적화 시도
-- 
-- ps) 윈도우 함수(Window Function)?
-- 윈도우 함수는 테이블의 각 행에 대해 집계나 순위 계산 등을 수행하되, 
-- 결과를 행 단위로 반환하는 함수.
-- 전체 그룹 집계 결과를 하나의 값으로 반환하는 일반 집계 함수(SUM, COUNT 등)와 달리, 
-- 각 행마다 집계 결과를 보여줄 수 있어서 훨씬 유연함.
-- 
-- 윈도우 함수 예시_(함수명: 설명)
-- ROW_NUMBER(): 각 행에 고유 순위 번호 부여
-- RANK(), DENSE_RANK(): 순위 계산(중복 순위 가능)
-- SUM() OVER(): 누적 합계 또는 파티션별 합계 계산
-- AVG() OVER(): 파티션별 평균 계산
-- COUNT() OVER(): 파티션별 행 개수 계산
-- 
-- 스칼라 서브쿼리의 기본 형식
-- SELECT
--   [column], (SELECT <aggregate function, 집계 함수> [column] FROM [table_2]
--   WHERE [table_2.column] = [table_1.column]) AS a
-- FROM [table_1]
-- WHERE [condition, 조건]

-- 테이블 조인하기
-- 테이블 별칭) a: film 테이블, b: film_category 테이블, c: category 테이블
SELECT
	a.film_id, a.title, a.special_features, c.name
FROM film AS a
	INNER JOIN film_category AS b ON a.film_id = b.film_id
	INNER JOIN category AS c ON b.category_id = c.category_id
WHERE a.film_id > 10 AND a.film_id < 20;

-- SELECT 절에 서브쿼리 적용
-- 테이블 별칭) a: film 테이블, b: film_category 테이블, c: category 테이블
SELECT
	a.film_id, a.title, a.special_features,
    (SELECT c.name FROM film_category AS b
    INNER JOIN category AS c ON b.category_id = c.category_id
    WHERE a.film_id = b.film_id) AS name
FROM film AS a
WHERE a.film_id > 10 AND a.film_id < 20;
-- 조인으로 나온 결과를 서브쿼리로도 똑같이 작성할 수 있다는 걸 알 수 있음.


USE sakila; -- sakila DB 사용
-- CTE (Common Table Expression) 공통 테이블 표현식?
-- 실제 데이터베이스에 생성되는 테이블은 아니지만
-- 쿼리 실행 결과를 테이블처럼 활용하기 위한 논리적인 테이블을 만들 때 활용하는 표현식
-- 목적에 따라 1)일반 공통 테이블 표현식, 결과를 재사용하는 2)재귀 공통 테이블 표현식으로 나뉨

-- 일반 CTE의 기본 형식
-- WITH [table] (column1, column2, ...)
-- AS
-- (
-- 	<SELECT ...>
-- )
-- SELECT [column] FROM [table];

-- 일반 CTE로 데이터 조회하기
WITH cte_customer (customer_id, first_name, email)
AS
(
	SELECT customer_id, first_name, email
    FROM customer 
    WHERE customer_id >= 10 AND customer_id < 100
)
SELECT * FROM cte_customer;
-- 일반 CTE는 복잡한 쿼리를 단순하게 만들 때 유용하게 사용된다.

-- 일반 CTE에서 열(column) 불일치로 인한 오류 발생 예시
WITH cte_customer (customer_id, first_name, email) 
AS
(
	SELECT customer_id, first_name, last_name, email 
    FROM customer
    WHERE customer_id >= 10 AND customer_id < 100
)
SELECT * FROM cte_customer;
-- 오류가 발생한 이유는?
-- CTE에 정의된 열(column)과 SELECT문에 정의된 열의 개수가 달라서 오류가 발생한 것.

-- UNION으로 CTE 결합하기
-- UNION 연산자(UNION, UNION ALL 등)는 여러 쿼리의 결과를 
-- 하나의 데이터 집합으로 결합하는 데 사용하는 명령문으로, 
-- CTE 뿐만 아니라 다양한 쿼리문에서 사용 가능함.
-- 그리고 중복 데이터를 제거하는 연산을 포함하는 UNION 대신 UNION ALL을 사용하는 것을 권장함

-- UNION ALL로 CTE 결합하기
WITH cte_customer (customer_id, first_name, email) 
AS
(
	SELECT customer_id, first_name, email 
    FROM customer
    WHERE customer_id >= 10 AND customer_id <= 15
    
    UNION ALL
    
    SELECT customer_id, first_name, email 
    FROM customer
    WHERE customer_id >= 25 AND customer_id <= 30
)
SELECT * FROM cte_customer;
-- CTE 내부에 정의한 1번째 SELECT 결과 집합과
-- 2번째 SELECT 결과 집합을 UNION ALL으로 합쳐 하나의 데이터 집합으로 조회된 걸 확인할 수 있다.

-- 교집합으로 CTE 결합하기 (지금 사용중인 MySQL Workbench 8.0 CE 버전에서 INTERSECT를 지원하지 않으므로 EXISTS와 IN으로 대체)
-- 1) IN: 단일 컬럼 비교 시 사용
-- 2) EXISTS: 다중 컬럼 비교 시 사용 및 NULL 값 처리를 안전하게 함
-- 3) INNER JOIN: 테이블 사이의 JOIN 조건에 맞는 데이터를 반환

-- 1) IN 연산자로 CTE 결합하기 (단일 컬럼일 때)
WITH cte_customer (customer_id, first_name, email) 
AS
(
	SELECT customer_id, first_name, email
    FROM customer
    WHERE customer_id >= 10 AND customer_id <= 15
    AND customer_id IN (
		SELECT customer_id
		FROM customer
		WHERE customer_id >= 12 AND customer_id <= 20
	)
)
SELECT * FROM cte_customer;

-- 2) EXISTS로 CTE 결합하기 (다중 컬럼일 때)
WITH cte_customer (customer_id, first_name, email)
AS 
(
	SELECT DISTINCT customer_id, first_name, email
    FROM customer c1
    WHERE customer_id >= 10 AND customer_id <= 15
    AND EXISTS (
		SELECT 1 FROM customer c2 
        WHERE c2.customer_id = c1.customer_id
        AND c2.first_name = c1.first_name 
        AND c2.email = c1.email 
        AND c2.customer_id >= 12 AND C2.customer_id <= 20
    )
)
SELECT * FROM cte_customer;
-- SELECT 1: 존재 여부만 확인
-- c1에서 customer_id가 10~15인 각 행을 하나씩 검사
-- 각 행마다 c2에서 동일한 customer_id, first_name, email을 가지면서 
--  customer_id가 12~20 범위에 있는 행이 존재하는지 확인
-- 존재하면 그 행을 결과에 포함
-- 결과: customer_id가 12~15인 고객들 (교집합)

-- 3) INNER JOIN으로 CTE 결합하기 (테이블 사이의 JOIN 조건에 맞는 데이터를 반환)
WITH cte_customer (customer_id, first_name, email) 
AS 
(
	SELECT DISTINCT t1.customer_id, t1.first_name, t1.email 
    FROM (
		SELECT customer_id, first_name, email
        FROM customer 
        WHERE customer_id >= 10 AND customer_id <= 15
    ) t1 
    INNER JOIN (
		SELECT customer_id, first_name, email
        FROM customer 
        WHERE customer_id >= 12 AND customer_id <= 20
    ) t2 ON t1.customer_id = t2.customer_id
		AND t1.first_name = t2.first_name 
        AND t1.email = t2.email
)
SELECT * FROM cte_customer;
-- t1: customer_id가 10~15인 고객들 조회
-- t2: customer_id가 12~20인 고객들 조회
-- 두 결과에서 customer_id, first_name, email이 모두 일치하는 행들만 연결
-- 결과: customer_id가 12~15인 고객들 (교집합)

-- 교집합으로 CTE 결합하기 (지금 사용중인 MySQL Workbench 8.0 CE 버전에서 EXCEPT를 지원하지 않으므로 NOT EXISTS와 NOT IN으로 대체)
-- 1) NOT IN: 단일 컬럼 비교 시 사용
-- 2) NOT EXISTS: 다중 컬럼 비교 시 사용 및 NULL 값 처리를 안전하게 함
-- 3) LEFT JOIN & IS NULL: 테이블 사이의 JOIN 조건에 맞는 데이터를 반환

-- 차집합으로 CTE 결합하기
-- 1) NOT IN으로 CTE 결합하기 (단일 컬럼일 때)
WITH cte_customer (customer_id, first_name, email) 
AS (
	SELECT customer_id, first_name, email
    FROM customer 
    WHERE customer_id >= 10 AND customer_id <= 15
    AND customer_id NOT IN (
		SELECT customer_id
		FROM customer 
		WHERE customer_id >= 12 AND customer_id <= 20
    )
)
SELECT * FROM cte_customer;

-- 2) NOT EXISTS로 CTE 결합하기 (직관적)
WITH cte_customer (customer_id, first_name, email) 
AS (
    SELECT DISTINCT customer_id, first_name, email
    FROM customer c1
    WHERE customer_id >= 10 AND customer_id <= 15
    AND NOT EXISTS (
		SELECT 1 FROM customer c2 -- SELECT 1: 존재 여부만 확인
		WHERE c2.customer_id = c1.customer_id
        AND c2.first_name = c1.first_name 
        AND c2.email = c1.email 
        AND c2.customer_id >= 12 AND c2.customer_id <= 20
	)
)
SELECT * FROM cte_customer;

-- 3) LEFT JOIN & IS NULL로 CTE 결합하기
WITH cte_customer 
AS (
	SELECT DISTINCT t1.customer_id, t1.first_name, t1.email 
    FROM (
		SELECT customer_id, first_name, email 
        FROM customer 
        WHERE customer_id >= 10 AND customer_id <= 15
    ) t1 
    LEFT JOIN (
		SELECT customer_id, first_name, email 
        FROM customer 
        WHERE customer_id >= 12 AND customer_id <= 20
    ) t2 ON t1.customer_id = t2.customer_id
		AND t1.first_name = t2.first_name 
        AND t1.email = t2.email
	WHERE t2.customer_id IS NULL -- t2에 없는 것만 선택
)
SELECT * FROM cte_customer;

-- 2-2) 2번 NOT EXISTS 쿼리문에서 customer_id의 순서를 변경하여 CTE 결합하기
WITH cte_customer (customer_id, first_name, email) 
AS (
    SELECT DISTINCT customer_id, first_name, email
    FROM customer c1
    WHERE customer_id >= 12 AND customer_id <= 20 -- 1)
    AND NOT EXISTS (
		SELECT 1 FROM customer c2 -- SELECT 1: 존재 여부만 확인
		WHERE c2.customer_id = c1.customer_id
        AND c2.first_name = c1.first_name 
        AND c2.email = c1.email 
        AND c2.customer_id >= 10 AND c2.customer_id <= 15 -- 2)
	)
)
SELECT * FROM cte_customer;
-- 결과는?
-- 당연히 customer_id가 12 이상 20 이하에서 10 이상 15 이하를 제외한 나머지
-- customer_id = 16 이상 20 이하의 데이터만 남음

-- 재귀 CTE
-- 재귀?
--  함수 내부에서 함수가 자기 자신을 다시 호출하는 것
-- 재귀 CTE?
--  CTE 결과를 CTE 내부 쿼리에서 재사용함으로써 반복 실행하는 쿼리 구조
-- 재귀 CTE는 조직도와 같은 계층 데이터를 검색할 때 많이 사용되며, 실행 과정이 복잡함.

-- 재귀 CTE의 기본 형식
-- WITH RECURSIVE [CTE_table] (column 1, column 2, ...)
-- AS (
-- 	SELECT * FROM table A -- 쿼리 1: 앵커 멤버
--     UNION ALL 
--     SELECT * FROM table B 
--     JOIN CTE_table -- 쿼리 2: 재귀 멤버
-- )
-- SELECT * FROM [CTE_table];

-- 재귀 CTE의 조건:
-- 1) 2개 이상의 SELECT문을 사용할 것
-- 2) 앵커 멤버(anchor member)와 재귀 멤버(recursive member)를 포함해야 하며, 
--  앵커 멤버는 1번째 재귀 멤버 앞에 있을 것
-- 3) 재귀 멤버 열(column)의 데이터 유형은 앵커 멤버 열의 데이터 유형과 일치할 것
-- + 앵커 멤버와 재귀 멤버는 여러 개 정의할 수 있음

-- 피보나치 수열?
-- 숫자 0과 1 (또는 1과 1)로 시작하며
-- 두 수를 합친 값이 그 다음 수가 되어 이어진다.
-- ex) 0, 1, 1, 2, 3, 5, 8, 13, ...
-- 재귀 CTE는 재귀 멤버에 의해 생성된 각 행이 이전의 결과 행을 참조하여
-- 다시 계산하는 방식이므로 피보나치 수열을 생성할 수 있음.

-- 재귀 CTE로 처음 2개의 숫자로 0과 1을 사용하여 20개의 피보나치 수열 생성하기
WITH RECURSIVE fibonacci_number (n, fibonacci_n, next_fibonacci_n) 
AS (
	SELECT 1, 0, 1
    UNION ALL
    SELECT n + 1, next_fibonacci_n, fibonacci_n + next_fibonacci_n
    FROM fibonacci_number
    WHERE n < 20
)
SELECT * FROM fibonacci_number;

-- FINAL QUIZ
-- Q1. world 데이터베이스에는 country, city 테이블이 있습니다. 
-- country 테이블의 Name 열에서 'United States'인 데이터와 city 테이블에서
-- 해당 국가와 일치하는 데이터를 조회하는 쿼리를 작성하세요.
-- 이 때, 조인을 활용한 쿼리를 작성해보세요.
use world;

SELECT co.*, ci.*
FROM country AS co
	INNER JOIN city AS ci
    ON co.Code = ci.CountryCode
WHERE co.Name = 'United States';

-- Q2. world 데이터베이스의 city 테이블에서 인구가 가장 많은 도시 상위 10개를 구하고
-- country 테이블에서 해당 도시의 국가 이름과 국가 총 인구, GNP, 수명 등의 정보를 
-- 조회하는 쿼리를 작성하세요. 이 때, 조인 또는 서브 쿼리를 활용해 쿼리를 작성해보세요.

-- A1. using INNER JOIN
SELECT 
	ci.Name AS city_name, ci.CountryCode, ci.District, ci.Population AS city_population, 
    co.Name AS country_name, co.Population AS country_population, co.GNP, co.LifeExpectancy
FROM city AS ci
	INNER JOIN country AS co 
    ON ci.CountryCode = co.Code
ORDER BY ci.Population DESC LIMIT 10;

-- A2. using Subquery
SELECT
	ci.Name AS city_name, ci.CountryCode, ci.District, ci.Population, 
    co.Name AS country_name, co.Population, co.GNP, co.LifeExpectancy
FROM (
	SELECT
		Name, CountryCode, District, Population
	FROM city
    ORDER BY Population DESC LIMIT 10
) AS ci
	INNER JOIN country AS co 
    ON ci.CountryCode = co.Code;

-- Q3. world 데이터베이스에서 countrylanguage 테이블과 country 테이블을 조합하여
-- 사용 언어가 English인 국가의 정보를 조회하는 쿼리를 작성하세요.
-- 이 때, JOIN으로 조회하는 쿼리와 Subquery로 조회하는 쿼리 등 원하는 방법으로 쿼리를 작성하세요.

-- A1. using INNER JOIN
SELECT c.*
FROM countrylanguage AS cl
	INNER JOIN country AS c
    ON cl.CountryCode = c.Code
WHERE cl.Language = 'English';

-- A2. using Subquery
SELECT * FROM country
WHERE Code IN (
	SELECT CountryCode
    FROM countrylanguage
    WHERE Language = 'English'
);

-- Q4. sakila 데이터베이스에는 actor, film, film_actor, film_category, category 테이블이 있습니다.
-- category 테이블의 name 열(column)이 'Action'인 데이터와 관련된
-- 배우 이름(first_name, last_name), 영화 제목(title)과 개봉 연도(release_year)를
-- 조회하는 쿼리를 작성하세요.

USE sakila;

SELECT 
	a.first_name, a.last_name, f.title, f.release_year, c.name AS category_name
FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    INNER JOIN film AS f ON fa.film_id = f.film_id
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY title;
