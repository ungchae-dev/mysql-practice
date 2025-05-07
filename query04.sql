-- 인코딩
SET NAMES utf8mb4;

-- query03.sql에서 생성한 doitsql DB 사용
-- 데이터베이스 선택
USE doitsql;

-- 1번째 열에 AUTO_INCREMENT 적용
CREATE TABLE doit_increment (
	col_1 INT AUTO_INCREMENT PRIMARY KEY, 
    col_2 VARCHAR(50), 
    col_3 INT
);

INSERT INTO doit_increment (col_2, col_3) VALUES ('1 자동 입력', 1);
INSERT INTO doit_increment (col_2, col_3) VALUES ('2 자동 입력', 2);

SELECT * FROM doit_increment;