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