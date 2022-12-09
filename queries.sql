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


-- many to many relationship queries
-- last animal seen by William Tatcher
SELECT vets.name, animals.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets.name = 'William Tatcher'
ORDER BY date_of_visit DESC LIMIT 1;

-- different animals did Stephanie Mendez see
SELECT vets.name, COUNT(visits.date_of_visit)
FROM visits
JOIN vets
ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- all vets and their specialties, including vets with no specialties
SELECT vets.name, specializations.species_id, specializations.vets_id, species.name  
FROM specializations
FULL OUTER JOIN species
ON species.id = specializations.species_id
FULL OUTER JOIN vets
ON vets.id = specializations.vets_id;

-- all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, vets.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- animal has the most visits to vets
SELECT animals.name, COUNT(visits.date_of_visit)
FROM animals
JOIN visits
ON animals.id = visits.animals_id
GROUP BY animals.name
ORDER BY COUNT DESC LIMIT 1;

-- Maisy Smith's first visit?
SELECT vets.name, animals.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit
SELECT animals.id, animals.name, animals.date_of_birth, vets.id, vets.age, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
ORDER BY visits.date_of_visit DESC;

-- Number of visits with a vet that did not specialize in that animal's species
SELECT vets.name, COUNT(*)
FROM visits
JOIN vets
ON vets.id = visits.vets_id
JOIN specializations
ON specializations.vets_id = visits.vets_id
WHERE specializations.species_id IS NULL
GROUP BY vets.name;

-- specialty Maisy Smith should consider getting?
SELECT vets.name, species.name, COUNT(species.name)
FROM visits
LEFT JOIN animals
ON animals.id = visits.animals_id
JOIN vets 
ON vets.id = visits.vets_id
JOIN species
ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY vets.name, species.name
ORDER BY COUNT DESC LIMIT 1;