-- ============================================================
-- BANGLADESH JOB RECRUITMENT & CAREER PORTAL
-- Complete Database Script for Oracle APEX
-- ============================================================

-- STEP 1: DROP EXISTING TABLES (Clean Slate)
BEGIN
  FOR t IN (
    SELECT table_name FROM user_tables
    WHERE table_name IN (
      'REVIEWS','OFFERS','INTERVIEWS','APPLICATIONS',
      'RESUMESKILLS','RESUMES','JOBSKILLS','SKILLS',
      'JOBS','COMPANIES','EMPLOYERS','JOBSEEKERS'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- STEP 2: DROP SEQUENCES
BEGIN
  FOR s IN (
    SELECT sequence_name FROM user_sequences
    WHERE sequence_name IN (
      'SEQ_JOBSEEKERS','SEQ_EMPLOYERS','SEQ_COMPANIES',
      'SEQ_SKILLS','SEQ_JOBS','SEQ_RESUMES','SEQ_JOBSKILLS',
      'SEQ_RESUMESKILLS','SEQ_APPLICATIONS','SEQ_INTERVIEWS',
      'SEQ_OFFERS','SEQ_REVIEWS'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
  END LOOP;
END;
/

-- ============================================================
-- SEQUENCES
-- ============================================================
CREATE SEQUENCE SEQ_JOBSEEKERS   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_EMPLOYERS    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_COMPANIES    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_SKILLS       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_JOBS         START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_RESUMES      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_JOBSKILLS    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_RESUMESKILLS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_APPLICATIONS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_INTERVIEWS   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_OFFERS       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_REVIEWS      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ============================================================
-- TABLE 1: JOBSEEKERS
-- ============================================================
CREATE TABLE JobSeekers (
  seeker_id    NUMBER PRIMARY KEY,
  full_name    VARCHAR2(100) NOT NULL,
  email        VARCHAR2(100) UNIQUE NOT NULL,
  phone        VARCHAR2(20),
  address      VARCHAR2(200),
  dob          DATE,
  gender       VARCHAR2(10) CHECK (gender IN ('Male','Female','Other')),
  status       VARCHAR2(20) DEFAULT 'Active' CHECK (status IN ('Active','Inactive')),
  created_at   DATE DEFAULT SYSDATE
);

-- TABLE 2: COMPANIES
CREATE TABLE Companies (
  company_id   NUMBER PRIMARY KEY,
  company_name VARCHAR2(150) NOT NULL,
  industry     VARCHAR2(100),
  address      VARCHAR2(200),
  city         VARCHAR2(50),
  website      VARCHAR2(150),
  established  NUMBER(4),
  status       VARCHAR2(20) DEFAULT 'Active' CHECK (status IN ('Active','Inactive')),
  created_at   DATE DEFAULT SYSDATE
);

-- TABLE 3: EMPLOYERS
CREATE TABLE Employers (
  employer_id  NUMBER PRIMARY KEY,
  full_name    VARCHAR2(100) NOT NULL,
  email        VARCHAR2(100) UNIQUE NOT NULL,
  phone        VARCHAR2(20),
  company_id   NUMBER REFERENCES Companies(company_id),
  designation  VARCHAR2(100),
  status       VARCHAR2(20) DEFAULT 'Active' CHECK (status IN ('Active','Inactive')),
  created_at   DATE DEFAULT SYSDATE
);

-- TABLE 4: SKILLS
CREATE TABLE Skills (
  skill_id     NUMBER PRIMARY KEY,
  skill_name   VARCHAR2(100) NOT NULL,
  category     VARCHAR2(100),
  status       VARCHAR2(20) DEFAULT 'Active' CHECK (status IN ('Active','Inactive'))
);

-- TABLE 5: JOBS
CREATE TABLE Jobs (
  job_id       NUMBER PRIMARY KEY,
  title        VARCHAR2(150) NOT NULL,
  company_id   NUMBER REFERENCES Companies(company_id),
  employer_id  NUMBER REFERENCES Employers(employer_id),
  category     VARCHAR2(100),
  job_type     VARCHAR2(50) CHECK (job_type IN ('Full-Time','Part-Time','Remote','Internship','Contract')),
  location     VARCHAR2(100),
  salary_min   NUMBER(12,2),
  salary_max   NUMBER(12,2),
  description  VARCHAR2(2000),
  deadline     DATE,
  status       VARCHAR2(20) DEFAULT 'Open' CHECK (status IN ('Open','Closed','Draft')),
  posted_at    DATE DEFAULT SYSDATE
);

-- TABLE 6: JOBSKILLS (Junction: Jobs <-> Skills)
CREATE TABLE JobSkills (
  jobskill_id  NUMBER PRIMARY KEY,
  job_id       NUMBER REFERENCES Jobs(job_id) ON DELETE CASCADE,
  skill_id     NUMBER REFERENCES Skills(skill_id) ON DELETE CASCADE,
  CONSTRAINT uq_jobskill UNIQUE (job_id, skill_id)
);

-- TABLE 7: RESUMES
CREATE TABLE Resumes (
  resume_id    NUMBER PRIMARY KEY,
  seeker_id    NUMBER REFERENCES JobSeekers(seeker_id) ON DELETE CASCADE,
  title        VARCHAR2(150) NOT NULL,
  education    VARCHAR2(500),
  experience   VARCHAR2(500),
  objective    VARCHAR2(500),
  created_at   DATE DEFAULT SYSDATE,
  updated_at   DATE DEFAULT SYSDATE
);

-- TABLE 8: RESUMESKILLS (Junction: Resumes <-> Skills)
CREATE TABLE ResumeSkills (
  rs_id        NUMBER PRIMARY KEY,
  resume_id    NUMBER REFERENCES Resumes(resume_id) ON DELETE CASCADE,
  skill_id     NUMBER REFERENCES Skills(skill_id) ON DELETE CASCADE,
  proficiency  VARCHAR2(20) DEFAULT 'Intermediate'
                CHECK (proficiency IN ('Beginner','Intermediate','Advanced','Expert')),
  CONSTRAINT uq_resumeskill UNIQUE (resume_id, skill_id)
);

-- TABLE 9: APPLICATIONS
CREATE TABLE Applications (
  app_id       NUMBER PRIMARY KEY,
  job_id       NUMBER REFERENCES Jobs(job_id) ON DELETE CASCADE,
  seeker_id    NUMBER REFERENCES JobSeekers(seeker_id) ON DELETE CASCADE,
  resume_id    NUMBER REFERENCES Resumes(resume_id),
  cover_letter VARCHAR2(1000),
  status       VARCHAR2(30) DEFAULT 'Pending'
                CHECK (status IN ('Pending','Reviewed','Shortlisted','Rejected','Hired')),
  applied_at   DATE DEFAULT SYSDATE,
  CONSTRAINT uq_application UNIQUE (job_id, seeker_id)
);

-- TABLE 10: INTERVIEWS
CREATE TABLE Interviews ( 
  interview_id  NUMBER PRIMARY KEY, 
  app_id        NUMBER REFERENCES Applications(app_id) ON DELETE CASCADE, 
  scheduled_at  DATE NOT NULL, 
  location      VARCHAR2(200), 
  interview_mode VARCHAR2(20) DEFAULT 'In-Person' 
                 CHECK (interview_mode IN ('In-Person','Online','Phone')), 
  status        VARCHAR2(20) DEFAULT 'Scheduled' 
                 CHECK (status IN ('Scheduled','Completed','Cancelled','Rescheduled')), 
  remarks       VARCHAR2(500) 
);

-- TABLE 11: OFFERS
CREATE TABLE Offers (
  offer_id     NUMBER PRIMARY KEY,
  app_id       NUMBER REFERENCES Applications(app_id) ON DELETE CASCADE,
  offered_salary NUMBER(12,2),
  offer_date   DATE DEFAULT SYSDATE,
  joining_date DATE,
  status       VARCHAR2(20) DEFAULT 'Pending'
                CHECK (status IN ('Pending','Accepted','Declined','Withdrawn')),
  remarks      VARCHAR2(500)
);

-- TABLE 12: REVIEWS
CREATE TABLE Reviews (
  review_id    NUMBER PRIMARY KEY,
  seeker_id    NUMBER REFERENCES JobSeekers(seeker_id) ON DELETE CASCADE,
  company_id   NUMBER REFERENCES Companies(company_id) ON DELETE CASCADE,
  rating       NUMBER(1) CHECK (rating BETWEEN 1 AND 5),
  title        VARCHAR2(200),
  comments     VARCHAR2(1000),
  reviewed_at  DATE DEFAULT SYSDATE
);

-- ============================================================
-- VIEWS (Demonstrates SQL JOIN knowledge)
-- ============================================================
CREATE OR REPLACE VIEW VW_JOB_DETAILS AS
SELECT
  j.job_id, j.title, j.category, j.job_type, j.location,
  j.salary_min, j.salary_max, j.deadline, j.status AS job_status,
  c.company_name, c.industry, c.city,
  e.full_name AS employer_name, e.email AS employer_email,
  j.posted_at
FROM Jobs j
JOIN Companies c ON j.company_id = c.company_id
JOIN Employers e ON j.employer_id = e.employer_id;

CREATE OR REPLACE VIEW VW_APPLICATION_DETAILS AS
SELECT
  a.app_id, a.status AS app_status, a.applied_at,
  js.full_name AS seeker_name, js.email AS seeker_email, js.phone,
  j.title AS job_title, j.category, j.location,
  c.company_name,
  r.title AS resume_title,
  a.cover_letter
FROM Applications a
JOIN JobSeekers js ON a.seeker_id = js.seeker_id
JOIN Jobs j        ON a.job_id    = j.job_id
JOIN Companies c   ON j.company_id = c.company_id
LEFT JOIN Resumes r ON a.resume_id = r.resume_id;

CREATE OR REPLACE VIEW VW_INTERVIEW_DETAILS AS
SELECT
  i.interview_id, i.scheduled_at, i.location AS interview_location,
  i.mode, i.status AS interview_status, i.remarks,
  js.full_name AS seeker_name, js.email AS seeker_email,
  j.title AS job_title,
  c.company_name
FROM Interviews i
JOIN Applications a ON i.app_id    = a.app_id
JOIN JobSeekers js  ON a.seeker_id = js.seeker_id
JOIN Jobs j         ON a.job_id    = j.job_id
JOIN Companies c    ON j.company_id = c.company_id;

-- ============================================================
-- TRIGGER: Auto-update resume updated_at
-- ============================================================
CREATE OR REPLACE TRIGGER trg_resume_update
BEFORE UPDATE ON Resumes
FOR EACH ROW
BEGIN
  :NEW.updated_at := SYSDATE;
END;
/

-- ============================================================
-- SAMPLE DATA: COMPANIES (Bangladeshi Context)
-- ============================================================
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'Grameenphone Ltd','Telecommunications','GPHouse, Bashundhara, Dhaka','Dhaka','www.grameenphone.com',1996,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'BRAC Bank Limited','Banking & Finance','1 Gulshan Avenue, Dhaka','Dhaka','www.bracbank.com',2001,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'Robi Axiata Limited','Telecommunications','53 Gulshan South Avenue, Dhaka','Dhaka','www.robi.com.bd',1997,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'Square Pharmaceuticals Ltd','Healthcare & Pharma','Square Centre, 48 Mohakhali, Dhaka','Dhaka','www.squarepharma.com.bd',1958,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'SELISE Digital Platforms','Information Technology','House 18, Road 14, Gulshan 1, Dhaka','Dhaka','www.selise.com',2014,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'Bashundhara Group','Conglomerate','Bashundhara City, Panthapath, Dhaka','Dhaka','www.bashundhara.com.bd',1987,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'ACI Limited','FMCG & Healthcare','245 Tejgaon Industrial Area, Dhaka','Dhaka','www.aci-bd.com',1968,'Active',SYSDATE);
INSERT INTO Companies VALUES (SEQ_COMPANIES.NEXTVAL,'Dutch-Bangla Bank Limited','Banking & Finance','Sena Kalyan Bhaban, Motijheel, Dhaka','Dhaka','www.dutchbanglabank.com',1996,'Active',SYSDATE);

-- SAMPLE DATA: JOBSEEKERS (Bangladeshi Names)
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Md. Rakibul Hasan','rakibul.hasan@gmail.com','01711234567','House 12, Road 4, Mirpur, Dhaka',TO_DATE('1998-03-15','YYYY-MM-DD'),'Male','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Fatema Begum','fatema.begum@gmail.com','01812345678','Flat 3B, Dhanmondi 27, Dhaka',TO_DATE('1999-07-22','YYYY-MM-DD'),'Female','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Arif Hossain','arif.hossain@yahoo.com','01913456789','Agrabad, Chattogram',TO_DATE('1997-11-10','YYYY-MM-DD'),'Male','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Sumaiya Akter','sumaiya.akter@gmail.com','01614567890','Sylhet Sadar, Sylhet',TO_DATE('2000-05-18','YYYY-MM-DD'),'Female','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Tanvir Ahmed','tanvir.ahmed@gmail.com','01515678901','Khulna Sadar, Khulna',TO_DATE('1996-09-25','YYYY-MM-DD'),'Male','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Nusrat Jahan','nusrat.jahan@gmail.com','01716789012','Uttara Sector 7, Dhaka',TO_DATE('2001-01-30','YYYY-MM-DD'),'Female','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Sabbir Rahman','sabbir.rahman@gmail.com','01617890123','Rajshahi Sadar, Rajshahi',TO_DATE('1995-06-14','YYYY-MM-DD'),'Male','Active',SYSDATE);
INSERT INTO JobSeekers VALUES (SEQ_JOBSEEKERS.NEXTVAL,'Marium Khanam','marium.khanam@gmail.com','01518901234','Bashundhara R/A, Dhaka',TO_DATE('1999-12-05','YYYY-MM-DD'),'Female','Active',SYSDATE);

-- SAMPLE DATA: EMPLOYERS
INSERT INTO Employers VALUES (SEQ_EMPLOYERS.NEXTVAL,'Md. Kamal Uddin','kamal.uddin@grameenphone.com','01711111101',1,'HR Manager','Active',SYSDATE);
INSERT INTO Employers VALUES (SEQ_EMPLOYERS.NEXTVAL,'Reshma Parvin','reshma.parvin@bracbank.com','01812222202',2,'Recruitment Lead','Active',SYSDATE);
INSERT INTO Employers VALUES (SEQ_EMPLOYERS.NEXTVAL,'Zahirul Islam','zahirul.islam@robi.com.bd','01913333303',3,'Talent Acquisition','Active',SYSDATE);
INSERT INTO Employers VALUES (SEQ_EMPLOYERS.NEXTVAL,'Shirin Akhter','shirin.akhter@squarepharma.com','01614444404',4,'HR Director','Active',SYSDATE);
INSERT INTO Employers VALUES (SEQ_EMPLOYERS.NEXTVAL,'Nasim Mahmud','nasim.mahmud@selise.com','01515555505',5,'CTO','Active',SYSDATE);
INSERT INTO Employers VALUES (SEQ_EMPLOYERS.NEXTVAL,'Habibur Rahman','habibur.rahman@bashundhara.com','01716666606',6,'HR Executive','Active',SYSDATE);

-- SAMPLE DATA: SKILLS
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'SQL & Database Management','Technology','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Python Programming','Technology','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Java Development','Technology','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Financial Analysis','Finance','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Digital Marketing','Marketing','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Communication Skills','Soft Skills','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Project Management','Management','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Network Engineering','Technology','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Pharmaceutical Research','Healthcare','Active');
INSERT INTO Skills VALUES (SEQ_SKILLS.NEXTVAL,'Data Analysis','Technology','Active');

-- SAMPLE DATA: JOBS
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Software Engineer',1,1,'Computing & ICT','Full-Time','Dhaka',50000,80000,'Develop and maintain enterprise software solutions.',TO_DATE('2025-09-30','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Financial Analyst',2,2,'Banking & Finance','Full-Time','Dhaka',45000,70000,'Analyze financial data and prepare reports for management.',TO_DATE('2025-08-31','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Network Engineer',3,3,'Telecommunications','Full-Time','Dhaka',55000,85000,'Design and maintain telecom network infrastructure.',TO_DATE('2025-10-15','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Medical Sales Representative',4,4,'Healthcare & Pharma','Full-Time','Chattogram',35000,55000,'Promote and sell pharmaceutical products to healthcare providers.',TO_DATE('2025-07-31','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Full Stack Developer',5,5,'Computing & ICT','Remote','Dhaka',70000,110000,'Build scalable web applications using modern frameworks.',TO_DATE('2025-11-30','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Marketing Executive',6,6,'Marketing','Full-Time','Dhaka',30000,45000,'Plan and execute marketing campaigns for brand growth.',TO_DATE('2025-08-15','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Data Analyst Intern',5,5,'Computing & ICT','Internship','Dhaka',15000,20000,'Assist in data collection, cleaning, and visualization.',TO_DATE('2025-07-15','YYYY-MM-DD'),'Open',SYSDATE);
INSERT INTO Jobs VALUES (SEQ_JOBS.NEXTVAL,'Branch Manager',8,2,'Banking & Finance','Full-Time','Sylhet',80000,120000,'Oversee daily branch operations and team management.',TO_DATE('2025-09-01','YYYY-MM-DD'),'Open',SYSDATE);

-- SAMPLE DATA: JOBSKILLS
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,1,1);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,1,2);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,1,10);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,2,4);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,2,10);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,3,8);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,5,2);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,5,3);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,5,1);
INSERT INTO JobSkills VALUES (SEQ_JOBSKILLS.NEXTVAL,6,5);

