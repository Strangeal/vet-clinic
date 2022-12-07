/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon"
SELECT * FROM animals WHERE name LIKE '%mon'
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
SELECT name FROM animals WHERE neutered IS true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE NOT name = 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- QUERY AND UPDATE TABLE
-- Transaction 1
BEGIN; 
UPDATE animals SET species = 'unspecified';
ROLLBACK;

-- Transaction 2
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE name NOT LIKE '%mon';
COMMIT;

-- Transaction 3
-- Delete from table in a transaction
BEGIN;
DELETE FROM animals;
ROLLBACK;

-- Transaction 4
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- Answer Queries
SELECT COUNT(*) AS total_animal_count FROM animals;
SELECT * FROM animals WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01' GROUP BY species;


-- Join queries
-- all animals owned by Melody Pond
SELECT *
FROM owners
JOIN animals
ON  animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- all animals that are of type pokemon
SELECT *
FROM animals
JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- all owners and their animals
SELECT * FROM Owners
FULL OUTER JOIN animals
ON owners.id = animals.owner_id;

-- many animals are there per species
SELECT species.name, COUNT(*)
FROM species
JOIN  animals
ON animals.species_id = species.id
GROUP BY species.name;

-- all Digimon owned by Jennifer Orwell
SELECT *
FROM animals
JOIN owners
ON owners.id = animals.owner_id
JOIN species
ON species.id = animals.species_id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

--  all animals owned by Dean Winchester that haven't tried to escape
SELECT *
FROM animals
JOIN owners
ON animals.owner_id = owners.id
WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

-- owns the most animals
SELECT owners.full_name, COUNT(*)
FROM animals
JOIN owners
ON animals.owner_id = owners.id
GROUP BY owners.full_name ORDER BY COUNT DESC LIMIT 1;