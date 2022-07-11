##### 05) 자료 선택

## 테이블 전체 자료 선택
SELECT *
FROM `tashu_station_info` ;


## 특정 열 선택
SELECT `번호`, `대여소명`, `거치대_수`, `구`, `위도`, `경도`
FROM `tashu_station_info` ;


## 새로운 열 만들기 - 함수 또는 연산자 사용
SELECT `대여스테이션`, `대여일시`, SUBSTR(`대여일시`, 5, 2), `이동거리`, `이동거리`/1000
FROM `tashu_using_status` ;


## 열 이름에 가명(alias) 주기
SELECT `대여스테이션`, `대여일시`, SUBSTR(5, 2) AS `월`, `이동거리`, `이동거리`/1000 AS `이동거리_km`
FROM `tashu_using_status` ;


## 조건을 만족하는 자료(행) 선택
SELECT *
FROM `tashu_using_status`
WHERE `이동거리` > 1000 ;

SELECT *
FROM `tashu_using_status`
WHERE `이동거리` > 1000 AND `대여스테이션` ;

SELECT *
FROM `tashu_using_status`
WHERE `이동거리` > 1000 AND (`대여스테이션` = 8 OR `대여스테이션` = 3) ;


## 패턴을 이용한 자료 선택
# - 대여소명의 값이 "대전'을 포함하는 자료
SELECT *
FROM `tashu_station_info`
WHERE `대여소명` LIKE "%대전%" ;

# - 대여소명의 값이 "대전"으로 시작하는 자료
SELECT *
FROM `tashu_station_info`
WHERE `대여소명` LIKE "대전%" ;


## 중복된 행을 제거하여 선택
SELECT DISTINCT `구`
FROM `tashu_station_info` ;


## 자료를 정렬하여 선택
SELECT *
FROM `tashu_station_info`
ORDER BY `거치대_수` DESC ;

# 2차 정렬
SELECT *
FROM `tashu_station_info`
ORDER BY `거치대_수` DESC, `번호` ;


## 자료의 원하는 위치에서 일정한 개수만큼 선택
SELECT *
FROM `tashu_station_info`
LIMIT 0, 5 ;

SELECT *
FROM `tashu_station_info`
LIMIT 3, 5 ;



### 그룹별 집계 - 지정한 열의 값을 동일한 수준으로 그룹화하여 결과를 도출
SELECT `대여스테이션`, COUNT(*) AS COUNT, AVG(`이동거리`) AS `이동거리_AVG`, STD(`이동거리`) AS `이동거리_STD`,
	MIN(`이동거리`) AS `이동거리_MIN`, MAX(`이동거리`) AS `이동거리_MAX`
FROM `tashu_using_status`
GROUP BY `대여스테이션` ;


## GROUP CONCAT
SELECT `구`, SUM(`거치대_수`) AS `구_거치대_수`, GROUP_CONCAT(`대여소명`)
FROM `tashu_station_info`
GROUP BY `구` ;

SELECT `구`, COUNT(*) AS CNT, GROUP_CONCAT(`대여소명`) AS `대여소명`
FROM `tashu_station_info`
GROUP BY `구`
ORDER BY CNT DESC ;

SELECT `구`, COUNT(*) AS CNT, GROUP_CONCAT(DISTINCT `거치대_종류`), COUNT(DISTINCT `거치대_종류`),
	SUM(`거치대_종류` = '기둥'), SUM(IF(`거치대_종류` = '기둥', 1, 0))
FROM `tashu_station_info`
GROUP BY `구` ;


## HAVING - GROUP BY 결과에 조건을 주어 자료를 선택 (필터)
SELECT `구`, COUNT(*) AS CNT, GROUP_CONCAT(DISTINCT `거치대_종류`) AS `거치대_종류_concat`,
	COUNT(DISTINCT `거치대_종류`) AS `거치대_종류_cnt`
FROM `tashu_station_info`
GROUP BY `구`
HAVING CNT > 50 ;

SELECT `구`, COUNT(*) AS CNT, GROUP_CONCAT(DISTINCT `거치대_종류`) AS `거치대_종류_concat`,
	COUNT(DISTINCT `거치대_종류`) AS `거치대_종류_cnt`
FROM `tashu_station_info`
GROUP BY `구`
HAVING `구` = '동구' ;



### 조인 (JOIN)
# - 두 개 이상의 테이블의 자료를 결합
# - 각 테이블 열의 공통된 값을 사용하여 두 테이블의 열을 결합

