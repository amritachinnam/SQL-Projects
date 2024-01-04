----- Reading all the tables ----
SELECT * FROM database_books.authors;
SELECT * FROM database_books.books;
SELECT * FROM database_books.publishers;
SELECT * FROM database_books.ratings;
SELECT * FROM database_books.reviews;
SELECT * FROM database_books.users;

UPDATE Reviews AS R
JOIN Ratings AS Ra ON R.Book_ID = Ra.Book_ID AND R.User_ID = Ra.User_ID
SET R.Review_Text =
    CASE
        WHEN Ra.Ratings_Received = 5.0 THEN 'THIS IS A MUST READ BOOK!!!'
        WHEN Ra.Ratings_Received >= 4.9 THEN 'Had to let go of my work to finish this book.'
        WHEN Ra.Ratings_Received >= 4.8 THEN 'Amazing read for sure.'
        WHEN Ra.Ratings_Received >= 4.5 THEN 'Good book, enjoyed it!'
        WHEN Ra.Ratings_Received >= 4.0 THEN 'Do try this book for a good read.'
        WHEN Ra.Ratings_Received >= 3.8 THEN 'TRY MORE FROM THIS AUTHOR FOR SURE!!'
        WHEN Ra.Ratings_Received >= 3.5 THEN 'Such a boring read, but here we go.'
        ELSE 'Not a great experience.'
    END;

SELECT * FROM database_books.reviews;

----- All the book titles with Authors ----
SELECT B.Book_Title, A.Author_Name
FROM Books AS B
JOIN Authors A ON B.Author_ID = A.Author_ID;

----- Average rating of books by users and the count of ratings ----
SELECT A.Author_ID, A.Author_Name, B.Book_Title, ROUND(AVG(R.Ratings_Received), 2) AS Average_Rating, COUNT(R.Ratings_ID) AS Rating_Count
FROM Authors AS A
JOIN Books AS B ON A.Author_ID = B.Author_ID
JOIN Ratings AS R ON B.Book_ID = R.Book_ID
GROUP BY A.Author_ID, A.Author_Name, B.Book_Title
ORDER BY Rating_Count DESC;

----- The number of books written by authors. ---
SELECT A.Author_ID, A.Author_Name, COUNT(B.Book_ID) AS Books_Written
FROM Authors AS A
LEFT JOIN Books AS B ON A.Author_ID = B.Author_ID
GROUP BY A.Author_ID, A.Author_Name
ORDER BY Books_Written DESC;

----- The number of author books read by authors. ---
SELECT A.Author_ID, A.Author_Name, COUNT(DISTINCT U.User_ID) AS Users_Reading
FROM Authors AS A
LEFT JOIN Books AS B ON A.Author_ID = B.Author_ID
LEFT JOIN Ratings AS R ON B.Book_ID = R.Book_ID
LEFT JOIN Users AS U ON R.User_ID = U.User_ID
GROUP BY A.Author_ID, A.Author_Name
ORDER BY Users_Reading DESC;

----- Books more than 300 pages realeased by a publisher with greatest reviews. ------
SELECT P.Publisher_ID, P.Publisher_Name, MAX(Ratings_Received) AS MaxRated, B.Book_Title AS MaxRatedBookTitle
FROM Publishers AS P
JOIN Books AS B ON P.Publisher_ID = B.Publisher_ID
LEFT JOIN Ratings AS R ON B.Book_ID = R.Book_ID
WHERE B.Book_Pages >= 300
GROUP BY P.Publisher_ID, P.Publisher_Name, MaxRatedBookTitle
ORDER BY MaxRated DESC;

----- List of all books sold by publishers in the order of highest ratings. -----
SELECT P.Publisher_ID, P.Publisher_Name, MAX(Ratings_Received) AS MaxRated, B.Book_Title AS MaxRatedBookTitle
FROM Publishers AS P
JOIN Books AS B ON P.Publisher_ID = B.Publisher_ID
LEFT JOIN Ratings AS R ON B.Book_ID = R.Book_ID
GROUP BY P.Publisher_ID, P.Publisher_Name, MaxRatedBookTitle
ORDER BY MaxRated DESC;

