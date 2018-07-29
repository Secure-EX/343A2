SET SEARCH_PATH TO parlgov;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
century VARCHAR(2),
country VARCHAR(50), 
left_right REAL, 
state_market REAL, 
liberty_authority REAL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- get all of the winning parties based on the cabinet
CREATE VIEW election_winners AS
    SELECT election.id AS election_id, cabinet_party.party_id AS party_id
    FROM election
    	JOIN cabinet
            ON election.id = cabinet.election_id
        JOIN cabinet_party
            ON cabinet.id = cabinet_party.cabinet_id
    WHERE cabinet_party.pm = true;

-- get all the twentieth_century election date, century range, elction id and party id
CREATE VIEW twentieth_century AS
	SELECT e_date, '20' AS centuries, election.id AS election_id, cabinet_party.party_id AS party_id
	FROM election
		JOIN election_winners
			ON election.id = election_id
	WHERE (e_date NOT LIKE'1901%' AND (LIKE '19%' OR e_date LIKE'2000%'))
;

-- get all the twenty_first_century election date, century range, elction id and party id
CREATE VIEW twenty_first_century AS
	SELECT e_date, '21' AS centuries, election.id AS election_id, cabinet_party.party_id AS party_id
	FROM election
		JOIN election_winners
			ON election.id = election_id
	WHERE (e_date NOT LIKE'2000%' AND LIKE '20%')
;

-- union both election date table together
CREATE VIEW all_e_date AS
	(SELECT *
	FROM twentieth_century)
	UNION
	(SELECT *
	FROM twenty_first_century)
;

-- get winner country name
CREATE VIEW country_name AS
	SELECT country.name AS cname, party.id AS party_id
	FROM election_winners
		JOIN party
			ON party.id = election_winners.party_id
		JOIN country
			ON party.country_id = country.id
;

-- the answer to the query 
CREATE VIEW answer AS
	SELECT centuries AS century,
	cname AS country,
	avg(left_right) AS left_right,
	avg(state_market) AS state_market,
	avg(liberty_authority) AS liberty_authority
	FROM all_e_date
		JOIN country_name
			ON all_e_date.party_id = country_name.party_id
		JOIN party_position
			ON all_e_date.party_id = party_position.party_id
	GROUP BY century, country
;

insert into q1 select * from answer;

