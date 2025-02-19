# Layoffs Data Analysis Project

## Introduction
Ce projet vise à analyser les licenciements dans différentes entreprises à l'aide de données structurées et de scripts SQL. L'objectif est de nettoyer, structurer et explorer les données pour en tirer des insights pertinents.

## Contenu du dépôt

### 1. `layoffs.csv`
Ce fichier contient un jeu de données sur les licenciements dans diverses entreprises. Il inclut des informations telles que l'année, l'entreprise, l'industrie et d'autres détails pertinents.

### 2. `MySQL_Project_Data_Cleaning.sql`
Ce script SQL permet de nettoyer les données en supprimant les incohérences, en normalisant les valeurs et en structurant les informations pour faciliter leur analyse.

### 3. `MySQL_Project_Exploratory_Data_Analysis.sql`
Ce script SQL réalise une analyse exploratoire des données pour identifier des tendances et extraire des insights sur les licenciements.

## Instructions d'utilisation

1. **Importer le jeu de données** :
   - Charger `layoffs.csv` dans une base de données MySQL.
2. **Exécuter le script de nettoyage** :
   - Lancer `MySQL_Project_Data_Cleaning.sql` pour préparer les données.
3. **Réaliser l'analyse exploratoire** :
   - Exécuter `MySQL_Project_Exploratory_Data_Analysis.sql` pour obtenir des insights.

## Requêtes SQL pertinentes
Voici quelques requêtes clés utilisées dans ce projet :

### Retrouver des doublons
```sql
CREATE TABLE `layoffs_staging2` (
	company text,
	location text,
	industry text,
	total_laid_off int,
	percentage_laid_off text,
	`date` text,
	stage text,
	country text,
	funds_raised_millions int,
	row_num INT
);
```

```sql
INSERT INTO `layoffs_staging2`
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging ;
```

### Supprimer des doublons
```sql
SELECT *
FROM layoffs_staging2
WHERE row_num > 1 ;
```
```sql
DELETE
FROM layoffs_staging2
WHERE row_num > 1 ;
```

### Total des licenciements par année
```sql
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_year
FROM Rolling_Total;
```

### Top 5 des entreprises avec le plus de licenciements
```sql
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <=5;
```

### Répartition des licenciements par secteur d'industrie
```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
```

## Technologies utilisées
- **SQL** : Manipulation et analyse des données.
- **MySQL Workbench** : Système de gestion de bases de données utilisé pour stocker et interroger les données.

## Contributions
Les contributions sont les bienvenues ! N'hésitez pas à proposer des améliorations ou à ajouter des analyses supplémentaires via des pull requests.

## Contact
Si vous avez des questions ou souhaitez en savoir plus, vous pouvez me contacter sur [LinkedIn](www.linkedin.com/in/marc-gaël-zeme) ou ouvrir une issue sur ce dépôt.

