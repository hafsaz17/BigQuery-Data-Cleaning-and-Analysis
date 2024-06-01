-- Calculate the average score of movies (rounded to two decimal places)
SELECT 
ROUND(AVG(score), 2) AS average_score
FROM 
centering-sweep-399611.movies_data.imdb_movies;

-- Count number of movies by genre
SELECT 
genre,
COUNT(*) AS movie_count
FROM 
centering-sweep-399611.movies_data.imdb_movies
WHERE 
genre IS NOT NULL
GROUP BY genre;

-- Calculate percentage of budget spent for each movie
SELECT 
names,
budget_x,
revenue,
(revenue / budget_x) * 100 AS percentage_spent
FROM 
centering-sweep-399611.movies_data.imdb_movies;

-- Find top 10 movies by revenue
SELECT 
names, revenue
FROM 
centering-sweep-399611.movies_data.imdb_movies
ORDER BY revenue DESC
LIMIT 10;

-- Calculate average revenue by release year
SELECT 
EXTRACT(YEAR FROM date_x) AS release_year,
AVG(revenue) AS average_revenue
FROM 
centering-sweep-399611.movies_data.imdb_movies
GROUP BY release_year
ORDER BY release_year;

-- Find country with most movie credits
SELECT 
country, 
COUNT(*) AS movie_count
FROM 
centering-sweep-399611.movies_data.imdb_movies
GROUP BY country
ORDER BY movie_count DESC
LIMIT 1;

-- Calculate the average score of movies using a CTE
WITH movie_scores AS (
    SELECT score
    FROM centering-sweep-399611.movies_data.imdb_movies
)
SELECT AVG(score) AS average_score
FROM movie_scores;

-- Create a view to calculate total budget and revenue by genre
CREATE VIEW movies_data.genre_budget_revenue AS (
    WITH genre_summary AS (
        SELECT genre,
               SUM(budget_x) AS total_budget,
               SUM(revenue) AS total_revenue
        FROM centering-sweep-399611.movies_data.imdb_movies
        GROUP BY genre
    )
    SELECT genre, total_budget, total_revenue
    FROM genre_summary
);

-- Query the view to get total budget and revenue by genre
SELECT *
FROM movies_data.genre_budget_revenue;