-- 주소 테이블 생성
CREATE TABLE DT_ADDRESS (
    ADDRESS_NUMBER NUMBER ,
    ADDRESS_POSTAL VARCHAR2(10) NOT NULL,
    ADDRESS_ADDRESS VARCHAR2(200) NOT NULL,
    ADDRESS_DETAIL VARCHAR2(200) NOT NULL,
    CONSTRAINT PK_ADDRESS PRIMARY KEY (ADDRESS_NUMBER)
);

-- 회원 정보 테이블 생성
CREATE TABLE DT_MEMBER (
    MEMBER_NUMBER NUMBER,
    MEMBER_ID VARCHAR2(200) UNIQUE NOT NULL,
    MEMBER_PW VARCHAR2(200) NOT NULL,
    MEMBER_NAME VARCHAR2(200) NOT NULL,
    MEMBER_BIRTH DATE NOT NULL,
    MEMBER_PHONE VARCHAR2(200) UNIQUE NOT NULL,
    ADDRESS_NUMBER NUMBER,
    CONSTRAINT PK_MEMBER PRIMARY KEY (MEMBER_NUMBER),
    CONSTRAINT FK_MEMBER_ADDRESS FOREIGN KEY (ADDRESS_NUMBER) REFERENCES DT_ADDRESS(ADDRESS_NUMBER)
);


INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, MEMBER_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 1, '일반');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, MEMBER_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 2, '일반');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, MEMBER_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 3, '일반');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, MEMBER_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 4, '일반');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, MEMBER_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 5, '일반');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, DOCTOR_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 1, '의사');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, DOCTOR_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 2, '의사');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, DOCTOR_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 3, '의사');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, DOCTOR_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 4, '의사');
INSERT INTO DT_USER_TYPE (USER_TYPE_NUMBER, DOCTOR_NUMBER, USER_TYPE_TYPE) VALUES
(USER_TYPE_SEQ.NEXTVAL, 5, '의사');






-- 병원 정보 테이블 생성
CREATE TABLE DT_HOSPITAL (
    HOSPITAL_NUMBER NUMBER,
    HOSPITAL_CALL VARCHAR2(200) NOT NULL,
    HOSPITAL_NAME VARCHAR2(200) NOT NULL,
    HOSPITAL_WORK_TIME DATE NOT NULL,
    HOSPITAL_LUNCH_TIME DATE NOT NULL,
    HOSPITAL_REST_TIME VARCHAR2(200) DEFAULT '주말,공휴일' NOT NULL,
    HOSPITAL_NIGHT_WORK VARCHAR2(200) DEFAULT '없음' NOT NULL,
    ADDRESS_NUMBER NUMBER,
    CONSTRAINT PK_HOSPITAL PRIMARY KEY (HOSPITAL_NUMBER),
    CONSTRAINT FK_HOSPITAL_ADDRESS FOREIGN KEY (ADDRESS_NUMBER) REFERENCES DT_ADDRESS(ADDRESS_NUMBER)
);

ALTER TABLE DT_HOSPITAL DROP COLUMN hospital_call;
ALTER TABLE DT_HOSPITAL DROP COLUMN hospital_rest_time;
ALTER TABLE DT_HOSPITAL DROP COLUMN hospital_night_work;
SELECT*FROM DT_HOSPITAL dh ;

-- 의사 정보 테이블 생성
CREATE TABLE DT_DOCTOR (
    DOCTOR_NUMBER NUMBER,
    DOCTOR_ID VARCHAR2(200) UNIQUE NOT NULL,
    DOCTOR_PW VARCHAR2(200) NOT NULL,
    DOCTOR_NAME VARCHAR2(200) NOT NULL,
    DOCTOR_PHONE VARCHAR2(200) UNIQUE NOT NULL,
    DOCTOR_LICENSE VARCHAR2(200) UNIQUE NOT NULL,
    DOCTOR_MAJOR VARCHAR2(200) NOT NULL,
    HOSPITAL_NUMBER NUMBER,
    CONSTRAINT PK_DOCTOR PRIMARY KEY (DOCTOR_NUMBER),
    CONSTRAINT FK_DOCTOR_HOSPITAL FOREIGN KEY (HOSPITAL_NUMBER) REFERENCES DT_HOSPITAL(HOSPITAL_NUMBER)
);

