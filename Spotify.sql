CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from Spotify;

------
-- EDA
------
SELECT COUNT(*) FROM Spotify;

SELECT COUNT(DISTINCT artist) FROM Spotify;

SELECT COUNT(DISTINCT album) FROM Spotify;

SELECT DISTINCT album_type FROM Spotify;

SELECT MAX(duration_min) FROM Spotify;

SELECT MIN(duration_min) FROM Spotify;

SELECT * FROM Spotify WHERE duration_min = 0;

DELETE FROM Spotify WHERE duration_min = 0;

SELECT DISTINCT channel FROM Spotify;

SELECT DISTINCT most_played_on FROM Spotify;

--------------------------------
-- Data Analysis - Easy Category
--------------------------------
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track FROM spotify WHERE stream > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT DISTINCT album, artist FROM spotify ORDER BY artist, album;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) As total_comments FROM Spotify WHERE  licensed= TRUE;

-- 4. Find all tracks that belong to the album type single.
SELECT * FROM Spotify WHERE  album_type = 'single';

-- 5. Count the total number of tracks by each artist.
SELECT artist, COUNT(track) AS total_tracks FROM spotify GROUP BY artist ORDER BY total_tracks DESC;

---------------
-- Medium Level
---------------
-- 6. Calculate the average danceability of tracks in each album.
SELECT 
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT 
    track,
    artist,
    energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 8 .List all tracks along with their views and likes where official_video = TRUE.
SELECT 
    track,
    artist,
    views,
    likes
FROM spotify
WHERE official_video = TRUE
ORDER BY views DESC;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT 
    album,
    track,
    SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM 
(SELECT 
     track, 
	 COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify,
	 COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube
FROM Spotify
GROUP BY 1) AS t1
WHERE streamed_on_spotify > streamed_on_youtube AND streamed_on_youtube <> 0;

-----------------
-- Advanced Level
-----------------
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT artist, track, views
FROM (
    SELECT 
        artist,
        track,
        views,
        RANK() OVER (PARTITION BY artist ORDER BY views DESC) AS rank
    FROM spotify
) ranked
WHERE rank <= 3
ORDER BY artist, views DESC;

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT 
    track,
    artist,
    album,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC;

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH energy_stats AS (
    SELECT 
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT 
    album,
    (max_energy - min_energy) AS energy_difference
FROM energy_stats
ORDER BY energy_difference DESC;

