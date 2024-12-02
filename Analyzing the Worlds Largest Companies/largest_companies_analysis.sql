
/************************************* Cleaning and Transformation ******************************************/

--Converting Revenue and Profit columns to decimal and Employees to int.

--Removing unnecessary columns
ALTER TABLE dbo.wikipedia_export DROP COLUMN Ref#;
ALTER TABLE dbo.wikipedia_export DROP COLUMN "State-owned";

--Renaming Columns
EXEC sp_rename 'wikipedia_export.Headquarters(note 1)',  'Headquarters', 'COLUMN';
EXEC sp_rename 'wikipedia_export.Ram',  'Company', 'COLUMN';

/************************************* DML ********************************************************************/

--Top 5 Companies by Revenue
select top 5 company, revenue from wikipedia_export
order by revenue desc;

--Profit vs revenue 
SELECT 
    Company, 
    Revenue, 
    Profit
FROM 
    wikipedia_export;

--Percentage of company in each industry
SELECT 
    industry, 
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM wikipedia_export) AS DECIMAL(10,0)) AS percentage
FROM 
    wikipedia_export
GROUP BY 
    industry
ORDER BY 
    percentage DESC;

--Top 5 Companies by Profit Margin
SELECT top 5
    Company,
    --Profit,
    --Revenue,
    (Profit / Revenue) * 100 AS profit_marg_percent
FROM 
    wikipedia_export
ORDER BY 
    profit_marg_percent DESC;

--Percentage of company by headquarters
SELECT 
    headquarters, 
	--count(*),
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM wikipedia_export) AS DECIMAL(10, 2)) AS percentage
FROM 
    wikipedia_export
GROUP BY 
    headquarters
ORDER BY 
    percentage DESC;

--Revenue and profit grouped by industry or region.
SELECT 
	top 3
    sum(revenue) as revenue, industry
FROM 
    wikipedia_export
GROUP BY 
    industry
	order by sum(revenue) desc;

--All companies by revenue
select company, revenue from wikipedia_export
order by revenue desc;

--Top 10 Companies by Number of Employees
SELECT top 10 company, employees
FROM 
    wikipedia_export
order by employees desc;

--Profit per Employee by Industry
SELECT 
    Industry, 
    SUM(Profit) / SUM(Employees) AS ProfitPerEmployee
FROM 
    wikipedia_export
GROUP BY 
    Industry;

--Employee Distribution
SELECT 
    CASE 
        WHEN Employees <= 50000 THEN '0-50K'
        WHEN Employees <= 100000 THEN '50K-100K'
        WHEN Employees <= 250000 THEN '100K-250K'
        WHEN Employees <= 500000 THEN '250K-500K'
        WHEN Employees <= 750000 THEN '500K-750K'
        WHEN Employees <= 1000000 THEN '750K-1M'
        ELSE '>1M'
    END AS EmployeeRange,
    COUNT(*) AS CompanyCount
FROM 
    wikipedia_export
GROUP BY 
    CASE 
        WHEN Employees <= 50000 THEN '0-50K'
        WHEN Employees <= 100000 THEN '50K-100K'
        WHEN Employees <= 250000 THEN '100K-250K'
        WHEN Employees <= 500000 THEN '250K-500K'
        WHEN Employees <= 750000 THEN '500K-750K'
        WHEN Employees <= 1000000 THEN '750K-1M'
        ELSE '>1M'
    END;

--Workforce efficiency
SELECT 
    company, industry,
    AVG(Revenue / Employees) AS AvgRevenuePerEmployee,
    AVG(Profit / Employees) AS AvgProfitPerEmployee
FROM 
    wikipedia_export
GROUP BY 
    company, industry
	order by industry asc;

--Total profit and total revenue
SELECT 
    SUM(Revenue) AS TotalRevenue, 
    ROUND(SUM(Profit), 2) AS TotalProfit,
	SUM(employees) as TotalEmployees
FROM 
    wikipedia_export;