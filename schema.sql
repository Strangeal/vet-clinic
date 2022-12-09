/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(30),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
);

ALTER TABLE animals ADD species VARCHAR(50);


-- Owners table
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    age INT
);

-- Species table
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
);

-- Modify animals table:
ALTER TABLE animals ADD PRIMARY KEY(id);
ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT, ADD FOREIGN KEY(species_id) REFERENCES species;
ALTER TABLE animals ADD owner_id INT, ADD FOREIGN KEY(owner_id) REFERENCES owners;


-- many to many relationship
-- Vet table
CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY(id)
);

-- specializations table
CREATE TABLE specializations (
    id INT GENERATED ALWAYS AS IDENTITY,
    vets_id INT,
    species_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY(vets_id) REFERENCES vets,
    FOREIGN KEY(species_id) REFERENCES species
);

-- visits table
CREATE TABLE visits (
    id INT GENERATED ALWAYS AS IDENTITY,
    animals_id INT,
    vets_id INT,
    date_of_visit DATE,
    PRIMARY KEY(id),
    FOREIGN KEY(animals_id) REFERENCES animals,
    FOREIGN KEY(vets_id) REFERENCES vets
);


