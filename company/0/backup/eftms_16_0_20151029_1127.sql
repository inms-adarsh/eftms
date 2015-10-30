# MySQL dump of database 'eftms_16' on host 'localhost'
# Backup Date and Time: 2015-10-29 11:27
# Built by Confret TMS 2.3.19
# http://frontaccounting.com
# Company: admin
# User: Administrator



### Structure of table `0_accident_data` ###

DROP TABLE IF EXISTS `0_accident_data`;

CREATE TABLE `0_accident_data` (
  `accident_id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_id` int(11) NOT NULL,
  `accident_reading` int(50) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `date` date NOT NULL,
  `odometer_id` varchar(11) NOT NULL,
  `accident_description` varchar(200) NOT NULL,
  PRIMARY KEY (`accident_id`,`vehicle_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_accident_data` ###


### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES
('1', 'Global', '0');

### Structure of table `0_attachments` ###

DROP TABLE IF EXISTS `0_attachments`;

CREATE TABLE `0_attachments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `type_no` int(11) NOT NULL DEFAULT '0',
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `unique_name` varchar(60) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `filename` varchar(60) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `filetype` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_attachments` ###


### Structure of table `0_audit_trail` ###

DROP TABLE IF EXISTS `0_audit_trail`;

CREATE TABLE `0_audit_trail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `user` smallint(6) unsigned NOT NULL DEFAULT '0',
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` varchar(60) DEFAULT NULL,
  `fiscal_year` int(11) NOT NULL,
  `gl_date` date NOT NULL DEFAULT '0000-00-00',
  `gl_seq` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=latin1 ;

### Data of table `0_audit_trail` ###

INSERT INTO `0_audit_trail` VALUES
('1', '33', '1', '1', '2015-05-24 22:26:39', NULL, '7', '2014-12-27', NULL),
('2', '33', '2', '1', '2015-05-24 22:37:44', NULL, '7', '2014-12-30', NULL),
('3', '33', '3', '1', '2015-05-24 22:44:43', NULL, '7', '2014-12-30', NULL),
('4', '32', '1', '1', '2014-12-30 08:11:25', NULL, '7', '2014-12-30', '0'),
('5', '30', '1', '1', '2015-07-19 21:28:30', NULL, '7', '2014-12-30', NULL),
('6', '13', '1', '1', '2014-12-30 08:13:31', NULL, '7', '2014-12-30', '0'),
('7', '10', '1', '1', '2015-05-12 19:15:42', NULL, '7', '2014-12-30', '4'),
('8', '12', '1', '1', '2015-05-12 19:15:42', NULL, '7', '2014-12-30', '5'),
('9', '30', '2', '1', '2015-03-23 05:58:25', NULL, '7', '2014-12-30', NULL),
('10', '33', '4', '3', '2015-05-24 23:13:37', NULL, '7', '2014-12-31', NULL),
('11', '33', '5', '1', '2015-05-24 23:13:40', NULL, '7', '2014-12-31', NULL),
('12', '32', '2', '1', '2015-01-02 15:03:46', NULL, '7', '2015-01-02', '0'),
('13', '33', '6', '1', '2015-05-24 23:15:22', NULL, '7', '2015-01-01', NULL),
('14', '32', '3', '1', '2015-01-04 05:13:38', NULL, '7', '2015-01-04', '0'),
('15', '32', '4', '1', '2015-01-04 06:03:45', NULL, '7', '2015-01-04', '0'),
('16', '30', '3', '1', '2015-07-22 22:31:04', NULL, '7', '2014-01-06', NULL),
('17', '33', '0', '3', '2015-07-11 14:58:57', 'Deleted.', '7', '2015-01-06', NULL),
('18', '33', '7', '3', '2015-07-03 14:43:07', NULL, '7', '2015-01-07', NULL),
('19', '32', '5', '3', '2015-01-07 01:43:56', NULL, '7', '2015-01-07', '0'),
('20', '33', '8', '3', '2015-07-03 14:44:32', NULL, '7', '2015-01-26', NULL),
('21', '33', '9', '1', '2015-07-03 14:45:12', NULL, '7', '2014-12-31', NULL),
('22', '32', '6', '1', '2015-02-10 02:07:51', NULL, '7', '2015-02-10', '0'),
('23', '30', '4', '1', '2015-07-22 22:31:35', NULL, '7', '2014-02-10', NULL),
('24', '13', '2', '1', '2015-02-10 02:12:06', NULL, '7', '2014-02-10', '0'),
('25', '12', '2', '3', '2015-05-12 19:15:42', NULL, '7', '2014-12-31', '6'),
('26', '33', '10', '3', '2015-07-03 14:46:10', NULL, '7', '2014-12-31', NULL),
('27', '32', '7', '3', '2015-03-16 02:13:08', NULL, '7', '2015-03-16', '0'),
('28', '33', '11', '1', '2015-07-03 15:58:20', NULL, '7', '2014-12-31', NULL),
('29', '32', '8', '1', '2015-03-20 09:31:59', NULL, '7', '2015-03-20', '0'),
('30', '30', '5', '1', '2015-07-23 22:19:28', NULL, '7', '2014-03-20', NULL),
('31', '13', '3', '1', '2015-03-20 09:33:24', NULL, '7', '2014-03-20', '0'),
('32', '10', '2', '1', '2015-05-12 19:15:42', NULL, '7', '2014-03-20', '1'),
('33', '12', '3', '1', '2015-05-12 19:15:42', NULL, '7', '2014-03-20', '2'),
('34', '33', '12', '1', '2015-07-03 16:27:02', NULL, '7', '2016-03-23', NULL),
('35', '32', '9', '1', '2015-03-23 05:02:14', NULL, '7', '2015-03-23', '0'),
('36', '30', '6', '1', '2015-05-12 21:28:50', NULL, '7', '2014-03-23', NULL),
('37', '30', '2', '1', '2015-07-22 22:22:03', 'Deleted.', '7', '2015-03-23', NULL),
('38', '33', '13', '1', '2015-07-03 17:13:21', NULL, '7', '2014-12-01', NULL),
('39', '32', '10', '1', '2015-03-23 09:07:42', NULL, '7', '2015-03-23', '0'),
('40', '30', '7', '1', '2015-10-26 22:24:20', NULL, '7', '2014-03-23', NULL),
('41', '13', '4', '1', '2015-03-23 09:27:36', NULL, '7', '2014-03-23', '0'),
('42', '10', '3', '1', '2015-03-23 09:34:33', NULL, '7', '2014-03-23', '0'),
('43', '12', '4', '1', '2015-05-12 19:15:42', NULL, '7', '2014-03-23', '3'),
('44', '33', '14', '1', '2015-07-04 10:28:35', NULL, '7', '2015-05-12', NULL),
('45', '1', '1', '1', '2015-05-12 19:21:57', NULL, '7', '2015-05-12', '0'),
('46', '32', '11', '1', '2015-05-12 19:22:32', NULL, '7', '2015-05-12', '0'),
('47', '30', '8', '1', '2015-05-12 19:47:21', NULL, '7', '2015-05-12', NULL),
('48', '13', '5', '1', '2015-05-12 19:26:29', NULL, '7', '2015-05-12', '0'),
('49', '30', '8', '1', '2015-10-27 23:04:21', 'Updated.', '7', '2015-05-12', NULL),
('50', '30', '9', '1', '2015-10-29 15:55:49', NULL, '7', '2015-05-12', NULL),
('51', '13', '6', '1', '2015-05-12 19:48:17', NULL, '7', '2015-05-12', '0'),
('52', '30', '10', '1', '2015-05-12 21:27:53', NULL, '7', '2015-05-12', '0'),
('53', '13', '7', '1', '2015-05-12 21:28:03', NULL, '7', '2015-05-12', '0'),
('54', '30', '6', '1', '2015-07-24 00:26:07', 'Updated.', '7', '2015-03-23', NULL),
('55', '33', '1', '1', '2015-05-24 23:09:03', NULL, '7', '2015-05-24', NULL),
('56', '33', '2', '1', '2015-05-24 23:09:25', NULL, '7', '2015-05-24', NULL),
('57', '33', '3', '1', '2015-05-24 23:13:34', NULL, '7', '2015-05-24', NULL),
('58', '33', '1', '1', '2015-07-19 21:50:50', NULL, '7', '2015-05-24', NULL),
('59', '33', '2', '1', '2015-07-20 23:28:15', NULL, '7', '2015-05-24', NULL),
('60', '33', '3', '1', '2015-07-20 23:33:55', NULL, '7', '2015-05-24', NULL),
('61', '33', '4', '1', '2015-07-20 23:38:27', NULL, '7', '2015-05-24', NULL),
('62', '33', '5', '1', '2015-07-20 23:39:01', NULL, '7', '2015-05-24', NULL),
('63', '33', '6', '1', '2015-07-20 23:59:23', NULL, '7', '2015-05-24', NULL),
('64', '33', '7', '1', '2015-07-20 23:59:45', NULL, '7', '2015-07-03', NULL),
('65', '33', '8', '1', '2015-07-21 00:00:30', NULL, '7', '2015-07-03', NULL),
('66', '33', '9', '1', '2015-07-21 23:46:34', NULL, '7', '2015-07-03', NULL),
('67', '33', '10', '1', '2015-07-21 23:50:39', NULL, '7', '2015-07-03', NULL),
('68', '33', '11', '1', '2015-07-21 23:51:23', NULL, '7', '2015-07-03', NULL),
('69', '33', '12', '1', '2015-07-21 23:52:42', NULL, '7', '2015-07-03', NULL),
('70', '33', '13', '1', '2015-07-21 23:52:51', NULL, '7', '2015-07-03', NULL),
('71', '33', '14', '1', '2015-07-21 23:53:22', NULL, '7', '2015-07-04', NULL),
('72', '33', '15', '1', '2015-07-21 23:56:37', NULL, '7', '2015-07-04', NULL),
('73', '33', '16', '1', '2015-07-04 17:01:54', NULL, '7', '2015-07-04', '0'),
('74', '33', '17', '1', '2015-07-04 17:05:44', NULL, '7', '2015-07-04', '0'),
('75', '33', '18', '1', '2015-07-04 17:56:53', NULL, '7', '2015-07-04', '0'),
('76', '33', '19', '1', '2015-07-04 21:09:34', NULL, '7', '2015-07-04', '0'),
('77', '33', '20', '1', '2015-07-04 21:31:52', NULL, '7', '2015-07-04', '0'),
('78', '33', '21', '1', '2015-07-04 21:36:22', NULL, '7', '2015-07-04', '0'),
('79', '33', '22', '1', '2015-07-06 16:49:02', NULL, '7', '2015-07-06', '0'),
('80', '33', '23', '1', '2015-07-09 22:14:58', NULL, '7', '2015-07-09', '0'),
('81', '33', '24', '1', '2015-07-10 13:10:16', NULL, '7', '2015-07-09', NULL),
('82', '33', '24', '1', '2015-07-10 13:11:47', 'Updated.', '7', '2015-07-09', NULL),
('83', '33', '24', '1', '2015-07-10 13:14:30', 'Updated.', '7', '2015-07-09', NULL),
('84', '33', '24', '1', '2015-07-10 13:17:37', 'Updated.', '7', '2015-07-09', NULL),
('85', '33', '24', '1', '2015-07-10 13:20:02', 'Updated.', '7', '2015-07-09', NULL),
('86', '33', '24', '1', '2015-07-10 13:22:06', 'Updated.', '7', '2015-07-09', NULL),
('87', '33', '24', '1', '2015-07-10 13:23:37', 'Updated.', '7', '2015-07-09', NULL),
('88', '33', '24', '1', '2015-07-10 13:25:01', 'Updated.', '7', '2015-07-09', NULL),
('89', '33', '24', '1', '2015-07-10 13:33:44', 'Updated.', '7', '2015-07-09', NULL),
('90', '33', '24', '1', '2015-07-10 13:51:46', 'Updated.', '7', '2015-07-09', NULL),
('91', '33', '24', '1', '2015-07-10 13:56:35', 'Updated.', '7', '2015-07-09', NULL),
('92', '33', '24', '1', '2015-07-10 13:57:17', 'Updated.', '7', '2015-07-09', NULL),
('93', '33', '24', '1', '2015-07-10 13:58:17', 'Updated.', '7', '2015-07-09', NULL),
('94', '33', '24', '1', '2015-07-10 13:59:45', 'Updated.', '7', '2015-07-09', NULL),
('95', '33', '24', '1', '2015-07-10 14:01:58', 'Updated.', '7', '2015-07-09', NULL),
('96', '33', '24', '1', '2015-07-10 14:01:58', 'Updated.', '7', '2015-07-09', '0'),
('97', '33', '25', '1', '2015-07-10 14:08:37', NULL, '7', '2015-07-10', '0'),
('98', '33', '26', '1', '2015-07-10 14:34:54', NULL, '7', '2015-07-10', NULL),
('99', '33', '26', '1', '2015-07-10 14:34:54', 'Updated.', '7', '2015-07-10', '0'),
('100', '33', '27', '1', '2015-07-10 15:32:10', NULL, '7', '2015-07-10', NULL),
('101', '33', '27', '1', '2015-07-10 15:32:10', 'Updated.', '7', '2015-07-10', '0'),
('102', '33', '28', '1', '2015-07-10 15:59:33', NULL, '7', '2015-07-10', NULL),
('103', '33', '28', '1', '2015-07-11 11:26:23', 'Updated.', '7', '2015-07-10', NULL),
('104', '33', '28', '1', '2015-07-11 11:59:44', 'Deleted.', '7', '2015-07-11', NULL),
('105', '33', '28', '1', '2015-07-11 12:37:47', NULL, '7', '2015-07-11', NULL),
('106', '33', '28', '1', '2015-07-11 12:38:53', 'Updated.', '7', '2015-07-11', NULL),
('107', '33', '28', '1', '2015-07-11 12:39:43', 'Updated.', '7', '2015-07-11', NULL),
('108', '33', '28', '1', '2015-07-11 12:40:05', 'Updated.', '7', '2015-07-11', NULL),
('109', '33', '28', '1', '2015-07-11 12:53:43', 'Updated.', '7', '2015-07-11', NULL),
('110', '33', '28', '1', '2015-07-11 12:54:04', 'Updated.', '7', '2015-07-11', NULL),
('111', '33', '28', '1', '2015-07-11 12:55:19', 'Updated.', '7', '2015-07-11', NULL),
('112', '33', '28', '1', '2015-07-11 12:57:13', 'Updated.', '7', '2015-07-11', NULL),
('113', '33', '28', '1', '2015-07-11 13:00:05', 'Updated.', '7', '2015-07-11', NULL),
('114', '33', '28', '1', '2015-07-11 14:59:39', 'Updated.', '7', '2015-07-11', NULL),
('115', '33', '0', '1', '2015-07-11 14:58:57', 'Deleted.', '7', '2015-07-11', '0'),
('116', '33', '28', '1', '2015-07-11 15:00:19', 'Updated.', '7', '2015-07-11', NULL),
('117', '33', '28', '1', '2015-07-11 15:00:19', 'Updated.', '7', '2015-07-11', '0'),
('118', '33', '29', '1', '2015-07-13 12:03:26', NULL, '7', '2015-07-13', NULL),
('119', '33', '29', '1', '2015-07-13 12:03:26', 'Updated.', '7', '2015-07-13', '0'),
('120', '33', '30', '1', '2015-07-13 12:09:36', NULL, '7', '2015-07-13', '0'),
('121', '33', '31', '1', '2015-07-13 12:22:17', NULL, '7', '2015-07-13', '0'),
('122', '33', '32', '1', '2015-07-13 14:17:52', NULL, '7', '2015-07-13', NULL),
('123', '33', '32', '1', '2015-07-13 14:17:52', 'Updated.', '7', '2015-07-13', '0'),
('124', '33', '33', '1', '2015-07-13 22:09:28', NULL, '7', '2015-07-13', '0'),
('125', '33', '34', '1', '2015-07-15 20:27:37', NULL, '7', '2015-07-15', '0'),
('126', '33', '35', '1', '2015-07-15 20:31:49', NULL, '7', '2015-07-15', '0'),
('127', '33', '36', '1', '2015-07-15 20:44:16', NULL, '7', '2015-07-15', '0'),
('128', '33', '37', '1', '2015-07-16 13:24:54', NULL, '7', '2015-07-15', NULL),
('129', '33', '37', '1', '2015-07-16 13:28:50', 'Updated.', '7', '2015-07-15', NULL),
('130', '33', '37', '1', '2015-07-16 13:29:21', 'Updated.', '7', '2015-07-15', NULL),
('131', '33', '37', '1', '2015-07-16 13:29:21', 'Updated.', '7', '2015-07-15', '0'),
('132', '2', '1', '1', '2015-07-18 09:19:51', NULL, '7', '2015-07-18', NULL),
('133', '2', '1', '1', '2015-07-18 09:19:51', NULL, '7', '2015-07-18', '0'),
('134', '33', '38', '1', '2015-07-18 10:09:24', NULL, '7', '2015-07-18', '0'),
('135', '33', '39', '1', '2015-07-18 10:25:10', NULL, '7', '2015-07-18', '0'),
('136', '33', '40', '1', '2015-07-18 10:37:25', NULL, '7', '2015-07-18', '0'),
('137', '33', '41', '1', '2015-07-18 10:43:41', NULL, '7', '2015-07-18', '0'),
('138', '33', '42', '1', '2015-07-19 19:49:07', NULL, '7', '2015-07-19', '0'),
('139', '33', '43', '1', '2015-07-19 19:59:05', NULL, '7', '2015-07-19', '0'),
('140', '33', '44', '1', '2015-07-19 20:09:07', NULL, '7', '2015-07-19', NULL),
('141', '33', '45', '1', '2015-07-19 20:08:19', NULL, '7', '2015-07-19', '0'),
('142', '33', '44', '1', '2015-07-19 20:09:20', 'Updated.', '7', '2015-07-19', NULL),
('143', '33', '44', '1', '2015-07-19 20:09:20', 'Deleted.', '7', '2015-07-19', '0'),
('144', '33', '46', '1', '2015-07-19 20:10:23', NULL, '7', '2015-07-19', '0'),
('145', '33', '47', '1', '2015-07-19 20:11:58', NULL, '7', '2015-07-19', '0'),
('146', '30', '1', '1', '2015-07-19 21:33:41', NULL, '7', '2015-07-19', NULL),
('147', '30', '1', '1', '2015-07-22 00:24:52', NULL, '7', '2015-07-19', NULL),
('148', '33', '1', '1', '2015-07-19 21:51:38', NULL, '7', '2015-07-19', NULL),
('149', '33', '1', '1', '2015-07-19 21:52:45', 'Updated.', '7', '2015-07-19', NULL),
('150', '33', '1', '1', '2015-07-19 21:56:25', 'Updated.', '7', '2015-07-19', NULL),
('151', '33', '1', '1', '2015-07-21 23:57:34', 'Updated.', '7', '2015-07-19', NULL),
('152', '33', '2', '1', '2015-07-22 00:19:39', NULL, '7', '2015-07-20', NULL),
('153', '33', '3', '1', '2015-07-20 23:33:55', NULL, '7', '2015-07-20', '0'),
('154', '33', '4', '1', '2015-07-20 23:38:27', NULL, '7', '2015-07-20', '0'),
('155', '33', '5', '1', '2015-07-20 23:39:01', NULL, '7', '2015-07-20', '0'),
('156', '33', '6', '1', '2015-07-20 23:59:23', NULL, '7', '2015-07-20', '0'),
('157', '33', '7', '1', '2015-07-20 23:59:45', NULL, '7', '2015-07-20', '0'),
('158', '33', '8', '1', '2015-07-21 00:00:30', NULL, '7', '2015-07-20', '0'),
('159', '33', '9', '1', '2015-07-21 23:46:34', NULL, '7', '2015-07-21', '0'),
('160', '33', '10', '1', '2015-07-21 23:50:39', NULL, '7', '2015-07-21', '0'),
('161', '33', '11', '1', '2015-07-21 23:51:23', NULL, '7', '2015-07-21', '0'),
('162', '33', '12', '1', '2015-07-21 23:52:42', NULL, '7', '2015-07-21', '0'),
('163', '33', '13', '1', '2015-07-21 23:52:51', NULL, '7', '2015-07-21', '0'),
('164', '33', '14', '1', '2015-07-21 23:53:22', NULL, '7', '2015-07-21', '0'),
('165', '33', '15', '1', '2015-07-21 23:56:37', NULL, '7', '2015-07-21', '0'),
('166', '33', '1', '1', '2015-07-22 00:20:33', NULL, '7', '2015-07-21', NULL),
('167', '33', '2', '1', '2015-07-22 00:19:39', NULL, '7', '2015-07-21', '0'),
('168', '33', '1', '1', '2015-07-22 00:21:36', NULL, '7', '2015-07-21', NULL),
('169', '33', '1', '1', '2015-07-22 22:29:49', 'Updated.', '7', '2015-07-21', NULL),
('170', '30', '1', '1', '2015-07-22 23:06:35', NULL, '7', '2015-07-21', NULL),
('171', '30', '2', '1', '2015-07-22 23:28:14', NULL, '7', '2015-07-22', NULL),
('172', '33', '1', '1', '2015-07-22 22:29:49', 'Updated.', '7', '2015-07-21', '0'),
('173', '30', '3', '1', '2015-07-22 23:30:35', NULL, '7', '2015-07-22', NULL),
('174', '30', '4', '1', '2015-07-23 22:10:53', NULL, '7', '2015-07-22', NULL),
('175', '30', '1', '1', '2015-07-24 00:31:28', NULL, '7', '2015-07-22', NULL),
('176', '30', '2', '1', '2015-07-24 00:32:31', NULL, '7', '2015-07-22', NULL),
('177', '30', '3', '1', '2015-07-26 22:18:38', NULL, '7', '2015-07-22', NULL),
('178', '30', '4', '1', '2015-07-26 22:21:28', NULL, '7', '2015-07-23', NULL),
('179', '30', '5', '1', '2015-07-23 23:17:09', NULL, '7', '2015-07-23', NULL),
('180', '30', '5', '1', '2015-07-27 00:20:51', 'Updated.', '7', '2015-07-23', NULL),
('181', '30', '6', '1', '2015-07-24 00:28:13', NULL, '7', '2015-07-23', NULL),
('182', '30', '6', '1', '2015-08-29 16:47:27', 'Updated.', '7', '2015-07-23', NULL),
('183', '30', '1', '1', '2015-10-27 21:41:50', NULL, '7', '0000-00-00', NULL),
('184', '30', '2', '1', '2015-07-24 23:51:56', NULL, '7', '2015-07-23', NULL),
('185', '30', '2', '1', '2015-07-24 23:51:56', 'Updated.', '7', '2015-07-23', '0'),
('186', '30', '3', '1', '2015-07-26 22:18:38', NULL, '7', '2015-07-26', '0'),
('187', '30', '4', '1', '2015-07-26 22:21:28', NULL, '7', '2015-07-26', '0'),
('190', '30', '5', '1', '2015-07-28 00:03:59', NULL, '7', '2015-07-26', NULL),
('191', '30', '5', '1', '2015-07-28 00:03:59', 'Updated.', '7', '2015-07-26', '0'),
('192', '30', '6', '1', '2015-08-29 17:08:32', NULL, '7', '2015-08-29', NULL),
('193', '30', '6', '1', '2015-08-29 17:16:39', 'Updated.', '7', '2015-08-29', NULL),
('194', '30', '6', '1', '2015-08-29 17:55:10', 'Updated.', '7', '2015-08-29', NULL),
('195', '30', '6', '1', '2015-08-29 17:58:23', 'Updated.', '7', '2015-08-29', NULL),
('196', '30', '6', '1', '2015-08-29 17:59:02', 'Updated.', '7', '2015-08-29', NULL),
('197', '30', '6', '1', '2015-08-29 18:50:25', 'Updated.', '7', '2015-08-29', NULL),
('198', '30', '6', '1', '2015-08-29 18:54:52', 'Updated.', '7', '2015-08-29', NULL),
('199', '30', '6', '1', '2015-08-29 18:57:47', 'Updated.', '7', '2015-08-29', NULL),
('200', '30', '6', '1', '2015-08-29 19:57:41', 'Updated.', '7', '2015-08-29', NULL),
('201', '30', '6', '1', '2015-08-29 20:31:32', 'Updated.', '7', '2015-08-29', NULL),
('202', '30', '6', '1', '2015-08-29 20:32:30', 'Updated.', '7', '2015-08-29', NULL),
('203', '30', '6', '1', '2015-08-29 20:32:30', 'Updated.', '7', '2015-08-29', '0'),
('204', '30', '7', '1', '2015-10-26 22:24:20', NULL, '7', '2015-10-26', '0'),
('205', '30', '1', '1', '2015-10-27 21:41:50', 'Updated.', '7', '0000-00-00', '0'),
('206', '30', '8', '1', '2015-10-27 23:04:21', NULL, '7', '2015-10-27', '0'),
('207', '30', '9', '1', '2015-10-29 15:55:49', NULL, '7', '2015-10-29', '0');

### Structure of table `0_bank_accounts` ###

DROP TABLE IF EXISTS `0_bank_accounts`;

CREATE TABLE `0_bank_accounts` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_type` smallint(6) NOT NULL DEFAULT '0',
  `bank_account_name` varchar(60) NOT NULL DEFAULT '',
  `bank_account_number` varchar(100) NOT NULL DEFAULT '',
  `bank_name` varchar(60) NOT NULL DEFAULT '',
  `bank_address` tinytext,
  `bank_curr_code` char(3) NOT NULL DEFAULT '',
  `dflt_curr_act` tinyint(1) NOT NULL DEFAULT '0',
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `last_reconciled_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ending_reconcile_balance` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bank_account_name` (`bank_account_name`),
  KEY `bank_account_number` (`bank_account_number`),
  KEY `account_code` (`account_code`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES
('1060', '0', 'Current account', '9999999999', 'Wachovia Bank', NULL, 'INR', '0', '1', '0000-00-00 00:00:00', '0', '0'),
('1065', '3', 'Petty Cash account', 'N/A', 'N/A', NULL, 'INR', '0', '2', '0000-00-00 00:00:00', '0', '0');

### Structure of table `0_bank_trans` ###

DROP TABLE IF EXISTS `0_bank_trans`;

CREATE TABLE `0_bank_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `bank_act` varchar(15) NOT NULL DEFAULT '',
  `ref` varchar(40) DEFAULT NULL,
  `trans_date` date NOT NULL DEFAULT '0000-00-00',
  `amount` double DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `person_type_id` int(11) NOT NULL DEFAULT '0',
  `person_id` tinyblob,
  `reconciled` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bank_act` (`bank_act`,`ref`),
  KEY `type` (`type`,`trans_no`),
  KEY `bank_act_2` (`bank_act`,`reconciled`),
  KEY `bank_act_3` (`bank_act`,`trans_date`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ;

### Data of table `0_bank_trans` ###

INSERT INTO `0_bank_trans` VALUES
('1', '12', '1', '2', '108', '2014-12-30', '1340', '0', '0', '2', '1', NULL),
('2', '12', '2', '1', '109', '2014-12-31', '34234', '0', '0', '2', '1', NULL),
('3', '12', '3', '2', '110', '2014-03-20', '2767.5', '0', '0', '2', '1', NULL),
('4', '12', '4', '2', '111', '2014-03-23', '0', '0', '0', '2', '1', NULL),
('5', '1', '1', '1', '3', '2015-05-12', '-230', '0', '0', '3', NULL, NULL),
('6', '2', '1', '1', '3', '2015-07-18', '12340', '0', '0', '2', '2', NULL);

### Structure of table `0_bom` ###

DROP TABLE IF EXISTS `0_bom`;

CREATE TABLE `0_bom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` char(20) NOT NULL DEFAULT '',
  `component` char(20) NOT NULL DEFAULT '',
  `workcentre_added` int(11) NOT NULL DEFAULT '0',
  `loc_code` int(11) NOT NULL DEFAULT '1',
  `vehicle_id` varchar(20) NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `component` (`component`),
  KEY `id` (`id`),
  KEY `loc_code` (`loc_code`),
  KEY `parent` (`parent`,`loc_code`),
  KEY `workcentre_added` (`workcentre_added`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_bom` ###


### Structure of table `0_budget_trans` ###

DROP TABLE IF EXISTS `0_budget_trans`;

CREATE TABLE `0_budget_trans` (
  `counter` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `type_no` bigint(16) NOT NULL DEFAULT '1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `account` varchar(15) NOT NULL DEFAULT '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL DEFAULT '0',
  `dimension_id` int(11) DEFAULT '0',
  `dimension2_id` int(11) DEFAULT '0',
  `person_type_id` int(11) DEFAULT NULL,
  `person_id` tinyblob,
  PRIMARY KEY (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `Account` (`account`,`tran_date`,`dimension_id`,`dimension2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_budget_trans` ###


### Structure of table `0_chart_class` ###

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL DEFAULT '',
  `ctype` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_chart_class` ###

INSERT INTO `0_chart_class` VALUES
('1', 'Assets', '1', '0'),
('2', 'Liabilities', '2', '0'),
('3', 'Income', '4', '0'),
('4', 'Costs', '6', '0');

### Structure of table `0_chart_master` ###

DROP TABLE IF EXISTS `0_chart_master`;

CREATE TABLE `0_chart_master` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_code2` varchar(15) NOT NULL DEFAULT '',
  `account_name` varchar(60) NOT NULL DEFAULT '',
  `account_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES
('1060', '', 'Checking Account', '1', '0'),
('1065', '', 'Petty Cash', '1', '0'),
('1200', '', 'Accounts Receivables', '1', '0'),
('1205', '', 'Allowance for doubtful accounts', '1', '0'),
('1510', '', 'Inventory', '2', '0'),
('1520', '', 'Stocks of Raw Materials', '2', '0'),
('1530', '', 'Stocks of Work In Progress', '2', '0'),
('1540', '', 'Stocks of Finsihed Goods', '2', '0'),
('1550', '', 'Goods Received Clearing account', '2', '0'),
('1820', '', 'Office Furniture &amp; Equipment', '3', '0'),
('1825', '', 'Accum. Amort. -Furn. &amp; Equip.', '3', '0'),
('1840', '', 'Vehicle', '3', '0'),
('1845', '', 'Accum. Amort. -Vehicle', '3', '0'),
('2100', '', 'Accounts Payable', '4', '0'),
('2110', '', 'Accrued Income Tax - Federal', '4', '0'),
('2120', '', 'Accrued Income Tax - State', '4', '0'),
('2130', '', 'Accrued Franchise Tax', '4', '0'),
('2140', '', 'Accrued Real &amp; Personal Prop Tax', '4', '0'),
('2150', '', 'Transport Tax', '4', '0'),
('2160', '', 'Accrued Use Tax Payable', '4', '0'),
('2210', '', 'Accrued Wages', '4', '0'),
('2220', '', 'Accrued Comp Time', '4', '0'),
('2230', '', 'Accrued Holiday Pay', '4', '0'),
('2240', '', 'Accrued Vacation Pay', '4', '0'),
('2310', '', 'Accr. Benefits - 401K', '4', '0'),
('2320', '', 'Accr. Benefits - Stock Purchase', '4', '0'),
('2330', '', 'Accr. Benefits - Med, Den', '4', '0'),
('2340', '', 'Accr. Benefits - Payroll Taxes', '4', '0'),
('2350', '', 'Accr. Benefits - Credit Union', '4', '0'),
('2360', '', 'Accr. Benefits - Savings Bond', '4', '0'),
('2370', '', 'Accr. Benefits - Garnish', '4', '0'),
('2380', '', 'Accr. Benefits - Charity Cont.', '4', '0'),
('2620', '', 'Bank Loans', '5', '0'),
('2680', '', 'Loans from Shareholders', '5', '0'),
('3350', '', 'Common Shares', '6', '0'),
('3590', '', 'Retained Earnings - prior years', '7', '0'),
('4010', '', 'Transport', '8', '0'),
('4430', '', 'Shipping &amp; Handling', '9', '0'),
('4440', '', 'Interest', '9', '0'),
('4450', '', 'Foreign Exchange Gain', '9', '0'),
('4500', '', 'Prompt Payment Discounts', '9', '0'),
('4510', '', 'Discounts Given', '9', '0'),
('5010', '', 'Cost of Goods Sold - Retail', '10', '0'),
('5020', '', 'Material Usage Varaiance', '10', '0'),
('5030', '', 'Consumable Materials', '10', '0'),
('5040', '', 'Purchase price Variance', '10', '0'),
('5050', '', 'Purchases of materials', '10', '0'),
('5060', '', 'Discounts Received', '10', '0'),
('5100', '', 'Freight', '10', '0'),
('5410', '', 'Wages &amp; Salaries', '11', '0'),
('5420', '', 'Wages - Overtime', '11', '0'),
('5430', '', 'Benefits - Comp Time', '11', '0'),
('5440', '', 'Benefits - Payroll Taxes', '11', '0'),
('5450', '', 'Benefits - Workers Comp', '11', '0'),
('5460', '', 'Benefits - Pension', '11', '0'),
('5470', '', 'Benefits - General Benefits', '11', '0'),
('5510', '', 'Inc Tax Exp - Federal', '11', '0'),
('5520', '', 'Inc Tax Exp - State', '11', '0'),
('5530', '', 'Taxes - Real Estate', '11', '0'),
('5540', '', 'Taxes - Personal Property', '11', '0'),
('5550', '', 'Taxes - Franchise', '11', '0'),
('5560', '', 'Taxes - Foreign Withholding', '11', '0'),
('5610', '', 'Accounting &amp; Legal', '12', '0'),
('5615', '', 'Advertising &amp; Promotions', '12', '0'),
('5620', '', 'Bad Debts', '12', '0'),
('5660', '', 'Amortization Expense', '12', '0'),
('5685', '', 'Insurance', '12', '0'),
('5690', '', 'Interest &amp; Bank Charges', '12', '0'),
('5700', '', 'Office Supplies', '12', '0'),
('5760', '', 'Rent', '12', '0'),
('5765', '', 'Repair &amp; Maintenance', '12', '0'),
('5780', '', 'Telephone', '12', '0'),
('5785', '', 'Travel &amp; Entertainment', '12', '0'),
('5790', '', 'Utilities', '12', '0'),
('5795', '', 'Registrations', '12', '0'),
('5800', '', 'Licenses', '12', '0'),
('5810', '', 'Foreign Exchange Loss', '12', '0'),
('9990', '', 'Year Profit/Loss', '12', '0');

### Structure of table `0_chart_types` ###

DROP TABLE IF EXISTS `0_chart_types`;

CREATE TABLE `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `class_id` varchar(3) NOT NULL DEFAULT '',
  `parent` varchar(10) NOT NULL DEFAULT '-1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES
('1', 'Current Assets', '1', '', '0'),
('2', 'Inventory Assets', '1', '', '0'),
('3', 'Capital Assets', '1', '', '0'),
('4', 'Current Liabilities', '2', '', '0'),
('5', 'Long Term Liabilities', '2', '', '0'),
('6', 'Share Capital', '2', '', '0'),
('7', 'Retained Earnings', '2', '', '0'),
('8', 'Transport Revenue', '3', '', '0'),
('9', 'Other Revenue', '3', '', '0'),
('10', 'Cost of Goods Sold', '4', '', '0'),
('11', 'Payroll Expenses', '4', '', '0'),
('12', 'General &amp; Administrative expenses', '4', '', '0');

### Structure of table `0_comments` ###

DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date DEFAULT '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_comments` ###

INSERT INTO `0_comments` VALUES
('13', '1', '2014-12-30', 'Loading Slip # 1'),
('10', '1', '2014-12-30', 'Loading Slip # 1'),
('12', '1', '2014-12-30', 'Cash invoice 1'),
('13', '2', '2014-02-10', 'Loading Slip # 6'),
('13', '3', '2014-03-20', 'Loading Slip # 8'),
('10', '2', '2014-03-20', 'Loading Slip # 8'),
('12', '3', '2014-03-20', 'Cash invoice 2'),
('13', '4', '2014-03-23', 'Loading Slip # 10'),
('10', '3', '2014-03-23', 'Loading Slip # 10'),
('12', '4', '2014-03-23', 'Cash invoice 3'),
('13', '5', '2015-05-12', 'Loading Slip # 11'),
('13', '6', '2015-05-12', 'Loading Slip # 11'),
('13', '7', '2015-05-12', 'Loading Slip # 11');

### Structure of table `0_commodity_group_types` ###

DROP TABLE IF EXISTS `0_commodity_group_types`;

CREATE TABLE `0_commodity_group_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_commodity_group_types` ###

INSERT INTO `0_commodity_group_types` VALUES
('1', 'Gas', '0');

### Structure of table `0_commodity_type` ###

DROP TABLE IF EXISTS `0_commodity_type`;

CREATE TABLE `0_commodity_type` (
  `commodity_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `commodity_type_name` varchar(60) NOT NULL DEFAULT '',
  `commodity_group_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`commodity_type_code`),
  KEY `commodity_type_name` (`commodity_type_name`),
  KEY `commodity_status_by_type` (`commodity_group_type`,`commodity_type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_commodity_type` ###

INSERT INTO `0_commodity_type` VALUES
('1', 'd', '1', '0');

### Structure of table `0_consignee_allocations` ###

DROP TABLE IF EXISTS `0_consignee_allocations`;

CREATE TABLE `0_consignee_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_consignee_allocations` ###


### Structure of table `0_consignee_branch` ###

DROP TABLE IF EXISTS `0_consignee_branch`;

CREATE TABLE `0_consignee_branch` (
  `consignee_branch_code` int(11) NOT NULL AUTO_INCREMENT,
  `consignee_no` int(11) NOT NULL DEFAULT '0',
  `br_name` varchar(60) NOT NULL DEFAULT '',
  `consignee_branch_ref` varchar(30) NOT NULL DEFAULT '',
  `tin_no` varchar(20) NOT NULL,
  `br_address` tinytext NOT NULL,
  `area` int(11) DEFAULT NULL,
  `transportman` int(11) NOT NULL DEFAULT '0',
  `contact_name` varchar(60) NOT NULL DEFAULT '',
  `default_location` int(11) NOT NULL DEFAULT '1',
  `tax_group_id` int(11) DEFAULT NULL,
  `transport_account` varchar(15) NOT NULL DEFAULT '',
  `transport_discount_account` varchar(15) NOT NULL DEFAULT '',
  `receivables_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `default_ship_via` int(11) NOT NULL DEFAULT '1',
  `disable_trans` tinyint(4) NOT NULL DEFAULT '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL DEFAULT '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`consignee_branch_code`,`consignee_no`),
  KEY `branch_code` (`consignee_branch_code`),
  KEY `branch_ref` (`consignee_branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_consignee_branch` ###

INSERT INTO `0_consignee_branch` VALUES
('1', '1', 'ankita', 'ankita', '343434343343', 'sfdhs', NULL, '0', '', '0', NULL, '', '', '', '', '1', '0', '2', '0', '', '0');

### Structure of table `0_consignee_trans` ###

DROP TABLE IF EXISTS `0_consignee_trans`;

CREATE TABLE `0_consignee_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `consignee_no` int(11) unsigned DEFAULT NULL,
  `consignee_branch_code` int(11) NOT NULL DEFAULT '-1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `tpe` int(11) NOT NULL DEFAULT '0',
  `order_` int(11) NOT NULL DEFAULT '0',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `ov_freight` double NOT NULL DEFAULT '0',
  `ov_freight_tax` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ship_via` int(11) DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  PRIMARY KEY (`type`,`trans_no`),
  KEY `consignee_no` (`consignee_no`,`consignee_branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_consignee_trans` ###


### Structure of table `0_consignee_trans_details` ###

DROP TABLE IF EXISTS `0_consignee_trans_details`;

CREATE TABLE `0_consignee_trans_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consignee_trans_no` int(11) DEFAULT NULL,
  `consignee_trans_type` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `qty_done` double NOT NULL DEFAULT '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`consignee_trans_type`,`consignee_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_consignee_trans_details` ###


### Structure of table `0_consignees_master` ###

DROP TABLE IF EXISTS `0_consignees_master`;

CREATE TABLE `0_consignees_master` (
  `consignee_no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `consignee_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL DEFAULT '',
  `curr_code` char(3) NOT NULL DEFAULT '',
  `credit_status` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  `discount` double NOT NULL DEFAULT '0',
  `pymt_discount` double NOT NULL DEFAULT '0',
  `credit_limit` float NOT NULL DEFAULT '1000',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`consignee_no`),
  UNIQUE KEY `consignee_ref` (`consignee_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_consignees_master` ###

INSERT INTO `0_consignees_master` VALUES
('1', 'ankita', 'ankita', 'sfdhs', '34343', 'INR', '0', NULL, '0', '0', '1000', '', '0');

### Structure of table `0_consignor_allocations` ###

DROP TABLE IF EXISTS `0_consignor_allocations`;

CREATE TABLE `0_consignor_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_consignor_allocations` ###

INSERT INTO `0_consignor_allocations` VALUES
('1', '1340', '2014-12-30', '1', '12', '1', '10'),
('2', '2767.5', '2015-03-20', '3', '12', '2', '10'),
('3', '0', '2015-03-23', '4', '12', '3', '10');

### Structure of table `0_consignor_branch` ###

DROP TABLE IF EXISTS `0_consignor_branch`;

CREATE TABLE `0_consignor_branch` (
  `branch_code` int(11) NOT NULL AUTO_INCREMENT,
  `consignor_no` int(11) NOT NULL DEFAULT '0',
  `br_name` varchar(60) NOT NULL DEFAULT '',
  `branch_ref` varchar(30) NOT NULL DEFAULT '',
  `tin_no` varchar(20) NOT NULL,
  `br_address` tinytext NOT NULL,
  `area` int(11) DEFAULT NULL,
  `transportman` int(11) NOT NULL DEFAULT '0',
  `contact_name` varchar(60) NOT NULL DEFAULT '',
  `default_location` int(11) NOT NULL DEFAULT '1',
  `tax_group_id` int(11) DEFAULT NULL,
  `transport_account` varchar(15) NOT NULL DEFAULT '',
  `transport_discount_account` varchar(15) NOT NULL DEFAULT '',
  `receivables_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `default_ship_via` int(11) NOT NULL DEFAULT '1',
  `disable_trans` tinyint(4) NOT NULL DEFAULT '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL DEFAULT '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`branch_code`,`consignor_no`),
  KEY `branch_code` (`branch_code`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_consignor_branch` ###

INSERT INTO `0_consignor_branch` VALUES
('1', '1', 'sarang', 'sarang', '38458304330', 'fdj', NULL, '0', '', '0', '1', '', '', '', '', '1', '0', '', '0', '', '0'),
('2', '2', 'Adarsh', 'dad', 'czcxzc', 'sdf', NULL, '0', '', '2', '1', '', '', '', '', '1', '0', 'sdfsdf', '0', 'sdf', '0'),
('3', '3', 'Gopalbari', 'Gopalbari', 'gopal_tax', 'Jaipur\nJaipur\nRajasthan\nIndia\n302001\n', NULL, '0', '', '2', '1', '', '', '', '', '1', '0', '', '0', '', '0'),
('4', '1', 'sarang_br2', 'sarang_br2', '1234', 'hyd', NULL, '0', '', '1', NULL, '', '', '', '', '1', '0', 'hyd', '0', 'test', '0');

### Structure of table `0_consignor_trans` ###

DROP TABLE IF EXISTS `0_consignor_trans`;

CREATE TABLE `0_consignor_trans` (
  `order_no` int(11) unsigned NOT NULL,
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `consignor_no` int(11) unsigned DEFAULT NULL,
  `branch_code` int(11) NOT NULL DEFAULT '-1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `tpe` int(11) NOT NULL DEFAULT '0',
  `order_` int(11) NOT NULL DEFAULT '0',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `ov_freight` double NOT NULL DEFAULT '0',
  `ov_freight_tax` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ship_via` int(11) DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_no`,`trans_no`,`type`),
  KEY `consignor_no` (`consignor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_consignor_trans` ###


### Structure of table `0_consignor_trans_details` ###

DROP TABLE IF EXISTS `0_consignor_trans_details`;

CREATE TABLE `0_consignor_trans_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `consignor_trans_no` int(11) DEFAULT NULL,
  `consignor_trans_type` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `to_units` varchar(20) NOT NULL,
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `qty_done` double NOT NULL DEFAULT '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`consignor_trans_type`,`consignor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 ;

### Data of table `0_consignor_trans_details` ###

INSERT INTO `0_consignor_trans_details` VALUES
('1', '0', '1', '13', 'Marbel', 'Marbel', '1340', '268', '1', 'Bags', '0', '0', '1', '2'),
('2', '0', '1', '10', 'Marbel', 'Marbel', '1340', '268', '1', 'Bags', '0', '0', '0', '1'),
('3', '0', '2', '13', 'Marbel', 'Marbel', '1230', '307.5', '1', 'Ton', '0', '0', '0', '8'),
('4', '0', '3', '13', 'Colors', 'Colors', '1230', '307.5', '1', 'Bags', '0', '0', '1', '10'),
('5', '0', '2', '10', 'Colors', 'Colors', '1230', '307.5', '1', 'Bags', '0', '0', '0', '4'),
('6', '0', '4', '13', 'Marbel', 'Marbel', '0', '0', '21', 'Ton', '0', '0', '21', '14'),
('7', '0', '3', '10', 'Marbel', 'Marbel', '0', '0', '21', 'Ton', '0', '0', '0', '6'),
('8', '0', '5', '13', 'Colors', 'Colors', '1230', '307.5', '1', 'Bags', '0', '0', '0', '15'),
('9', '0', '6', '13', 'Colors', 'Colors', '1230', '307.5', '1', 'Bags', '0', '0', '0', '16'),
('10', '0', '7', '13', 'Colors', 'Colors', '1230', '307.5', '11', 'Bags', '0', '0', '0', '17');

### Structure of table `0_consignors_master` ###

DROP TABLE IF EXISTS `0_consignors_master`;

CREATE TABLE `0_consignors_master` (
  `consignor_no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `consignor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tin_no` varchar(20) NOT NULL,
  `contact_name` varchar(60) NOT NULL DEFAULT '',
  `phone` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `default_location` int(11) NOT NULL DEFAULT '1',
  `default_ship_via` int(11) NOT NULL DEFAULT '1',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`consignor_no`),
  UNIQUE KEY `consignor_ref` (`consignor_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 ;

### Data of table `0_consignors_master` ###

INSERT INTO `0_consignors_master` VALUES
('5', 'sdaas', 'sda', 'asdasdjschai \nvibhag', '2130', 'gcbcb', '0', '', '2', '1', '', '0'),
('6', 'Avinash', 'Senads', 'adask.asd\nas', '482349283492859', 'adsas', '0', 'adarshsomani64@gmail.com', '2', '1', '', '0'),
('7', 'Adash', 'sdadf', NULL, '', 'ddkadskdas', '0', '', '18', '1', '', '0');

### Structure of table `0_credit_status` ###

DROP TABLE IF EXISTS `0_credit_status`;

CREATE TABLE `0_credit_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason_description` char(100) NOT NULL DEFAULT '',
  `dissallow_invoices` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_credit_status` ###

INSERT INTO `0_credit_status` VALUES
('1', 'Good History', '0', '0'),
('3', 'No more work until payment received', '1', '0'),
('4', 'In liquidation', '1', '0');

### Structure of table `0_crm_categories` ###

DROP TABLE IF EXISTS `0_crm_categories`;

CREATE TABLE `0_crm_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'pure technical key',
  `type` varchar(20) NOT NULL COMMENT 'contact type e.g. consignor',
  `action` varchar(20) NOT NULL COMMENT 'detailed usage e.g. department',
  `name` varchar(30) NOT NULL COMMENT 'for category selector',
  `description` tinytext NOT NULL COMMENT 'usage description',
  `system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'nonzero for core system usage',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`action`),
  UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1 ;

### Data of table `0_crm_categories` ###

INSERT INTO `0_crm_categories` VALUES
('1', 'consignor_branch', 'general', 'General', 'General contact data for consignor branch (overrides company setting)', '1', '0'),
('2', 'consignor_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', '1', '0'),
('3', 'consignor_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', '1', '0'),
('4', 'consignor_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', '1', '0'),
('5', 'consignor', 'general', 'General', 'General contact data for consignor', '1', '0'),
('6', 'consignor', 'order', 'Orders', 'Order confirmation', '1', '0'),
('7', 'consignor', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('8', 'consignor', 'invoice', 'Invoices', 'Invoice posting', '1', '0'),
('9', 'supplier', 'general', 'General', 'General contact data for supplier', '1', '0'),
('10', 'supplier', 'order', 'Orders', 'Order confirmation', '1', '0'),
('11', 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('12', 'supplier', 'invoice', 'Invoices', 'Invoice posting', '1', '0'),
('13', 'consignee_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', '1', '0'),
('14', 'consignee_branch', 'general', 'General', 'General contact data for consignor branch (overrides company setting)', '1', '0'),
('15', 'consignee_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', '1', '0'),
('16', 'consignee_branch', 'order', 'Orders', 'Order Confirmation', '1', '0');

### Structure of table `0_crm_contacts` ###

DROP TABLE IF EXISTS `0_crm_contacts`;

CREATE TABLE `0_crm_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL DEFAULT '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) DEFAULT NULL COMMENT 'entity id in related class table',
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=latin1 ;

### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES
('1', '1', 'consignor', 'general', '1'),
('2', '2', 'consignor', 'general', '2'),
('5', '5', 'consignor_branch', 'general', '2'),
('7', '7', 'supplier', 'general', '1'),
('8', '8', 'supplier', 'general', '2'),
('9', '9', 'supplier', 'general', '3'),
('10', '10', 'consignor_branch', 'general', '4'),
('13', '11', 'consignor', 'general', '5'),
('14', '12', 'consignor_branch', 'general', '6'),
('15', '13', 'consignee_branch', 'general', '5'),
('16', '14', 'consignor_branch', 'general', '7'),
('17', '14', 'consignor', 'general', '6'),
('18', '15', 'consignor_branch', 'general', '8'),
('19', '15', 'consignor', 'general', '7'),
('20', '16', 'consignee_branch', 'general', '6'),
('21', '16', 'consignee', 'general', '8'),
('22', '17', 'consignee_branch', 'general', '7'),
('23', '18', 'consignee_branch', 'general', '8'),
('24', '19', 'consignee_branch', 'general', '9'),
('26', '20', 'consignee', 'general', '9'),
('27', '21', 'consignee_branch', 'general', '11'),
('28', '22', 'consignor_branch', 'general', '9'),
('29', '22', 'consignor', 'general', '8'),
('30', '20', 'consignee_branch', 'general', '10'),
('31', '6', 'consignor_branch', 'delivery', '3'),
('32', '6', 'consignor_branch', 'general', '3'),
('33', '6', 'consignor_branch', 'invoice', '3'),
('34', '6', 'consignor_branch', 'order', '3'),
('38', '23', 'consignee_branch', 'delivery', '3'),
('39', '23', 'consignee_branch', 'general', '3'),
('40', '23', 'consignee_branch', 'invoice', '3'),
('41', '23', 'consignee_branch', 'order', '3'),
('43', '24', 'consignor', 'general', '1'),
('45', '25', 'consignee', 'general', '1'),
('46', '26', 'consignor_branch', 'general', '2'),
('47', '26', 'consignor', 'general', '1'),
('49', '27', 'consignee', 'general', '1'),
('50', '28', 'consignee_branch', 'general', '2'),
('51', '28', 'consignee', 'general', '2'),
('63', '1', 'consignor_branch', 'general', '3'),
('64', '1', 'consignor', 'general', '2'),
('65', '1', 'consignor_branch', 'general', '4'),
('67', '2', 'consignor_branch', 'general', '5'),
('69', '1', 'consignor_branch', 'general', '6'),
('70', '1', 'consignor', 'general', '5'),
('72', '2', 'consignee', 'general', '3'),
('73', '3', 'consignor_branch', 'general', '7'),
('74', '3', 'consignor', 'general', '6'),
('75', '4', 'consignee_branch', 'general', '2'),
('76', '5', 'consignor_branch', 'general', '8'),
('77', '5', 'consignor', 'general', '7'),
('78', '6', 'consignor_branch', 'general', '9'),
('79', '6', 'consignor', 'general', '8'),
('80', '7', 'consignee_branch', 'general', '3'),
('81', '7', 'consignee', 'general', '4'),
('82', '8', 'consignor_branch', 'general', '10'),
('83', '8', 'consignor', 'general', '9'),
('84', '9', 'consignor_branch', 'general', '11'),
('85', '9', 'consignor', 'general', '10'),
('86', '10', 'consignor_branch', 'general', '12'),
('87', '10', 'consignor', 'general', '11'),
('88', '1', 'consignor_branch', 'general', '13'),
('89', '1', 'consignor', 'general', '12'),
('90', '1', 'consignor_branch', 'general', '1'),
('91', '1', 'consignor', 'general', '1'),
('92', '2', 'consignee_branch', 'general', '1'),
('93', '2', 'consignee', 'general', '1'),
('94', '3', 'consignor_branch', 'general', '2'),
('95', '3', 'consignor', 'general', '2'),
('96', '4', 'consignor_branch', 'general', '3'),
('97', '4', 'consignor', 'general', '3'),
('98', '5', 'consignor', 'general', '4'),
('99', '7', 'consignor', 'general', '5'),
('100', '8', 'consignor', 'general', '6'),
('101', '9', 'consignor', 'general', '7');

### Structure of table `0_crm_persons` ###

DROP TABLE IF EXISTS `0_crm_persons`;

CREATE TABLE `0_crm_persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(30) NOT NULL,
  `name` varchar(60) NOT NULL,
  `name2` varchar(60) DEFAULT NULL,
  `address` tinytext,
  `phone` varchar(30) DEFAULT NULL,
  `phone2` varchar(30) DEFAULT NULL,
  `fax` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `lang` char(5) DEFAULT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ref` (`ref`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 ;

### Data of table `0_crm_persons` ###

INSERT INTO `0_crm_persons` VALUES
('1', 'sarang', 'sarang', NULL, 'fdj', NULL, NULL, NULL, NULL, NULL, '', '0'),
('2', 'ankita', 'ankita', NULL, 'sfdhs', NULL, NULL, NULL, NULL, NULL, '', '0'),
('3', 'Adarsh', 'dad', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('4', 'Gopalbari', 'Gopalbari', NULL, 'Jaipur\nJaipur\nRajasthan\nIndia\n302001\n', NULL, NULL, NULL, NULL, NULL, '', '0'),
('5', 'sdf', 'sdf', NULL, 'sfd', 'sdf', NULL, NULL, NULL, NULL, '', '0'),
('6', '', '', NULL, 'rere', NULL, NULL, NULL, NULL, NULL, '', '0'),
('7', 'sdaas', 'sda', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('8', 'Avinash', 'Sen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('9', 'Adash', 'sdadf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');

### Structure of table `0_currencies` ###

DROP TABLE IF EXISTS `0_currencies`;

CREATE TABLE `0_currencies` (
  `currency` varchar(60) NOT NULL DEFAULT '',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `curr_symbol` varchar(10) NOT NULL DEFAULT '',
  `country` varchar(100) NOT NULL DEFAULT '',
  `hundreds_name` varchar(15) NOT NULL DEFAULT '',
  `auto_update` tinyint(1) NOT NULL DEFAULT '1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`curr_abrev`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES
('US Dollars', 'USD', '$', 'United States', 'Cents', '1', '0'),
('CA Dollars', 'CAD', '$', 'Canada', 'Cents', '1', '0'),
('Euro', 'EUR', '?', 'Europe', 'Cents', '1', '0'),
('Pounds', 'GBP', '?', 'England', 'Pence', '1', '0'),
('DK Kroner', 'DKK', '?', 'Denmark', 'Ore', '1', '0'),
('Rupees', 'INR', 'Rs', 'India', 'Paisa', '1', '0');

### Structure of table `0_dashboard_reminders` ###

DROP TABLE IF EXISTS `0_dashboard_reminders`;

CREATE TABLE `0_dashboard_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `next_date` date NOT NULL,
  `description` text,
  `frequency` varchar(20) NOT NULL,
  `param` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

### Data of table `0_dashboard_reminders` ###


### Structure of table `0_dashboard_widgets` ###

DROP TABLE IF EXISTS `0_dashboard_widgets`;

CREATE TABLE `0_dashboard_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `app` varchar(50) NOT NULL,
  `column_id` int(11) NOT NULL,
  `sort_no` int(11) NOT NULL,
  `collapsed` tinyint(4) NOT NULL,
  `widget` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `param` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 ;

### Data of table `0_dashboard_widgets` ###

INSERT INTO `0_dashboard_widgets` VALUES
('1', '1', 'AP', '1', '1', '0', 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}'),
('2', '1', 'AP', '1', '0', '0', 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('3', '1', 'AP', '2', '1', '0', 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('6', '1', 'AP', '2', '0', '0', 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}'),
('7', '1', 'orders', '1', '1', '1', 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}'),
('9', '1', 'orders', '1', '0', '0', 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}'),
('10', '1', 'AP', '1', '0', '0', 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}'),
('11', '1', 'AP', '2', '0', '0', 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}'),
('12', '1', 'GL', '2', '1', '0', 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('13', '1', 'GL', '2', '0', '0', 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('14', '1', 'stock', '1', '0', '0', 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('15', '1', 'stock', '0', '0', '0', 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('16', '1', 'manuf', '1', '0', '0', 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('17', '1', 'manuf', '2', '0', '0', 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('18', '1', 'orders', '2', '0', '0', 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}'),
('19', '1', 'GL', '2', '2', '0', 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}'),
('20', '1', 'GL', '1', '1', '0', 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}'),
('21', '1', 'GL', '1', '0', '0', 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('22', '2', 'AP', '1', '1', '0', 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}'),
('23', '2', 'AP', '1', '0', '0', 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('24', '2', 'AP', '2', '1', '0', 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('25', '2', 'AP', '2', '0', '0', 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}'),
('26', '2', 'orders', '1', '0', '0', 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}'),
('27', '2', 'orders', '1', '1', '0', 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}'),
('28', '2', 'AP', '1', '0', '0', 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}'),
('29', '2', 'AP', '2', '0', '0', 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}'),
('30', '2', 'GL', '2', '1', '0', 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('31', '2', 'GL', '2', '0', '0', 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('32', '2', 'stock', '1', '0', '0', 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('33', '2', 'stock', '2', '0', '0', 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('34', '2', 'manuf', '1', '0', '0', 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('35', '2', 'manuf', '2', '0', '0', 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('36', '2', 'orders', '2', '0', '0', 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}'),
('37', '2', 'GL', '2', '2', '0', 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}'),
('38', '2', 'GL', '1', '1', '0', 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}'),
('39', '2', 'GL', '1', '0', '0', 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('40', '1', 'stock', '1', '1', '0', 'odometer', 'Odometer Readings', '{&quot;top&quot;:&quot;20&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}'),
('41', '1', 'manuf', '0', '0', '0', 'maintenance', '', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');

### Structure of table `0_dimensions` ###

DROP TABLE IF EXISTS `0_dimensions`;

CREATE TABLE `0_dimensions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(60) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `type_` tinyint(1) NOT NULL DEFAULT '1',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `date_` (`date_`),
  KEY `due_date` (`due_date`),
  KEY `type_` (`type_`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_dimensions` ###

INSERT INTO `0_dimensions` VALUES
('1', '1', 'Support', '1', '0', '2009-06-21', '2015-07-11'),
('2', '2', 'Development', '1', '0', '2009-06-21', '2015-07-11');

### Structure of table `0_driver_trans` ###

DROP TABLE IF EXISTS `0_driver_trans`;

CREATE TABLE `0_driver_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `driver_no` int(11) unsigned DEFAULT NULL,
  `branch_code` int(11) NOT NULL DEFAULT '-1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `tpe` int(11) NOT NULL DEFAULT '0',
  `order_` int(11) NOT NULL DEFAULT '0',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `ov_freight` double NOT NULL DEFAULT '0',
  `ov_freight_tax` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ship_via` int(11) DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  PRIMARY KEY (`type`,`trans_no`),
  KEY `driver_no` (`driver_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_driver_trans` ###


### Structure of table `0_driver_trans_details` ###

DROP TABLE IF EXISTS `0_driver_trans_details`;

CREATE TABLE `0_driver_trans_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `driver_trans_no` int(11) DEFAULT NULL,
  `driver_trans_type` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `qty_done` double NOT NULL DEFAULT '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`driver_trans_type`,`driver_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_driver_trans_details` ###


### Structure of table `0_drivers_master` ###

DROP TABLE IF EXISTS `0_drivers_master`;

CREATE TABLE `0_drivers_master` (
  `driver_no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `driver_birth_date` date DEFAULT NULL,
  `hired_on` date DEFAULT NULL,
  `licence_no` varchar(100) DEFAULT NULL,
  `mobile_no` bigint(20) DEFAULT NULL,
  `health_exam_ref` varchar(100) DEFAULT NULL,
  `date_of_checkup` date DEFAULT NULL,
  `driver_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `curr_code` char(3) DEFAULT '',
  `payment_terms` int(11) DEFAULT NULL,
  `rate` decimal(10,2) NOT NULL,
  `notes` tinytext,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`driver_no`),
  UNIQUE KEY `driver_ref` (`driver_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_drivers_master` ###

INSERT INTO `0_drivers_master` VALUES
('1', 'Adarsh', '0000-00-00', '0000-00-00', NULL, '9328438493', NULL, '0000-00-00', 'adarsh', NULL, '', NULL, '0.00', NULL, '0'),
('2', 'Prabha', '0000-00-00', '0000-00-00', '89', '9999999', '99', '0000-00-00', 'Prabha', 'asd', '', NULL, '1.00', 'test', '0'),
('3', 'dsa', '0000-00-00', '0000-00-00', NULL, '0', NULL, '0000-00-00', 'dsa', NULL, '', NULL, '0.00', NULL, '0');

### Structure of table `0_exchange_rates` ###

DROP TABLE IF EXISTS `0_exchange_rates`;

CREATE TABLE `0_exchange_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curr_code` char(3) NOT NULL DEFAULT '',
  `rate_buy` double NOT NULL DEFAULT '0',
  `rate_sell` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ;

### Data of table `0_exchange_rates` ###

INSERT INTO `0_exchange_rates` VALUES
('1', 'DKK', '0.18717252868313', '0.18717252868313', '2009-06-21'),
('2', 'GBP', '1.6445729799917', '1.6445729799917', '2009-06-21'),
('3', 'EUR', '1.3932', '1.3932', '2009-06-21'),
('4', 'GBP', '1.6446', '1.6446', '2013-12-31'),
('5', 'EUR', '1.3932', '1.3932', '2013-12-31'),
('6', 'USD', '61.929978467182', '61.929978467182', '2014-11-20');

### Structure of table `0_fiscal_year` ###

DROP TABLE IF EXISTS `0_fiscal_year`;

CREATE TABLE `0_fiscal_year` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `begin` date DEFAULT '0000-00-00',
  `end` date DEFAULT '0000-00-00',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ;

### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES
('1', '2008-01-01', '2008-12-31', '1'),
('2', '2009-01-01', '2009-12-31', '1'),
('3', '2010-01-01', '2010-12-31', '1'),
('4', '2011-01-01', '2011-12-31', '1'),
('5', '2012-01-01', '2012-12-31', '1'),
('6', '2013-01-01', '2013-12-31', '1'),
('7', '2014-01-01', '2014-12-31', '1'),
('8', '2015-01-01', '2015-12-31', '0');

### Structure of table `0_fuel_types` ###

DROP TABLE IF EXISTS `0_fuel_types`;

CREATE TABLE `0_fuel_types` (
  `fuel_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `fuel_description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fuel_type_code`),
  UNIQUE KEY `description` (`fuel_description`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ;

### Data of table `0_fuel_types` ###

INSERT INTO `0_fuel_types` VALUES
('5', 'sdaads', '0'),
('6', 'Gasoline', '0');

### Structure of table `0_fuel_weight_types` ###

DROP TABLE IF EXISTS `0_fuel_weight_types`;

CREATE TABLE `0_fuel_weight_types` (
  `fuel_weight_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `fuel_weight_description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fuel_weight_type_code`),
  UNIQUE KEY `description` (`fuel_weight_description`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_fuel_weight_types` ###

INSERT INTO `0_fuel_weight_types` VALUES
('5', 'dsads', '0');

### Structure of table `0_gl_trans` ###

DROP TABLE IF EXISTS `0_gl_trans`;

CREATE TABLE `0_gl_trans` (
  `counter` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `type_no` bigint(16) NOT NULL DEFAULT '1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `account` varchar(15) NOT NULL DEFAULT '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL DEFAULT '0',
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `person_type_id` int(11) DEFAULT NULL,
  `person_id` tinyblob,
  PRIMARY KEY (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `dimension_id` (`dimension_id`),
  KEY `dimension2_id` (`dimension2_id`),
  KEY `tran_date` (`tran_date`),
  KEY `account_and_tran_date` (`account`,`tran_date`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 ;

### Data of table `0_gl_trans` ###

INSERT INTO `0_gl_trans` VALUES
('1', '10', '1', '2014-12-30', '4010', '', '-1072', '0', '0', '2', '1'),
('2', '10', '1', '2014-12-30', '1060', '', '1340', '0', '0', '2', '1'),
('3', '10', '1', '2014-12-30', '2150', '', '-214.4', '0', '0', '2', '1'),
('4', '10', '1', '2014-12-30', '1060', '', '-53.6', '0', '0', '2', '1'),
('5', '12', '1', '2014-12-30', '1065', '', '1340', '0', '0', '2', '1'),
('6', '12', '1', '2014-12-30', '1060', '', '-1340', '0', '0', '2', '1'),
('7', '12', '2', '2014-12-31', '1060', '', '34234', '0', '0', '2', '1'),
('8', '12', '2', '2014-12-31', '1060', '', '-34234', '0', '0', '2', '1'),
('9', '10', '2', '2014-03-20', '4010', '', '-1230', '0', '0', '2', '1'),
('10', '10', '2', '2014-03-20', '1060', '', '2767.5', '0', '0', '2', '1'),
('11', '10', '2', '2014-03-20', '4430', '', '-1230', '0', '0', '2', '1'),
('12', '10', '2', '2014-03-20', '2150', '', '-246', '0', '0', '2', '1'),
('13', '10', '2', '2014-03-20', '1060', '', '-61.5', '0', '0', '2', '1'),
('14', '12', '3', '2014-03-20', '1065', '', '2767.5', '0', '0', '2', '1'),
('15', '12', '3', '2014-03-20', '1060', '', '-2767.5', '0', '0', '2', '1'),
('16', '12', '4', '2014-03-23', '1065', '', '0', '0', '0', '2', '1'),
('17', '0', '1', '2014-12-31', '3590', 'Closing Year', '-3532', '0', '0', NULL, NULL),
('18', '0', '1', '2014-12-31', '9990', 'Closing Year', '3532', '0', '0', NULL, NULL),
('19', '1', '1', '2015-05-12', '5100', '', '230', '0', '0', '3', NULL),
('20', '1', '1', '2015-05-12', '1060', '', '-230', '0', '0', '3', NULL),
('21', '2', '1', '2015-07-18', '1200', '', '-12340', '0', '0', '2', '2'),
('22', '2', '1', '2015-07-18', '1060', '', '12340', '0', '0', '2', '2');

### Structure of table `0_grn_batch` ###

DROP TABLE IF EXISTS `0_grn_batch`;

CREATE TABLE `0_grn_batch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `purch_order_no` int(11) DEFAULT NULL,
  `reference` varchar(60) NOT NULL DEFAULT '',
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `loc_code` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_grn_batch` ###


### Structure of table `0_grn_items` ###

DROP TABLE IF EXISTS `0_grn_items`;

CREATE TABLE `0_grn_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grn_batch_id` int(11) DEFAULT NULL,
  `po_detail_item` int(11) NOT NULL DEFAULT '0',
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `qty_recd` double NOT NULL DEFAULT '0',
  `quantity_inv` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_grn_items` ###


### Structure of table `0_groups` ###

DROP TABLE IF EXISTS `0_groups`;

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_groups` ###

INSERT INTO `0_groups` VALUES
('1', 'Small', '0'),
('2', 'Medium', '0'),
('3', 'Large', '0');

### Structure of table `0_item_codes` ###

DROP TABLE IF EXISTS `0_item_codes`;

CREATE TABLE `0_item_codes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) NOT NULL,
  `stock_id` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL DEFAULT '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_item_codes` ###


### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_item_tax_type_exemptions` ###


### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `exempt` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES
('1', 'Regular', '0', '0');

### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES
('ea.', 'Each', '0', '0'),
('hrs', 'Hours', '1', '0'),
('Ltr', 'Ltr', '2', '0'),
('Gallons', 'Gallons', '-1', '0'),
('Bags', 'Bags', '0', '0'),
('Kg', 'Kg', '2', '0'),
('Ton', 'Ton', '3', '0'),
('Qt', 'Quintal', '2', '0'),
('Box', 'Box', '0', '0'),
('sqft', 'sqft', '2', '0'),
('sqmt', 'sqmt', '2', '0'),
('cc', 'cube', '2', '0');

### Structure of table `0_load_status` ###

DROP TABLE IF EXISTS `0_load_status`;

CREATE TABLE `0_load_status` (
  `load_status_code` int(11) NOT NULL AUTO_INCREMENT,
  `load_status_name` varchar(60) NOT NULL DEFAULT '',
  `load_status_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`load_status_code`),
  KEY `load_status_name` (`load_status_name`),
  KEY `load_status_by_type` (`load_status_type`,`load_status_code`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 ;

### Data of table `0_load_status` ###

INSERT INTO `0_load_status` VALUES
('2', 'Booked', '1', '0'),
('3', 'Need Carrier', '1', '0'),
('4', 'Loading Awaited', '2', '0'),
('5', 'Ready To Dispatch', '2', '0'),
('6', 'In transit', '3', '0'),
('8', 'Stopped', '3', '0'),
('9', 'Delivered', '4', '0'),
('10', 'To be Billed', '5', '0'),
('11', 'Billed', '5', '0'),
('12', 'Paid', '5', '0'),
('13', 'Just to Try', '1', '0'),
('14', 'Billed', '5', '0');

### Structure of table `0_load_status_group_types` ###

DROP TABLE IF EXISTS `0_load_status_group_types`;

CREATE TABLE `0_load_status_group_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_load_status_group_types` ###

INSERT INTO `0_load_status_group_types` VALUES
('1', 'Booked', '0'),
('2', 'Loading', '0'),
('3', 'In Transit', '0'),
('4', 'Delivered', '0'),
('5', 'Accountable', '0');

### Structure of table `0_loc_stock` ###

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
  `loc_code` int(11) NOT NULL DEFAULT '1',
  `vehicle_id` int(11) NOT NULL,
  `reorder_level` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`,`vehicle_id`),
  KEY `stock_id` (`vehicle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_loc_stock` ###

INSERT INTO `0_loc_stock` VALUES
('2', '0', '0'),
('2', '8032', '0'),
('2', '8033', '0'),
('7', '0', '0'),
('7', '8032', '0'),
('7', '8033', '0'),
('8', '0', '0'),
('8', '8032', '0'),
('8', '8033', '0'),
('9', '0', '0'),
('9', '8032', '0'),
('9', '8033', '0'),
('10', '0', '0'),
('10', '8032', '0'),
('10', '8033', '0'),
('11', '0', '0'),
('11', '8032', '0'),
('11', '8033', '0'),
('12', '0', '0'),
('12', '8032', '0'),
('12', '8033', '0'),
('13', '0', '0'),
('13', '8032', '0'),
('13', '8033', '0'),
('14', '0', '0'),
('14', '8032', '0'),
('14', '8033', '0'),
('15', '0', '0'),
('15', '8032', '0'),
('15', '8033', '0'),
('16', '0', '0'),
('16', '8032', '0'),
('16', '8033', '0'),
('17', '0', '0'),
('17', '8032', '0'),
('17', '8033', '0'),
('18', '0', '0'),
('18', '8032', '0'),
('18', '8033', '0'),
('19', '8033', '0');

### Structure of table `0_locations` ###

DROP TABLE IF EXISTS `0_locations`;

CREATE TABLE `0_locations` (
  `loc_code` int(11) NOT NULL AUTO_INCREMENT,
  `location_name` varchar(60) NOT NULL DEFAULT '',
  `delivery_address` tinytext NOT NULL,
  `phone` varchar(30) NOT NULL DEFAULT '',
  `phone2` varchar(30) NOT NULL DEFAULT '',
  `fax` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `contact` varchar(30) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 ;

### Data of table `0_locations` ###

INSERT INTO `0_locations` VALUES
('2', 'Adarsh Somani', 'dsasad', '', '', '', '', '', '0'),
('7', 'asd', 'asd', '', '', '', '', 'ads', '0'),
('8', 'asd', 'asddassda', '', '', '', '', 'ads', '0'),
('9', 'asd', 'asdadsdasdsa', '', '', '', '', 'ads', '0'),
('10', 'asd', 'asddassdadsasd', '', '', '', '', 'adsasd', '0'),
('11', 'asd', 'asddassda', '', '', '', '', 'ads', '0'),
('12', 'asd', 'asdsadsadasd', '', '', '', '', 'ads', '0'),
('13', 'asd', 'asd', '', '', '', '', 'ads', '0'),
('14', 'Adarsh', 'dsasad', '', '', '', '', 'vccxvasdasd', '0'),
('15', 'Adarsh', 'dsasad', '', '', '', '', '', '0'),
('16', 'Adarsh', 'dsasad', '', '', '', '', 'sddsa', '0'),
('17', 'Adarsh', 'dsasad', '', '', '', '', '', '0'),
('18', 'Adarsh', 'dsasad', '', '', '', '', 'sad', '0'),
('19', 'sad', 'asd', '', '', '', '', 'sad', '0');

### Structure of table `0_movement_types` ###

DROP TABLE IF EXISTS `0_movement_types`;

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_movement_types` ###

INSERT INTO `0_movement_types` VALUES
('1', 'Adjustment', '0');

### Structure of table `0_odometer_data` ###

DROP TABLE IF EXISTS `0_odometer_data`;

CREATE TABLE `0_odometer_data` (
  `odometer_id` int(11) NOT NULL AUTO_INCREMENT,
  `category` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `odometer_reading` int(50) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `log_description` varchar(200) NOT NULL,
  `accident_id` int(10) NOT NULL,
  `wo_id` int(10) NOT NULL,
  PRIMARY KEY (`odometer_id`,`vehicle_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_odometer_data` ###

INSERT INTO `0_odometer_data` VALUES
('1', '0', '0', '12', '1', '2015-01-02', 'BANGA', '', '0', '0'),
('2', '0', '0', '123', '1', '2015-02-10', 'BANGA', '', '0', '0'),
('3', '0', '8019', '243', '1', '2015-10-28', '18', '', '0', '0');

### Structure of table `0_odometer_types` ###

DROP TABLE IF EXISTS `0_odometer_types`;

CREATE TABLE `0_odometer_types` (
  `odometer_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `odometer_description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`odometer_type_code`),
  UNIQUE KEY `description` (`odometer_description`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_odometer_types` ###

INSERT INTO `0_odometer_types` VALUES
('1', 'Km', '0');

### Structure of table `0_part` ###

DROP TABLE IF EXISTS `0_part`;

CREATE TABLE `0_part` (
  `part_code` int(11) NOT NULL AUTO_INCREMENT,
  `part_name` char(60) NOT NULL DEFAULT '',
  `part_type_desc` varchar(100) DEFAULT NULL,
  `part_no` varchar(100) NOT NULL DEFAULT '',
  `part_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `part_price_date` date NOT NULL,
  `vendor_ref` varchar(100) DEFAULT NULL,
  `part_manufacturer` varchar(200) DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`part_code`),
  UNIQUE KEY `part_name` (`part_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_part` ###


### Structure of table `0_part_types` ###

DROP TABLE IF EXISTS `0_part_types`;

CREATE TABLE `0_part_types` (
  `part_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `part_description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`part_type_code`),
  UNIQUE KEY `description` (`part_description`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_part_types` ###

INSERT INTO `0_part_types` VALUES
('2', 'dasbkdsa', '0'),
('3', 'dddd', '0');

### Structure of table `0_pay_items_group_types` ###

DROP TABLE IF EXISTS `0_pay_items_group_types`;

CREATE TABLE `0_pay_items_group_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_pay_items_group_types` ###

INSERT INTO `0_pay_items_group_types` VALUES
('Flat', 'Flat', '0');

### Structure of table `0_payment_terms` ###

DROP TABLE IF EXISTS `0_payment_terms`;

CREATE TABLE `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL AUTO_INCREMENT,
  `terms` char(80) NOT NULL DEFAULT '',
  `days_before_due` smallint(6) NOT NULL DEFAULT '0',
  `day_in_following_month` smallint(6) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES
('1', 'Due 15th Of the Following Month', '0', '17', '0'),
('2', 'Due By End Of The Following Month', '0', '30', '0'),
('3', 'Payment due within 10 days', '10', '0', '0'),
('4', 'Cash Only', '0', '0', '0'),
('5', 'bkj', '0', '0', '0');

### Structure of table `0_prices` ###

DROP TABLE IF EXISTS `0_prices`;

CREATE TABLE `0_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `transport_type_id` int(11) NOT NULL DEFAULT '0',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `price` (`stock_id`,`transport_type_id`,`curr_abrev`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_prices` ###

INSERT INTO `0_prices` VALUES
('1', '3400', '1', 'USD', '100'),
('2', '102', '1', 'USD', '50'),
('3', '103', '1', 'USD', '55'),
('4', '104', '1', 'USD', '60');

### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) DEFAULT NULL,
  `printer` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 ;

### Data of table `0_print_profiles` ###

INSERT INTO `0_print_profiles` VALUES
('1', 'Out of office', NULL, '0'),
('2', 'Sales Department', NULL, '0'),
('3', 'Central', NULL, '2'),
('4', 'Sales Department', '104', '2'),
('5', 'Sales Department', '105', '2'),
('6', 'Sales Department', '107', '2'),
('7', 'Sales Department', '109', '2'),
('8', 'Sales Department', '110', '2'),
('9', 'Sales Department', '201', '2');

### Structure of table `0_printers` ###

DROP TABLE IF EXISTS `0_printers`;

CREATE TABLE `0_printers` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_printers` ###

INSERT INTO `0_printers` VALUES
('1', 'QL500', 'Label printer', 'QL500', 'server', '127', '20'),
('2', 'Samsung', 'Main network printer', 'scx4521F', 'server', '515', '5'),
('3', 'Local', 'Local print server at user IP', 'lp', '', '515', '10');

### Structure of table `0_purch_data` ###

DROP TABLE IF EXISTS `0_purch_data`;

CREATE TABLE `0_purch_data` (
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  `suppliers_uom` char(50) NOT NULL DEFAULT '',
  `conversion_factor` double NOT NULL DEFAULT '1',
  `supplier_description` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`supplier_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_purch_data` ###


### Structure of table `0_purch_order_details` ###

DROP TABLE IF EXISTS `0_purch_order_details`;

CREATE TABLE `0_purch_order_details` (
  `po_detail_item` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `qty_invoiced` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `act_price` double NOT NULL DEFAULT '0',
  `std_cost_unit` double NOT NULL DEFAULT '0',
  `quantity_ordered` double NOT NULL DEFAULT '0',
  `quantity_received` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`po_detail_item`),
  KEY `order` (`order_no`,`po_detail_item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_purch_order_details` ###


### Structure of table `0_purch_orders` ###

DROP TABLE IF EXISTS `0_purch_orders`;

CREATE TABLE `0_purch_orders` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `comments` tinytext,
  `ord_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` tinytext NOT NULL,
  `requisition_no` tinytext,
  `into_stock_location` int(11) NOT NULL DEFAULT '1',
  `delivery_address` tinytext NOT NULL,
  `total` double NOT NULL DEFAULT '0',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`order_no`),
  KEY `ord_date` (`ord_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_purch_orders` ###


### Structure of table `0_quick_entries` ###

DROP TABLE IF EXISTS `0_quick_entries`;

CREATE TABLE `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(60) NOT NULL,
  `base_amount` double NOT NULL DEFAULT '0',
  `base_desc` varchar(60) DEFAULT NULL,
  `bal_type` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_quick_entries` ###

INSERT INTO `0_quick_entries` VALUES
('1', '1', 'Maintenance', '0', 'Amount', '0'),
('2', '4', 'Phone', '0', 'Amount', '0'),
('3', '2', 'Cash Sales', '0', 'Amount', '0');

### Structure of table `0_quick_entry_lines` ###

DROP TABLE IF EXISTS `0_quick_entry_lines`;

CREATE TABLE `0_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double DEFAULT '0',
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` smallint(6) unsigned DEFAULT NULL,
  `dimension2_id` smallint(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qid` (`qid`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 ;

### Data of table `0_quick_entry_lines` ###

INSERT INTO `0_quick_entry_lines` VALUES
('1', '1', '0', 't-', '1', '0', '0'),
('2', '2', '0', 't-', '1', '0', '0'),
('3', '3', '0', 't-', '1', '0', '0'),
('4', '3', '0', '=', '4010', '0', '0'),
('5', '1', '0', '=', '5765', '0', '0'),
('6', '2', '0', '=', '5780', '0', '0');

### Structure of table `0_recurrent_invoices` ###

DROP TABLE IF EXISTS `0_recurrent_invoices`;

CREATE TABLE `0_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `order_no` int(11) unsigned NOT NULL,
  `consignor_no` int(11) unsigned DEFAULT NULL,
  `consignee_no` int(11) DEFAULT NULL,
  `group_no` smallint(6) unsigned DEFAULT NULL,
  `days` int(11) NOT NULL DEFAULT '0',
  `monthly` int(11) NOT NULL DEFAULT '0',
  `begin` date NOT NULL DEFAULT '0000-00-00',
  `end` date NOT NULL DEFAULT '0000-00-00',
  `last_sent` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_recurrent_invoices` ###


### Structure of table `0_refs` ###

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_refs` ###

INSERT INTO `0_refs` VALUES
('18', '0', '1'),
('19', '0', '2'),
('21', '0', '3'),
('22', '0', '4'),
('23', '0', '5'),
('24', '0', '6'),
('1', '0', '7'),
('2', '0', '8'),
('3', '0', '9'),
('9', '1', '2'),
('1', '1', '3'),
('6', '2', '2'),
('1', '2', '3'),
('1', '4', '4'),
('2', '4', '5'),
('3', '4', '6'),
('26', '10', '10'),
('27', '10', '11'),
('19', '10', '117'),
('20', '10', '118'),
('21', '10', '119'),
('10', '10', '131'),
('11', '10', '132'),
('12', '10', '133'),
('13', '10', '134'),
('14', '10', '135'),
('15', '10', '136'),
('16', '10', '137'),
('17', '10', '138'),
('18', '10', '139'),
('4', '10', '143'),
('5', '10', '144'),
('6', '10', '145'),
('7', '10', '146'),
('8', '10', '147'),
('9', '10', '148'),
('1', '10', '150'),
('2', '10', '151'),
('3', '10', '152'),
('22', '10', '33'),
('23', '10', '7'),
('24', '10', '8'),
('25', '10', '9'),
('3', '11', '13'),
('1', '11', '14'),
('2', '11', '15'),
('4', '11', '2'),
('5', '12', '101'),
('6', '12', '102'),
('7', '12', '103'),
('8', '12', '104'),
('9', '12', '105'),
('10', '12', '106'),
('1', '12', '108'),
('2', '12', '109'),
('3', '12', '110'),
('4', '12', '111'),
('11', '12', '87'),
('12', '12', '88'),
('13', '12', '89'),
('14', '12', '90'),
('15', '12', '91'),
('16', '12', '92'),
('17', '12', '93'),
('18', '12', '94'),
('19', '12', '95'),
('20', '12', '96'),
('1', '13', '100'),
('2', '13', '101'),
('3', '13', '102'),
('4', '13', '103'),
('5', '13', '104'),
('6', '13', '105'),
('7', '13', '106'),
('24', '13', '17'),
('25', '13', '18'),
('26', '13', '19'),
('28', '13', '20'),
('19', '13', '56'),
('20', '13', '57'),
('21', '13', '58'),
('22', '13', '59'),
('23', '13', '60'),
('17', '13', '80'),
('18', '13', '81'),
('8', '13', '90'),
('9', '13', '91'),
('10', '13', '92'),
('11', '13', '93'),
('12', '13', '94'),
('13', '13', '95'),
('14', '13', '96'),
('15', '13', '97'),
('16', '13', '98'),
('27', '13', 'auto'),
('29', '13', 'auto'),
('3', '16', ''),
('4', '16', ''),
('6', '16', ''),
('1', '16', '15'),
('2', '16', '16'),
('5', '16', '2'),
('1', '17', '1'),
('2', '17', '2'),
('3', '17', '3'),
('4', '17', '4'),
('3', '18', '3'),
('5', '18', '4'),
('7', '18', '5'),
('9', '18', '6'),
('1', '18', 'auto'),
('2', '18', 'auto'),
('4', '18', 'auto'),
('6', '18', 'auto'),
('8', '18', 'auto'),
('10', '18', 'auto'),
('11', '18', 'auto'),
('12', '18', 'auto'),
('13', '18', 'auto'),
('14', '18', 'auto'),
('16', '20', '10'),
('2', '20', '13'),
('1', '20', '14'),
('9', '20', '3'),
('10', '20', '4'),
('11', '20', '5'),
('12', '20', '6'),
('13', '20', '7'),
('14', '20', '8'),
('15', '20', '9'),
('5', '22', '2'),
('6', '22', '3'),
('7', '22', '4'),
('3', '25', '3'),
('1', '25', 'auto'),
('2', '25', 'auto'),
('4', '25', 'auto'),
('5', '25', 'auto'),
('6', '25', 'auto'),
('7', '25', 'auto'),
('8', '25', 'auto'),
('9', '25', 'auto'),
('10', '25', 'auto'),
('11', '25', 'auto'),
('10', '26', '10'),
('11', '26', '11'),
('12', '26', '12'),
('13', '26', '13'),
('14', '26', '14'),
('15', '26', '15'),
('16', '26', '16'),
('17', '26', '17'),
('18', '26', '18'),
('19', '26', '19'),
('20', '26', '20'),
('21', '26', '21'),
('22', '26', '22'),
('23', '26', '23'),
('24', '26', '24'),
('25', '26', '25'),
('28', '26', '26'),
('32', '26', '27'),
('34', '26', '28'),
('36', '26', '29'),
('33', '26', '298'),
('37', '26', '30'),
('39', '26', '31'),
('40', '26', '32'),
('41', '26', '33'),
('42', '26', '34'),
('43', '26', '35'),
('44', '26', '36'),
('45', '26', '37'),
('46', '26', '38'),
('35', '26', '39'),
('47', '26', '39'),
('48', '26', '40'),
('49', '26', '41'),
('50', '26', '42'),
('51', '26', '43'),
('52', '26', '44'),
('29', '26', '45'),
('53', '26', '45'),
('54', '26', '46'),
('55', '26', '47'),
('56', '26', '48'),
('57', '26', '49'),
('58', '26', '50'),
('59', '26', '51'),
('60', '26', '52'),
('61', '26', '53'),
('30', '26', '535'),
('62', '26', '54'),
('63', '26', '55'),
('64', '26', '56'),
('65', '26', '57'),
('66', '26', '58'),
('67', '26', '59'),
('3', '26', '62'),
('4', '26', '63'),
('5', '26', '64'),
('6', '26', '65'),
('7', '26', '66'),
('8', '26', '67'),
('1', '26', '70'),
('2', '26', '71'),
('9', '26', '9'),
('31', '26', 'rewewr'),
('1', '28', '1'),
('2', '28', '2'),
('2', '29', '2'),
('10', '30', '125'),
('1', '30', '138'),
('2', '30', '139'),
('3', '30', '140'),
('4', '30', '141'),
('5', '30', '142'),
('6', '30', '143'),
('7', '30', '144'),
('8', '30', '145'),
('9', '30', '146'),
('29', '30', '24'),
('31', '30', '25'),
('11', '30', '71'),
('12', '30', '72'),
('13', '30', '73'),
('14', '30', '74'),
('15', '30', '75'),
('18', '30', '76'),
('19', '30', '77'),
('20', '30', '78'),
('21', '30', '79'),
('22', '30', '80'),
('23', '30', '81'),
('24', '30', '82'),
('25', '30', '83'),
('16', '30', 'auto'),
('17', '30', 'auto'),
('26', '30', 'auto'),
('27', '30', 'auto'),
('28', '30', 'auto'),
('30', '30', 'auto'),
('32', '30', 'auto'),
('1', '32', '113'),
('2', '32', '114'),
('3', '32', '115'),
('4', '32', '116'),
('5', '32', '117'),
('6', '32', '118'),
('7', '32', '119'),
('8', '32', '120'),
('9', '32', '121'),
('10', '32', '122'),
('11', '32', '123'),
('12', '32', '65'),
('13', '32', '66'),
('14', '32', '67'),
('15', '32', '68'),
('16', '32', '69'),
('17', '32', '70'),
('18', '32', '71'),
('19', '32', '72'),
('20', '32', '73'),
('21', '32', '74'),
('22', '32', '75'),
('23', '32', '76'),
('24', '32', '77'),
('25', '32', '78'),
('26', '32', '79'),
('27', '32', '80'),
('28', '32', '81'),
('29', '32', '82'),
('30', '32', '83'),
('31', '32', '84'),
('32', '32', '85'),
('16', '33', '151'),
('17', '33', '152'),
('18', '33', '153'),
('19', '33', '154'),
('20', '33', '155'),
('21', '33', '156'),
('22', '33', '157'),
('23', '33', '158'),
('24', '33', '159'),
('25', '33', '160'),
('26', '33', '161'),
('27', '33', '162'),
('28', '33', '164'),
('29', '33', '165'),
('30', '33', '166'),
('31', '33', '167'),
('32', '33', '168'),
('33', '33', '169'),
('34', '33', '170'),
('35', '33', '171'),
('36', '33', '172'),
('37', '33', '173'),
('38', '33', '174'),
('39', '33', '175'),
('40', '33', '176'),
('41', '33', '177'),
('42', '33', '178'),
('43', '33', '179'),
('45', '33', '181'),
('46', '33', '182'),
('47', '33', '183'),
('3', '33', '186'),
('4', '33', '187'),
('5', '33', '188'),
('6', '33', '189'),
('7', '33', '190'),
('8', '33', '191'),
('9', '33', '192'),
('10', '33', '193'),
('11', '33', '194'),
('12', '33', '195'),
('13', '33', '196'),
('14', '33', '197'),
('15', '33', '198'),
('2', '33', '200'),
('1', '33', '201');

### Structure of table `0_security_roles` ###

DROP TABLE IF EXISTS `0_security_roles`;

CREATE TABLE `0_security_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) DEFAULT NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ;

### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES
('1', 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132', '0'),
('2', 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128;353280', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3083;3084;3085;3086;3087;3088;3089;3090;3091;3092;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132', '0'),
('3', 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873', '0'),
('4', 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132', '0'),
('5', 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0'),
('6', 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0'),
('7', 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', '0'),
('8', 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132', '0'),
('9', 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132;353380;353381', '1'),
('10', 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3083;3084;3085;3086;3087;3088;3089;3090;3091;3092;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132;353380;353381', '0'),
('11', 'transport', 'Transport', '512;768;2816;3072;3328;7936;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3083;3084;3085;3086;3087;3088;3089;3090;3091;3092;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;353380;353381', '0'),
('12', 'fleet', 'Fleet Maintainence', '512;768;3072;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3083;3084;3085;3087;3088;3089;3090;3091;3092;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;353380;353381', '0');

### Structure of table `0_shippers` ###

DROP TABLE IF EXISTS `0_shippers`;

CREATE TABLE `0_shippers` (
  `shipper_id` int(11) NOT NULL AUTO_INCREMENT,
  `shipper_name` varchar(60) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `phone2` varchar(30) NOT NULL DEFAULT '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_shippers` ###

INSERT INTO `0_shippers` VALUES
('1', 'Default', '', '', '', '', '0'),
('2', 'Raipur Roadways', '', '', 'Abhishek', '', '0');

### Structure of table `0_sql_trail` ###

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_sql_trail` ###


### Structure of table `0_stock_category` ###

DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_stock_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `dflt_tax_type` int(11) NOT NULL DEFAULT '1',
  `dflt_units` varchar(20) NOT NULL DEFAULT 'each',
  `dflt_mb_flag` char(1) NOT NULL DEFAULT 'B',
  `dflt_transport_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_cogs_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_inventory_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_adjustment_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_assembly_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_dim1` int(11) DEFAULT NULL,
  `dflt_dim2` int(11) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `dflt_no_sale` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ;

### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES
('1', 'Components', '1', 'ea.', 'B', '4010', '5010', '1510', '5040', '1530', '0', '0', '0', '1'),
('2', 'Charges', '1', 'ea.', 'D', '4010', '5010', '1510', '5040', '1530', '0', '0', '0', '1'),
('3', 'Systems', '1', 'ea.', 'M', '4010', '5010', '1510', '5040', '1530', '0', '0', '0', '0'),
('4', 'Services', '1', 'hrs', 'D', '4010', '5010', '5765', '5040', '1530', '0', '0', '0', '1'),
('5', 'Vehicle', '1', 'ea.', 'M', '4430', '5100', '1510', '5040', '1530', '0', '0', '0', '1'),
('8', 'New', '1', 'Bags', 'B', '4010', '5100', '1520', '5040', '1530', '0', '0', '0', '0'),
('7', 'Fuels', '1', 'Ltr', 'B', '4430', '5100', '1520', '5040', '1530', '0', '0', '0', '1'),
('6', 'Transportable Items', '1', 'ea.', 'D', '4430', '5100', '1520', '5040', '1530', '0', '0', '0', '0');

### Structure of table `0_stock_master` ###

DROP TABLE IF EXISTS `0_stock_master`;

CREATE TABLE `0_stock_master` (
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `description` varchar(200) NOT NULL DEFAULT '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL DEFAULT 'each',
  `mb_flag` char(1) NOT NULL DEFAULT 'B',
  `transport_account` varchar(15) NOT NULL DEFAULT '',
  `cogs_account` varchar(15) NOT NULL DEFAULT '',
  `inventory_account` varchar(15) NOT NULL DEFAULT '',
  `adjustment_account` varchar(15) NOT NULL DEFAULT '',
  `assembly_account` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` int(11) DEFAULT NULL,
  `dimension2_id` int(11) DEFAULT NULL,
  `actual_cost` double NOT NULL DEFAULT '0',
  `last_cost` double NOT NULL DEFAULT '0',
  `material_cost` double NOT NULL DEFAULT '0',
  `labour_cost` double NOT NULL DEFAULT '0',
  `overhead_cost` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  `vehicle_init_odometer` decimal(10,2) NOT NULL,
  `vehicle_warranty_odometer` decimal(10,2) NOT NULL,
  `vehicle_number_plate` varchar(20) NOT NULL DEFAULT '',
  `vehicle_sr_no` varchar(200) NOT NULL,
  `vehicle_color` varchar(20) NOT NULL,
  `vehicle_maker_name` varchar(200) NOT NULL,
  `vehicle_model_name` varchar(200) NOT NULL,
  `vehicle_year` int(10) NOT NULL,
  `vehicle_insurer_name` varchar(100) NOT NULL,
  `vehicle_insurer_company` varchar(100) NOT NULL,
  `vehicle_insurance_note` varchar(200) NOT NULL,
  `vehicle_insurance_ref` varchar(30) NOT NULL,
  `vehicle_insurance_date` date NOT NULL,
  `vehicle_insurance_expiry_date` date NOT NULL,
  `vehicle_lic_ref` varchar(100) NOT NULL,
  `vehicle_lic_note` varchar(200) NOT NULL,
  `vehicle_lic_date` date NOT NULL,
  `vehicle_lic_expiry_date` date NOT NULL,
  `vehicle_comments` varchar(200) NOT NULL,
  `vehicle_purchase_date` date NOT NULL,
  `vehicle_warranty_date` date NOT NULL,
  `vehicle_purchase_note` varchar(200) NOT NULL,
  `vehicle_wt` decimal(10,2) NOT NULL,
  `vehicle_wt_unit` int(11) NOT NULL,
  `vehicle_type_id` int(11) NOT NULL,
  `vehicle_fuel_type_id` int(11) NOT NULL,
  `vehicle_fuel_usage_id` int(11) NOT NULL,
  `vehicle_odometer_type_id` int(10) NOT NULL,
  `part_type_id` int(11) NOT NULL,
  `material_type_id` int(11) NOT NULL,
  `service_quantity` int(11) NOT NULL,
  `alarm_quantity` int(11) NOT NULL,
  `time_id` int(11) NOT NULL,
  `alarm_time_id` int(11) NOT NULL,
  PRIMARY KEY (`stock_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_stock_master` ###


### Structure of table `0_stock_moves` ###

DROP TABLE IF EXISTS `0_stock_moves`;

CREATE TABLE `0_stock_moves` (
  `trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `loc_code` int(11) NOT NULL DEFAULT '1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `person_id` int(11) DEFAULT NULL,
  `price` double NOT NULL DEFAULT '0',
  `reference` char(40) NOT NULL DEFAULT '',
  `qty` double NOT NULL DEFAULT '1',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`trans_id`),
  KEY `type` (`type`,`trans_no`),
  KEY `Move` (`stock_id`,`loc_code`,`tran_date`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1 ;

### Data of table `0_stock_moves` ###

INSERT INTO `0_stock_moves` VALUES
('1', '0', 'GJ2783', '0', '0', '2014-12-30', NULL, '0', 'auto', '1', '0', '0', '1'),
('2', '1', 'Marbel', '13', '0', '2014-12-30', '0', '1340', '100', '-1', '0', '0', '1'),
('3', '2', 'Marbel', '13', '0', '2014-02-10', '0', '1230', '101', '-1', '0', '0', '1'),
('4', '3', 'Colors', '13', '0', '2014-03-20', '0', '1230', '102', '-1', '0', '0', '1'),
('5', '0', '8019', '0', '0', '2015-03-23', NULL, '0', 'auto', '1', '0', '0', '1'),
('6', '4', 'Marbel', '13', '0', '2014-03-23', '0', '0', '103', '-21', '0', '0', '1'),
('7', '5', 'Colors', '13', '0', '2015-05-12', '0', '1230', '104', '-1', '0', '0', '1'),
('8', '6', 'Colors', '13', '0', '2015-05-12', '0', '1230', '105', '-1', '0', '0', '1'),
('9', '7', 'Colors', '13', '0', '2015-05-12', '0', '1230', '106', '-11', '0', '0', '1'),
('10', '0', 'ds', '0', '2', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1'),
('11', '0', 'Adardsh', '0', '2', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1'),
('12', '0', 'sadjq', '0', '2', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1'),
('13', '0', 'dsa', '0', '2', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1'),
('14', '0', 'sda', '0', '2', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1'),
('15', '0', 'asdasda', '0', '2', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1'),
('16', '0', 'asds', '0', '18', '0000-00-00', NULL, '0', 'auto', '1', '0', '0', '1');

### Structure of table `0_supp_allocations` ###

DROP TABLE IF EXISTS `0_supp_allocations`;

CREATE TABLE `0_supp_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_supp_allocations` ###


### Structure of table `0_supp_invoice_items` ###

DROP TABLE IF EXISTS `0_supp_invoice_items`;

CREATE TABLE `0_supp_invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_trans_no` int(11) DEFAULT NULL,
  `supp_trans_type` int(11) DEFAULT NULL,
  `gl_code` varchar(15) NOT NULL DEFAULT '',
  `grn_item_id` int(11) DEFAULT NULL,
  `po_detail_item_id` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `quantity` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `memo_` tinytext,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`supp_trans_type`,`supp_trans_no`,`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_supp_invoice_items` ###


### Structure of table `0_supp_trans` ###

DROP TABLE IF EXISTS `0_supp_trans`;

CREATE TABLE `0_supp_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `supplier_id` int(11) unsigned DEFAULT NULL,
  `reference` tinytext NOT NULL,
  `supp_reference` varchar(60) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `alloc` double NOT NULL DEFAULT '0',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type`,`trans_no`),
  KEY `supplier_id` (`supplier_id`),
  KEY `SupplierID_2` (`supplier_id`,`supp_reference`),
  KEY `type` (`type`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_supp_trans` ###


### Structure of table `0_suppliers` ###

DROP TABLE IF EXISTS `0_suppliers`;

CREATE TABLE `0_suppliers` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_name` varchar(60) NOT NULL DEFAULT '',
  `supp_ref` varchar(30) NOT NULL DEFAULT '',
  `address` tinytext NOT NULL,
  `supp_address` tinytext NOT NULL,
  `gst_no` varchar(25) NOT NULL DEFAULT '',
  `contact` varchar(60) NOT NULL DEFAULT '',
  `supp_account_no` varchar(40) NOT NULL DEFAULT '',
  `website` varchar(100) NOT NULL DEFAULT '',
  `bank_account` varchar(60) NOT NULL DEFAULT '',
  `curr_code` char(3) DEFAULT NULL,
  `payment_terms` int(11) DEFAULT NULL,
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  `dimension_id` int(11) DEFAULT '0',
  `dimension2_id` int(11) DEFAULT '0',
  `tax_group_id` int(11) DEFAULT NULL,
  `credit_limit` double NOT NULL DEFAULT '0',
  `purchase_account` varchar(15) NOT NULL DEFAULT '',
  `payable_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_suppliers` ###

INSERT INTO `0_suppliers` VALUES
('1', 'Junk Beer ApS', 'Junk Beer', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '123456', 'Contact', '111', '', '', 'INR', '3', '0', '1', '0', '2', '1000', '', '2100', '5060', 'A supplier with junk beers.', '0'),
('2', 'Lucky Luke Inc.', 'Lucky Luke', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '654321', 'Luke', '333', '', '', 'INR', '3', '0', '0', '0', '1', '500', '', '2100', '5060', '', '0'),
('3', 'Money Makers Ltd.', 'Money Makers', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '987654', 'Makers', '222', '', '', 'INR', '3', '0', '0', '0', '2', '300', '', '2100', '5060', '', '0');

### Structure of table `0_sys_prefs` ###

DROP TABLE IF EXISTS `0_sys_prefs`;

CREATE TABLE `0_sys_prefs` (
  `name` varchar(35) NOT NULL DEFAULT '',
  `category` varchar(30) DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT '',
  `length` smallint(6) DEFAULT NULL,
  `value` tinytext,
  PRIMARY KEY (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_sys_prefs` ###

INSERT INTO `0_sys_prefs` VALUES
('coy_name', 'setup.company', 'varchar', '60', 'admin'),
('gst_no', 'setup.company', 'varchar', '25', '9876543'),
('coy_no', 'setup.company', 'varchar', '25', '123456789'),
('tax_prd', 'setup.company', 'int', '11', '1'),
('tax_last', 'setup.company', 'int', '11', '1'),
('postal_address', 'setup.company', 'tinytext', '0', 'Address 1\r\nAddress 2\r\nAddress 3'),
('phone', 'setup.company', 'varchar', '30', '(222) 111.222.333'),
('fax', 'setup.company', 'varchar', '30', NULL),
('email', 'setup.company', 'varchar', '100', 'delta@delta.com'),
('coy_logo', 'setup.company', 'varchar', '100', 'logo_frontaccounting.jpg'),
('domicile', 'setup.company', 'varchar', '55', NULL),
('curr_default', 'setup.company', 'char', '3', 'INR'),
('use_dimension', 'setup.company', 'tinyint', '1', '1'),
('f_year', 'setup.company', 'int', '11', '7'),
('no_item_list', 'setup.company', 'tinyint', '1', '0'),
('no_consignor_list', 'setup.company', 'tinyint', '1', '0'),
('no_supplier_list', 'setup.company', 'tinyint', '1', '0'),
('base_transport', 'setup.company', 'int', '11', '0'),
('time_zone', 'setup.company', 'tinyint', '1', '0'),
('add_pct', 'setup.company', 'int', '5', '-1'),
('round_to', 'setup.company', 'int', '5', '1'),
('login_tout', 'setup.company', 'smallint', '6', '600'),
('past_due_days', 'glsetup.general', 'int', '11', '30'),
('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990'),
('retained_earnings_act', 'glsetup.general', 'varchar', '15', '3590'),
('bank_charge_act', 'glsetup.general', 'varchar', '15', '5690'),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '4450'),
('default_credit_limit', 'glsetup.consignor', 'int', '11', '1000'),
('accumulate_shipping', 'glsetup.consignor', 'tinyint', '1', '1'),
('legal_text', 'glsetup.consignor', 'tinytext', '0', NULL),
('freight_act', 'glsetup.consignor', 'varchar', '15', '4430'),
('consignors_act', 'glsetup.transport', 'varchar', '15', '1060'),
('default_transport_act', 'glsetup.transport', 'varchar', '15', '4010'),
('default_transport_discount_act', 'glsetup.transport', 'varchar', '15', '4510'),
('default_prompt_payment_act', 'glsetup.transport', 'varchar', '15', '4500'),
('default_delivery_required', 'glsetup.transport', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', NULL),
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', NULL),
('creditors_act', 'glsetup.purchase', 'varchar', '15', NULL),
('po_over_receive', 'glsetup.purchase', 'int', '11', '0'),
('po_over_charge', 'glsetup.purchase', 'int', '11', '0'),
('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '1520'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '5100'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '5040'),
('default_inv_transport_act', 'glsetup.items', 'varchar', '15', '4010'),
('default_assembly_act', 'glsetup.items', 'varchar', '15', '1530'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', NULL),
('version_id', 'system', 'varchar', '11', '2.3rc'),
('auto_curr_reval', 'setup.company', 'smallint', '6', '1'),
('grn_clearing_act', 'glsetup.purchase', 'varchar', '15', '0'),
('bcc_email', 'setup.company', 'varchar', '100', NULL),
('no_consignee_list', 'setup.company', 'tinyint', '1', '0');

### Structure of table `0_sys_types` ###

DROP TABLE IF EXISTS `0_sys_types`;

CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL DEFAULT '0',
  `type_no` int(11) NOT NULL DEFAULT '1',
  `next_reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_sys_types` ###

INSERT INTO `0_sys_types` VALUES
('0', '19', '10'),
('1', '8', '4'),
('2', '5', '4'),
('4', '3', '7'),
('10', '19', '153'),
('11', '3', '16'),
('12', '6', '112'),
('13', '5', '107'),
('16', '2', '17'),
('17', '2', '5'),
('18', '1', '7'),
('20', '8', '15'),
('21', '1', '1'),
('22', '4', '5'),
('25', '1', '4'),
('26', '1', '72'),
('28', '1', '3'),
('29', '1', '3'),
('30', '5', '147'),
('32', '0', '124'),
('33', '0', '202'),
('35', '1', '1'),
('40', '1', '3');

### Structure of table `0_tag_associations` ###

DROP TABLE IF EXISTS `0_tag_associations`;

CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_tag_associations` ###


### Structure of table `0_tags` ###

DROP TABLE IF EXISTS `0_tags`;

CREATE TABLE `0_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_tags` ###


### Structure of table `0_tax_group_items` ###

DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_tax_group_items` ###

INSERT INTO `0_tax_group_items` VALUES
('1', '1', '20'),
('1', '2', '5'),
('5', '1', '20');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `tax_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('1', 'Tax', '0', '0'),
('2', 'Tax Exempt', '0', '0'),
('4', 'Main', '0', '0'),
('5', 'dasdsa', '0', '0');

### Structure of table `0_tax_types` ###

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rate` double NOT NULL DEFAULT '0',
  `transport_gl_code` varchar(15) DEFAULT '',
  `purchasing_gl_code` varchar(15) DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('1', '20', '2150', '2150', 'Tax', '0'),
('2', '5', '1060', '1060', 'New Tax', '0');

### Structure of table `0_trans_order_payments_deposits` ###

DROP TABLE IF EXISTS `0_trans_order_payments_deposits`;

CREATE TABLE `0_trans_order_payments_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `trans_type` int(11) NOT NULL,
  `entity_type` varchar(10) DEFAULT NULL,
  `consignor_no` int(11) DEFAULT NULL,
  `driver_code` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `account_code` int(11) DEFAULT NULL,
  `amount` double DEFAULT '0',
  `memo` tinytext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=latin1 ;

### Data of table `0_trans_order_payments_deposits` ###

INSERT INTO `0_trans_order_payments_deposits` VALUES
('77', '4', '30', '0', '6', '-1', '10', '1200', '320', NULL);

### Structure of table `0_trans_tax_details` ###

DROP TABLE IF EXISTS `0_trans_tax_details`;

CREATE TABLE `0_trans_tax_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `tran_date` date NOT NULL,
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  `ex_rate` double NOT NULL DEFAULT '1',
  `included_in_price` tinyint(1) NOT NULL DEFAULT '0',
  `net_amount` double NOT NULL DEFAULT '0',
  `amount` double NOT NULL DEFAULT '0',
  `memo` tinytext,
  PRIMARY KEY (`id`),
  KEY `Type_and_Number` (`trans_type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1 ;

### Data of table `0_trans_tax_details` ###

INSERT INTO `0_trans_tax_details` VALUES
('1', '13', '1', '2014-10-24', '1', '20', '1', '0', '25830', '5166', '82'),
('2', '13', '1', '2014-10-24', '1', '20', '1', '0', '56650', '11330', '83'),
('3', '10', '1', '2014-10-24', '1', '20', '1', '0', '56650', '11330', '140'),
('4', '13', '2', '2014-10-24', '1', '20', '1', '0', '56660', '11332', '84'),
('5', '10', '2', '2014-10-24', '1', '20', '1', '0', '10', '2', '141'),
('6', '13', '3', '2014-10-27', '1', '20', '1', '0', '46483.5', '9296.7', '85'),
('7', '10', '3', '2014-10-27', '1', '20', '1', '0', '46483.5', '9296.7', '142'),
('8', '13', '4', '2014-11-20', '1', '20', '1', '0', '410820', '82164', '86'),
('9', '10', '4', '2014-11-20', '1', '20', '1', '0', '24600', '4920', '143'),
('10', '13', '5', '2014-11-20', '1', '20', '1', '0', '533820', '106764', '87'),
('11', '13', '6', '2014-11-20', '1', '20', '1', '0', '2420', '484', '88'),
('12', '13', '7', '2014-11-20', '1', '20', '1', '0', '2420', '484', '89'),
('13', '13', '8', '2014-11-20', '1', '20', '1', '0', '6500', '1300', '90'),
('14', '13', '9', '2014-11-20', '1', '20', '1', '0', '154220', '30844', '91'),
('15', '10', '5', '2014-11-20', '1', '20', '1', '0', '147720', '29544', '144'),
('16', '13', '10', '2014-11-20', '1', '20', '1.6446', '0', '130', '26', '92'),
('17', '13', '10', '2014-11-20', '2', '5', '1.6446', '0', '130', '6.5', '92'),
('18', '10', '6', '2014-11-20', '1', '20', '1.6446', '0', '130', '26', '145'),
('19', '10', '6', '2014-11-20', '2', '5', '1.6446', '0', '130', '6.5', '145'),
('20', '11', '1', '2014-11-20', '1', '20', '1.6446', '0', '130', '26', '14'),
('21', '11', '1', '2014-11-20', '2', '5', '1.6446', '0', '130', '6.5', '14'),
('22', '13', '11', '2014-11-20', '1', '20', '61.929978467182', '0', '1', '0.2', '93'),
('23', '13', '11', '2014-11-20', '2', '5', '61.929978467182', '0', '1', '0.05', '93'),
('24', '10', '7', '2014-11-20', '1', '20', '61.929978467182', '0', '1', '0.2', '146'),
('25', '10', '7', '2014-11-20', '2', '5', '61.929978467182', '0', '1', '0.05', '146'),
('26', '13', '12', '2014-11-20', '1', '20', '1', '0', '403440', '80688', '94'),
('27', '13', '12', '2014-11-20', '2', '5', '1', '0', '403440', '20172', '94'),
('28', '13', '13', '2014-11-21', '1', '20', '1', '0', '14760', '2952', '95'),
('29', '13', '13', '2014-11-21', '2', '5', '1', '0', '15990', '799.5', '95'),
('30', '13', '14', '2014-11-21', '1', '20', '1', '0', '12300', '2460', '96'),
('31', '13', '15', '2014-11-21', '1', '20', '1', '0', '1230', '246', '97'),
('32', '10', '8', '2014-11-21', '1', '20', '1', '0', '1230', '246', '147'),
('33', '11', '2', '2014-11-21', '1', '20', '1', '0', '12300', '2460', '15'),
('34', '13', '1', '2014-12-07', '1', '20', '1', '1', '96', '19.2', '99'),
('35', '13', '1', '2014-12-07', '2', '5', '1', '1', '96', '4.8', '99'),
('36', '10', '1', '2014-12-07', '1', '20', '1', '1', '96', '19.2', '149'),
('37', '10', '1', '2014-12-07', '2', '5', '1', '1', '96', '4.8', '149'),
('38', '13', '1', '2014-12-30', '1', '20', '1', '1', '1072', '214.4', '100'),
('39', '13', '1', '2014-12-30', '2', '5', '1', '1', '1072', '53.6', '100'),
('40', '10', '1', '2014-12-30', '1', '20', '1', '1', '1072', '214.4', '150'),
('41', '10', '1', '2014-12-30', '2', '5', '1', '1', '1072', '53.6', '150'),
('42', '13', '2', '2014-02-10', '1', '20', '1', '0', '1230', '246', '101'),
('43', '13', '2', '2014-02-10', '2', '5', '1', '0', '1230', '61.5', '101'),
('44', '13', '3', '2014-03-20', '1', '20', '1', '0', '1230', '246', '102'),
('45', '13', '3', '2014-03-20', '2', '5', '1', '0', '1230', '61.5', '102'),
('46', '10', '2', '2014-03-20', '1', '20', '1', '0', '1230', '246', '151'),
('47', '10', '2', '2014-03-20', '2', '5', '1', '0', '1230', '61.5', '151'),
('48', '13', '5', '2015-05-12', '1', '20', '1', '0', '1230', '246', '104'),
('49', '13', '5', '2015-05-12', '2', '5', '1', '0', '1230', '61.5', '104'),
('50', '13', '6', '2015-05-12', '1', '20', '1', '0', '1230', '246', '105'),
('51', '13', '6', '2015-05-12', '2', '5', '1', '0', '1230', '61.5', '105'),
('52', '13', '7', '2015-05-12', '1', '20', '1', '0', '13530', '2706', '106'),
('53', '13', '7', '2015-05-12', '2', '5', '1', '0', '13530', '676.5', '106');

### Structure of table `0_transport_consignor_details` ###

DROP TABLE IF EXISTS `0_transport_consignor_details`;

CREATE TABLE `0_transport_consignor_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `trans_type` int(11) NOT NULL,
  `consignor_no` int(11) NOT NULL,
  `tin_no` varchar(50) DEFAULT NULL,
  `address` tinytext,
  `phone` int(11) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `update_by` varchar(100) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`order_no`,`trans_type`,`consignor_no`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_consignor_details` ###

INSERT INTO `0_transport_consignor_details` VALUES
('64', '9', '33', '6', '482349283492859', 'adask.asd\nas', '0', NULL, 'admin', '2015-07-21 23:46:34', NULL, NULL),
('65', '2', '30', '6', '482349283492859', 'adask.asd\nas', '0', NULL, 'admin', '2015-07-22 23:28:13', 'admin', '2015-07-24 23:51:56'),
('68', '6', '30', '6', '482349283492859', 'adask.asd\nas', '0', NULL, 'admin', '2015-08-29 19:57:41', 'admin', '2015-08-29 20:32:30'),
('69', '6', '30', '5', '2130', 'asdasdjschai \nvibhag', '0', NULL, 'admin', '2015-08-29 19:57:41', 'admin', '2015-08-29 20:32:30');

### Structure of table `0_transport_item_codes` ###

DROP TABLE IF EXISTS `0_transport_item_codes`;

CREATE TABLE `0_transport_item_codes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) NOT NULL,
  `stock_id` int(11) NOT NULL,
  `description` varchar(200) NOT NULL DEFAULT '',
  `category_description` varchar(200) NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_item_codes` ###

INSERT INTO `0_transport_item_codes` VALUES
('1', 'Marbel', '1', 'Marbel', 'Transportable Items', '1', '0', '0'),
('2', 'Colors', '2', 'Colors', 'Transportable Items', '1', '0', '0'),
('3', 'Colorsasd', '3', 'Colorssdds', 'Transportable Items', '1', '0', '0'),
('4', '4', '4', 'Asadahloasd', 'Transportable Items', '1', '0', '0');

### Structure of table `0_transport_items_master` ###

DROP TABLE IF EXISTS `0_transport_items_master`;

CREATE TABLE `0_transport_items_master` (
  `stock_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `description` varchar(200) NOT NULL DEFAULT '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL DEFAULT 'each',
  `mb_flag` char(1) NOT NULL DEFAULT 'B',
  `transport_account` varchar(15) NOT NULL DEFAULT '',
  `cogs_account` varchar(15) NOT NULL DEFAULT '',
  `inventory_account` varchar(15) NOT NULL DEFAULT '',
  `adjustment_account` varchar(15) NOT NULL DEFAULT '',
  `assembly_account` varchar(15) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`stock_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_items_master` ###

INSERT INTO `0_transport_items_master` VALUES
('1', '0', '1', 'Colors', '', 'Bags', 'B', '', '', '', '', '', '0', '0', '0'),
('3', '0', '1', 'Marbel', 'Marbel', 'Bags', 'B', '', '', '', '', '', '0', '0', '0'),
('4', '0', '1', 'Asadahloasd', 'dsjdf;s;ads', 'Bags', 'B', '', '', '', '', '', '0', '0', '0');

### Structure of table `0_transport_order_details` ###

DROP TABLE IF EXISTS `0_transport_order_details`;

CREATE TABLE `0_transport_order_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `stk_code` int(11) NOT NULL,
  `description` tinytext,
  `qty_sent` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `to_units` varchar(10) NOT NULL,
  `discount_percent` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sorder` (`trans_type`,`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_order_details` ###

INSERT INTO `0_transport_order_details` VALUES
('23', '1', '30', '1', 'Colors', '0', '12324', '1', 'Bags', '0'),
('24', '2', '30', '1', 'Colors', '0', '4340', '1', 'Bags', '0'),
('26', '5', '30', '1', 'Colors', '0', '13450', '1', 'Bags', '0');

### Structure of table `0_transport_order_stops` ###

DROP TABLE IF EXISTS `0_transport_order_stops`;

CREATE TABLE `0_transport_order_stops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `loc_code` int(11) NOT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `stop_code` bigint(11) NOT NULL,
  `stop_date` date DEFAULT NULL,
  `stop_time` time DEFAULT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sorder` (`trans_type`,`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_order_stops` ###

INSERT INTO `0_transport_order_stops` VALUES
('1', '16', '33', '2', '0', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '07:07:00', 'admin', '2015-07-04 17:01:54', NULL, NULL),
('2', '17', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '11:33:00', 'admin', '2015-07-04 17:05:44', NULL, NULL),
('3', '18', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '17:18:00', 'admin', '2015-07-04 17:56:53', NULL, NULL),
('4', '19', '33', '2', 'Adarsh1212', 'Jaipur,\nRajasthan,\nIndia\n', '1', '0000-00-00', '12:55:00', 'admin', '2015-07-04 21:09:34', NULL, NULL),
('5', '20', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '11:09:00', 'admin', '2015-07-04 21:31:52', NULL, NULL),
('9', '21', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-10-12', '14:17:00', 'admin', '2015-07-04 21:36:22', NULL, NULL),
('10', '22', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\nhyd', '1', '2015-10-14', '10:12:00', 'admin', '2015-07-06 16:49:02', NULL, NULL),
('15', '23', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-10-01', '17:14:00', 'admin', '2015-07-09 22:14:58', NULL, NULL),
('16', '24', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-10-13', '21:15:00', 'admin', '2015-07-09 22:21:43', 'admin', '2015-07-10 14:01:58'),
('17', '25', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-10-01', '22:19:00', 'admin', '2015-07-10 14:08:37', NULL, NULL),
('18', '26', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '17:17:00', 'admin', '2015-07-10 14:20:12', 'admin', '2015-07-10 14:34:54'),
('19', '28', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0020-00-00', '17:08:00', 'admin', '2015-07-11 11:59:44', 'admin', '2015-07-11 12:40:05'),
('20', '29', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '21:17:00', 'admin', '2015-07-13 11:52:16', 'admin', '2015-07-13 12:03:26'),
('21', '30', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-07-13', '19:16:00', 'admin', '2015-07-13 12:09:36', NULL, NULL),
('22', '31', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-07-13', '15:16:00', 'admin', '2015-07-13 12:22:17', NULL, NULL),
('23', '32', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '18:18:00', 'admin', '2015-07-13 14:15:02', 'admin', '2015-07-13 14:17:52'),
('24', '33', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-07-01', '15:31:00', 'admin', '2015-07-13 22:09:28', NULL, NULL),
('25', '34', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-07-15', '15:15:00', 'admin', '2015-07-15 20:27:37', NULL, NULL),
('26', '35', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '2015-07-15', '16:15:00', 'admin', '2015-07-15 20:31:49', NULL, NULL),
('27', '37', '33', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '17:09:00', 'admin', '2015-07-15 21:36:35', 'admin', '2015-07-16 13:29:21'),
('28', '2', '30', '2', 'Adarsh', 'Jaipur\nRajasthan\nIndia\n', '1', '0000-00-00', '00:00:00', 'admin', '2015-07-22 23:28:13', 'admin', '2015-07-24 23:51:56');

### Structure of table `0_transport_orders` ###

DROP TABLE IF EXISTS `0_transport_orders`;

CREATE TABLE `0_transport_orders` (
  `order_no` int(11) NOT NULL,
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `load_status_code` int(11) DEFAULT NULL,
  `truck_status_code` int(11) DEFAULT NULL,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `consignee_no` int(11) DEFAULT NULL,
  `billing_no` int(11) DEFAULT NULL,
  `consignee_ref` tinytext,
  `bill_to` varchar(50) DEFAULT NULL,
  `driver_no` varchar(11) DEFAULT NULL,
  `driver_ref` varchar(20) DEFAULT NULL,
  `vehicle_no` char(20) DEFAULT NULL,
  `vehicle_type` int(11) DEFAULT NULL,
  `vehicle_ref` tinytext,
  `reference` varchar(100) NOT NULL DEFAULT '',
  `contact_person` varchar(50) DEFAULT NULL,
  `consignor_tin_no` varchar(20) DEFAULT NULL,
  `billing_tin_no` varchar(20) DEFAULT NULL,
  `consignee_tin_no` varchar(20) DEFAULT NULL,
  `comments` tinytext,
  `ord_date` date NOT NULL,
  `order_type` int(11) DEFAULT NULL,
  `ship_via` int(11) DEFAULT NULL,
  `delivery_address` tinytext,
  `loading_address` varchar(100) DEFAULT NULL,
  `billing_address` varchar(100) DEFAULT NULL,
  `loaded_from` varchar(100) DEFAULT NULL,
  `contact_phone` varchar(30) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `deliver_to` tinytext,
  `freight_cost` double DEFAULT NULL,
  `commission_cost` double DEFAULT NULL,
  `labour_charge` double DEFAULT NULL,
  `insc_charge` double DEFAULT NULL,
  `way_cost` double DEFAULT NULL,
  `bilty_charge` double DEFAULT NULL,
  `ship_cost` double DEFAULT NULL,
  `from_stk_loc` int(11) DEFAULT NULL,
  `Location_to` int(11) DEFAULT NULL,
  `delivery_date` date NOT NULL,
  `total` double DEFAULT NULL,
  `total_goods_value` decimal(20,0) DEFAULT NULL,
  `goods_bill_no` varchar(50) DEFAULT NULL,
  `payment_by` int(11) DEFAULT NULL,
  `service_tax_by` int(11) DEFAULT NULL,
  `add_service_tax` int(11) DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,
  `paid_account_ref` int(11) DEFAULT NULL,
  `total_payment` double DEFAULT NULL,
  `deposit_date` datetime DEFAULT NULL,
  `deposit_account_ref` int(11) DEFAULT NULL,
  `total_deposit` double DEFAULT NULL,
  `consignee_phone` int(11) NOT NULL,
  `consignee_email` varchar(50) NOT NULL,
  `billing_phone` int(11) NOT NULL,
  `billing_email` varchar(50) NOT NULL,
  PRIMARY KEY (`trans_type`,`order_no`),
  KEY `vehicle_no` (`vehicle_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_orders` ###

INSERT INTO `0_transport_orders` VALUES
('1', '30', '1', '0', '11', '1', '0', '0', NULL, NULL, NULL, '0', NULL, NULL, NULL, '138', NULL, NULL, NULL, NULL, NULL, '0000-00-00', '2', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '2', '0', '2015-07-24', '12324', '12324', NULL, '0', '0', '0', NULL, '138', '0', NULL, '138', '0', '0', '', '0', ''),
('2', '30', '1', '0', '0', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '139', NULL, NULL, NULL, NULL, NULL, '2015-07-23', '2', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0', '2015-07-24', '4340', '4340', NULL, '0', '0', '0', NULL, '139', '0', NULL, '139', '0', '0', '', '0', ''),
('3', '30', '0', '0', '0', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '140', NULL, NULL, NULL, NULL, NULL, '2015-07-26', '2', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0', '2015-07-27', '0', '0', NULL, '0', '0', '0', NULL, '140', '0', NULL, '140', '340', '0', '', '0', ''),
('4', '30', '0', '0', '0', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '141', NULL, NULL, NULL, NULL, NULL, '2015-07-26', '2', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0', '2015-07-27', '0', '0', NULL, '0', '0', '0', NULL, '141', '0', NULL, '141', '320', '0', '', '0', ''),
('5', '30', '1', '0', '0', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '142', NULL, NULL, NULL, NULL, NULL, '2015-07-26', '2', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '260', '30', '0', '0', '0', '0', '230', '0', '0', '2015-07-27', '13710', '13450', NULL, '0', '0', '0', NULL, '142', '0', NULL, '142', '0', '0', '', '0', ''),
('6', '30', '11', '0', '0', '1', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '143', NULL, NULL, NULL, NULL, NULL, '2015-08-29', '0', '1', NULL, NULL, NULL, NULL, 'asdasdas', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '2', '2', '2015-08-30', '0', '0', NULL, '0', '0', '0', NULL, '143', '0', NULL, '143', '0', '0', '', '0', ''),
('7', '30', '0', '2', '0', '0', '0', '0', NULL, NULL, NULL, '0', NULL, NULL, NULL, '144', NULL, NULL, NULL, NULL, NULL, '2015-10-26', '2', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '2', '2', '2015-10-27', '0', '0', NULL, '0', '0', '0', NULL, '144', '0', NULL, '144', '0', '0', '', '0', ''),
('8', '30', '0', '0', '0', '0', '0', '0', NULL, NULL, NULL, '0', NULL, NULL, NULL, '145', NULL, NULL, NULL, NULL, NULL, '2015-10-27', '2', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '2', '2', '2015-10-28', '0', '0', NULL, '0', '0', '0', NULL, '145', '0', NULL, '145', '0', '0', '', '0', ''),
('9', '30', '0', '12', '11', '0', '0', '0', NULL, NULL, NULL, '0', NULL, NULL, NULL, '146', 'das', NULL, NULL, NULL, NULL, '2015-10-29', '2', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '18', '18', '2015-10-30', '0', '0', NULL, '0', '0', '0', NULL, '146', '0', NULL, '146', '0', '0', '', '0', '');

### Structure of table `0_transport_pos` ###

DROP TABLE IF EXISTS `0_transport_pos`;

CREATE TABLE `0_transport_pos` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` int(11) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_pos` ###


### Structure of table `0_transport_prices` ###

DROP TABLE IF EXISTS `0_transport_prices`;

CREATE TABLE `0_transport_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` int(11) NOT NULL,
  `transport_type_id` int(11) NOT NULL DEFAULT '0',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `price` (`stock_id`,`transport_type_id`,`curr_abrev`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_prices` ###


### Structure of table `0_transport_types` ###

DROP TABLE IF EXISTS `0_transport_types`;

CREATE TABLE `0_transport_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transport_type` char(50) NOT NULL DEFAULT '',
  `tax_included` int(1) NOT NULL DEFAULT '0',
  `factor` double NOT NULL DEFAULT '1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `transport_type` (`transport_type`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ;

### Data of table `0_transport_types` ###

INSERT INTO `0_transport_types` VALUES
('1', 'Tax Included', '1', '0', '0'),
('2', 'Tax Excluded', '0', '0', '0');

### Structure of table `0_transportman` ###

DROP TABLE IF EXISTS `0_transportman`;

CREATE TABLE `0_transportman` (
  `transportman_code` int(11) NOT NULL AUTO_INCREMENT,
  `transportman_name` char(60) NOT NULL DEFAULT '',
  `transportman_phone` char(30) NOT NULL DEFAULT '',
  `transportman_fax` char(30) NOT NULL DEFAULT '',
  `transportman_email` varchar(100) NOT NULL DEFAULT '',
  `provision` double NOT NULL DEFAULT '0',
  `break_pt` double NOT NULL DEFAULT '0',
  `provision2` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`transportman_code`),
  UNIQUE KEY `transportman_name` (`transportman_name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_transportman` ###

INSERT INTO `0_transportman` VALUES
('1', 'Sales Person', '', '', '', '5', '1000', '4', '0'),
('2', 'New', '', '', '', '0', '0', '0', '0');

### Structure of table `0_truck_group_types` ###

DROP TABLE IF EXISTS `0_truck_group_types`;

CREATE TABLE `0_truck_group_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_truck_group_types` ###

INSERT INTO `0_truck_group_types` VALUES
('1', 'Small', '0');

### Structure of table `0_truck_length_group_types` ###

DROP TABLE IF EXISTS `0_truck_length_group_types`;

CREATE TABLE `0_truck_length_group_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_truck_length_group_types` ###

INSERT INTO `0_truck_length_group_types` VALUES
('1', '22', '0');

### Structure of table `0_truck_length_type` ###

DROP TABLE IF EXISTS `0_truck_length_type`;

CREATE TABLE `0_truck_length_type` (
  `truck_length_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `truck_length_type_name` varchar(60) NOT NULL DEFAULT '',
  `truck_length_group_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`truck_length_type_code`),
  KEY `truck_length_measure` (`truck_length_type_name`),
  KEY `truck_length_group_type` (`truck_length_group_type`,`truck_length_type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_truck_length_type` ###

INSERT INTO `0_truck_length_type` VALUES
('1', 'ads', '1', '0');

### Structure of table `0_truck_status_group_types` ###

DROP TABLE IF EXISTS `0_truck_status_group_types`;

CREATE TABLE `0_truck_status_group_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_truck_status_group_types` ###

INSERT INTO `0_truck_status_group_types` VALUES
('1', 'Carrier Setup', '0'),
('2', 'Before Your Load', '0'),
('3', 'During Your Load', '0'),
('4', 'After Your Load', '0');

### Structure of table `0_truck_status_type` ###

DROP TABLE IF EXISTS `0_truck_status_type`;

CREATE TABLE `0_truck_status_type` (
  `truck_status_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `truck_status_type_name` varchar(60) NOT NULL DEFAULT '',
  `truck_status_group_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`truck_status_type_code`),
  KEY `truck_status_measure` (`truck_status_type_name`),
  KEY `truck_status_group_type` (`truck_status_group_type`,`truck_status_type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1 ;

### Data of table `0_truck_status_type` ###

INSERT INTO `0_truck_status_type` VALUES
('1', 'Carrier Need Setup', '1', '0'),
('2', 'Carrier Need Setup', '1', '0'),
('3', 'Setup Packet Sent to Carrier', '1', '0'),
('4', 'Insurance Verification Needed', '1', '0'),
('5', 'Carrier Setup Not Completed', '1', '0'),
('6', 'Carrier Setup Completedd', '1', '0'),
('7', 'At prior load', '2', '0'),
('8', 'Dispatched', '2', '0'),
('9', 'At Pickup - Waiting', '3', '0'),
('10', 'At Pickup - Loading', '3', '0'),
('11', 'On Time', '3', '0'),
('12', 'Running Late', '3', '0'),
('13', 'At Delivery - Waiting', '3', '0'),
('14', 'At Delivery - Unloading', '3', '0'),
('15', 'Broken Down', '3', '0'),
('16', 'In Accident', '3', '0'),
('17', 'Empty', '4', '0'),
('18', 'Driver Paid', '4', '0');

### Structure of table `0_truck_type` ###

DROP TABLE IF EXISTS `0_truck_type`;

CREATE TABLE `0_truck_type` (
  `truck_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `truck_type_name` varchar(60) NOT NULL DEFAULT '',
  `truck_group_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`truck_type_code`),
  KEY `truck_type_name` (`truck_type_name`),
  KEY `truck_status_by_type` (`truck_group_type`,`truck_type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_truck_type` ###

INSERT INTO `0_truck_type` VALUES
('1', 'Dry Van', '1', '0'),
('2', '123', '1', '0');

### Structure of table `0_useronline` ###

DROP TABLE IF EXISTS `0_useronline`;

CREATE TABLE `0_useronline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(15) NOT NULL DEFAULT '0',
  `ip` varchar(40) NOT NULL DEFAULT '',
  `file` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

### Data of table `0_useronline` ###


### Structure of table `0_users` ###

DROP TABLE IF EXISTS `0_users`;

CREATE TABLE `0_users` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `real_name` varchar(100) NOT NULL DEFAULT '',
  `role_id` int(11) NOT NULL DEFAULT '1',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `language` varchar(20) DEFAULT NULL,
  `date_format` tinyint(1) NOT NULL DEFAULT '0',
  `date_sep` tinyint(1) NOT NULL DEFAULT '0',
  `tho_sep` tinyint(1) NOT NULL DEFAULT '0',
  `dec_sep` tinyint(1) NOT NULL DEFAULT '0',
  `theme` varchar(20) NOT NULL DEFAULT 'default',
  `page_size` varchar(20) NOT NULL DEFAULT 'A4',
  `prices_dec` smallint(6) NOT NULL DEFAULT '2',
  `qty_dec` smallint(6) NOT NULL DEFAULT '2',
  `rates_dec` smallint(6) NOT NULL DEFAULT '4',
  `percent_dec` smallint(6) NOT NULL DEFAULT '1',
  `show_gl` tinyint(1) NOT NULL DEFAULT '1',
  `show_codes` tinyint(1) NOT NULL DEFAULT '0',
  `show_hints` tinyint(1) NOT NULL DEFAULT '0',
  `last_visit_date` datetime DEFAULT NULL,
  `query_size` tinyint(1) DEFAULT '10',
  `graphic_links` tinyint(1) DEFAULT '1',
  `pos` smallint(6) DEFAULT '1',
  `print_profile` varchar(30) NOT NULL DEFAULT '1',
  `rep_popup` tinyint(1) DEFAULT '1',
  `sticky_doc_date` tinyint(1) DEFAULT '0',
  `startup_tab` varchar(20) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_users` ###

INSERT INTO `0_users` VALUES
('1', 'admin', '5942733022a86d8b8a80579f87a46537', 'Administrator', '2', '', 'adm@adm.com', 'C', '0', '0', '0', '0', 'coloradmin', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2015-10-29 10:37:18', '10', '1', '1', '', '1', '0', 'orders', '0');

### Structure of table `0_vehicle_category` ###

DROP TABLE IF EXISTS `0_vehicle_category`;

CREATE TABLE `0_vehicle_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ;

### Data of table `0_vehicle_category` ###


### Structure of table `0_vehicle_codes` ###

DROP TABLE IF EXISTS `0_vehicle_codes`;

CREATE TABLE `0_vehicle_codes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `description` varchar(200) NOT NULL DEFAULT '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_id` (`vehicle_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ;

### Data of table `0_vehicle_codes` ###

INSERT INTO `0_vehicle_codes` VALUES
('1', 'GJ2783', '0', 'GJ2783', '0', '1', '0', '0'),
('2', '8019', '8019', 'RJ05GA8019', '0', '1', '0', '0'),
('3', 'ds', '0', 'sad', '0', '1', '0', '0'),
('4', 'Adardsh', '0', 'fdsdsd', '0', '1', '0', '0'),
('5', 'sadjq', '0', 'sadsafj', '0', '1', '0', '0'),
('6', 'dsa', '0', 'adsdssd', '0', '1', '0', '0'),
('7', 'sda', '0', 'saddasdsa', '0', '1', '0', '0'),
('8', 'asdasda', '0', 'asdsa', '0', '1', '0', '0'),
('9', 'asds', '0', 'asd', '0', '1', '0', '0'),
('10', 'asddasdsa', '0', 'asddasvc njsda', '0', '1', '0', '0'),
('11', '8032', '8032', 'adssad', '0', '1', '0', '0'),
('12', '8033', '8033', 'ads', '0', '1', '0', '0');

### Structure of table `0_vehicle_location_data` ###

DROP TABLE IF EXISTS `0_vehicle_location_data`;

CREATE TABLE `0_vehicle_location_data` (
  `loc_status_id` int(11) NOT NULL AUTO_INCREMENT,
  `category` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `ref_no` int(11) NOT NULL,
  `odometer_ref` int(11) NOT NULL,
  `date` date NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `log_description` varchar(200) NOT NULL,
  `loc_status` varchar(200) DEFAULT NULL,
  `accident_id` int(10) NOT NULL,
  `wo_id` int(10) NOT NULL,
  PRIMARY KEY (`loc_status_id`,`vehicle_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ;

### Data of table `0_vehicle_location_data` ###

INSERT INTO `0_vehicle_location_data` VALUES
('1', '0', '0', '1', '2', '1', '2015-01-02', 'BANGA', '', 'Arrived', '0', '0'),
('2', '0', '0', '1', '4', '2', '2015-02-10', 'BANGA', '', 'On the Way', '0', '0');

### Structure of table `0_vehicle_types` ###

DROP TABLE IF EXISTS `0_vehicle_types`;

CREATE TABLE `0_vehicle_types` (
  `vehicle_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vehicle_type_code`),
  UNIQUE KEY `description` (`vehicle_description`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_vehicle_types` ###

INSERT INTO `0_vehicle_types` VALUES
('5', 'sad', '0');

### Structure of table `0_vehicle_weight_types` ###

DROP TABLE IF EXISTS `0_vehicle_weight_types`;

CREATE TABLE `0_vehicle_weight_types` (
  `vehicle_weight_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_weight_description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vehicle_weight_type_code`),
  UNIQUE KEY `description` (`vehicle_weight_description`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ;

### Data of table `0_vehicle_weight_types` ###

INSERT INTO `0_vehicle_weight_types` VALUES
('5', 'Kg', '0');

### Structure of table `0_vehicles_master` ###

DROP TABLE IF EXISTS `0_vehicles_master`;

CREATE TABLE `0_vehicles_master` (
  `vehicle_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `description` varchar(200) NOT NULL DEFAULT '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL DEFAULT 'each',
  `mb_flag` char(1) NOT NULL DEFAULT 'B',
  `transport_account` varchar(15) NOT NULL DEFAULT '',
  `cogs_account` varchar(15) NOT NULL DEFAULT '',
  `inventory_account` varchar(15) NOT NULL DEFAULT '',
  `adjustment_account` varchar(15) NOT NULL DEFAULT '',
  `assembly_account` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` int(11) DEFAULT NULL,
  `dimension2_id` int(11) DEFAULT NULL,
  `actual_cost` double NOT NULL DEFAULT '0',
  `last_cost` double NOT NULL DEFAULT '0',
  `material_cost` double NOT NULL DEFAULT '0',
  `labour_cost` double NOT NULL DEFAULT '0',
  `overhead_cost` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  `vehicle_init_odometer` decimal(10,2) NOT NULL,
  `vehicle_warranty_odometer` decimal(10,2) NOT NULL,
  `vehicle_number_plate` varchar(20) NOT NULL DEFAULT '',
  `vehicle_sr_no` varchar(200) NOT NULL,
  `vehicle_color` varchar(20) NOT NULL,
  `vehicle_maker_name` varchar(200) NOT NULL,
  `vehicle_model_name` varchar(200) NOT NULL,
  `vehicle_year` int(10) NOT NULL,
  `vehicle_insurer_name` varchar(100) NOT NULL,
  `vehicle_insurer_company` varchar(100) NOT NULL,
  `vehicle_insurance_note` varchar(200) NOT NULL,
  `vehicle_insurance_ref` varchar(30) NOT NULL,
  `vehicle_insurance_date` date NOT NULL,
  `vehicle_insurance_expiry_date` date NOT NULL,
  `vehicle_lic_ref` varchar(100) NOT NULL,
  `vehicle_lic_note` varchar(200) NOT NULL,
  `vehicle_lic_date` date NOT NULL,
  `vehicle_lic_expiry_date` date NOT NULL,
  `vehicle_comments` varchar(200) NOT NULL,
  `vehicle_purchase_date` date NOT NULL,
  `vehicle_warranty_date` date NOT NULL,
  `vehicle_purchase_note` varchar(200) NOT NULL,
  `vehicle_wt` decimal(10,2) NOT NULL,
  `vehicle_wt_unit` int(11) NOT NULL,
  `vehicle_type_id` int(11) NOT NULL,
  `vehicle_fuel_type_id` int(11) NOT NULL,
  `vehicle_fuel_usage_id` int(11) NOT NULL,
  `vehicle_odometer_type_id` int(11) NOT NULL,
  `part_type_id` int(11) NOT NULL,
  `material_type_id` int(11) NOT NULL,
  `service_quantity` int(11) NOT NULL,
  `alarm_quantity` int(11) NOT NULL,
  `time_id` int(11) NOT NULL,
  `alarm_time_id` int(11) NOT NULL,
  PRIMARY KEY (`vehicle_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=8034 DEFAULT CHARSET=latin1 ;

### Data of table `0_vehicles_master` ###

INSERT INTO `0_vehicles_master` VALUES
('8019', '0', '0', 'RJ05GA8019', '', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '10.00', '0.00', 'RJ05GA8019', 'AFEREN123456789ADH', 'WHITE', '2011', '3116 AL', '2', '', '', '', '', '2015-03-23', '2015-03-23', '', '', '2015-03-23', '2015-03-23', '', '2015-03-23', '2015-03-23', '', '10.00', '5', '5', '6', '5', '1', '0', '0', '0', '0', '0', '0'),
('8021', '0', '0', 'asdsa', 'dsadas', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'asdsa', '', '', '', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '2015-10-27', '', '0.00', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),
('8022', '0', '0', 'asddasvc njsda', 'asd', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'asddasvc njsda', '', '', 'sad', 'sad', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', '0.00', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
('8023', '0', '0', 'asd', 'asd', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'asd', '', '', '', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '2015-10-27', '', '0.00', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),
('8024', '0', '0', 'sad', '', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'sad', '', '', '', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '2015-10-26', '', '0.00', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),
('8025', '0', '0', 'adsdssd', 'asddsa', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'adsdssd', '', '', '', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '2015-10-27', '', '0.00', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),
('8026', '0', '0', 'GJ2783', 'GJ2783', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'GJ2783', '', '', '', '', '0', '', '', '', '', '2014-12-30', '2014-12-30', '', '', '2014-12-30', '2014-12-30', '', '2014-12-30', '2014-12-30', '', '0.00', '5', '5', '5', '5', '1', '0', '0', '0', '0', '0', '0'),
('8027', '0', '0', 'sadsafj', 'asd', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'sadsafj', '', '', '', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '2015-10-27', '', '0.00', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),
('8028', '0', '0', 'saddasdsa', 'asddasdsasdasd', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'saddasdsa', '', '', '', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '2015-10-27', '', '0.00', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),
('8031', '0', '0', 'sdsad', 'sadsd', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'sdsad', '', '', 'saddas', 'asdad', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', '0.00', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
('8032', '0', '0', 'adssad', 'asddas', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'adssad', '', '', 'fdgdg', '', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', '0.00', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
('8033', '0', '0', 'ads', 'sadsad', 'each', 'B', '', '', '', '', '', NULL, NULL, '0', '0', '0', '0', '0', '0', '0', '0', '0.00', '0.00', 'ads', '', '', 'sdadsa', 'saddasdsa', '0', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', '0.00', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

### Structure of table `0_vendor_trans` ###

DROP TABLE IF EXISTS `0_vendor_trans`;

CREATE TABLE `0_vendor_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `vendor_no` int(11) unsigned DEFAULT NULL,
  `branch_code` int(11) NOT NULL DEFAULT '-1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `tpe` int(11) NOT NULL DEFAULT '0',
  `order_` int(11) NOT NULL DEFAULT '0',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `ov_freight` double NOT NULL DEFAULT '0',
  `ov_freight_tax` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ship_via` int(11) DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  PRIMARY KEY (`type`,`trans_no`),
  KEY `vendor_no` (`vendor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_vendor_trans` ###


### Structure of table `0_vendor_trans_details` ###

DROP TABLE IF EXISTS `0_vendor_trans_details`;

CREATE TABLE `0_vendor_trans_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_trans_no` int(11) DEFAULT NULL,
  `vendor_trans_type` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `qty_done` double NOT NULL DEFAULT '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`vendor_trans_type`,`vendor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_vendor_trans_details` ###


### Structure of table `0_vendors_master` ###

DROP TABLE IF EXISTS `0_vendors_master`;

CREATE TABLE `0_vendors_master` (
  `vendor_no` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(100) NOT NULL DEFAULT '',
  `vendor_birth_date` date NOT NULL,
  `hired_on` date NOT NULL,
  `licence_no` varchar(100) NOT NULL,
  `health_exam_ref` varchar(100) NOT NULL,
  `date_of_checkup` date NOT NULL,
  `vendor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `curr_code` char(3) NOT NULL DEFAULT '',
  `payment_terms` int(11) DEFAULT NULL,
  `rate` decimal(10,2) NOT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vendor_no`),
  UNIQUE KEY `vendor_ref` (`vendor_ref`),
  KEY `name` (`vendor_name`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 ;

### Data of table `0_vendors_master` ###

INSERT INTO `0_vendors_master` VALUES
('1', 'Beefeater Ltd.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Beefeater', 'Addr 1\nAddr 2\nAddr 3', 'GBP', '3', '0.00', '', '0'),
('2', 'Ghostbusters Corp.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Ghostbusters', 'Address 1\nAddress 2\nAddress 3', 'USD', '4', '0.00', '', '0'),
('3', 'Brezan', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Brezan', 'Address 1\nAddress 2\nAddress 3', 'EUR', '3', '0.00', '', '0'),
('4', 'asd', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'sad', NULL, '', NULL, '0.00', 'USD', '0'),
('5', 'dsa', '0000-00-00', '0000-00-00', 'das', '', '0000-00-00', 'dsa', 'sda', 'USD', '4', '0.00', '', '0'),
('6', 'dasdasjadsjads', '0000-00-00', '0000-00-00', 'dsa', '', '0000-00-00', 'Anurodh', 'dsa', 'USD', '4', '0.00', '', '0'),
('7', 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sda', 'sda', 'USD', '4', '0.00', '', '0'),
('8', 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sddddddda', 'sda', 'USD', '4', '0.00', '', '0'),
('9', 'das', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'dsadsdsashkgdsuhgskd', 'dasa', 'USD', '4', '0.00', '', '0'),
('10', 'dsa', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Andhrapradesh', 'das', 'USD', '4', '0.00', '', '0'),
('11', 'Avinash', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'Jeengar', 'ddhfsf', 'USD', '4', '0.00', '', '0'),
('12', 'Naehhe', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'adasdhhdas', NULL, 'USD', '4', '55.00', '', '1'),
('13', 'adnannadads', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'dasnands,,nads', 'czx', 'USD', '4', '0.00', '', '0'),
('14', 'Avinashskjd', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'fsdhfas', 'fdsfkskdfsnksd', 'USD', '4', '0.00', '', '0'),
('15', 'HKHAd', '0000-00-00', '2014-02-17', '', '', '0000-00-00', 'daljajdsjl', 'dasjllads', 'USD', '4', '0.00', '', '0');

### Structure of table `0_voided` ###

DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_voided` ###


### Structure of table `0_wo_issue_items` ###

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(40) DEFAULT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `qty_issued` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_issue_items` ###


### Structure of table `0_wo_issues` ###

DROP TABLE IF EXISTS `0_wo_issues`;

CREATE TABLE `0_wo_issues` (
  `issue_no` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `loc_code` int(11) DEFAULT NULL,
  `workcentre_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_issues` ###


### Structure of table `0_wo_manufacture` ###

DROP TABLE IF EXISTS `0_wo_manufacture`;

CREATE TABLE `0_wo_manufacture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) DEFAULT NULL,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_manufacture` ###


### Structure of table `0_wo_requirements` ###

DROP TABLE IF EXISTS `0_wo_requirements`;

CREATE TABLE `0_wo_requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `workcentre` int(11) NOT NULL DEFAULT '0',
  `vehicle_id` varchar(20) NOT NULL,
  `units_req` double NOT NULL DEFAULT '1',
  `std_cost` double NOT NULL DEFAULT '0',
  `loc_code` int(11) NOT NULL DEFAULT '1',
  `units_issued` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_wo_requirements` ###


### Structure of table `0_workcentres` ###

DROP TABLE IF EXISTS `0_workcentres`;

CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL DEFAULT '',
  `description` char(50) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ;

### Data of table `0_workcentres` ###

INSERT INTO `0_workcentres` VALUES
('1', 'Workshop', 'Workshop in Alabama', '0');

### Structure of table `0_workorders` ###

DROP TABLE IF EXISTS `0_workorders`;

CREATE TABLE `0_workorders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wo_ref` varchar(60) NOT NULL DEFAULT '',
  `loc_code` int(11) NOT NULL DEFAULT '1',
  `units_reqd` double NOT NULL DEFAULT '1',
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `vehicle_id` varchar(20) NOT NULL,
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `required_by` date NOT NULL DEFAULT '0000-00-00',
  `released_date` date NOT NULL DEFAULT '0000-00-00',
  `units_issued` double NOT NULL DEFAULT '0',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `released` tinyint(1) NOT NULL DEFAULT '0',
  `additional_costs` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

### Data of table `0_workorders` ###
