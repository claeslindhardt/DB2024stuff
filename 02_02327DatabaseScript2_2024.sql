-- Creating the database
CREATE DATABASE IF NOT EXISTS dka;
USE dka;

-- Creating the tables
CREATE TABLE Newspaper (
    NewspaperID INT PRIMARY KEY, -- Consider using an appropriate primary key 
    Title VARCHAR(255) NOT NULL,
    FoundingDate DATE,
    Periodicity INT -- Number of days between editions
);

CREATE TABLE Journalist (
    CPR INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    StreetName VARCHAR(255),
    CivicNumber VARCHAR(255),
    City VARCHAR(255),
    ZIPcode VARCHAR(255),
    Country VARCHAR(255)
);

-- Add Telephone and Email for Journalist (multiple entries per journalist)
CREATE TABLE JournalistContact (
    ContactID INT PRIMARY KEY AUTO_INCREMENT,
    CPR INT,
    ContactType ENUM('Telephone', 'Email'),
    ContactValue VARCHAR(255),
    FOREIGN KEY (CPR) REFERENCES Journalist(CPR)
);

CREATE TABLE Edition (
    EditionID INT PRIMARY KEY, -- Consider using an appropriate primary key
    NewspaperID INT,
    PublicationDate DATE,
    EditorCPR INT,
    FOREIGN KEY (NewspaperID) REFERENCES Newspaper(NewspaperID),
    FOREIGN KEY (EditorCPR) REFERENCES Journalist(CPR)
);

CREATE TABLE Article (
    ArticleID INT PRIMARY KEY, -- Consider using an appropriate primary key
    EditionID INT,
    Title VARCHAR(255) NOT NULL,
    ArticleText TEXT,
    Topic VARCHAR(255),
    Reads INT DEFAULT 0,
    FOREIGN KEY (EditionID) REFERENCES Edition(EditionID)
);

CREATE TABLE Photo (
    PhotoID INT PRIMARY KEY, -- Consider using an appropriate primary key
    Title VARCHAR(255),
    ShootingDate DATE,
    ReporterCPR INT,
    FOREIGN KEY (ReporterCPR) REFERENCES Journalist(CPR)
);

-- Table to link articles and photos
CREATE TABLE ArticlePhoto (
    ArticleID INT,
    PhotoID INT,
    PRIMARY KEY (ArticleID, PhotoID), -- Composite primary key
    FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID),
    FOREIGN KEY (PhotoID) REFERENCES Photo(PhotoID)
);

-- Table to link articles and writers with roles
CREATE TABLE ArticleWriter (
    ArticleID INT,
    JournalistCPR INT,
    Role VARCHAR(255),
    PRIMARY KEY (ArticleID, JournalistCPR), -- Composite primary key
    FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID),
    FOREIGN KEY (JournalistCPR) REFERENCES Journalist(CPR)
);

-- Populating tables with data (example)
INSERT INTO Newspaper (NewspaperID, Title, FoundingDate, Periodicity) VALUES
(1, 'DKA Daily', '2000-01-01', 1),
(2, 'DKA Weekly', '2005-06-15', 7);

-- Add your data for Journalists, Editions, Articles, Photos, ArticlePhoto, and ArticleWriter

-- SQL Table Modifications (example)
UPDATE Article
SET Reads = Reads + 1
WHERE ArticleID = 1;

DELETE FROM Photo
WHERE PhotoID = 5;

-- SQL Data Queries (example)
-- For each topic, the most read news article.
SELECT Topic, MAX(Reads) AS MaxReads
FROM Article
GROUP BY Topic;

-- Add the remaining queries as per the requirements

-- SQL Programming (example)
-- Function to calculate the age of a newspaper
DELIMITER //
CREATE FUNCTION NewspaperAge (foundingDate DATE)
RETURNS INT
BEGIN
    DECLARE age INT;
    SELECT YEAR(CURDATE()) - YEAR(foundingDate) INTO age;
    RETURN age;
END //
DELIMITER ;

-- Example usage of the function
SELECT Title, NewspaperAge(FoundingDate) AS Age
FROM Newspaper;

-- Add procedures and triggers as per the requirements
