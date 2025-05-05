-- 쿼리 실행 단축키? Ctrl + Enter
-- 데이터베이스에선 항상 대소문자를 잘 구분해서 참조할 것.
CREATE DATABASE DoItSQL;
DROP DATABASE DoItSQL;
-- 실무에서는 여러 프로그램들이 데이터베이스에 접속해 사용하는 경우가 많아서
-- 데이터베이스를 삭제하는 일은 드물다.

CREATE DATABASE doitsql;
USE doitsql;

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