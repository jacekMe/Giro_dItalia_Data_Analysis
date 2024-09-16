-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema project_giro
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema project_giro
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `project_giro` ;
USE `project_giro` ;

-- -----------------------------------------------------
-- Table `project_giro`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Countries` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(40) NOT NULL,
  `country_code` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB
COMMENT = 'countries from which the riders come';


-- -----------------------------------------------------
-- Table `project_giro`.`Teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Teams` (
  `team_id` INT NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(60) NOT NULL,
  `team_country_id` INT NULL,
  `founding_date` DATE NULL,
  `completion_date` VARCHAR(45) NULL,
  PRIMARY KEY (`team_id`),
  INDEX `team_country_id_idx` (`team_country_id` ASC) VISIBLE,
  CONSTRAINT `team_country_id`
    FOREIGN KEY (`team_country_id`)
    REFERENCES `project_giro`.`Countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'the teams that took part in the Giro d\'Italia in the years 2000-2024';


-- -----------------------------------------------------
-- Table `project_giro`.`Specialities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Specialities` (
  `speciality_id` INT NOT NULL AUTO_INCREMENT,
  `speciality_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`speciality_id`))
ENGINE = InnoDB
COMMENT = 'stores a list of available specialties (e.g., \'sprinter\', \'climber\', \'time-trialist\')';


-- -----------------------------------------------------
-- Table `project_giro`.`Riders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Riders` (
  `rider_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `date_of_birth` DATE NULL,
  `height` DECIMAL(5,2) NULL,
  `country_of_origin` INT NULL,
  `team_id` INT NULL,
  `speciality_id` INT NULL,
  `national_champion` TINYINT NULL DEFAULT 0,
  PRIMARY KEY (`rider_id`),
  INDEX `country_of_origin_idx` (`country_of_origin` ASC) VISIBLE,
  INDEX `team_id_idx` (`team_id` ASC) VISIBLE,
  INDEX `speciality_id_idx` (`speciality_id` ASC) VISIBLE,
  CONSTRAINT `country_of_origin`
    FOREIGN KEY (`country_of_origin`)
    REFERENCES `project_giro`.`Countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `project_giro`.`Teams` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `speciality_id`
    FOREIGN KEY (`speciality_id`)
    REFERENCES `project_giro`.`Specialities` (`speciality_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'table with all the athletes participating in the Giro d\'Italia in the years 2000-2024';


-- -----------------------------------------------------
-- Table `project_giro`.`StartAndFinishCities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`StartAndFinishCities` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `start_city` VARCHAR(50) NOT NULL,
  `finish_city` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`city_id`))
ENGINE = InnoDB
COMMENT = 'a table storing the cities where the starts and finishes of the stages were held';


-- -----------------------------------------------------
-- Table `project_giro`.`Races`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Races` (
  `race_id` INT NOT NULL AUTO_INCREMENT,
  `year` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `number_of_stages` INT NOT NULL,
  `total_distance` DECIMAL(10,2) NOT NULL,
  `start_country_id` INT NULL,
  `finish_country_id` INT NULL,
  `start_city_id` INT NOT NULL,
  `finish_city_id` INT NOT NULL,
  `description` VARCHAR(200) NULL,
  PRIMARY KEY (`race_id`),
  INDEX `start_country_id_idx` (`start_country_id` ASC) VISIBLE,
  INDEX `finish_country_id_idx` (`finish_country_id` ASC) VISIBLE,
  INDEX `start_city_id_idx` (`start_city_id` ASC) VISIBLE,
  INDEX `finish_city_id_idx` (`finish_city_id` ASC) VISIBLE,
  CONSTRAINT `start_country_id`
    FOREIGN KEY (`start_country_id`)
    REFERENCES `project_giro`.`Countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `finish_country_id`
    FOREIGN KEY (`finish_country_id`)
    REFERENCES `project_giro`.`Countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `start_city_id`
    FOREIGN KEY (`start_city_id`)
    REFERENCES `project_giro`.`StartAndFinishCities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `finish_city_id`
    FOREIGN KEY (`finish_city_id`)
    REFERENCES `project_giro`.`StartAndFinishCities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table stores all the information about the race in each year';


-- -----------------------------------------------------
-- Table `project_giro`.`TeamsRiders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`TeamsRiders` (
  `team_rider_id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT NULL,
  `rider_id` INT NULL,
  `race_id` INT NULL,
  `role_team` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`team_rider_id`),
  INDEX `team_id_idx` (`team_id` ASC) VISIBLE,
  INDEX `rider_id_idx` (`rider_id` ASC) VISIBLE,
  INDEX `race_id_idx` (`race_id` ASC) VISIBLE,
  CONSTRAINT `team_id_tr`
    FOREIGN KEY (`team_id`)
    REFERENCES `project_giro`.`Teams` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `rider_id_tr`
    FOREIGN KEY (`rider_id`)
    REFERENCES `project_giro`.`Riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `race_id_tr`
    FOREIGN KEY (`race_id`)
    REFERENCES `project_giro`.`Races` (`race_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'a table linking players to teams in different year (since players can change teams)';


-- -----------------------------------------------------
-- Table `project_giro`.`StageTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`StageTypes` (
  `stage_type_id` INT NOT NULL AUTO_INCREMENT,
  `stage_type_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`stage_type_id`))
