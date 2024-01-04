DROP DATABASE IF EXISTS DATABASE_BOOKS;
CREATE DATABASE IF NOT EXISTS DATABASE_BOOKS;
USE DATABASE_BOOKS;

CREATE TABLE Publishers (
    Publisher_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Publisher_Name VARCHAR(225) NOT NULL,
    Publisher_Country VARCHAR(225) NOT NULL,
    Publisher_Contact VARCHAR(225) NOT NULL
);


CREATE TABLE Authors (
    Author_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Author_Name VARCHAR(225) UNIQUE NOT NULL,
    Author_Gender CHAR(1) NOT NULL,
    Author_Age INT(20) NOT NULL,
    Author_Country VARCHAR(225) NOT NULL
);

CREATE TABLE Books (
    Book_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Book_Title VARCHAR(225) UNIQUE NOT NULL,
    Book_Genre VARCHAR(225) NOT NULL,
    Publication_Date DATE NOT NULL,
    Book_Pages INT(20) NOT NULL,
    Publisher_ID INT,
    Author_ID INT,
CONSTRAINT FOREIGN KEY (Publisher_ID) REFERENCES Publishers(Publisher_ID) ON UPDATE CASCADE ON DELETE NO ACTION, 
		FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID) ON UPDATE CASCADE
);

CREATE TABLE Users (
    User_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    User_Name VARCHAR(225) NOT NULL,
    User_Age INT(20) NOT NULL,
    User_Gender CHAR(1) NOT NULL,
    User_Email VARCHAR(225)
);


CREATE TABLE Ratings (
    Ratings_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Ratings_Received DECIMAL(10, 2) NOT NULL,
    Rating_Date DATE NOT NULL,
    User_ID INT,
    Book_ID INT,
CONSTRAINT FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON UPDATE CASCADE,
           FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Reviews (
    Review_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Review_Text TEXT,
    Book_ID INT,
    User_ID INT,
CONSTRAINT FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);


DELIMITER //
CREATE TRIGGER Insert_Reviews
AFTER INSERT ON Ratings
FOR EACH ROW
BEGIN
    INSERT INTO Reviews (Review_Text, Book_ID, User_ID)
    VALUES (NULL, NEW.Book_ID, NEW.User_ID);
END;
//
DELIMITER ;



INSERT INTO Publishers (Publisher_ID, Publisher_Name, Publisher_Country, Publisher_Contact)
VALUES
    (1, 'Penguin Random House', 'USA', '123-456-7890'),
    (2, 'Harper Collins', 'UK', '987-654-3210'),
    (3, 'Bloomsbury', 'India', '555-555-5555'),
    (4, 'Beacon Publishing', 'India', '111-111-1111'),
    (5, 'North Atlantic Books', 'USA', '222-222-2222');
    

INSERT INTO Authors (Author_ID, Author_Name, Author_Gender, Author_Age, Author_Country)
VALUES
    (1, 'Jane Austin', 'F', 40, 'Europe'),
    (2, 'Homer', 'M', 35, 'USA'),
    (3, 'Oscar Wilde', 'M', 50, 'UK'),
    (4, 'Walt Whitman', 'M', 45, 'USA'),
    (5, 'Albert Camus', 'M', 60, 'India'),
    (6, 'Thomas Hardy', 'F', 32, 'India'),
    (7, 'Toni Morrison', 'F', 28, 'Europe');


INSERT INTO Books (Book_ID, Book_Title, Book_Genre, Publication_Date, Book_Pages, Publisher_ID, Author_ID)
VALUES
    (1, 'The Quantum Paradox', 'Science Fiction', '2023-01-01', 300, 1, 1),
    (2, 'Midnight Shadows', 'Mystery', '2023-02-15', 250, 2, 2),
    (3, 'Eternal Love', 'Romance', '2023-03-30', 400, 3, 3),
    (4, 'Into the Unknown', 'Adventure', '2023-04-10', 350, 4, 4),
    (5, 'Dark Secrets', 'Thriller', '2023-05-20', 200, 5, 5),
    (6, 'The Forgotten Legacy', 'Historical Fiction', '2023-06-05', 280, 5, 3),
    (7, 'Echoes of War', 'Fantasy', '2023-07-15', 320, 4, 7),
    (8, 'Celestial Harmony', 'Science Fiction', '2023-08-25', 180, 3, 7),
    (9, 'Whispers in the Wind', 'Adventure', '2023-09-10', 240, 2, 3),
    (10, 'Crimson Nightmares', 'Horror', '2023-10-30', 310, 2, 1);


INSERT INTO Users (User_ID, User_Name, User_Age, User_Gender, User_Email)
VALUES
    (1, 'Dravid', 25, 'M', 'Dravss001@gmail.com'),
    (2, 'Nisthi Agarwal', 30, 'F', 'nishtiagarwal009@gmail.com'),
    (3, 'Dravid Frank', 22, 'M', 'dravidsfrankhouse@gmail.com'),
    (4, 'Smith Grace', 28, 'F', 'smithsayshi@gmail.com'),
    (5, 'Ross Smiss', 35, 'M', 'bookcallsme@gmail.com');
    
INSERT INTO Users (User_ID, User_Name, User_Age, User_Gender)
VALUES    
    (6, 'Ela Rose', 40, 'F'),
    (7, 'Dimitri', 26, 'M'),
    (8, 'Hasini Rani', 32, 'F');


INSERT INTO Ratings (Ratings_ID, Ratings_Received, Rating_Date, User_ID, Book_ID)
VALUES
    (1, 4.5, '2023-01-15', 1, 1),
    (2, 4.0, '2023-02-20', 2, 8),
    (3, 3.8, '2023-03-10', 3, 8),
    (4, 4.8, '2023-04-05', 4, 4),
    (5, 2.0 , '2023-05-15', 5, 4),
    (6, 4.0, '2023-06-25', 4, 5),
    (7, 5.0, '2023-07-10', 3, 5),
    (8, 4.9, '2023-08-30', 2, 7),
    (9, 3.5, '2023-09-20', 2, 6),
    (10, 4.8, '2023-10-10', 1, 7),
    (11, 4.7, '2023-10-10', 1, 2),
	(12, 5.0, '2023-10-10', 2, 10),
    (13, 3.5, '2023-10-10', 3, 9),
    (14, 2.8, '2023-10-10', 5, 3),
    (15, 4.7, '2023-10-10', 4, 2),
	(16, 5.0, '2023-10-10', 6, 6),
    (17, 4.0, '2023-10-10', 7, 1),
	(18, 3.8, '2023-10-10', 8, 3),
    (19, 3.7, '2023-10-10', 6, 2),
	(20, 5.0, '2023-10-10', 7, 9),
    (21, 4.7, '2023-10-10', 8, 1);
