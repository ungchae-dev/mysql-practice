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

-- 문자열 크기 또는 개수를 반환하는 함수 - LENGTH, CHAR_LENGTH
-- LENGTH 함수는 문자열의 크기로 바이트를 반환함

-- LENGTH 함수로 문자열의 크기 반환
SELECT LENGTH('Do it! MySQL'), LENGTH('두잇 마이에스큐엘');

-- LENGTH 함수로 다양한 문자의 크기 반환
SELECT LENGTH('A'), LENGTH('강'), LENGTH('漢'), LENGTH('◁'), LENGTH(' ');
-- 영어 및 공백은 1byte, 한글·한자·특수문자는 3byte를 사용함

-- byte 크기로는 문자열의 개수를 정확히 알기 어렵기 때문에
-- 문자열 개수를 확인하고 싶다면 CHAR_LENGTH 함수를 사용함

-- CHAR_LENGTH 함수로 문자열의 개수 반환
SELECT CHAR_LENGTH('Do it! MySQL'), CHAR_LENGTH('두잇 마이에스큐엘');
-- 'Do it! MySQL'의 문자열 개수: 띄어쓰기를 포함해 12를 반환
-- '두잇 마이에스큐엘' 문자열 개수: 9를 반환

-- LENGTH와 CHAR_LENGTH 함수에는 문자열 대신 열 이름(column name)을 인수로 전달할 수 있음.
-- LENGTH와 CHAR_LENGTH 함수에 열 이름 전달
SELECT first_name, LENGTH(first_name), CHAR_LENGTH(first_name)
FROM customer;
-- 열 이름을 넣어 실행하면 각 행에 저장된 문자열의 크기와 개수를 반환함을 알 수 있음

-- 특정 문자까지의 문자열 길이를 반환하는 함수 - POSITION
-- POSITION 함수로 특정 문자(!)까지의 크기 반환
SELECT 'Do it!! MySQL', POSITION('!' IN 'Do it!! MySQL');
-- 1번째 느낌표까지 문자열 길이 6을 반환함

-- POSITION 함수는 지정한 문자가 탐색 대상이 되는 문자열에 존재하지 않으면 0을 반환하고, 
-- 찾을 대상인 문자열이 NULL인 경우 NULL을 반환함
SELECT 'Do it!! MySQL', POSITION('#' IN 'Do it!! MySQL');

-- 지정한 길이만큼 문자열을 반환하는 함수 - LEFT, RIGHT
-- LEFT 함수: 문자열의 왼쪽부터 정의한 위치만큼의 문자열을 반환
-- RIGHT 함수: 문자열의 오른쪽부터 정의한 위치만큼의 문자열을 반환
-- 아래와 같이 'DoitSQL'이라는 문장이 있다면 문자열을 셀 때 시작값은 1이 됨.
-- [1][2][3][4][5][6][7]
--  D  o  i  t  S  Q  L

-- LEFT와 RIGHT 함수로 왼쪽과 오른쪽 2개의 문자열 반환
SELECT 'Do it! MySQL', LEFT('Do it! MySQL', 2), RIGHT('Do it! MySQL', 2);

-- 지정한 범위의 문자열을 반환하는 함수 - SUBSTRING
-- SUBSTRING 함수는 지정한 범위의 문자열을 반환하며,
-- 함수의 2번째 인자에 시작 위치를,
-- 3번째 인자에 시작 위치로부터 반환할 문자열 개수를 입력함

-- SUBSTRING 함수로 지정한 범위의 문자열 반환 (4번째 문자부터 문자 2개를 반환)
SELECT 'Do it! MySQL', SUBSTRING('Do it! MySQL', 4, 2);

-- SUBSTRING 함수도 열 이름을 인수로 전달해 사용할 수 있음
-- SUBSTRING 함수에 열 이름 전달 (first_name 열에 저장된 데이터의 2번째 문자부터 문자 3개를 반환)
SELECT first_name, SUBSTRING(first_name, 2, 3) 
FROM customer;

-- SUBSTRING 함수는 POSITION 함수와 함께 사용할 수 있다.
-- POSITION 함수로 @ 문자 위치 계산 후 SUBSTRING 함수를 통해 @ 바로 앞까지의 문자열을 조회하는 쿼리
SELECT SUBSTRING('abc@gmail.com', 1, POSITION('@' IN 'abc@gmail.com') -1);
-- 문자열의 1번째 문자부터 시작해 POSITION 함수를 통해
-- @ 까지의 문자열의 크기를 반환 후 그 수에서 -1을 더한 크기만큼(3개의 문자열)의 값인
-- abc를 출력함

-- 특정 문자를 다른 문자로 대체하는 함수 - REPLACE
-- REPLACE 함수: 지정한 문자를 다른 문자로 대체하는 함수
-- customer 테이블의 first_name 열에서 A로 시작하는 데이터의 A를 C로 대체
SELECT first_name, REPLACE(first_name, 'A', 'C')
FROM customer
WHERE first_name LIKE 'A%';

-- 문자를 반복하는 함수 - REPEAT
-- REPEAT 함수: 지정한 문자를 반복할 때 사용하는 함수
-- 이때, 반복할 문자와 반복횟수를 인자로 전달

-- REPEAT 함수로 문자 0을 10번 반복하여 출력
SELECT REPEAT('0', 10);
-- ※ 숫자에 ''를 붙이면? 문자열이 됨.

-- REPEAT 함수는 REPLACE 함수와 함께 사용할 수 있다.
-- REPEAT과 REPLACE 함수 조합
SELECT first_name, REPLACE(first_name, 'A', REPEAT('C', 10))
FROM customer 
WHERE first_name LIKE '%A%'
ORDER BY first_name;
-- %A%를 사용해 A가 포함도니 모든 데이터를 조회한 뒤
-- 대문자 A를 10개의 C로 대체함.

-- 공백 문자를 생성하는 함수 - SPACE
-- SPACE 함수는 지정한 인자만큼 공백을 생성한다.
-- CONCAT 함수로 문자열을 연결할 때 열과 열 사이에 공백 문자 10개를 추가하는 쿼리
SELECT CONCAT(first_name, SPACE(10), last_name)
FROM customer;

