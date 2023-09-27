-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S3: Multiple Tables
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
--
-- Codeer je uitwerking onder de regel 'DROP VIEW ...' (bij een SELECT)
-- of boven de regel 'ON CONFLICT DO NOTHING;' (bij een INSERT)
-- Je kunt deze eigen query selecteren en los uitvoeren, en wijzigen tot
-- je tevreden bent.
--
-- Vervolgens kun je je uitwerkingen testen door de testregels
-- (met [TEST] erachter) te activeren (haal hiervoor de commentaartekens
-- weg) en vervolgens het hele bestand uit te voeren. Hiervoor moet je de
-- testsuite in de database hebben geladen (bedrijf_postgresql_test.sql).
-- NB: niet alle opdrachten hebben testregels.
--
-- Lever je werk pas in op Canvas als alle tests slagen.
-- ------------------------------------------------------------------------


-- S3.1.
-- Produceer een overzicht van alle cursusuitvoeringen; geef de
-- code, de begindatum, de lengte en de naam van de docent.
-- DROP VIEW IF EXISTS s3_1; CREATE OR REPLACE VIEW s3_1 AS                                                     -- [TEST]
SELECT code, begindatum, lengte, naam FROM cursussen
INNER JOIN public.uitvoeringen u on cursussen.code = u.cursus
INNER JOIN public.medewerkers m on m.mnr = u.docent;


-- S3.2.
-- Geef in twee kolommen naast elkaar de achternaam van elke cursist (`cursist`)
-- van alle S02-cursussen, met de achternaam van zijn cursusdocent (`docent`).
-- DROP VIEW IF EXISTS s3_2; CREATE OR REPLACE VIEW s3_2 AS                                                     -- [TEST]
SELECT m1.naam AS cursist, m2.naam AS docent
FROM medewerkers m1, medewerkers m2, uitvoeringen, inschrijvingen
WHERE inschrijvingen.cursus = 'S02' AND uitvoeringen.cursus = 'S02'
AND inschrijvingen.cursist = m1.mnr AND uitvoeringen.docent = m2.mnr
AND inschrijvingen.begindatum = uitvoeringen.begindatum;

-- S3.3.
-- Geef elke afdeling (`afdeling`) met de naam van het hoofd van die
-- afdeling (`hoofd`).
-- DROP VIEW IF EXISTS s3_3; CREATE OR REPLACE VIEW s3_3 AS                                                     -- [TEST]
SELECT afdelingen.naam, medewerkers.naam FROM afdelingen
INNER JOIN medewerkers on afdelingen.hoofd = medewerkers.mnr;

-- S3.4.
-- Geef de namen van alle medewerkers, de naam van hun afdeling (`afdeling`)
-- en de bijbehorende locatie.
-- DROP VIEW IF EXISTS s3_4; CREATE OR REPLACE VIEW s3_4 AS                                                     -- [TEST]
SELECT medewerkers.naam, afdelingen.naam, afdelingen.locatie FROM medewerkers
INNER JOIN afdelingen on medewerkers.afd = afdelingen.anr;

-- S3.5.
-- Geef de namen van alle cursisten die staan ingeschreven voor de cursus S02 van 12 april 2019
-- DROP VIEW IF EXISTS s3_5; CREATE OR REPLACE VIEW s3_5 AS                                                     -- [TEST]
SELECT medewerkers.naam FROM medewerkers
INNER JOIN inschrijvingen on inschrijvingen.cursist = medewerkers.mnr
WHERE cursus = 'S02' and begindatum = '2019-04-12';

-- S3.6.
-- Geef de namen van alle medewerkers en hun toelage.
-- DROP VIEW IF EXISTS s3_6; CREATE OR REPLACE VIEW s3_6 AS                                                     -- [TEST]
SELECT medewerkers.naam, schalen.toelage FROM medewerkers, schalen
WHERE medewerkers.maandsal BETWEEN schalen.ondergrens AND schalen.bovengrens;


-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

SELECT * FROM test_select('S3.1') AS resultaat
UNION
SELECT * FROM test_select('S3.2') AS resultaat
UNION
SELECT * FROM test_select('S3.3') AS resultaat
UNION
SELECT * FROM test_select('S3.4') AS resultaat
UNION
SELECT * FROM test_select('S3.5') AS resultaat
UNION
SELECT * FROM test_select('S3.6') AS resultaat
ORDER BY resultaat;
