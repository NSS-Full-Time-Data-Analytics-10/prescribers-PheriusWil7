SELECT COUNT(total_claim_count), prescriber.npi
FROM prescription
INNER JOIN prescriber
ON prescriber.npi = prescription.npi
GROUP BY prescriber.npi
ORDER BY count DESC;

--Q1B
SELECT COUNT(total_claim_count),prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name,prescriber.specialty_description,prescriber.npi
FROM prescription
INNER JOIN prescriber ON prescription.npi = prescriber.npi
GROUP BY prescriber.npi,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
ORDER BY count DESC

--Q2A
SELECT COUNT (total_claim_count),specialty_description
FROM prescription
INNER JOIN prescriber
ON prescription.npi = prescriber.npi
GROUP BY prescriber.specialty_description
ORDER BY count DESC;

--2B
SELECT COUNT (total_claim_count),specialty_description, drug.drug_name, opioid_drug_flag, long_acting_opioid_drug_flag
FROM prescription
INNER JOIN prescriber 
ON prescription.npi = prescriber.npi
INNER JOIN drug 
ON drug.drug_name = prescription.drug_name
GROUP BY prescriber.specialty_description, drug.drug_name, opioid_drug_flag, long_acting_opioid_drug_flag
ORDER BY count DESC;

--3A
SELECT generic_name, total_drug_cost
FROM drug
INNER JOIN prescription
ON drug.drug_name = prescription.drug_name
ORDER BY total_drug_cost DESC;
--PIRFENIDONE



--4A
SELECT drug_name, 
    CASE 
	WHEN opioid_drug_flag ='Y' THEN 'opioid' 
    WHEN antibiotic_drug_flag = 'Y' THEN 'anitibiotic'
	ELSE 'neither'
	END AS drug_type
FROM drug;

--4B
SELECT drug_name
	CASE
		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		ELSE 'neither'
	END AS drug_type	
FROM drug;

--5A
SELECT COUNT(DISTINCT cbsa),state
FROM cbsa
INNER JOIN fips_county
ON fips_county.fipscounty = cbsa.fipscounty
WHERE state ILIKE '%TN%'
GROUP BY cbsa.cbsa,state
--10

--5B
SELECT cbsa.cbsa,cbsa.cbsaname, SUM(population) AS total_population,cbsaname AS name
FROM cbsa
    INNER JOIN population
	USING(fipscounty)
GROUP BY cbsa.cbsa,cbsaname
ORDER BY cbsa DESC;
--smallest Davidson CO,Nashville--Murfreesboro,Rutherford--Franklin,TN
--largest Memphis, TN-MS-AR

--5C
(SELECT population.population,fips_county.county
 FROM population
 INNER JOIN fips_county
 USING(fipscounty))
 ORDER BY population DESC;
--SHELBY

--6A
SELECT drug_name,total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;

--6B
SELECT drug.drug_name,total_claim_count,
CASE
	    WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		ELSE 'Not opioid'
		END AS drug_type
FROM prescription
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE total_claim_count >= 3000;

--6C
SELECT drug_name,total_claim_count,prescriber.nppes_provider_last_org_name,prescriber.nppes_provider_first_name,
	CASE
	   WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
	   ELSE 'Not Opioid'
	   END AS drug_type
FROM prescription
INNER JOIN drug
USING(drug_name)
INNER JOIN prescriber
USING(npi)
WHERE total_claim_count >= 3000;

--7A
SELECT pr.specialty_description,dr.drug_name,pr.nppes_provider_city,pr.npi
FROM prescriber AS pr
CROSS JOIN drug AS dr
WHERE pr.nppes_provider_city = 'NASHVILLE' AND pr.specialty_description = 'Pain MANAGEMENT' AND dr.opioid_drug_flag = 'Y'

--7B
SELECT drug.drug_name,prescriber.npi,SUM(prescription.total_claim_count)
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription
USING (npi)
WHERE prescriber.nppes_provider_city = 'NASHVILLE' AND prescriber.specialty_description = 'Pain Management' AND drug.opioid_drug_flag = 'Y'
GROUP BY drug.drug_name,prescriber.npi
ORDER BY SUM(prescription.total_claim_count)DESC;

--7C
SELECT drug.drug_name,prescriber.npi,COALESCE(SUM(prescription.total_claim_count),0) AS RESULT
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription
USING(npi)
WHERE prescriber.nppes_provider_city = 'NASHVILLE' AND prescriber.specialty_description = 'Pain Management' AND drug.opioid_drug_flag = 'Y'
GROUP BY drug.drug_name,prescriber.npi
ORDER BY RESULT DESC;