SELECT CONCAT(first_name, ' ', last_name)
FROM customer;

-- 문자열을 역순으로 출력하는 함수 - REVERSE
-- REVERSE: 문자열을 거꾸로 정렬하는 함수
-- 예를 들어, 다양한 문자열 함수와 혼합해 이메일에서 도메인의 자릿수나 IP 대역을 구할 때 등
-- 다양하게 활용할 수 있음

-- REVERSE 함수로 문자열을 역순으로 반환
SELECT 'Do it! MySQL', REVERSE('Do it! MySQL');

-- CTE를 활용해 REVERSE 함수와 다른 여러 함수(POSITION, CHAR_LENGTH, SUBSTRING)의 조합으로
-- IP 주소의 3번째 부분까지의 정보만 조회하는 쿼리
WITH ip_list (ip)
AS (
	SELECT '192.168.0.1' UNION ALL
    SELECT '10.6.100.99' UNION ALL
    SELECT '8.8.8.8' UNION ALL
    SELECT '192.200.212.113'
)
SELECT ip, SUBSTRING(ip, 1, CHAR_LENGTH(ip) - POSITION('.' IN REVERSE(ip)))
FROM ip_list;
-- 1) CHAR_LENGTH(ip) 함수를 사용해 IP 열에 대한 전체 길이를 구한 뒤
-- 2) POSITION('.' IN REVERSE(ip)) 함수를 사용해 IP 열에 대해 
-- 뒤에서부터 가장 먼저 나오는 .(점)까지의 길이를 구함
-- 3) SUBSTRING에서 IP 전체 길이에서 1부터 시작해 POSITION 길이를 뺀 만큼 문자열을 출력함.

-- 문자열을 비교하는 함수 - STRCMP
-- STRCMP: 두 문자열을 비교해 같은지 알려주는 함수
-- 비교하는 문자열이 같을 경우 0을, 다를 경우 1을 반환함

-- STRCMP 함수로 두 문자열의 비교: (1)동일한 경우
SELECT STRCMP('Do it! MySQL', 'Do it! MySQL');

-- STRCMP 함수로 두 문자열의 비교: (2)동일하지 않은 경우
SELECT STRCMP('Do it! MySQL', 'D0 it! MySQL');


-- 6-2. 날짜 함수
-- 같은 년, 월, 일, 요일 등 조건에 따라 데이터를 검색할 때
-- 날짜 함수를 사용하면 편리한 점이 많다.

-- 서버의 현재 날짜나 시간을 반환하는 다양한 함수
-- CURRENT_DATE: 접속 중인 데이터베이스 서버의 현재 날짜를 확인할 때 사용하는 함수
-- CURRENT_TIME: 시간을 알고 싶을 때 사용하는 함수
-- CURRENT_TIMESTAMP: 날짜와 시간을 합쳐 확인하고 싶을 때 사용하는 함수

-- 날짜 함수로 현재 날짜나 시간 반환
SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP(), NOW();

-- ms, µs (밀리초, 마이크로초)와 같이 정밀한 시각을 반환
SELECT CURRENT_DATE(), CURRENT_TIME(3), CURRENT_TIMESTAMP(3), NOW(3);
-- 시간을 반환하는 함수에 인수로 3을 입력: 밀리초 (ms) 단위까지 출력하도록 요청

-- UTC(Universal Time Coordinated): 세계 표준 시간, 국제 표준 시간의 기준으로 쓰이는 시각
-- UTC_DATE: 현재 접속 중인 데이터베이스 서버의 UTC 날짜를 확인하는 함수
-- UTC_TIME: UTC 시간을 확인하는 함수
-- UTC_TIMESTAMP: 날짜와 시간을 함께 확인하는 함수

-- UTC_DATE, UTC_TIME, UTC_TIMESTAMP 함수로 세계 표준 날짜나 시간 반환
SELECT CURRENT_TIMESTAMP(3), UTC_DATE(), UTC_TIME(3), UTC_TIMESTAMP(3);

-- 날짜를 더하거나 빼는 함수 - DATE_ADD, DATE_SUB
-- DATE_ADD: 날짜를 더하거나 뺄 때 사용하는 함수
-- 1번째 인자로 날짜 데이터를 입력, 2번째 인자로 INTERVAL과 함께 더하거나 빼려는 숫자와 년, 월, 일 등 단위를 삽입

-- DATE_ADD 함수로 1년 증가한 날짜 반환
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR);

-- DATE_ADD 함수로 1년 감소한 날짜 반환
SELECT NOW(), DATE_ADD(NOW(), INTERVAL -1 YEAR);

-- 날짜를 뺄 때, DATE_ADD 함수 대신 DATE_SUB 함수를 사용할 수 있음.
-- ※ 단, DATE_SUB 함수 사용 시, 빼는 숫자는 '양수(+)'로 입력할 것.
-- 음수(-) 입력 시 오히려 날짜를 더하게 됨
SELECT NOW(), DATE_SUB(NOW(), INTERVAL 1 YEAR);
SELECT NOW(), DATE_SUB(NOW(), INTERVAL -1 YEAR); -- -(-1 YEAR) == +1 YEAR이 되는 셈

-- DATE_ADD 함수에서 더하거나 빼는 숫자와 함께 사용하는 단위들:
-- • YEAR: 년 • QUARTER: 분기 • MONTH: 월 
-- • DAY: 일 • WEEK: 주 • HOUR: 시간 
-- • MINUTE: 분 • SECOND: 초 • MICROSECOND: 마이크로초 

-- 날짜 간 차이를 구하는 함수 - DATEDIFF, TIMESTAMPDIFF
-- DATEDIFF: 날짜 간 시간 차이를 구할 수 있는 함수
-- 시작 날짜, 종료 날짜를 인자로 받음. 함수 실행 결과의 기본값: 인수를 반환하는 것
-- TIMESTAMPDIFF: 일(DAY) 수가 아닌 년 또는 시간 등 다양한 단위로 확인하고 싶을 때 사용하는 함수

