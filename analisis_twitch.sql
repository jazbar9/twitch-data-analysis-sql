- =====================================================================
-- 🧠 RESPUESTAS A LAS PREGUNTAS CLAVE DEL PROYECTO (CODÉDEX CHALLENGES)
-- =====================================================================

-- 0. Conociendo la DB 
SELECT *
FROM streamers2021
LIMIT 10;

SELECT *
FROM streamers2024
LIMIT 5;

--Limpieza
DELETE FROM streamers2024 WHERE `rank` = 0;

-- 1. ¿Cuántas personas en promedio vieron a estos streamers en 2021?
SELECT AVG(average_viewers)
FROM streamers2021;

-- 2. ¿Quiénes fueron los streamers con mayor crecimiento (hottest rising) en 2021?
-- (Medido por la mayor cantidad de seguidores ganados)

SELECT channel, MAX(followers_gained)
FROM streamers2021 
GROUP BY channel
ORDER BY MAX(followers_gained) DESC
LIMIT 5;

-- 3. ¿Cuáles son los juegos más populares en 2024?
-- (Medido por la cantidad de streamers top que lo transmiten)
SELECT DISTINCT most_streamed_game 
FROM streamers2024
ORDER BY most_streamed_game DESC;

SELECT most_streamed_game, COUNT(*) AS number_of_streamers
FROM streamers2024
GROUP BY most_streamed_game
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 4. ¿Dónde están ubicados los espectadores de League of Legends en 2024?
-- (Identificamos los idiomas principales de los streamers que juegan LoL)

SELECT language, COUNT(*) AS streamers_lol, SUM(total_followers) AS total_followers
FROM streamers2024
WHERE most_streamed_game LIKE  '%League of Legends%'
GROUP BY language
ORDER BY streamers_lol DESC;

-- 5. ¿Cuál es el mejor día para streamear en 2024?
-- (Analizamos qué día de la semana tiene el promedio más alto de seguidores ganados)

SELECT day_with_most_followers_gained, COUNT(*)
FROM streamers2024
GROUP BY day_with_most_followers_gained
ORDER BY COUNT(*) DESC;


SELECT most_active_day, ROUND(AVG(followers_gained_per_stream), 0) AS promedio_seguidores_ganados
FROM streamers2024
WHERE most_active_day IS NOT NULL AND most_active_day != ''
GROUP BY most_active_day
ORDER BY promedio_seguidores_ganados DESC;

--Aqui analizamos mejor el mejor día para streaming
SELECT day_with_most_followers_gained AS Dia, 
       COUNT(*) AS Cantidad_Streamers_Con_Pico,
       ROUND(AVG(followers_gained_per_stream), 0) AS Promedio_Seguidores_Por_Stream
FROM streamers2024
WHERE day_with_most_followers_gained IS NOT NULL AND day_with_most_followers_gained != ''
GROUP BY day_with_most_followers_gained
ORDER BY Cantidad_Streamers_Con_Pico DESC;


-------------------
--Fase 2: Análisis Avanzado (CTEs & Window Functions)
-- 🚀 a) CTE: Segmentación Optimizada por Duración Real de Transmisión (2024)
--Auditoria de nuestros datos en average_stream_duration
SELECT DISTINCT average_stream_duration
FROM streamers2024;

WITH SegmentacionStreamers AS (
    SELECT name, language, most_streamed_game, average_stream_duration, total_followers,
           CASE 
               WHEN average_stream_duration >= 12 THEN 'Maratónico Extremo (+12 hrs)'
               WHEN average_stream_duration >= 6 THEN 'Sesión Larga (6-12 hrs)'
               ELSE 'Estándar/Corta (-6 hrs)'
           END AS tipo_duracion
    FROM streamers2024
    WHERE name IS NOT NULL AND name != ''
)
-- Analizamos el impacto real luego de la auditoria 
SELECT tipo_duracion, 
       COUNT(*) AS cantidad_streamers,
       ROUND(AVG(total_followers), 0) AS promedio_seguidores_totales
FROM SegmentacionStreamers
GROUP BY tipo_duracion
ORDER BY promedio_seguidores_totales DESC;

-- 👑 WINDOW FUNCTION: Top 3 Streamers con más seguidores por cada Idioma (2024)
WITH RankingPorIdioma AS (
    SELECT name, language, total_followers, most_streamed_game,
           DENSE_RANK() OVER(PARTITION BY language ORDER BY total_followers DESC) AS posicion_en_idioma
    FROM streamers2024
    WHERE language IS NOT NULL AND language != '' AND name != ''
)
SELECT language AS Idioma, 
       posicion_en_idioma AS Top, 
       name AS Streamer, 
       total_followers AS Seguidores_Totales,
       most_streamed_game AS Juego_Principal
FROM RankingPorIdioma
WHERE posicion_en_idioma <= 3
ORDER BY language, posicion_en_idioma;


-- 👑b) WINDOW FUNCTION: Top 3 Streamers con más seguidores por cada Idioma (2024)
WITH RankingPorIdioma AS (
    SELECT name, language, total_followers, most_streamed_game,
           DENSE_RANK() OVER(PARTITION BY language ORDER BY total_followers DESC) AS posicion_en_idioma
    FROM streamers2024
    WHERE language IS NOT NULL AND language != '' AND name != ''
)
SELECT language AS Idioma, 
       posicion_en_idioma AS Top, 
       name AS Streamer, 
       total_followers AS Seguidores_Totales,
       most_streamed_game AS Juego_Principal
FROM RankingPorIdioma
WHERE posicion_en_idioma <= 3
ORDER BY language, posicion_en_idioma
LIMIT 5;



--EXPORTAR DATOS DEL CALENDARIO (DIAS) EN CSV PARA TABLEAU
USE twitch_analysis;

SELECT 'Dia', 'Cantidad_Streamers_Con_Pico', 'Promedio_Seguidores_Por_Stream'
UNION ALL
SELECT day_with_most_followers_gained, 
       CAST(COUNT(*) AS CHAR),
       CAST(ROUND(AVG(followers_gained_per_stream), 0) AS CHAR)
FROM streamers2024
WHERE day_with_most_followers_gained IS NOT NULL AND day_with_most_followers_gained != ''
GROUP BY day_with_most_followers_gained
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datos_calendario.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

--EXPORTAR IDIOMAS EN CSV PARA TABLEAU
SELECT 'Idioma', 'Total_Streamers'
UNION ALL
SELECT language, CAST(COUNT(*) AS CHAR)
FROM streamers2024
WHERE language IS NOT NULL AND language != ''
GROUP BY language
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/datos_idiomas.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';