ENGINE = InnoDB
COMMENT = 'this table stores the possible types of stages';


-- -----------------------------------------------------
-- Table `project_giro`.`Stages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Stages` (
  `stage_id` INT NOT NULL AUTO_INCREMENT,
  `race_id` INT NULL,
  `stage_number` INT NOT NULL,
  `stage_date` DATE NOT NULL,
  `stage_type_id` INT NULL,
  `start_city_id` INT NULL,
  `finish_city_id` INT NULL,
  `distance` DECIMAL(10,2) NOT NULL,
  `elevation_gain` DECIMAL(10,2) NOT NULL,
  `stage_time_limit` TIME NULL,
  PRIMARY KEY (`stage_id`),
  INDEX `race_id_idx` (`race_id` ASC) VISIBLE,
  INDEX `stage_type_id_idx` (`stage_type_id` ASC) VISIBLE,
  INDEX `start_city_id_idx` (`start_city_id` ASC) VISIBLE,
  INDEX `finish_city_id_idx` (`finish_city_id` ASC) VISIBLE,
  CONSTRAINT `race_id_stage`
    FOREIGN KEY (`race_id`)
    REFERENCES `project_giro`.`Races` (`race_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `stage_type_id`
    FOREIGN KEY (`stage_type_id`)
    REFERENCES `project_giro`.`StageTypes` (`stage_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `start_city_id_stage`
    FOREIGN KEY (`start_city_id`)
    REFERENCES `project_giro`.`StartAndFinishCities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `finish_city_id_stage`
    FOREIGN KEY (`finish_city_id`)
    REFERENCES `project_giro`.`StartAndFinishCities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table is intended to store all the stages that have taken place in the Giro d\'Italia in the years 2000-2024';


-- -----------------------------------------------------
-- Table `project_giro`.`Classifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Classifications` (
  `classification_id` INT NOT NULL AUTO_INCREMENT,
  `classification_name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(150) NULL,
  `jersey_color` VARCHAR(15) NULL,
  PRIMARY KEY (`classification_id`))
ENGINE = InnoDB
COMMENT = 'this table is to store all possible classifications and shirt colors for them';


-- -----------------------------------------------------
-- Table `project_giro`.`StagesResults`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`StagesResults` (
  `stage_result_id` INT NOT NULL AUTO_INCREMENT,
  `rider_id` INT NULL,
  `stage_id` INT NULL,
  `classification_id` INT NULL,
  `position` INT NOT NULL,
  `time` TIME NOT NULL,
  `points` INT NULL,
  `status` ENUM('finished', 'abandoned', 'disqualified') NULL DEFAULT 'finished',
  PRIMARY KEY (`stage_result_id`),
  INDEX `rider_id_idx` (`rider_id` ASC) VISIBLE,
  INDEX `stage_id_idx` (`stage_id` ASC) VISIBLE,
  INDEX `classification_id_idx` (`classification_id` ASC) VISIBLE,
  CONSTRAINT `rider_id_sr`
    FOREIGN KEY (`rider_id`)
    REFERENCES `project_giro`.`Riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `stage_id_sr`
    FOREIGN KEY (`stage_id`)
    REFERENCES `project_giro`.`Stages` (`stage_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `classification_id_sr`
    FOREIGN KEY (`classification_id`)
    REFERENCES `project_giro`.`Classifications` (`classification_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table is designed to store the results of each competitor for each stage of the race';


-- -----------------------------------------------------
-- Table `project_giro`.`Sponsors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Sponsors` (
  `sponsor_id` INT NOT NULL AUTO_INCREMENT,
  `sponsor_name` VARCHAR(50) NOT NULL,
  `sponsor_country_id` INT NULL,
  `industry` VARCHAR(50) NULL,
  PRIMARY KEY (`sponsor_id`),
  INDEX `sponsor_country_id_idx` (`sponsor_country_id` ASC) VISIBLE,
  CONSTRAINT `sponsor_country_id`
    FOREIGN KEY (`sponsor_country_id`)
    REFERENCES `project_giro`.`Countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table is designed to store all the sponsors that were in the Giro d\'Italia in the years 2000-2024';


-- -----------------------------------------------------
-- Table `project_giro`.`Sponsorships`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`Sponsorships` (
  `sponsorship_id` INT NOT NULL AUTO_INCREMENT,
  `classification_id` INT NULL,
  `sponsor_id` INT NULL,
  `race_id` INT NULL,
  `amount` DECIMAL(10,2) NULL,
  `description` VARCHAR(200) NULL,
  PRIMARY KEY (`sponsorship_id`),
  INDEX `classification_id_idx` (`classification_id` ASC) VISIBLE,
  INDEX `sponsor_id_idx` (`sponsor_id` ASC) VISIBLE,
  INDEX `race_id_idx` (`race_id` ASC) VISIBLE,
  CONSTRAINT `classification_id_sponsor`
    FOREIGN KEY (`classification_id`)
    REFERENCES `project_giro`.`Classifications` (`classification_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sponsor_id`
    FOREIGN KEY (`sponsor_id`)
    REFERENCES `project_giro`.`Sponsors` (`sponsor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `race_id_sponsor`
    FOREIGN KEY (`race_id`)
    REFERENCES `project_giro`.`Races` (`race_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'the sponsorship table allows you to associate a particular sponsor with a specific classification in a specific race year';


-- -----------------------------------------------------
-- Table `project_giro`.`ClassificationCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`ClassificationCategories` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `classification_id` INT NULL,
  `category_name` VARCHAR(30) NOT NULL,
  `points_for_first_place` INT NULL,
  `points_for_second_place` INT NULL,
  `points_for_third_place` INT NULL,
  `points_for_fourth_place` INT NULL,
  `points_for_fifth_place` INT NULL,
  `points_for_sixth_place` INT NULL,
  `points_for_seventh_place` INT NULL,
  `points_for_eighth_place` INT NULL,
  `points_for_ninth_place` INT NULL,
  `points_for_tenth_place` INT NULL,
  `points_for_eleventh_place` INT NULL,
  `points_for_twelfth_place` INT NULL,
  `points_for_thirteenth_place` INT NULL,
  `points_for_fourteenth_place` INT NULL,
  `points_for_fifteenth_place` INT NULL,
  PRIMARY KEY (`category_id`),
  INDEX `classification_id_idx` (`classification_id` ASC) VISIBLE,
  CONSTRAINT `classification_id_cc`
    FOREIGN KEY (`classification_id`)
    REFERENCES `project_giro`.`Classifications` (`classification_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table stores information about the classification categories and the points allocated for each place according to the category';


-- -----------------------------------------------------
-- Table `project_giro`.`StageBonuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`StageBonuses` (
  `stage_bonus_id` INT NOT NULL AUTO_INCREMENT,
  `stage_id` INT NULL,
  `category_id` INT NULL,
  `location` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`stage_bonus_id`),
  INDEX `stage_id_idx` (`stage_id` ASC) VISIBLE,
  INDEX `category_id_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `stage_id_sb`
    FOREIGN KEY (`stage_id`)
    REFERENCES `project_giro`.`Stages` (`stage_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `category_id_sb`
    FOREIGN KEY (`category_id`)
    REFERENCES `project_giro`.`ClassificationCategories` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'it contains basic information about each bonus, including the bonus category (e.g., 1st category, 2nd category) and the number of places that are scored';


-- -----------------------------------------------------
-- Table `project_giro`.`BonusResults`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`BonusResults` (
  `bonus_result_id` INT NOT NULL AUTO_INCREMENT,
  `stage_bonus_id` INT NULL,
  `rider_id` INT NULL,
  `place` INT NOT NULL,
  `bonus_points` INT NULL,
  `bonus_time` TIME NULL,
  PRIMARY KEY (`bonus_result_id`),
  INDEX `stage_bonus_id_idx` (`stage_bonus_id` ASC) VISIBLE,
  INDEX `rider_id_idx` (`rider_id` ASC) VISIBLE,
  CONSTRAINT `stage_bonus_id`
    FOREIGN KEY (`stage_bonus_id`)
    REFERENCES `project_giro`.`StageBonuses` (`stage_bonus_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `rider_id_bonus`
    FOREIGN KEY (`rider_id`)
    REFERENCES `project_giro`.`Riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table stores the results of each competitor, taking into account the place occupied, the number of points awarded and the time bonus, if any';


-- -----------------------------------------------------
-- Table `project_giro`.`RaceClassification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `project_giro`.`RaceClassification` (
  `race_classification_id` INT NOT NULL AUTO_INCREMENT,
  `classification_id` INT NULL,
  `race_id` INT NULL,
  `rider_id` INT NULL,
  `points` INT NULL,
  `time` TIME NULL,
  `rank` INT NULL,
  `status_race_classification` ENUM('active', 'finished') NULL DEFAULT 'finished',
  PRIMARY KEY (`race_classification_id`),
  INDEX `classification_id_idx` (`classification_id` ASC) VISIBLE,
  INDEX `race_id_idx` (`race_id` ASC) VISIBLE,
  INDEX `rider_id_idx` (`rider_id` ASC) VISIBLE,
  CONSTRAINT `classification_id_rc`
    FOREIGN KEY (`classification_id`)
    REFERENCES `project_giro`.`Classifications` (`classification_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `race_id_rc`
    FOREIGN KEY (`race_id`)
    REFERENCES `project_giro`.`Races` (`race_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `rider_id_rc`
    FOREIGN KEY (`rider_id`)
    REFERENCES `project_giro`.`Riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'this table stores information and resulst of various classification during the race';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