-- DATEDIFF 함수로 날짜 간의 일수 차 반환
SELECT NOW();
SELECT DATEDIFF('2025-12-31 23:59:59.9999999', '2025-01-01 00:00:00.0000000');
-- 2025년 12월 31일에서 2025년 01월 01일까지의 일수 차이는 365일로 출력됨

-- TIMESTAMPDIFF 함수로 날짜 간의 개월 수 차 반환
SELECT TIMESTAMPDIFF(MONTH, '2025-12-31 23:59:59.9999999', '2025-01-01 00:00:00.0000000');
-- 2025년 12월 31일에서 2025년 01월 01일까지의 개월 수 차이는 12개월로 출력됨
SELECT TIMESTAMPDIFF(YEAR, '2025-12-31 23:59:59.9999999', '2025-01-01 00:00:00.0000000'); -- 년(YEAR) 차이
SELECT TIMESTAMPDIFF(QUARTER, '2025-12-31 23:59:59.9999999', '2025-01-01 00:00:00.0000000'); -- 분기(QUARTER) 차이

-- 지정한 날짜의 요일을 반환하는 함수 - DAYNAME
-- DAYNAME 함수로 특정 날짜의 요일 반환
SELECT DAYNAME(NOW()); 

-- 날짜에서 년, 월, 주, 일을 값으로 가져오는 함수 - YEAR, MONTH, WEEK, DAY
-- YEAR: 날짜 데이터에서 년을 가져오는 함수
-- MONTH: 날짜 데이터에서 월을 가져오는 함수
-- WEEK: 날짜 데이터에서 주를 가져오는 함수
-- DAY: 날짜 데이터에서 일을 가져오는 함수

-- YEAR, MONTH, WEEK, DAY 함수로 년, 월, 주, 일을 별도의 값으로 반환
SELECT
	YEAR(NOW()), 
    MONTH(NOW()), 
    WEEK(NOW()), -- WEEK 함수: 해당 날짜가 1년 중 몇 번째 주에 해당하는지를 반환
    DAY(NOW());
    
-- 날짜 형식을 변환하는 함수 - DATE_FORMAT, GET_FORMAT
-- DATE_FORMAT: 날짜를 다양한 형식으로 표현해야할 때 사용하는 함수
-- 나라마다 날짜를 표현하는 방식이 다르므로 날짜 형식으로 변환해야할 때 필요

-- DATE_FORMAT 함수로 미국에서 사용하는 날짜 형식으로 변경
SELECT DATE_FORMAT(NOW(), '%m/%d/%Y');
-- DATE_FORMAT 함수를 통해 미국식으로 월(MONTH), 일(DAY), 년(YEAR) 순으로 날짜가 출력되도록 변경

-- '%m/%d/%Y' 외에도 다양한 조합으로 원하는 날짜 형식으로 결과 출력이 가능함.
-- 다양한 날짜 형식 변환의 예)
SELECT DATE_FORMAT(NOW(), '%Y%m%d'); -- 년, 월, 일 (YEAR, month, day)
SELECT DATE_FORMAT(NOW(), '%Y.%m.%d'); -- 날짜 구분자를 변경하여 출력
SELECT DATE_FORMAT(NOW(), '%H:%i:%s'); -- 지정한 날짜의 시, 분, 초(HOUR, minute, second)

-- 일부 국가에서는 년, 월, 일 (YEAR, MONTH, DAY) 순서를 다르게 사용하는데
-- 일일이 각 국가나 지역별 표준 날짜 형식을 모두 알기는 어렵기 때문에 이를 해결하기 위해 
-- 국가나 지역별 날짜 형식이 어떤지 알기 위해 사용하는 함수가 GET_FORMAT이다.

-- GET_FORMAT 함수로 국가나 지역별 날짜 형식 확인
SELECT GET_FORMAT(DATE, 'USA') AS USA, -- 미국
	GET_FORMAT(DATE, 'JIS') AS JIS, -- 일본 산업 표준
    GET_FORMAT(DATE, 'EUR') AS Europe, -- 유럽
    GET_FORMAT(DATE, 'ISO') AS ISO, -- 국제 표준화 기구
    GET_FORMAT(DATE, 'INTERVAL') AS `INTERVAL`; -- 내부 형식

SELECT DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'USA')) AS USA, 
	DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'JIS')) AS JIS, 
    DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'EUR')) AS Europe, 
    DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'ISO')) AS ISO;
-- (1) GET_FORMAT 함수로 날짜 형식을 불러온 뒤, (2) 그 형식에 따라 날짜를 출력한 것.

-- 6-3. 집계 함수
-- 집계 함수는 데이터를 그룹화해 계산할 때 자주 사용한다.
-- ex) 합계, 평균, 최댓값, 최솟값, 중간 합계, 표준편차 함수, ...

-- 조건에 맞는 데이터 개수를 세는 함수 - COUNT
-- COUNT: 조건에 맞는 데이터의 개수를 셀 때 사용하는 함수
-- 반환하는 데이터의 범위: BIGINT

USE sakila;

-- COUNT 함수로 customer 테이블의 데이터 개수 집계
SELECT COUNT(*) FROM customer;

-- COUNT 함수와 GROUP BY 절 조합
SELECT store_id, COUNT(*) AS cnt
FROM customer 
GROUP BY store_id;

-- COUNT 함수와 GROUP BY문 조합: 열 2개 활용
SELECT store_id, active, COUNT(*) AS cnt
FROM customer
GROUP BY store_id, active;

-- COUNT 함수 사용 시 주의할 점?
-- ※ COUNT 함수에 전체 열이 아닌 특정 열만 지정하여 집계할 경우 해당 열에 있는 NULL 값은 제외한다.
-- => 전체 데이터 개수와 COUNT 함수로 얻은 데이터 개수는 다를 수 있음

-- NULL을 제외한 집계 확인
SELECT COUNT(*) AS all_cnt, 
	COUNT(address2) AS ex_null 
FROM address;

-- COUNT 함수와 DISTINCT 조합
-- COUNT 함수 사용 시 DISTINCT를 조합해 중복된 값을 제외한 데이터 개수를 집계할 수 있음