-- SAMPLE DATA: RESUMES
INSERT INTO Resumes VALUES (SEQ_RESUMES.NEXTVAL,1,'Software Engineering CV','BSc CSE, BUET 2020','2 years at StartupBD as Junior Developer','Seeking a challenging role in software development',SYSDATE,SYSDATE);
INSERT INTO Resumes VALUES (SEQ_RESUMES.NEXTVAL,2,'Finance & Accounting CV','BBA Finance, DU 2021','1 year internship at BRAC Bank','Aspiring financial analyst with strong analytical skills',SYSDATE,SYSDATE);
INSERT INTO Resumes VALUES (SEQ_RESUMES.NEXTVAL,3,'Telecom Engineer CV','BSc EEE, CUET 2019','3 years at Robi as Field Engineer','Looking for senior network engineering roles',SYSDATE,SYSDATE);
INSERT INTO Resumes VALUES (SEQ_RESUMES.NEXTVAL,4,'Pharmaceutical Sales CV','BSc Pharmacy, NSU 2022','Fresher with strong communication skills','Eager to join pharma sales and grow professionally',SYSDATE,SYSDATE);
INSERT INTO Resumes VALUES (SEQ_RESUMES.NEXTVAL,5,'Full Stack Developer CV','BSc CSE, AIUB 2020','3 years at SELISE as Web Developer','Passionate full-stack developer targeting remote roles',SYSDATE,SYSDATE);

