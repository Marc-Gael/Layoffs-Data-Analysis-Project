SELECT *
FROM layoffs;

-- On va créer une autre table dans laquelle on pourra appliquer nos requêtes

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- maintenant, on peut nettoyer les données en suivant ces étapes :
-- 1. vérifier l'existence de doublons et les supprimer
-- 2. standardiser les données et fixer les erreurs
-- 3. Valeurs NULL ou EMPTY 
-- 4. Supprimer toute ligne ou colonne dispensable - plusieurs méthodes


-- 1. vérifier l'existence de doublons et les supprimer

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

WITH doublons AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM doublons
WHERE row_num > 1;


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

INSERT INTO `layoffs_staging2`
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging ;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1 ;

DELETE
FROM layoffs_staging2
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging2;


-- 2. standardiser les données et fixer les erreurs

		-- Supprimer les espaces entre les noms des compagnies
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2;

		-- Regrouper les noms d'industries qui doivent être ensemble
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; 


		-- Mettre les dates au bon format
SElECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


			-- Remplir les lignes vides dans la colonne `industry`
SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '' ;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL ;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;
