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
