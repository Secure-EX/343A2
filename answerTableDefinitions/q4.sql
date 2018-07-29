SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
country VARCHAR(50),
num_elections INT,
num_repeat_party INT,
num_repeat_pm INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- get all of the winning parties based on the cabinet
CREATE VIEW election_winners AS
    SELECT election.id AS election_id, cabinet_party.party_id
    FROM election
    	JOIN cabinet
            ON election.id = cabinet.election_id
        JOIN cabinet_party
            ON cabinet.id = cabinet_party.cabinet_id
    WHERE cabinet_party.pm = true;


-- the answer to the query 
INSERT INTO q4 

