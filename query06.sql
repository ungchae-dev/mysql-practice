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

-- 데이터 형 변환 함수 - CAST, CONVERT
-- 명시적 형 변환: 사용자가 임의로 형 변환하는 과정
-- 형 변환을 위해 사용하는 함수의 예로 CAST, CONVERT가 있음

-- CAST 함수의 기본 형식
-- SELECT CAST(열 AS 데이터 유형) FROM 테이블;

-- CONVERT 함수의 기본 형식
-- SELECT CONVERT(열, 데이터 유형) FROM 테이블;
-- => CONVERT 함수는 CAST 함수와 달리 문자열 집합을 다른 문자열 집합으로 변환할 수 있음

-- CAST, CONVERT에 사용 가능한 데이터 유형
-- • BINARY • CHAR • DATE • DATETIME • TIME 
-- • DECIMAL • JSON • NCHAR • SIGNED[INTEGER] • UNSIGNED[INTEGER]
-- JSON은 MySQL 5.7.8 version부터 제공됨

-- CAST 함수를 통해 문자열 '2'라는 글자를 부호가 없는 정수형 2로 변경
SELECT
	4 / '2', -- 문자열 2
    4 / 2, -- 정수형 숫자 2
    4 / CAST('2' AS UNSIGNED); -- 부호가 없는 정수형으로 변경
    
-- NOW 함수로 현재 날짜와 시간 출력
SELECT NOW();

-- CAST 함수를 통해 NOW 함수로 가져온 값을 정수형으로 변환
SELECT CAST(NOW() AS SIGNED);
-- NOW() 함수 실행 결과와 달리, 날짜와 시간을 구분하는 기호 없이
-- 날짜가 숫자 형식으로 이루어진 데이터가 출력됨

-- 반대로 CAST 함수로 숫자형을 날짜형으로 변환
SELECT CAST(20250628 AS DATE);
-- 결과는 년,월,일 구분 가능

-- CAST 함수로 숫자형을 문자열로 변환
SELECT CAST(20250628 AS CHAR);

-- 다음으로 CONVERT 함수는 인자 2개를 넘겨 사용함
-- CONVERT 함수는 CAST 함수와 사용법이 거의 비슷하지만
-- CAST에서는 지원하지 않는 스타일을 정의할 수 있음.

-- CONVERT 함수로 날짜형을 정수형으로 변환
SELECT CONVERT(NOW(), SIGNED);

-- CONVERT 함수로 숫자형을 날짜형으로 변환
SELECT CONVERT(20250628, DATE);

-- CAST, CONVERT 함수 사용 시, 
-- AS CHAR(5) 또는 CHAR(5)와 같이 문자열의 길이를 지정할 수 있고
-- 문자열 길이 지정 시, 문자열을 변환할 때 CHAR(5)와 같이
-- 지정한 값보다 문자열 길이가 작으면 문자열이 잘려 출력됨
SELECT CONVERT(20250628, CHAR(5));
-- CHAR(5)로 길이를 5로 지정했기 때문에 문자열이 5개까지만 출력됨.

-- 만약, 엄청 큰 수에 1을 더하는 쿼리를 작성하면?
SELECT 9223372036854775807 +1;
-- 실행 결과: Error Code: 1690. BIGINT value is out of range in '(9223372036854775807 + 1)'
-- 가장 큰 숫자형(BIGINT)의 범위를 넘어 overflow가 발생한다.
-- overflow(오버플로)?
-- '넘쳐흐르다'라는 의미로, 컴퓨터에서 오버플로는 데이터 유형에 따른 한계값을 넘었다는 뜻.

-- 오버플로를 예방하고 싶다면?
-- A1. CAST 함수를 통해 입력값을 UNSIGNED로 변경하여 연산하면 OK.
SELECT CAST(9223372036854775807 AS UNSIGNED) +1;

-- A2. CONVERT 함수를 통해 overflow 방지
SELECT CONVERT(9223372036854775807, UNSIGNED) +1;

-- NULL을 대체하는 함수 - IFNULL, COALESCE
-- NULL: 어떤 연산 작업을 진행해도 NULL이 반환됨.
-- 그래서 테이블에 NULL이 있는 경우 문자열 또는 숫자로 데이터를 바꾸는 게 좋다.
-- NULL을 치환하기 위해 IFNULL 함수를 사용
-- IFNULL 함수를 사용하면 NULL을 대체할 다른 값으로 변환함.

-- IFNULL 함수의 기본 형식
-- IFNULL(열, 대체할 값)

-- COALESCE 함수도 NULL을 대체하는데 여러 열 이름을 인자로 전달함
-- COALESCE 함수의 기본 형식
-- COALESCE(열 1, 열 2, ...)
-- => COALESCE 함수는 IFNULL과 달리 NULL이 아닌 값이 나올 때까지
-- 후보군의 여러 열을 입력할 수 있음

