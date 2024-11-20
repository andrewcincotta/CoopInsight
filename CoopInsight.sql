DROP DATABASE IF EXISTS CoopInsight;
CREATE DATABASE IF NOT EXISTS CoopInsight;
USE CoopInsight;
CREATE TABLE IF NOT EXISTS `User`
(
    UserID      INT PRIMARY KEY AUTO_INCREMENT,
    FirstName   VARCHAR(50) NOT NULL,
    LastName    VARCHAR(50) NOT NULL,
    Email       VARCHAR(50) NOT NULL,
    Password    VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    AccessLevel VARCHAR(50) NOT NULL DEFAULT 'User'
);
CREATE TABLE IF NOT EXISTS Skill
(
    SkillID   INT PRIMARY KEY AUTO_INCREMENT,
    SkillName VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS Industry
(
    IndustryID   INT PRIMARY KEY AUTO_INCREMENT,
    IndustryName VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS StudentMajor
(
    Major      VARCHAR(50) PRIMARY KEY,
    IndustryID INT NOT NULL REFERENCES Industry (IndustryID) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS Company
(
    CompanyID          INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName        VARCHAR(50)  NOT NULL,
    IndustryID         INT          NOT NULL REFERENCES Industry (IndustryID) ON UPDATE CASCADE ON DELETE RESTRICT,
    CompanyDescription VARCHAR(500) NOT NULL,
    AdminID            INT          NOT NULL REFERENCES `User` (UserID) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS JobListing
(
    JobID          INT PRIMARY KEY AUTO_INCREMENT,
    Name           VARCHAR(50)  NOT NULL,
    CompanyID      INT          NOT NULL REFERENCES Company (CompanyID) ON UPDATE CASCADE ON DELETE CASCADE,
    Major          VARCHAR(50)  NOT NULL REFERENCES StudentMajor (Major) ON UPDATE CASCADE ON DELETE CASCADE,
    MinGPA         FLOAT(4)     NOT NULL,
    IndustryID     INT          NOT NULL REFERENCES Industry (IndustryID) ON UPDATE CASCADE ON DELETE RESTRICT,
    Posted         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    JobDescription VARCHAR(500) NOT NULL,
    SkillID        INT          NOT NULL REFERENCES Skill (SkillID) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS Employee
(
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    UserID     INT         NOT NULL REFERENCES `User` (UserID) ON UPDATE CASCADE ON DELETE CASCADE,
    HiredOn    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Role       VARCHAR(50) NOT NULL DEFAULT 'Employee',
    JobID      INT         NOT NULL REFERENCES JobListing (JobID) ON UPDATE CASCADE ON DELETE RESTRICT,
    CompanyID  INT         NOT NULL REFERENCES Company (CompanyID) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Student
(
    StudentID    INT PRIMARY KEY AUTO_INCREMENT,
    UserID       INT         NOT NULL REFERENCES `User` (UserID) ON UPDATE CASCADE ON DELETE CASCADE,
    GPA          FLOAT(4)    NOT NULL,
    Skill        INT         NOT NULL REFERENCES Skill (SkillID) ON UPDATE CASCADE ON DELETE RESTRICT,
    Major        VARCHAR(50) NOT NULL REFERENCES StudentMajor (Major) ON UPDATE CASCADE ON DELETE RESTRICT,
    SupervisorID INT REFERENCES Employee (EmployeeID) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS Applicant
(
    ApplicantID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID   INT         NOT NULL REFERENCES Student (StudentID) ON UPDATE CASCADE ON DELETE CASCADE,
    JobID       INT         NOT NULL REFERENCES JobListing (JobID) ON UPDATE CASCADE ON DELETE CASCADE,
    Status      VARCHAR(50) NOT NULL DEFAULT 'Pending'
);
CREATE TABLE IF NOT EXISTS JobHistory
(
    JobHistoryID        INT PRIMARY KEY AUTO_INCREMENT,
    UserID              INT                                NOT NULL REFERENCES `User` (UserID) ON UPDATE CASCADE ON DELETE CASCADE,
    JobID               INT                                NOT NULL REFERENCES JobListing (JobID) ON UPDATE CASCADE ON DELETE CASCADE,
    CompanyID           INT                                NOT NULL REFERENCES Company (CompanyID) ON UPDATE CASCADE ON DELETE CASCADE,
    Wage                INT                                NOT NULL,
    EmploymentStartDate DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    EmploymentEndDate   DATETIME,
    TerminationReason   VARCHAR(200)                       NOT NULL
);
CREATE TABLE IF NOT EXISTS Rating
(
    RatingID                    INT PRIMARY KEY AUTO_INCREMENT,
    OverallRating               INT          NOT NULL,
    Review                      VARCHAR(500) NOT NULL,
    WorkCultureRating           INT          NOT NULL,
    CompensationRating          INT          NOT NULL,
    WorkLifeBalanceRating       INT          NOT NULL,
    LearningOpportunitiesRating INT          NOT NULL,
    JobID                       INT REFERENCES JobListing (JobID) ON UPDATE CASCADE ON DELETE CASCADE,
    CompanyID                   INT REFERENCES Company (CompanyID) ON UPDATE CASCADE ON DELETE CASCADE,
    UserID                      INT          NOT NULL REFERENCES User (UserID) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Offer
(
    OfferID     INT PRIMARY KEY AUTO_INCREMENT,
    ApplicantID INT         NOT NULL REFERENCES Student (StudentID) ON UPDATE CASCADE ON DELETE CASCADE,
    JobID       INT         NOT NULL REFERENCES JobListing (JobID) ON UPDATE CASCADE ON DELETE CASCADE,
    Wage        INT         NOT NULL,
    StartDate   DATETIME    NOT NULL,
    EndDate     DATETIME,
    Status      VARCHAR(50) NOT NULL DEFAULT 'Pending'
);
CREATE TABLE IF NOT EXISTS ErrorLog
(
    LogID            INT PRIMARY KEY AUTO_INCREMENT,
    UserID           INT          NOT NULL REFERENCES `User` (UserID) ON UPDATE CASCADE ON DELETE CASCADE,
    ErrorDescription VARCHAR(500) NOT NULL,
    ErrorDate        DATETIME     NOT NULL
);
CREATE TABLE IF NOT EXISTS JobSkill
(
    JobSkillID INT PRIMARY KEY AUTO_INCREMENT,
    JobID      INT NOT NULL REFERENCES JobListing (JobID) ON UPDATE CASCADE ON DELETE CASCADE,
    SkillID    INT NOT NULL REFERENCES Skill (SkillID) ON UPDATE CASCADE ON DELETE CASCADE
);
