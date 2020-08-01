-- MySQL dump 10.17  Distrib 10.3.17-MariaDB, for debian-linux-gnueabihf (armv7l)
--
-- Host: localhost    Database: monday
-- ------------------------------------------------------
-- Server version	10.3.17-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AccessHistory`
--

DROP TABLE IF EXISTS `AccessHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccessHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `lastAccess` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_AccessHistory_User1_idx` (`userId`),
  CONSTRAINT `fk_AccessHistory_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=950 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccessHistory`
--

LOCK TABLES `AccessHistory` WRITE;
/*!40000 ALTER TABLE `AccessHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `AccessHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Action`
--

DROP TABLE IF EXISTS `Action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Action` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deviceId` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `command` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT 'Can be:\n- on\n- off\n- up\n- down\n- n (number in seconds)',
  PRIMARY KEY (`id`),
  KEY `fk_Action_Device1_idx` (`deviceId`),
  CONSTRAINT `fk_Action_Device1` FOREIGN KEY (`deviceId`) REFERENCES `Device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=466 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Action`
--

LOCK TABLES `Action` WRITE;
/*!40000 ALTER TABLE `Action` DISABLE KEYS */;
/*!40000 ALTER TABLE `Action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Client`
--

DROP TABLE IF EXISTS `Client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientId` varchar(255) COLLATE utf8_bin NOT NULL,
  `userId` int(11) NOT NULL,
  `firebaseToken` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sessionToken` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `sessionTimeout` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Client_User1_idx` (`userId`),
  CONSTRAINT `fk_Client_User1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Client`
--

LOCK TABLES `Client` WRITE;
/*!40000 ALTER TABLE `Client` DISABLE KEYS */;
/*!40000 ALTER TABLE `Client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Device`
--

DROP TABLE IF EXISTS `Device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Device` (
  `id` varchar(20) COLLATE utf8_bin NOT NULL,
  `name` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT '1 = light\\n2 = outlet\\n3 = climate\\n4 = shade\\n5 = climate sensor\\n6 = alarm sensor',
  `roomId` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT 'Can be 0 (offline) or 1 (online)',
  `enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Set to 0 if device has not been configured yet (you can find it in new devices).\\nSet to 1 otherwise.',
  `ip` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Device_Room1_idx` (`roomId`),
  CONSTRAINT `fk_Device_Room1` FOREIGN KEY (`roomId`) REFERENCES `Room` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Device`
--