-- 의료 지식인 글 정보 테이블 생성
CREATE TABLE DT_MEDICAL_INFO (
    MEDICAL_INFO_NUMBER NUMBER,
    MEDICAL_INFO_TITLE VARCHAR2(200) NOT NULL,
    MEDICAL_INFO_TEXT VARCHAR2(1000) NOT NULL,
    MEDICAL_INFO_DATE DATE NOT NULL,
    MEMBER_NUMBER NUMBER,
    CONSTRAINT PK_MEDICAL_INFO PRIMARY KEY (MEDICAL_INFO_NUMBER),
    CONSTRAINT FK_MEDICAL_INFO_MEMBER FOREIGN KEY (MEMBER_NUMBER) REFERENCES DT_MEMBER(MEMBER_NUMBER)
);

SELECT * FROM DT_MEDICAL_INFO;

-- 의사 의료지식인 댓글 테이블 생성
CREATE TABLE DT_DOCTOR_COMMENT (
    DOCTOR_COMMENT_NUMBER NUMBER,
    DOCTOR_COMMENT_TEXT VARCHAR2(200) NOT NULL,
    MEDICAL_INFO_NUMBER NUMBER UNIQUE,
    DOCTOR_NUMBER NUMBER,
    CONSTRAINT PK_DOCTOR_COMMENT PRIMARY KEY (DOCTOR_COMMENT_NUMBER),
    CONSTRAINT FK_DOCTOR_COMMENT_MEDICAL_INFO FOREIGN KEY (MEDICAL_INFO_NUMBER) REFERENCES DT_MEDICAL_INFO(MEDICAL_INFO_NUMBER),
    CONSTRAINT FK_DOCTOR_COMMENT_DOCTOR FOREIGN KEY (DOCTOR_NUMBER) REFERENCES DT_DOCTOR(DOCTOR_NUMBER)
);

SELECT*FROM DT_MEMBER;

-- 세션 관리 테이블 생성
CREATE TABLE DT_CHAT_SESSION (
    SESSION_NUMBER NUMBER,
    SESSION_STATUS VARCHAR2(200) NOT NULL CHECK (SESSION_STATUS IN ('진료중', '진료대기', '진료종료')),
    MEMBER_NUMBER NUMBER NOT NULL,
    DOCTOR_NUMBER NUMBER NOT NULL,
    CONSTRAINT PK_CHAT_SESSION PRIMARY KEY (SESSION_NUMBER),
    CONSTRAINT FK_CHAT_SESSION_MEMBER FOREIGN KEY (MEMBER_NUMBER) REFERENCES DT_MEMBER(MEMBER_NUMBER),
    CONSTRAINT FK_CHAT_SESSION_DOCTOR FOREIGN KEY (DOCTOR_NUMBER) REFERENCES DT_DOCTOR(DOCTOR_NUMBER)
);

-- 채팅 테이블 생성
CREATE TABLE DT_CHAT (
    CHAT_NUMBER NUMBER,
    CHAT_ROOM_NUMBER NUMBER NOT NULL,
    CHAT_TEXT VARCHAR2(200) NOT NULL,
    CHAT_MSG_DATE DATE NOT NULL,
    SESSION_NUMBER NUMBER,
    CONSTRAINT PK_CHAT PRIMARY KEY (CHAT_NUMBER),
    CONSTRAINT FK_CHAT_SESSION FOREIGN KEY (SESSION_NUMBER) REFERENCES DT_CHAT_SESSION(SESSION_NUMBER)
);

-- 처방전 테이블 생성
CREATE TABLE DT_CHART (
    CHART_NUMBER NUMBER,
    CHART_NAME VARCHAR2(200) NOT NULL,
    CHART_MEDICINE VARCHAR2(200) NOT NULL,
    CHART_DAY VARCHAR2(200) NOT NULL, -- 1일 몇회
    CHART_TIME VARCHAR2(200) NOT NULL CHECK (CHART_TIME IN ('식전', '식후')), -- 식전 또는 식후
    CHART_PERIOD VARCHAR2(200) NOT NULL, -- 몇일치
      MEMBER_NUMBER NUMBER,
    DOCTOR_NUMBER NUMBER,
    CONSTRAINT PK_CHART PRIMARY KEY (CHART_NUMBER),
    CONSTRAINT fk_member FOREIGN KEY (MEMBER_NUMBER) REFERENCES DT_MEMBER(MEMBER_NUMBER),
    CONSTRAINT fk_doctor FOREIGN KEY (DOCTOR_NUMBER) REFERENCES DT_DOCTOR(DOCTOR_NUMBER)
);