-- doit_null 테이블 생성
CREATE TABLE doit_null (
	col_1 INT, 
    col_2 VARCHAR(10), 
    col_3 VARCHAR(10), 
    col_4 VARCHAR(10), 
    col_5 VARCHAR(10)
);

INSERT INTO doit_null VALUES (1, NULL, 'col_3', 'col_4', 'col_5');
INSERT INTO doit_null VALUES (2, NULL, 'col_3', 'col_4', 'col_5');
INSERT INTO doit_null VALUES (2, NULL, NULL, NULL, 'col_5');
INSERT INTO doit_null VALUES (3, NULL, NULL, NULL, NULL);

SELECT * FROM doit_null;

-- col_2 열의 값이 NULL이면 IFNULL 함수를 통해 공백 ('')으로 대체
SELECT col_1, IFNULL(col_2, '') AS col_2, col_3, col_4, col_5
FROM doit_null
WHERE col_1 = 1;

-- col_2 열의 값이 NULL이면 col_3 열의 값으로 대체
SELECT col_1, IFNULL(col_2, col_3) AS col_2, col_3, col_4, col_5
FROM doit_null 
WHERE col_1 = 1;
-- 실행 결과: col_2 열의 데이터가 col_3 열에 있던 col_3 데이터로 대체됨

-- COALESCE 함수는 1번째 인자로 전달한 열에 NULL이 있을 때
-- 그 다음 인자로 작성한 열의 데이터로 대체함.
-- 만약 이 함수에 N개의 인자를 작성햇다면? 순차로 대입함

-- col_2의 값이 NULL일 때 다음 인자인 col_3의 데이터도 NULL이면
-- 그 다음 인자인 col_4의 데이터를 확인하여 대입하는 쿼리
SELECT col_1, COALESCE(col_2, col_3, col_4, col_5)
FROM doit_null
WHERE col_1 = 2;

-- 만약 마지막 인자까지도 NULL이 저장되어있다면?
SELECT col_1, COALESCE(col_2, col_3, col_4, col_5)
FROM doit_null
WHERE col_1 = 3;
-- 실행 결과, 결국 NULL을 반환.

-- 소문자 또는 대문자로 변경하는 함수 - LOWER, UPPER
-- LOWER: 대문자를 소문자로 변경하는 함수
-- UPPER: 소문자를 대문자로 변경하는 함수

-- LOWER 함수로 소문자로, UPPER 함수로 대문자로 변경
SELECT 'DO IT! MYSQL <-> do it! mysql', 
	LOWER('DO IT! MYSQL'), UPPER('do it! mysql');
    
-- LOWER 함수로 소문자로, UPPER 함수로 대문자로 변경 (2)
SELECT email, LOWER(email), UPPER(email)
FROM customer;

-- 공백을 제거하는 함수 - LTRIM, RTRIM, TRIM
-- 만약, 사용자가 회원가입을 할 때 실수로 ID나 Password 뒤에
-- 의도하지 않은 공백을 입력하고 DataBase에서 공백을 허용했다면?
-- 이후 사용자가 로그인할 때 아이디, 비밀번호를 제대로 입력해도
-- 공백이 입력되지 않아 인증 처리가 제대로 되지 않는 문제가 발생함

-- 이같이 실수로 공백을 입력해도 데이터가 공백 없이 저장되도록 공백을 제거하는 함수가 있는데
-- LTRIM, RTRIM, TRIM 함수가 그에 해당된다.
-- LTRIM: 문자열의 왼쪽(앞, LEFT) 공백을 제거
-- RTRIM: 문자열의 오른쪽(뒤, RIGHT) 공백을 제거
-- TRIM: 양쪽 공백을 모두 제거

-- LTRIM 함수로 왼쪽 공백 제거
SELECT '       Do it! MySQL', LTRIM('       Do it! MySQL');

-- RTRIM 함수로 왼쪽 공백 제거
SELECT 'Do it! MySQL       ', RTRIM('Do it! MySQL       ');

-- TRIM 함수로 문자열의 양쪽 공백 제거
SELECT '       Do it! MySQL       ', TRIM('       Do it! MySQL       ');

-- TRIM 함수는 공백이 아닌 앞뒤에 있는 특정 문자를 제거하는 기능도 있다.
-- TRIM 함수로 문자열 양 끝에 있는 '#' 제거
SELECT TRIM(BOTH '#' FROM '#       Do it! MySQL       #');
-- BOTH: 왼쪽과 오른쪽의 접두사(여기서 #)를 제거하는 명령문
-- TRIM 함수의 문자 제거 기능은 LTRIM, RTRIM 함수들에는 없음.
-- 대신, 이 쿼리에서 BOTH 대신 LEADING을 입력하면 왼쪽 문자가, 
-- TRAILING을 입력하면 오른쪽 문자가 제거됨

SELECT TRIM(LEADING '#' FROM '#       Do it! MySQL       #');
SELECT TRIM(TRAILING '#' FROM '#       Do it! MySQL       #');