LOCK TABLES `Device` WRITE;
/*!40000 ALTER TABLE `Device` DISABLE KEYS */;
INSERT INTO `Device` VALUES ('000000000000','Timer','timer','clock',NULL,1,1,NULL);
/*!40000 ALTER TABLE `Device` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`md`@`%`*/ /*!50003 TRIGGER `monday`.`Device_AFTER_UPDATE`
AFTER UPDATE ON `monday`.`Device`
FOR EACH ROW
BEGIN
	IF !(NEW.enabled <=> OLD.enabled) THEN
		IF (NEW.type) = 'climate' THEN
			INSERT INTO `Heater` (`id`, `switch`, `setTemperature`, `enabled`) values (NEW.id, 0, 20, 0);
		ELSEIF (NEW.type) = 'light' THEN
			INSERT INTO `Light` (`id`, `switch`) values (NEW.id, 0);
		ELSEIF (NEW.type) = 'outlet' THEN
			INSERT INTO `Outlet` (`id`, `switch`) values (NEW.id, 0);
		ELSEIF (NEW.type) = 'shutter' THEN
			INSERT INTO `Shutter` (`id`, `openingLevel`) values (NEW.id, 0);
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`md`@`%`*/ /*!50003 TRIGGER `monday`.`Device_BEFORE_DELETE`
BEFORE DELETE ON `monday`.`Device`
FOR EACH ROW
BEGIN
	IF (OLD.type) = 'climate' THEN
		DELETE FROM `Heater` WHERE id = OLD.id;
	ELSEIF (OLD.type) = 'light' THEN
		DELETE FROM `Light` WHERE id = OLD.id;
        DELETE FROM `Measure` WHERE id = OLD.id;
	ELSEIF (OLD.type) = 'outlet' THEN
		DELETE FROM `Outlet` WHERE id = OLD.id;
        DELETE FROM `Measure` WHERE id = OLD.id;
	ELSEIF (OLD.type) = 'shutter' THEN
		DELETE FROM `Shutter` WHERE id = OLD.id;
        DELETE FROM `Measure` WHERE id = OLD.id;
	ELSEIF (OLD.type) = 'climate sensor' THEN
		DELETE FROM `Measure` WHERE id = OLD.id;
        DELETE FROM `ClimateSensor` WHERE id = OLD.id;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Heater`
--

DROP TABLE IF EXISTS `Heater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Heater` (
  `id` varchar(20) COLLATE utf8_bin NOT NULL,
  `switch` tinyint(4) NOT NULL DEFAULT 0,
  `setTemperature` int(11) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Heater_Device1` FOREIGN KEY (`id`) REFERENCES `Device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Heater`
--

LOCK TABLES `Heater` WRITE;
/*!40000 ALTER TABLE `Heater` DISABLE KEYS */;
/*!40000 ALTER TABLE `Heater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Light`
--

DROP TABLE IF EXISTS `Light`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Light` (
  `id` varchar(20) COLLATE utf8_bin NOT NULL,
  `switch` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Can be 0 (OFF) or 1 (ON)',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Light_Device1` FOREIGN KEY (`id`) REFERENCES `Device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Light`
--

LOCK TABLES `Light` WRITE;
/*!40000 ALTER TABLE `Light` DISABLE KEYS */;
/*!40000 ALTER TABLE `Light` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Measure`
--

DROP TABLE IF EXISTS `Measure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Measure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deviceId` varchar(20) COLLATE utf8_bin NOT NULL,
  `date` datetime NOT NULL,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT 'Can be:\\n\\n- clima\\n- consumi\\n- qa (qualità aria)',
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`,`deviceId`),
  KEY `fk_Measure_Device1_idx` (`deviceId`),
  KEY `Secondary` (`type`),
  CONSTRAINT `fk_Measure_Device1` FOREIGN KEY (`deviceId`) REFERENCES `Device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=352022 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Measure`
--

LOCK TABLES `Measure` WRITE;
/*!40000 ALTER TABLE `Measure` DISABLE KEYS */;
/*!40000 ALTER TABLE `Measure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MeasureCondition`
--

DROP TABLE IF EXISTS `MeasureCondition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MeasureCondition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `operator` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MeasureCondition`
--

LOCK TABLES `MeasureCondition` WRITE;
/*!40000 ALTER TABLE `MeasureCondition` DISABLE KEYS */;
/*!40000 ALTER TABLE `MeasureCondition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MeasureDailyAVG`
--

DROP TABLE IF EXISTS `MeasureDailyAVG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MeasureDailyAVG` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deviceId` varchar(20) COLLATE utf8_bin NOT NULL,
  `date` datetime NOT NULL,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT 'Can be:\\n\\n- clima\\n- consumi\\n- qa (qualità aria)',
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`,`deviceId`),
  KEY `fk_MeasureDailyAVG_Device1_idx` (`deviceId`),
  CONSTRAINT `fk_MeasureDailyAVG_Device10` FOREIGN KEY (`deviceId`) REFERENCES `Device` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=388 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MeasureDailyAVG`
--

LOCK TABLES `MeasureDailyAVG` WRITE;
/*!40000 ALTER TABLE `MeasureDailyAVG` DISABLE KEYS */;
/*!40000 ALTER TABLE `MeasureDailyAVG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MeasureHourlyAVG`
--

DROP TABLE IF EXISTS `MeasureHourlyAVG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MeasureHourlyAVG` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deviceId` varchar(20) COLLATE utf8_bin NOT NULL,
  `date` datetime NOT NULL,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT 'Can be:\\n\\n- clima\\n- consumi\\n- qa (qualità aria)',
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`,`deviceId`),
  KEY `fk_MeasureHourlyAVG_Device1_idx` (`deviceId`),
  CONSTRAINT `fk_MeasureHourlyAVG_Device1` FOREIGN KEY (`deviceId`) REFERENCES `Device` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9161 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MeasureHourlyAVG`
--

LOCK TABLES `MeasureHourlyAVG` WRITE;
/*!40000 ALTER TABLE `MeasureHourlyAVG` DISABLE KEYS */;
/*!40000 ALTER TABLE `MeasureHourlyAVG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notification`
--

DROP TABLE IF EXISTS `Notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) COLLATE utf8_bin NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2009 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notification`
--

LOCK TABLES `Notification` WRITE;
/*!40000 ALTER TABLE `Notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Outlet`
--

DROP TABLE IF EXISTS `Outlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Outlet` (
  `id` varchar(20) COLLATE utf8_bin NOT NULL,
  `switch` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Can be 0 (OFF) or 1 (ON)',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Outlet_Device10` FOREIGN KEY (`id`) REFERENCES `Device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Outlet`
--

LOCK TABLES `Outlet` WRITE;
/*!40000 ALTER TABLE `Outlet` DISABLE KEYS */;
/*!40000 ALTER TABLE `Outlet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Room`
--

DROP TABLE IF EXISTS `Room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `imgPath` varchar(135) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Room`
--

LOCK TABLES `Room` WRITE;
/*!40000 ALTER TABLE `Room` DISABLE KEYS */;
/*!40000 ALTER TABLE `Room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Scene`
--

DROP TABLE IF EXISTS `Scene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Scene` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `enabled` smallint(6) DEFAULT NULL,
  `running` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Scene`
--

LOCK TABLES `Scene` WRITE;
/*!40000 ALTER TABLE `Scene` DISABLE KEYS */;
/*!40000 ALTER TABLE `Scene` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SceneHasAction`
--

DROP TABLE IF EXISTS `SceneHasAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SceneHasAction` (
  `sceneId` int(11) NOT NULL,
  `actionId` int(11) NOT NULL,
  PRIMARY KEY (`sceneId`,`actionId`),
  KEY `fk_Scene_has_Action_Action1_idx` (`actionId`),
  KEY `fk_Scene_has_Action_Scene1_idx` (`sceneId`),
  CONSTRAINT `fk_Scene_has_Action_Action1` FOREIGN KEY (`actionId`) REFERENCES `Action` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scene_has_Action_Scene1` FOREIGN KEY (`sceneId`) REFERENCES `Scene` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SceneHasAction`
--

LOCK TABLES `SceneHasAction` WRITE;
/*!40000 ALTER TABLE `SceneHasAction` DISABLE KEYS */;
/*!40000 ALTER TABLE `SceneHasAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SceneHasMeasureCondition`
--

DROP TABLE IF EXISTS `SceneHasMeasureCondition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SceneHasMeasureCondition` (
  `sceneId` int(11) NOT NULL,
  `measureConditionId` int(11) NOT NULL,
  PRIMARY KEY (`sceneId`,`measureConditionId`),
  KEY `fk_Scene_has_MeasureCondition_MeasureCondition1_idx` (`measureConditionId`),
  KEY `fk_Scene_has_MeasureCondition_Scene1_idx` (`sceneId`),
  CONSTRAINT `fk_Scene_has_MeasureCondition_MeasureCondition1` FOREIGN KEY (`measureConditionId`) REFERENCES `MeasureCondition` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scene_has_MeasureCondition_Scene1` FOREIGN KEY (`sceneId`) REFERENCES `Scene` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SceneHasMeasureCondition`
--

LOCK TABLES `SceneHasMeasureCondition` WRITE;
/*!40000 ALTER TABLE `SceneHasMeasureCondition` DISABLE KEYS */;
/*!40000 ALTER TABLE `SceneHasMeasureCondition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Shutter`
--

DROP TABLE IF EXISTS `Shutter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Shutter` (
  `id` varchar(20) COLLATE utf8_bin NOT NULL,
  `openingLevel` int(11) NOT NULL COMMENT 'The time set for opening and closing the shutter. It allows to bring the shutter at different levels while opening and closing the shutter.',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Shutter_Device1` FOREIGN KEY (`id`) REFERENCES `Device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Shutter`
--

LOCK TABLES `Shutter` WRITE;
/*!40000 ALTER TABLE `Shutter` DISABLE KEYS */;
/*!40000 ALTER TABLE `Shutter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TimeCondition`
--

DROP TABLE IF EXISTS `TimeCondition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TimeCondition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hour` int(11) DEFAULT NULL,
  `minute` int(11) DEFAULT NULL,
  `months` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `days` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `periodic` tinyint(4) DEFAULT NULL,
  `sceneId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_TimeCondition_Scene1_idx` (`sceneId`),
  CONSTRAINT `fk_TimeCondition_Scene1` FOREIGN KEY (`sceneId`) REFERENCES `Scene` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TimeCondition`
--

LOCK TABLES `TimeCondition` WRITE;
/*!40000 ALTER TABLE `TimeCondition` DISABLE KEYS */;
/*!40000 ALTER TABLE `TimeCondition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `enabled` tinyint(4) DEFAULT NULL,
  `currentAccess` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`md`@`%`*/ /*!50003 TRIGGER `monday`.`User_BEFORE_UPDATE`
BEFORE UPDATE ON `monday`.`User`
FOR EACH ROW
BEGIN
	IF NEW.currentAccess <> OLD.currentAccess THEN
		INSERT INTO AccessHistory (userId, lastAccess)
		VALUES (OLD.id, OLD.currentAccess);
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-06 14:43:17