DROP TABLE DT_ADDRESS CASCADE CONSTRAINT;
DROP SEQUENCE ADDRESS_SEQ;
DROP TABLE DT_MEMBER CASCADE CONSTRAINT;
DROP SEQUENCE MEMBER_SEQ;
DROP TABLE DT_DOCTOR ;
DROP TABLE DT_HOSPITAL CASCADE CONSTRAINT;
DROP SEQUENCE HOSPITAL_SEQ;
DROP TABLE DT_MEDICAL_INFO CASCADE CONSTRAINT;
DROP SEQUENCE MEDICAL_INFO_SEQ;
DROP TABLE DT_DOCTOR_COMMENT CASCADE CONSTRAINT;
DROP SEQUENCE DOCTOR_COMMENT_SEQ;
DROP TABLE DT_CHAT_SESSION CASCADE CONSTRAINT;
DROP SEQUENCE CHAT_SESSION_SEQ;
DROP TABLE DT_CHAT CASCADE CONSTRAINT;
DROP SEQUENCE CHAT_SEQ;
DROP SEQUENCE CHAT_ROOM_SEQ;
DROP TABLE DT_CHART CASCADE CONSTRAINT;
DROP SEQUENCE CHART_SEQ;

-- 주소 테이블 데이터 조회
SELECT * FROM DT_ADDRESS;

-- 회원 정보 테이블 데이터 조회
SELECT * FROM DT_MEMBER;

-- 병원 정보 테이블 데이터 조회
SELECT * FROM DT_HOSPITAL;

-- 의사 정보 테이블 데이터 조회
SELECT * FROM DT_DOCTOR;

-- 의료 지식인 글 정보 테이블 데이터 조회
SELECT * FROM DT_MEDICAL_INFO;


-- 의사 의료지식인 댓글 테이블 데이터 조회
SELECT * FROM DT_DOCTOR_COMMENT;

-- 세션 관리 테이블 데이터 조회
SELECT * FROM DT_CHAT_SESSION;

-- 채팅 테이블 데이터 조회
SELECT * FROM DT_CHAT;

-- 처방전 테이블 데이터 조회
SELECT * FROM DT_CHART;

-- DT_ADDRESS 테이블 시퀀스 생성
CREATE SEQUENCE ADDRESS_SEQ;

-- DT_MEMBER 테이블 시퀀스 생성
CREATE SEQUENCE MEMBER_SEQ;

-- DT_HOSPITAL 테이블 시퀀스 생성
CREATE SEQUENCE HOSPITAL_SEQ;

DROP SEQUENCE hospital_seq;

-- DT_DOCTOR 테이블 시퀀스 생성
CREATE SEQUENCE DOCTOR_SEQ;

DROP SEQUENCE doctor_Seq;

-- DT_MEDICAL_INFO 테이블 시퀀스 생성
CREATE SEQUENCE MEDICAL_INFO_SEQ;

-- DT_DOCTOR_COMMENT 테이블 시퀀스 생성
CREATE SEQUENCE DOCTOR_COMMENT_SEQ;

-- DT_CHAT_SESSION 테이블 시퀀스 생성
CREATE SEQUENCE CHAT_SESSION_SEQ;

-- DT_CHAT 테이블 시퀀스 생성
CREATE SEQUENCE CHAT_SEQ;

-- DT_CHART 테이블 시퀀스 생성
CREATE SEQUENCE CHART_SEQ;

-- DT_CHAT 테이블에 ROOM 시퀀스 생성
CREATE SEQUENCE CHAT_ROOM_SEQ;


----1) address 테이블
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '12345', '서울특별시 강남구 테헤란로 123', '1층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '23456', '부산광역시 해운대구 우동 456', '2층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '34567', '대구광역시 수성구 범어동 789', '3층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '45678', '인천광역시 남동구 구월동 101', '4층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '56789', '광주광역시 동구 동명동 202', '5층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '67890', '대전광역시 서구 둔산동 303', '6층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '78901', '울산광역시 남구 삼산동 404', '7층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '89012', '세종특별자치시 보람동 505', '8층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '90123', '경기도 성남시 분당구 정자동 606', '9층');
INSERT INTO DT_ADDRESS (ADDRESS_NUMBER, ADDRESS_POSTAL, ADDRESS_ADDRESS, ADDRESS_DETAIL) VALUES (ADDRESS_SEQ.NEXTVAL, '01234', '경기도 수원시 장안구 영화동 707', '10층');

SELECT * FROM DT_ADDRESS;