-- COUNT 함수와 DISTINCT문 조합
SELECT COUNT(*), COUNT(store_id), COUNT(DISTINCT store_id)
FROM customer;
-- store_id 열에 1과 2 데이터가 중복되어 있기 때문에
-- DISTINCT store_id로 중복 데이터를 제외하여 조회한 뒤 COUNT 함수로 행 개수 2를 반환한 것.

-- 데이터의 합을 구하는 함수 - SUM
-- SUM: 모든 행의 값을 합하는 함수. 숫자 데이터를 더할 경우 사용
-- SUM 함수로 payment 테이블의 amount 열의 데이터 합산
SELECT SUM(amount) FROM payment;
SELECT amount FROM payment; -- 확인용

-- SUM 함수와 GROUP BY 절 조합
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id;
-- payment 테이블 전체 16044행에서 599개 행이 customer_id로 그룹화되고,
-- 각 그룹에 해당하는 amount 열의 값이 더해진 결과를 얻을 수 있음.

-- 암시적 형 변환으로 overflow 없이 합산 결과를 반환할 수 있을까?
CREATE TABLE doit_overflow (
	col_1 int, 
    col_2 int, 
    col_3 int
);

INSERT INTO doit_overflow VALUES (1000000000, 1000000000, 1000000000); -- col_1 ~ col_3에 각각 10억씩 총 3개 행의 데이터 삽입
INSERT INTO doit_overflow VALUES (1000000000, 1000000000, 1000000000);
INSERT INTO doit_overflow VALUES (1000000000, 1000000000, 1000000000);

SELECT SUM(col_1) FROM doit_overflow;
-- int의 범위는 -2,147,483,648 ~ 2,147,483,647 이다.
-- col_1 열의 데이터를 합산한 결과가 30억을 넘어 overflow가 발생해야 정상이지만, 
-- MySQL에서는 암시적 형 변환으로 DECIMAL이나 BIGINT로 합산한 결과를 반환한다.

-- 데이터의 평균을 구하는 함수 - AVG
-- AVG: 데이터들의 평균을 구할 때 사용하는 함수
-- AVG 함수는 NULL을 무시함.

-- AVG 함수로 payment 테이블의 amount 열의 데이터 평균 계산
SELECT AVG(amount) FROM payment;
-- 결과를 통해 알 수 있는 것?
-- AVG 함수의 인자로 열 이름을 넣으면 그 열에 있는 숫자 데이터의 평균을 계산한 결과를 얻을 수 있음

-- AVG 함수와 GROUP BY절 조합
SELECT customer_id, AVG(amount) 
FROM payment 
GROUP BY customer_id;

-- 최솟값이나 최댓값을 구하는 함수 - MIN, MAX
-- MIN과 MAX 함수로 payment 테이블의 amount 열의 최솟값과 최댓값 조회
SELECT MIN(amount), MAX(amount) FROM payment;
-- MIN, MAX 함수는 DISTINCT와 조합할 수 있지만, 최솟값과 최댓값 자체가 전체 데이터에서 1개만 잇는 값이므로
-- 오히려 DISTINCT를 쓰는 게 의미가 없음.

-- MIN과 MAX 함수와 GROUP BY절 조합
SELECT customer_id, MIN(amount), MAX(amount) 
FROM payment 
GROUP BY customer_id;

-- 부분합과 총합을 구하는 함수 - ROLLUP
-- 데이터의 부분합과 총합을 구하고 싶다면?
-- GROUP BY 문과 ROLLUP 함수를 조합하면 OK.
-- GROUP BY [열 이름] WITH ROLLUP 으로
-- 입력한 열을 기준으로 오른쪽에서 왼쪽으로 이동하며 부분합과 총합을 구하는 방식.

-- ROLLUP 함수로 부분합 계산
SELECT customer_id, staff_id, SUM(amount) 
FROM payment 
GROUP BY customer_id, staff_id WITH ROLLUP;
-- 실행 결과: customer_id와 staff_id 열을 그룹화한 것의 부분합인 것을 알 수 있음
-- ex) 3행: customer_id: 1, staff_id 열에 속한 데이터의 총합인 것
-- 마지막 행: customer_id와 staff_id 모두 NULL인 행의 전체 총합
-- ROLLUP 사용 시 GROUP BY 뒤의 순서에 따라 계층화 부분도 달라지므로
-- 계층화해서 합계를 보려면 열 순서를 잘 정할 수 있어야 함.

-- 데이터의 표준편차(standard deviation)를 구하는 함수 - STDDEV, STDDEV_SAMP
-- STDDEV: 모든 값에 대한 표준편차를 구하는 함수
-- STDDEV_SAMP: 표본(sample)에 대한 표준편차를 구하는 함수

-- STDDEV와 STDDEV_SAMP 함수로 표준편차 계산
SELECT STDDEV(amount), STDDEV_SAMP(amount)
FROM payment;

-- 6-4. 수학 함수
-- 수학 함수는 대부분 입력값과 같은 데이터 유형으로 값을 반환하지만
-- LOG, EXP, SQRT 같은 함수는 입력값을 실수형인 float로 자동 변환하고 반환한다.

-- 절댓값(absolute value)을 구하는 함수 - ABS
-- ABS: 절댓값을 반환하는 함수로 음수(-)나 양수(+)를 입력 시 모두 양수로 반환받음.
-- ABS 함수의 인자에 숫자가 아닌 수식을 입력해 절댓값을 반환받을 수도 있음

-- ABS 함수에 입력한 숫자를 절댓값으로 반환
SELECT ABS(-1.0), ABS(0.0), ABS(1.0); -- 음수, 0, 양수 3가지 경우

-- ABS 함수에 입력한 수식의 결과를 절댓값으로 반환
USE sakila; -- sakila DataBase 사용

SELECT p.amount - p2.amount AS amount,
	ABS(p.amount - p2.amount) AS abs_amount
FROM payment AS p
	INNER JOIN payment AS p2 ON p.payment_id = p2.payment_id -1;
