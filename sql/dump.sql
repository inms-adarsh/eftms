-- phpMyAdmin SQL Dump
-- version 2.11.11.3
-- http://www.phpmyadmin.net
--
-- Host: 118.139.179.69
-- Generation Time: Jun 14, 2014 at 12:40 PM
-- Server version: 5.0.96
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `frontaccounting`
--

-- --------------------------------------------------------

--
-- Table structure for table `0_accident_data`
--

CREATE TABLE `0_accident_data` (
  `accident_id` int(11) NOT NULL auto_increment,
  `stock_id` char(20) NOT NULL default '',
  `accident_reading` int(50) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `date` date NOT NULL,
  `accident_description` varchar(200) NOT NULL,
  PRIMARY KEY  (`accident_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_accident_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_areas`
--

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_areas`
--

INSERT INTO `0_areas` VALUES(1, 'Global', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_attachments`
--

CREATE TABLE `0_attachments` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `type_no` int(11) NOT NULL default '0',
  `trans_no` int(11) NOT NULL default '0',
  `unique_name` varchar(60) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `filename` varchar(60) NOT NULL default '',
  `filesize` int(11) NOT NULL default '0',
  `filetype` varchar(60) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_attachments`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_audit_trail`
--

CREATE TABLE `0_audit_trail` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) unsigned NOT NULL default '0',
  `trans_no` int(11) unsigned NOT NULL default '0',
  `user` smallint(6) unsigned NOT NULL default '0',
  `stamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `description` varchar(60) default NULL,
  `fiscal_year` int(11) NOT NULL,
  `gl_date` date NOT NULL default '0000-00-00',
  `gl_seq` int(11) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=153 ;

--
-- Dumping data for table `0_audit_trail`
--

INSERT INTO `0_audit_trail` VALUES(1, 33, 1, 1, '2014-04-05 13:13:08', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(2, 32, 1, 1, '2014-04-05 13:13:50', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(3, 30, 1, 1, '2014-04-10 18:45:25', '', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(4, 13, 1, 1, '2014-04-05 13:23:56', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(5, 10, 1, 1, '2014-04-05 13:24:05', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(6, 12, 1, 1, '2014-04-05 13:24:05', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(7, 16, 2, 1, '2014-04-05 13:30:44', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(8, 16, 3, 1, '2014-04-05 13:33:06', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(9, 32, 2, 1, '2014-04-05 13:46:51', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(10, 30, 2, 1, '2014-04-11 18:07:46', '', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(11, 13, 2, 1, '2014-04-05 13:47:20', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(12, 10, 2, 1, '2014-04-05 13:47:28', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(13, 12, 2, 1, '2014-04-05 13:47:28', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(14, 32, 3, 1, '2014-04-05 14:18:01', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(15, 30, 3, 1, '2014-04-11 19:49:24', '', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(16, 13, 3, 1, '2014-04-05 14:18:42', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(17, 10, 3, 1, '2014-04-05 14:18:49', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(18, 30, 4, 1, '2014-04-05 14:19:56', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(19, 13, 4, 1, '2014-04-05 14:19:56', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(20, 10, 4, 1, '2014-04-05 14:20:05', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(21, 4, 1, 1, '2014-04-05 14:25:46', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(22, 33, 2, 1, '2014-04-05 15:00:36', '', 7, '2014-04-08', 0);
INSERT INTO `0_audit_trail` VALUES(23, 33, 3, 1, '2014-04-05 17:27:04', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(24, 32, 4, 1, '2014-04-05 17:30:21', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(25, 33, 4, 1, '2014-04-05 17:56:12', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(26, 32, 5, 1, '2014-04-05 17:56:30', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(27, 30, 5, 1, '2014-04-05 18:03:00', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(28, 30, 6, 1, '2014-04-05 18:06:18', '', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(29, 32, 6, 1, '2014-04-06 17:56:59', '', 7, '2014-04-06', 0);
INSERT INTO `0_audit_trail` VALUES(30, 32, 7, 1, '2014-04-06 17:57:41', '', 7, '2014-04-06', 0);
INSERT INTO `0_audit_trail` VALUES(31, 32, 8, 1, '2014-04-06 17:59:35', '', 7, '2014-04-06', 0);
INSERT INTO `0_audit_trail` VALUES(32, 30, 1, 1, '2014-04-10 18:48:11', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(33, 30, 1, 1, '2014-04-10 19:34:36', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(34, 30, 1, 1, '2014-04-10 19:35:48', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(35, 30, 1, 1, '2014-04-10 19:35:48', 'Updated.', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(36, 30, 2, 1, '2014-04-11 19:13:18', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(37, 30, 2, 1, '2014-04-11 19:16:42', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(38, 30, 2, 1, '2014-04-11 19:21:17', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(39, 30, 2, 1, '2014-04-11 19:22:23', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(40, 30, 2, 1, '2014-04-11 19:30:12', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(41, 30, 2, 1, '2014-04-11 19:40:50', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(42, 30, 2, 1, '2014-04-11 19:48:12', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(43, 30, 2, 1, '2014-04-12 19:54:05', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(44, 30, 3, 1, '2014-04-11 19:49:24', 'Updated.', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(45, 30, 2, 1, '2014-04-12 19:59:18', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(46, 30, 2, 1, '2014-04-12 20:00:29', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(47, 30, 2, 1, '2014-04-12 20:01:09', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(48, 30, 2, 1, '2014-04-12 20:19:45', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(49, 30, 2, 1, '2014-04-12 20:23:09', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(50, 30, 2, 1, '2014-04-12 20:25:56', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(51, 30, 2, 1, '2014-04-12 20:28:56', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(52, 30, 2, 1, '2014-04-12 20:31:06', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(53, 30, 2, 1, '2014-04-12 20:45:53', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(54, 30, 2, 1, '2014-04-12 20:48:26', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(55, 30, 2, 1, '2014-04-12 21:02:16', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(56, 30, 2, 1, '2014-04-12 21:20:29', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(57, 30, 2, 1, '2014-04-12 21:22:09', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(58, 30, 2, 1, '2014-04-12 21:29:04', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(59, 30, 2, 1, '2014-04-12 21:35:39', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(60, 30, 2, 1, '2014-04-18 15:57:01', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(61, 33, 0, 1, '2014-04-18 15:07:37', 'Deleted.', 7, '2014-04-18', NULL);
INSERT INTO `0_audit_trail` VALUES(62, 33, 0, 1, '2014-05-09 21:02:16', 'Deleted.', 7, '2014-04-18', NULL);
INSERT INTO `0_audit_trail` VALUES(63, 30, 2, 1, '2014-04-18 15:58:38', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(64, 30, 2, 1, '2014-04-18 16:05:54', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(65, 30, 2, 1, '2014-04-18 16:08:38', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(66, 30, 2, 1, '2014-04-19 19:44:19', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(67, 30, 2, 1, '2014-04-19 19:48:13', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(68, 30, 2, 1, '2014-04-19 19:51:37', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(69, 30, 2, 1, '2014-04-19 19:58:47', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(70, 33, 5, 1, '2014-04-19 19:59:19', '', 7, '2014-04-19', NULL);
INSERT INTO `0_audit_trail` VALUES(71, 30, 2, 1, '2014-04-19 21:23:18', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(72, 33, 5, 1, '2014-04-19 19:59:19', 'Updated.', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(73, 32, 9, 1, '2014-04-19 19:59:38', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(74, 30, 7, 1, '2014-04-19 20:00:27', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(75, 13, 5, 1, '2014-04-19 20:01:33', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(76, 10, 5, 1, '2014-04-19 20:02:32', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(77, 12, 3, 1, '2014-04-19 20:02:32', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(78, 32, 10, 1, '2014-04-19 20:08:04', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(79, 30, 8, 1, '2014-04-19 20:08:38', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(80, 13, 6, 1, '2014-04-19 20:09:46', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(81, 10, 6, 1, '2014-04-19 20:10:15', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(82, 12, 4, 1, '2014-04-19 20:10:15', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(83, 32, 11, 1, '2014-04-19 20:30:49', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(84, 30, 9, 1, '2014-04-19 20:31:24', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(85, 13, 7, 1, '2014-04-19 20:31:45', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(86, 32, 12, 1, '2014-04-19 20:37:52', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(87, 30, 10, 1, '2014-04-19 20:55:04', '', 7, '2014-04-19', NULL);
INSERT INTO `0_audit_trail` VALUES(88, 13, 8, 1, '2014-04-19 20:38:46', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(89, 10, 7, 1, '2014-04-19 20:39:04', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(90, 12, 5, 1, '2014-04-19 20:39:04', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(91, 30, 10, 1, '2014-04-19 20:56:09', 'Updated.', 7, '2014-04-19', NULL);
INSERT INTO `0_audit_trail` VALUES(92, 30, 10, 1, '2014-04-19 20:56:09', 'Updated.', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(93, 13, 9, 1, '2014-04-19 20:56:20', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(94, 13, 10, 1, '2014-04-19 21:06:23', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(95, 10, 8, 1, '2014-04-23 18:19:55', '', 7, '2014-04-19', NULL);
INSERT INTO `0_audit_trail` VALUES(96, 12, 6, 1, '2014-04-19 21:19:47', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(97, 30, 2, 1, '2014-04-19 22:17:57', 'Updated.', 7, '2014-04-05', NULL);
INSERT INTO `0_audit_trail` VALUES(98, 32, 13, 1, '2014-04-19 21:36:08', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(99, 30, 11, 1, '2014-04-19 21:36:43', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(100, 13, 11, 1, '2014-04-19 21:36:55', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(101, 10, 9, 1, '2014-04-19 21:37:10', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(102, 12, 7, 1, '2014-04-19 21:37:10', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(103, 32, 14, 1, '2014-04-19 21:54:49', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(104, 30, 12, 1, '2014-04-19 21:57:33', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(105, 32, 15, 1, '2014-04-19 22:00:37', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(106, 30, 2, 1, '2014-04-19 22:17:57', 'Updated.', 7, '2014-04-05', 0);
INSERT INTO `0_audit_trail` VALUES(107, 13, 12, 1, '2014-04-19 22:18:18', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(108, 10, 10, 1, '2014-04-19 22:18:32', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(109, 12, 8, 1, '2014-04-19 22:18:32', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(110, 33, 6, 1, '2014-04-19 22:24:15', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(111, 32, 16, 1, '2014-04-19 22:24:32', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(112, 30, 13, 1, '2014-04-19 22:41:01', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(113, 30, 14, 1, '2014-04-19 22:43:12', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(114, 13, 13, 1, '2014-04-19 22:45:06', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(115, 10, 11, 1, '2014-04-19 22:45:22', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(116, 12, 9, 1, '2014-04-19 22:45:22', '', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(117, 33, 7, 1, '2014-04-23 17:13:58', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(118, 32, 17, 1, '2014-04-23 17:14:31', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(119, 30, 15, 1, '2014-04-23 17:15:19', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(120, 13, 14, 1, '2014-04-23 17:15:37', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(121, 10, 12, 1, '2014-04-23 17:15:44', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(122, 12, 10, 1, '2014-04-23 17:15:44', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(123, 30, 16, 1, '2014-04-23 17:29:47', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(124, 13, 15, 1, '2014-04-23 17:29:47', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(125, 10, 13, 1, '2014-04-23 17:29:47', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(126, 12, 11, 1, '2014-04-23 17:29:47', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(127, 30, 17, 1, '2014-04-23 17:32:16', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(128, 13, 16, 1, '2014-04-23 17:32:16', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(129, 10, 14, 1, '2014-04-23 17:32:16', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(130, 12, 12, 1, '2014-04-23 17:32:16', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(131, 11, 1, 1, '2014-04-23 18:18:36', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(132, 10, 8, 1, '2014-04-23 18:19:55', 'Updated.', 7, '2014-04-19', 0);
INSERT INTO `0_audit_trail` VALUES(133, 33, 8, 1, '2014-04-23 18:31:15', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(134, 32, 18, 1, '2014-04-23 18:31:41', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(135, 33, 9, 1, '2014-04-23 12:04:00', '', 7, '2014-04-23', 0);
INSERT INTO `0_audit_trail` VALUES(136, 33, 10, 1, '2014-05-09 21:00:05', '', 7, '2014-05-09', 0);
INSERT INTO `0_audit_trail` VALUES(137, 33, 11, 1, '2014-05-09 21:01:31', '', 7, '2014-05-09', 0);
INSERT INTO `0_audit_trail` VALUES(138, 33, 0, 1, '2014-05-09 21:02:16', 'Deleted.', 7, '2014-05-09', 0);
INSERT INTO `0_audit_trail` VALUES(139, 33, 12, 1, '2014-05-30 02:43:17', '', 7, '2014-05-30', 0);
INSERT INTO `0_audit_trail` VALUES(140, 33, 13, 1, '2014-06-14 06:57:20', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(141, 32, 19, 1, '2014-06-14 06:57:53', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(142, 33, 14, 1, '2014-06-14 07:17:40', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(143, 32, 20, 1, '2014-06-14 07:18:37', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(144, 33, 15, 1, '2014-06-14 07:19:30', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(145, 32, 21, 1, '2014-06-14 07:19:47', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(146, 30, 18, 1, '2014-06-14 07:21:17', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(147, 13, 17, 1, '2014-06-14 07:21:31', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(148, 10, 15, 1, '2014-06-14 07:21:44', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(149, 12, 13, 1, '2014-06-14 07:21:44', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(150, 33, 16, 1, '2014-06-14 07:30:54', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(151, 33, 17, 1, '2014-06-14 07:33:08', '', 7, '2014-06-14', 0);
INSERT INTO `0_audit_trail` VALUES(152, 33, 18, 1, '2014-06-14 11:38:35', '', 7, '2014-06-14', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_bank_accounts`
--

CREATE TABLE `0_bank_accounts` (
  `account_code` varchar(15) NOT NULL default '',
  `account_type` smallint(6) NOT NULL default '0',
  `bank_account_name` varchar(60) NOT NULL default '',
  `bank_account_number` varchar(100) NOT NULL default '',
  `bank_name` varchar(60) NOT NULL default '',
  `bank_address` tinytext,
  `bank_curr_code` char(3) NOT NULL default '',
  `dflt_curr_act` tinyint(1) NOT NULL default '0',
  `id` smallint(6) NOT NULL auto_increment,
  `last_reconciled_date` timestamp NOT NULL default '0000-00-00 00:00:00',
  `ending_reconcile_balance` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `bank_account_name` (`bank_account_name`),
  KEY `bank_account_number` (`bank_account_number`),
  KEY `account_code` (`account_code`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_bank_accounts`
--

INSERT INTO `0_bank_accounts` VALUES('1060', 0, 'Current account', '9999999999', 'Wachovia Bank', NULL, 'INR', 0, 1, '0000-00-00 00:00:00', 0, 0);
INSERT INTO `0_bank_accounts` VALUES('1065', 3, 'Petty Cash account', 'N/A', 'N/A', NULL, 'INR', 0, 2, '0000-00-00 00:00:00', 0, 0);
INSERT INTO `0_bank_accounts` VALUES('1061', 3, 'Citi Bank Account', '8282382', 'Citi Bank', 'fhfd', 'INR', 1, 3, '2014-01-10 18:30:00', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_bank_trans`
--

CREATE TABLE `0_bank_trans` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) default NULL,
  `trans_no` int(11) default NULL,
  `bank_act` varchar(15) NOT NULL default '',
  `ref` varchar(40) default NULL,
  `trans_date` date NOT NULL default '0000-00-00',
  `amount` double default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `person_type_id` int(11) NOT NULL default '0',
  `person_id` tinyblob,
  `reconciled` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `bank_act` (`bank_act`,`ref`),
  KEY `type` (`type`,`trans_no`),
  KEY `bank_act_2` (`bank_act`,`reconciled`),
  KEY `bank_act_3` (`bank_act`,`trans_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `0_bank_trans`
--

INSERT INTO `0_bank_trans` VALUES(1, 12, 1, '2', '55', '2014-04-05', 120, 0, 0, 2, 0x31, NULL);
INSERT INTO `0_bank_trans` VALUES(2, 12, 2, '2', '56', '2014-04-05', 10000, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(3, 4, 1, '2', '4', '2014-04-05', -10000, 0, 0, 0, 0x46726f6d2050657474792043617368206163636f756e7420546f20436974692042616e6b204163636f756e74, NULL);
INSERT INTO `0_bank_trans` VALUES(4, 4, 1, '3', '4', '2014-04-05', 10000, 0, 0, 0, 0x46726f6d2050657474792043617368206163636f756e7420546f20436974692042616e6b204163636f756e74, NULL);
INSERT INTO `0_bank_trans` VALUES(5, 12, 3, '2', '57', '2014-04-19', 1340, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(6, 12, 4, '2', '58', '2014-04-19', 23370, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(7, 12, 5, '2', '59', '2014-04-19', 2340, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(8, 12, 6, '2', '60', '2014-04-19', 65920, 0, 0, 2, 0x31, NULL);
INSERT INTO `0_bank_trans` VALUES(9, 12, 7, '2', '61', '2014-04-19', 3795, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(10, 12, 8, '2', '62', '2014-04-19', 5023.1, 0, 0, 2, 0x31, NULL);
INSERT INTO `0_bank_trans` VALUES(11, 12, 9, '2', '63', '2014-04-19', 28005, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(12, 12, 10, '2', '64', '2014-04-23', 6125, 0, 0, 2, 0x32, NULL);
INSERT INTO `0_bank_trans` VALUES(13, 12, 11, '2', '65', '2014-04-23', 132, 0, 0, 2, 0x31, NULL);
INSERT INTO `0_bank_trans` VALUES(14, 12, 12, '2', '66', '2014-04-23', 472, 0, 0, 2, 0x31, NULL);
INSERT INTO `0_bank_trans` VALUES(15, 12, 13, '2', '67', '2014-06-14', 22, 0, 0, 2, 0x31, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `0_bom`
--

CREATE TABLE `0_bom` (
  `id` int(11) NOT NULL auto_increment,
  `parent` char(20) NOT NULL default '',
  `component` char(20) NOT NULL default '',
  `workcentre_added` int(11) NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `vehicle_id` varchar(20) NOT NULL,
  `quantity` double NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `component` (`component`),
  KEY `id` (`id`),
  KEY `loc_code` (`loc_code`),
  KEY `parent` (`parent`,`loc_code`),
  KEY `workcentre_added` (`workcentre_added`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_bom`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_budget_trans`
--

CREATE TABLE `0_budget_trans` (
  `counter` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL default '0',
  `type_no` bigint(16) NOT NULL default '1',
  `tran_date` date NOT NULL default '0000-00-00',
  `account` varchar(15) NOT NULL default '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL default '0',
  `dimension_id` int(11) default '0',
  `dimension2_id` int(11) default '0',
  `person_type_id` int(11) default NULL,
  `person_id` tinyblob,
  PRIMARY KEY  (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `Account` (`account`,`tran_date`,`dimension_id`,`dimension2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_budget_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_chart_class`
--

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL default '',
  `ctype` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_chart_class`
--

INSERT INTO `0_chart_class` VALUES('1', 'Assets', 1, 0);
INSERT INTO `0_chart_class` VALUES('2', 'Liabilities', 2, 0);
INSERT INTO `0_chart_class` VALUES('3', 'Income', 4, 0);
INSERT INTO `0_chart_class` VALUES('4', 'Costs', 6, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_chart_master`
--

CREATE TABLE `0_chart_master` (
  `account_code` varchar(15) NOT NULL default '',
  `account_code2` varchar(15) NOT NULL default '',
  `account_name` varchar(60) NOT NULL default '',
  `account_type` varchar(10) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_chart_master`
--

INSERT INTO `0_chart_master` VALUES('1060', '', 'Checking Account', '1', 0);
INSERT INTO `0_chart_master` VALUES('1065', '', 'Petty Cash', '1', 0);
INSERT INTO `0_chart_master` VALUES('1200', '', 'Accounts Receivables', '1', 0);
INSERT INTO `0_chart_master` VALUES('1205', '', 'Allowance for doubtful accounts', '1', 0);
INSERT INTO `0_chart_master` VALUES('1510', '', 'Inventory', '2', 0);
INSERT INTO `0_chart_master` VALUES('1520', '', 'Stocks of Raw Materials', '2', 0);
INSERT INTO `0_chart_master` VALUES('1530', '', 'Stocks of Work In Progress', '2', 0);
INSERT INTO `0_chart_master` VALUES('1540', '', 'Stocks of Finsihed Goods', '2', 0);
INSERT INTO `0_chart_master` VALUES('1550', '', 'Goods Received Clearing account', '2', 0);
INSERT INTO `0_chart_master` VALUES('1820', '', 'Office Furniture &amp; Equipment', '3', 0);
INSERT INTO `0_chart_master` VALUES('1825', '', 'Accum. Amort. -Furn. &amp; Equip.', '3', 0);
INSERT INTO `0_chart_master` VALUES('1840', '', 'Vehicle', '3', 0);
INSERT INTO `0_chart_master` VALUES('1845', '', 'Accum. Amort. -Vehicle', '3', 0);
INSERT INTO `0_chart_master` VALUES('2100', '', 'Accounts Payable', '4', 0);
INSERT INTO `0_chart_master` VALUES('2110', '', 'Accrued Income Tax - Federal', '4', 0);
INSERT INTO `0_chart_master` VALUES('2120', '', 'Accrued Income Tax - State', '4', 0);
INSERT INTO `0_chart_master` VALUES('2130', '', 'Accrued Franchise Tax', '4', 0);
INSERT INTO `0_chart_master` VALUES('2140', '', 'Accrued Real &amp; Personal Prop Tax', '4', 0);
INSERT INTO `0_chart_master` VALUES('2150', '', 'Transport Tax', '4', 0);
INSERT INTO `0_chart_master` VALUES('2160', '', 'Accrued Use Tax Payable', '4', 0);
INSERT INTO `0_chart_master` VALUES('2210', '', 'Accrued Wages', '4', 0);
INSERT INTO `0_chart_master` VALUES('2220', '', 'Accrued Comp Time', '4', 0);
INSERT INTO `0_chart_master` VALUES('2230', '', 'Accrued Holiday Pay', '4', 0);
INSERT INTO `0_chart_master` VALUES('2240', '', 'Accrued Vacation Pay', '4', 0);
INSERT INTO `0_chart_master` VALUES('2310', '', 'Accr. Benefits - 401K', '4', 0);
INSERT INTO `0_chart_master` VALUES('2320', '', 'Accr. Benefits - Stock Purchase', '4', 0);
INSERT INTO `0_chart_master` VALUES('2330', '', 'Accr. Benefits - Med, Den', '4', 0);
INSERT INTO `0_chart_master` VALUES('2340', '', 'Accr. Benefits - Payroll Taxes', '4', 0);
INSERT INTO `0_chart_master` VALUES('2350', '', 'Accr. Benefits - Credit Union', '4', 0);
INSERT INTO `0_chart_master` VALUES('2360', '', 'Accr. Benefits - Savings Bond', '4', 0);
INSERT INTO `0_chart_master` VALUES('2370', '', 'Accr. Benefits - Garnish', '4', 0);
INSERT INTO `0_chart_master` VALUES('2380', '', 'Accr. Benefits - Charity Cont.', '4', 0);
INSERT INTO `0_chart_master` VALUES('2620', '', 'Bank Loans', '5', 0);
INSERT INTO `0_chart_master` VALUES('2680', '', 'Loans from Shareholders', '5', 0);
INSERT INTO `0_chart_master` VALUES('3350', '', 'Common Shares', '6', 0);
INSERT INTO `0_chart_master` VALUES('3590', '', 'Retained Earnings - prior years', '7', 0);
INSERT INTO `0_chart_master` VALUES('4010', '', 'Transport', '8', 0);
INSERT INTO `0_chart_master` VALUES('4430', '', 'Shipping &amp; Handling', '9', 0);
INSERT INTO `0_chart_master` VALUES('4440', '', 'Interest', '9', 0);
INSERT INTO `0_chart_master` VALUES('4450', '', 'Foreign Exchange Gain', '9', 0);
INSERT INTO `0_chart_master` VALUES('4500', '', 'Prompt Payment Discounts', '9', 0);
INSERT INTO `0_chart_master` VALUES('4510', '', 'Discounts Given', '9', 0);
INSERT INTO `0_chart_master` VALUES('5010', '', 'Cost of Goods Sold - Retail', '10', 0);
INSERT INTO `0_chart_master` VALUES('5020', '', 'Material Usage Varaiance', '10', 0);
INSERT INTO `0_chart_master` VALUES('5030', '', 'Consumable Materials', '10', 0);
INSERT INTO `0_chart_master` VALUES('5040', '', 'Purchase price Variance', '10', 0);
INSERT INTO `0_chart_master` VALUES('5050', '', 'Purchases of materials', '10', 0);
INSERT INTO `0_chart_master` VALUES('5060', '', 'Discounts Received', '10', 0);
INSERT INTO `0_chart_master` VALUES('5100', '', 'Freight', '10', 0);
INSERT INTO `0_chart_master` VALUES('5410', '', 'Wages &amp; Salaries', '11', 0);
INSERT INTO `0_chart_master` VALUES('5420', '', 'Wages - Overtime', '11', 0);
INSERT INTO `0_chart_master` VALUES('5430', '', 'Benefits - Comp Time', '11', 0);
INSERT INTO `0_chart_master` VALUES('5440', '', 'Benefits - Payroll Taxes', '11', 0);
INSERT INTO `0_chart_master` VALUES('5450', '', 'Benefits - Workers Comp', '11', 0);
INSERT INTO `0_chart_master` VALUES('5460', '', 'Benefits - Pension', '11', 0);
INSERT INTO `0_chart_master` VALUES('5470', '', 'Benefits - General Benefits', '11', 0);
INSERT INTO `0_chart_master` VALUES('5510', '', 'Inc Tax Exp - Federal', '11', 0);
INSERT INTO `0_chart_master` VALUES('5520', '', 'Inc Tax Exp - State', '11', 0);
INSERT INTO `0_chart_master` VALUES('5530', '', 'Taxes - Real Estate', '11', 0);
INSERT INTO `0_chart_master` VALUES('5540', '', 'Taxes - Personal Property', '11', 0);
INSERT INTO `0_chart_master` VALUES('5550', '', 'Taxes - Franchise', '11', 0);
INSERT INTO `0_chart_master` VALUES('5560', '', 'Taxes - Foreign Withholding', '11', 0);
INSERT INTO `0_chart_master` VALUES('5610', '', 'Accounting &amp; Legal', '12', 0);
INSERT INTO `0_chart_master` VALUES('5615', '', 'Advertising &amp; Promotions', '12', 0);
INSERT INTO `0_chart_master` VALUES('5620', '', 'Bad Debts', '12', 0);
INSERT INTO `0_chart_master` VALUES('5660', '', 'Amortization Expense', '12', 0);
INSERT INTO `0_chart_master` VALUES('5685', '', 'Insurance', '12', 0);
INSERT INTO `0_chart_master` VALUES('5690', '', 'Interest &amp; Bank Charges', '12', 0);
INSERT INTO `0_chart_master` VALUES('5700', '', 'Office Supplies', '12', 0);
INSERT INTO `0_chart_master` VALUES('5760', '', 'Rent', '12', 0);
INSERT INTO `0_chart_master` VALUES('5765', '', 'Repair &amp; Maintenance', '12', 0);
INSERT INTO `0_chart_master` VALUES('5780', '', 'Telephone', '12', 0);
INSERT INTO `0_chart_master` VALUES('5785', '', 'Travel &amp; Entertainment', '12', 0);
INSERT INTO `0_chart_master` VALUES('5790', '', 'Utilities', '12', 0);
INSERT INTO `0_chart_master` VALUES('5795', '', 'Registrations', '12', 0);
INSERT INTO `0_chart_master` VALUES('5800', '', 'Licenses', '12', 0);
INSERT INTO `0_chart_master` VALUES('5810', '', 'Foreign Exchange Loss', '12', 0);
INSERT INTO `0_chart_master` VALUES('9990', '', 'Year Profit/Loss', '12', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_chart_types`
--

CREATE TABLE `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL default '',
  `class_id` varchar(3) NOT NULL default '',
  `parent` varchar(10) NOT NULL default '-1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_chart_types`
--

INSERT INTO `0_chart_types` VALUES('1', 'Current Assets', '1', '', 0);
INSERT INTO `0_chart_types` VALUES('2', 'Inventory Assets', '1', '', 0);
INSERT INTO `0_chart_types` VALUES('3', 'Capital Assets', '1', '', 0);
INSERT INTO `0_chart_types` VALUES('4', 'Current Liabilities', '2', '', 0);
INSERT INTO `0_chart_types` VALUES('5', 'Long Term Liabilities', '2', '', 0);
INSERT INTO `0_chart_types` VALUES('6', 'Share Capital', '2', '', 0);
INSERT INTO `0_chart_types` VALUES('7', 'Retained Earnings', '2', '', 0);
INSERT INTO `0_chart_types` VALUES('8', 'Transport Revenue', '3', '', 0);
INSERT INTO `0_chart_types` VALUES('9', 'Other Revenue', '3', '', 0);
INSERT INTO `0_chart_types` VALUES('10', 'Cost of Goods Sold', '4', '', 0);
INSERT INTO `0_chart_types` VALUES('11', 'Payroll Expenses', '4', '', 0);
INSERT INTO `0_chart_types` VALUES('12', 'General &amp; Administrative expenses', '4', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_comments`
--

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date default '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_comments`
--

INSERT INTO `0_comments` VALUES(13, 1, '2014-04-05', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(10, 1, '2014-04-05', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(12, 1, '2014-04-05', 'Cash invoice 1');
INSERT INTO `0_comments` VALUES(13, 2, '2014-04-05', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(10, 2, '2014-04-05', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(12, 2, '2014-04-05', 'Cash invoice 2');
INSERT INTO `0_comments` VALUES(13, 3, '2014-04-05', 'Loading Slip # 3');
INSERT INTO `0_comments` VALUES(10, 3, '2014-04-05', 'Loading Slip # 3');
INSERT INTO `0_comments` VALUES(13, 4, '2014-04-05', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(10, 4, '2014-04-05', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(13, 5, '2014-04-19', 'Loading Slip # 9');
INSERT INTO `0_comments` VALUES(10, 5, '2014-04-19', 'Loading Slip # 9');
INSERT INTO `0_comments` VALUES(12, 3, '2014-04-19', 'Cash invoice 5');
INSERT INTO `0_comments` VALUES(13, 6, '2014-04-19', 'Loading Slip # 10');
INSERT INTO `0_comments` VALUES(10, 6, '2014-04-19', 'Loading Slip # 10');
INSERT INTO `0_comments` VALUES(12, 4, '2014-04-19', 'Cash invoice 6');
INSERT INTO `0_comments` VALUES(13, 7, '2014-04-19', 'Loading Slip # 11');
INSERT INTO `0_comments` VALUES(13, 8, '2014-04-19', 'Loading Slip # 12');
INSERT INTO `0_comments` VALUES(10, 7, '2014-04-19', 'Loading Slip # 12');
INSERT INTO `0_comments` VALUES(12, 5, '2014-04-19', 'Cash invoice 7');
INSERT INTO `0_comments` VALUES(13, 9, '2014-04-19', 'Loading Slip # 12');
INSERT INTO `0_comments` VALUES(13, 10, '2014-04-19', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(12, 6, '2014-04-19', 'Cash invoice 8');
INSERT INTO `0_comments` VALUES(13, 11, '2014-04-19', 'Loading Slip # 13');
INSERT INTO `0_comments` VALUES(10, 9, '2014-04-19', 'Loading Slip # 13');
INSERT INTO `0_comments` VALUES(12, 7, '2014-04-19', 'Cash invoice 9');
INSERT INTO `0_comments` VALUES(13, 12, '2014-04-19', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(10, 10, '2014-04-19', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(12, 8, '2014-04-19', 'Cash invoice 10');
INSERT INTO `0_comments` VALUES(13, 13, '2014-04-19', 'Loading Slip # 15');
INSERT INTO `0_comments` VALUES(10, 11, '2014-04-19', 'Loading Slip # 15');
INSERT INTO `0_comments` VALUES(12, 9, '2014-04-19', 'Cash invoice 11');
INSERT INTO `0_comments` VALUES(13, 14, '2014-04-23', 'Loading Slip # 17');
INSERT INTO `0_comments` VALUES(10, 12, '2014-04-23', 'Loading Slip # 17');
INSERT INTO `0_comments` VALUES(12, 10, '2014-04-23', 'Cash invoice 12');
INSERT INTO `0_comments` VALUES(13, 15, '2014-04-23', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(10, 13, '2014-04-23', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(12, 11, '2014-04-23', 'Cash invoice 13');
INSERT INTO `0_comments` VALUES(13, 16, '2014-04-23', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(10, 14, '2014-04-23', 'Loading Slip # 1');
INSERT INTO `0_comments` VALUES(12, 12, '2014-04-23', 'Cash invoice 14');
INSERT INTO `0_comments` VALUES(11, 1, '2014-04-23', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(10, 8, '2014-04-19', 'Loading Slip # 2');
INSERT INTO `0_comments` VALUES(13, 17, '2014-06-14', 'Loading Slip # 21');
INSERT INTO `0_comments` VALUES(10, 15, '2014-06-14', 'Loading Slip # 21');
INSERT INTO `0_comments` VALUES(12, 13, '2014-06-14', 'Cash invoice 15');

-- --------------------------------------------------------

--
-- Table structure for table `0_consignees_master`
--

CREATE TABLE `0_consignees_master` (
  `consignee_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `consignee_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL default '',
  `curr_code` char(3) NOT NULL default '',
  `credit_status` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  `discount` double NOT NULL default '0',
  `pymt_discount` double NOT NULL default '0',
  `credit_limit` float NOT NULL default '1000',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`consignee_no`),
  UNIQUE KEY `consignee_ref` (`consignee_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_consignees_master`
--

INSERT INTO `0_consignees_master` VALUES(1, 'New Consignee', 'Consignee', 'asdsa', '', 'INR', 1, 4, 0, 0, 1000, '', 0);
INSERT INTO `0_consignees_master` VALUES(2, 'Consignee2', 'Consignee2', 'dasda', '', 'INR', 1, 4, 0, 0, 1000, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_consignee_allocations`
--

CREATE TABLE `0_consignee_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_consignee_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_consignee_branch`
--

CREATE TABLE `0_consignee_branch` (
  `consignee_branch_code` int(11) NOT NULL auto_increment,
  `consignee_no` int(11) NOT NULL default '0',
  `br_name` varchar(60) NOT NULL default '',
  `consignee_branch_ref` varchar(30) NOT NULL default '',
  `tin_no` varchar(20) NOT NULL,
  `br_address` tinytext NOT NULL,
  `area` int(11) default NULL,
  `transportman` int(11) NOT NULL default '0',
  `contact_name` varchar(60) NOT NULL default '',
  `default_location` varchar(5) NOT NULL default '',
  `tax_group_id` int(11) default NULL,
  `transport_account` varchar(15) NOT NULL default '',
  `transport_discount_account` varchar(15) NOT NULL default '',
  `receivables_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `default_ship_via` int(11) NOT NULL default '1',
  `disable_trans` tinyint(4) NOT NULL default '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL default '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`consignee_branch_code`,`consignee_no`),
  KEY `branch_code` (`consignee_branch_code`),
  KEY `branch_ref` (`consignee_branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_consignee_branch`
--

INSERT INTO `0_consignee_branch` VALUES(1, 1, 'New Consignee', 'Consignee', 'asdasd', 'asdsa', 1, 2, '', 'DEF', 1, '', '', '', '', 1, 0, 'addsdas', 2, 'asdsa', 0);
INSERT INTO `0_consignee_branch` VALUES(2, 2, 'Consignee2', 'Consignee2', 'ads', 'dasda', 1, 2, '', '', 1, '', '', '', '', 0, 0, '4510', 4500, 'dasda', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_consignee_trans`
--

CREATE TABLE `0_consignee_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `consignee_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `consignee_no` (`consignee_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_consignee_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_consignee_trans_details`
--

CREATE TABLE `0_consignee_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `consignee_trans_no` int(11) default NULL,
  `consignee_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`consignee_trans_type`,`consignee_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_consignee_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_consignors_master`
--

CREATE TABLE `0_consignors_master` (
  `consignor_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `consignor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL default '',
  `curr_code` char(3) NOT NULL default '',
  `transport_type` int(11) NOT NULL default '1',
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `credit_status` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  `discount` double NOT NULL default '0',
  `pymt_discount` double NOT NULL default '0',
  `credit_limit` float NOT NULL default '1000',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`consignor_no`),
  UNIQUE KEY `consignor_ref` (`consignor_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_consignors_master`
--

INSERT INTO `0_consignors_master` VALUES(1, 'New', 'sda', 'sdad', '', 'INR', 2, 0, 0, 1, 4, 0, 0, 1000, '', 0);
INSERT INTO `0_consignors_master` VALUES(2, 'Adarsh Somani', 'Adarsh', '', '', 'INR', 2, 0, 0, 1, 4, 0, 0, 1000, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_consignor_allocations`
--

CREATE TABLE `0_consignor_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `0_consignor_allocations`
--

INSERT INTO `0_consignor_allocations` VALUES(1, 120, '2014-04-05', 1, 12, 1, 10);
INSERT INTO `0_consignor_allocations` VALUES(2, 10000, '2014-04-05', 2, 12, 2, 10);
INSERT INTO `0_consignor_allocations` VALUES(3, 1340, '2014-04-20', 3, 12, 5, 10);
INSERT INTO `0_consignor_allocations` VALUES(4, 23370, '2014-04-20', 4, 12, 6, 10);
INSERT INTO `0_consignor_allocations` VALUES(5, 2340, '2014-04-20', 5, 12, 7, 10);
INSERT INTO `0_consignor_allocations` VALUES(7, 3795, '2014-04-20', 7, 12, 9, 10);
INSERT INTO `0_consignor_allocations` VALUES(9, 28005, '2014-04-20', 9, 12, 11, 10);
INSERT INTO `0_consignor_allocations` VALUES(10, 6125, '2014-04-23', 10, 12, 12, 10);
INSERT INTO `0_consignor_allocations` VALUES(11, 132, '2014-04-23', 11, 12, 13, 10);
INSERT INTO `0_consignor_allocations` VALUES(12, 472, '2014-04-23', 12, 12, 14, 10);
INSERT INTO `0_consignor_allocations` VALUES(13, 1502.1, '2014-04-23', 8, 12, 10, 10);
INSERT INTO `0_consignor_allocations` VALUES(14, 3521, '2014-04-23', 1, 11, 10, 10);
INSERT INTO `0_consignor_allocations` VALUES(15, 22, '2014-06-14', 13, 12, 15, 10);

-- --------------------------------------------------------

--
-- Table structure for table `0_consignor_branch`
--

CREATE TABLE `0_consignor_branch` (
  `branch_code` int(11) NOT NULL auto_increment,
  `consignor_no` int(11) NOT NULL default '0',
  `br_name` varchar(60) NOT NULL default '',
  `branch_ref` varchar(30) NOT NULL default '',
  `tin_no` varchar(20) NOT NULL,
  `br_address` tinytext NOT NULL,
  `area` int(11) default NULL,
  `transportman` int(11) NOT NULL default '0',
  `contact_name` varchar(60) NOT NULL default '',
  `default_location` varchar(5) NOT NULL default '',
  `tax_group_id` int(11) default NULL,
  `transport_account` varchar(15) NOT NULL default '',
  `transport_discount_account` varchar(15) NOT NULL default '',
  `receivables_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `default_ship_via` int(11) NOT NULL default '1',
  `disable_trans` tinyint(4) NOT NULL default '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL default '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`branch_code`,`consignor_no`),
  KEY `branch_code` (`branch_code`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_consignor_branch`
--

INSERT INTO `0_consignor_branch` VALUES(2, 1, 'New', 'sda', 'dasdaads', 'sdad', 1, 2, '', 'DEF', 1, '', '4510', '1200', '4500', 1, 0, 'sdad', 0, '', 0);
INSERT INTO `0_consignor_branch` VALUES(3, 2, 'Adarsh Somani', 'Adarsh', 'HASJSD', '', 1, 2, '', 'BHL', 1, '', '4510', '1200', '4500', 1, 0, '', 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_consignor_trans`
--

CREATE TABLE `0_consignor_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `consignor_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `consignor_no` (`consignor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_consignor_trans`
--

INSERT INTO `0_consignor_trans` VALUES(1, 10, 0, 1, 2, '2014-04-05', '2014-04-05', '99', 2, 1, 120, 0, 0, 0, 0, 120, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(2, 10, 0, 2, 3, '2014-04-05', '2014-04-05', '100', 2, 2, 10000, 0, 0, 0, 0, 10000, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(3, 10, 0, 2, 3, '2014-04-05', '2014-05-17', '101', 2, 3, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1);
INSERT INTO `0_consignor_trans` VALUES(4, 10, 0, 1, 2, '2014-04-05', '2014-05-17', '102', 2, 4, 120, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1);
INSERT INTO `0_consignor_trans` VALUES(5, 10, 0, 2, 3, '2014-04-19', '2014-04-19', '103', 2, 7, 1340, 0, 0, 0, 0, 1340, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(6, 10, 0, 2, 3, '2014-04-19', '2014-04-19', '104', 2, 8, 23140, 0, 230, 0, 0, 23370, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(7, 10, 0, 2, 3, '2014-04-19', '2014-04-19', '105', 2, 10, 2340, 0, 0, 0, 0, 2340, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(8, 10, 0, 1, 2, '2014-04-19', '2014-04-19', '106', 2, 2, 65490, 6506, 430, 43, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(9, 10, 0, 2, 3, '2014-04-19', '2014-04-19', '107', 2, 11, 3450, 0, 345, 0, 0, 3795, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(10, 10, 1, 1, 2, '2014-04-19', '2014-04-19', '108', 2, 2, 5000, 0, 21, 2.1, 0, 1502.1, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(11, 10, 0, 2, 3, '2014-04-19', '2014-04-19', '109', 2, 14, 24340, 2310.9, 1231, 123.1, 0, 28005, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(12, 10, 0, 2, 3, '2014-04-23', '2014-04-23', '110', 2, 15, 5450, 532, 130, 13, 0, 6125, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(13, 10, 0, 1, 2, '2014-04-23', '2014-04-23', '111', 2, 16, 120, 12, 0, 0, 0, 132, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(14, 10, 0, 1, 2, '2014-04-23', '2014-04-23', '112', 2, 17, 120, -22, 340, 34, 0, 472, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(15, 10, 0, 1, 2, '2014-06-14', '2014-06-14', '113', 2, 18, 20, 2, 0, 0, 0, 22, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(1, 11, 0, 1, 2, '2014-04-23', '0000-00-00', '10', 2, 2, 3000, 497.9, 21, 2.1, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(1, 12, 0, 1, 2, '2014-04-05', '0000-00-00', '55', 0, 0, 120, 0, 0, 0, 0, 120, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(2, 12, 0, 2, 3, '2014-04-05', '0000-00-00', '56', 0, 0, 10000, 0, 0, 0, 0, 10000, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(3, 12, 0, 2, 3, '2014-04-19', '0000-00-00', '57', 0, 0, 1340, 0, 0, 0, 0, 1340, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(4, 12, 0, 2, 3, '2014-04-19', '0000-00-00', '58', 0, 0, 23370, 0, 0, 0, 0, 23370, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(5, 12, 0, 2, 3, '2014-04-19', '0000-00-00', '59', 0, 0, 2340, 0, 0, 0, 0, 2340, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(6, 12, 0, 1, 2, '2014-04-19', '0000-00-00', '60', 0, 0, 65920, 0, 0, 0, 0, 0, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(7, 12, 0, 2, 3, '2014-04-19', '0000-00-00', '61', 0, 0, 3795, 0, 0, 0, 0, 3795, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(8, 12, 0, 1, 2, '2014-04-19', '0000-00-00', '62', 0, 0, 5023.1, 0, 0, 0, 0, 5023.1, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(9, 12, 0, 2, 3, '2014-04-19', '0000-00-00', '63', 0, 0, 28005, 0, 0, 0, 0, 28005, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(10, 12, 0, 2, 3, '2014-04-23', '0000-00-00', '64', 0, 0, 6125, 0, 0, 0, 0, 6125, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(11, 12, 0, 1, 2, '2014-04-23', '0000-00-00', '65', 0, 0, 132, 0, 0, 0, 0, 132, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(12, 12, 0, 1, 2, '2014-04-23', '0000-00-00', '66', 0, 0, 472, 0, 0, 0, 0, 472, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(13, 12, 0, 1, 2, '2014-06-14', '0000-00-00', '67', 0, 0, 22, 0, 0, 0, 0, 22, 1, 0, 0, 0, NULL);
INSERT INTO `0_consignor_trans` VALUES(1, 13, 1, 1, 2, '2014-04-05', '2014-04-06', '40', 2, 1, 120, 0, 0, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(2, 13, 1, 2, 3, '2014-04-05', '2014-04-06', '41', 2, 2, 10000, 0, 0, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(3, 13, 1, 2, 3, '2014-04-05', '2014-04-06', '42', 2, 3, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1);
INSERT INTO `0_consignor_trans` VALUES(4, 13, 1, 1, 2, '2014-04-05', '2014-04-06', '43', 2, 4, 120, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1);
INSERT INTO `0_consignor_trans` VALUES(5, 13, 1, 2, 3, '2014-04-19', '2014-04-20', '44', 2, 7, 1340, 0, 474, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(6, 13, 1, 2, 3, '2014-04-19', '2014-04-20', '45', 2, 8, 23140, 0, 3544, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(7, 13, 0, 2, 3, '2014-04-19', '2014-04-20', '46', 2, 9, 3177, 0, 317.7, 31.77, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(8, 13, 1, 2, 3, '2014-04-19', '2014-04-20', '47', 2, 10, 2340, 0, 234, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(9, 13, 0, 1, 2, '2014-04-19', '2014-04-20', '48', 2, 10, 1110, 0, 345, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(10, 13, 2, 1, 2, '2014-04-19', '2014-04-06', '49', 2, 2, 65490, 0, 430, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(11, 13, 1, 2, 3, '2014-04-19', '2014-04-20', '50', 2, 11, 3450, 0, 345, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(12, 13, 1, 1, 2, '2014-04-19', '2014-04-06', '51', 2, 2, 5000, 0, 21, 2.1, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(13, 13, 1, 2, 3, '2014-04-19', '2014-04-20', '52', 2, 14, 24340, 2310.9, 1231, 123.1, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(14, 13, 1, 2, 3, '2014-04-23', '2014-04-24', '53', 2, 15, 5450, 532, 130, 13, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(15, 13, 1, 1, 2, '2014-04-23', '2014-04-23', 'auto', 2, 16, 120, 12, 0, 0, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(16, 13, 1, 1, 2, '2014-04-23', '2014-04-23', 'auto', 2, 17, 120, -22, 340, 34, 0, 0, 1, 1, 0, 0, 4);
INSERT INTO `0_consignor_trans` VALUES(17, 13, 1, 1, 2, '2014-06-14', '2014-06-14', '54', 2, 18, 20, 2, 0, 0, 0, 0, 1, 1, 0, 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `0_consignor_trans_details`
--

CREATE TABLE `0_consignor_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `consignor_trans_no` int(11) default NULL,
  `consignor_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `to_units` varchar(20) NOT NULL,
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`consignor_trans_type`,`consignor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=48 ;

--
-- Dumping data for table `0_consignor_trans_details`
--

INSERT INTO `0_consignor_trans_details` VALUES(1, 1, 13, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 1, 5);
INSERT INTO `0_consignor_trans_details` VALUES(2, 1, 10, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 0, 1);
INSERT INTO `0_consignor_trans_details` VALUES(3, 2, 13, 'NewMarble', 'Marble', 10000, 0, 1, 'Gallons', 0, 0, 1, 7);
INSERT INTO `0_consignor_trans_details` VALUES(4, 2, 10, 'NewMarble', 'Marble', 10000, 0, 1, 'Gallons', 0, 0, 0, 3);
INSERT INTO `0_consignor_trans_details` VALUES(5, 3, 13, 'NewMarble', 'Marble', 0, 0, 1, 'Gallons', 0, 0, 1, 9);
INSERT INTO `0_consignor_trans_details` VALUES(6, 3, 10, 'NewMarble', 'Marble', 0, 0, 1, 'Gallons', 0, 0, 0, 5);
INSERT INTO `0_consignor_trans_details` VALUES(7, 4, 13, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 1, 10);
INSERT INTO `0_consignor_trans_details` VALUES(8, 4, 10, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 0, 7);
INSERT INTO `0_consignor_trans_details` VALUES(9, 5, 13, 'JAAJS', 'adsj', 1340, 0, 1, 'Bags', 0, 0, 1, 28);
INSERT INTO `0_consignor_trans_details` VALUES(10, 5, 10, 'JAAJS', 'adsj', 1340, 0, 1, 'Bags', 0, 0, 0, 9);
INSERT INTO `0_consignor_trans_details` VALUES(11, 6, 13, 'JAAJS', 'adsj', 23140, 0, 1, 'Bags', 0, 0, 1, 30);
INSERT INTO `0_consignor_trans_details` VALUES(12, 6, 10, 'JAAJS', 'adsj', 23140, 0, 1, 'Bags', 0, 0, 0, 11);
INSERT INTO `0_consignor_trans_details` VALUES(13, 7, 13, 'JAAJS', 'adsj', 3530, 0, 1, 'Bags', 0.1, 0, 0, 32);
INSERT INTO `0_consignor_trans_details` VALUES(14, 8, 13, 'JAAJS', 'adsj', 2340, 0, 1, 'Bags', 0, 0, 1, 34);
INSERT INTO `0_consignor_trans_details` VALUES(15, 7, 10, 'JAAJS', 'adsj', 2340, 0, 1, 'Bags', 0, 0, 0, 14);
INSERT INTO `0_consignor_trans_details` VALUES(16, 9, 13, 'JAAJS', 'adsj', 2340, 0, 0, 'Bags', 0, 0, 0, 34);
INSERT INTO `0_consignor_trans_details` VALUES(17, 9, 13, 'Colors', 'Colors', 1110, 0, 1, 'Bags', 0, 0, 0, 35);
INSERT INTO `0_consignor_trans_details` VALUES(18, 10, 13, 'NewMarble', 'Marble', 41000, 0, 0, 'Gallons', 0, 0, 0, 7);
INSERT INTO `0_consignor_trans_details` VALUES(19, 10, 13, 'Colors', 'Colors', 4440, 0, 12, 'ea.', 0, 0, 12, 21);
INSERT INTO `0_consignor_trans_details` VALUES(20, 10, 13, 'JAAJS', 'adsj', 12210, 0, 1, 'Bags', 0, 0, 1, 25);
INSERT INTO `0_consignor_trans_details` VALUES(21, 8, 10, 'NewMarble', 'Marble', 41000, 0, 0, 'Gallons', 0, 0, 0, 18);
INSERT INTO `0_consignor_trans_details` VALUES(22, 8, 10, 'Colors', 'Colors', 4440, 0, 12, 'ea.', 0, 0, 0, 19);
INSERT INTO `0_consignor_trans_details` VALUES(23, 8, 10, 'JAAJS', 'adsj', 12210, 0, 1, 'Bags', 0, 0, 0, 20);
INSERT INTO `0_consignor_trans_details` VALUES(24, 11, 13, 'JAAJS', 'adsj', 3450, 0, 1, 'Bags', 0, 0, 1, 37);
INSERT INTO `0_consignor_trans_details` VALUES(25, 9, 10, 'JAAJS', 'adsj', 3450, 0, 1, 'Bags', 0, 0, 0, 24);
INSERT INTO `0_consignor_trans_details` VALUES(26, 12, 13, 'NewMarble', 'Marble', 41000, 0, 0, 'Gallons', 0, 0, 0, 7);
INSERT INTO `0_consignor_trans_details` VALUES(27, 12, 13, 'Colors', 'Colors', 4440, 0, 0, 'ea.', 0, 0, 0, 21);
INSERT INTO `0_consignor_trans_details` VALUES(28, 12, 13, 'JAAJS', 'adsj', 12210, 0, 0, 'Bags', 0, 0, 0, 25);
INSERT INTO `0_consignor_trans_details` VALUES(29, 12, 13, 'NewMarble', 'Marble', 10, 0, 500, 'Bags', 0, 0, 500, 41);
INSERT INTO `0_consignor_trans_details` VALUES(30, 10, 10, 'NewMarble', 'Marble', 41000, 0, 0, 'Gallons', 0, 0, 0, 26);
INSERT INTO `0_consignor_trans_details` VALUES(31, 10, 10, 'Colors', 'Colors', 4440, 0, 0, 'ea.', 0, 0, 0, 27);
INSERT INTO `0_consignor_trans_details` VALUES(32, 10, 10, 'JAAJS', 'adsj', 12210, 0, 0, 'Bags', 0, 0, 0, 28);
INSERT INTO `0_consignor_trans_details` VALUES(33, 10, 10, 'NewMarble', 'Marble', 10, 0, 500, 'Bags', 0, 0, 300, 29);
INSERT INTO `0_consignor_trans_details` VALUES(34, 13, 13, 'JAAJS', 'adsj', 24340, 0, 1, 'Bags', 0, 0, 1, 45);
INSERT INTO `0_consignor_trans_details` VALUES(35, 11, 10, 'JAAJS', 'adsj', 24340, 0, 1, 'Bags', 0, 0, 0, 34);
INSERT INTO `0_consignor_trans_details` VALUES(36, 14, 13, 'Colors', 'Colors', 5450, 0, 1, 'Bags', 0, 0, 1, 48);
INSERT INTO `0_consignor_trans_details` VALUES(37, 12, 10, 'Colors', 'Colors', 5450, 0, 1, 'Bags', 0, 0, 0, 36);
INSERT INTO `0_consignor_trans_details` VALUES(38, 15, 13, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 1, 49);
INSERT INTO `0_consignor_trans_details` VALUES(39, 13, 10, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 0, 38);
INSERT INTO `0_consignor_trans_details` VALUES(40, 16, 13, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 1, 50);
INSERT INTO `0_consignor_trans_details` VALUES(41, 14, 10, 'NewMarble', 'Marble', 120, 0, 1, 'Gallons', 0, 0, 0, 40);
INSERT INTO `0_consignor_trans_details` VALUES(42, 1, 11, 'NewMarble', 'Marble', 41000, 0, 0, 'Gallons', 0, 0, 0, 30);
INSERT INTO `0_consignor_trans_details` VALUES(43, 1, 11, 'Colors', 'Colors', 4440, 0, 0, 'ea.', 0, 0, 0, 31);
INSERT INTO `0_consignor_trans_details` VALUES(44, 1, 11, 'JAAJS', 'adsj', 12210, 0, 0, 'Bags', 0, 0, 0, 32);
INSERT INTO `0_consignor_trans_details` VALUES(45, 1, 11, 'NewMarble', 'Marble', 10, 0, 300, 'Bags', 0, 0, 0, 33);
INSERT INTO `0_consignor_trans_details` VALUES(46, 17, 13, 'Colors', 'Colors', 20, 0, 1, 'Bags', 0, 0, 1, 51);
INSERT INTO `0_consignor_trans_details` VALUES(47, 15, 10, 'Colors', 'Colors', 20, 0, 1, 'Bags', 0, 0, 0, 46);

-- --------------------------------------------------------

--
-- Table structure for table `0_credit_status`
--

CREATE TABLE `0_credit_status` (
  `id` int(11) NOT NULL auto_increment,
  `reason_description` char(100) NOT NULL default '',
  `dissallow_invoices` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `0_credit_status`
--

INSERT INTO `0_credit_status` VALUES(1, 'Good History', 0, 0);
INSERT INTO `0_credit_status` VALUES(3, 'No more work until payment received', 1, 0);
INSERT INTO `0_credit_status` VALUES(4, 'In liquidation', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_crm_categories`
--

CREATE TABLE `0_crm_categories` (
  `id` int(11) NOT NULL auto_increment COMMENT 'pure technical key',
  `type` varchar(20) NOT NULL COMMENT 'contact type e.g. consignor',
  `action` varchar(20) NOT NULL COMMENT 'detailed usage e.g. department',
  `name` varchar(30) NOT NULL COMMENT 'for category selector',
  `description` tinytext NOT NULL COMMENT 'usage description',
  `system` tinyint(1) NOT NULL default '0' COMMENT 'nonzero for core system usage',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`action`),
  UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `0_crm_categories`
--

INSERT INTO `0_crm_categories` VALUES(1, 'consignor_branch', 'general', 'General', 'General contact data for consignor branch (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(2, 'consignor_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(3, 'consignor_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(4, 'consignor_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(5, 'consignor', 'general', 'General', 'General contact data for consignor', 1, 0);
INSERT INTO `0_crm_categories` VALUES(6, 'consignor', 'order', 'Orders', 'Order confirmation', 1, 0);
INSERT INTO `0_crm_categories` VALUES(7, 'consignor', 'delivery', 'Deliveries', 'Delivery coordination', 1, 0);
INSERT INTO `0_crm_categories` VALUES(8, 'consignor', 'invoice', 'Invoices', 'Invoice posting', 1, 0);
INSERT INTO `0_crm_categories` VALUES(9, 'supplier', 'general', 'General', 'General contact data for supplier', 1, 0);
INSERT INTO `0_crm_categories` VALUES(10, 'supplier', 'order', 'Orders', 'Order confirmation', 1, 0);
INSERT INTO `0_crm_categories` VALUES(11, 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', 1, 0);
INSERT INTO `0_crm_categories` VALUES(12, 'supplier', 'invoice', 'Invoices', 'Invoice posting', 1, 0);
INSERT INTO `0_crm_categories` VALUES(13, 'consignee_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(14, 'consignee_branch', 'general', 'General', 'General contact data for consignor branch (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(15, 'consignee_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', 1, 0);
INSERT INTO `0_crm_categories` VALUES(16, 'consignee_branch', 'order', 'Orders', 'Order Confirmation', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_crm_contacts`
--

CREATE TABLE `0_crm_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) NOT NULL default '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) default NULL COMMENT 'entity id in related class table',
  PRIMARY KEY  (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=65 ;

--
-- Dumping data for table `0_crm_contacts`
--

INSERT INTO `0_crm_contacts` VALUES(1, 1, 'consignor', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(2, 2, 'consignor', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES(3, 3, 'consignor', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES(5, 5, 'consignor_branch', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES(7, 7, 'supplier', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(8, 8, 'supplier', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES(9, 9, 'supplier', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES(10, 10, 'consignor_branch', 'general', '4');
INSERT INTO `0_crm_contacts` VALUES(11, 10, 'consignor', 'general', '4');
INSERT INTO `0_crm_contacts` VALUES(13, 11, 'consignor', 'general', '5');
INSERT INTO `0_crm_contacts` VALUES(14, 12, 'consignor_branch', 'general', '6');
INSERT INTO `0_crm_contacts` VALUES(15, 13, 'consignee_branch', 'general', '5');
INSERT INTO `0_crm_contacts` VALUES(16, 14, 'consignor_branch', 'general', '7');
INSERT INTO `0_crm_contacts` VALUES(17, 14, 'consignor', 'general', '6');
INSERT INTO `0_crm_contacts` VALUES(18, 15, 'consignor_branch', 'general', '8');
INSERT INTO `0_crm_contacts` VALUES(19, 15, 'consignor', 'general', '7');
INSERT INTO `0_crm_contacts` VALUES(20, 16, 'consignee_branch', 'general', '6');
INSERT INTO `0_crm_contacts` VALUES(21, 16, 'consignee', 'general', '8');
INSERT INTO `0_crm_contacts` VALUES(22, 17, 'consignee_branch', 'general', '7');
INSERT INTO `0_crm_contacts` VALUES(23, 18, 'consignee_branch', 'general', '8');
INSERT INTO `0_crm_contacts` VALUES(24, 19, 'consignee_branch', 'general', '9');
INSERT INTO `0_crm_contacts` VALUES(26, 20, 'consignee', 'general', '9');
INSERT INTO `0_crm_contacts` VALUES(27, 21, 'consignee_branch', 'general', '11');
INSERT INTO `0_crm_contacts` VALUES(28, 22, 'consignor_branch', 'general', '9');
INSERT INTO `0_crm_contacts` VALUES(29, 22, 'consignor', 'general', '8');
INSERT INTO `0_crm_contacts` VALUES(30, 20, 'consignee_branch', 'general', '10');
INSERT INTO `0_crm_contacts` VALUES(31, 6, 'consignor_branch', 'delivery', '3');
INSERT INTO `0_crm_contacts` VALUES(32, 6, 'consignor_branch', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES(33, 6, 'consignor_branch', 'invoice', '3');
INSERT INTO `0_crm_contacts` VALUES(34, 6, 'consignor_branch', 'order', '3');
INSERT INTO `0_crm_contacts` VALUES(38, 23, 'consignee_branch', 'delivery', '3');
INSERT INTO `0_crm_contacts` VALUES(39, 23, 'consignee_branch', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES(40, 23, 'consignee_branch', 'invoice', '3');
INSERT INTO `0_crm_contacts` VALUES(41, 23, 'consignee_branch', 'order', '3');
INSERT INTO `0_crm_contacts` VALUES(43, 24, 'consignor', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(45, 25, 'consignee', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(46, 26, 'consignor_branch', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES(47, 26, 'consignor', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(49, 27, 'consignee', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(50, 28, 'consignee_branch', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES(51, 28, 'consignee', 'general', '2');
INSERT INTO `0_crm_contacts` VALUES(52, 25, 'consignee_branch', 'delivery', '1');
INSERT INTO `0_crm_contacts` VALUES(53, 25, 'consignee_branch', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(54, 25, 'consignee_branch', 'invoice', '1');
INSERT INTO `0_crm_contacts` VALUES(55, 25, 'consignee_branch', 'order', '1');
INSERT INTO `0_crm_contacts` VALUES(59, 27, 'consignee_branch', 'delivery', '1');
INSERT INTO `0_crm_contacts` VALUES(60, 27, 'consignee_branch', 'general', '1');
INSERT INTO `0_crm_contacts` VALUES(61, 27, 'consignee_branch', 'invoice', '1');
INSERT INTO `0_crm_contacts` VALUES(62, 27, 'consignee_branch', 'order', '1');
INSERT INTO `0_crm_contacts` VALUES(63, 1, 'consignor_branch', 'general', '3');
INSERT INTO `0_crm_contacts` VALUES(64, 1, 'consignor', 'general', '2');

-- --------------------------------------------------------

--
-- Table structure for table `0_crm_persons`
--

CREATE TABLE `0_crm_persons` (
  `id` int(11) NOT NULL auto_increment,
  `ref` varchar(30) NOT NULL,
  `name` varchar(60) NOT NULL,
  `name2` varchar(60) default NULL,
  `address` tinytext,
  `phone` varchar(30) default NULL,
  `phone2` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `email` varchar(100) default NULL,
  `lang` char(5) default NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `ref` (`ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_crm_persons`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_currencies`
--

CREATE TABLE `0_currencies` (
  `currency` varchar(60) NOT NULL default '',
  `curr_abrev` char(3) NOT NULL default '',
  `curr_symbol` varchar(10) NOT NULL default '',
  `country` varchar(100) NOT NULL default '',
  `hundreds_name` varchar(15) NOT NULL default '',
  `auto_update` tinyint(1) NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`curr_abrev`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_currencies`
--

INSERT INTO `0_currencies` VALUES('US Dollars', 'USD', '$', 'United States', 'Cents', 1, 0);
INSERT INTO `0_currencies` VALUES('CA Dollars', 'CAD', '$', 'Canada', 'Cents', 1, 0);
INSERT INTO `0_currencies` VALUES('Euro', 'EUR', '?', 'Europe', 'Cents', 1, 0);
INSERT INTO `0_currencies` VALUES('Pounds', 'GBP', '?', 'England', 'Pence', 1, 0);
INSERT INTO `0_currencies` VALUES('DK Kroner', 'DKK', '?', 'Denmark', 'Ore', 1, 0);
INSERT INTO `0_currencies` VALUES('Rupees', 'INR', 'Rs', 'India', 'Paisa', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_dashboard_reminders`
--

CREATE TABLE `0_dashboard_reminders` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `next_date` date NOT NULL,
  `description` text,
  `frequency` varchar(20) NOT NULL,
  `param` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_dashboard_reminders`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_dashboard_widgets`
--

CREATE TABLE `0_dashboard_widgets` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `app` varchar(50) NOT NULL,
  `column_id` int(11) NOT NULL,
  `sort_no` int(11) NOT NULL,
  `collapsed` tinyint(4) NOT NULL,
  `widget` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `param` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=42 ;

--
-- Dumping data for table `0_dashboard_widgets`
--

INSERT INTO `0_dashboard_widgets` VALUES(1, 1, 'AP', 1, 1, 0, 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(2, 1, 'AP', 1, 0, 0, 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(3, 1, 'AP', 2, 1, 0, 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(6, 1, 'AP', 2, 0, 0, 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(7, 1, 'orders', 1, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(9, 1, 'orders', 1, 1, 0, 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(10, 1, 'AP', 1, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(11, 1, 'AP', 2, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(12, 1, 'GL', 2, 1, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(13, 1, 'GL', 2, 0, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(14, 1, 'stock', 1, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(15, 1, 'stock', 0, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(16, 1, 'manuf', 1, 0, 0, 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(17, 1, 'manuf', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(18, 1, 'orders', 2, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(19, 1, 'GL', 2, 2, 0, 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(20, 1, 'GL', 1, 1, 0, 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(21, 1, 'GL', 1, 0, 0, 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(22, 2, 'AP', 1, 1, 0, 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(23, 2, 'AP', 1, 0, 0, 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(24, 2, 'AP', 2, 1, 0, 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(25, 2, 'AP', 2, 0, 0, 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(26, 2, 'orders', 1, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(27, 2, 'orders', 1, 1, 0, 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(28, 2, 'AP', 1, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(29, 2, 'AP', 2, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(30, 2, 'GL', 2, 1, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(31, 2, 'GL', 2, 0, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(32, 2, 'stock', 1, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(33, 2, 'stock', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(34, 2, 'manuf', 1, 0, 0, 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(35, 2, 'manuf', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(36, 2, 'orders', 2, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(37, 2, 'GL', 2, 2, 0, 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(38, 2, 'GL', 1, 1, 0, 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(39, 2, 'GL', 1, 0, 0, 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(40, 1, 'stock', 1, 1, 0, 'odometer', 'Odometer Readings', '{&quot;top&quot;:&quot;20&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `0_dashboard_widgets` VALUES(41, 1, 'manuf', 0, 0, 0, 'maintenance', '', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');

-- --------------------------------------------------------

--
-- Table structure for table `0_dimensions`
--

CREATE TABLE `0_dimensions` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(60) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `type_` tinyint(1) NOT NULL default '1',
  `closed` tinyint(1) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `date_` (`date_`),
  KEY `due_date` (`due_date`),
  KEY `type_` (`type_`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_dimensions`
--

INSERT INTO `0_dimensions` VALUES(1, '1', 'Support', 1, 0, '2009-06-21', '2015-07-11');
INSERT INTO `0_dimensions` VALUES(2, '2', 'Development', 1, 0, '2009-06-21', '2015-07-11');

-- --------------------------------------------------------

--
-- Table structure for table `0_drivers_master`
--

CREATE TABLE `0_drivers_master` (
  `driver_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `driver_birth_date` date NOT NULL,
  `hired_on` date NOT NULL,
  `licence_no` varchar(100) NOT NULL,
  `health_exam_ref` varchar(100) NOT NULL,
  `date_of_checkup` date NOT NULL,
  `driver_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `curr_code` char(3) NOT NULL default '',
  `payment_terms` int(11) default NULL,
  `rate` decimal(10,2) NOT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`driver_no`),
  UNIQUE KEY `driver_ref` (`driver_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `0_drivers_master`
--

INSERT INTO `0_drivers_master` VALUES(1, 'Beefeater Ltd.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Beefeater', 'Addr 1\nAddr 2\nAddr 3', 'GBP', 3, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(2, 'Ghostbusters Corp.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Ghostbusters', 'Address 1\nAddress 2\nAddress 3', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(3, 'Brezan', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Brezan', 'Address 1\nAddress 2\nAddress 3', 'EUR', 3, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(4, 'asd', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'sad', NULL, '', NULL, 0.00, 'USD', 0);
INSERT INTO `0_drivers_master` VALUES(5, 'dsa', '0000-00-00', '0000-00-00', 'das', '', '0000-00-00', 'dsa', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(6, 'dasdasjadsjads', '0000-00-00', '0000-00-00', 'dsa', '', '0000-00-00', 'Anurodh', 'dsa', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(7, 'Pushkar', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'Pushkar', 'sda', '', 0, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(8, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sddddddda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(9, 'das', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'dsadsdsashkgdsuhgskd', 'dasa', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(10, 'dsa', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Andhrapradesh', 'das', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(11, 'Avinash', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'Jeengar', 'ddhfsf', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(12, 'Naehhe', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'adasdhhdas', NULL, 'USD', 4, 55.00, '', 1);
INSERT INTO `0_drivers_master` VALUES(13, 'adnannadads', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'dasnands,,nads', 'czx', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(14, 'Anurodha', '2014-02-15', '2014-02-15', '', '', '2014-02-15', 'Ahda', 'dafjvafjaf', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_drivers_master` VALUES(15, 'sds', '0000-00-00', '0000-00-00', 'sdsd', '', '0000-00-00', 'sdsd', 'sd', '', 0, 0.00, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_driver_trans`
--

CREATE TABLE `0_driver_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `driver_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `driver_no` (`driver_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_driver_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_driver_trans_details`
--

CREATE TABLE `0_driver_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `driver_trans_no` int(11) default NULL,
  `driver_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`driver_trans_type`,`driver_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_driver_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_exchange_rates`
--

CREATE TABLE `0_exchange_rates` (
  `id` int(11) NOT NULL auto_increment,
  `curr_code` char(3) NOT NULL default '',
  `rate_buy` double NOT NULL default '0',
  `rate_sell` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `0_exchange_rates`
--

INSERT INTO `0_exchange_rates` VALUES(1, 'DKK', 0.18717252868313, 0.18717252868313, '2009-06-21');
INSERT INTO `0_exchange_rates` VALUES(2, 'GBP', 1.6445729799917, 1.6445729799917, '2009-06-21');
INSERT INTO `0_exchange_rates` VALUES(3, 'EUR', 1.3932, 1.3932, '2009-06-21');
INSERT INTO `0_exchange_rates` VALUES(4, 'GBP', 1.6446, 1.6446, '2013-12-31');
INSERT INTO `0_exchange_rates` VALUES(5, 'EUR', 1.3932, 1.3932, '2013-12-31');

-- --------------------------------------------------------

--
-- Table structure for table `0_fiscal_year`
--

CREATE TABLE `0_fiscal_year` (
  `id` int(11) NOT NULL auto_increment,
  `begin` date default '0000-00-00',
  `end` date default '0000-00-00',
  `closed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `0_fiscal_year`
--

INSERT INTO `0_fiscal_year` VALUES(1, '2008-01-01', '2008-12-31', 1);
INSERT INTO `0_fiscal_year` VALUES(2, '2009-01-01', '2009-12-31', 1);
INSERT INTO `0_fiscal_year` VALUES(3, '2010-01-01', '2010-12-31', 0);
INSERT INTO `0_fiscal_year` VALUES(4, '2011-01-01', '2011-12-31', 0);
INSERT INTO `0_fiscal_year` VALUES(5, '2012-01-01', '2012-12-31', 0);
INSERT INTO `0_fiscal_year` VALUES(6, '2013-01-01', '2013-12-31', 0);
INSERT INTO `0_fiscal_year` VALUES(7, '2014-01-01', '2014-12-31', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_fuel_types`
--

CREATE TABLE `0_fuel_types` (
  `fuel_type_code` int(11) NOT NULL auto_increment,
  `fuel_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`fuel_type_code`),
  UNIQUE KEY `description` (`fuel_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `0_fuel_types`
--

INSERT INTO `0_fuel_types` VALUES(5, 'sdaads', 0);
INSERT INTO `0_fuel_types` VALUES(6, 'Gasoline', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_fuel_weight_types`
--

CREATE TABLE `0_fuel_weight_types` (
  `fuel_weight_type_code` int(11) NOT NULL auto_increment,
  `fuel_weight_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`fuel_weight_type_code`),
  UNIQUE KEY `description` (`fuel_weight_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `0_fuel_weight_types`
--

INSERT INTO `0_fuel_weight_types` VALUES(5, 'dsads', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_gl_trans`
--

CREATE TABLE `0_gl_trans` (
  `counter` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL default '0',
  `type_no` bigint(16) NOT NULL default '1',
  `tran_date` date NOT NULL default '0000-00-00',
  `account` varchar(15) NOT NULL default '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL default '0',
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `person_type_id` int(11) default NULL,
  `person_id` tinyblob,
  PRIMARY KEY  (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `dimension_id` (`dimension_id`),
  KEY `dimension2_id` (`dimension2_id`),
  KEY `tran_date` (`tran_date`),
  KEY `account_and_tran_date` (`account`,`tran_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=86 ;

--
-- Dumping data for table `0_gl_trans`
--

INSERT INTO `0_gl_trans` VALUES(1, 10, 1, '2014-04-05', '4430', '', -120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(2, 10, 1, '2014-04-05', '1200', '', 120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(3, 10, 1, '2014-04-05', '2150', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(4, 12, 1, '2014-04-05', '1065', '', 120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(5, 12, 1, '2014-04-05', '1200', '', -120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(6, 10, 2, '2014-04-05', '4430', '', -10000, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(7, 10, 2, '2014-04-05', '1200', '', 10000, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(8, 10, 2, '2014-04-05', '2150', '', 0, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(9, 12, 2, '2014-04-05', '1065', '', 10000, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(10, 12, 2, '2014-04-05', '1200', '', -10000, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(11, 10, 4, '2014-04-05', '4430', '', -120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(12, 10, 4, '2014-04-05', '1200', '', 120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(13, 10, 4, '2014-04-05', '2150', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(14, 4, 1, '2014-04-05', '1065', 'From Petty Cash account To Citi Bank Account', -10000, 0, 0, NULL, NULL);
INSERT INTO `0_gl_trans` VALUES(15, 4, 1, '2014-04-05', '1061', 'From Petty Cash account To Citi Bank Account', 10000, 0, 0, NULL, NULL);
INSERT INTO `0_gl_trans` VALUES(16, 10, 5, '2014-04-19', '', '', -1340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(17, 10, 5, '2014-04-19', '1200', '', 1340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(18, 12, 3, '2014-04-19', '1065', '', 1340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(19, 12, 3, '2014-04-19', '1200', '', -1340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(20, 10, 6, '2014-04-19', '', '', -23140, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(21, 10, 6, '2014-04-19', '1200', '', 23370, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(22, 10, 6, '2014-04-19', '4430', '', -230, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(23, 12, 4, '2014-04-19', '1065', '', 23370, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(24, 12, 4, '2014-04-19', '1200', '', -23370, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(25, 10, 7, '2014-04-19', '', '', -2340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(26, 10, 7, '2014-04-19', '1200', '', 2340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(27, 12, 5, '2014-04-19', '1065', '', 2340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(28, 12, 5, '2014-04-19', '1200', '', -2340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(29, 10, 8, '2014-04-19', '', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(30, 10, 8, '2014-04-19', '', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(31, 10, 8, '2014-04-19', '1200', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(32, 10, 8, '2014-04-19', '4430', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(33, 12, 6, '2014-04-19', '1065', '', 65920, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(34, 12, 6, '2014-04-19', '1200', '', -65920, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(35, 10, 9, '2014-04-19', '', '', -3450, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(36, 10, 9, '2014-04-19', '1200', '', 3795, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(37, 10, 9, '2014-04-19', '4430', '', -345, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(38, 12, 7, '2014-04-19', '1065', '', 3795, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(39, 12, 7, '2014-04-19', '1200', '', -3795, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(40, 10, 10, '2014-04-19', '4430', '', -5000, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(41, 10, 10, '2014-04-19', '1200', '', 5023.1, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(42, 10, 10, '2014-04-19', '4430', '', -21, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(43, 10, 10, '2014-04-19', '2150', '', -2.1, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(44, 12, 8, '2014-04-19', '1065', '', 5023.1, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(45, 12, 8, '2014-04-19', '1200', '', -5023.1, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(46, 10, 11, '2014-04-19', '', '', -24340, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(47, 10, 11, '2014-04-19', '1200', '', 28005, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(48, 10, 11, '2014-04-19', '4430', '', -1231, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(49, 10, 11, '2014-04-19', '2150', '', -2434, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(50, 12, 9, '2014-04-19', '1065', '', 28005, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(51, 12, 9, '2014-04-19', '1200', '', -28005, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(52, 10, 12, '2014-04-23', '', '', -5450, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(53, 10, 12, '2014-04-23', '1200', '', 6125, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(54, 10, 12, '2014-04-23', '4430', '', -130, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(55, 10, 12, '2014-04-23', '2150', '', -545, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(56, 12, 10, '2014-04-23', '1065', '', 6125, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(57, 12, 10, '2014-04-23', '1200', '', -6125, 0, 0, 2, 0x32);
INSERT INTO `0_gl_trans` VALUES(58, 10, 13, '2014-04-23', '4430', '', -120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(59, 10, 13, '2014-04-23', '1200', '', 132, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(60, 10, 13, '2014-04-23', '2150', '', -12, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(61, 12, 11, '2014-04-23', '1065', '', 132, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(62, 12, 11, '2014-04-23', '1200', '', -132, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(63, 10, 14, '2014-04-23', '4430', '', -120, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(64, 10, 14, '2014-04-23', '1200', '', 472, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(65, 10, 14, '2014-04-23', '4430', '', -340, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(66, 10, 14, '2014-04-23', '2150', '', -12, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(67, 12, 12, '2014-04-23', '1065', '', 472, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(68, 12, 12, '2014-04-23', '1200', '', -472, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(69, 11, 1, '2014-04-23', '4430', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(70, 11, 1, '2014-04-23', '', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(71, 11, 1, '2014-04-23', '', '', 0, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(72, 11, 1, '2014-04-23', '4430', '', 3000, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(73, 11, 1, '2014-04-23', '1200', '', -3521, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(74, 11, 1, '2014-04-23', '4430', '', 21, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(75, 11, 1, '2014-04-23', '2150', '', 500, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(76, 10, 8, '2014-04-19', '', '', -53280, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(77, 10, 8, '2014-04-19', '', '', -12210, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(78, 10, 8, '2014-04-19', '1200', '', 72469, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(79, 10, 8, '2014-04-19', '4430', '', -430, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(80, 10, 8, '2014-04-19', '2150', '', -6549, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(81, 10, 15, '2014-06-14', '', '', -20, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(82, 10, 15, '2014-06-14', '1200', '', 22, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(83, 10, 15, '2014-06-14', '2150', '', -2, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(84, 12, 13, '2014-06-14', '1065', '', 22, 0, 0, 2, 0x31);
INSERT INTO `0_gl_trans` VALUES(85, 12, 13, '2014-06-14', '1200', '', -22, 0, 0, 2, 0x31);

-- --------------------------------------------------------

--
-- Table structure for table `0_grn_batch`
--

CREATE TABLE `0_grn_batch` (
  `id` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `purch_order_no` int(11) default NULL,
  `reference` varchar(60) NOT NULL default '',
  `delivery_date` date NOT NULL default '0000-00-00',
  `loc_code` varchar(5) default NULL,
  PRIMARY KEY  (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_grn_batch`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_grn_items`
--

CREATE TABLE `0_grn_items` (
  `id` int(11) NOT NULL auto_increment,
  `grn_batch_id` int(11) default NULL,
  `po_detail_item` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_recd` double NOT NULL default '0',
  `quantity_inv` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_grn_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_groups`
--

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_groups`
--

INSERT INTO `0_groups` VALUES(1, 'Small', 0);
INSERT INTO `0_groups` VALUES(2, 'Medium', 0);
INSERT INTO `0_groups` VALUES(3, 'Large', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_item_codes`
--

CREATE TABLE `0_item_codes` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `item_code` varchar(20) NOT NULL,
  `stock_id` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL default '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL default '1',
  `is_foreign` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `0_item_codes`
--

INSERT INTO `0_item_codes` VALUES(1, 'NewMarble', 'NewMarble', 'Marble', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(2, 'hfdshf', 'hfdshf', 'dsasaddas', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(3, 'NewITEMS', 'NewITEMS', 'fdjsjfdsjdsf', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(4, 'JAAJS', 'JAAJS', 'adsj', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(5, 'adsads', 'adsads', 'dasdas', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(9, 'sfjhsd', 'sfjhsd', 'hddjfsjf', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(8, 'Colors', 'Colors', 'Colors', 6, 1, 0, 0);
INSERT INTO `0_item_codes` VALUES(10, 'adshl', 'adshl', 'jldasj', 5, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_item_tax_types`
--

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `exempt` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_item_tax_types`
--

INSERT INTO `0_item_tax_types` VALUES(1, 'Regular', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_item_tax_type_exemptions`
--

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_item_tax_type_exemptions`
--

INSERT INTO `0_item_tax_type_exemptions` VALUES(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `0_item_units`
--

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_item_units`
--

INSERT INTO `0_item_units` VALUES('ea.', 'Each', 0, 0);
INSERT INTO `0_item_units` VALUES('hrs', 'Hours', 1, 0);
INSERT INTO `0_item_units` VALUES('Ltr', 'Ltr', 2, 0);
INSERT INTO `0_item_units` VALUES('Gallons', 'Gallons', -1, 0);
INSERT INTO `0_item_units` VALUES('Bags', 'Bags', 0, 0);
INSERT INTO `0_item_units` VALUES('Kg', 'Kg', 2, 0);
INSERT INTO `0_item_units` VALUES('Ton', 'Ton', 3, 0);
INSERT INTO `0_item_units` VALUES('Qt', 'Quintal', 2, 0);
INSERT INTO `0_item_units` VALUES('Box', 'Box', 0, 0);
INSERT INTO `0_item_units` VALUES('sqft', 'sqft', 2, 0);
INSERT INTO `0_item_units` VALUES('sqmt', 'sqmt', 2, 0);
INSERT INTO `0_item_units` VALUES('cc', 'cube', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_locations`
--

CREATE TABLE `0_locations` (
  `loc_code` varchar(5) NOT NULL default '',
  `location_name` varchar(60) NOT NULL default '',
  `delivery_address` tinytext NOT NULL,
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `contact` varchar(30) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_locations`
--

INSERT INTO `0_locations` VALUES('DEF', 'Default', 'Delivery 1\nDelivery 2\nDelivery 3', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('BHL', 'Bhilwara', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('NAAS', 'dsas', 'asd', '', '', '', '', 'asdads', 0);
INSERT INTO `0_locations` VALUES('RAJ', 'RAJSAMAND', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('HYD', 'HYDERABAD', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('BNG', 'BANGLORE', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('MDS', 'CHENNAI', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('IND', 'INDORE', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('BPL', 'BHOPAL', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('JBLP', 'JABALPUR', '', '', '', '', '', '', 0);
INSERT INTO `0_locations` VALUES('POND', 'PONDICHERY', '', '', '', '', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_loc_stock`
--

CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL default '',
  `stock_id` char(20) NOT NULL default '',
  `reorder_level` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_loc_stock`
--

INSERT INTO `0_loc_stock` VALUES('BHL', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('BHL', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('BNG', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('BPL', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('DEF', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('HYD', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('IND', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('JBLP', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('MDS', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('NAAS', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('POND', 'sfjhsd', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'adsads', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'adshl', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'Colors', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'GJSDJS', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'hfdshf', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'JAAJS', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'Marbles', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'NewITEMS', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'NewMarble', 0);
INSERT INTO `0_loc_stock` VALUES('RAJ', 'sfjhsd', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_movement_types`
--

CREATE TABLE `0_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_movement_types`
--

INSERT INTO `0_movement_types` VALUES(1, 'Adjustment', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_odometer_data`
--

CREATE TABLE `0_odometer_data` (
  `odometer_id` int(11) NOT NULL auto_increment,
  `category` int(11) NOT NULL,
  `stock_id` char(20) NOT NULL default '',
  `odometer_reading` int(50) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `log_description` varchar(200) NOT NULL,
  `accident_id` int(10) NOT NULL,
  `wo_id` int(10) NOT NULL,
  PRIMARY KEY  (`odometer_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_odometer_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_odometer_types`
--

CREATE TABLE `0_odometer_types` (
  `odometer_type_code` int(11) NOT NULL auto_increment,
  `odometer_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`odometer_type_code`),
  UNIQUE KEY `description` (`odometer_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_odometer_types`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_part`
--

CREATE TABLE `0_part` (
  `part_code` int(11) NOT NULL auto_increment,
  `part_name` char(60) NOT NULL default '',
  `part_type_desc` varchar(100) default NULL,
  `part_no` varchar(100) NOT NULL default '',
  `part_price` decimal(10,2) NOT NULL default '0.00',
  `part_price_date` date NOT NULL,
  `vendor_ref` varchar(100) default NULL,
  `part_manufacturer` varchar(200) default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`part_code`),
  UNIQUE KEY `part_name` (`part_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_part`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_part_types`
--

CREATE TABLE `0_part_types` (
  `part_type_code` int(11) NOT NULL auto_increment,
  `part_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`part_type_code`),
  UNIQUE KEY `description` (`part_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_part_types`
--

INSERT INTO `0_part_types` VALUES(2, 'dasbkdsa', 0);
INSERT INTO `0_part_types` VALUES(3, 'dddd', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_payment_terms`
--

CREATE TABLE `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL auto_increment,
  `terms` char(80) NOT NULL default '',
  `days_before_due` smallint(6) NOT NULL default '0',
  `day_in_following_month` smallint(6) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `0_payment_terms`
--

INSERT INTO `0_payment_terms` VALUES(1, 'Due 15th Of the Following Month', 0, 17, 0);
INSERT INTO `0_payment_terms` VALUES(2, 'Due By End Of The Following Month', 0, 30, 0);
INSERT INTO `0_payment_terms` VALUES(3, 'Payment due within 10 days', 10, 0, 0);
INSERT INTO `0_payment_terms` VALUES(4, 'Cash Only', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_prices`
--

CREATE TABLE `0_prices` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(20) NOT NULL default '',
  `transport_type_id` int(11) NOT NULL default '0',
  `curr_abrev` char(3) NOT NULL default '',
  `price` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `price` (`stock_id`,`transport_type_id`,`curr_abrev`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `0_prices`
--

INSERT INTO `0_prices` VALUES(1, '3400', 1, 'USD', 100);
INSERT INTO `0_prices` VALUES(2, '102', 1, 'USD', 50);
INSERT INTO `0_prices` VALUES(3, '103', 1, 'USD', 55);
INSERT INTO `0_prices` VALUES(4, '104', 1, 'USD', 60);

-- --------------------------------------------------------

--
-- Table structure for table `0_printers`
--

CREATE TABLE `0_printers` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_printers`
--

INSERT INTO `0_printers` VALUES(1, 'QL500', 'Label printer', 'QL500', 'server', 127, 20);
INSERT INTO `0_printers` VALUES(2, 'Samsung', 'Main network printer', 'scx4521F', 'server', 515, 5);
INSERT INTO `0_printers` VALUES(3, 'Local', 'Local print server at user IP', 'lp', '', 515, 10);

-- --------------------------------------------------------

--
-- Table structure for table `0_print_profiles`
--

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) default NULL,
  `printer` tinyint(3) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `0_print_profiles`
--

INSERT INTO `0_print_profiles` VALUES(1, 'Out of office', NULL, 0);
INSERT INTO `0_print_profiles` VALUES(2, 'Sales Department', NULL, 0);
INSERT INTO `0_print_profiles` VALUES(3, 'Central', NULL, 2);
INSERT INTO `0_print_profiles` VALUES(4, 'Sales Department', '104', 2);
INSERT INTO `0_print_profiles` VALUES(5, 'Sales Department', '105', 2);
INSERT INTO `0_print_profiles` VALUES(6, 'Sales Department', '107', 2);
INSERT INTO `0_print_profiles` VALUES(7, 'Sales Department', '109', 2);
INSERT INTO `0_print_profiles` VALUES(8, 'Sales Department', '110', 2);
INSERT INTO `0_print_profiles` VALUES(9, 'Sales Department', '201', 2);

-- --------------------------------------------------------

--
-- Table structure for table `0_purch_data`
--

CREATE TABLE `0_purch_data` (
  `supplier_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `price` double NOT NULL default '0',
  `suppliers_uom` char(50) NOT NULL default '',
  `conversion_factor` double NOT NULL default '1',
  `supplier_description` char(50) NOT NULL default '',
  PRIMARY KEY  (`supplier_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_purch_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_purch_orders`
--

CREATE TABLE `0_purch_orders` (
  `order_no` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `comments` tinytext,
  `ord_date` date NOT NULL default '0000-00-00',
  `reference` tinytext NOT NULL,
  `requisition_no` tinytext,
  `into_stock_location` varchar(5) NOT NULL default '',
  `delivery_address` tinytext NOT NULL,
  `total` double NOT NULL default '0',
  `tax_included` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`order_no`),
  KEY `ord_date` (`ord_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_purch_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_purch_order_details`
--

CREATE TABLE `0_purch_order_details` (
  `po_detail_item` int(11) NOT NULL auto_increment,
  `order_no` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `delivery_date` date NOT NULL default '0000-00-00',
  `qty_invoiced` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `act_price` double NOT NULL default '0',
  `std_cost_unit` double NOT NULL default '0',
  `quantity_ordered` double NOT NULL default '0',
  `quantity_received` double NOT NULL default '0',
  PRIMARY KEY  (`po_detail_item`),
  KEY `order` (`order_no`,`po_detail_item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_purch_order_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_quick_entries`
--

CREATE TABLE `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `type` tinyint(1) NOT NULL default '0',
  `description` varchar(60) NOT NULL,
  `base_amount` double NOT NULL default '0',
  `base_desc` varchar(60) default NULL,
  `bal_type` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_quick_entries`
--

INSERT INTO `0_quick_entries` VALUES(1, 1, 'Maintenance', 0, 'Amount', 0);
INSERT INTO `0_quick_entries` VALUES(2, 4, 'Phone', 0, 'Amount', 0);
INSERT INTO `0_quick_entries` VALUES(3, 2, 'Cash Sales', 0, 'Amount', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_quick_entry_lines`
--

CREATE TABLE `0_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double default '0',
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL default '',
  `dimension_id` smallint(6) unsigned default NULL,
  `dimension2_id` smallint(6) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `qid` (`qid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `0_quick_entry_lines`
--

INSERT INTO `0_quick_entry_lines` VALUES(1, 1, 0, 't-', '1', 0, 0);
INSERT INTO `0_quick_entry_lines` VALUES(2, 2, 0, 't-', '1', 0, 0);
INSERT INTO `0_quick_entry_lines` VALUES(3, 3, 0, 't-', '1', 0, 0);
INSERT INTO `0_quick_entry_lines` VALUES(4, 3, 0, '=', '4010', 0, 0);
INSERT INTO `0_quick_entry_lines` VALUES(5, 1, 0, '=', '5765', 0, 0);
INSERT INTO `0_quick_entry_lines` VALUES(6, 2, 0, '=', '5780', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_recurrent_invoices`
--

CREATE TABLE `0_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `order_no` int(11) unsigned NOT NULL,
  `consignor_no` int(11) unsigned default NULL,
  `consignee_no` int(11) default NULL,
  `group_no` smallint(6) unsigned default NULL,
  `days` int(11) NOT NULL default '0',
  `monthly` int(11) NOT NULL default '0',
  `begin` date NOT NULL default '0000-00-00',
  `end` date NOT NULL default '0000-00-00',
  `last_sent` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_recurrent_invoices`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_refs`
--

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_refs`
--

INSERT INTO `0_refs` VALUES(18, 0, '1');
INSERT INTO `0_refs` VALUES(19, 0, '2');
INSERT INTO `0_refs` VALUES(21, 0, '3');
INSERT INTO `0_refs` VALUES(22, 0, '4');
INSERT INTO `0_refs` VALUES(23, 0, '5');
INSERT INTO `0_refs` VALUES(24, 0, '6');
INSERT INTO `0_refs` VALUES(1, 0, '7');
INSERT INTO `0_refs` VALUES(2, 0, '8');
INSERT INTO `0_refs` VALUES(3, 0, '9');
INSERT INTO `0_refs` VALUES(9, 1, '2');
INSERT INTO `0_refs` VALUES(6, 2, '2');
INSERT INTO `0_refs` VALUES(1, 4, '4');
INSERT INTO `0_refs` VALUES(26, 10, '10');
INSERT INTO `0_refs` VALUES(2, 10, '100');
INSERT INTO `0_refs` VALUES(3, 10, '101');
INSERT INTO `0_refs` VALUES(4, 10, '102');
INSERT INTO `0_refs` VALUES(5, 10, '103');
INSERT INTO `0_refs` VALUES(6, 10, '104');
INSERT INTO `0_refs` VALUES(7, 10, '105');
INSERT INTO `0_refs` VALUES(8, 10, '106');
INSERT INTO `0_refs` VALUES(9, 10, '107');
INSERT INTO `0_refs` VALUES(10, 10, '108');
INSERT INTO `0_refs` VALUES(11, 10, '109');
INSERT INTO `0_refs` VALUES(27, 10, '11');
INSERT INTO `0_refs` VALUES(12, 10, '110');
INSERT INTO `0_refs` VALUES(13, 10, '111');
INSERT INTO `0_refs` VALUES(14, 10, '112');
INSERT INTO `0_refs` VALUES(15, 10, '113');
INSERT INTO `0_refs` VALUES(21, 10, '32');
INSERT INTO `0_refs` VALUES(22, 10, '33');
INSERT INTO `0_refs` VALUES(17, 10, '50');
INSERT INTO `0_refs` VALUES(18, 10, '51');
INSERT INTO `0_refs` VALUES(19, 10, '52');
INSERT INTO `0_refs` VALUES(20, 10, '53');
INSERT INTO `0_refs` VALUES(23, 10, '7');
INSERT INTO `0_refs` VALUES(16, 10, '73');
INSERT INTO `0_refs` VALUES(24, 10, '8');
INSERT INTO `0_refs` VALUES(25, 10, '9');
INSERT INTO `0_refs` VALUES(1, 10, '99');
INSERT INTO `0_refs` VALUES(1, 11, '10');
INSERT INTO `0_refs` VALUES(4, 11, '2');
INSERT INTO `0_refs` VALUES(3, 11, '5');
INSERT INTO `0_refs` VALUES(2, 11, '9');
INSERT INTO `0_refs` VALUES(14, 12, '27');
INSERT INTO `0_refs` VALUES(15, 12, '28');
INSERT INTO `0_refs` VALUES(16, 12, '29');
INSERT INTO `0_refs` VALUES(1, 12, '55');
INSERT INTO `0_refs` VALUES(2, 12, '56');
INSERT INTO `0_refs` VALUES(3, 12, '57');
INSERT INTO `0_refs` VALUES(4, 12, '58');
INSERT INTO `0_refs` VALUES(5, 12, '59');
INSERT INTO `0_refs` VALUES(6, 12, '60');
INSERT INTO `0_refs` VALUES(7, 12, '61');
INSERT INTO `0_refs` VALUES(8, 12, '62');
INSERT INTO `0_refs` VALUES(9, 12, '63');
INSERT INTO `0_refs` VALUES(10, 12, '64');
INSERT INTO `0_refs` VALUES(11, 12, '65');
INSERT INTO `0_refs` VALUES(12, 12, '66');
INSERT INTO `0_refs` VALUES(13, 12, '67');
INSERT INTO `0_refs` VALUES(22, 13, '16');
INSERT INTO `0_refs` VALUES(24, 13, '17');
INSERT INTO `0_refs` VALUES(25, 13, '18');
INSERT INTO `0_refs` VALUES(26, 13, '19');
INSERT INTO `0_refs` VALUES(28, 13, '20');
INSERT INTO `0_refs` VALUES(1, 13, '40');
INSERT INTO `0_refs` VALUES(2, 13, '41');
INSERT INTO `0_refs` VALUES(3, 13, '42');
INSERT INTO `0_refs` VALUES(4, 13, '43');
INSERT INTO `0_refs` VALUES(5, 13, '44');
INSERT INTO `0_refs` VALUES(6, 13, '45');
INSERT INTO `0_refs` VALUES(7, 13, '46');
INSERT INTO `0_refs` VALUES(8, 13, '47');
INSERT INTO `0_refs` VALUES(9, 13, '48');
INSERT INTO `0_refs` VALUES(10, 13, '49');
INSERT INTO `0_refs` VALUES(11, 13, '50');
INSERT INTO `0_refs` VALUES(12, 13, '51');
INSERT INTO `0_refs` VALUES(13, 13, '52');
INSERT INTO `0_refs` VALUES(14, 13, '53');
INSERT INTO `0_refs` VALUES(17, 13, '54');
INSERT INTO `0_refs` VALUES(15, 13, 'auto');
INSERT INTO `0_refs` VALUES(16, 13, 'auto');
INSERT INTO `0_refs` VALUES(18, 13, 'auto');
INSERT INTO `0_refs` VALUES(19, 13, 'auto');
INSERT INTO `0_refs` VALUES(20, 13, 'auto');
INSERT INTO `0_refs` VALUES(21, 13, 'auto');
INSERT INTO `0_refs` VALUES(23, 13, 'auto');
INSERT INTO `0_refs` VALUES(27, 13, 'auto');
INSERT INTO `0_refs` VALUES(29, 13, 'auto');
INSERT INTO `0_refs` VALUES(2, 16, '10');
INSERT INTO `0_refs` VALUES(3, 16, '11');
INSERT INTO `0_refs` VALUES(1, 16, '9');
INSERT INTO `0_refs` VALUES(1, 17, '1');
INSERT INTO `0_refs` VALUES(2, 17, '2');
INSERT INTO `0_refs` VALUES(3, 17, '3');
INSERT INTO `0_refs` VALUES(4, 17, '4');
INSERT INTO `0_refs` VALUES(3, 18, '3');
INSERT INTO `0_refs` VALUES(5, 18, '4');
INSERT INTO `0_refs` VALUES(7, 18, '5');
INSERT INTO `0_refs` VALUES(9, 18, '6');
INSERT INTO `0_refs` VALUES(1, 18, 'auto');
INSERT INTO `0_refs` VALUES(2, 18, 'auto');
INSERT INTO `0_refs` VALUES(4, 18, 'auto');
INSERT INTO `0_refs` VALUES(6, 18, 'auto');
INSERT INTO `0_refs` VALUES(8, 18, 'auto');
INSERT INTO `0_refs` VALUES(10, 18, 'auto');
INSERT INTO `0_refs` VALUES(11, 18, 'auto');
INSERT INTO `0_refs` VALUES(12, 18, 'auto');
INSERT INTO `0_refs` VALUES(13, 18, 'auto');
INSERT INTO `0_refs` VALUES(14, 18, 'auto');
INSERT INTO `0_refs` VALUES(16, 20, '10');
INSERT INTO `0_refs` VALUES(2, 20, '13');
INSERT INTO `0_refs` VALUES(1, 20, '14');
INSERT INTO `0_refs` VALUES(9, 20, '3');
INSERT INTO `0_refs` VALUES(10, 20, '4');
INSERT INTO `0_refs` VALUES(11, 20, '5');
INSERT INTO `0_refs` VALUES(12, 20, '6');
INSERT INTO `0_refs` VALUES(13, 20, '7');
INSERT INTO `0_refs` VALUES(14, 20, '8');
INSERT INTO `0_refs` VALUES(15, 20, '9');
INSERT INTO `0_refs` VALUES(5, 22, '2');
INSERT INTO `0_refs` VALUES(6, 22, '3');
INSERT INTO `0_refs` VALUES(7, 22, '4');
INSERT INTO `0_refs` VALUES(3, 25, '3');
INSERT INTO `0_refs` VALUES(1, 25, 'auto');
INSERT INTO `0_refs` VALUES(2, 25, 'auto');
INSERT INTO `0_refs` VALUES(4, 25, 'auto');
INSERT INTO `0_refs` VALUES(5, 25, 'auto');
INSERT INTO `0_refs` VALUES(6, 25, 'auto');
INSERT INTO `0_refs` VALUES(7, 25, 'auto');
INSERT INTO `0_refs` VALUES(8, 25, 'auto');
INSERT INTO `0_refs` VALUES(9, 25, 'auto');
INSERT INTO `0_refs` VALUES(10, 25, 'auto');
INSERT INTO `0_refs` VALUES(11, 25, 'auto');
INSERT INTO `0_refs` VALUES(10, 26, '10');
INSERT INTO `0_refs` VALUES(11, 26, '11');
INSERT INTO `0_refs` VALUES(12, 26, '12');
INSERT INTO `0_refs` VALUES(13, 26, '13');
INSERT INTO `0_refs` VALUES(14, 26, '14');
INSERT INTO `0_refs` VALUES(15, 26, '15');
INSERT INTO `0_refs` VALUES(16, 26, '16');
INSERT INTO `0_refs` VALUES(17, 26, '17');
INSERT INTO `0_refs` VALUES(18, 26, '18');
INSERT INTO `0_refs` VALUES(19, 26, '19');
INSERT INTO `0_refs` VALUES(20, 26, '20');
INSERT INTO `0_refs` VALUES(21, 26, '21');
INSERT INTO `0_refs` VALUES(22, 26, '22');
INSERT INTO `0_refs` VALUES(23, 26, '23');
INSERT INTO `0_refs` VALUES(24, 26, '24');
INSERT INTO `0_refs` VALUES(25, 26, '25');
INSERT INTO `0_refs` VALUES(28, 26, '26');
INSERT INTO `0_refs` VALUES(32, 26, '27');
INSERT INTO `0_refs` VALUES(34, 26, '28');
INSERT INTO `0_refs` VALUES(36, 26, '29');
INSERT INTO `0_refs` VALUES(33, 26, '298');
INSERT INTO `0_refs` VALUES(37, 26, '30');
INSERT INTO `0_refs` VALUES(39, 26, '31');
INSERT INTO `0_refs` VALUES(40, 26, '32');
INSERT INTO `0_refs` VALUES(41, 26, '33');
INSERT INTO `0_refs` VALUES(42, 26, '34');
INSERT INTO `0_refs` VALUES(43, 26, '35');
INSERT INTO `0_refs` VALUES(44, 26, '36');
INSERT INTO `0_refs` VALUES(45, 26, '37');
INSERT INTO `0_refs` VALUES(46, 26, '38');
INSERT INTO `0_refs` VALUES(35, 26, '39');
INSERT INTO `0_refs` VALUES(47, 26, '39');
INSERT INTO `0_refs` VALUES(48, 26, '40');
INSERT INTO `0_refs` VALUES(49, 26, '41');
INSERT INTO `0_refs` VALUES(50, 26, '42');
INSERT INTO `0_refs` VALUES(51, 26, '43');
INSERT INTO `0_refs` VALUES(52, 26, '44');
INSERT INTO `0_refs` VALUES(29, 26, '45');
INSERT INTO `0_refs` VALUES(53, 26, '45');
INSERT INTO `0_refs` VALUES(54, 26, '46');
INSERT INTO `0_refs` VALUES(55, 26, '47');
INSERT INTO `0_refs` VALUES(56, 26, '48');
INSERT INTO `0_refs` VALUES(57, 26, '49');
INSERT INTO `0_refs` VALUES(58, 26, '50');
INSERT INTO `0_refs` VALUES(59, 26, '51');
INSERT INTO `0_refs` VALUES(60, 26, '52');
INSERT INTO `0_refs` VALUES(61, 26, '53');
INSERT INTO `0_refs` VALUES(30, 26, '535');
INSERT INTO `0_refs` VALUES(62, 26, '54');
INSERT INTO `0_refs` VALUES(63, 26, '55');
INSERT INTO `0_refs` VALUES(64, 26, '56');
INSERT INTO `0_refs` VALUES(65, 26, '57');
INSERT INTO `0_refs` VALUES(66, 26, '58');
INSERT INTO `0_refs` VALUES(67, 26, '59');
INSERT INTO `0_refs` VALUES(3, 26, '62');
INSERT INTO `0_refs` VALUES(4, 26, '63');
INSERT INTO `0_refs` VALUES(5, 26, '64');
INSERT INTO `0_refs` VALUES(6, 26, '65');
INSERT INTO `0_refs` VALUES(7, 26, '66');
INSERT INTO `0_refs` VALUES(8, 26, '67');
INSERT INTO `0_refs` VALUES(1, 26, '68');
INSERT INTO `0_refs` VALUES(2, 26, '69');
INSERT INTO `0_refs` VALUES(9, 26, '9');
INSERT INTO `0_refs` VALUES(31, 26, 'rewewr');
INSERT INTO `0_refs` VALUES(1, 28, '1');
INSERT INTO `0_refs` VALUES(2, 28, '2');
INSERT INTO `0_refs` VALUES(2, 29, '2');
INSERT INTO `0_refs` VALUES(29, 30, '24');
INSERT INTO `0_refs` VALUES(31, 30, '25');
INSERT INTO `0_refs` VALUES(1, 30, '62');
INSERT INTO `0_refs` VALUES(2, 30, '63');
INSERT INTO `0_refs` VALUES(3, 30, '64');
INSERT INTO `0_refs` VALUES(5, 30, '65');
INSERT INTO `0_refs` VALUES(6, 30, '66');
INSERT INTO `0_refs` VALUES(7, 30, '67');
INSERT INTO `0_refs` VALUES(8, 30, '68');
INSERT INTO `0_refs` VALUES(9, 30, '69');
INSERT INTO `0_refs` VALUES(10, 30, '70');
INSERT INTO `0_refs` VALUES(11, 30, '71');
INSERT INTO `0_refs` VALUES(12, 30, '72');
INSERT INTO `0_refs` VALUES(13, 30, '73');
INSERT INTO `0_refs` VALUES(14, 30, '74');
INSERT INTO `0_refs` VALUES(15, 30, '75');
INSERT INTO `0_refs` VALUES(18, 30, '76');
INSERT INTO `0_refs` VALUES(4, 30, 'auto');
INSERT INTO `0_refs` VALUES(16, 30, 'auto');
INSERT INTO `0_refs` VALUES(17, 30, 'auto');
INSERT INTO `0_refs` VALUES(19, 30, 'auto');
INSERT INTO `0_refs` VALUES(20, 30, 'auto');
INSERT INTO `0_refs` VALUES(21, 30, 'auto');
INSERT INTO `0_refs` VALUES(22, 30, 'auto');
INSERT INTO `0_refs` VALUES(23, 30, 'auto');
INSERT INTO `0_refs` VALUES(24, 30, 'auto');
INSERT INTO `0_refs` VALUES(25, 30, 'auto');
INSERT INTO `0_refs` VALUES(26, 30, 'auto');
INSERT INTO `0_refs` VALUES(27, 30, 'auto');
INSERT INTO `0_refs` VALUES(28, 30, 'auto');
INSERT INTO `0_refs` VALUES(30, 30, 'auto');
INSERT INTO `0_refs` VALUES(32, 30, 'auto');
INSERT INTO `0_refs` VALUES(1, 32, '54');
INSERT INTO `0_refs` VALUES(2, 32, '55');
INSERT INTO `0_refs` VALUES(3, 32, '56');
INSERT INTO `0_refs` VALUES(4, 32, '57');
INSERT INTO `0_refs` VALUES(5, 32, '58');
INSERT INTO `0_refs` VALUES(6, 32, '59');
INSERT INTO `0_refs` VALUES(7, 32, '60');
INSERT INTO `0_refs` VALUES(8, 32, '61');
INSERT INTO `0_refs` VALUES(9, 32, '62');
INSERT INTO `0_refs` VALUES(10, 32, '63');
INSERT INTO `0_refs` VALUES(11, 32, '64');
INSERT INTO `0_refs` VALUES(12, 32, '65');
INSERT INTO `0_refs` VALUES(13, 32, '66');
INSERT INTO `0_refs` VALUES(14, 32, '67');
INSERT INTO `0_refs` VALUES(15, 32, '68');
INSERT INTO `0_refs` VALUES(16, 32, '69');
INSERT INTO `0_refs` VALUES(17, 32, '70');
INSERT INTO `0_refs` VALUES(18, 32, '71');
INSERT INTO `0_refs` VALUES(19, 32, '72');
INSERT INTO `0_refs` VALUES(20, 32, '73');
INSERT INTO `0_refs` VALUES(21, 32, '74');
INSERT INTO `0_refs` VALUES(19, 33, '57');
INSERT INTO `0_refs` VALUES(20, 33, '58');
INSERT INTO `0_refs` VALUES(21, 33, '59');
INSERT INTO `0_refs` VALUES(22, 33, '60');
INSERT INTO `0_refs` VALUES(23, 33, '61');
INSERT INTO `0_refs` VALUES(1, 33, '62');
INSERT INTO `0_refs` VALUES(2, 33, '63');
INSERT INTO `0_refs` VALUES(3, 33, '64');
INSERT INTO `0_refs` VALUES(4, 33, '65');
INSERT INTO `0_refs` VALUES(5, 33, '66');
INSERT INTO `0_refs` VALUES(6, 33, '67');
INSERT INTO `0_refs` VALUES(7, 33, '68');
INSERT INTO `0_refs` VALUES(8, 33, '69');
INSERT INTO `0_refs` VALUES(9, 33, '70');
INSERT INTO `0_refs` VALUES(10, 33, '71');
INSERT INTO `0_refs` VALUES(11, 33, '72');
INSERT INTO `0_refs` VALUES(12, 33, '73');
INSERT INTO `0_refs` VALUES(13, 33, '74');
INSERT INTO `0_refs` VALUES(14, 33, '75');
INSERT INTO `0_refs` VALUES(15, 33, '76');
INSERT INTO `0_refs` VALUES(16, 33, '77');
INSERT INTO `0_refs` VALUES(17, 33, '78');
INSERT INTO `0_refs` VALUES(18, 33, '79');

-- --------------------------------------------------------

--
-- Table structure for table `0_security_roles`
--

CREATE TABLE `0_security_roles` (
  `id` int(11) NOT NULL auto_increment,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) default NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `0_security_roles`
--

INSERT INTO `0_security_roles` VALUES(1, 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(2, 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128;353280', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3083;3084;3085;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;353380', 0);
INSERT INTO `0_security_roles` VALUES(3, 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873', 0);
INSERT INTO `0_security_roles` VALUES(4, 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(5, 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(6, 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(7, 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(8, 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(9, 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `0_security_roles` VALUES(10, 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_shippers`
--

CREATE TABLE `0_shippers` (
  `shipper_id` int(11) NOT NULL auto_increment,
  `shipper_name` varchar(60) NOT NULL default '',
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_shippers`
--

INSERT INTO `0_shippers` VALUES(1, 'Default', '', '', '', '', 0);
INSERT INTO `0_shippers` VALUES(2, 'Raipur Roadways', '', '', 'Abhishek', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_sql_trail`
--

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_sql_trail`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_stock_category`
--

CREATE TABLE `0_stock_category` (
  `category_id` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `dflt_tax_type` int(11) NOT NULL default '1',
  `dflt_units` varchar(20) NOT NULL default 'each',
  `dflt_mb_flag` char(1) NOT NULL default 'B',
  `dflt_transport_act` varchar(15) NOT NULL default '',
  `dflt_cogs_act` varchar(15) NOT NULL default '',
  `dflt_inventory_act` varchar(15) NOT NULL default '',
  `dflt_adjustment_act` varchar(15) NOT NULL default '',
  `dflt_assembly_act` varchar(15) NOT NULL default '',
  `dflt_dim1` int(11) default NULL,
  `dflt_dim2` int(11) default NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  `dflt_no_sale` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `0_stock_category`
--

INSERT INTO `0_stock_category` VALUES(1, 'Components', 1, 'ea.', 'B', '4010', '5010', '1510', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `0_stock_category` VALUES(2, 'Charges', 1, 'ea.', 'D', '4010', '5010', '1510', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `0_stock_category` VALUES(3, 'Systems', 1, 'ea.', 'M', '4010', '5010', '1510', '5040', '1530', 0, 0, 0, 0);
INSERT INTO `0_stock_category` VALUES(4, 'Services', 1, 'hrs', 'M', '4010', '5010', '5765', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `0_stock_category` VALUES(5, 'Vehicle', 1, 'ea.', 'M', '4430', '5100', '1510', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `0_stock_category` VALUES(6, 'Transportable Items', 1, 'ea.', 'D', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 0);
INSERT INTO `0_stock_category` VALUES(7, 'Fuels', 1, 'Ltr', 'B', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `0_stock_master`
--

CREATE TABLE `0_stock_master` (
  `stock_id` varchar(20) NOT NULL default '',
  `category_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `description` varchar(200) NOT NULL default '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL default 'each',
  `mb_flag` char(1) NOT NULL default 'B',
  `transport_account` varchar(15) NOT NULL default '',
  `cogs_account` varchar(15) NOT NULL default '',
  `inventory_account` varchar(15) NOT NULL default '',
  `adjustment_account` varchar(15) NOT NULL default '',
  `assembly_account` varchar(15) NOT NULL default '',
  `dimension_id` int(11) default NULL,
  `dimension2_id` int(11) default NULL,
  `actual_cost` double NOT NULL default '0',
  `last_cost` double NOT NULL default '0',
  `material_cost` double NOT NULL default '0',
  `labour_cost` double NOT NULL default '0',
  `overhead_cost` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  `no_sale` tinyint(1) NOT NULL default '0',
  `editable` tinyint(1) NOT NULL default '0',
  `vehicle_init_odometer` decimal(10,2) NOT NULL,
  `vehicle_warranty_odometer` decimal(10,2) NOT NULL,
  `vehicle_number_plate` varchar(20) NOT NULL default '',
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
  PRIMARY KEY  (`stock_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_stock_master`
--

INSERT INTO `0_stock_master` VALUES('adsads', 6, 0, 'dasdas', 'adsasd', 'ea.', 'D', '', '', '', '', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('adshl', 5, 1, 'jldasj', 'ja;dsjs', '', 'M', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, 'jldasj', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('Colors', 6, 1, 'Colors', 'Colors', 'ea.', 'D', '', '', '', '', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('GJSDJS', 5, 1, 'RJ05GA8019', 'HFHS', 'ea.', 'M', '4430', '5100', '1510', '5040', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0.00, 'RJ05GA8019', '', '', '', '', 0, '', '', '', '', '2014-01-25', '2014-01-25', '', '', '2014-01-25', '2014-01-25', '', '2014-01-25', '2014-04-05', '', 0.00, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('hfdshf', 6, 0, 'dsasaddas', '', 'ea.', 'D', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('JAAJS', 6, 1, 'adsj', 'asdjadjs', 'ea.', 'D', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('Marbles', 6, 1, 'Marbles', '', 'ea.', 'D', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('NewITEMS', 6, 1, 'fdjsjfdsjdsf', 'dfdsfh', 'ea.', 'D', '', '', '', '', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('NewMarble', 6, 1, 'Marble', '', 'ea.', 'D', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `0_stock_master` VALUES('sfjhsd', 6, 1, 'hddjfsjf', 'fdsd', 'ea.', 'D', '', '', '', '', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_stock_moves`
--

CREATE TABLE `0_stock_moves` (
  `trans_id` int(11) NOT NULL auto_increment,
  `trans_no` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `type` smallint(6) NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `person_id` int(11) default NULL,
  `price` double NOT NULL default '0',
  `reference` char(40) NOT NULL default '',
  `qty` double NOT NULL default '1',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`trans_id`),
  KEY `type` (`type`,`trans_no`),
  KEY `Move` (`stock_id`,`loc_code`,`tran_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=34 ;

--
-- Dumping data for table `0_stock_moves`
--

INSERT INTO `0_stock_moves` VALUES(1, 0, 'GJSDJS', 0, 'BHL', '2014-01-25', NULL, 0, 'auto', 1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(3, 1, 'Marbles', 13, 'DEF', '2014-01-25', 0, 120, '37', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(4, 1, 'GJSDJS', 16, 'BHL', '2014-01-25', 1, 0, '9', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(5, 1, 'GJSDJS', 16, 'DEF', '2014-01-25', 1, 0, '9', 1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(6, 2, 'Marbles', 13, 'DEF', '2014-01-26', 0, 0, '38', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(7, 3, 'Marbles', 13, 'DEF', '2014-01-26', 0, 0, '39', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(8, 1, 'NewMarble', 13, 'BHL', '2014-04-05', 0, 120, '40', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(9, 2, 'GJSDJS', 16, 'DEF', '2014-04-05', 1, 0, '10', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(10, 2, 'GJSDJS', 16, 'NAAS', '2014-04-05', 1, 0, '10', 1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(11, 3, 'GJSDJS', 16, 'NAAS', '2014-04-05', 1, 0, '11', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(12, 3, 'GJSDJS', 16, 'BHL', '2014-04-05', 1, 0, '11', 1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(13, 2, 'NewMarble', 13, 'BHL', '2014-04-05', 0, 10000, '41', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(14, 3, 'NewMarble', 13, 'BHL', '2014-04-05', 0, 0, '42', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(15, 4, 'NewMarble', 13, 'BHL', '2014-04-05', 0, 120, '43', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(16, 5, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 1340, '44', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(17, 6, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 23140, '45', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(18, 7, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 3530, '46', -1, 0.1, 0, 1);
INSERT INTO `0_stock_moves` VALUES(19, 8, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 2340, '47', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(20, 9, 'Colors', 13, 'BHL', '2014-04-19', 0, 1110, '48', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(21, 10, 'Colors', 13, 'BHL', '2014-04-19', 0, 4440, '49', -12, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(22, 10, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 12210, '49', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(23, 11, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 3450, '50', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(24, 12, 'NewMarble', 13, 'BHL', '2014-04-19', 0, 10, '51', -500, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(25, 13, 'JAAJS', 13, 'BHL', '2014-04-19', 0, 24340, '52', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(26, 14, 'Colors', 13, 'BHL', '2014-04-23', 0, 5450, '53', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(27, 15, 'NewMarble', 13, 'BHL', '2014-04-23', 0, 120, 'auto', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(28, 16, 'NewMarble', 13, 'BHL', '2014-04-23', 0, 120, 'auto', -1, 0, 0, 1);
INSERT INTO `0_stock_moves` VALUES(29, 1, 'NewMarble', 11, 'BHL', '2014-04-23', 0, 41000, 'Return Ex Inv: 10', 0, 0, 0, 0);
INSERT INTO `0_stock_moves` VALUES(30, 1, 'Colors', 11, 'BHL', '2014-04-23', 0, 4440, 'Return Ex Inv: 10', 0, 0, 0, 0);
INSERT INTO `0_stock_moves` VALUES(31, 1, 'JAAJS', 11, 'BHL', '2014-04-23', 0, 12210, 'Return Ex Inv: 10', 0, 0, 0, 0);
INSERT INTO `0_stock_moves` VALUES(32, 1, 'NewMarble', 11, 'BHL', '2014-04-23', 0, 10, 'Return Ex Inv: 10', 300, 0, 0, 0);
INSERT INTO `0_stock_moves` VALUES(33, 17, 'Colors', 13, 'BNG', '2014-06-14', 0, 20, '54', -1, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `0_suppliers`
--

CREATE TABLE `0_suppliers` (
  `supplier_id` int(11) NOT NULL auto_increment,
  `supp_name` varchar(60) NOT NULL default '',
  `supp_ref` varchar(30) NOT NULL default '',
  `address` tinytext NOT NULL,
  `supp_address` tinytext NOT NULL,
  `gst_no` varchar(25) NOT NULL default '',
  `contact` varchar(60) NOT NULL default '',
  `supp_account_no` varchar(40) NOT NULL default '',
  `website` varchar(100) NOT NULL default '',
  `bank_account` varchar(60) NOT NULL default '',
  `curr_code` char(3) default NULL,
  `payment_terms` int(11) default NULL,
  `tax_included` tinyint(1) NOT NULL default '0',
  `dimension_id` int(11) default '0',
  `dimension2_id` int(11) default '0',
  `tax_group_id` int(11) default NULL,
  `credit_limit` double NOT NULL default '0',
  `purchase_account` varchar(15) NOT NULL default '',
  `payable_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_suppliers`
--

INSERT INTO `0_suppliers` VALUES(1, 'Junk Beer ApS', 'Junk Beer', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '123456', 'Contact', '111', '', '', 'INR', 3, 0, 1, 0, 2, 1000, '', '2100', '5060', 'A supplier with junk beers.', 0);
INSERT INTO `0_suppliers` VALUES(2, 'Lucky Luke Inc.', 'Lucky Luke', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '654321', 'Luke', '333', '', '', 'INR', 3, 0, 0, 0, 1, 500, '', '2100', '5060', '', 0);
INSERT INTO `0_suppliers` VALUES(3, 'Money Makers Ltd.', 'Money Makers', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '987654', 'Makers', '222', '', '', 'INR', 3, 0, 0, 0, 2, 300, '', '2100', '5060', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_supp_allocations`
--

CREATE TABLE `0_supp_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_supp_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_supp_invoice_items`
--

CREATE TABLE `0_supp_invoice_items` (
  `id` int(11) NOT NULL auto_increment,
  `supp_trans_no` int(11) default NULL,
  `supp_trans_type` int(11) default NULL,
  `gl_code` varchar(15) NOT NULL default '',
  `grn_item_id` int(11) default NULL,
  `po_detail_item_id` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `quantity` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `memo_` tinytext,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`supp_trans_type`,`supp_trans_no`,`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_supp_invoice_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_supp_trans`
--

CREATE TABLE `0_supp_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `supplier_id` int(11) unsigned default NULL,
  `reference` tinytext NOT NULL,
  `supp_reference` varchar(60) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `ov_amount` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `alloc` double NOT NULL default '0',
  `tax_included` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `supplier_id` (`supplier_id`),
  KEY `SupplierID_2` (`supplier_id`,`supp_reference`),
  KEY `type` (`type`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_supp_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_sys_prefs`
--

CREATE TABLE `0_sys_prefs` (
  `name` varchar(35) NOT NULL default '',
  `category` varchar(30) default NULL,
  `type` varchar(20) NOT NULL default '',
  `length` smallint(6) default NULL,
  `value` tinytext,
  PRIMARY KEY  (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_sys_prefs`
--

INSERT INTO `0_sys_prefs` VALUES('coy_name', 'setup.company', 'varchar', 60, 'admin');
INSERT INTO `0_sys_prefs` VALUES('gst_no', 'setup.company', 'varchar', 25, '9876543');
INSERT INTO `0_sys_prefs` VALUES('coy_no', 'setup.company', 'varchar', 25, '123456789');
INSERT INTO `0_sys_prefs` VALUES('tax_prd', 'setup.company', 'int', 11, '1');
INSERT INTO `0_sys_prefs` VALUES('tax_last', 'setup.company', 'int', 11, '1');
INSERT INTO `0_sys_prefs` VALUES('postal_address', 'setup.company', 'tinytext', 0, 'Address 1\r\nAddress 2\r\nAddress 3');
INSERT INTO `0_sys_prefs` VALUES('phone', 'setup.company', 'varchar', 30, '(222) 111.222.333');
INSERT INTO `0_sys_prefs` VALUES('fax', 'setup.company', 'varchar', 30, '');
INSERT INTO `0_sys_prefs` VALUES('email', 'setup.company', 'varchar', 100, 'delta@delta.com');
INSERT INTO `0_sys_prefs` VALUES('coy_logo', 'setup.company', 'varchar', 100, 'logo_frontaccounting.jpg');
INSERT INTO `0_sys_prefs` VALUES('domicile', 'setup.company', 'varchar', 55, '');
INSERT INTO `0_sys_prefs` VALUES('curr_default', 'setup.company', 'char', 3, 'INR');
INSERT INTO `0_sys_prefs` VALUES('use_dimension', 'setup.company', 'tinyint', 1, '1');
INSERT INTO `0_sys_prefs` VALUES('f_year', 'setup.company', 'int', 11, '7');
INSERT INTO `0_sys_prefs` VALUES('no_item_list', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `0_sys_prefs` VALUES('no_consignor_list', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `0_sys_prefs` VALUES('no_supplier_list', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `0_sys_prefs` VALUES('base_transport', 'setup.company', 'int', 11, '0');
INSERT INTO `0_sys_prefs` VALUES('time_zone', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `0_sys_prefs` VALUES('add_pct', 'setup.company', 'int', 5, '-1');
INSERT INTO `0_sys_prefs` VALUES('round_to', 'setup.company', 'int', 5, '1');
INSERT INTO `0_sys_prefs` VALUES('login_tout', 'setup.company', 'smallint', 6, '600');
INSERT INTO `0_sys_prefs` VALUES('past_due_days', 'glsetup.general', 'int', 11, '30');
INSERT INTO `0_sys_prefs` VALUES('profit_loss_year_act', 'glsetup.general', 'varchar', 15, '9990');
INSERT INTO `0_sys_prefs` VALUES('retained_earnings_act', 'glsetup.general', 'varchar', 15, '3590');
INSERT INTO `0_sys_prefs` VALUES('bank_charge_act', 'glsetup.general', 'varchar', 15, '5690');
INSERT INTO `0_sys_prefs` VALUES('exchange_diff_act', 'glsetup.general', 'varchar', 15, '4450');
INSERT INTO `0_sys_prefs` VALUES('default_credit_limit', 'glsetup.consignor', 'int', 11, '1000');
INSERT INTO `0_sys_prefs` VALUES('accumulate_shipping', 'glsetup.consignor', 'tinyint', 1, '1');
INSERT INTO `0_sys_prefs` VALUES('legal_text', 'glsetup.consignor', 'tinytext', 0, '');
INSERT INTO `0_sys_prefs` VALUES('freight_act', 'glsetup.consignor', 'varchar', 15, '4430');
INSERT INTO `0_sys_prefs` VALUES('consignors_act', 'glsetup.transport', 'varchar', 15, '1200');
INSERT INTO `0_sys_prefs` VALUES('default_transport_act', 'glsetup.transport', 'varchar', 15, '4010');
INSERT INTO `0_sys_prefs` VALUES('default_transport_discount_act', 'glsetup.transport', 'varchar', 15, '4510');
INSERT INTO `0_sys_prefs` VALUES('default_prompt_payment_act', 'glsetup.transport', 'varchar', 15, '4500');
INSERT INTO `0_sys_prefs` VALUES('default_delivery_required', 'glsetup.transport', 'smallint', 6, '1');
INSERT INTO `0_sys_prefs` VALUES('default_dim_required', 'glsetup.dims', 'int', 11, '20');
INSERT INTO `0_sys_prefs` VALUES('pyt_discount_act', 'glsetup.purchase', 'varchar', 15, '5060');
INSERT INTO `0_sys_prefs` VALUES('creditors_act', 'glsetup.purchase', 'varchar', 15, '2100');
INSERT INTO `0_sys_prefs` VALUES('po_over_receive', 'glsetup.purchase', 'int', 11, '0');
INSERT INTO `0_sys_prefs` VALUES('po_over_charge', 'glsetup.purchase', 'int', 11, '0');
INSERT INTO `0_sys_prefs` VALUES('allow_negative_stock', 'glsetup.inventory', 'tinyint', 1, '0');
INSERT INTO `0_sys_prefs` VALUES('default_inventory_act', 'glsetup.items', 'varchar', 15, '1520');
INSERT INTO `0_sys_prefs` VALUES('default_cogs_act', 'glsetup.items', 'varchar', 15, '5100');
INSERT INTO `0_sys_prefs` VALUES('default_adj_act', 'glsetup.items', 'varchar', 15, '5040');
INSERT INTO `0_sys_prefs` VALUES('default_inv_transport_act', 'glsetup.items', 'varchar', 15, '4010');
INSERT INTO `0_sys_prefs` VALUES('default_assembly_act', 'glsetup.items', 'varchar', 15, '1530');
INSERT INTO `0_sys_prefs` VALUES('default_workorder_required', 'glsetup.manuf', 'int', 11, '20');
INSERT INTO `0_sys_prefs` VALUES('version_id', 'system', 'varchar', 11, '2.3rc');
INSERT INTO `0_sys_prefs` VALUES('auto_curr_reval', 'setup.company', 'smallint', 6, '1');
INSERT INTO `0_sys_prefs` VALUES('grn_clearing_act', 'glsetup.purchase', 'varchar', 15, '1550');
INSERT INTO `0_sys_prefs` VALUES('bcc_email', 'setup.company', 'varchar', 100, '');
INSERT INTO `0_sys_prefs` VALUES('no_consignee_list', 'setup.company', 'tinyint', 1, '0');

-- --------------------------------------------------------

--
-- Table structure for table `0_sys_types`
--

CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL default '0',
  `type_no` int(11) NOT NULL default '1',
  `next_reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_sys_types`
--

INSERT INTO `0_sys_types` VALUES(0, 19, '10');
INSERT INTO `0_sys_types` VALUES(1, 8, '3');
INSERT INTO `0_sys_types` VALUES(2, 5, '3');
INSERT INTO `0_sys_types` VALUES(4, 3, '5');
INSERT INTO `0_sys_types` VALUES(10, 19, '114');
INSERT INTO `0_sys_types` VALUES(11, 3, '11');
INSERT INTO `0_sys_types` VALUES(12, 6, '68');
INSERT INTO `0_sys_types` VALUES(13, 5, '55');
INSERT INTO `0_sys_types` VALUES(16, 2, '12');
INSERT INTO `0_sys_types` VALUES(17, 2, '5');
INSERT INTO `0_sys_types` VALUES(18, 1, '7');
INSERT INTO `0_sys_types` VALUES(20, 8, '15');
INSERT INTO `0_sys_types` VALUES(21, 1, '1');
INSERT INTO `0_sys_types` VALUES(22, 4, '5');
INSERT INTO `0_sys_types` VALUES(25, 1, '4');
INSERT INTO `0_sys_types` VALUES(26, 1, '70');
INSERT INTO `0_sys_types` VALUES(28, 1, '3');
INSERT INTO `0_sys_types` VALUES(29, 1, '3');
INSERT INTO `0_sys_types` VALUES(30, 5, '77');
INSERT INTO `0_sys_types` VALUES(32, 0, '75');
INSERT INTO `0_sys_types` VALUES(33, 0, '80');
INSERT INTO `0_sys_types` VALUES(35, 1, '1');
INSERT INTO `0_sys_types` VALUES(40, 1, '3');

-- --------------------------------------------------------

--
-- Table structure for table `0_tags`
--

CREATE TABLE `0_tags` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) default NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_tags`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_tag_associations`
--

CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_tag_associations`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_tax_groups`
--

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_tax_groups`
--

INSERT INTO `0_tax_groups` VALUES(1, 'Tax', 0, 0);
INSERT INTO `0_tax_groups` VALUES(2, 'Tax Exempt', 1, 0);
INSERT INTO `0_tax_groups` VALUES(3, 'New ', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_tax_group_items`
--

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  PRIMARY KEY  (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_tax_group_items`
--

INSERT INTO `0_tax_group_items` VALUES(1, 1, 10);
INSERT INTO `0_tax_group_items` VALUES(2, 1, 10);
INSERT INTO `0_tax_group_items` VALUES(3, 1, 10);

-- --------------------------------------------------------

--
-- Table structure for table `0_tax_types`
--

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `rate` double NOT NULL default '0',
  `transport_gl_code` varchar(15) default '',
  `purchasing_gl_code` varchar(15) default '',
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_tax_types`
--

INSERT INTO `0_tax_types` VALUES(1, 10, '2150', '2150', 'Tax', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_transportman`
--

CREATE TABLE `0_transportman` (
  `transportman_code` int(11) NOT NULL auto_increment,
  `transportman_name` char(60) NOT NULL default '',
  `transportman_phone` char(30) NOT NULL default '',
  `transportman_fax` char(30) NOT NULL default '',
  `transportman_email` varchar(100) NOT NULL default '',
  `provision` double NOT NULL default '0',
  `break_pt` double NOT NULL default '0',
  `provision2` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`transportman_code`),
  UNIQUE KEY `transportman_name` (`transportman_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_transportman`
--

INSERT INTO `0_transportman` VALUES(1, 'Sales Person', '', '', '', 5, 1000, 4, 0);
INSERT INTO `0_transportman` VALUES(2, 'New', '', '', '', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_transport_orders`
--

CREATE TABLE `0_transport_orders` (
  `order_no` int(11) NOT NULL,
  `trans_type` smallint(6) NOT NULL default '30',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `consignor_no` int(11) default NULL,
  `branch_code` int(11) default NULL,
  `consignee_no` int(11) default NULL,
  `consignee_branch_code` int(11) default NULL,
  `consignee_ref` tinytext,
  `driver_no` varchar(11) default NULL,
  `driver_ref` varchar(20) default NULL,
  `vehicle_no` char(20) default NULL,
  `vehicle_type` int(11) default NULL,
  `vehicle_ref` tinytext,
  `reference` varchar(100) NOT NULL default '',
  `consignor_ref` varchar(50) default NULL,
  `consignor_tin_no` varchar(20) default NULL,
  `consignee_tin_no` varchar(20) default NULL,
  `comments` tinytext,
  `ord_date` date NOT NULL default '0000-00-00',
  `order_type` int(11) NOT NULL default '0',
  `ship_via` int(11) NOT NULL default '0',
  `delivery_address` tinytext NOT NULL,
  `loading_address` varchar(100) NOT NULL,
  `loaded_from` varchar(100) NOT NULL,
  `contact_phone` varchar(30) default NULL,
  `contact_email` varchar(100) default NULL,
  `deliver_to` tinytext NOT NULL,
  `freight_cost` double NOT NULL default '0',
  `commission_cost` double NOT NULL,
  `labour_charge` double NOT NULL,
  `insc_charge` double NOT NULL,
  `way_cost` double NOT NULL,
  `bilty_charge` double NOT NULL,
  `ship_cost` double NOT NULL,
  `from_stk_loc` varchar(5) NOT NULL default '',
  `Location_to` varchar(5) NOT NULL,
  `delivery_date` date NOT NULL default '0000-00-00',
  `payment_terms` int(11) default NULL,
  `total` double NOT NULL default '0',
  `total_goods_value` decimal(20,0) NOT NULL,
  `goods_bill_no` varchar(50) NOT NULL,
  `payment_by` int(11) NOT NULL,
  `service_tax_by` int(11) NOT NULL,
  `add_service_tax` int(11) NOT NULL,
  PRIMARY KEY  (`trans_type`,`order_no`),
  KEY `vehicle_no` (`vehicle_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_transport_orders`
--

INSERT INTO `0_transport_orders` VALUES(1, 30, 4, 1, 1, 2, 1, 1, '', '4', '98237214', 'GJSDJS', NULL, NULL, '62', 'Abhishek', 'dasdaads', 'asdasd', 'Loading Slip # 1', '2014-04-05', 2, 1, 'addsdas', 'fdahsds', 'Sample', '9714510890', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 4, 120, 1230, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(2, 30, 34, 0, 1, 2, 1, 1, '', '14', '9218217', 'GJSDJS', NULL, NULL, '63', 'Abhishek', 'dasdaads', 'asdasd', 'Loading Slip # 2', '2014-04-05', 2, 1, 'addsdas', 'asd', 'asd', '9714510890', NULL, 'New Consignee', 451, 0, 0, 1, 430, 20, 0, 'BHL', 'NAAS', '2014-04-06', 4, 112031.2, 14450, 'adsad', 3, 1, 1);
INSERT INTO `0_transport_orders` VALUES(3, 30, 1, 0, 2, 3, 1, 1, '', '3', '5545454', 'GJSDJS', NULL, NULL, '64', 'Abhishek', 'HASJSD', 'asdasd', 'Loading Slip # 3', '2014-04-05', 2, 1, 'addsdas', 'sfdfdsf', 'fdsfd', '9714510890', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 1, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(4, 30, 0, 0, 1, 2, 1, 1, '', '4', '98237214', 'GJSDJS', NULL, NULL, 'auto', 'Abhishek', 'dasdaads', 'asdasd', 'Loading Slip # 1', '2014-04-05', 2, 1, 'addsdas', 'fdahsds', 'Sample', '9714510890', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 1, 120, 1230, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(5, 30, 0, 0, 2, 3, 1, 1, '', '1', 'dsad', 'GJSDJS', NULL, NULL, '65', 'das', 'HASJSD', 'asdasd', 'Loading Slip # 5', '2014-04-05', 0, 1, 'addsdas', 'asdads', 'asddas', 'adsads', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-06', 4, 0, 0, 'asdjads', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(6, 30, 0, 0, 2, 3, 1, 1, '', '1', 'dsad', 'GJSDJS', NULL, NULL, '66', 'das', 'HASJSD', 'asdasd', 'Loading Slip # 5', '2014-04-05', 2, 1, 'addsdas', 'asdads', 'asddas', 'adsads', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-06', 4, 0, 0, 'dasddsad', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(7, 30, 0, 0, 2, 3, 1, 1, '', '10', 'asdasd', 'GJSDJS', NULL, NULL, '67', 'sasd', 'HASJSD', 'asdasd', 'Loading Slip # 9', '2014-04-19', 2, 1, 'addsdas', 'asdads', 'das', 'dsa', NULL, 'New Consignee', 474, 0, 340, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 1814, 3320, 'adsda', 3, 1, 1);
INSERT INTO `0_transport_orders` VALUES(8, 30, 0, 0, 2, 3, 1, 1, '', '14', 'das', 'GJSDJS', NULL, NULL, '68', 'sasd', 'HASJSD', 'asdasd', 'Loading Slip # 10', '2014-04-19', 2, 1, 'addsdas', 'asdsads', 'ds', 'dsa', NULL, 'New Consignee', 3544, 0, 1230, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 26684, 0, 'ssda', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(9, 30, 0, 0, 2, 3, 1, 1, '', '10', 'sdf', 'GJSDJS', NULL, NULL, '69', 'sasd', 'HASJSD', 'asdasd', 'Loading Slip # 11', '2014-04-19', 2, 1, 'addsdas', 'fd', 'fs', 'dsa', NULL, 'New Consignee', 317.7, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 3558.24, 0, '2132', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(10, 30, 2, 0, 1, 2, 1, 1, '', '10', 'j', 'GJSDJS', NULL, NULL, '70', 'sasd', 'dasdaads', 'asdasd', 'Loading Slip # 12', '2014-04-19', 2, 1, 'addsdas', 'jjhh', 'jhjhh', 'dsa', NULL, 'New Consignee', 345, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 3795, 0, 'rwe', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(11, 30, 0, 0, 2, 3, 1, 1, '', '10', 'ads', 'GJSDJS', NULL, NULL, '71', 'sasd', 'HASJSD', 'asdasd', 'Loading Slip # 13', '2014-04-19', 2, 1, 'addsdas', 'fdsf', 'dfs', 'dsa', NULL, 'New Consignee', 345, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 3795, 0, 'zcxzc', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(12, 30, 0, 0, 1, 2, 1, 1, '', '10', 'asd', 'GJSDJS', NULL, NULL, '72', 'sasd', 'dasdaads', 'asdasd', 'Loading Slip # 14', '2014-04-19', 2, 1, 'addsdas', 'das', 'sda', 'dsa', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 350, 0, '23', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(13, 30, 0, 0, 2, 3, 1, 1, '', '14', 'ds', 'GJSDJS', NULL, NULL, '73', 'sad', 'HASJSD', 'asdasd', 'Loading Slip # 16', '2014-04-19', 2, 1, 'addsdas', 'dsa', 'ddas', 'ds', NULL, 'New Consignee', 140, 0, 0, 0, 0, 0, 140, 'NAAS', 'BHL', '2014-04-20', 4, 1598, 0, '', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(14, 30, 0, 0, 2, 3, 1, 1, '', '10', 'asdds', 'GJSDJS', NULL, NULL, '74', 'sasd', 'HASJSD', 'asdasd', 'Loading Slip # 15', '2014-04-19', 2, 1, 'addsdas', 'sdasd', 'sdasd', 'dsa', NULL, 'New Consignee', 1231, 1230, 0, 0, 1, 0, 0, 'BHL', 'DEF', '2014-04-20', 4, 28128.1, 0, '', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(15, 30, 0, 0, 2, 3, 1, 1, '', '14', 'ads', 'GJSDJS', NULL, NULL, '75', 'das', 'HASJSD', 'asdasd', 'Loading Slip # 17', '2014-04-23', 2, 1, 'addsdas', 'ads', 'ads', 'das', NULL, 'New Consignee', 130, 0, 0, 0, 0, 130, 0, 'BHL', 'NAAS', '2014-04-24', 4, 6138, 130, 'asd', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(16, 30, 0, 0, 1, 2, 1, 1, '', '4', '98237214', 'GJSDJS', NULL, NULL, 'auto', 'Abhishek', 'dasdaads', 'asdasd', 'Loading Slip # 1', '2014-04-23', 2, 1, 'addsdas', 'fdahsds', 'Sample', '9714510890', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-23', 4, 120, 1230, '', 1, 1, -1);
INSERT INTO `0_transport_orders` VALUES(17, 30, 0, 0, 1, 2, 1, 1, '', '4', '98237214', 'GJSDJS', NULL, NULL, 'auto', 'Abhishek', 'dasdaads', 'asdasd', 'Loading Slip # 1', '2014-04-23', 2, 1, 'addsdas', 'fdahsds', 'Sample', '9714510890', NULL, 'New Consignee', 340, 340, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-23', 4, 460, 1230, '', 1, 1, -1);
INSERT INTO `0_transport_orders` VALUES(18, 30, 0, 0, 1, 2, 1, 1, '', '10', 'gffg', 'GJSDJS', NULL, NULL, '76', 'fggf', 'dasdaads', 'asdasd', 'Loading Slip # 21', '2014-06-14', 2, 1, 'addsdas', 'gf', 'gf', 'gffg', NULL, 'New Consignee', 0, 0, 0, 0, 0, 0, 0, 'BNG', 'BPL', '2014-06-14', 4, 22, 0, '', 1, 1, 1);
INSERT INTO `0_transport_orders` VALUES(1, 32, 0, 1, 0, 0, 0, 0, '', '4', '98237214', 'GJSDJS', NULL, NULL, '54', 'Abhishek', '', '', 'Transport Booking # 1', '2014-04-05', 0, 1, '', 'fdahsds', 'Sample', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(2, 32, 0, 0, 0, 0, 0, 0, '', '14', '9218217', 'GJSDJS', NULL, NULL, '55', 'Abhishek', '', '', 'Transport Booking # 1', '2014-04-05', 0, 1, '', 'asd', 'asd', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 0, 0, 120, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(3, 32, 0, 0, 0, 0, 0, 0, '', '3', '5545454', 'GJSDJS', NULL, NULL, '56', 'Abhishek', '', '', 'Transport Booking # 1', '2014-04-05', 0, 1, '', 'sfdfdsf', 'fdsfd', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(4, 32, 0, 0, 0, 0, 0, 0, '', '7', '983213277', 'GJSDJS', NULL, NULL, '57', 'adarsh', '', '', 'Transport Booking # 3', '2014-04-05', 0, 0, '', 'jasjasd', 'Lakaj', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-06', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(5, 32, 0, 0, 0, 0, 0, 0, '', '1', 'dsad', 'GJSDJS', NULL, NULL, '58', 'das', '', '', 'Transport Booking # 4', '2014-04-05', 0, 0, '', 'asdads', 'asddas', 'adsads', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '0000-00-00', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(6, 32, 0, 0, 0, 0, 0, 0, '', '10', 'adsads', 'GJSDJS', NULL, NULL, '59', 'adarsh', '', '', 'Transport Booking # 3', '2014-04-06', 0, 0, '', 'adsdas', 'sad', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '0000-00-00', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(7, 32, 0, 0, 0, 0, 0, 0, '', '10', 'adsasd', 'GJSDJS', NULL, NULL, '60', 'adarsh', '', '', 'Transport Booking # 3', '2014-04-06', 0, 0, '', 'adsads', 'ads', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '0000-00-00', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(8, 32, 0, 0, 0, 0, 0, 0, '', '14', 'adsdas', 'GJSDJS', NULL, NULL, '61', 'adarsh', '', '', 'Transport Booking # 3', '2014-04-06', 0, 0, '', 'asddas', 'asddas', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-06', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(9, 32, 0, 0, 0, 0, 0, 0, '', '10', 'asdasd', 'GJSDJS', NULL, NULL, '62', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'asdads', 'das', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(10, 32, 0, 0, 0, 0, 0, 0, '', '14', 'das', 'GJSDJS', NULL, NULL, '63', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'asdsads', 'ds', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(11, 32, 0, 0, 0, 0, 0, 0, '', '10', 'sdf', 'GJSDJS', NULL, NULL, '64', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'fd', 'fs', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(12, 32, 0, 0, 0, 0, 0, 0, '', '10', 'j', 'GJSDJS', NULL, NULL, '65', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'jjhh', 'jhjhh', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(13, 32, 0, 0, 0, 0, 0, 0, '', '10', 'ads', 'GJSDJS', NULL, NULL, '66', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'fdsf', 'dfs', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(14, 32, 0, 0, 0, 0, 0, 0, '', '10', 'asd', 'GJSDJS', NULL, NULL, '67', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'das', 'sda', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(15, 32, 0, 0, 0, 0, 0, 0, '', '10', 'asdds', 'GJSDJS', NULL, NULL, '68', 'sasd', '', '', 'Transport Booking # 5', '2014-04-19', 0, 0, '', 'sdasd', 'sdasd', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(16, 32, 0, 0, 0, 0, 0, 0, '', '14', 'ds', 'GJSDJS', NULL, NULL, '69', 'sad', '', '', 'Transport Booking # 6', '2014-04-19', 0, 0, '', 'dsa', 'ddas', 'ds', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'NAAS', 'BHL', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(17, 32, 0, 0, 0, 0, 0, 0, '', '14', 'ads', 'GJSDJS', NULL, NULL, '70', 'das', '', '', 'Transport Booking # 7', '2014-04-23', 0, 0, '', 'ads', 'ads', 'das', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-24', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(18, 32, 0, 0, 0, 0, 0, 0, '', '1', 'sad', 'adshl', NULL, NULL, '71', 'asd', '', '', 'Transport Booking # 8', '2014-04-23', 0, 0, '', 'adsdas', 'asd', 'ads', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'NAAS', 'BHL', '2014-04-24', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(19, 32, 0, 0, 0, 0, 0, 0, '', '10', '98789', 'adshl', NULL, NULL, '72', 'Adarsh', '', '', 'Transport Booking # 13', '2014-06-14', 0, 0, '', 'asdasd', 'Adarsh', 'Adarsh', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(20, 32, 0, 0, 0, 0, 0, 0, '', '15', 'tyty', 'GJSDJS', NULL, NULL, '73', 'Aadrsh', '', '', 'Transport Booking # 14', '2014-06-14', 0, 0, '', 'hggh', 'tyty', '978787', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BPL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(21, 32, 0, 0, 0, 0, 0, 0, '', '10', 'gffg', 'GJSDJS', NULL, NULL, '74', 'fggf', '', '', 'Transport Booking # 15', '2014-06-14', 0, 0, '', 'gf', 'gf', 'gffg', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BNG', 'BPL', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(1, 33, 0, 1, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '62', 'Abhishek', '', '', 'Comments', '2014-04-05', 0, 2, '', '', '', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-06', 0, 0, 1230, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(2, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '63', 'abhis', '', '', '', '2014-04-08', 0, 1, '', '', '', '87136', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-09', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(3, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '64', 'adarsh', '', '', '', '2014-04-05', 0, 0, '', '', '', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-06', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(4, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '65', 'das', '', '', 'adsasd', '2014-04-05', 0, 0, '', '', '', 'adsads', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '0000-00-00', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(5, 33, 1, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '66', 'sasd', '', '', 'dsadsaasd', '2014-04-19', 0, 0, '', '', '', 'dsa', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(6, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '67', 'sad', '', '', 'das', '2014-04-19', 0, 0, '', '', '', 'ds', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'NAAS', 'BHL', '2014-04-20', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(7, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '68', 'das', '', '', 'adsdsa', '2014-04-23', 0, 0, '', '', '', 'das', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'NAAS', '2014-04-24', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(8, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '69', 'asd', '', '', 'asdsad', '2014-04-23', 0, 0, '', '', '', 'ads', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'NAAS', 'BHL', '2014-04-24', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(9, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '70', 'ads', '', '', 'sad', '2014-04-23', 0, 0, '', '', '', 'sad', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'DEF', '2014-04-24', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(10, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '71', 'MUKESH', '', '', '', '2014-05-09', 0, 0, '', '', '', '9414472630', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'RAJ', 'HYD', '2014-05-10', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(11, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '72', 'KANSINGH', '', '', '', '2014-05-09', 0, 0, '', '', '', '9530469495', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'RAJ', 'BPL', '2014-05-10', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(12, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '73', 'sangeeta', '', '', 'Sample', '2014-05-30', 0, 0, '', '', '', '87488374844', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BNG', 'BHL', '2014-05-31', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(13, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '74', 'Adarsh', '', '', 'dasad', '2014-06-14', 0, 0, '', '', '', 'Adarsh', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(14, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '75', 'Aadrsh', '', '', '', '2014-06-14', 0, 0, '', '', '', '978787', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BPL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(15, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '76', 'fggf', '', '', '', '2014-06-14', 0, 0, '', '', '', 'gffg', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BNG', 'BPL', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(16, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '77', 'Adarsh', '', '', '', '2014-06-14', 0, 0, '', '', '', '9714510890', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(17, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '78', 'weqw', '', '', 'qweqew', '2014-06-14', 0, 0, '', '', '', 'qwe', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);
INSERT INTO `0_transport_orders` VALUES(18, 33, 0, 0, 0, 0, 0, 0, '', '', '', '', NULL, NULL, '79', 'Avinash', '', '', 'hdhhdsa', '2014-06-14', 0, 0, '', '', '', '98712718', NULL, '', 0, 0, 0, 0, 0, 0, 0, 'BHL', 'BNG', '2014-06-15', 0, 0, 0, '', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_transport_order_details`
--

CREATE TABLE `0_transport_order_details` (
  `id` int(11) NOT NULL auto_increment,
  `order_no` int(11) NOT NULL default '0',
  `trans_type` smallint(6) NOT NULL default '30',
  `stk_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_sent` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `to_units` varchar(10) NOT NULL,
  `discount_percent` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `sorder` (`trans_type`,`order_no`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=52 ;

--
-- Dumping data for table `0_transport_order_details`
--

INSERT INTO `0_transport_order_details` VALUES(3, 1, 33, 'NewMarble', 'Marble', 0, 0, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(4, 1, 32, 'NewMarble', 'Marble', 1, 0, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(5, 1, 30, 'NewMarble', 'Marble', 1, 120, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(6, 2, 32, 'NewMarble', 'Marble', 1, 0, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(7, 2, 30, 'NewMarble', 'Marble', 1, 41000, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(8, 3, 32, 'NewMarble', 'Marble', 1, 0, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(9, 3, 30, 'NewMarble', 'Marble', 1, 0, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(10, 4, 30, 'NewMarble', 'Marble', 1, 120, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(11, 2, 33, 'NewMarble', 'Marble', 0, 0, 1, 'ea.', 0);
INSERT INTO `0_transport_order_details` VALUES(12, 3, 33, 'NewMarble', 'Marble', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(13, 4, 32, 'NewMarble', 'Marble', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(14, 4, 33, 'Colors', 'Colors', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(15, 5, 32, 'Colors', 'Colors', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(16, 5, 30, 'Colors', 'Colors', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(17, 6, 30, 'Colors', 'Colors', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(18, 6, 32, 'NewMarble', 'Marble', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(19, 7, 32, 'NewMarble', 'Marble', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(20, 8, 32, 'NewMarble', 'Marble', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(21, 2, 30, 'Colors', 'Colors', 12, 4440, 12, 'ea.', 0);
INSERT INTO `0_transport_order_details` VALUES(22, 3, 30, 'Colors', 'Colors', 0, 1, 0, '0', 1320);
INSERT INTO `0_transport_order_details` VALUES(25, 2, 30, 'JAAJS', 'adsj', 1, 12210, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(26, 5, 33, 'JAAJS', 'adsj', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(27, 9, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(28, 7, 30, 'JAAJS', 'adsj', 1, 1340, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(29, 10, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(30, 8, 30, 'JAAJS', 'adsj', 1, 23140, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(31, 11, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(32, 9, 30, 'JAAJS', 'adsj', 1, 3530, 1, 'Bags', 0.1);
INSERT INTO `0_transport_order_details` VALUES(33, 12, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(34, 10, 30, 'JAAJS', 'adsj', 1, 2340, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(35, 10, 30, 'Colors', 'Colors', 1, 1110, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(36, 13, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(37, 11, 30, 'JAAJS', 'adsj', 1, 3450, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(38, 14, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(39, 12, 30, 'JAAJS', 'adsj', 0, 350, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(40, 15, 32, 'JAAJS', 'adsj', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(41, 2, 30, 'NewMarble', 'Marble', 500, 10, 500, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(42, 6, 33, 'NewMarble', 'Marble', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(43, 16, 32, 'NewMarble', 'Marble', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(44, 13, 30, 'NewMarble', 'Marble', 0, 1430, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(45, 14, 30, 'JAAJS', 'adsj', 1, 24340, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(46, 7, 33, 'Colors', 'Colors', 0, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(47, 17, 32, 'Colors', 'Colors', 1, 0, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(48, 15, 30, 'Colors', 'Colors', 1, 5450, 1, 'Bags', 0);
INSERT INTO `0_transport_order_details` VALUES(49, 16, 30, 'NewMarble', 'Marble', 1, 120, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(50, 17, 30, 'NewMarble', 'Marble', 1, 120, 1, 'Gallons', 0);
INSERT INTO `0_transport_order_details` VALUES(51, 18, 30, 'Colors', 'Colors', 1, 20, 1, 'Bags', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_transport_pos`
--

CREATE TABLE `0_transport_pos` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` varchar(5) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_transport_pos`
--

INSERT INTO `0_transport_pos` VALUES(1, 'Default', 1, 1, 'DEF', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_transport_types`
--

CREATE TABLE `0_transport_types` (
  `id` int(11) NOT NULL auto_increment,
  `transport_type` char(50) NOT NULL default '',
  `tax_included` int(1) NOT NULL default '0',
  `factor` double NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `transport_type` (`transport_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `0_transport_types`
--

INSERT INTO `0_transport_types` VALUES(1, 'By Ship', 0, 0, 0);
INSERT INTO `0_transport_types` VALUES(2, 'By Air', 0, 0, 0);
INSERT INTO `0_transport_types` VALUES(3, 'By Road', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_trans_tax_details`
--

CREATE TABLE `0_trans_tax_details` (
  `id` int(11) NOT NULL auto_increment,
  `trans_type` smallint(6) default NULL,
  `trans_no` int(11) default NULL,
  `tran_date` date NOT NULL,
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  `ex_rate` double NOT NULL default '1',
  `included_in_price` tinyint(1) NOT NULL default '0',
  `net_amount` double NOT NULL default '0',
  `amount` double NOT NULL default '0',
  `memo` tinytext,
  PRIMARY KEY  (`id`),
  KEY `Type_and_Number` (`trans_type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=51 ;

--
-- Dumping data for table `0_trans_tax_details`
--

INSERT INTO `0_trans_tax_details` VALUES(1, 13, 3, '2014-01-12', 1, 5, 1, 0, 120, 6, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(2, 10, 3, '2014-01-12', 1, 5, 1, 0, 120, 6, '80');
INSERT INTO `0_trans_tax_details` VALUES(3, 13, 4, '2014-01-12', 1, 5, 1, 0, 120, 6, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(4, 10, 4, '2014-01-12', 1, 5, 1, 0, 120, 6, '81');
INSERT INTO `0_trans_tax_details` VALUES(5, 13, 5, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(6, 10, 5, '2014-01-12', 1, 0, 1, 0, 120, 0, '82');
INSERT INTO `0_trans_tax_details` VALUES(7, 13, 6, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(8, 10, 6, '2014-01-12', 1, 0, 1, 0, 120, 0, '83');
INSERT INTO `0_trans_tax_details` VALUES(9, 13, 7, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(10, 10, 7, '2014-01-12', 1, 0, 1, 0, 120, 0, '84');
INSERT INTO `0_trans_tax_details` VALUES(11, 13, 8, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(12, 10, 8, '2014-01-12', 1, 0, 1, 0, 0, 0, '85');
INSERT INTO `0_trans_tax_details` VALUES(13, 11, 1, '2014-01-12', 1, 0, 1, 0, 120, 0, '10');
INSERT INTO `0_trans_tax_details` VALUES(14, 13, 9, '2014-01-12', 1, 0, 1, 0, 120, 0, '24');
INSERT INTO `0_trans_tax_details` VALUES(15, 10, 9, '2014-01-12', 1, 0, 1, 0, 120, 0, '86');
INSERT INTO `0_trans_tax_details` VALUES(16, 13, 10, '2014-01-12', 1, 0, 1, 0, 122320.09, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(17, 10, 10, '2014-01-12', 1, 0, 1, 0, 122320.09, 0, '87');
INSERT INTO `0_trans_tax_details` VALUES(18, 13, 1, '2014-01-16', 1, 0, 1, 0, 0, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(19, 10, 1, '2014-01-16', 1, 0, 1, 0, 10, 0, '90');
INSERT INTO `0_trans_tax_details` VALUES(20, 13, 2, '2014-01-18', 1, 0, 1, 0, 1220, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(21, 10, 2, '2014-01-18', 1, 0, 1, 0, 1220, 0, '92');
INSERT INTO `0_trans_tax_details` VALUES(22, 13, 3, '2014-01-18', 1, 0, 1, 0, 124454310, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(23, 10, 3, '2014-01-18', 1, 0, 1, 0, 124454310, 0, '93');
INSERT INTO `0_trans_tax_details` VALUES(24, 13, 2, '2014-01-19', 1, 0, 1, 0, 232323210, 0, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(25, 10, 1, '2014-01-19', 1, 0, 1, 0, 232323210, 0, '94');
INSERT INTO `0_trans_tax_details` VALUES(26, 13, 14, '2014-01-25', 1, 0, 1, 0, 120, 0, '36');
INSERT INTO `0_trans_tax_details` VALUES(27, 13, 1, '2014-01-25', 1, 0, 1, 0, 0, 0, '37');
INSERT INTO `0_trans_tax_details` VALUES(28, 13, 1, '2014-01-25', 1, 0, 1, 0, 120, 0, '37');
INSERT INTO `0_trans_tax_details` VALUES(29, 10, 1, '2014-01-25', 1, 0, 1, 0, 120, 0, '97');
INSERT INTO `0_trans_tax_details` VALUES(30, 13, 1, '2014-04-05', 1, 0, 1, 0, 120, 0, '40');
INSERT INTO `0_trans_tax_details` VALUES(31, 10, 1, '2014-04-05', 1, 0, 1, 0, 120, 0, '99');
INSERT INTO `0_trans_tax_details` VALUES(32, 13, 2, '2014-04-05', 1, 0, 1, 0, 10000, 0, '41');
INSERT INTO `0_trans_tax_details` VALUES(33, 10, 2, '2014-04-05', 1, 0, 1, 0, 10000, 0, '100');
INSERT INTO `0_trans_tax_details` VALUES(34, 13, 4, '2014-04-05', 1, 0, 1, 0, 120, 0, '43');
INSERT INTO `0_trans_tax_details` VALUES(35, 10, 4, '2014-04-05', 1, 0, 1, 0, 120, 0, '102');
INSERT INTO `0_trans_tax_details` VALUES(36, 13, 7, '2014-04-19', 1, 10, 1, 0, 317.7, 31.77, '46');
INSERT INTO `0_trans_tax_details` VALUES(37, 13, 12, '2014-04-19', 1, 10, 1, 0, 21, 2.1, '51');
INSERT INTO `0_trans_tax_details` VALUES(38, 10, 10, '2014-04-19', 1, 10, 1, 0, 21, 2.1, '108');
INSERT INTO `0_trans_tax_details` VALUES(39, 13, 13, '2014-04-19', 1, 10, 1, 0, 24340, 2434, '52');
INSERT INTO `0_trans_tax_details` VALUES(40, 10, 11, '2014-04-19', 1, 10, 1, 0, 24340, 2434, '109');
INSERT INTO `0_trans_tax_details` VALUES(41, 13, 14, '2014-04-23', 1, 10, 1, 0, 5450, 545, '53');
INSERT INTO `0_trans_tax_details` VALUES(42, 10, 12, '2014-04-23', 1, 10, 1, 0, 5450, 545, '110');
INSERT INTO `0_trans_tax_details` VALUES(43, 13, 15, '2014-04-23', 1, 10, 1, 0, 120, 12, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(44, 10, 13, '2014-04-23', 1, 10, 1, 0, 120, 12, '111');
INSERT INTO `0_trans_tax_details` VALUES(45, 13, 16, '2014-04-23', 1, 10, 1, 0, 120, 12, 'auto');
INSERT INTO `0_trans_tax_details` VALUES(46, 10, 14, '2014-04-23', 1, 10, 1, 0, 120, 12, '112');
INSERT INTO `0_trans_tax_details` VALUES(47, 11, 1, '2014-04-23', 1, 10, 1, 0, 5000, 500, '10');
INSERT INTO `0_trans_tax_details` VALUES(48, 10, 8, '2014-04-19', 1, 10, 1, 0, 65490, 6549, '106');
INSERT INTO `0_trans_tax_details` VALUES(49, 13, 17, '2014-06-14', 1, 10, 1, 0, 20, 2, '54');
INSERT INTO `0_trans_tax_details` VALUES(50, 10, 15, '2014-06-14', 1, 10, 1, 0, 20, 2, '113');

-- --------------------------------------------------------

--
-- Table structure for table `0_useronline`
--

CREATE TABLE `0_useronline` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(15) NOT NULL default '0',
  `ip` varchar(40) NOT NULL default '',
  `file` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_useronline`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_users`
--

CREATE TABLE `0_users` (
  `id` smallint(6) NOT NULL auto_increment,
  `user_id` varchar(60) NOT NULL default '',
  `password` varchar(100) NOT NULL default '',
  `real_name` varchar(100) NOT NULL default '',
  `role_id` int(11) NOT NULL default '1',
  `phone` varchar(30) NOT NULL default '',
  `email` varchar(100) default NULL,
  `language` varchar(20) default NULL,
  `date_format` tinyint(1) NOT NULL default '0',
  `date_sep` tinyint(1) NOT NULL default '0',
  `tho_sep` tinyint(1) NOT NULL default '0',
  `dec_sep` tinyint(1) NOT NULL default '0',
  `theme` varchar(20) NOT NULL default 'default',
  `page_size` varchar(20) NOT NULL default 'A4',
  `prices_dec` smallint(6) NOT NULL default '2',
  `qty_dec` smallint(6) NOT NULL default '2',
  `rates_dec` smallint(6) NOT NULL default '4',
  `percent_dec` smallint(6) NOT NULL default '1',
  `show_gl` tinyint(1) NOT NULL default '1',
  `show_codes` tinyint(1) NOT NULL default '0',
  `show_hints` tinyint(1) NOT NULL default '0',
  `last_visit_date` datetime default NULL,
  `query_size` tinyint(1) default '10',
  `graphic_links` tinyint(1) default '1',
  `pos` smallint(6) default '1',
  `print_profile` varchar(30) NOT NULL default '1',
  `rep_popup` tinyint(1) default '1',
  `sticky_doc_date` tinyint(1) default '0',
  `startup_tab` varchar(20) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `0_users`
--

INSERT INTO `0_users` VALUES(1, 'admin', '2f1abedac8cdcaa8acf6815889150ecc', 'Administrator', 2, '', 'adm@adm.com', 'C', 0, 0, 0, 0, 'default', 'Letter', 2, 2, 4, 1, 1, 0, 0, '2014-06-14 11:37:58', 10, 1, 1, '', 1, 0, 'orders', 0);
INSERT INTO `0_users` VALUES(2, 'demouser', '5f4dcc3b5aa765d61d8327deb882cf99', 'Demo User', 9, '999-999-999', 'demo@demo.nu', 'en_US', 0, 0, 0, 0, 'default', 'Letter', 2, 2, 3, 1, 1, 0, 0, '2008-02-06 19:02:35', 10, 1, 1, '1', 1, 0, 'orders', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_vehicles_master`
--

CREATE TABLE `0_vehicles_master` (
  `vehicle_no` int(11) NOT NULL auto_increment,
  `vehicle_init_odometer` decimal(10,2) NOT NULL,
  `vehicle_warranty_odometer` decimal(10,2) NOT NULL,
  `vehicle_number_plate` varchar(20) NOT NULL default '',
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
  `vehicle_purchase_price` decimal(10,2) NOT NULL,
  `vehicle_purchase_date` date NOT NULL,
  `vehicle_warranty_date` date NOT NULL,
  `vehicle_vendor_id` int(11) NOT NULL,
  `vehicle_purchase_note` varchar(200) NOT NULL,
  `vehicle_wt` decimal(10,2) NOT NULL,
  `vehicle_wt_unit` int(11) NOT NULL,
  `vehicle_type_id` int(11) NOT NULL,
  `vehicle_fuel_type_id` int(11) NOT NULL,
  `vehicle_fuel_usage_id` int(11) NOT NULL,
  `vehicle_odometer_type_id` int(10) NOT NULL,
  `inactive` int(10) NOT NULL,
  PRIMARY KEY  (`vehicle_no`),
  UNIQUE KEY `vehicle_number_plate` (`vehicle_number_plate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_vehicles_master`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_vehicle_types`
--

CREATE TABLE `0_vehicle_types` (
  `vehicle_type_code` int(11) NOT NULL auto_increment,
  `vehicle_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vehicle_type_code`),
  UNIQUE KEY `description` (`vehicle_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `0_vehicle_types`
--

INSERT INTO `0_vehicle_types` VALUES(5, 'sad', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_vehicle_weight_types`
--

CREATE TABLE `0_vehicle_weight_types` (
  `vehicle_weight_type_code` int(11) NOT NULL auto_increment,
  `vehicle_weight_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vehicle_weight_type_code`),
  UNIQUE KEY `description` (`vehicle_weight_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `0_vehicle_weight_types`
--

INSERT INTO `0_vehicle_weight_types` VALUES(5, 'Kg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_vendors_master`
--

CREATE TABLE `0_vendors_master` (
  `vendor_no` int(11) NOT NULL auto_increment,
  `vendor_name` varchar(100) NOT NULL default '',
  `vendor_birth_date` date NOT NULL,
  `hired_on` date NOT NULL,
  `licence_no` varchar(100) NOT NULL,
  `health_exam_ref` varchar(100) NOT NULL,
  `date_of_checkup` date NOT NULL,
  `vendor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `curr_code` char(3) NOT NULL default '',
  `payment_terms` int(11) default NULL,
  `rate` decimal(10,2) NOT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vendor_no`),
  UNIQUE KEY `vendor_ref` (`vendor_ref`),
  KEY `name` (`vendor_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `0_vendors_master`
--

INSERT INTO `0_vendors_master` VALUES(1, 'Beefeater Ltd.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Beefeater', 'Addr 1\nAddr 2\nAddr 3', 'GBP', 3, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(2, 'Ghostbusters Corp.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Ghostbusters', 'Address 1\nAddress 2\nAddress 3', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(3, 'Brezan', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Brezan', 'Address 1\nAddress 2\nAddress 3', 'EUR', 3, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(4, 'asd', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'sad', NULL, '', NULL, 0.00, 'USD', 0);
INSERT INTO `0_vendors_master` VALUES(5, 'dsa', '0000-00-00', '0000-00-00', 'das', '', '0000-00-00', 'dsa', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(6, 'dasdasjadsjads', '0000-00-00', '0000-00-00', 'dsa', '', '0000-00-00', 'Anurodh', 'dsa', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(7, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(8, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sddddddda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(9, 'das', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'dsadsdsashkgdsuhgskd', 'dasa', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(10, 'dsa', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Andhrapradesh', 'das', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(11, 'Avinash', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'Jeengar', 'ddhfsf', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(12, 'Naehhe', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'adasdhhdas', NULL, 'USD', 4, 55.00, '', 1);
INSERT INTO `0_vendors_master` VALUES(13, 'adnannadads', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'dasnands,,nads', 'czx', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(14, 'Avinashskjd', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'fsdhfas', 'fdsfkskdfsnksd', 'USD', 4, 0.00, '', 0);
INSERT INTO `0_vendors_master` VALUES(15, 'HKHAd', '0000-00-00', '2014-02-17', '', '', '0000-00-00', 'daljajdsjl', 'dasjllads', 'USD', 4, 0.00, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_vendor_trans`
--

CREATE TABLE `0_vendor_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `vendor_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `vendor_no` (`vendor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_vendor_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_vendor_trans_details`
--

CREATE TABLE `0_vendor_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `vendor_trans_no` int(11) default NULL,
  `vendor_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`vendor_trans_type`,`vendor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_vendor_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_voided`
--

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `0_voided`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_workcentres`
--

CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(40) NOT NULL default '',
  `description` char(50) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `0_workcentres`
--

INSERT INTO `0_workcentres` VALUES(1, 'Workshop', 'Workshop in Alabama', 0);

-- --------------------------------------------------------

--
-- Table structure for table `0_workorders`
--

CREATE TABLE `0_workorders` (
  `id` int(11) NOT NULL auto_increment,
  `wo_ref` varchar(60) NOT NULL default '',
  `loc_code` varchar(5) NOT NULL default '',
  `units_reqd` double NOT NULL default '1',
  `stock_id` varchar(20) NOT NULL default '',
  `vehicle_id` varchar(20) NOT NULL,
  `date_` date NOT NULL default '0000-00-00',
  `type` tinyint(4) NOT NULL default '0',
  `required_by` date NOT NULL default '0000-00-00',
  `released_date` date NOT NULL default '0000-00-00',
  `units_issued` double NOT NULL default '0',
  `closed` tinyint(1) NOT NULL default '0',
  `released` tinyint(1) NOT NULL default '0',
  `additional_costs` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_workorders`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_issues`
--

CREATE TABLE `0_wo_issues` (
  `issue_no` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `reference` varchar(100) default NULL,
  `issue_date` date default NULL,
  `loc_code` varchar(5) default NULL,
  `workcentre_id` int(11) default NULL,
  PRIMARY KEY  (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_issues`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_issue_items`
--

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(40) default NULL,
  `issue_id` int(11) default NULL,
  `qty_issued` double default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_issue_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_manufacture`
--

CREATE TABLE `0_wo_manufacture` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(100) default NULL,
  `workorder_id` int(11) NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_manufacture`
--


-- --------------------------------------------------------

--
-- Table structure for table `0_wo_requirements`
--

CREATE TABLE `0_wo_requirements` (
  `id` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `workcentre` int(11) NOT NULL default '0',
  `vehicle_id` varchar(20) NOT NULL,
  `units_req` double NOT NULL default '1',
  `std_cost` double NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `units_issued` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `0_wo_requirements`
--


-- --------------------------------------------------------

--
-- Table structure for table `1_dashboard_reminders`
--

CREATE TABLE `1_dashboard_reminders` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `next_date` date NOT NULL,
  `description` text,
  `frequency` varchar(20) NOT NULL,
  `param` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `1_dashboard_reminders`
--


-- --------------------------------------------------------

--
-- Table structure for table `1_dashboard_widgets`
--

CREATE TABLE `1_dashboard_widgets` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `app` varchar(50) NOT NULL,
  `column_id` int(11) NOT NULL,
  `sort_no` int(11) NOT NULL,
  `collapsed` tinyint(4) NOT NULL,
  `widget` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `param` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=40 ;

--
-- Dumping data for table `1_dashboard_widgets`
--

INSERT INTO `1_dashboard_widgets` VALUES(1, 1, 'AP', 1, 1, 0, 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(2, 1, 'AP', 1, 0, 0, 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(3, 1, 'AP', 2, 1, 0, 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(6, 1, 'AP', 2, 0, 0, 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(7, 1, 'orders', 1, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(9, 1, 'orders', 1, 1, 0, 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(10, 1, 'AP', 1, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(11, 1, 'AP', 2, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(12, 1, 'GL', 2, 1, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(13, 1, 'GL', 2, 0, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(14, 1, 'stock', 1, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(15, 1, 'stock', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(16, 1, 'manuf', 1, 0, 0, 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(17, 1, 'manuf', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(18, 1, 'orders', 2, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(19, 1, 'GL', 2, 2, 0, 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(20, 1, 'GL', 1, 1, 0, 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(21, 1, 'GL', 1, 0, 0, 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(22, 2, 'AP', 1, 1, 0, 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(23, 2, 'AP', 1, 0, 0, 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(24, 2, 'AP', 2, 1, 0, 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(25, 2, 'AP', 2, 0, 0, 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(26, 2, 'orders', 1, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(27, 2, 'orders', 1, 1, 0, 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(28, 2, 'AP', 1, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(29, 2, 'AP', 2, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(30, 2, 'GL', 2, 1, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(31, 2, 'GL', 2, 0, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(32, 2, 'stock', 1, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(33, 2, 'stock', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(34, 2, 'manuf', 1, 0, 0, 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(35, 2, 'manuf', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(36, 2, 'orders', 2, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(37, 2, 'GL', 2, 2, 0, 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(38, 2, 'GL', 1, 1, 0, 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `1_dashboard_widgets` VALUES(39, 2, 'GL', 1, 0, 0, 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}');

-- --------------------------------------------------------

--
-- Table structure for table `2_accident_data`
--

CREATE TABLE `2_accident_data` (
  `accident_id` int(11) NOT NULL auto_increment,
  `stock_id` char(20) NOT NULL default '',
  `accident_reading` int(50) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `date` date NOT NULL,
  `accident_description` varchar(200) NOT NULL,
  PRIMARY KEY  (`accident_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_accident_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_areas`
--

CREATE TABLE `2_areas` (
  `area_code` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `2_areas`
--

INSERT INTO `2_areas` VALUES(1, 'Global', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_attachments`
--

CREATE TABLE `2_attachments` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `type_no` int(11) NOT NULL default '0',
  `trans_no` int(11) NOT NULL default '0',
  `unique_name` varchar(60) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `filename` varchar(60) NOT NULL default '',
  `filesize` int(11) NOT NULL default '0',
  `filetype` varchar(60) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_attachments`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_audit_trail`
--

CREATE TABLE `2_audit_trail` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) unsigned NOT NULL default '0',
  `trans_no` int(11) unsigned NOT NULL default '0',
  `user` smallint(6) unsigned NOT NULL default '0',
  `stamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `description` varchar(60) default NULL,
  `fiscal_year` int(11) NOT NULL,
  `gl_date` date NOT NULL default '0000-00-00',
  `gl_seq` int(11) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_audit_trail`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_bank_accounts`
--

CREATE TABLE `2_bank_accounts` (
  `account_code` varchar(15) NOT NULL default '',
  `account_type` smallint(6) NOT NULL default '0',
  `bank_account_name` varchar(60) NOT NULL default '',
  `bank_account_number` varchar(100) NOT NULL default '',
  `bank_name` varchar(60) NOT NULL default '',
  `bank_address` tinytext,
  `bank_curr_code` char(3) NOT NULL default '',
  `dflt_curr_act` tinyint(1) NOT NULL default '0',
  `id` smallint(6) NOT NULL auto_increment,
  `last_reconciled_date` timestamp NOT NULL default '0000-00-00 00:00:00',
  `ending_reconcile_balance` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `bank_account_name` (`bank_account_name`),
  KEY `bank_account_number` (`bank_account_number`),
  KEY `account_code` (`account_code`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_bank_accounts`
--

INSERT INTO `2_bank_accounts` VALUES('1060', 0, 'Current account', '9999999999', 'Wachovia Bank', NULL, 'INR', 0, 1, '0000-00-00 00:00:00', 0, 0);
INSERT INTO `2_bank_accounts` VALUES('1065', 3, 'Petty Cash account', 'N/A', 'N/A', NULL, 'INR', 0, 2, '0000-00-00 00:00:00', 0, 0);
INSERT INTO `2_bank_accounts` VALUES('1061', 3, 'Citi Bank Account', '8282382', 'Citi Bank', 'fhfd', 'INR', 1, 3, '2014-01-10 18:30:00', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_bank_trans`
--

CREATE TABLE `2_bank_trans` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) default NULL,
  `trans_no` int(11) default NULL,
  `bank_act` varchar(15) NOT NULL default '',
  `ref` varchar(40) default NULL,
  `trans_date` date NOT NULL default '0000-00-00',
  `amount` double default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `person_type_id` int(11) NOT NULL default '0',
  `person_id` tinyblob,
  `reconciled` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `bank_act` (`bank_act`,`ref`),
  KEY `type` (`type`,`trans_no`),
  KEY `bank_act_2` (`bank_act`,`reconciled`),
  KEY `bank_act_3` (`bank_act`,`trans_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_bank_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_bom`
--

CREATE TABLE `2_bom` (
  `id` int(11) NOT NULL auto_increment,
  `parent` char(20) NOT NULL default '',
  `component` char(20) NOT NULL default '',
  `workcentre_added` int(11) NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `vehicle_id` varchar(20) NOT NULL,
  `quantity` double NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `component` (`component`),
  KEY `id` (`id`),
  KEY `loc_code` (`loc_code`),
  KEY `parent` (`parent`,`loc_code`),
  KEY `workcentre_added` (`workcentre_added`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_bom`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_budget_trans`
--

CREATE TABLE `2_budget_trans` (
  `counter` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL default '0',
  `type_no` bigint(16) NOT NULL default '1',
  `tran_date` date NOT NULL default '0000-00-00',
  `account` varchar(15) NOT NULL default '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL default '0',
  `dimension_id` int(11) default '0',
  `dimension2_id` int(11) default '0',
  `person_type_id` int(11) default NULL,
  `person_id` tinyblob,
  PRIMARY KEY  (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `Account` (`account`,`tran_date`,`dimension_id`,`dimension2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_budget_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_chart_class`
--

CREATE TABLE `2_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL default '',
  `ctype` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_chart_class`
--

INSERT INTO `2_chart_class` VALUES('1', 'Assets', 1, 0);
INSERT INTO `2_chart_class` VALUES('2', 'Liabilities', 2, 0);
INSERT INTO `2_chart_class` VALUES('3', 'Income', 4, 0);
INSERT INTO `2_chart_class` VALUES('4', 'Costs', 6, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_chart_master`
--

CREATE TABLE `2_chart_master` (
  `account_code` varchar(15) NOT NULL default '',
  `account_code2` varchar(15) NOT NULL default '',
  `account_name` varchar(60) NOT NULL default '',
  `account_type` varchar(10) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_chart_master`
--

INSERT INTO `2_chart_master` VALUES('1060', '', 'Checking Account', '1', 0);
INSERT INTO `2_chart_master` VALUES('1065', '', 'Petty Cash', '1', 0);
INSERT INTO `2_chart_master` VALUES('1200', '', 'Accounts Receivables', '1', 0);
INSERT INTO `2_chart_master` VALUES('1205', '', 'Allowance for doubtful accounts', '1', 0);
INSERT INTO `2_chart_master` VALUES('1510', '', 'Inventory', '2', 0);
INSERT INTO `2_chart_master` VALUES('1520', '', 'Stocks of Raw Materials', '2', 0);
INSERT INTO `2_chart_master` VALUES('1530', '', 'Stocks of Work In Progress', '2', 0);
INSERT INTO `2_chart_master` VALUES('1540', '', 'Stocks of Finsihed Goods', '2', 0);
INSERT INTO `2_chart_master` VALUES('1550', '', 'Goods Received Clearing account', '2', 0);
INSERT INTO `2_chart_master` VALUES('1820', '', 'Office Furniture &amp; Equipment', '3', 0);
INSERT INTO `2_chart_master` VALUES('1825', '', 'Accum. Amort. -Furn. &amp; Equip.', '3', 0);
INSERT INTO `2_chart_master` VALUES('1840', '', 'Vehicle', '3', 0);
INSERT INTO `2_chart_master` VALUES('1845', '', 'Accum. Amort. -Vehicle', '3', 0);
INSERT INTO `2_chart_master` VALUES('2100', '', 'Accounts Payable', '4', 0);
INSERT INTO `2_chart_master` VALUES('2110', '', 'Accrued Income Tax - Federal', '4', 0);
INSERT INTO `2_chart_master` VALUES('2120', '', 'Accrued Income Tax - State', '4', 0);
INSERT INTO `2_chart_master` VALUES('2130', '', 'Accrued Franchise Tax', '4', 0);
INSERT INTO `2_chart_master` VALUES('2140', '', 'Accrued Real &amp; Personal Prop Tax', '4', 0);
INSERT INTO `2_chart_master` VALUES('2150', '', 'Transport Tax', '4', 0);
INSERT INTO `2_chart_master` VALUES('2160', '', 'Accrued Use Tax Payable', '4', 0);
INSERT INTO `2_chart_master` VALUES('2210', '', 'Accrued Wages', '4', 0);
INSERT INTO `2_chart_master` VALUES('2220', '', 'Accrued Comp Time', '4', 0);
INSERT INTO `2_chart_master` VALUES('2230', '', 'Accrued Holiday Pay', '4', 0);
INSERT INTO `2_chart_master` VALUES('2240', '', 'Accrued Vacation Pay', '4', 0);
INSERT INTO `2_chart_master` VALUES('2310', '', 'Accr. Benefits - 401K', '4', 0);
INSERT INTO `2_chart_master` VALUES('2320', '', 'Accr. Benefits - Stock Purchase', '4', 0);
INSERT INTO `2_chart_master` VALUES('2330', '', 'Accr. Benefits - Med, Den', '4', 0);
INSERT INTO `2_chart_master` VALUES('2340', '', 'Accr. Benefits - Payroll Taxes', '4', 0);
INSERT INTO `2_chart_master` VALUES('2350', '', 'Accr. Benefits - Credit Union', '4', 0);
INSERT INTO `2_chart_master` VALUES('2360', '', 'Accr. Benefits - Savings Bond', '4', 0);
INSERT INTO `2_chart_master` VALUES('2370', '', 'Accr. Benefits - Garnish', '4', 0);
INSERT INTO `2_chart_master` VALUES('2380', '', 'Accr. Benefits - Charity Cont.', '4', 0);
INSERT INTO `2_chart_master` VALUES('2620', '', 'Bank Loans', '5', 0);
INSERT INTO `2_chart_master` VALUES('2680', '', 'Loans from Shareholders', '5', 0);
INSERT INTO `2_chart_master` VALUES('3350', '', 'Common Shares', '6', 0);
INSERT INTO `2_chart_master` VALUES('3590', '', 'Retained Earnings - prior years', '7', 0);
INSERT INTO `2_chart_master` VALUES('4010', '', 'Transport', '8', 0);
INSERT INTO `2_chart_master` VALUES('4430', '', 'Shipping &amp; Handling', '9', 0);
INSERT INTO `2_chart_master` VALUES('4440', '', 'Interest', '9', 0);
INSERT INTO `2_chart_master` VALUES('4450', '', 'Foreign Exchange Gain', '9', 0);
INSERT INTO `2_chart_master` VALUES('4500', '', 'Prompt Payment Discounts', '9', 0);
INSERT INTO `2_chart_master` VALUES('4510', '', 'Discounts Given', '9', 0);
INSERT INTO `2_chart_master` VALUES('5010', '', 'Cost of Goods Sold - Retail', '10', 0);
INSERT INTO `2_chart_master` VALUES('5020', '', 'Material Usage Varaiance', '10', 0);
INSERT INTO `2_chart_master` VALUES('5030', '', 'Consumable Materials', '10', 0);
INSERT INTO `2_chart_master` VALUES('5040', '', 'Purchase price Variance', '10', 0);
INSERT INTO `2_chart_master` VALUES('5050', '', 'Purchases of materials', '10', 0);
INSERT INTO `2_chart_master` VALUES('5060', '', 'Discounts Received', '10', 0);
INSERT INTO `2_chart_master` VALUES('5100', '', 'Freight', '10', 0);
INSERT INTO `2_chart_master` VALUES('5410', '', 'Wages &amp; Salaries', '11', 0);
INSERT INTO `2_chart_master` VALUES('5420', '', 'Wages - Overtime', '11', 0);
INSERT INTO `2_chart_master` VALUES('5430', '', 'Benefits - Comp Time', '11', 0);
INSERT INTO `2_chart_master` VALUES('5440', '', 'Benefits - Payroll Taxes', '11', 0);
INSERT INTO `2_chart_master` VALUES('5450', '', 'Benefits - Workers Comp', '11', 0);
INSERT INTO `2_chart_master` VALUES('5460', '', 'Benefits - Pension', '11', 0);
INSERT INTO `2_chart_master` VALUES('5470', '', 'Benefits - General Benefits', '11', 0);
INSERT INTO `2_chart_master` VALUES('5510', '', 'Inc Tax Exp - Federal', '11', 0);
INSERT INTO `2_chart_master` VALUES('5520', '', 'Inc Tax Exp - State', '11', 0);
INSERT INTO `2_chart_master` VALUES('5530', '', 'Taxes - Real Estate', '11', 0);
INSERT INTO `2_chart_master` VALUES('5540', '', 'Taxes - Personal Property', '11', 0);
INSERT INTO `2_chart_master` VALUES('5550', '', 'Taxes - Franchise', '11', 0);
INSERT INTO `2_chart_master` VALUES('5560', '', 'Taxes - Foreign Withholding', '11', 0);
INSERT INTO `2_chart_master` VALUES('5610', '', 'Accounting &amp; Legal', '12', 0);
INSERT INTO `2_chart_master` VALUES('5615', '', 'Advertising &amp; Promotions', '12', 0);
INSERT INTO `2_chart_master` VALUES('5620', '', 'Bad Debts', '12', 0);
INSERT INTO `2_chart_master` VALUES('5660', '', 'Amortization Expense', '12', 0);
INSERT INTO `2_chart_master` VALUES('5685', '', 'Insurance', '12', 0);
INSERT INTO `2_chart_master` VALUES('5690', '', 'Interest &amp; Bank Charges', '12', 0);
INSERT INTO `2_chart_master` VALUES('5700', '', 'Office Supplies', '12', 0);
INSERT INTO `2_chart_master` VALUES('5760', '', 'Rent', '12', 0);
INSERT INTO `2_chart_master` VALUES('5765', '', 'Repair &amp; Maintenance', '12', 0);
INSERT INTO `2_chart_master` VALUES('5780', '', 'Telephone', '12', 0);
INSERT INTO `2_chart_master` VALUES('5785', '', 'Travel &amp; Entertainment', '12', 0);
INSERT INTO `2_chart_master` VALUES('5790', '', 'Utilities', '12', 0);
INSERT INTO `2_chart_master` VALUES('5795', '', 'Registrations', '12', 0);
INSERT INTO `2_chart_master` VALUES('5800', '', 'Licenses', '12', 0);
INSERT INTO `2_chart_master` VALUES('5810', '', 'Foreign Exchange Loss', '12', 0);
INSERT INTO `2_chart_master` VALUES('9990', '', 'Year Profit/Loss', '12', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_chart_types`
--

CREATE TABLE `2_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL default '',
  `class_id` varchar(3) NOT NULL default '',
  `parent` varchar(10) NOT NULL default '-1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_chart_types`
--

INSERT INTO `2_chart_types` VALUES('1', 'Current Assets', '1', '', 0);
INSERT INTO `2_chart_types` VALUES('2', 'Inventory Assets', '1', '', 0);
INSERT INTO `2_chart_types` VALUES('3', 'Capital Assets', '1', '', 0);
INSERT INTO `2_chart_types` VALUES('4', 'Current Liabilities', '2', '', 0);
INSERT INTO `2_chart_types` VALUES('5', 'Long Term Liabilities', '2', '', 0);
INSERT INTO `2_chart_types` VALUES('6', 'Share Capital', '2', '', 0);
INSERT INTO `2_chart_types` VALUES('7', 'Retained Earnings', '2', '', 0);
INSERT INTO `2_chart_types` VALUES('8', 'Transport Revenue', '3', '', 0);
INSERT INTO `2_chart_types` VALUES('9', 'Other Revenue', '3', '', 0);
INSERT INTO `2_chart_types` VALUES('10', 'Cost of Goods Sold', '4', '', 0);
INSERT INTO `2_chart_types` VALUES('11', 'Payroll Expenses', '4', '', 0);
INSERT INTO `2_chart_types` VALUES('12', 'General &amp; Administrative expenses', '4', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_comments`
--

CREATE TABLE `2_comments` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date default '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_consignees_master`
--

CREATE TABLE `2_consignees_master` (
  `consignee_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `consignee_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL default '',
  `curr_code` char(3) NOT NULL default '',
  `credit_status` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  `discount` double NOT NULL default '0',
  `pymt_discount` double NOT NULL default '0',
  `credit_limit` float NOT NULL default '1000',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`consignee_no`),
  UNIQUE KEY `consignee_ref` (`consignee_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_consignees_master`
--

INSERT INTO `2_consignees_master` VALUES(1, 'New Consignee', 'Consignee', 'asdsa', '', 'INR', 1, 4, 0, 0, 1000, '', 0);
INSERT INTO `2_consignees_master` VALUES(2, 'Consignee2', 'Consignee2', 'dasda', '', 'INR', 1, 4, 0, 0, 1000, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_consignee_allocations`
--

CREATE TABLE `2_consignee_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_consignee_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_consignee_branch`
--

CREATE TABLE `2_consignee_branch` (
  `consignee_branch_code` int(11) NOT NULL auto_increment,
  `consignee_no` int(11) NOT NULL default '0',
  `br_name` varchar(60) NOT NULL default '',
  `consignee_branch_ref` varchar(30) NOT NULL default '',
  `tin_no` varchar(20) NOT NULL,
  `br_address` tinytext NOT NULL,
  `area` int(11) default NULL,
  `transportman` int(11) NOT NULL default '0',
  `contact_name` varchar(60) NOT NULL default '',
  `default_location` varchar(5) NOT NULL default '',
  `tax_group_id` int(11) default NULL,
  `transport_account` varchar(15) NOT NULL default '',
  `transport_discount_account` varchar(15) NOT NULL default '',
  `receivables_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `default_ship_via` int(11) NOT NULL default '1',
  `disable_trans` tinyint(4) NOT NULL default '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL default '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`consignee_branch_code`,`consignee_no`),
  KEY `branch_code` (`consignee_branch_code`),
  KEY `branch_ref` (`consignee_branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_consignee_branch`
--

INSERT INTO `2_consignee_branch` VALUES(1, 1, 'New Consignee', 'Consignee', 'asdasd', 'asdsa', 1, 2, '', 'DEF', 1, '', '', '', '', 1, 0, 'addsdas', 2, 'asdsa', 0);
INSERT INTO `2_consignee_branch` VALUES(2, 2, 'Consignee2', 'Consignee2', 'ads', 'dasda', 1, 2, '', '', 1, '', '', '', '', 0, 0, '4510', 4500, 'dasda', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_consignee_trans`
--

CREATE TABLE `2_consignee_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `consignee_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `consignee_no` (`consignee_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_consignee_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_consignee_trans_details`
--

CREATE TABLE `2_consignee_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `consignee_trans_no` int(11) default NULL,
  `consignee_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`consignee_trans_type`,`consignee_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_consignee_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_consignors_master`
--

CREATE TABLE `2_consignors_master` (
  `consignor_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `consignor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL default '',
  `curr_code` char(3) NOT NULL default '',
  `transport_type` int(11) NOT NULL default '1',
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `credit_status` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  `discount` double NOT NULL default '0',
  `pymt_discount` double NOT NULL default '0',
  `credit_limit` float NOT NULL default '1000',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`consignor_no`),
  UNIQUE KEY `consignor_ref` (`consignor_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_consignors_master`
--

INSERT INTO `2_consignors_master` VALUES(1, 'New', 'sda', 'sdad', '', 'INR', 2, 0, 0, 1, 4, 0, 0, 1000, '', 0);
INSERT INTO `2_consignors_master` VALUES(2, 'Adarsh Somani', 'Adarsh', '', '', 'INR', 2, 0, 0, 1, 4, 0, 0, 1000, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_consignor_allocations`
--

CREATE TABLE `2_consignor_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_consignor_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_consignor_branch`
--

CREATE TABLE `2_consignor_branch` (
  `branch_code` int(11) NOT NULL auto_increment,
  `consignor_no` int(11) NOT NULL default '0',
  `br_name` varchar(60) NOT NULL default '',
  `branch_ref` varchar(30) NOT NULL default '',
  `tin_no` varchar(20) NOT NULL,
  `br_address` tinytext NOT NULL,
  `area` int(11) default NULL,
  `transportman` int(11) NOT NULL default '0',
  `contact_name` varchar(60) NOT NULL default '',
  `default_location` varchar(5) NOT NULL default '',
  `tax_group_id` int(11) default NULL,
  `transport_account` varchar(15) NOT NULL default '',
  `transport_discount_account` varchar(15) NOT NULL default '',
  `receivables_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `default_ship_via` int(11) NOT NULL default '1',
  `disable_trans` tinyint(4) NOT NULL default '0',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL default '0',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`branch_code`,`consignor_no`),
  KEY `branch_code` (`branch_code`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_consignor_branch`
--

INSERT INTO `2_consignor_branch` VALUES(2, 1, 'New', 'sda', 'dasdaads', 'sdad', 1, 2, '', 'DEF', 1, '', '4510', '1200', '4500', 1, 0, 'sdad', 0, '', 0);
INSERT INTO `2_consignor_branch` VALUES(3, 2, 'Adarsh Somani', 'Adarsh', 'HASJSD', '', 1, 2, '', 'BHL', 1, '', '4510', '1200', '4500', 1, 0, '', 0, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_consignor_trans`
--

CREATE TABLE `2_consignor_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `consignor_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `consignor_no` (`consignor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_consignor_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_consignor_trans_details`
--

CREATE TABLE `2_consignor_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `consignor_trans_no` int(11) default NULL,
  `consignor_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `to_units` varchar(20) NOT NULL,
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`consignor_trans_type`,`consignor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `2_consignor_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_credit_status`
--

CREATE TABLE `2_credit_status` (
  `id` int(11) NOT NULL auto_increment,
  `reason_description` char(100) NOT NULL default '',
  `dissallow_invoices` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `2_credit_status`
--

INSERT INTO `2_credit_status` VALUES(1, 'Good History', 0, 0);
INSERT INTO `2_credit_status` VALUES(3, 'No more work until payment received', 1, 0);
INSERT INTO `2_credit_status` VALUES(4, 'In liquidation', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_crm_categories`
--

CREATE TABLE `2_crm_categories` (
  `id` int(11) NOT NULL auto_increment COMMENT 'pure technical key',
  `type` varchar(20) NOT NULL COMMENT 'contact type e.g. consignor',
  `action` varchar(20) NOT NULL COMMENT 'detailed usage e.g. department',
  `name` varchar(30) NOT NULL COMMENT 'for category selector',
  `description` tinytext NOT NULL COMMENT 'usage description',
  `system` tinyint(1) NOT NULL default '0' COMMENT 'nonzero for core system usage',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`action`),
  UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `2_crm_categories`
--

INSERT INTO `2_crm_categories` VALUES(1, 'consignor_branch', 'general', 'General', 'General contact data for consignor branch (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(2, 'consignor_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(3, 'consignor_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(4, 'consignor_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(5, 'consignor', 'general', 'General', 'General contact data for consignor', 1, 0);
INSERT INTO `2_crm_categories` VALUES(6, 'consignor', 'order', 'Orders', 'Order confirmation', 1, 0);
INSERT INTO `2_crm_categories` VALUES(7, 'consignor', 'delivery', 'Deliveries', 'Delivery coordination', 1, 0);
INSERT INTO `2_crm_categories` VALUES(8, 'consignor', 'invoice', 'Invoices', 'Invoice posting', 1, 0);
INSERT INTO `2_crm_categories` VALUES(9, 'supplier', 'general', 'General', 'General contact data for supplier', 1, 0);
INSERT INTO `2_crm_categories` VALUES(10, 'supplier', 'order', 'Orders', 'Order confirmation', 1, 0);
INSERT INTO `2_crm_categories` VALUES(11, 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', 1, 0);
INSERT INTO `2_crm_categories` VALUES(12, 'supplier', 'invoice', 'Invoices', 'Invoice posting', 1, 0);
INSERT INTO `2_crm_categories` VALUES(13, 'consignee_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(14, 'consignee_branch', 'general', 'General', 'General contact data for consignor branch (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(15, 'consignee_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', 1, 0);
INSERT INTO `2_crm_categories` VALUES(16, 'consignee_branch', 'order', 'Orders', 'Order Confirmation', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_crm_contacts`
--

CREATE TABLE `2_crm_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) NOT NULL default '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
  `entity_id` varchar(11) default NULL COMMENT 'entity id in related class table',
  PRIMARY KEY  (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=65 ;

--
-- Dumping data for table `2_crm_contacts`
--

INSERT INTO `2_crm_contacts` VALUES(1, 1, 'consignor', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(2, 2, 'consignor', 'general', '2');
INSERT INTO `2_crm_contacts` VALUES(3, 3, 'consignor', 'general', '3');
INSERT INTO `2_crm_contacts` VALUES(5, 5, 'consignor_branch', 'general', '2');
INSERT INTO `2_crm_contacts` VALUES(7, 7, 'supplier', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(8, 8, 'supplier', 'general', '2');
INSERT INTO `2_crm_contacts` VALUES(9, 9, 'supplier', 'general', '3');
INSERT INTO `2_crm_contacts` VALUES(10, 10, 'consignor_branch', 'general', '4');
INSERT INTO `2_crm_contacts` VALUES(11, 10, 'consignor', 'general', '4');
INSERT INTO `2_crm_contacts` VALUES(13, 11, 'consignor', 'general', '5');
INSERT INTO `2_crm_contacts` VALUES(14, 12, 'consignor_branch', 'general', '6');
INSERT INTO `2_crm_contacts` VALUES(15, 13, 'consignee_branch', 'general', '5');
INSERT INTO `2_crm_contacts` VALUES(16, 14, 'consignor_branch', 'general', '7');
INSERT INTO `2_crm_contacts` VALUES(17, 14, 'consignor', 'general', '6');
INSERT INTO `2_crm_contacts` VALUES(18, 15, 'consignor_branch', 'general', '8');
INSERT INTO `2_crm_contacts` VALUES(19, 15, 'consignor', 'general', '7');
INSERT INTO `2_crm_contacts` VALUES(20, 16, 'consignee_branch', 'general', '6');
INSERT INTO `2_crm_contacts` VALUES(21, 16, 'consignee', 'general', '8');
INSERT INTO `2_crm_contacts` VALUES(22, 17, 'consignee_branch', 'general', '7');
INSERT INTO `2_crm_contacts` VALUES(23, 18, 'consignee_branch', 'general', '8');
INSERT INTO `2_crm_contacts` VALUES(24, 19, 'consignee_branch', 'general', '9');
INSERT INTO `2_crm_contacts` VALUES(26, 20, 'consignee', 'general', '9');
INSERT INTO `2_crm_contacts` VALUES(27, 21, 'consignee_branch', 'general', '11');
INSERT INTO `2_crm_contacts` VALUES(28, 22, 'consignor_branch', 'general', '9');
INSERT INTO `2_crm_contacts` VALUES(29, 22, 'consignor', 'general', '8');
INSERT INTO `2_crm_contacts` VALUES(30, 20, 'consignee_branch', 'general', '10');
INSERT INTO `2_crm_contacts` VALUES(31, 6, 'consignor_branch', 'delivery', '3');
INSERT INTO `2_crm_contacts` VALUES(32, 6, 'consignor_branch', 'general', '3');
INSERT INTO `2_crm_contacts` VALUES(33, 6, 'consignor_branch', 'invoice', '3');
INSERT INTO `2_crm_contacts` VALUES(34, 6, 'consignor_branch', 'order', '3');
INSERT INTO `2_crm_contacts` VALUES(38, 23, 'consignee_branch', 'delivery', '3');
INSERT INTO `2_crm_contacts` VALUES(39, 23, 'consignee_branch', 'general', '3');
INSERT INTO `2_crm_contacts` VALUES(40, 23, 'consignee_branch', 'invoice', '3');
INSERT INTO `2_crm_contacts` VALUES(41, 23, 'consignee_branch', 'order', '3');
INSERT INTO `2_crm_contacts` VALUES(43, 24, 'consignor', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(45, 25, 'consignee', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(46, 26, 'consignor_branch', 'general', '2');
INSERT INTO `2_crm_contacts` VALUES(47, 26, 'consignor', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(49, 27, 'consignee', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(50, 28, 'consignee_branch', 'general', '2');
INSERT INTO `2_crm_contacts` VALUES(51, 28, 'consignee', 'general', '2');
INSERT INTO `2_crm_contacts` VALUES(52, 25, 'consignee_branch', 'delivery', '1');
INSERT INTO `2_crm_contacts` VALUES(53, 25, 'consignee_branch', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(54, 25, 'consignee_branch', 'invoice', '1');
INSERT INTO `2_crm_contacts` VALUES(55, 25, 'consignee_branch', 'order', '1');
INSERT INTO `2_crm_contacts` VALUES(59, 27, 'consignee_branch', 'delivery', '1');
INSERT INTO `2_crm_contacts` VALUES(60, 27, 'consignee_branch', 'general', '1');
INSERT INTO `2_crm_contacts` VALUES(61, 27, 'consignee_branch', 'invoice', '1');
INSERT INTO `2_crm_contacts` VALUES(62, 27, 'consignee_branch', 'order', '1');
INSERT INTO `2_crm_contacts` VALUES(63, 1, 'consignor_branch', 'general', '3');
INSERT INTO `2_crm_contacts` VALUES(64, 1, 'consignor', 'general', '2');

-- --------------------------------------------------------

--
-- Table structure for table `2_crm_persons`
--

CREATE TABLE `2_crm_persons` (
  `id` int(11) NOT NULL auto_increment,
  `ref` varchar(30) NOT NULL,
  `name` varchar(60) NOT NULL,
  `name2` varchar(60) default NULL,
  `address` tinytext,
  `phone` varchar(30) default NULL,
  `phone2` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `email` varchar(100) default NULL,
  `lang` char(5) default NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `ref` (`ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_crm_persons`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_currencies`
--

CREATE TABLE `2_currencies` (
  `currency` varchar(60) NOT NULL default '',
  `curr_abrev` char(3) NOT NULL default '',
  `curr_symbol` varchar(10) NOT NULL default '',
  `country` varchar(100) NOT NULL default '',
  `hundreds_name` varchar(15) NOT NULL default '',
  `auto_update` tinyint(1) NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`curr_abrev`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_currencies`
--

INSERT INTO `2_currencies` VALUES('US Dollars', 'USD', '$', 'United States', 'Cents', 1, 0);
INSERT INTO `2_currencies` VALUES('CA Dollars', 'CAD', '$', 'Canada', 'Cents', 1, 0);
INSERT INTO `2_currencies` VALUES('Euro', 'EUR', '?', 'Europe', 'Cents', 1, 0);
INSERT INTO `2_currencies` VALUES('Pounds', 'GBP', '?', 'England', 'Pence', 1, 0);
INSERT INTO `2_currencies` VALUES('DK Kroner', 'DKK', '?', 'Denmark', 'Ore', 1, 0);
INSERT INTO `2_currencies` VALUES('Rupees', 'INR', 'Rs', 'India', 'Paisa', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_dashboard_reminders`
--

CREATE TABLE `2_dashboard_reminders` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `next_date` date NOT NULL,
  `description` text,
  `frequency` varchar(20) NOT NULL,
  `param` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_dashboard_reminders`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_dashboard_widgets`
--

CREATE TABLE `2_dashboard_widgets` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `app` varchar(50) NOT NULL,
  `column_id` int(11) NOT NULL,
  `sort_no` int(11) NOT NULL,
  `collapsed` tinyint(4) NOT NULL,
  `widget` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `param` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=42 ;

--
-- Dumping data for table `2_dashboard_widgets`
--

INSERT INTO `2_dashboard_widgets` VALUES(1, 1, 'AP', 1, 1, 0, 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(2, 1, 'AP', 1, 0, 0, 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(3, 1, 'AP', 2, 1, 0, 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(6, 1, 'AP', 2, 0, 0, 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(7, 1, 'orders', 1, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(9, 1, 'orders', 1, 1, 0, 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(10, 1, 'AP', 1, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(11, 1, 'AP', 2, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(12, 1, 'GL', 2, 1, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(13, 1, 'GL', 2, 0, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(14, 1, 'stock', 1, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(15, 1, 'stock', 0, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(16, 1, 'manuf', 1, 0, 0, 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(17, 1, 'manuf', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(18, 1, 'orders', 2, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(19, 1, 'GL', 2, 2, 0, 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(20, 1, 'GL', 1, 1, 0, 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(21, 1, 'GL', 1, 0, 0, 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(22, 2, 'AP', 1, 1, 0, 'weeklytransport', 'Top 10 Transport Weeks', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;desc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(23, 2, 'AP', 1, 0, 0, 'weeklytransport', 'Weekly Transport', '{&quot;top&quot;:&quot;&quot;,&quot;orderby&quot;:&quot;Week End&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(24, 2, 'AP', 2, 1, 0, 'weeklytransport', 'Lowest weeks transport', '{&quot;top&quot;:&quot;10&quot;,&quot;orderby&quot;:&quot;Gross Transport&quot;,&quot;orderby_seq&quot;:&quot;asc&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(25, 2, 'AP', 2, 0, 0, 'dailytransport', 'Daily Transport', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;dm.payment_terms = -1&quot;,&quot;graph_type&quot;:&quot;LineChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(26, 2, 'orders', 1, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;10&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(27, 2, 'orders', 1, 1, 0, 'transportinvoices', 'Overdue invoices', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(28, 2, 'AP', 1, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;Table&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(29, 2, 'AP', 2, 0, 0, 'suppliers', 'Top 10 Suppliers', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(30, 2, 'GL', 2, 1, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(31, 2, 'GL', 2, 0, 0, 'glreturn', 'Return', '{&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(32, 2, 'stock', 1, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(33, 2, 'stock', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(34, 2, 'manuf', 1, 0, 0, 'items', 'Top 10 items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(35, 2, 'manuf', 2, 0, 0, 'items', 'Top 10 Items', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;manuf&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(36, 2, 'orders', 2, 0, 0, 'consignors', 'Top 10 Consignors', '{&quot;top&quot;:&quot;&quot;,&quot;data_filter&quot;:&quot;&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(37, 2, 'GL', 2, 2, 0, 'bankbalances', 'Bank Balances', '{&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(38, 2, 'GL', 1, 1, 0, 'dailybankbalances', 'Daily Current Account Balance', '{&quot;days_past&quot;:&quot;&quot;,&quot;days_future&quot;:&quot;&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;graph_type&quot;:&quot;ColumnChart&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(39, 2, 'GL', 1, 0, 0, 'banktransactions', 'Current Account Transactions', '{&quot;days_past&quot;:&quot;15&quot;,&quot;days_future&quot;:&quot;15&quot;,&quot;bank_act&quot;:&quot;0&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(40, 1, 'stock', 1, 1, 0, 'odometer', 'Odometer Readings', '{&quot;top&quot;:&quot;20&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;Table&quot;,&quot;data_filter&quot;:&quot;&quot;}');
INSERT INTO `2_dashboard_widgets` VALUES(41, 1, 'manuf', 0, 0, 0, 'maintenance', '', '{&quot;top&quot;:&quot;&quot;,&quot;item_type&quot;:&quot;stock&quot;,&quot;graph_type&quot;:&quot;PieChart&quot;,&quot;data_filter&quot;:&quot;&quot;}');

-- --------------------------------------------------------

--
-- Table structure for table `2_dimensions`
--

CREATE TABLE `2_dimensions` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(60) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `type_` tinyint(1) NOT NULL default '1',
  `closed` tinyint(1) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `date_` (`date_`),
  KEY `due_date` (`due_date`),
  KEY `type_` (`type_`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_dimensions`
--

INSERT INTO `2_dimensions` VALUES(1, '1', 'Support', 1, 0, '2009-06-21', '2015-07-11');
INSERT INTO `2_dimensions` VALUES(2, '2', 'Development', 1, 0, '2009-06-21', '2015-07-11');

-- --------------------------------------------------------

--
-- Table structure for table `2_drivers_master`
--

CREATE TABLE `2_drivers_master` (
  `driver_no` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `driver_birth_date` date NOT NULL,
  `hired_on` date NOT NULL,
  `licence_no` varchar(100) NOT NULL,
  `health_exam_ref` varchar(100) NOT NULL,
  `date_of_checkup` date NOT NULL,
  `driver_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `curr_code` char(3) NOT NULL default '',
  `payment_terms` int(11) default NULL,
  `rate` decimal(10,2) NOT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`driver_no`),
  UNIQUE KEY `driver_ref` (`driver_ref`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `2_drivers_master`
--

INSERT INTO `2_drivers_master` VALUES(1, 'Beefeater Ltd.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Beefeater', 'Addr 1\nAddr 2\nAddr 3', 'GBP', 3, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(2, 'Ghostbusters Corp.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Ghostbusters', 'Address 1\nAddress 2\nAddress 3', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(3, 'Brezan', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Brezan', 'Address 1\nAddress 2\nAddress 3', 'EUR', 3, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(4, 'asd', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'sad', NULL, '', NULL, 0.00, 'USD', 0);
INSERT INTO `2_drivers_master` VALUES(5, 'dsa', '0000-00-00', '0000-00-00', 'das', '', '0000-00-00', 'dsa', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(6, 'dasdasjadsjads', '0000-00-00', '0000-00-00', 'dsa', '', '0000-00-00', 'Anurodh', 'dsa', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(7, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(8, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sddddddda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(9, 'das', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'dsadsdsashkgdsuhgskd', 'dasa', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(10, 'dsa', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Andhrapradesh', 'das', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(11, 'Avinash', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'Jeengar', 'ddhfsf', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(12, 'Naehhe', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'adasdhhdas', NULL, 'USD', 4, 55.00, '', 1);
INSERT INTO `2_drivers_master` VALUES(13, 'adnannadads', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'dasnands,,nads', 'czx', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_drivers_master` VALUES(14, 'Anurodha', '2014-02-15', '2014-02-15', '', '', '2014-02-15', 'Ahda', 'dafjvafjaf', 'USD', 4, 0.00, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_driver_trans`
--

CREATE TABLE `2_driver_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `driver_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `driver_no` (`driver_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_driver_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_driver_trans_details`
--

CREATE TABLE `2_driver_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `driver_trans_no` int(11) default NULL,
  `driver_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`driver_trans_type`,`driver_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_driver_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_exchange_rates`
--

CREATE TABLE `2_exchange_rates` (
  `id` int(11) NOT NULL auto_increment,
  `curr_code` char(3) NOT NULL default '',
  `rate_buy` double NOT NULL default '0',
  `rate_sell` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `2_exchange_rates`
--

INSERT INTO `2_exchange_rates` VALUES(1, 'DKK', 0.18717252868313, 0.18717252868313, '2009-06-21');
INSERT INTO `2_exchange_rates` VALUES(2, 'GBP', 1.6445729799917, 1.6445729799917, '2009-06-21');
INSERT INTO `2_exchange_rates` VALUES(3, 'EUR', 1.3932, 1.3932, '2009-06-21');
INSERT INTO `2_exchange_rates` VALUES(4, 'GBP', 1.6446, 1.6446, '2013-12-31');
INSERT INTO `2_exchange_rates` VALUES(5, 'EUR', 1.3932, 1.3932, '2013-12-31');

-- --------------------------------------------------------

--
-- Table structure for table `2_fiscal_year`
--

CREATE TABLE `2_fiscal_year` (
  `id` int(11) NOT NULL auto_increment,
  `begin` date default '0000-00-00',
  `end` date default '0000-00-00',
  `closed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `2_fiscal_year`
--

INSERT INTO `2_fiscal_year` VALUES(1, '2008-01-01', '2008-12-31', 1);
INSERT INTO `2_fiscal_year` VALUES(2, '2009-01-01', '2009-12-31', 1);
INSERT INTO `2_fiscal_year` VALUES(3, '2010-01-01', '2010-12-31', 0);
INSERT INTO `2_fiscal_year` VALUES(4, '2011-01-01', '2011-12-31', 0);
INSERT INTO `2_fiscal_year` VALUES(5, '2012-01-01', '2012-12-31', 0);
INSERT INTO `2_fiscal_year` VALUES(6, '2013-01-01', '2013-12-31', 0);
INSERT INTO `2_fiscal_year` VALUES(7, '2014-01-01', '2014-12-31', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_fuel_types`
--

CREATE TABLE `2_fuel_types` (
  `fuel_type_code` int(11) NOT NULL auto_increment,
  `fuel_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`fuel_type_code`),
  UNIQUE KEY `description` (`fuel_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `2_fuel_types`
--

INSERT INTO `2_fuel_types` VALUES(5, 'sdaads', 0);
INSERT INTO `2_fuel_types` VALUES(6, 'Gasoline', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_fuel_weight_types`
--

CREATE TABLE `2_fuel_weight_types` (
  `fuel_weight_type_code` int(11) NOT NULL auto_increment,
  `fuel_weight_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`fuel_weight_type_code`),
  UNIQUE KEY `description` (`fuel_weight_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `2_fuel_weight_types`
--

INSERT INTO `2_fuel_weight_types` VALUES(5, 'dsads', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_gl_trans`
--

CREATE TABLE `2_gl_trans` (
  `counter` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL default '0',
  `type_no` bigint(16) NOT NULL default '1',
  `tran_date` date NOT NULL default '0000-00-00',
  `account` varchar(15) NOT NULL default '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL default '0',
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `person_type_id` int(11) default NULL,
  `person_id` tinyblob,
  PRIMARY KEY  (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `dimension_id` (`dimension_id`),
  KEY `dimension2_id` (`dimension2_id`),
  KEY `tran_date` (`tran_date`),
  KEY `account_and_tran_date` (`account`,`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_gl_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_grn_batch`
--

CREATE TABLE `2_grn_batch` (
  `id` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `purch_order_no` int(11) default NULL,
  `reference` varchar(60) NOT NULL default '',
  `delivery_date` date NOT NULL default '0000-00-00',
  `loc_code` varchar(5) default NULL,
  PRIMARY KEY  (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_grn_batch`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_grn_items`
--

CREATE TABLE `2_grn_items` (
  `id` int(11) NOT NULL auto_increment,
  `grn_batch_id` int(11) default NULL,
  `po_detail_item` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_recd` double NOT NULL default '0',
  `quantity_inv` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_grn_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_groups`
--

CREATE TABLE `2_groups` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_groups`
--

INSERT INTO `2_groups` VALUES(1, 'Small', 0);
INSERT INTO `2_groups` VALUES(2, 'Medium', 0);
INSERT INTO `2_groups` VALUES(3, 'Large', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_item_codes`
--

CREATE TABLE `2_item_codes` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `item_code` varchar(20) NOT NULL,
  `stock_id` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL default '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL default '1',
  `is_foreign` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_item_codes`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_item_tax_types`
--

CREATE TABLE `2_item_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `exempt` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `2_item_tax_types`
--

INSERT INTO `2_item_tax_types` VALUES(1, 'Regular', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_item_tax_type_exemptions`
--

CREATE TABLE `2_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_item_tax_type_exemptions`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_item_units`
--

CREATE TABLE `2_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_item_units`
--

INSERT INTO `2_item_units` VALUES('ea.', 'Each', 0, 0);
INSERT INTO `2_item_units` VALUES('hrs', 'Hours', 1, 0);
INSERT INTO `2_item_units` VALUES('Ltr', 'Ltr', 0, 0);
INSERT INTO `2_item_units` VALUES('Gallons', 'Gallons', -1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_locations`
--

CREATE TABLE `2_locations` (
  `loc_code` varchar(5) NOT NULL default '',
  `location_name` varchar(60) NOT NULL default '',
  `delivery_address` tinytext NOT NULL,
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `fax` varchar(30) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `contact` varchar(30) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_locations`
--

INSERT INTO `2_locations` VALUES('DEF', 'Default', 'Delivery 1\nDelivery 2\nDelivery 3', '', '', '', '', '', 0);
INSERT INTO `2_locations` VALUES('BHL', 'Bhilwara', '', '', '', '', '', '', 0);
INSERT INTO `2_locations` VALUES('NAAS', 'dsas', 'asd', '', '', '', '', 'asdads', 0);
INSERT INTO `2_locations` VALUES('PBOS', 'JFS', 'SDHS', 'DSJ', 'JSDHS', '', '', 'SHD', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_loc_stock`
--

CREATE TABLE `2_loc_stock` (
  `loc_code` char(5) NOT NULL default '',
  `stock_id` char(20) NOT NULL default '',
  `reorder_level` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_loc_stock`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_movement_types`
--

CREATE TABLE `2_movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `2_movement_types`
--

INSERT INTO `2_movement_types` VALUES(1, 'Adjustment', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_odometer_data`
--

CREATE TABLE `2_odometer_data` (
  `odometer_id` int(11) NOT NULL auto_increment,
  `category` int(11) NOT NULL,
  `stock_id` char(20) NOT NULL default '',
  `odometer_reading` int(50) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `location_id` varchar(11) NOT NULL,
  `log_description` varchar(200) NOT NULL,
  `accident_id` int(10) NOT NULL,
  `wo_id` int(10) NOT NULL,
  PRIMARY KEY  (`odometer_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_odometer_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_odometer_types`
--

CREATE TABLE `2_odometer_types` (
  `odometer_type_code` int(11) NOT NULL auto_increment,
  `odometer_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`odometer_type_code`),
  UNIQUE KEY `description` (`odometer_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_odometer_types`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_part`
--

CREATE TABLE `2_part` (
  `part_code` int(11) NOT NULL auto_increment,
  `part_name` char(60) NOT NULL default '',
  `part_type_desc` varchar(100) default NULL,
  `part_no` varchar(100) NOT NULL default '',
  `part_price` decimal(10,2) NOT NULL default '0.00',
  `part_price_date` date NOT NULL,
  `vendor_ref` varchar(100) default NULL,
  `part_manufacturer` varchar(200) default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`part_code`),
  UNIQUE KEY `part_name` (`part_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_part`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_part_types`
--

CREATE TABLE `2_part_types` (
  `part_type_code` int(11) NOT NULL auto_increment,
  `part_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`part_type_code`),
  UNIQUE KEY `description` (`part_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_part_types`
--

INSERT INTO `2_part_types` VALUES(2, 'dasbkdsa', 0);
INSERT INTO `2_part_types` VALUES(3, 'dddd', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_payment_terms`
--

CREATE TABLE `2_payment_terms` (
  `terms_indicator` int(11) NOT NULL auto_increment,
  `terms` char(80) NOT NULL default '',
  `days_before_due` smallint(6) NOT NULL default '0',
  `day_in_following_month` smallint(6) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `2_payment_terms`
--

INSERT INTO `2_payment_terms` VALUES(1, 'Due 15th Of the Following Month', 0, 17, 0);
INSERT INTO `2_payment_terms` VALUES(2, 'Due By End Of The Following Month', 0, 30, 0);
INSERT INTO `2_payment_terms` VALUES(3, 'Payment due within 10 days', 10, 0, 0);
INSERT INTO `2_payment_terms` VALUES(4, 'Cash Only', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_prices`
--

CREATE TABLE `2_prices` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(20) NOT NULL default '',
  `transport_type_id` int(11) NOT NULL default '0',
  `curr_abrev` char(3) NOT NULL default '',
  `price` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `price` (`stock_id`,`transport_type_id`,`curr_abrev`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `2_prices`
--

INSERT INTO `2_prices` VALUES(1, '3400', 1, 'USD', 100);
INSERT INTO `2_prices` VALUES(2, '102', 1, 'USD', 50);
INSERT INTO `2_prices` VALUES(3, '103', 1, 'USD', 55);
INSERT INTO `2_prices` VALUES(4, '104', 1, 'USD', 60);

-- --------------------------------------------------------

--
-- Table structure for table `2_printers`
--

CREATE TABLE `2_printers` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_printers`
--

INSERT INTO `2_printers` VALUES(1, 'QL500', 'Label printer', 'QL500', 'server', 127, 20);
INSERT INTO `2_printers` VALUES(2, 'Samsung', 'Main network printer', 'scx4521F', 'server', 515, 5);
INSERT INTO `2_printers` VALUES(3, 'Local', 'Local print server at user IP', 'lp', '', 515, 10);

-- --------------------------------------------------------

--
-- Table structure for table `2_print_profiles`
--

CREATE TABLE `2_print_profiles` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) default NULL,
  `printer` tinyint(3) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `2_print_profiles`
--

INSERT INTO `2_print_profiles` VALUES(1, 'Out of office', NULL, 0);
INSERT INTO `2_print_profiles` VALUES(2, 'Sales Department', NULL, 0);
INSERT INTO `2_print_profiles` VALUES(3, 'Central', NULL, 2);
INSERT INTO `2_print_profiles` VALUES(4, 'Sales Department', '104', 2);
INSERT INTO `2_print_profiles` VALUES(5, 'Sales Department', '105', 2);
INSERT INTO `2_print_profiles` VALUES(6, 'Sales Department', '107', 2);
INSERT INTO `2_print_profiles` VALUES(7, 'Sales Department', '109', 2);
INSERT INTO `2_print_profiles` VALUES(8, 'Sales Department', '110', 2);
INSERT INTO `2_print_profiles` VALUES(9, 'Sales Department', '201', 2);

-- --------------------------------------------------------

--
-- Table structure for table `2_purch_data`
--

CREATE TABLE `2_purch_data` (
  `supplier_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `price` double NOT NULL default '0',
  `suppliers_uom` char(50) NOT NULL default '',
  `conversion_factor` double NOT NULL default '1',
  `supplier_description` char(50) NOT NULL default '',
  PRIMARY KEY  (`supplier_id`,`stock_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_purch_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_purch_orders`
--

CREATE TABLE `2_purch_orders` (
  `order_no` int(11) NOT NULL auto_increment,
  `supplier_id` int(11) NOT NULL default '0',
  `comments` tinytext,
  `ord_date` date NOT NULL default '0000-00-00',
  `reference` tinytext NOT NULL,
  `requisition_no` tinytext,
  `into_stock_location` varchar(5) NOT NULL default '',
  `delivery_address` tinytext NOT NULL,
  `total` double NOT NULL default '0',
  `tax_included` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`order_no`),
  KEY `ord_date` (`ord_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_purch_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_purch_order_details`
--

CREATE TABLE `2_purch_order_details` (
  `po_detail_item` int(11) NOT NULL auto_increment,
  `order_no` int(11) NOT NULL default '0',
  `item_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `delivery_date` date NOT NULL default '0000-00-00',
  `qty_invoiced` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `act_price` double NOT NULL default '0',
  `std_cost_unit` double NOT NULL default '0',
  `quantity_ordered` double NOT NULL default '0',
  `quantity_received` double NOT NULL default '0',
  PRIMARY KEY  (`po_detail_item`),
  KEY `order` (`order_no`,`po_detail_item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_purch_order_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_quick_entries`
--

CREATE TABLE `2_quick_entries` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `type` tinyint(1) NOT NULL default '0',
  `description` varchar(60) NOT NULL,
  `base_amount` double NOT NULL default '0',
  `base_desc` varchar(60) default NULL,
  `bal_type` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_quick_entries`
--

INSERT INTO `2_quick_entries` VALUES(1, 1, 'Maintenance', 0, 'Amount', 0);
INSERT INTO `2_quick_entries` VALUES(2, 4, 'Phone', 0, 'Amount', 0);
INSERT INTO `2_quick_entries` VALUES(3, 2, 'Cash Sales', 0, 'Amount', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_quick_entry_lines`
--

CREATE TABLE `2_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double default '0',
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL default '',
  `dimension_id` smallint(6) unsigned default NULL,
  `dimension2_id` smallint(6) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `qid` (`qid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `2_quick_entry_lines`
--

INSERT INTO `2_quick_entry_lines` VALUES(1, 1, 0, 't-', '1', 0, 0);
INSERT INTO `2_quick_entry_lines` VALUES(2, 2, 0, 't-', '1', 0, 0);
INSERT INTO `2_quick_entry_lines` VALUES(3, 3, 0, 't-', '1', 0, 0);
INSERT INTO `2_quick_entry_lines` VALUES(4, 3, 0, '=', '4010', 0, 0);
INSERT INTO `2_quick_entry_lines` VALUES(5, 1, 0, '=', '5765', 0, 0);
INSERT INTO `2_quick_entry_lines` VALUES(6, 2, 0, '=', '5780', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_recurrent_invoices`
--

CREATE TABLE `2_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `order_no` int(11) unsigned NOT NULL,
  `consignor_no` int(11) unsigned default NULL,
  `consignee_no` int(11) default NULL,
  `group_no` smallint(6) unsigned default NULL,
  `days` int(11) NOT NULL default '0',
  `monthly` int(11) NOT NULL default '0',
  `begin` date NOT NULL default '0000-00-00',
  `end` date NOT NULL default '0000-00-00',
  `last_sent` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_recurrent_invoices`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_refs`
--

CREATE TABLE `2_refs` (
  `id` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_refs`
--

INSERT INTO `2_refs` VALUES(18, 0, '1');
INSERT INTO `2_refs` VALUES(19, 0, '2');
INSERT INTO `2_refs` VALUES(21, 0, '3');
INSERT INTO `2_refs` VALUES(22, 0, '4');
INSERT INTO `2_refs` VALUES(23, 0, '5');
INSERT INTO `2_refs` VALUES(24, 0, '6');
INSERT INTO `2_refs` VALUES(1, 0, '7');
INSERT INTO `2_refs` VALUES(2, 0, '8');
INSERT INTO `2_refs` VALUES(3, 0, '9');
INSERT INTO `2_refs` VALUES(9, 1, '2');
INSERT INTO `2_refs` VALUES(6, 2, '2');
INSERT INTO `2_refs` VALUES(1, 4, '3');
INSERT INTO `2_refs` VALUES(26, 10, '10');
INSERT INTO `2_refs` VALUES(27, 10, '11');
INSERT INTO `2_refs` VALUES(21, 10, '32');
INSERT INTO `2_refs` VALUES(22, 10, '33');
INSERT INTO `2_refs` VALUES(17, 10, '50');
INSERT INTO `2_refs` VALUES(18, 10, '51');
INSERT INTO `2_refs` VALUES(19, 10, '52');
INSERT INTO `2_refs` VALUES(20, 10, '53');
INSERT INTO `2_refs` VALUES(23, 10, '7');
INSERT INTO `2_refs` VALUES(13, 10, '70');
INSERT INTO `2_refs` VALUES(14, 10, '71');
INSERT INTO `2_refs` VALUES(15, 10, '72');
INSERT INTO `2_refs` VALUES(16, 10, '73');
INSERT INTO `2_refs` VALUES(24, 10, '8');
INSERT INTO `2_refs` VALUES(4, 10, '81');
INSERT INTO `2_refs` VALUES(5, 10, '82');
INSERT INTO `2_refs` VALUES(6, 10, '83');
INSERT INTO `2_refs` VALUES(7, 10, '84');
INSERT INTO `2_refs` VALUES(8, 10, '85');
INSERT INTO `2_refs` VALUES(9, 10, '86');
INSERT INTO `2_refs` VALUES(10, 10, '87');
INSERT INTO `2_refs` VALUES(11, 10, '88');
INSERT INTO `2_refs` VALUES(12, 10, '89');
INSERT INTO `2_refs` VALUES(25, 10, '9');
INSERT INTO `2_refs` VALUES(3, 10, '96');
INSERT INTO `2_refs` VALUES(1, 10, '97');
INSERT INTO `2_refs` VALUES(2, 10, '98');
INSERT INTO `2_refs` VALUES(4, 11, '2');
INSERT INTO `2_refs` VALUES(3, 11, '5');
INSERT INTO `2_refs` VALUES(1, 11, '8');
INSERT INTO `2_refs` VALUES(2, 11, '9');
INSERT INTO `2_refs` VALUES(13, 12, '26');
INSERT INTO `2_refs` VALUES(14, 12, '27');
INSERT INTO `2_refs` VALUES(15, 12, '28');
INSERT INTO `2_refs` VALUES(16, 12, '29');
INSERT INTO `2_refs` VALUES(4, 12, '37');
INSERT INTO `2_refs` VALUES(5, 12, '38');
INSERT INTO `2_refs` VALUES(6, 12, '39');
INSERT INTO `2_refs` VALUES(7, 12, '40');
INSERT INTO `2_refs` VALUES(8, 12, '41');
INSERT INTO `2_refs` VALUES(9, 12, '42');
INSERT INTO `2_refs` VALUES(10, 12, '43');
INSERT INTO `2_refs` VALUES(11, 12, '44');
INSERT INTO `2_refs` VALUES(12, 12, '45');
INSERT INTO `2_refs` VALUES(3, 12, '52');
INSERT INTO `2_refs` VALUES(1, 12, '53');
INSERT INTO `2_refs` VALUES(2, 12, '54');
INSERT INTO `2_refs` VALUES(22, 13, '16');
INSERT INTO `2_refs` VALUES(24, 13, '17');
INSERT INTO `2_refs` VALUES(25, 13, '18');
INSERT INTO `2_refs` VALUES(26, 13, '19');
INSERT INTO `2_refs` VALUES(28, 13, '20');
INSERT INTO `2_refs` VALUES(4, 13, '26');
INSERT INTO `2_refs` VALUES(5, 13, '27');
INSERT INTO `2_refs` VALUES(6, 13, '28');
INSERT INTO `2_refs` VALUES(7, 13, '29');
INSERT INTO `2_refs` VALUES(8, 13, '30');
INSERT INTO `2_refs` VALUES(9, 13, '31');
INSERT INTO `2_refs` VALUES(10, 13, '32');
INSERT INTO `2_refs` VALUES(11, 13, '33');
INSERT INTO `2_refs` VALUES(12, 13, '34');
INSERT INTO `2_refs` VALUES(13, 13, '35');
INSERT INTO `2_refs` VALUES(14, 13, '36');
INSERT INTO `2_refs` VALUES(1, 13, '37');
INSERT INTO `2_refs` VALUES(2, 13, '38');
INSERT INTO `2_refs` VALUES(3, 13, '39');
INSERT INTO `2_refs` VALUES(15, 13, 'auto');
INSERT INTO `2_refs` VALUES(16, 13, 'auto');
INSERT INTO `2_refs` VALUES(17, 13, 'auto');
INSERT INTO `2_refs` VALUES(18, 13, 'auto');
INSERT INTO `2_refs` VALUES(19, 13, 'auto');
INSERT INTO `2_refs` VALUES(20, 13, 'auto');
INSERT INTO `2_refs` VALUES(21, 13, 'auto');
INSERT INTO `2_refs` VALUES(23, 13, 'auto');
INSERT INTO `2_refs` VALUES(27, 13, 'auto');
INSERT INTO `2_refs` VALUES(29, 13, 'auto');
INSERT INTO `2_refs` VALUES(3, 16, '4');
INSERT INTO `2_refs` VALUES(2, 16, '8');
INSERT INTO `2_refs` VALUES(1, 16, '9');
INSERT INTO `2_refs` VALUES(1, 17, '1');
INSERT INTO `2_refs` VALUES(2, 17, '2');
INSERT INTO `2_refs` VALUES(3, 17, '3');
INSERT INTO `2_refs` VALUES(4, 17, '4');
INSERT INTO `2_refs` VALUES(3, 18, '3');
INSERT INTO `2_refs` VALUES(5, 18, '4');
INSERT INTO `2_refs` VALUES(7, 18, '5');
INSERT INTO `2_refs` VALUES(9, 18, '6');
INSERT INTO `2_refs` VALUES(1, 18, 'auto');
INSERT INTO `2_refs` VALUES(2, 18, 'auto');
INSERT INTO `2_refs` VALUES(4, 18, 'auto');
INSERT INTO `2_refs` VALUES(6, 18, 'auto');
INSERT INTO `2_refs` VALUES(8, 18, 'auto');
INSERT INTO `2_refs` VALUES(10, 18, 'auto');
INSERT INTO `2_refs` VALUES(11, 18, 'auto');
INSERT INTO `2_refs` VALUES(12, 18, 'auto');
INSERT INTO `2_refs` VALUES(13, 18, 'auto');
INSERT INTO `2_refs` VALUES(14, 18, 'auto');
INSERT INTO `2_refs` VALUES(16, 20, '10');
INSERT INTO `2_refs` VALUES(2, 20, '13');
INSERT INTO `2_refs` VALUES(1, 20, '14');
INSERT INTO `2_refs` VALUES(9, 20, '3');
INSERT INTO `2_refs` VALUES(10, 20, '4');
INSERT INTO `2_refs` VALUES(11, 20, '5');
INSERT INTO `2_refs` VALUES(12, 20, '6');
INSERT INTO `2_refs` VALUES(13, 20, '7');
INSERT INTO `2_refs` VALUES(14, 20, '8');
INSERT INTO `2_refs` VALUES(15, 20, '9');
INSERT INTO `2_refs` VALUES(5, 22, '2');
INSERT INTO `2_refs` VALUES(6, 22, '3');
INSERT INTO `2_refs` VALUES(7, 22, '4');
INSERT INTO `2_refs` VALUES(3, 25, '3');
INSERT INTO `2_refs` VALUES(1, 25, 'auto');
INSERT INTO `2_refs` VALUES(2, 25, 'auto');
INSERT INTO `2_refs` VALUES(4, 25, 'auto');
INSERT INTO `2_refs` VALUES(5, 25, 'auto');
INSERT INTO `2_refs` VALUES(6, 25, 'auto');
INSERT INTO `2_refs` VALUES(7, 25, 'auto');
INSERT INTO `2_refs` VALUES(8, 25, 'auto');
INSERT INTO `2_refs` VALUES(9, 25, 'auto');
INSERT INTO `2_refs` VALUES(10, 25, 'auto');
INSERT INTO `2_refs` VALUES(11, 25, 'auto');
INSERT INTO `2_refs` VALUES(10, 26, '10');
INSERT INTO `2_refs` VALUES(11, 26, '11');
INSERT INTO `2_refs` VALUES(12, 26, '12');
INSERT INTO `2_refs` VALUES(13, 26, '13');
INSERT INTO `2_refs` VALUES(14, 26, '14');
INSERT INTO `2_refs` VALUES(15, 26, '15');
INSERT INTO `2_refs` VALUES(16, 26, '16');
INSERT INTO `2_refs` VALUES(17, 26, '17');
INSERT INTO `2_refs` VALUES(18, 26, '18');
INSERT INTO `2_refs` VALUES(19, 26, '19');
INSERT INTO `2_refs` VALUES(20, 26, '20');
INSERT INTO `2_refs` VALUES(21, 26, '21');
INSERT INTO `2_refs` VALUES(22, 26, '22');
INSERT INTO `2_refs` VALUES(23, 26, '23');
INSERT INTO `2_refs` VALUES(24, 26, '24');
INSERT INTO `2_refs` VALUES(25, 26, '25');
INSERT INTO `2_refs` VALUES(28, 26, '26');
INSERT INTO `2_refs` VALUES(32, 26, '27');
INSERT INTO `2_refs` VALUES(34, 26, '28');
INSERT INTO `2_refs` VALUES(36, 26, '29');
INSERT INTO `2_refs` VALUES(33, 26, '298');
INSERT INTO `2_refs` VALUES(37, 26, '30');
INSERT INTO `2_refs` VALUES(39, 26, '31');
INSERT INTO `2_refs` VALUES(40, 26, '32');
INSERT INTO `2_refs` VALUES(41, 26, '33');
INSERT INTO `2_refs` VALUES(42, 26, '34');
INSERT INTO `2_refs` VALUES(43, 26, '35');
INSERT INTO `2_refs` VALUES(44, 26, '36');
INSERT INTO `2_refs` VALUES(45, 26, '37');
INSERT INTO `2_refs` VALUES(46, 26, '38');
INSERT INTO `2_refs` VALUES(35, 26, '39');
INSERT INTO `2_refs` VALUES(47, 26, '39');
INSERT INTO `2_refs` VALUES(48, 26, '40');
INSERT INTO `2_refs` VALUES(49, 26, '41');
INSERT INTO `2_refs` VALUES(50, 26, '42');
INSERT INTO `2_refs` VALUES(51, 26, '43');
INSERT INTO `2_refs` VALUES(52, 26, '44');
INSERT INTO `2_refs` VALUES(29, 26, '45');
INSERT INTO `2_refs` VALUES(53, 26, '45');
INSERT INTO `2_refs` VALUES(54, 26, '46');
INSERT INTO `2_refs` VALUES(55, 26, '47');
INSERT INTO `2_refs` VALUES(56, 26, '48');
INSERT INTO `2_refs` VALUES(57, 26, '49');
INSERT INTO `2_refs` VALUES(58, 26, '50');
INSERT INTO `2_refs` VALUES(59, 26, '51');
INSERT INTO `2_refs` VALUES(60, 26, '52');
INSERT INTO `2_refs` VALUES(61, 26, '53');
INSERT INTO `2_refs` VALUES(30, 26, '535');
INSERT INTO `2_refs` VALUES(62, 26, '54');
INSERT INTO `2_refs` VALUES(63, 26, '55');
INSERT INTO `2_refs` VALUES(64, 26, '56');
INSERT INTO `2_refs` VALUES(65, 26, '57');
INSERT INTO `2_refs` VALUES(66, 26, '58');
INSERT INTO `2_refs` VALUES(67, 26, '59');
INSERT INTO `2_refs` VALUES(3, 26, '62');
INSERT INTO `2_refs` VALUES(4, 26, '63');
INSERT INTO `2_refs` VALUES(5, 26, '64');
INSERT INTO `2_refs` VALUES(6, 26, '65');
INSERT INTO `2_refs` VALUES(7, 26, '66');
INSERT INTO `2_refs` VALUES(8, 26, '67');
INSERT INTO `2_refs` VALUES(1, 26, '68');
INSERT INTO `2_refs` VALUES(2, 26, '69');
INSERT INTO `2_refs` VALUES(9, 26, '9');
INSERT INTO `2_refs` VALUES(31, 26, 'rewewr');
INSERT INTO `2_refs` VALUES(1, 28, '1');
INSERT INTO `2_refs` VALUES(2, 28, '2');
INSERT INTO `2_refs` VALUES(2, 29, '2');
INSERT INTO `2_refs` VALUES(29, 30, '24');
INSERT INTO `2_refs` VALUES(31, 30, '25');
INSERT INTO `2_refs` VALUES(6, 30, '39');
INSERT INTO `2_refs` VALUES(7, 30, '40');
INSERT INTO `2_refs` VALUES(8, 30, '41');
INSERT INTO `2_refs` VALUES(9, 30, '42');
INSERT INTO `2_refs` VALUES(10, 30, '43');
INSERT INTO `2_refs` VALUES(12, 30, '44');
INSERT INTO `2_refs` VALUES(13, 30, '45');
INSERT INTO `2_refs` VALUES(14, 30, '46');
INSERT INTO `2_refs` VALUES(15, 30, '47');
INSERT INTO `2_refs` VALUES(16, 30, '48');
INSERT INTO `2_refs` VALUES(1, 30, '57');
INSERT INTO `2_refs` VALUES(2, 30, '58');
INSERT INTO `2_refs` VALUES(3, 30, '59');
INSERT INTO `2_refs` VALUES(4, 30, '60');
INSERT INTO `2_refs` VALUES(5, 30, '61');
INSERT INTO `2_refs` VALUES(11, 30, 'auto');
INSERT INTO `2_refs` VALUES(17, 30, 'auto');
INSERT INTO `2_refs` VALUES(18, 30, 'auto');
INSERT INTO `2_refs` VALUES(19, 30, 'auto');
INSERT INTO `2_refs` VALUES(20, 30, 'auto');
INSERT INTO `2_refs` VALUES(21, 30, 'auto');
INSERT INTO `2_refs` VALUES(22, 30, 'auto');
INSERT INTO `2_refs` VALUES(23, 30, 'auto');
INSERT INTO `2_refs` VALUES(24, 30, 'auto');
INSERT INTO `2_refs` VALUES(25, 30, 'auto');
INSERT INTO `2_refs` VALUES(26, 30, 'auto');
INSERT INTO `2_refs` VALUES(27, 30, 'auto');
INSERT INTO `2_refs` VALUES(28, 30, 'auto');
INSERT INTO `2_refs` VALUES(30, 30, 'auto');
INSERT INTO `2_refs` VALUES(32, 30, 'auto');
INSERT INTO `2_refs` VALUES(1, 32, '41');
INSERT INTO `2_refs` VALUES(2, 32, '42');
INSERT INTO `2_refs` VALUES(3, 32, '43');
INSERT INTO `2_refs` VALUES(4, 32, '44');
INSERT INTO `2_refs` VALUES(5, 32, '45');
INSERT INTO `2_refs` VALUES(6, 32, '46');
INSERT INTO `2_refs` VALUES(7, 32, '47');
INSERT INTO `2_refs` VALUES(8, 32, '48');
INSERT INTO `2_refs` VALUES(9, 32, '49');
INSERT INTO `2_refs` VALUES(10, 32, '50');
INSERT INTO `2_refs` VALUES(11, 32, '51');
INSERT INTO `2_refs` VALUES(13, 32, '53');
INSERT INTO `2_refs` VALUES(2, 33, '12');
INSERT INTO `2_refs` VALUES(3, 33, '13');
INSERT INTO `2_refs` VALUES(5, 33, '3');
INSERT INTO `2_refs` VALUES(6, 33, '44');
INSERT INTO `2_refs` VALUES(7, 33, '45');
INSERT INTO `2_refs` VALUES(8, 33, '46');
INSERT INTO `2_refs` VALUES(10, 33, '48');
INSERT INTO `2_refs` VALUES(11, 33, '49');
INSERT INTO `2_refs` VALUES(4, 33, '5');
INSERT INTO `2_refs` VALUES(12, 33, '50');
INSERT INTO `2_refs` VALUES(13, 33, '51');
INSERT INTO `2_refs` VALUES(14, 33, '52');
INSERT INTO `2_refs` VALUES(15, 33, '53');
INSERT INTO `2_refs` VALUES(16, 33, '54');
INSERT INTO `2_refs` VALUES(17, 33, '55');
INSERT INTO `2_refs` VALUES(18, 33, '56');
INSERT INTO `2_refs` VALUES(19, 33, '57');
INSERT INTO `2_refs` VALUES(20, 33, '58');
INSERT INTO `2_refs` VALUES(21, 33, '59');
INSERT INTO `2_refs` VALUES(22, 33, '60');
INSERT INTO `2_refs` VALUES(23, 33, '61');

-- --------------------------------------------------------

--
-- Table structure for table `2_security_roles`
--

CREATE TABLE `2_security_roles` (
  `id` int(11) NOT NULL auto_increment,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) default NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `2_security_roles`
--

INSERT INTO `2_security_roles` VALUES(1, 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(2, 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128;287744', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3083;3084;3085;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;287844;287845', 0);
INSERT INTO `2_security_roles` VALUES(3, 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873', 0);
INSERT INTO `2_security_roles` VALUES(4, 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '2818;2822;3073;3076;3077;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5889;5890;5891;8193;8194;8450;8451;10753;11009;11010;11012;13313;13315;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(5, 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5640;5640;5889;5890;5891;8193;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(6, 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;2818;2819;2820;2821;2822;2823;3073;3074;3076;3077;3078;3079;3080;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5377;5633;5635;5640;5640;5889;5890;5891;8193;8194;8196;8197;8449;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(7, 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(8, 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;769;770;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5635;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15876;15877;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(9, 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132', 0);
INSERT INTO `2_security_roles` VALUES(10, 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_shippers`
--

CREATE TABLE `2_shippers` (
  `shipper_id` int(11) NOT NULL auto_increment,
  `shipper_name` varchar(60) NOT NULL default '',
  `phone` varchar(30) NOT NULL default '',
  `phone2` varchar(30) NOT NULL default '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_shippers`
--

INSERT INTO `2_shippers` VALUES(1, 'Default', '', '', '', '', 0);
INSERT INTO `2_shippers` VALUES(2, 'Raipur Roadways', '', '', 'Abhishek', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_sql_trail`
--

CREATE TABLE `2_sql_trail` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_sql_trail`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_stock_category`
--

CREATE TABLE `2_stock_category` (
  `category_id` int(11) NOT NULL auto_increment,
  `description` varchar(60) NOT NULL default '',
  `dflt_tax_type` int(11) NOT NULL default '1',
  `dflt_units` varchar(20) NOT NULL default 'each',
  `dflt_mb_flag` char(1) NOT NULL default 'B',
  `dflt_transport_act` varchar(15) NOT NULL default '',
  `dflt_cogs_act` varchar(15) NOT NULL default '',
  `dflt_inventory_act` varchar(15) NOT NULL default '',
  `dflt_adjustment_act` varchar(15) NOT NULL default '',
  `dflt_assembly_act` varchar(15) NOT NULL default '',
  `dflt_dim1` int(11) default NULL,
  `dflt_dim2` int(11) default NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  `dflt_no_sale` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `2_stock_category`
--

INSERT INTO `2_stock_category` VALUES(1, 'Components', 1, 'ea.', 'B', '4010', '5010', '1510', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `2_stock_category` VALUES(2, 'Charges', 1, 'ea.', 'D', '4010', '5010', '1510', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `2_stock_category` VALUES(3, 'Systems', 1, 'ea.', 'M', '4010', '5010', '1510', '5040', '1530', 0, 0, 0, 0);
INSERT INTO `2_stock_category` VALUES(4, 'Services', 1, 'hrs', 'M', '4010', '5010', '5765', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `2_stock_category` VALUES(5, 'Vehicle', 1, 'ea.', 'M', '4430', '5100', '1510', '5040', '1530', 0, 0, 0, 1);
INSERT INTO `2_stock_category` VALUES(6, 'Transportable Items', 1, 'ea.', 'D', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 0);
INSERT INTO `2_stock_category` VALUES(7, 'Fuels', 1, 'Ltr', 'B', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `2_stock_master`
--

CREATE TABLE `2_stock_master` (
  `stock_id` varchar(20) NOT NULL default '',
  `category_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `description` varchar(200) NOT NULL default '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL default 'each',
  `mb_flag` char(1) NOT NULL default 'B',
  `transport_account` varchar(15) NOT NULL default '',
  `cogs_account` varchar(15) NOT NULL default '',
  `inventory_account` varchar(15) NOT NULL default '',
  `adjustment_account` varchar(15) NOT NULL default '',
  `assembly_account` varchar(15) NOT NULL default '',
  `dimension_id` int(11) default NULL,
  `dimension2_id` int(11) default NULL,
  `actual_cost` double NOT NULL default '0',
  `last_cost` double NOT NULL default '0',
  `material_cost` double NOT NULL default '0',
  `labour_cost` double NOT NULL default '0',
  `overhead_cost` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  `no_sale` tinyint(1) NOT NULL default '0',
  `editable` tinyint(1) NOT NULL default '0',
  `vehicle_init_odometer` decimal(10,2) NOT NULL,
  `vehicle_warranty_odometer` decimal(10,2) NOT NULL,
  `vehicle_number_plate` varchar(20) NOT NULL default '',
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
  PRIMARY KEY  (`stock_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_stock_master`
--

INSERT INTO `2_stock_master` VALUES('GJSDJS', 5, 1, 'HFSHF', 'HFHS', 'ea.', 'M', '4430', '5100', '1510', '5040', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0.00, 'HFSHF', '', '', '', '', 0, '', '', '', '', '2014-01-25', '2014-01-25', '', '', '2014-01-25', '2014-01-25', '', '2014-01-25', '2014-01-25', '', 0.00, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `2_stock_master` VALUES('Marbles', 6, 1, 'Marbles', '', 'ea.', 'D', '4430', '5100', '1520', '5040', '1530', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00, 0.00, '', '', '', '', '', 0, '', '', '', '', '0000-00-00', '0000-00-00', '', '', '0000-00-00', '0000-00-00', '', '0000-00-00', '0000-00-00', '', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_stock_moves`
--

CREATE TABLE `2_stock_moves` (
  `trans_id` int(11) NOT NULL auto_increment,
  `trans_no` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `type` smallint(6) NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `person_id` int(11) default NULL,
  `price` double NOT NULL default '0',
  `reference` char(40) NOT NULL default '',
  `qty` double NOT NULL default '1',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`trans_id`),
  KEY `type` (`type`,`trans_no`),
  KEY `Move` (`stock_id`,`loc_code`,`tran_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `2_stock_moves`
--

INSERT INTO `2_stock_moves` VALUES(1, 0, 'GJSDJS', 0, 'BHL', '2014-01-25', NULL, 0, 'auto', 1, 0, 0, 1);
INSERT INTO `2_stock_moves` VALUES(3, 1, 'Marbles', 13, 'DEF', '2014-01-25', 0, 120, '37', -1, 0, 0, 1);
INSERT INTO `2_stock_moves` VALUES(4, 1, 'GJSDJS', 16, 'BHL', '2014-01-25', 1, 0, '9', -1, 0, 0, 1);
INSERT INTO `2_stock_moves` VALUES(5, 1, 'GJSDJS', 16, 'DEF', '2014-01-25', 1, 0, '9', 1, 0, 0, 1);
INSERT INTO `2_stock_moves` VALUES(6, 2, 'Marbles', 13, 'DEF', '2014-01-26', 0, 0, '38', -1, 0, 0, 1);
INSERT INTO `2_stock_moves` VALUES(7, 3, 'Marbles', 13, 'DEF', '2014-01-26', 0, 0, '39', -1, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `2_suppliers`
--

CREATE TABLE `2_suppliers` (
  `supplier_id` int(11) NOT NULL auto_increment,
  `supp_name` varchar(60) NOT NULL default '',
  `supp_ref` varchar(30) NOT NULL default '',
  `address` tinytext NOT NULL,
  `supp_address` tinytext NOT NULL,
  `gst_no` varchar(25) NOT NULL default '',
  `contact` varchar(60) NOT NULL default '',
  `supp_account_no` varchar(40) NOT NULL default '',
  `website` varchar(100) NOT NULL default '',
  `bank_account` varchar(60) NOT NULL default '',
  `curr_code` char(3) default NULL,
  `payment_terms` int(11) default NULL,
  `tax_included` tinyint(1) NOT NULL default '0',
  `dimension_id` int(11) default '0',
  `dimension2_id` int(11) default '0',
  `tax_group_id` int(11) default NULL,
  `credit_limit` double NOT NULL default '0',
  `purchase_account` varchar(15) NOT NULL default '',
  `payable_account` varchar(15) NOT NULL default '',
  `payment_discount_account` varchar(15) NOT NULL default '',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_suppliers`
--

INSERT INTO `2_suppliers` VALUES(1, 'Junk Beer ApS', 'Junk Beer', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '123456', 'Contact', '111', '', '', 'INR', 3, 0, 1, 0, 2, 1000, '', '2100', '5060', 'A supplier with junk beers.', 0);
INSERT INTO `2_suppliers` VALUES(2, 'Lucky Luke Inc.', 'Lucky Luke', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '654321', 'Luke', '333', '', '', 'INR', 3, 0, 0, 0, 1, 500, '', '2100', '5060', '', 0);
INSERT INTO `2_suppliers` VALUES(3, 'Money Makers Ltd.', 'Money Makers', 'Mailing 1\nMailing 2\nMailing 3', 'Address 1\nAddress 2\nAddress 3', '987654', 'Makers', '222', '', '', 'INR', 3, 0, 0, 0, 2, 300, '', '2100', '5060', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_supp_allocations`
--

CREATE TABLE `2_supp_allocations` (
  `id` int(11) NOT NULL auto_increment,
  `amt` double unsigned default NULL,
  `date_alloc` date NOT NULL default '0000-00-00',
  `trans_no_from` int(11) default NULL,
  `trans_type_from` int(11) default NULL,
  `trans_no_to` int(11) default NULL,
  `trans_type_to` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_supp_allocations`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_supp_invoice_items`
--

CREATE TABLE `2_supp_invoice_items` (
  `id` int(11) NOT NULL auto_increment,
  `supp_trans_no` int(11) default NULL,
  `supp_trans_type` int(11) default NULL,
  `gl_code` varchar(15) NOT NULL default '',
  `grn_item_id` int(11) default NULL,
  `po_detail_item_id` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `quantity` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `memo_` tinytext,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`supp_trans_type`,`supp_trans_no`,`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_supp_invoice_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_supp_trans`
--

CREATE TABLE `2_supp_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `supplier_id` int(11) unsigned default NULL,
  `reference` tinytext NOT NULL,
  `supp_reference` varchar(60) NOT NULL default '',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `ov_amount` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `alloc` double NOT NULL default '0',
  `tax_included` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `supplier_id` (`supplier_id`),
  KEY `SupplierID_2` (`supplier_id`,`supp_reference`),
  KEY `type` (`type`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_supp_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_sys_prefs`
--

CREATE TABLE `2_sys_prefs` (
  `name` varchar(35) NOT NULL default '',
  `category` varchar(30) default NULL,
  `type` varchar(20) NOT NULL default '',
  `length` smallint(6) default NULL,
  `value` tinytext,
  PRIMARY KEY  (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_sys_prefs`
--

INSERT INTO `2_sys_prefs` VALUES('coy_name', 'setup.company', 'varchar', 60, 'admin');
INSERT INTO `2_sys_prefs` VALUES('gst_no', 'setup.company', 'varchar', 25, '9876543');
INSERT INTO `2_sys_prefs` VALUES('coy_no', 'setup.company', 'varchar', 25, '123456789');
INSERT INTO `2_sys_prefs` VALUES('tax_prd', 'setup.company', 'int', 11, '1');
INSERT INTO `2_sys_prefs` VALUES('tax_last', 'setup.company', 'int', 11, '1');
INSERT INTO `2_sys_prefs` VALUES('postal_address', 'setup.company', 'tinytext', 0, 'Address 1\r\nAddress 2\r\nAddress 3');
INSERT INTO `2_sys_prefs` VALUES('phone', 'setup.company', 'varchar', 30, '(222) 111.222.333');
INSERT INTO `2_sys_prefs` VALUES('fax', 'setup.company', 'varchar', 30, '');
INSERT INTO `2_sys_prefs` VALUES('email', 'setup.company', 'varchar', 100, 'delta@delta.com');
INSERT INTO `2_sys_prefs` VALUES('coy_logo', 'setup.company', 'varchar', 100, 'logo_frontaccounting.jpg');
INSERT INTO `2_sys_prefs` VALUES('domicile', 'setup.company', 'varchar', 55, '');
INSERT INTO `2_sys_prefs` VALUES('curr_default', 'setup.company', 'char', 3, 'INR');
INSERT INTO `2_sys_prefs` VALUES('use_dimension', 'setup.company', 'tinyint', 1, '1');
INSERT INTO `2_sys_prefs` VALUES('f_year', 'setup.company', 'int', 11, '7');
INSERT INTO `2_sys_prefs` VALUES('no_item_list', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `2_sys_prefs` VALUES('no_consignor_list', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `2_sys_prefs` VALUES('no_supplier_list', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `2_sys_prefs` VALUES('base_transport', 'setup.company', 'int', 11, '0');
INSERT INTO `2_sys_prefs` VALUES('time_zone', 'setup.company', 'tinyint', 1, '0');
INSERT INTO `2_sys_prefs` VALUES('add_pct', 'setup.company', 'int', 5, '-1');
INSERT INTO `2_sys_prefs` VALUES('round_to', 'setup.company', 'int', 5, '1');
INSERT INTO `2_sys_prefs` VALUES('login_tout', 'setup.company', 'smallint', 6, '600');
INSERT INTO `2_sys_prefs` VALUES('past_due_days', 'glsetup.general', 'int', 11, '30');
INSERT INTO `2_sys_prefs` VALUES('profit_loss_year_act', 'glsetup.general', 'varchar', 15, '9990');
INSERT INTO `2_sys_prefs` VALUES('retained_earnings_act', 'glsetup.general', 'varchar', 15, '3590');
INSERT INTO `2_sys_prefs` VALUES('bank_charge_act', 'glsetup.general', 'varchar', 15, '5690');
INSERT INTO `2_sys_prefs` VALUES('exchange_diff_act', 'glsetup.general', 'varchar', 15, '4450');
INSERT INTO `2_sys_prefs` VALUES('default_credit_limit', 'glsetup.consignor', 'int', 11, '1000');
INSERT INTO `2_sys_prefs` VALUES('accumulate_shipping', 'glsetup.consignor', 'tinyint', 1, '1');
INSERT INTO `2_sys_prefs` VALUES('legal_text', 'glsetup.consignor', 'tinytext', 0, '');
INSERT INTO `2_sys_prefs` VALUES('freight_act', 'glsetup.consignor', 'varchar', 15, '4430');
INSERT INTO `2_sys_prefs` VALUES('consignors_act', 'glsetup.transport', 'varchar', 15, '1200');
INSERT INTO `2_sys_prefs` VALUES('default_transport_act', 'glsetup.transport', 'varchar', 15, '4430');
INSERT INTO `2_sys_prefs` VALUES('default_transport_discount_act', 'glsetup.transport', 'varchar', 15, '4510');
INSERT INTO `2_sys_prefs` VALUES('default_prompt_payment_act', 'glsetup.transport', 'varchar', 15, '4500');
INSERT INTO `2_sys_prefs` VALUES('default_delivery_required', 'glsetup.transport', 'smallint', 6, '1');
INSERT INTO `2_sys_prefs` VALUES('default_dim_required', 'glsetup.dims', 'int', 11, '20');
INSERT INTO `2_sys_prefs` VALUES('pyt_discount_act', 'glsetup.purchase', 'varchar', 15, '5060');
INSERT INTO `2_sys_prefs` VALUES('creditors_act', 'glsetup.purchase', 'varchar', 15, '2100');
INSERT INTO `2_sys_prefs` VALUES('po_over_receive', 'glsetup.purchase', 'int', 11, '0');
INSERT INTO `2_sys_prefs` VALUES('po_over_charge', 'glsetup.purchase', 'int', 11, '0');
INSERT INTO `2_sys_prefs` VALUES('allow_negative_stock', 'glsetup.inventory', 'tinyint', 1, '0');
INSERT INTO `2_sys_prefs` VALUES('default_inventory_act', 'glsetup.items', 'varchar', 15, '1520');
INSERT INTO `2_sys_prefs` VALUES('default_cogs_act', 'glsetup.items', 'varchar', 15, '5100');
INSERT INTO `2_sys_prefs` VALUES('default_adj_act', 'glsetup.items', 'varchar', 15, '5040');
INSERT INTO `2_sys_prefs` VALUES('default_inv_transport_act', 'glsetup.items', 'varchar', 15, '4430');
INSERT INTO `2_sys_prefs` VALUES('default_assembly_act', 'glsetup.items', 'varchar', 15, '1530');
INSERT INTO `2_sys_prefs` VALUES('default_workorder_required', 'glsetup.manuf', 'int', 11, '20');
INSERT INTO `2_sys_prefs` VALUES('version_id', 'system', 'varchar', 11, '2.3rc');
INSERT INTO `2_sys_prefs` VALUES('auto_curr_reval', 'setup.company', 'smallint', 6, '1');
INSERT INTO `2_sys_prefs` VALUES('grn_clearing_act', 'glsetup.purchase', 'varchar', 15, '1550');
INSERT INTO `2_sys_prefs` VALUES('bcc_email', 'setup.company', 'varchar', 100, '');
INSERT INTO `2_sys_prefs` VALUES('no_consignee_list', 'setup.company', 'tinyint', 1, '0');

-- --------------------------------------------------------

--
-- Table structure for table `2_sys_types`
--

CREATE TABLE `2_sys_types` (
  `type_id` smallint(6) NOT NULL default '0',
  `type_no` int(11) NOT NULL default '1',
  `next_reference` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_sys_types`
--

INSERT INTO `2_sys_types` VALUES(0, 19, '10');
INSERT INTO `2_sys_types` VALUES(1, 8, '3');
INSERT INTO `2_sys_types` VALUES(2, 5, '3');
INSERT INTO `2_sys_types` VALUES(4, 3, '4');
INSERT INTO `2_sys_types` VALUES(10, 19, '99');
INSERT INTO `2_sys_types` VALUES(11, 3, '10');
INSERT INTO `2_sys_types` VALUES(12, 6, '55');
INSERT INTO `2_sys_types` VALUES(13, 5, '40');
INSERT INTO `2_sys_types` VALUES(16, 2, '10');
INSERT INTO `2_sys_types` VALUES(17, 2, '5');
INSERT INTO `2_sys_types` VALUES(18, 1, '7');
INSERT INTO `2_sys_types` VALUES(20, 8, '15');
INSERT INTO `2_sys_types` VALUES(21, 1, '1');
INSERT INTO `2_sys_types` VALUES(22, 4, '5');
INSERT INTO `2_sys_types` VALUES(25, 1, '4');
INSERT INTO `2_sys_types` VALUES(26, 1, '70');
INSERT INTO `2_sys_types` VALUES(28, 1, '3');
INSERT INTO `2_sys_types` VALUES(29, 1, '3');
INSERT INTO `2_sys_types` VALUES(30, 5, '62');
INSERT INTO `2_sys_types` VALUES(32, 0, '54');
INSERT INTO `2_sys_types` VALUES(33, 0, '62');
INSERT INTO `2_sys_types` VALUES(35, 1, '1');
INSERT INTO `2_sys_types` VALUES(40, 1, '3');

-- --------------------------------------------------------

--
-- Table structure for table `2_tags`
--

CREATE TABLE `2_tags` (
  `id` int(11) NOT NULL auto_increment,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) default NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_tags`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_tag_associations`
--

CREATE TABLE `2_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_tag_associations`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_tax_groups`
--

CREATE TABLE `2_tax_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `tax_shipping` tinyint(1) NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_tax_groups`
--

INSERT INTO `2_tax_groups` VALUES(1, 'Tax', 0, 0);
INSERT INTO `2_tax_groups` VALUES(2, 'Tax Exempt', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_tax_group_items`
--

CREATE TABLE `2_tax_group_items` (
  `tax_group_id` int(11) NOT NULL default '0',
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  PRIMARY KEY  (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_tax_group_items`
--

INSERT INTO `2_tax_group_items` VALUES(1, 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `2_tax_types`
--

CREATE TABLE `2_tax_types` (
  `id` int(11) NOT NULL auto_increment,
  `rate` double NOT NULL default '0',
  `transport_gl_code` varchar(15) NOT NULL default '',
  `purchasing_gl_code` varchar(15) NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `2_tax_types`
--

INSERT INTO `2_tax_types` VALUES(1, 0, '2150', '2150', 'Tax', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_transportman`
--

CREATE TABLE `2_transportman` (
  `transportman_code` int(11) NOT NULL auto_increment,
  `transportman_name` char(60) NOT NULL default '',
  `transportman_phone` char(30) NOT NULL default '',
  `transportman_fax` char(30) NOT NULL default '',
  `transportman_email` varchar(100) NOT NULL default '',
  `provision` double NOT NULL default '0',
  `break_pt` double NOT NULL default '0',
  `provision2` double NOT NULL default '0',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`transportman_code`),
  UNIQUE KEY `transportman_name` (`transportman_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_transportman`
--

INSERT INTO `2_transportman` VALUES(1, 'Sales Person', '', '', '', 5, 1000, 4, 0);
INSERT INTO `2_transportman` VALUES(2, 'New', '', '', '', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_transport_orders`
--

CREATE TABLE `2_transport_orders` (
  `order_no` int(11) NOT NULL,
  `trans_type` smallint(6) NOT NULL default '30',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `consignor_no` int(11) default NULL,
  `branch_code` int(11) default NULL,
  `consignee_no` int(11) default NULL,
  `consignee_branch_code` int(11) default NULL,
  `consignee_ref` tinytext,
  `driver_no` varchar(11) default NULL,
  `driver_ref` varchar(20) default NULL,
  `vehicle_no` char(20) default NULL,
  `vehicle_type` int(11) default NULL,
  `vehicle_ref` tinytext,
  `reference` varchar(100) NOT NULL default '',
  `consignor_ref` varchar(50) default NULL,
  `consignor_tin_no` varchar(20) default NULL,
  `consignee_tin_no` varchar(20) default NULL,
  `comments` tinytext,
  `ord_date` date NOT NULL default '0000-00-00',
  `order_type` int(11) NOT NULL default '0',
  `ship_via` int(11) NOT NULL default '0',
  `delivery_address` tinytext NOT NULL,
  `loading_address` varchar(100) NOT NULL,
  `loaded_from` varchar(100) NOT NULL,
  `contact_phone` varchar(30) default NULL,
  `contact_email` varchar(100) default NULL,
  `deliver_to` tinytext NOT NULL,
  `freight_cost` double NOT NULL default '0',
  `commission_cost` double NOT NULL,
  `labour_charge` double NOT NULL,
  `insc_charge` double NOT NULL,
  `way_cost` double NOT NULL,
  `bilty_charge` double NOT NULL,
  `ship_cost` double NOT NULL,
  `from_stk_loc` varchar(5) NOT NULL default '',
  `Location_to` varchar(5) NOT NULL,
  `delivery_date` date NOT NULL default '0000-00-00',
  `payment_terms` int(11) default NULL,
  `total` double NOT NULL default '0',
  `total_goods_value` decimal(20,0) NOT NULL,
  PRIMARY KEY  (`trans_type`,`order_no`),
  KEY `vehicle_no` (`vehicle_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_transport_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_transport_order_details`
--

CREATE TABLE `2_transport_order_details` (
  `id` int(11) NOT NULL auto_increment,
  `order_no` int(11) NOT NULL default '0',
  `trans_type` smallint(6) NOT NULL default '30',
  `stk_code` varchar(20) NOT NULL default '',
  `description` tinytext,
  `qty_sent` double NOT NULL default '0',
  `unit_price` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `to_units` varchar(10) NOT NULL,
  `discount_percent` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `sorder` (`trans_type`,`order_no`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_transport_order_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_transport_pos`
--

CREATE TABLE `2_transport_pos` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` varchar(5) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `2_transport_pos`
--

INSERT INTO `2_transport_pos` VALUES(1, 'Default', 1, 1, 'DEF', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_transport_types`
--

CREATE TABLE `2_transport_types` (
  `id` int(11) NOT NULL auto_increment,
  `transport_type` char(50) NOT NULL default '',
  `tax_included` int(1) NOT NULL default '0',
  `factor` double NOT NULL default '1',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `transport_type` (`transport_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `2_transport_types`
--

INSERT INTO `2_transport_types` VALUES(1, 'By Ship', 0, 0, 0);
INSERT INTO `2_transport_types` VALUES(2, 'By Air', 0, 0, 0);
INSERT INTO `2_transport_types` VALUES(3, 'By Road', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_trans_tax_details`
--

CREATE TABLE `2_trans_tax_details` (
  `id` int(11) NOT NULL auto_increment,
  `trans_type` smallint(6) default NULL,
  `trans_no` int(11) default NULL,
  `tran_date` date NOT NULL,
  `tax_type_id` int(11) NOT NULL default '0',
  `rate` double NOT NULL default '0',
  `ex_rate` double NOT NULL default '1',
  `included_in_price` tinyint(1) NOT NULL default '0',
  `net_amount` double NOT NULL default '0',
  `amount` double NOT NULL default '0',
  `memo` tinytext,
  PRIMARY KEY  (`id`),
  KEY `Type_and_Number` (`trans_type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

--
-- Dumping data for table `2_trans_tax_details`
--

INSERT INTO `2_trans_tax_details` VALUES(1, 13, 3, '2014-01-12', 1, 5, 1, 0, 120, 6, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(2, 10, 3, '2014-01-12', 1, 5, 1, 0, 120, 6, '80');
INSERT INTO `2_trans_tax_details` VALUES(3, 13, 4, '2014-01-12', 1, 5, 1, 0, 120, 6, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(4, 10, 4, '2014-01-12', 1, 5, 1, 0, 120, 6, '81');
INSERT INTO `2_trans_tax_details` VALUES(5, 13, 5, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(6, 10, 5, '2014-01-12', 1, 0, 1, 0, 120, 0, '82');
INSERT INTO `2_trans_tax_details` VALUES(7, 13, 6, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(8, 10, 6, '2014-01-12', 1, 0, 1, 0, 120, 0, '83');
INSERT INTO `2_trans_tax_details` VALUES(9, 13, 7, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(10, 10, 7, '2014-01-12', 1, 0, 1, 0, 120, 0, '84');
INSERT INTO `2_trans_tax_details` VALUES(11, 13, 8, '2014-01-12', 1, 0, 1, 0, 120, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(12, 10, 8, '2014-01-12', 1, 0, 1, 0, 120, 0, '85');
INSERT INTO `2_trans_tax_details` VALUES(13, 11, 1, '2014-01-12', 1, 0, 1, 0, 120, 0, '10');
INSERT INTO `2_trans_tax_details` VALUES(14, 13, 9, '2014-01-12', 1, 0, 1, 0, 120, 0, '24');
INSERT INTO `2_trans_tax_details` VALUES(15, 10, 9, '2014-01-12', 1, 0, 1, 0, 120, 0, '86');
INSERT INTO `2_trans_tax_details` VALUES(16, 13, 10, '2014-01-12', 1, 0, 1, 0, 122320.09, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(17, 10, 10, '2014-01-12', 1, 0, 1, 0, 122320.09, 0, '87');
INSERT INTO `2_trans_tax_details` VALUES(18, 13, 1, '2014-01-16', 1, 0, 1, 0, 0, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(19, 10, 1, '2014-01-16', 1, 0, 1, 0, 10, 0, '90');
INSERT INTO `2_trans_tax_details` VALUES(20, 13, 2, '2014-01-18', 1, 0, 1, 0, 1220, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(21, 10, 2, '2014-01-18', 1, 0, 1, 0, 1220, 0, '92');
INSERT INTO `2_trans_tax_details` VALUES(22, 13, 3, '2014-01-18', 1, 0, 1, 0, 124454310, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(23, 10, 3, '2014-01-18', 1, 0, 1, 0, 124454310, 0, '93');
INSERT INTO `2_trans_tax_details` VALUES(24, 13, 2, '2014-01-19', 1, 0, 1, 0, 232323210, 0, 'auto');
INSERT INTO `2_trans_tax_details` VALUES(25, 10, 1, '2014-01-19', 1, 0, 1, 0, 232323210, 0, '94');
INSERT INTO `2_trans_tax_details` VALUES(26, 13, 14, '2014-01-25', 1, 0, 1, 0, 120, 0, '36');
INSERT INTO `2_trans_tax_details` VALUES(27, 13, 1, '2014-01-25', 1, 0, 1, 0, 0, 0, '37');
INSERT INTO `2_trans_tax_details` VALUES(28, 13, 1, '2014-01-25', 1, 0, 1, 0, 120, 0, '37');
INSERT INTO `2_trans_tax_details` VALUES(29, 10, 1, '2014-01-25', 1, 0, 1, 0, 120, 0, '97');

-- --------------------------------------------------------

--
-- Table structure for table `2_useronline`
--

CREATE TABLE `2_useronline` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(15) NOT NULL default '0',
  `ip` varchar(40) NOT NULL default '',
  `file` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_useronline`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_users`
--

CREATE TABLE `2_users` (
  `id` smallint(6) NOT NULL auto_increment,
  `user_id` varchar(60) NOT NULL default '',
  `password` varchar(100) NOT NULL default '',
  `real_name` varchar(100) NOT NULL default '',
  `role_id` int(11) NOT NULL default '1',
  `phone` varchar(30) NOT NULL default '',
  `email` varchar(100) default NULL,
  `language` varchar(20) default NULL,
  `date_format` tinyint(1) NOT NULL default '0',
  `date_sep` tinyint(1) NOT NULL default '0',
  `tho_sep` tinyint(1) NOT NULL default '0',
  `dec_sep` tinyint(1) NOT NULL default '0',
  `theme` varchar(20) NOT NULL default 'default',
  `page_size` varchar(20) NOT NULL default 'A4',
  `prices_dec` smallint(6) NOT NULL default '2',
  `qty_dec` smallint(6) NOT NULL default '2',
  `rates_dec` smallint(6) NOT NULL default '4',
  `percent_dec` smallint(6) NOT NULL default '1',
  `show_gl` tinyint(1) NOT NULL default '1',
  `show_codes` tinyint(1) NOT NULL default '0',
  `show_hints` tinyint(1) NOT NULL default '0',
  `last_visit_date` datetime default NULL,
  `query_size` tinyint(1) default '10',
  `graphic_links` tinyint(1) default '1',
  `pos` smallint(6) default '1',
  `print_profile` varchar(30) NOT NULL default '1',
  `rep_popup` tinyint(1) default '1',
  `sticky_doc_date` tinyint(1) default '0',
  `startup_tab` varchar(20) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `2_users`
--

INSERT INTO `2_users` VALUES(1, 'admin', 'afbb2c3c34deef5949337258b1531b96', 'Administrator', 2, '', 'adm@adm.com', 'C', 0, 0, 0, 0, 'default', 'Letter', 2, 2, 4, 1, 1, 0, 0, '2014-06-14 06:59:53', 10, 1, 1, '', 1, 0, 'orders', 0);
INSERT INTO `2_users` VALUES(2, 'demouser', '5f4dcc3b5aa765d61d8327deb882cf99', 'Demo User', 9, '999-999-999', 'demo@demo.nu', 'en_US', 0, 0, 0, 0, 'default', 'Letter', 2, 2, 3, 1, 1, 0, 0, '2008-02-06 19:02:35', 10, 1, 1, '1', 1, 0, 'orders', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_vehicles_master`
--

CREATE TABLE `2_vehicles_master` (
  `vehicle_no` int(11) NOT NULL auto_increment,
  `vehicle_init_odometer` decimal(10,2) NOT NULL,
  `vehicle_warranty_odometer` decimal(10,2) NOT NULL,
  `vehicle_number_plate` varchar(20) NOT NULL default '',
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
  `vehicle_purchase_price` decimal(10,2) NOT NULL,
  `vehicle_purchase_date` date NOT NULL,
  `vehicle_warranty_date` date NOT NULL,
  `vehicle_vendor_id` int(11) NOT NULL,
  `vehicle_purchase_note` varchar(200) NOT NULL,
  `vehicle_wt` decimal(10,2) NOT NULL,
  `vehicle_wt_unit` int(11) NOT NULL,
  `vehicle_type_id` int(11) NOT NULL,
  `vehicle_fuel_type_id` int(11) NOT NULL,
  `vehicle_fuel_usage_id` int(11) NOT NULL,
  `vehicle_odometer_type_id` int(10) NOT NULL,
  `inactive` int(10) NOT NULL,
  PRIMARY KEY  (`vehicle_no`),
  UNIQUE KEY `vehicle_number_plate` (`vehicle_number_plate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_vehicles_master`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_vehicle_types`
--

CREATE TABLE `2_vehicle_types` (
  `vehicle_type_code` int(11) NOT NULL auto_increment,
  `vehicle_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vehicle_type_code`),
  UNIQUE KEY `description` (`vehicle_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `2_vehicle_types`
--

INSERT INTO `2_vehicle_types` VALUES(5, 'sad', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_vehicle_weight_types`
--

CREATE TABLE `2_vehicle_weight_types` (
  `vehicle_weight_type_code` int(11) NOT NULL auto_increment,
  `vehicle_weight_description` varchar(60) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vehicle_weight_type_code`),
  UNIQUE KEY `description` (`vehicle_weight_description`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `2_vehicle_weight_types`
--

INSERT INTO `2_vehicle_weight_types` VALUES(5, 'Kg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_vendors_master`
--

CREATE TABLE `2_vendors_master` (
  `vendor_no` int(11) NOT NULL auto_increment,
  `vendor_name` varchar(100) NOT NULL default '',
  `vendor_birth_date` date NOT NULL,
  `hired_on` date NOT NULL,
  `licence_no` varchar(100) NOT NULL,
  `health_exam_ref` varchar(100) NOT NULL,
  `date_of_checkup` date NOT NULL,
  `vendor_ref` varchar(30) NOT NULL,
  `address` tinytext,
  `curr_code` char(3) NOT NULL default '',
  `payment_terms` int(11) default NULL,
  `rate` decimal(10,2) NOT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vendor_no`),
  UNIQUE KEY `vendor_ref` (`vendor_ref`),
  KEY `name` (`vendor_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `2_vendors_master`
--

INSERT INTO `2_vendors_master` VALUES(1, 'Beefeater Ltd.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Beefeater', 'Addr 1\nAddr 2\nAddr 3', 'GBP', 3, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(2, 'Ghostbusters Corp.', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Ghostbusters', 'Address 1\nAddress 2\nAddress 3', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(3, 'Brezan', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Brezan', 'Address 1\nAddress 2\nAddress 3', 'EUR', 3, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(4, 'asd', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'sad', NULL, '', NULL, 0.00, 'USD', 0);
INSERT INTO `2_vendors_master` VALUES(5, 'dsa', '0000-00-00', '0000-00-00', 'das', '', '0000-00-00', 'dsa', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(6, 'dasdasjadsjads', '0000-00-00', '0000-00-00', 'dsa', '', '0000-00-00', 'Anurodh', 'dsa', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(7, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(8, 'das', '0000-00-00', '0000-00-00', 'ads', '', '0000-00-00', 'sddddddda', 'sda', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(9, 'das', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'dsadsdsashkgdsuhgskd', 'dasa', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(10, 'dsa', '0000-00-00', '0000-00-00', '', '', '0000-00-00', 'Andhrapradesh', 'das', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(11, 'Avinash', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'Jeengar', 'ddhfsf', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(12, 'Naehhe', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'adasdhhdas', NULL, 'USD', 4, 55.00, '', 1);
INSERT INTO `2_vendors_master` VALUES(13, 'adnannadads', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'dasnands,,nads', 'czx', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(14, 'Avinashskjd', '2014-02-13', '2014-02-13', '', '', '2014-02-13', 'fsdhfas', 'fdsfkskdfsnksd', 'USD', 4, 0.00, '', 0);
INSERT INTO `2_vendors_master` VALUES(15, 'HKHAd', '0000-00-00', '2014-02-17', '', '', '0000-00-00', 'daljajdsjl', 'dasjllads', 'USD', 4, 0.00, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_vendor_trans`
--

CREATE TABLE `2_vendor_trans` (
  `trans_no` int(11) unsigned NOT NULL default '0',
  `type` smallint(6) unsigned NOT NULL default '0',
  `version` tinyint(1) unsigned NOT NULL default '0',
  `vendor_no` int(11) unsigned default NULL,
  `branch_code` int(11) NOT NULL default '-1',
  `tran_date` date NOT NULL default '0000-00-00',
  `due_date` date NOT NULL default '0000-00-00',
  `reference` varchar(60) NOT NULL default '',
  `tpe` int(11) NOT NULL default '0',
  `order_` int(11) NOT NULL default '0',
  `ov_amount` double NOT NULL default '0',
  `ov_gst` double NOT NULL default '0',
  `ov_freight` double NOT NULL default '0',
  `ov_freight_tax` double NOT NULL default '0',
  `ov_discount` double NOT NULL default '0',
  `alloc` double NOT NULL default '0',
  `rate` double NOT NULL default '1',
  `ship_via` int(11) default NULL,
  `dimension_id` int(11) NOT NULL default '0',
  `dimension2_id` int(11) NOT NULL default '0',
  `payment_terms` int(11) default NULL,
  PRIMARY KEY  (`type`,`trans_no`),
  KEY `vendor_no` (`vendor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_vendor_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_vendor_trans_details`
--

CREATE TABLE `2_vendor_trans_details` (
  `id` int(11) NOT NULL auto_increment,
  `vendor_trans_no` int(11) default NULL,
  `vendor_trans_type` int(11) default NULL,
  `stock_id` varchar(20) NOT NULL default '',
  `description` tinytext,
  `unit_price` double NOT NULL default '0',
  `unit_tax` double NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `discount_percent` double NOT NULL default '0',
  `standard_cost` double NOT NULL default '0',
  `qty_done` double NOT NULL default '0',
  `src_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Transaction` (`vendor_trans_type`,`vendor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_vendor_trans_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_voided`
--

CREATE TABLE `2_voided` (
  `type` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `2_voided`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_workcentres`
--

CREATE TABLE `2_workcentres` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(40) NOT NULL default '',
  `description` char(50) NOT NULL default '',
  `inactive` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `2_workcentres`
--

INSERT INTO `2_workcentres` VALUES(1, 'Workshop', 'Workshop in Alabama', 0);

-- --------------------------------------------------------

--
-- Table structure for table `2_workorders`
--

CREATE TABLE `2_workorders` (
  `id` int(11) NOT NULL auto_increment,
  `wo_ref` varchar(60) NOT NULL default '',
  `loc_code` varchar(5) NOT NULL default '',
  `units_reqd` double NOT NULL default '1',
  `stock_id` varchar(20) NOT NULL default '',
  `vehicle_id` varchar(20) NOT NULL,
  `date_` date NOT NULL default '0000-00-00',
  `type` tinyint(4) NOT NULL default '0',
  `required_by` date NOT NULL default '0000-00-00',
  `released_date` date NOT NULL default '0000-00-00',
  `units_issued` double NOT NULL default '0',
  `closed` tinyint(1) NOT NULL default '0',
  `released` tinyint(1) NOT NULL default '0',
  `additional_costs` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_workorders`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_wo_issues`
--

CREATE TABLE `2_wo_issues` (
  `issue_no` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `reference` varchar(100) default NULL,
  `issue_date` date default NULL,
  `loc_code` varchar(5) default NULL,
  `workcentre_id` int(11) default NULL,
  PRIMARY KEY  (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_wo_issues`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_wo_issue_items`
--

CREATE TABLE `2_wo_issue_items` (
  `id` int(11) NOT NULL auto_increment,
  `stock_id` varchar(40) default NULL,
  `issue_id` int(11) default NULL,
  `qty_issued` double default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_wo_issue_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_wo_manufacture`
--

CREATE TABLE `2_wo_manufacture` (
  `id` int(11) NOT NULL auto_increment,
  `reference` varchar(100) default NULL,
  `workorder_id` int(11) NOT NULL default '0',
  `quantity` double NOT NULL default '0',
  `date_` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_wo_manufacture`
--


-- --------------------------------------------------------

--
-- Table structure for table `2_wo_requirements`
--

CREATE TABLE `2_wo_requirements` (
  `id` int(11) NOT NULL auto_increment,
  `workorder_id` int(11) NOT NULL default '0',
  `stock_id` char(20) NOT NULL default '',
  `workcentre` int(11) NOT NULL default '0',
  `vehicle_id` varchar(20) NOT NULL,
  `units_req` double NOT NULL default '1',
  `std_cost` double NOT NULL default '0',
  `loc_code` char(5) NOT NULL default '',
  `units_issued` double NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `2_wo_requirements`
--