-- SAMPLE DATA: RESUMESKILLS
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,1,1,'Advanced');
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,1,2,'Intermediate');
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,2,4,'Advanced');
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,3,8,'Expert');
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,4,6,'Advanced');
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,5,2,'Expert');
INSERT INTO ResumeSkills VALUES (SEQ_RESUMESKILLS.NEXTVAL,5,3,'Advanced');

-- SAMPLE DATA: APPLICATIONS
INSERT INTO Applications VALUES (SEQ_APPLICATIONS.NEXTVAL,1,1,1,'I am highly motivated and have strong SQL & Python skills that match this role.','Shortlisted',TO_DATE('2025-06-01','YYYY-MM-DD'));
INSERT INTO Applications VALUES (SEQ_APPLICATIONS.NEXTVAL,2,2,2,'My finance background at DU and internship at BRAC Bank make me an ideal candidate.','Reviewed',TO_DATE('2025-06-05','YYYY-MM-DD'));
INSERT INTO Applications VALUES (SEQ_APPLICATIONS.NEXTVAL,3,3,3,'Three years of telecom experience at Robi qualifies me for this position.','Shortlisted',TO_DATE('2025-06-10','YYYY-MM-DD'));
INSERT INTO Applications VALUES (SEQ_APPLICATIONS.NEXTVAL,5,5,5,'I have built multiple full-stack projects and am ready to contribute immediately.','Pending',TO_DATE('2025-06-15','YYYY-MM-DD'));
INSERT INTO Applications VALUES (SEQ_APPLICATIONS.NEXTVAL,6,6,NULL,'Strong marketing background with proven campaign results.','Pending',TO_DATE('2025-06-18','YYYY-MM-DD'));
INSERT INTO Applications VALUES (SEQ_APPLICATIONS.NEXTVAL,4,4,4,'Pharmacy graduate eager to start career in medical sales.','Reviewed',TO_DATE('2025-06-20','YYYY-MM-DD'));

