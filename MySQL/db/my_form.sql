CREATE DATABASE IF NOT EXISTS my_form;

/*CREATE TABLE FOR THE FORM*/
USE my_form;
CREATE TABLE IF NOT EXISTS wp_terms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(255),
    name VARCHAR(255),
    taxonomy VARCHAR(255)
);

/*GRANT select PRIVILEGES TO USER test*/
GRANT SELECT ON my_form.* TO 'test'@'%';


/*CREATE ARRAY FOR AREA*/
START TRANSACTION;

INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term1', 'Term 1', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term2', 'Term 2', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term3', 'Term 3', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term4', 'Term 4', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term5', 'Term 5', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term6', 'Term 6', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term7', 'Term 7', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term8', 'Term 8', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term9', 'Term 9', 'area');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('term10', 'Term 10', 'area');

COMMIT;


/*CREATE ARRAY FOR WORK*/
START TRANSACTION;

INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work1', 'Work Type 1', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work2', 'Work Type 2', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work3', 'Work Type 3', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work4', 'Work Type 4', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work5', 'Work Type 5', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work6', 'Work Type 6', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work7', 'Work Type 7', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work8', 'Work Type 8', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work9', 'Work Type 9', 'work');
INSERT INTO wp_terms (slug, name, taxonomy) VALUES ('work10', 'Work Type 10', 'work');


COMMIT;