----1) member 테이블
INSERT INTO DT_MEMBER (MEMBER_NUMBER, MEMBER_ID, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH, MEMBER_PHONE, ADDRESS_NUMBER) VALUES (MEMBER_SEQ.NEXTVAL, 'user1', 'password1', '홍길동', TO_DATE('1990-01-01', 'YYYY-MM-DD'), '010-1111-2222', 1);
INSERT INTO DT_MEMBER (MEMBER_NUMBER, MEMBER_ID, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH, MEMBER_PHONE, ADDRESS_NUMBER) VALUES (MEMBER_SEQ.NEXTVAL, 'user2', 'password2', '김영희', TO_DATE('1992-02-02', 'YYYY-MM-DD'), '010-3333-4444', 2);
INSERT INTO DT_MEMBER (MEMBER_NUMBER, MEMBER_ID, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH, MEMBER_PHONE, ADDRESS_NUMBER) VALUES (MEMBER_SEQ.NEXTVAL, 'user3', 'password3', '이철수', TO_DATE('1988-03-03', 'YYYY-MM-DD'), '010-5555-6666', 3);
INSERT INTO DT_MEMBER (MEMBER_NUMBER, MEMBER_ID, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH, MEMBER_PHONE, ADDRESS_NUMBER) VALUES (MEMBER_SEQ.NEXTVAL, 'user4', 'password4', '박지민', TO_DATE('1995-04-04', 'YYYY-MM-DD'), '010-7777-8888', 4);
INSERT INTO DT_MEMBER (MEMBER_NUMBER, MEMBER_ID, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH, MEMBER_PHONE, ADDRESS_NUMBER) VALUES (MEMBER_SEQ.NEXTVAL, 'user5', 'password5', '최민수', TO_DATE('1985-05-05', 'YYYY-MM-DD'), '010-9999-0000', 5);


SELECT * FROM DT_MEMBER;

