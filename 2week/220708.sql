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

SELECT `구`, COUNT(*) AS cnt, GROUP_CONCAT(DISTINCT `거치대_종류`), COUNT(DISTINCT `거치대_종류`)
FROM `tashu_stati on_info`
GROUP BY `구` ;


## HAVING - GROUP BY 결과에 조건을 주어 자료를 선택 (필터)
SELECT `대여스테이션`, COUNT(*) AS COUNT, AVG(`이동거리`) AS `이동거리_avg`
FROM `tashu_using_status`
GROUP BY `대여스테이션`
HAVING COUNT > 5000 ;



### 조인 (JOIN)
# - 두 개 이상의 테이블의 자료를 결합
# - 각 테이블 열의 공통된 값을 사용하여 두 테이블의 열을 결합
