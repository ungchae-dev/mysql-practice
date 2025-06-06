-- 쿼리 실행 단축키? Ctrl + Enter
-- 데이터베이스에선 항상 대소문자를 잘 구분해서 참조할 것.
-- Workbench를 껐다 켜도, 다시 쿼리 실행 시 자동으로 데이터베이스를 지정
USE doitsql;

CREATE DATABASE DoItSQL;
DROP DATABASE DoItSQL;
-- 실무에서는 여러 프로그램들이 데이터베이스에 접속해 사용하는 경우가 많아서
-- 데이터베이스를 삭제하는 일은 드물다.

CREATE DATABASE doitsql;

-- 테이블 생성
CREATE TABLE doit_create_table (
	col_1 INT, 
    col_2 VARCHAR(50), 
    col_3 DATETIME
);

-- 테이블 삭제
DROP TABLE doit_create_table;

-- 테이블 생성_2
CREATE TABLE doit_dml (
	col_1 INT, 
    col_2 VARCHAR(50), 
    col_3 DATETIME
);

-- 데이터 삽입
INSERT INTO doit_dml (col_1, col_2, col_3) 
VALUES (1, 'DoItSQL', '2025-05-05');

-- 열 이름 생략하고 데이터 삽입
INSERT INTO doit_dml 
VALUES (2, '열 이름 생략', '2025-05-06');

-- 삽입한 데이터 조회
SELECT * FROM doit_dml;

-- 특정 열에만 데이터 삽입 & 데이터 조회
INSERT INTO doit_dml (col_1, col_2) 
VALUES (3, 'col_3 값 생략');
SELECT * FROM doit_dml;
-- col_3에는 NULL이 담긴다.

-- 삽입할 데이터의 순서 변경
INSERT INTO doit_dml (col_1, col_3, col_2) 
VALUES (4, '2025-05-07', '열 순서 변경');
SELECT * FROM doit_dml;

-- 여러 데이터 한 번에 삽입
INSERT INTO doit_dml (col_1, col_2, col_3) 
VALUES (5, '데이터 입력5', '2025-05-08'), 
(6, '데이터 입력6', '2025-05-08'), 
(7, '데이터 입력7', '2025-05-08');
SELECT * FROM doit_dml;

-- 데이터 수정
UPDATE doit_dml SET col_2 = '데이터 수정' 
WHERE col_1 = 4;
-- 안전모드를 비활성화 한 후 workbench 종료한 뒤 실행하여 
-- 다시 UPDATE 쿼리문 실행하기.
SELECT * FROM doit_dml;

-- 안전 모드 활성화
set SQL_SAFE_UPDATES=1;
-- 안전 모드 비활성화
set SQL_SAFE_UPDATES=0;

-- UPDATE문으로 테이블 전체 데이터 수정
UPDATE doit_dml SET col_1 = col_1 + 10;
SELECT * FROM doit_dml;

-- ※ DELETE문은 FROM이 반드시 필요하고, 
-- WHERE절의 조건이 누락되면 전체 데이터를 삭제하므로 주의할 것!
-- DELETE문으로 데이터 삭제
DELETE FROM doit_dml WHERE col_1 = 14;
SELECT * FROM doit_dml;

-- 테이블 전체 데이터 삭제
DELETE FROM doit_dml;
SELECT * FROM doit_dml;

# 한 줄 주석
-- 한 줄 주석
/*
여러줄
주석
*/

-- /*! 실행 가능한 주석 코드 작성 */
SELECT 1/*!+1 */