-- payment 테이블에서 payment_id가 현재보다 -1인 payment_id를 찾아 amount 값을 뺀 결과.
-- 결과에 따라 음수 또는 양수이지만 ABS 함수로 모두 양수로 결과를 반환함

-- ABS 함수는 자료형의 범위를 넘으면 overflow가 발생하지만
-- MySQL 서버에선 BIGINT로 암시적 형 변환이 일어나 값이 반환됨.

-- 암시적 형 변환으로 overflow 없이 절댓값을 반환
SELECT ABS(-2147483648);

-- 양수 또는 음수 여부를 판단하는 함수 - SIGN
-- SIGN 함수는 지정한 값이나 수식 결과값이 양수, 음수, 0인지를 판단하여
-- 각각 1, -1, 0을 반환함.

-- SIGN 함수로 입력한 숫자가 양수인지 음수인지 0인지를 판단
SELECT SIGN(-256), SIGN(0), SIGN(256);

-- SIGN 함수의 인자로 수식을 입력해 수식을 계산한 결과가 양수인지 음수인지 0인지를 판단
SELECT p.amount - p2.amount AS amount,
	SIGN(p.amount - p2.amount) AS sign_amount
FROM payment AS p
	INNER JOIN payment AS p2 ON p.payment_id = p2.payment_id -1;

-- 천장값과 바닥값을 구하는 함수 - CEILING, FLOOR
-- CEILING: 천장값을 구하는 함수, 여기서 천장값이란 입력한 숫자보다 크거나 같은(>=) 최소 정수를 의미
-- ex) 2.4 라면 => 3을 반환함
-- FLOOR: 바닥값을 구하는 함수, 바닥값이란 지정한 숫자보다 작거나 같은(<=) 최대 정수를 의미
-- ex) 2.4 => 2를 반환

-- CEILING 함수로 천장값 반환
SELECT CEILING(2.4), CEILING(-2.4), CEILING(0.0);

-- FLOOR 함수로 바닥값 반환
SELECT FLOOR(2.4), FLOOR(-2.4), FLOOR(0.0);

-- 반올림을 반환하는 함수 - ROUND
-- ROUND: 입력된 숫자의 반올림을 반환하는 함수
-- ROUND 함수는 함수 자체는 간단하지만 사용 시 고려해야 할 게 많고, 인자는 2개가 필요함.

-- ROUND 함수의 기본 형식
-- ROUND(숫자, 자릿수)
-- 1) 1번째 인자: 반올림할 대상인 숫자 값 또는 열 이름을 넣어 사용
-- 2번째 인자: 반올림하여 표현할 자릿수 입력
-- ex) 인자 1: 123.1234, 인자 2: 3이라면 => ROUND 함수는 123.123을 반환
-- 2) 자릿수의 데이터 유형: 정수, 
-- 양수나 음수를 지정할 수 있는데 양수는 소수부터 반올림하고, 음수는 정수부터 반올림함.

-- ROUND 함수로 소수점 3째 자리까지 반올림
SELECT ROUND(99.9994, 3), ROUND(99.9995, 3);

-- ROUND 함수로 소수와 정수를 따로 반올림
SELECT ROUND(234.4545, 2), ROUND(234.4545, -2);
-- 1번째는 소수점 둘째 자리로 반올림하여 234.45를, 
-- 2번째는 10의 자리에서 반올림하여 200을 반환한 결과임을 알 수 있음.

-- ROUND 함수는 자릿수에 음수(-)를 전달할 때
-- 입력된 정수의 자릿수보다 더 큰 자릿수(절대값으로 비교)를 입력하면 0을 반환함.
-- 정수 부분의 길이보다 큰 자릿수를 입력한 경우
SELECT ROUND(748.58, -1); -- 1의 자리에서 반올림할 때
SELECT ROUND(748.58, -2); -- 10의 자리에서 반올림할 때
SELECT ROUND(748.58, -4); -- 1000의 자리에서 반올림해야 하는데 정수부인 748의 길이인 3보다 -4의 절댓값 4가 크므로 0을 반환

-- 로그를 구하는 함수 - LOG
-- 로그 함수와 지수 함수는 역함수 관계이다.
-- a^x = b <=> x = loga(b) 
-- a: 밑(base), b: 진수(value), x: 지수(exponent)

-- LOG 함수의 기본 형식
-- 1) 인자가 1개일 때(밑을 생략할 경우 자연 로그가 되며 밑의 기본값: e(exponential, 지수 => 2.718281828... 무리수 상수)
-- LOG(진수)
-- 2) 인자가 2개일 때
-- LOG(밑, 진수)

-- LOG 함수 계산 (1)
SELECT LOG(10);
-- 밑을 생략한 경우로 밑은 e(2.71828...)이고 진수는 10인 자연 로그: LOGe(10)

-- LOG 함수 계산 (2)
SELECT LOG(10, 5);

-- e의 n 제곱값을 구하는 함수 - EXP
-- EXP: e의 n 제곱값을 반환함. 여기서 e는 로그 함수의 기본 밑과 동일함.
-- EXP 함수도 결과를 실수형(float)으로 반환한다.

-- EXP 함수 기본 형태
-- EXP(지수 계산할 숫자 또는 식)

SELECT EXP(1.0);
-- 결과: e^1.0

SELECT EXP(10);

-- ※ LOG 함수와 EXP 함수는 역함수 관계
-- LOG 함수 <=> EXP 함수
SELECT EXP(LOG(20)), LOG(EXP(20));
-- 실수 변환에서 반올림 처리의 차이가 있을 뿐 결과는 20으로 같다 볼 수 있음

-- 거듭제곱값을 구하는 함수 - POWER
-- POWER 함수의 기본 형식
-- POWER(숫자 또는 수식, 지수)
-- 1번째 인자: 정수 또는 실수형(float)만 입력받을 수 있음
-- 2번째 인자: 거듭제곱할 정수 또는 실수를 입력받음
SELECT POWER(2, 3), POWER(2, 10), POWER(2.0, 3);
-- 실수를 거듭제곱했는데 결과는 정수로 반환됨을 알 수 있음