----3) hospital 테이블
INSERT INTO DT_HOSPITAL (HOSPITAL_NUMBER, HOSPITAL_CALL, HOSPITAL_NAME, HOSPITAL_WORK_TIME, HOSPITAL_LUNCH_TIME, HOSPITAL_REST_TIME, HOSPITAL_NIGHT_WORK, ADDRESS_NUMBER) VALUES (HOSPITAL_SEQ.NEXTVAL, '02-123-4567', '서울병원', TO_DATE('09:00', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI'), '주말,공휴일', '없음', 6);
INSERT INTO DT_HOSPITAL (HOSPITAL_NUMBER, HOSPITAL_CALL, HOSPITAL_NAME, HOSPITAL_WORK_TIME, HOSPITAL_LUNCH_TIME, HOSPITAL_REST_TIME, HOSPITAL_NIGHT_WORK, ADDRESS_NUMBER) VALUES (HOSPITAL_SEQ.NEXTVAL, '051-987-6543', '부산병원', TO_DATE('09:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), '주말,공휴일', '있음', 7);
INSERT INTO DT_HOSPITAL (HOSPITAL_NUMBER, HOSPITAL_CALL, HOSPITAL_NAME, HOSPITAL_WORK_TIME, HOSPITAL_LUNCH_TIME, HOSPITAL_REST_TIME, HOSPITAL_NIGHT_WORK, ADDRESS_NUMBER) VALUES (HOSPITAL_SEQ.NEXTVAL, '053-321-4321', '대구병원', TO_DATE('09:00', 'HH24:MI'), TO_DATE('13:00', 'HH24:MI'), '주말,공휴일', '없음', 8);
INSERT INTO DT_HOSPITAL (HOSPITAL_NUMBER, HOSPITAL_CALL, HOSPITAL_NAME, HOSPITAL_WORK_TIME, HOSPITAL_LUNCH_TIME, HOSPITAL_REST_TIME, HOSPITAL_NIGHT_WORK, ADDRESS_NUMBER) VALUES (HOSPITAL_SEQ.NEXTVAL, '032-456-7890', '인천병원', TO_DATE('09:00', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI'), '주말,공휴일', '있음', 9);
INSERT INTO DT_HOSPITAL (HOSPITAL_NUMBER, HOSPITAL_CALL, HOSPITAL_NAME, HOSPITAL_WORK_TIME, HOSPITAL_LUNCH_TIME, HOSPITAL_REST_TIME, HOSPITAL_NIGHT_WORK, ADDRESS_NUMBER) VALUES (HOSPITAL_SEQ.NEXTVAL, '062-987-1234', '광주병원', TO_DATE('09:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), '주말,공휴일', '없음', 10);

ALTER TABLE DT_HOSPITAL ADD HOSPITAL_CALL VARCHAR2(200);


SELECT * FROM DT_HOSPITAL;

--4) doctor 테이블
INSERT INTO DT_DOCTOR (DOCTOR_NUMBER, DOCTOR_ID, DOCTOR_PW, DOCTOR_NAME, DOCTOR_PHONE, DOCTOR_LICENSE, DOCTOR_MAJOR, HOSPITAL_NUMBER) VALUES (DOCTOR_SEQ.NEXTVAL, 'doc1', 'password1', '이준호', '010-1111-2222', 'License001', '내과', 1);
INSERT INTO DT_DOCTOR (DOCTOR_NUMBER, DOCTOR_ID, DOCTOR_PW, DOCTOR_NAME, DOCTOR_PHONE, DOCTOR_LICENSE, DOCTOR_MAJOR, HOSPITAL_NUMBER) VALUES (DOCTOR_SEQ.NEXTVAL, 'doc2', 'password2', '김하나', '010-3333-4444', 'License002', '이비인후과', 2);
INSERT INTO DT_DOCTOR (DOCTOR_NUMBER, DOCTOR_ID, DOCTOR_PW, DOCTOR_NAME, DOCTOR_PHONE, DOCTOR_LICENSE, DOCTOR_MAJOR, HOSPITAL_NUMBER) VALUES (DOCTOR_SEQ.NEXTVAL, 'doc3', 'password3', '박소연', '010-5555-6666', 'License003', '내과', 3);
INSERT INTO DT_DOCTOR (DOCTOR_NUMBER, DOCTOR_ID, DOCTOR_PW, DOCTOR_NAME, DOCTOR_PHONE, DOCTOR_LICENSE, DOCTOR_MAJOR, HOSPITAL_NUMBER) VALUES (DOCTOR_SEQ.NEXTVAL, 'doc4', 'password4', '최민재', '010-7777-8888', 'License004', '이비인후과', 4);
INSERT INTO DT_DOCTOR (DOCTOR_NUMBER, DOCTOR_ID, DOCTOR_PW, DOCTOR_NAME, DOCTOR_PHONE, DOCTOR_LICENSE, DOCTOR_MAJOR, HOSPITAL_NUMBER) VALUES (DOCTOR_SEQ.NEXTVAL, 'doc5', 'password5', '이수진', '010-9999-0000', 'License005', '내과', 5);

SELECT * FROM DT_DOCTOR ;

--5) medcial_info 테이블
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_SUBJECT, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES
(MEDICAL_INFO_SEQ.NEXTVAL, '심장 건강', '심장 병 예방을 위한 10가지 팁', '심장 건강을 유지하기 위해서는 운동과 건강한 식습관이 중요합니다...', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_SUBJECT, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES
(MEDICAL_INFO_SEQ.NEXTVAL, '영양', '비타민 D의 중요성', '비타민 D는 뼈 건강에 필수적이며, 면역력 강화에도 도움을 줍니다...', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 2);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_SUBJECT, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES
(MEDICAL_INFO_SEQ.NEXTVAL, '정신 건강', '스트레스 관리 방법', '스트레스를 효과적으로 관리하는 방법에는 여러 가지가 있습니다...', TO_DATE('2024-03-05', 'YYYY-MM-DD'), 3);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_SUBJECT, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES
(MEDICAL_INFO_SEQ.NEXTVAL, '운동', '매일 30분 운동하기', '운동은 신체 건강뿐만 아니라 정신 건강에도 이롭습니다...', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 4);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_SUBJECT, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES
(MEDICAL_INFO_SEQ.NEXTVAL, '수면', '숙면을 위한 팁', '좋은 수면 습관은 전반적인 건강에 큰 영향을 미칩니다...', TO_DATE('2024-05-25', 'YYYY-MM-DD'), 5);

INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '고혈압 관리', '고혈압은 심혈관 질환의 주요 원인입니다. 정기적으로 혈압을 측정하고, 건강한 식습관을 유지하세요.', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 1);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '당뇨병 예방', '당뇨병은 조기 발견이 중요합니다. 정기적인 검진으로 혈당 수치를 체크하세요.', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 2);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '정신 건강', '정신 건강을 유지하기 위해 스트레스 관리와 충분한 수면이 필요합니다.', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 3);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '비만 관리', '비만은 여러 질병의 원인이 될 수 있습니다. 균형 잡힌 식사와 운동을 병행하세요.', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 4);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '예방 접종', '정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.', TO_DATE('2023-05-12', 'YYYY-MM-DD'), 5);
INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '예방 접종', '정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.정기적인 예방 접종은 여러 질병으로부터 자신을 보호하는 가장 좋은 방법입니다.', TO_DATE('2023-05-14', 'YYYY-MM-DD'), 2);

INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '심장 건강', '심장 건강을 위해 규칙적인 운동과 균형 잡힌 식사가 필요합니다.', TO_DATE('2023-06-15', 'YYYY-MM-DD'), 5);

INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '콜레스테롤 관리', '콜레스테롤 수치를 정기적으로 확인하고, 건강한 지방을 섭취하세요.', TO_DATE('2023-07-20', 'YYYY-MM-DD'), 4);

INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '에너지 관리', '충분한 수면과 적절한 영양 섭취로 에너지를 관리하세요.', TO_DATE('2023-08-10', 'YYYY-MM-DD'), 3);

INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '알레르기 예방', '알레르기 증상을 줄이기 위해 알레르겐을 피하세요.', TO_DATE('2023-09-05', 'YYYY-MM-DD'), 2);

INSERT INTO DT_MEDICAL_INFO (MEDICAL_INFO_NUMBER, MEDICAL_INFO_TITLE, MEDICAL_INFO_TEXT, MEDICAL_INFO_DATE, MEMBER_NUMBER) VALUES (MEDICAL_INFO_SEQ.NEXTVAL, '건강 검진', '정기적인 건강 검진으로 조기에 질병을 발견할 수 있습니다.', TO_DATE('2023-09-20', 'YYYY-MM-DD'), 1);


SELECT * FROM DT_MEDICAL_INFO;


SELECT * FROM DT_MEDICAL_INFO;

-- 6) doctor_comment

INSERT INTO DT_DOCTOR_COMMENT (DOCTOR_COMMENT_NUMBER, DOCTOR_COMMENT_TEXT, MEDICAL_INFO_NUMBER, DOCTOR_NUMBER) VALUES
(DOCTOR_COMMENT_SEQ.NEXTVAL, '매우 유익한 정보입니다. 감사합니다!', 1, 5);
INSERT INTO DT_DOCTOR_COMMENT (DOCTOR_COMMENT_NUMBER, DOCTOR_COMMENT_TEXT, MEDICAL_INFO_NUMBER, DOCTOR_NUMBER) VALUES
(DOCTOR_COMMENT_SEQ.NEXTVAL, '이 주제에 대해 더 알고 싶습니다.', 2, 4);
INSERT INTO DT_DOCTOR_COMMENT (DOCTOR_COMMENT_NUMBER, DOCTOR_COMMENT_TEXT, MEDICAL_INFO_NUMBER, DOCTOR_NUMBER) VALUES
(DOCTOR_COMMENT_SEQ.NEXTVAL, '좋은 팁이네요! 실천해 보겠습니다.', 3, 3);
INSERT INTO DT_DOCTOR_COMMENT (DOCTOR_COMMENT_NUMBER, DOCTOR_COMMENT_TEXT, MEDICAL_INFO_NUMBER, DOCTOR_NUMBER) VALUES
(DOCTOR_COMMENT_SEQ.NEXTVAL, '이 내용이 많은 사람에게 도움이 될 것 같습니다.', 4, 2);
INSERT INTO DT_DOCTOR_COMMENT (DOCTOR_COMMENT_NUMBER, DOCTOR_COMMENT_TEXT, MEDICAL_INFO_NUMBER, DOCTOR_NUMBER) VALUES
(DOCTOR_COMMENT_SEQ.NEXTVAL, '유용한 정보 감사합니다. 자주 확인하겠습니다.', 5, 1);


SELECT * FROM DT_DOCTOR_COMMENT;

--7) CHAT SESSION 테이블

INSERT INTO DT_CHAT_SESSION (SESSION_NUMBER, SESSION_STATUS, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHAT_SESSION_SEQ.NEXTVAL, '진료중', 1, 5);
INSERT INTO DT_CHAT_SESSION (SESSION_NUMBER, SESSION_STATUS, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHAT_SESSION_SEQ.NEXTVAL, '진료종료', 2, 4);
INSERT INTO DT_CHAT_SESSION (SESSION_NUMBER, SESSION_STATUS, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHAT_SESSION_SEQ.NEXTVAL, '진료대기', 3, 3);
INSERT INTO DT_CHAT_SESSION (SESSION_NUMBER, SESSION_STATUS, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHAT_SESSION_SEQ.NEXTVAL, '진료종료', 4, 2);
INSERT INTO DT_CHAT_SESSION (SESSION_NUMBER, SESSION_STATUS, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHAT_SESSION_SEQ.NEXTVAL, '진료중', 5, 1);


SELECT * FROM DT_CHAT_SESSION;

--8) CHAT 테이블

