-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Jun 16 01:57:34 2019
-- 

;
BEGIN TRANSACTION;
--
-- Table: dataset
--
CREATE TABLE dataset (
  file_id INTEGER PRIMARY KEY NOT NULL,
  file text NOT NULL,
  transaction_date timestamp DEFAULT current_timestamp
);
--
-- Table: datasheet
--
CREATE TABLE datasheet (
  sheet_id INTEGER PRIMARY KEY NOT NULL,
  file_id integer NOT NULL,
  sheet_indx integer NOT NULL,
  sheet_name text NOT NULL,
  FOREIGN KEY (file_id) REFERENCES dataset(file_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX datasheet_idx_file_id ON datasheet (file_id);
CREATE UNIQUE INDEX file_id_sheet_indx_unique ON datasheet (file_id, sheet_indx);
--
-- Table: data
--
CREATE TABLE data (
  data_id INTEGER PRIMARY KEY NOT NULL,
  file_id integer NOT NULL,
  sheet_id integer NOT NULL,
  row_indx integer NOT NULL,
  name text NOT NULL,
  age integer NOT NULL,
  utf text NOT NULL,
  FOREIGN KEY (file_id) REFERENCES dataset(file_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (sheet_id) REFERENCES datasheet(sheet_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX data_idx_file_id ON data (file_id);
CREATE INDEX data_idx_sheet_id ON data (sheet_id);
CREATE UNIQUE INDEX file_id_sheet_id_row_indx_unique ON data (file_id, sheet_id, row_indx);
COMMIT;