-- 제곱근(square root)을 구하는 함수 - SQRT
-- SQRT 함수의 기본 형식
-- SQRT(숫자 또는 수식)
-- 제곱근을 계산할 때 양수를 넣어야 하며, 음수를 넣을 경우 결과가 허수면 NULL이 반환됨.

SELECT SQRT(1.00), SQRT(10.00); -- 1의 제곱근, 10의 제곱근을 반환

-- 난수(random number)를 구하는 함수 - RAND
-- RAND: 0부터 1사이의 실수형 난수를 반환함.

-- RAND 함수의 기본 형식
-- RAND(인자)
-- 인자로 전달하는 값의 데이터 유형: tinyint, smallint, int
-- 인자를 지정하지 않을 경우, 임의의 초기값을 설정

SELECT RAND(100), RAND(), RAND();
-- RAND 함수는 같은 결과를 반환함

-- 위 쿼리문을 여러 번 실행해도 RAND(100)이 계속 같은 값을 반환하는 이유는?
-- 현재 쿼리 창에서 처음 함수를 실행할 때 임의로 정해진 초기값을 계속 재사용하기 때문임.

-- 인자를 설정하지 않은 채로 WHILE문을 사용해 난수를 4회 생성하는 쿼리를 작성해보기
-- RAND 함수 인자에 아무 것도 전달하지 않으면 DataBase가 설정한 임의의 값으로 난수 종류를 보여주기 때문에
-- 실행할 때마다 다른 난수를 볼 수 있음.
-- 또, MySQL에서 WHILE을 사용하려면 스토어드 프로시저를 생성해서 사용해야 한다. 아직 모르는 내용이지만 예습하는 겸 진행해보기.

-- 인수가 없는 RAND 함수로 난수 계산
DELIMITER $$
CREATE PROCEDURE rnd()
BEGIN
DECLARE counter INT;
SET counter = 1;

WHILE counter < 5 DO
	SELECT RAND() Random_Number;
    SET counter = counter + 1;
END WHILE;

END $$
DELIMITER ;

call rnd();

-- 삼각함수 - COS, SIN, TAN, ATAN(arctan, 아크탄젠트)
-- 삼각함수는 여러가지가 있지만 크게 4가지인 SIN, COS, TAN, ATAN 관련 쿼리를 보자.
-- 모든 삼각함수는 실수형 인자를 받는다.

-- COS 함수 계산
SELECT COS(14.78);

-- SIN 함수 계산
SELECT SIN(45.175643);

-- TAN 함수 계산
SELECT TAN(PI()/2), TAN(.45);

-- ATAN 함수 계산
SELECT ATAN(45.87) AS atanCalc1, 
	ATAN(-181.01) AS atanCalc2, 
    ATAN(0) AS atanCalc3, 
    ATAN(0.1472738) AS atanCalc4, 
    ATAN(197.1099392) AS atanCalc5;

-- 6-5. 순위 함수
-- 순위 함수: 조회 결과에 순위를 부여하는 함수
-- MySQL에서 제공하는 순위 함수: ROW_NUMBER, RANK, DENSE_RANK, NTILE, ...
-- 순위 함수는 1) 전체 데이터에 순위를 부여할 수 있음
-- 2) PARTITION 옵션을 함께 사용해 사용자가 설정한 그룹에 따라 그룹 내에서만 순위를 부여할 수도 있음.

-- 유일한 값으로 순위를 부여하는 함수 - ROW_NUMBER
-- ROW_NUMBER: 모든 행에 유일한 값으로 순위를 부여하는 함수
-- 함수를 실행한 결과에 같은 순위는 없음. 만약 같은 순위라면 정렬 순서에 따라 순위를 다르게 부여하여 반환함.

-- ROW_NUMBER 함수의 기본 형식
-- ROW_NUMBER() OVER([PARTITION BY 열] ORDER BY 열)

USE sakila; -- sakila DataBase 사용

-- ROW_NUMBER 함수로 순위 부여
SELECT ROW_NUMBER() OVER(ORDER BY amount DESC) AS num, customer_id, amount
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x;
-- 실행 결과: amount 값이 클수록 순위가 높음.
-- num = 4, 5위를 보면 amount값이 같음에도 순위가 다른데
-- 여기선 customer_id의 숫자가 작을수록 더 높은 우선순위를 부여받는 걸 알 수 있음.

-- 만약 동점에 대해 순위를 MySQL이 임의로 부여하지 않게 하기위해 ORDER BY 절에 정렬 조건 추가하기
SELECT ROW_NUMBER() OVER(ORDER BY amount DESC, customer_id DESC) AS num,
	customer_id, amount
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x;

-- 전체 데이터가 아닌 그룹별로 순위를 부여해야 할 때가 있는데, 
-- 예를 들면 1) 전교생을 대상으로 석차를 구할 때, 2) 학년별 석차를 구할 때를
-- 생각하면 된다. 그룹별 순위를 부여하려면 PARTITION 절을 사용해야 한다.

-- PARTITION BY 절로 그룹별 순위 부여
SELECT staff_id, 
	ROW_NUMBER() OVER(PARTITION BY staff_id ORDER BY amount DESC, customer_id ASC) AS num, 
    customer_id,
    amount
FROM (
	SELECT customer_id, staff_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id, staff_id
) AS x;

-- 우선순위를 고려하지 않고 순위를 부여하는 함수 - RANK
-- RANK 함수: 우선순위를 따지지 않고 같은 순위를 부여한다는 점이 ROW_NUMBER 함수와는 다른 점.

-- RANK 함수의 기본 형식
-- RANK() OVER([PARTITION BY 열] ORDER BY 열)
-- 1) OVER(ORDER BY 열)을 명시해 해당 열을 기준으로 오름차순이나 내림차순으로 해당 열 데이터의 순위를 부여하고
-- 2) 데이터 그룹별 순위를 부여하고 싶다면 PARTITION BY 열 옵션을 사용함.