INSERT INTO DT_CHAT (CHAT_NUMBER, CHAT_ROOM_NUMBER, CHAT_TEXT, CHAT_MSG_DATE, SESSION_NUMBER) VALUES
(CHAT_SEQ.NEXTVAL, CHAT_ROOM_SEQ.NEXTVAL, '안녕하세요, 의사 선생님.', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 1);
INSERT INTO DT_CHAT (CHAT_NUMBER, CHAT_ROOM_NUMBER, CHAT_TEXT, CHAT_MSG_DATE, SESSION_NUMBER) VALUES
(CHAT_SEQ.NEXTVAL, CHAT_ROOM_SEQ.NEXTVAL, '안녕하세요! 어떻게 도와드릴까요?', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 2);
INSERT INTO DT_CHAT (CHAT_NUMBER, CHAT_ROOM_NUMBER, CHAT_TEXT, CHAT_MSG_DATE, SESSION_NUMBER) VALUES
(CHAT_SEQ.NEXTVAL, CHAT_ROOM_SEQ.NEXTVAL, '최근에 기분이 우울해요.', TO_DATE('2024-06-02', 'YYYY-MM-DD'), 3);
INSERT INTO DT_CHAT (CHAT_NUMBER, CHAT_ROOM_NUMBER, CHAT_TEXT, CHAT_MSG_DATE, SESSION_NUMBER) VALUES
(CHAT_SEQ.NEXTVAL, CHAT_ROOM_SEQ.NEXTVAL, '이해합니다. 어떤 일이 있었나요?', TO_DATE('2024-06-02', 'YYYY-MM-DD'), 4);
INSERT INTO DT_CHAT (CHAT_NUMBER, CHAT_ROOM_NUMBER, CHAT_TEXT, CHAT_MSG_DATE, SESSION_NUMBER) VALUES
(CHAT_SEQ.NEXTVAL, CHAT_ROOM_SEQ.NEXTVAL, '건강 검진 결과가 궁금합니다.', TO_DATE('2024-06-03', 'YYYY-MM-DD'), 5);


SELECT * FROM DT_CHAT;

--9) CHART 테이블

INSERT INTO DT_CHART (CHART_NUMBER, CHART_NAME, CHART_MEDICINE, CHART_DAY, CHART_TIME, CHART_PERIOD, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHART_SEQ.NEXTVAL, '감기 치료', '타이레놀', '1일 3회', '식후', '5일치', 1, 5);
INSERT INTO DT_CHART (CHART_NUMBER, CHART_NAME, CHART_MEDICINE, CHART_DAY, CHART_TIME, CHART_PERIOD, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHART_SEQ.NEXTVAL, '고혈압 관리', '로카신', '1일 1회', '식전', '30일치', 2, 4);
INSERT INTO DT_CHART (CHART_NUMBER, CHART_NAME, CHART_MEDICINE, CHART_DAY, CHART_TIME, CHART_PERIOD, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHART_SEQ.NEXTVAL, '당뇨 관리', '메트포르민', '1일 2회', '식후', '90일치', 3, 3);
INSERT INTO DT_CHART (CHART_NUMBER, CHART_NAME, CHART_MEDICINE, CHART_DAY, CHART_TIME, CHART_PERIOD, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHART_SEQ.NEXTVAL, '소화불량', '오메프라졸', '1일 1회', '식전', '14일치', 4, 2);
INSERT INTO DT_CHART (CHART_NUMBER, CHART_NAME, CHART_MEDICINE, CHART_DAY, CHART_TIME, CHART_PERIOD, MEMBER_NUMBER, DOCTOR_NUMBER) VALUES
(CHART_SEQ.NEXTVAL, '알레르기', '항히스타민제', '1일 2회', '식후', '7일치', 5, 1);

SELECT * FROM DT_CHART;







--   로그인 페이지
SELECT login.USER_ID,login.USER_PW
FROM (
    SELECT 
        MEMBER_ID AS USER_ID,
        MEMBER_PW AS USER_PW
    FROM 
        DT_MEMBER
    UNION ALL
    SELECT 
        DOCTOR_ID AS USER_ID,
        DOCTOR_ID AS USER_PW
    FROM 
        DT_DOCTOR
) login
WHERE 
    login.USER_ID = '유저가 입력한 아이디' AND login.USER_PW = '유저가 입력한 비밀번호'; 
    
--   아이디 찾기
--   비밀번호 찾기
   
   SELECT * FROM DT_DOCTOR dd ;
  SELECT*FROM DT_MEMBER dm ;
   SELECT*FROM DT_MEDICAL_INFO;
  
--   의사,일반 회원가입 페이지 ID 중복확인 조회
SELECT login.USER_ID
FROM (
    SELECT 
        MEMBER_ID AS USER_ID
    FROM 
        DT_MEMBER
    UNION ALL
    SELECT 
        DOCTOR_ID AS USER_ID
    FROM 
        DT_DOCTOR
) login
WHERE 
    login.USER_ID = '유저가 입력한 아이디';
   
   SELECT * FROM DT_ADDRESS;
   SELECT * FROM DT_MEMBER; 
   SELECT * FROM DT_DOCTOR;

  -- 일반회원의 마이페이지
  SELECT
   dm.MEMBER_ID,
   dm.MEMBER_NAME,
   dm.MEMBER_BIRTH,
   dm.MEMBER_PHONE,
   da.ADDRESS_POSTAL,
   da.ADDRESS_ADDRESS,
   da.ADDRESS_DETAIL