-- SAMPLE DATA: INTERVIEWS
INSERT INTO Interviews VALUES (SEQ_INTERVIEWS.NEXTVAL,1,TO_DATE('2025-07-05 10:00','YYYY-MM-DD HH24:MI'),'Grameenphone HQ, Bashundhara, Dhaka','In-Person','Scheduled','Bring original certificates and NID copy');
INSERT INTO Interviews VALUES (SEQ_INTERVIEWS.NEXTVAL,2,TO_DATE('2025-07-08 14:00','YYYY-MM-DD HH24:MI'),'Google Meet - Link shared via email','Online','Scheduled','Technical round focusing on Excel and financial modelling');
INSERT INTO Interviews VALUES (SEQ_INTERVIEWS.NEXTVAL,3,TO_DATE('2025-07-10 11:00','YYYY-MM-DD HH24:MI'),'Robi HQ, Gulshan, Dhaka','In-Person','Completed','Candidate performed excellently in technical round');

-- SAMPLE DATA: OFFERS
INSERT INTO Offers VALUES (SEQ_OFFERS.NEXTVAL,1,75000,SYSDATE,TO_DATE('2025-08-01','YYYY-MM-DD'),'Accepted','Offer accepted. Joining confirmed.');
INSERT INTO Offers VALUES (SEQ_OFFERS.NEXTVAL,3,80000,SYSDATE,TO_DATE('2025-08-15','YYYY-MM-DD'),'Pending','Awaiting candidate response within 7 days.');

