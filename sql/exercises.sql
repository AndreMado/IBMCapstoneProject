SELECT z.country as country, ca.category as category, sum(amount) as total_sales 
FROM public."FactSales" a JOIN  public."DimCategory" ca ON a.categoryid = ca.categoryid JOIN public."DimCountry" z ON a.countryid = z.countryid
GROUP BY GROUPING SETS (country,category)
ORDER BY country, category;

SELECT z.country as country, ca.year as "year", sum(amount) as total_sales 
FROM public."FactSales" a JOIN  public."DimDate" ca ON a.dateid = ca.dateid JOIN public."DimCountry" z ON a.countryid = z.countryid
GROUP BY ROLLUP (country, ca.year)
ORDER BY country, "year";

SELECT z.country as country, ca.year as "year", round(avg(amount),2) as total_sales 
FROM public."FactSales" a JOIN  public."DimDate" ca ON a.dateid = ca.dateid JOIN public."DimCountry" z ON a.countryid = z.countryid
GROUP BY CUBE (country, ca.year)
ORDER BY country, "year";

CREATE MATERIALIZED VIEW "total_sales_per_country" AS 
SELECT b.country as country, sum(a.amount) as total_sales 
FROM public."FactSales" a JOIN public."DimCountry" b ON a.countryid = b.countryid
GROUP BY country
ORDER BY total_sales;