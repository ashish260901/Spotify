# 🎧 Spotify SQL Analysis Project (PostgreSQL)

## 📖 Overview
This project explores Spotify music data using **PostgreSQL**.  
It focuses on analyzing artists, tracks, albums, and performance metrics such as **streams, likes, views, and energy levels**.  

The goal is to perform **Exploratory Data Analysis (EDA)** and generate **insightful SQL-based reports** across multiple complexity levels — Easy, Medium, and Advanced.

---

## 🧱 Database Setup

### Create Table

```sql
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
🔍 Basic Exploration (EDA)
sql
Copy code
SELECT * FROM spotify;

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify WHERE duration_min = 0;

DELETE FROM spotify WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;
📊 Data Analysis
🟢 Easy Level
1️⃣ Retrieve all tracks with more than 1 billion streams
sql
Copy code
SELECT track FROM spotify WHERE stream > 1000000000;
2️⃣ List all albums with their respective artists
sql
Copy code
SELECT DISTINCT album, artist FROM spotify ORDER BY artist, album;
3️⃣ Get total comments for licensed tracks
sql
Copy code
SELECT SUM(comments) AS total_comments FROM spotify WHERE licensed = TRUE;
4️⃣ Find all tracks where album type is 'single'
sql
Copy code
SELECT * FROM spotify WHERE album_type = 'single';
5️⃣ Count total number of tracks by each artist
sql
Copy code
SELECT artist, COUNT(track) AS total_tracks 
FROM spotify 
GROUP BY artist 
ORDER BY total_tracks DESC;
🟡 Medium Level
6️⃣ Calculate average danceability of tracks per album
sql
Copy code
SELECT 
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
7️⃣ Find top 5 tracks with the highest energy
sql
Copy code
SELECT 
    track,
    artist,
    energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;
8️⃣ List all tracks (views & likes) where official video = TRUE
sql
Copy code
SELECT 
    track,
    artist,
    views,
    likes
FROM spotify
WHERE official_video = TRUE
ORDER BY views DESC;
9️⃣ For each album, calculate total views of all tracks
sql
Copy code
SELECT 
    album,
    track,
    SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;
🔟 Retrieve tracks streamed more on Spotify than YouTube
sql
Copy code
SELECT * FROM (
    SELECT 
        track, 
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify,
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube
    FROM spotify
    GROUP BY 1
) AS t1
WHERE streamed_on_spotify > streamed_on_youtube AND streamed_on_youtube <> 0;
🔴 Advanced Level
11️⃣ Top 3 most-viewed tracks for each artist (Window Function)
sql
Copy code
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
12️⃣ Find tracks with liveness above average
sql
Copy code
SELECT 
    track,
    artist,
    album,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC;
13️⃣ Calculate energy difference (max-min) per album using WITH clause
sql
Copy code
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
🧠 Insights from the Project
Identify top-performing artists and most-streamed tracks.

Compare Spotify vs YouTube streaming dominance.

Evaluate track energy, danceability, and liveness.

Use window functions and CTEs for advanced analysis.

Clean and standardize music data for meaningful insights.

🧰 Tools & Technologies
Database: PostgreSQL

Language: SQL

Tools: DBeaver / pgAdmin / SQL Shell (psql)

Dataset: Spotify music dataset (CSV or imported file)

👩‍💻 Author
Geetha
📧 your_email@example.com