-- SAMPLE DATA: REVIEWS
INSERT INTO Reviews VALUES (SEQ_REVIEWS.NEXTVAL,1,1,5,'Excellent Work Culture','Grameenphone has a very professional work environment. Great learning opportunities and competitive salary.',SYSDATE);
INSERT INTO Reviews VALUES (SEQ_REVIEWS.NEXTVAL,2,2,4,'Good But Demanding','BRAC Bank offers great exposure but workload can be intense. Overall a solid employer.',SYSDATE);
INSERT INTO Reviews VALUES (SEQ_REVIEWS.NEXTVAL,3,3,4,'Modern Infrastructure','Robi has excellent technical infrastructure. Good for telecom engineers.',SYSDATE);
INSERT INTO Reviews VALUES (SEQ_REVIEWS.NEXTVAL,5,5,5,'Best Tech Company in BD','SELISE truly values engineers. Remote-friendly, good salary, and great team culture.',SYSDATE);

COMMIT;

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================
SELECT 'Companies'    AS entity, COUNT(*) AS total FROM Companies    UNION ALL
SELECT 'JobSeekers',                COUNT(*)         FROM JobSeekers  UNION ALL
SELECT 'Employers',                 COUNT(*)         FROM Employers   UNION ALL
SELECT 'Skills',                    COUNT(*)         FROM Skills      UNION ALL
SELECT 'Jobs',                      COUNT(*)         FROM Jobs        UNION ALL
SELECT 'Applications',              COUNT(*)         FROM Applications UNION ALL
SELECT 'Interviews',                COUNT(*)         FROM Interviews  UNION ALL
SELECT 'Offers',                    COUNT(*)         FROM Offers      UNION ALL
SELECT 'Reviews',                   COUNT(*)         FROM Reviews;