-- payment 테이블에서 amount 열을 내림차순 정렬하여 RANK 함수로 순위 부여하기
SELECT RANK() OVER(ORDER BY amount DESC) AS num, customer_id, amount
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x;
-- num = 4, 5의 경우 amount 값이 같은 경우로, 같은 순위를 부여했다.
-- 공동 순위가 있으면 그 다음 순위는 같은 순위에 있는 데이터 개수만큼 건너뛴 순위가 부여되므로
-- 여기서 4위 다음 6위가 매겨진 걸 알 수 있음.
-- ex) 1위가 3개면 그 다음 순위는 2가 아닌 4가 되는 식임.

-- 건너뛰지 않고 순위를 부여하는 함수 - DENSE_RANK
-- DENSE_RANK: RANK 함수와 달리 같은 순위에 있는 데이터 개수를 무시하고 순위를 매김.
-- ex) 1위가 3개여도 그 다음 순위가 2가 되는 식.

-- DENSE_RANK 함수의 기본 형식
-- DENSE_RANK() OVER([PARTITION BY 열] ORDER BY 열)

-- payment 테이블에서 amount 열을 내림차순 정렬하여 DENSE_RANK 함수로 순위를 부여하기
SELECT DENSE_RANK() OVER(ORDER BY amount DESC) AS num, 
	customer_id, 
    amount
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x;

-- 그룹 순위를 부여하는 함수 - NTILE
-- NTILE: 인자로 지정한 개수만큼 데이터 행을 그룹화한 뒤
-- 각 그룹에 순위를 부여함. 각 그룹은 1부터 순위가 매겨지고, 이 순위는 각 행의 순위가 아닌 '행이 속한 그룹의 순위'임.

-- NTILE 함수의 기본 형식
-- NTILE(정수) OVER([PARTITION BY 열] ORDER BY 열)

-- 내림차순으로 정렬한 결과에 NTILE 함수로 순위 부여
SELECT NTILE(100) OVER(ORDER BY amount DESC) AS num, 
	customer_id, 
	amount
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x;
-- 실행 결과: 전체 행을 100개의 그룹으로 쪼갠 뒤,
-- 각 행마다 속한 그룹의 순위를 부여한 것을 알 수 있음.
-- NTILE 함수는 전체 행을 균등하게 나누어서 
-- 1순위 그룹, 2순위 그룹에 차등으로 혜택을 지급할 때 활용하기 좋은 함수다.

-- 6-6. 분석 함수
-- 분석 함수: 데이터 그룹을 기반으로 앞뒤 행을 계산하거나 그룹에 대한 누적 분포, 상대 순위 등을 계산하는 함수
-- 여러 행을 반환할 수 있음.

-- 앞 또는 뒤 행을 참조하는 함수 - LAG, LEAD
-- 앞뒤 행을 비교해 데이터 처리를 해야 하는 경우 LAG 또는 LEAD 함수를 사용하면 된다.
-- 이 함수들을 사용하면 SELF JOIN을 따로 작성하지 않아도 돼 간편하다.

-- LAG와 LEAD 함수의 기본 형식
-- LAG(또는 LEAD)(열 이름, 참조 위치)
-- OVER([PARTITION BY 열] ORDER BY 열)
-- 인자로 참조 위치를 입력하면 기본값: 1 이므로 아무 것도 전달하지 않으면 1칸 앞이나 1칸 뒤의 데이터를 참조함.

-- payment 테이블에서 기준 열 amount를 가운데로 하여 LAG와 LEAD 함수로 앞뒤 행 참조
SELECT x.payment_date,
	LAG(x.amount) OVER(ORDER BY x.payment_date ASC) AS lag_amount, 
    amount,
    LEAD(x.amount) OVER(ORDER BY x.payment_date ASC) AS lead_amount
FROM (
	SELECT DATE_FORMAT(payment_date, '%y-%m-%d') AS payment_date, 
		SUM(amount) AS amount
	FROM payment
    GROUP BY DATE_FORMAT(payment_date, '%y-%m-%d')
) AS x
ORDER BY x.payment_date;
-- amount 열 기준으로 왼쪽: 현재 행의 앞,
-- 오른쪽: 현재 행의 뒤에 있는 행을 보여줌
-- 첫 행인 29.92의 경우 앞의 값이 없어서 NULL이 출력됨

-- LAG와 LEAD 함수로 2칸씩 앞뒤 행 참조
SELECT x.payment_date,
	LAG(x.amount, 2) OVER(ORDER BY x.payment_date ASC) AS lag_amount, 
    amount,
    LEAD(x.amount, 2) OVER(ORDER BY x.payment_date ASC) AS lead_amount
FROM (
	SELECT DATE_FORMAT(payment_date, '%y-%m-%d') AS payment_date, 
		SUM(amount) AS amount
    FROM payment
    GROUP BY DATE_FORMAT(payment_date, '%y-%m-%d')
) AS x 
ORDER BY x.payment_date;
-- amount 열을 기준으로
-- lag_amount 열에서 반환하는 데이터는 이전 2행의 데이터이고,
-- lead_amount 열에서 반환하는 데이터는 이후 2행의 데이터임을 알 수 있음.

-- 누적 분포(Cumulative Distribution)를 계산하는 함수 - CUME_DIST
-- CUME_DIST: 그룹 내에서 누적 분포를 계산하는 함수
-- 그룹에서 데이터 값이 포함되는 위치의 누적 분포를 계산함.
-- CUME_DIST 함수의 기본 형식
-- CUME_DIST() OVER([PARTITION BY 열] ORDER BY 열)

-- CUME_DIST 함수: 0 초과 ~ 1 이하의 값을 반환함.
-- 같은 값은 항상 같은 누적 분포값으로 계산하며, 기본적으로 NULL값을 포함하며
-- NULL값은 해당 데이터 집합에서 가장 낮은 값으로 취급함

-- CUME_DIST 함수로 payment 테이블의 amount 열의 누적 분포값 계산하기
SELECT x.customer_id, x.amount, CUME_DIST() OVER(ORDER BY x.amount DESC) 
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x 
ORDER BY x.amount DESC;
-- 실행 결과 amount 열의 데이터를 내림차순으로 정렬한 뒤 누적 분포를 계산한 것.
-- amount 열에서 가장 높은 customer_id = 526의 amount 합계 값이 전체 데이터 중 상위 0.0016 
-- 즉, 상위 0.16%의 누적 분포 값을 갖고 있음.
-- ... 마지막 행 customer_id = 248은 누적 분포 1을 반환함.

