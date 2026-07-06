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