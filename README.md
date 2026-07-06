# 📊 Análisis Avanzado de Streamers en Twitch (2021 vs. 2024)

## 📌 1. Descripción del Proyecto
Este proyecto de analítica de datos profundiza en el comportamiento, métricas de audiencia y evolución del ecosistema de Twitch utilizando bases de datos relacionales de los top 1,000 streamers en dos periodos clave: **2021** (auge post-pandemia) y **2024** (estabilización del mercado). 

**Caso de Negocio:** El objetivo es simular un rol de consultor de datos para una agencia de marketing digital. El análisis busca identificar qué perfiles de streamers, idiomas y categorías de contenido generan el mayor engagement y retorno de inversión (ROI) para campañas de patrocinio de marcas.


---

## 🛠️ 2. Stack Tecnológico
* **Motor de Base de Datos:** MySQL Server 8.0
* **Entorno de Desarrollo:** Visual Studio Code (Extension: Database Client)
* **Lenguaje:** SQL (Consultas de agregación, uniones relacionales y análisis temporal)

---

## 🔍 3. Estructura de la Base de Datos (`twitch_analysis`)
El proyecto cuenta con dos tablas normalizadas con orígenes de datos de Codédex y Kaggle:
* `streamers2021`: Enfocada en métricas de visualización puras (1,000 filas).
* `streamers2024`: Incluye métricas de rendimiento por transmisión y desglose de juegos (1,000 filas).

---

## 💻 4. Consultas Clave y Análisis de Datos

### A) Distribución de Audiencia por Idioma (2021)
Identificación de los mercados lingüísticos más masivos para segmentación geográfica de campañas.
```sql
SELECT language, 
       COUNT(*) AS total_streamers, 
       ROUND(AVG(average_viewers), 0) AS audiencia_promedio
FROM streamers2021
GROUP BY language
ORDER BY total_streamers DESC
LIMIT 5;
```

### B) Optimización Multivariable de Calendario (Volumen vs. Rendimiento)
Esta consulta estratégica cruza el volumen total de picos de crecimiento contra la eficiencia neta de conversión por transmisión para determinar el mejor día de streaming.
```sql
SELECT day_with_most_followers_gained AS Dia, 
       COUNT(*) AS Cantidad_Streamers_Con_Pico,
       ROUND(AVG(followers_gained_per_stream), 0) AS Promedio_Seguidores_Por_Stream
FROM streamers2024
WHERE day_with_most_followers_gained IS NOT NULL AND day_with_most_followers_gained != ''
GROUP BY day_with_most_followers_gained
ORDER BY Cantidad_Streamers_Con_Pico DESC;
```

### C) Resolución de Preguntas de Negocio (Codédex Core)
Para profundizar en las tácticas de contenido y entender el comportamiento de la plataforma, se resolvieron las preguntas analíticas clave del proyecto utilizando funciones de agregación:

* **Métrica Base:** En 2021, el promedio global de espectadores por streamer fue de `[4781.0400]` personas simultáneas por transmisión.
* **Optimización de Calendario:** Existe una dualidad para el "mejor día". El **Domingo** lidera en volumen (358 de los 1,000 streamers logran su pico ahí), mientras que el **Viernes** lidera en eficiencia, alcanzando un rendimiento promedio de 3,524 seguidores ganados por transmisión.
* **Análisis de Nicho (League of Legends):** Los espectadores de este videojuego se concentran principalmente en los canales de idioma `[English]`.
---


### 🗓️ Optimización de Calendario: ¿Cuál es el mejor día para streamear en 2024?
Al combinar las funciones de agregación `COUNT(*)` y `AVG()`, se descubrió una discrepancia clave entre el **volumen** y el **rendimiento**:

1. **Domingo (Máximo Volumen):** Es el día más popular, donde **358 de los 1,000 streamers** top experimentan su mayor pico de crecimiento. Es el día ideal para eventos masivos de comunidades consolidadas.
2. **Viernes (Máxima Eficiencia):** Presenta el promedio más alto de conversión con **3,524 seguidores ganados por transmisión**. 

**Recomendación de Negocio:** Para marcas con presupuestos limitados que buscan maximizar el retorno de inversión (ROI) a través de nuevos seguidores, se aconseja pautar patrocinios los **Viernes**, ya que la audiencia muestra una mayor predisposición a descubrir e interactuar con nuevos canales, enfrentando además una menor saturación de streamers compitiendo en vivo.



## 💡 5. Conclusiones y Recomendaciones Estratégicas (Insights)
*(Nota: Aquí agregarás los números exactos que te arrojaron tus consultas en la terminal)*

1. **Dominio de Idiomas:** El mercado angloparlante e hispanohablante concentran la mayor cantidad de creadores top, sugiriendo concentrar los presupuestos de marketing en estas regiones.
2. **Estrategia de Calendario:** 
   * *Domingo (Máximo Volumen):* Es el día más popular, donde **358 de los 1,000 streamers** top experimentan su mayor pico de crecimiento. Es el día ideal para eventos masivos de comunidades consolidadas.
   * *Viernes (Máxima Eficiencia):* Presenta el promedio más alto de conversión con **3,524 seguidores ganados por transmisión**.
   * *Recomendación:* Para marcas con presupuestos limitados que buscan maximizar el retorno de inversión (ROI) a través de nuevos seguidores, se aconseja pautar patrocinios los **Viernes**, ya que la audiencia muestra una mayor predisposición a descubrir nuevos canales.
3. **Filtro de Contenido:** El análisis de contenido maduro (`mature`) revela si las marcas con políticas familiares estrictas sufren una penalización de alcance al evitar canales clasificados +18.