## CROSS JOIN
# 모든 행 JOIN
SELECT *
FROM `employee` JOIN `department` ;


## EQUI JOIN
# 조건을 만족하는 자료 JOIN
SELECT *
FROM `employee` JOIN `department`
ON`employee`.`DepartmentID` = `department`.`DepartmentID` ;

SELECT *
FROM `employee` JOIN `department`
WHERE `employee`.`DepartmentID` = `department`.`DepartmentID` ;


## LEFT (OUTER) JOIN
# 왼쪽이 기준
SELECT *
FROM `employee` LEFT JOIN `department`
ON `employee`.`DepartmentID` = `department`.`DepartmentID` ;


## RIGHT JOIN
# 사용 X
SELECT *
FROM `employee` RIGHT JOIN `department`
ON `employee`.`DepartmentID` = `department`.`DepartmentID` ;


## 테이블에 가칭 붙이기 (결과 동일)
SELECT *
FROM `employee` AS e JOIN `department` AS d
ON e.`DepartmentID` = d.`DepartmentID` ;

SELECT `LastName`, d.`DepartmentID`, `DepartmentName`
FROM `employee` AS e JOIN `department` AS d
ON e.`DepartmentID` = d.`DepartmentID` ;

SELECT `LastName`, `DepartmentID`, `DepartmentName`
FROM `employee` AS e JOIN `department` AS d
USING (`DepartmentID`) ;


### 연습문제 -  타슈 무인대여소 현황 & 2019년 이용 현황
SELECT u.*, i.`대여소명` AS `대여스테이션_이름`
FROM `tashu_using_status` u JOIN `tashu_station_info` i
ON u.`대여스테이션` = i.`번호` ;

SELECT u.*, i.`대여소명` AS `대여스테이션_이름`, n.`대여소명` AS `반납스테이션_이름`
FROM `tashu_using_status` u JOIN `tashu_station_info` i
	ON u.`대여스테이션` = i.`번호`
LEFT JOIN `tashu_station_info` n
	ON u.`반납스테이션` = n.`번호` ;
	
SELECT COUNT(*)
FROM `tashu_using_status` ;

# CASE WHEN THEN~ END (IF 구문과 비슷)
SELECT *, CASE WHEN `회원구분` = '0' THEN '정회원'
	       WHEN `회원구분` = '1' THEN '일반회원'
	       WHEN `회원구분` = '2' THEN '비회원'
	       ELSE NULL
	  END AS 회원구분2
FROM `tashu_using_status` ;





##### 6) 자료 수정과 삭제

### 테이블 복사
CREATE TABLE `tashu_using_status_use` LIKE `tashu_using_status` ;
INSERT INTO `tashu_using_status_use`
SELECT *
FROM `tashu_using_status` ;

SELECT *
FROM `tashu_using_status_use` ;


### 자료 수정
SELECT *
FROM `tashu_using_status`
WHERE `반납스테이션` = 0 ;

UPDATE `tashu_using_status` SET `반납스테이션` = NULL
WHERE `반납스테이션` = 0 ;

# NULL 값 검색
SELECT *
FROM `tashu_using_status`
WHERE `반납스테이션` <=> NULL ;

SELECT *
FROM `tashu_using_status`
WHERE `반납스테이션` IS NULL ;


## 자료 삭제
SELECT *
FROM `tashu_using_status`
WHERE `반납스테이션` IS NULL ;

DELETE FROM `tashu_using_status` WHERE `반납스테이션` IS NULL ;





##### 7) 서브쿼리





##### 8) 뷰
CREATE OR REPLACE VIEW `v_대여반납_이름` AS
SELECT u.*, i.`대여소명` AS `대여스테이션_이름`, n.`대여소명` AS `반납스테이션_이름`
FROM `tashu_using_status` u 
JOIN `tashu_station_info` i
	ON u.`대여스테이션` = i.`번호`
LEFT JOIN `tashu_station_info` n
	ON u.`반납스테이션` = n.`번호`;

SELECT *
FROM `v_대여반납_이름` ;

DROP VIEW `v_대여반납_이름` ;



SELECT COUNT(*)
FROM `busRouteInfo` ;

DROP TABLE IF EXISTS `busRouteInfo_use2` ;
CREATE TABLE `busRouteInfo_use2` LIKE `busRouteInfo_use` ;

TRUNCATE `busRouteInfo_use2` ;

INSERT `busRouteInfo_use2`
SELECT *
FROM `busRouteInfo` ;