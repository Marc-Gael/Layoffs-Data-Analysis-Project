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
SELECT year, SUM(layoffs) AS total_layoffs 
FROM layoffs_data 
GROUP BY year 
ORDER BY year ASC;
```

### Top 5 des entreprises avec le plus de licenciements
```sql
SELECT company, SUM(layoffs) AS total_layoffs 
FROM layoffs_data 
GROUP BY company 
ORDER BY total_layoffs DESC 
LIMIT 5;
```

### Répartition des licenciements par secteur d'industrie
```sql
SELECT industry, SUM(layoffs) AS total_layoffs 
FROM layoffs_data 
GROUP BY industry 
ORDER BY total_layoffs DESC;
```

### Identification des doublons
```sql
SELECT *, COUNT(*) 
FROM layoffs_data 
GROUP BY company, year, industry, layoffs 
HAVING COUNT(*) > 1;
```


## Technologies utilisées
- **SQL** : Manipulation et analyse des données.
- **MySQL** : Système de gestion de bases de données utilisé pour stocker et interroger les données.

## Contributions
Les contributions sont les bienvenues ! N'hésitez pas à proposer des améliorations ou à ajouter des analyses supplémentaires via des pull requests.

## Contact
Si vous avez des questions ou souhaitez en savoir plus, vous pouvez me contacter sur [LinkedIn](https://www.linkedin.com) ou ouvrir une issue sur ce dépôt.

