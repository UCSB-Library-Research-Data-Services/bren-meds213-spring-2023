-- Build a long and wide Bird_nests table, starting from the database
-- used as the running class example.  Run like so:
--
--     cp ../../week7/database.db db/database-long-wide.db
--     sqlite3 -init build-big-db.sql db/database-long-wide.db

DROP TABLE IF EXISTS Bird_eggs;
DROP TABLE IF EXISTS Bird_nests;

CREATE TABLE Bird_nests (
    Book_page TEXT NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site TEXT NOT NULL,
    Nest_ID TEXT PRIMARY KEY,
    Species TEXT NOT NULL,
    Observer TEXT NOT NULL,
    Date_found TEXT NOT NULL
        CHECK (Date_found BETWEEN Year||'-01-01' AND Year||'-12-31'),
    how_found TEXT NOT NULL
        CHECK (how_found IN ('searcher', 'rope', 'bander')),
    padding TEXT NOT NULL,
    Clutch_max INTEGER NOT NULL CHECK (Clutch_max BETWEEN 0 AND 20),
    floatAge_temp TEXT,
    ageMethod TEXT NOT NULL CHECK (ageMethod IN ('float', 'lay', 'hatch')),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Species) REFERENCES Species (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation)
);

.import --csv "|generate-rows db/database-long-wide.db 1000000" Bird_nests

UPDATE Bird_nests SET floatAge_temp = NULL WHERE floatAge_temp = '';
ALTER TABLE Bird_nests ADD COLUMN floatAge REAL DEFAULT NULL
    CHECK (floatAge BETWEEN 0 AND 30);
UPDATE Bird_nests SET floatAge = CAST(floatAge_temp AS REAL);
ALTER TABLE Bird_nests DROP COLUMN floatAge_temp;