----- List of all publishers and the count of books published. -----
SELECT P.Publisher_ID, P.Publisher_Name, COUNT(B.Book_ID) AS BookCount
FROM Publishers AS P
JOIN Books AS B ON P.Publisher_ID = B.Publisher_ID
GROUP BY P.Publisher_ID, P.Publisher_Name
ORDER BY BookCount DESC;

----- Most to least read book count. ----
SELECT B.Book_Title, COUNT(R.User_ID) AS ReadCount
FROM Books AS B
LEFT JOIN Ratings AS R ON B.Book_ID = R.Book_ID
GROUP BY B.Book_Title
ORDER BY ReadCount DESC;

----- Highest review count book. ----
SELECT B.Book_ID, B.Book_Title, COUNT(R.Review_ID) AS ReviewCount, AVG(R2.Ratings_Received) AS AverageRating
FROM Books AS B
LEFT JOIN Reviews AS R ON B.Book_ID = R.Book_ID
LEFT JOIN Ratings AS R2 ON B.Book_ID = R2.Book_ID
GROUP BY B.Book_ID, B.Book_Title
ORDER BY ReviewCount DESC, AverageRating DESC
LIMIT 1;

----- Lowest review count book.----
SELECT B.Book_ID, B.Book_Title, COUNT(R.Review_ID) AS ReviewCount, AVG(R2.Ratings_Received) AS AverageRating
FROM Books AS B
LEFT JOIN Reviews AS R ON B.Book_ID = R.Book_ID
LEFT JOIN Ratings AS R2 ON B.Book_ID = R2.Book_ID
GROUP BY B.Book_ID, B.Book_Title
ORDER BY AverageRating ASC, ReviewCount DESC
LIMIT 1;

----- Ratings based on Genre. -----
SELECT B.Book_Genre, ROUND(AVG(R.Ratings_Received),2) AS AverageRating
FROM Books AS B
LEFT JOIN Ratings AS R ON B.Book_ID = R.Book_ID
GROUP BY B.Book_Genre
ORDER BY AverageRating DESC;

----- Books with highest reviewcount and average rating. -----
SELECT B.Book_ID, B.Book_Title, COUNT(R.Review_ID) AS ReviewCount, ROUND(AVG(R2.Ratings_Received),2) AS AverageRating
FROM Books AS B
LEFT JOIN Reviews AS R ON B.Book_ID = R.Book_ID
LEFT JOIN Ratings AS R2 ON B.Book_ID = R2.Book_ID
GROUP BY B.Book_ID, B.Book_Title
ORDER BY ReviewCount DESC, AverageRating DESC;

----- Latest Reviews of all books along with the user details. -----
SELECT R.Review_ID, R.Review_Text, B.Book_Title, U.User_Name, U.User_Age, U.User_Gender, RT.Ratings_Received
FROM Reviews AS R
JOIN Books AS B ON R.Book_ID = B.Book_ID
JOIN Users AS U ON R.User_ID = U.User_ID
JOIN Ratings AS RT ON R.User_ID = RT.User_ID AND R.Book_ID = RT.Book_ID
ORDER BY Book_Title DESC, Ratings_Received DESC
LIMIT 10;


----- Users who have given a rating above 4.5 for a book title. ----
SELECT DISTINCT U.User_ID, U.User_Name, B.Book_Genre, B.Book_Title
FROM Users AS U
JOIN Ratings AS R ON U.User_ID = R.User_ID
JOIN Books AS B ON R.Book_ID = B.Book_ID
WHERE R.Ratings_Received > 4.5;

----- Book suggestions for Users from the same genre with highest rating provided, excluding the already rated book title ---
SELECT 
    U.User_ID, 
    U.User_Name, 
    B1.Book_Genre AS ReadGenre, 
    B1.Book_Title AS PreviouslyReadBook,
    B2.Book_Title AS SuggestedBook,
    B2.Book_Genre AS SuggestedGenre
FROM Users AS U
JOIN Ratings AS R ON U.User_ID = R.User_ID
JOIN Books AS B1 ON R.Book_ID = B1.Book_ID
JOIN Books AS B2 ON B1.Book_Genre = B2.Book_Genre
WHERE R.Ratings_Received > 4.5
AND NOT EXISTS (SELECT 1 FROM Ratings AS R2 WHERE R2.User_ID = U.User_ID AND R2.Book_ID = B2.Book_ID)
    AND B1.Book_ID != B2.Book_ID
LIMIT 5;