FROM
   DT_MEMBER dm
JOIN DT_ADDRESS da ON
   dm.ADDRESS_NUMBER = da.ADDRESS_NUMBER; 
  -- 의사회원의 마이페이지
  SELECT
   dd.DOCTOR_ID,
   dd.DOCTOR_NAME,
   dh.HOSPITAL_NAME,
   dd.DOCTOR_PHONE,
   dh.HOSPITAL_CALL,
   da.ADDRESS_POSTAL,
   da.ADDRESS_ADDRESS,
   da.ADDRESS_DETAIL
FROM
   DT_DOCTOR dd
JOIN DT_HOSPITAL dh ON
   dd.HOSPITAL_NUMBER = dh.HOSPITAL_NUMBER
JOIN DT_ADDRESS da ON
   dh.ADDRESS_NUMBER = da.ADDRESS_NUMBER;

SELECT * FROM DT_MEDICAL_INFO;
SELECT * FROM DT_MEMBER;
SELECT * FROM DT_DOCTOR dd ;
SELECT * FROM DT_DOCTOR_COMMENT ddc ;
   
--   의료지식인 페이지
SELECT
   dmi.MEDICAL_INFO_TITLE ,
   dmi.MEDICAL_INFO_TEXT,
   dm.MEMBER_NAME
FROM
   DT_MEDICAL_INFO dmi
JOIN DT_MEMBER dm ON
   dmi.MEMBER_NUMBER = dm.MEMBER_NUMBER;	

--   의료지식인 상세페이지
SELECT
   dmi.MEDICAL_INFO_TITLE,
   dm.MEMBER_NAME,
   dmi.MEDICAL_INFO_DATE,
   dmi.MEDICAL_INFO_TEXT,
   dd.DOCTOR_MAJOR,
   dd.DOCTOR_NAME,
   ddc.DOCTOR_COMMENT_TEXT
FROM
   DT_MEDICAL_INFO dmi
JOIN DT_MEMBER dm ON
   dmi.MEMBER_NUMBER = dm.MEMBER_NUMBER
JOIN DT_DOCTOR_COMMENT ddc ON
   ddc.MEDICAL_INFO_NUMBER = dmi.MEDICAL_INFO_NUMBER
JOIN DT_DOCTOR dd ON
   ddc.DOCTOR_NUMBER = dd.DOCTOR_NUMBER;

  SELECT*FROM 
  
  ALTER TABLE DT_MEDICAL_INFO
ADD MEDICAL_INFO_MODIFY_DATE DATE;

ALTER TABLE DT_MEDICAL_INFO
DROP COLUMN MEDICAL_INFO_SUBJECT;

SELECT * FROM DT_MEDICAL_INFO dmi ;

SELECT * FROM DT_MEDICAL_INFO dmi;
SELECT * FROM DT_MEMBER dm;

SELECT dmi.MEDICAL_INFO_TITLE , dmi.MEDICAL_INFO_TEXT, dm.MEMBER_NAME
	FROM DT_MEDICAL_INFO dmi JOIN DT_MEMBER dm ON dmi.MEMBER_NUMBER = dm.MEMBER_NUMBER;

SELECT 
    D.DOCTOR_ID AS 아이디,
    D.DOCTOR_PW AS 비밀번호,  -- 비밀번호 확인란은 비밀번호와 동일하게 가져옴
    D.DOCTOR_NAME AS 이름,
    A.ADDRESS_POSTAL AS 우편번호,
    A.ADDRESS_ADDRESS AS 주소,
    A.ADDRESS_DETAIL AS 상세주소,
    D.DOCTOR_PHONE AS 핸드폰번호,
    H.HOSPITAL_NAME AS 병원이름,
    D.DOCTOR_LICENSE AS 면허번호,
    D.DOCTOR_MAJOR AS 진료과목
FROM 
    DT_DOCTOR D
JOIN 
    DT_HOSPITAL H ON D.HOSPITAL_NUMBER = H.HOSPITAL_NUMBER
JOIN 
    DT_ADDRESS A ON H.ADDRESS_NUMBER = A.ADDRESS_NUMBER;
   
   SELECT*FROM DT_ADDRESS;
   SELECT*FROM DT_HOSPITAL;
  
  SELECT*FROM DT_DOCTOR;
 SELECT*FROM DT_MEMBER;

  
--      HOSPITAL_WORK_TIME DATE NOT NULL,
--    HOSPITAL_LUNCH_TIME
  ALTER TABLE DT_HOSPITAL DROP COLUMN HOSPITAL_WORK_TIME; 
  ALTER TABLE DT_HOSPITAL DROP COLUMN HOSPITAL_LUNCH_TIME; 