-- 상대 순위를 계산하는 함수 - PERCENT_RANK
-- PERCENT_RANK: 지정한 그룹 또는 쿼리 결과로 이루어진 그룹 내의 상대 순위를 계산할 수 있는 함수
-- CUME_DIST 함수와 비슷하지만 누적 분포가 아닌 '분포 순위'임.

-- PERCENT_RANK 함수의 기본 형식
-- PERCENT_RANK() OVER([PARTITION BY 열] ORDER BY 열)
-- 함수의 반환값 범위: 0 이상 ~ 1 이하 (데이터 집합에서 1번째 행은 0부터 시작, 마지막 값은 1)
-- PERCENT_RANK 함수에서 NULL은 해당 데이터 그룹에서 가장 낮은 값으로 취급되며, 
-- 상위 분포 순위를 계산할 때 하나의 데이터로 간주됨

-- PERCENT_RANK 함수로 상위 분포 순위를 계산
SELECT x.customer_id, x.amount, PERCENT_RANK() OVER(ORDER BY x.amount DESC)
FROM (
	SELECT customer_id, SUM(amount) AS amount
    FROM payment
    GROUP BY customer_id
) AS x
ORDER BY x.amount DESC;
-- 실행 결과 amount 열의 데이터를 내림차순하여 높은 값이 상위 몇 퍼센트인지 계산하여 보여줌.
-- 맨 첫 번째 데이터는 무조건 0이 반환되며
-- 이후 내림차순한 데이터에 따라 상위 분포를 나타냄.
-- 맨 마지막 행은 1을 반환

-- 그룹의 정렬된 데이터에서 첫번째 행 또는 마지막 행을 반환하는 함수 - FIRST_VALUE, LAST_VALUE
-- FIRST_VALUE와 LAST_VALUE 함수는 그룹에서 첫 행이나 마지막 행의 값을 구해 데이터를 비교할 경우 많이 사용함.
-- ex) 첫 행에 있는 날짜와 매출을 기준으로 지금까지의 매출 변화를 확인하는 경우에 사용 가능

-- FIRST_VALUE와 LAST_VALUE의 기본 형식
-- FIRST VALUE(열) OVER([PARTITION BY 열] ORDER BY 열)
-- LAST_VALUE(열) OVER([PARTITION BY 열] ORDER BY 열)

-- payment 테이블에서 각 일자별로 amount 합계를 구한 뒤
-- payment_id 열을 기준으로 오름차순 정렬하여 
-- FIRST_VALUE 함수로 가장 낮은 일자에 대한 amount 값을 구하고, 
-- LAST_VALUE 함수로 가장 높은 일자에 대한 amount 값 구하기
-- 그리고 FIRST_VALUE 값과 현재 값의 차이가 얼마인지 조회하기
SELECT x.payment_date, x.amount, 
	FIRST_VALUE(x.amount) OVER(ORDER BY x.payment_date) AS f_value, 
    LAST_VALUE(x.amount) OVER(ORDER BY x.payment_date 
		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS l_value, 
	x.amount - FIRST_VALUE(x.amount) OVER(ORDER BY x.payment_date) AS increase_amount
FROM (
	SELECT DATE_FORMAT(payment_date, '%y-%m-%d') AS payment_date, 
		SUM(amount) AS amount
	FROM payment 
    GROUP BY DATE_FORMAT(payment_date, '%y-%m-%d')
) AS x
ORDER BY x.payment_date;
-- 실행 결과: 날짜를 나타내는 payment_date 열을 기준으로 오름차순해서
-- 첫 행의 amount 값(29.92)을 찾은 뒤, 각 일자별 amount 값의 차이를 보여줌
-- 특정 행 기준으로 데이터를 비교하고 싶을 때 이런 쿼리를 사용함.

-- LAST_VALUE 함수 쪽에 윈도우 함수 'RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING'을 사용한 이유는?
-- 윈도우 함수를 사용하지 않으면 LAST_VALUE 함수로 정확한 결과를 얻을 수 없기 때문임.


-- FINAL QUIZ
-- Q1. world 데이터베이스의 country 테이블에서 Name, Continent, Population 열을
-- 하나의 열로 만들기 위해 문자열을 연결하고 각 문자열 사이를 구분할 수 있도록 빈칸을 추가해
-- 그 결과를 조회하는 쿼리를 작성하세요.
USE world;
SELECT CONCAT(Name, ' ', Continent, ' ', Population)
FROM country;

-- Q2. world 데이터베이스의 country 테이블에서 IndepYear 열이 NULL인 데이터를 조회하고
-- 이러한 NULL을 '데이터 없음'으로 표시하는 쿼리를 작성하세요.
SELECT name, IFNULL(IndepYear, '데이터 없음') AS IndepYear
FROM country
WHERE IndepYear IS NULL;

-- Q3. world 데이터베이스의 country 테이블에서 Name 열을 모두 대문자로 조회하거나
-- 모두 소문자로 조회하도록 쿼리를 작성하세요.
SELECT UPPER(name), LOWER(name)
FROM country;

-- Q4. world 데이터베이스의 country 테이블에서 Name 열의 왼쪽, 오른쪽, 양쪽 공백을 제거하고
-- 데이터를 조회하는 쿼리를 작성하세요.
SELECT LTRIM(name), RTRIM(name), TRIM(name)
FROM country;

-- Q5. world 데이터베이스의 country 테이블에서 Name 열의 길이가 20보다 큰 데이터를
-- 열 길이가 높은 순서로 내림차순으로 정렬하는 쿼리를 작성하세요.
SELECT 
	name, LENGTH(name)
FROM country
WHERE LENGTH(name) > 20
ORDER BY LENGTH(name) DESC;

-- Q6. world 데이터베이스의 country 테이블에서 SurfaceArea 열의 소수점 자리까지만
-- 조회하는 쿼리를 작성하세요.
SELECT name, SurfaceArea, POSITION('.' IN SurfaceArea)
FROM country;
