CREATE TABLE IF NOT EXISTS `bloodtype` (
  `blood_type_id` varchar(5) NOT NULL,
  `abo_group` char(3) NOT NULL CHECK (`abo_group` in ('A','B','AB','O')),
  `rh_factor` varchar(10) NOT NULL CHECK (`rh_factor` in ('Positive','Negative')),
  PRIMARY KEY (`blood_type_id`),
  UNIQUE KEY `abo_group` (`abo_group`,`rh_factor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `bloodunit` (
  `bloodUnit_id` varchar(5) NOT NULL,
  `donation_id` varchar(5) NOT NULL,
  `blood_type_id` varchar(5) DEFAULT NULL,
  `procurement_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `blood_vol` decimal(5,2) NOT NULL,
  PRIMARY KEY (`bloodUnit_id`),
  KEY `donation_id` (`donation_id`),
  KEY `blood_type_id` (`blood_type_id`),
  CONSTRAINT `1` FOREIGN KEY (`donation_id`) REFERENCES `donation` (`donation_id`),
  CONSTRAINT `2` FOREIGN KEY (`blood_type_id`) REFERENCES `bloodtype` (`blood_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `branch` (
  `branch_id` varchar(5) NOT NULL,
  `branchName` varchar(30) DEFAULT NULL,
  `branchAddress` varchar(50) DEFAULT NULL,
  `branchContact` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `compatibility` (
  `donor_type_id` varchar(5) NOT NULL,
  `recipient_type_id` varchar(5) NOT NULL,
  PRIMARY KEY (`donor_type_id`,`recipient_type_id`),
  KEY `recipient_type_id` (`recipient_type_id`),
  CONSTRAINT `1` FOREIGN KEY (`donor_type_id`) REFERENCES `bloodtype` (`blood_type_id`),
  CONSTRAINT `2` FOREIGN KEY (`recipient_type_id`) REFERENCES `bloodtype` (`blood_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `deferral` (
  `deferralID` varchar(5) NOT NULL,
  `donorID` varchar(5) NOT NULL,
  `deferral_date` date NOT NULL,
  `reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`deferralID`),
  KEY `donorID` (`donorID`),
  CONSTRAINT `1` FOREIGN KEY (`donorID`) REFERENCES `donor` (`donor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `donation` (
  `donation_id` varchar(5) NOT NULL,
  `donor_id` varchar(5) NOT NULL,
  `volume` decimal(5,2) NOT NULL,
  `branch_id` varchar(5) NOT NULL,
  `DonationDate` date NOT NULL,
  PRIMARY KEY (`donation_id`),
  KEY `donor_id` (`donor_id`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`),
  CONSTRAINT `2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `donor` (
  `donor_id` varchar(5) NOT NULL,
  `donorFName` varchar(30) DEFAULT NULL,
  `donorLName` varchar(30) DEFAULT NULL,
  `DOB` date NOT NULL,
  `gender` char(1) NOT NULL CHECK (`gender` in ('M','F')),
  `contact` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `blood_type_id` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`donor_id`),
  KEY `blood_type_id` (`blood_type_id`),
  CONSTRAINT `1` FOREIGN KEY (`blood_type_id`) REFERENCES `bloodtype` (`blood_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `hospital` (
  `Hospital_id` varchar(5) NOT NULL,
  `HospitalName` varchar(50) NOT NULL,
  `Contact` varchar(15) DEFAULT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`Hospital_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `inventory` (
  `inventory_id` varchar(5) NOT NULL,
  `bloodUnit_id` varchar(5) NOT NULL,
  `branch_id` varchar(5) NOT NULL,
  `status` varchar(20) NOT NULL CHECK (`status` in ('Available','Reserved','Issued','Expired')),
  PRIMARY KEY (`inventory_id`),
  KEY `bloodUnit_id` (`bloodUnit_id`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `1` FOREIGN KEY (`bloodUnit_id`) REFERENCES `bloodunit` (`bloodUnit_id`),
  CONSTRAINT `2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `issuance` (
  `Issuance_id` varchar(5) NOT NULL,
  `IssuedUnits` decimal(5,2) NOT NULL,
  `Request_id` varchar(5) NOT NULL,
  `IssueDate` date NOT NULL,
  `StaffID` varchar(5) NOT NULL,
  PRIMARY KEY (`Issuance_id`),
  KEY `Request_id` (`Request_id`),
  KEY `StaffID` (`StaffID`),
  CONSTRAINT `1` FOREIGN KEY (`Request_id`) REFERENCES `request` (`Request_id`),
  CONSTRAINT `2` FOREIGN KEY (`StaffID`) REFERENCES `staff` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `issuedbloodunit` (
  `Issuance_id` varchar(5) NOT NULL,
  `bloodUnit_id` varchar(5) NOT NULL,
  PRIMARY KEY (`Issuance_id`,`bloodUnit_id`),
  KEY `bloodUnit_id` (`bloodUnit_id`),
  CONSTRAINT `1` FOREIGN KEY (`Issuance_id`) REFERENCES `issuance` (`Issuance_id`),
  CONSTRAINT `2` FOREIGN KEY (`bloodUnit_id`) REFERENCES `bloodunit` (`bloodUnit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `request` (
  `Request_id` varchar(5) NOT NULL,
  `BloodType` varchar(5) NOT NULL,
  `Priority` varchar(10) NOT NULL CHECK (`Priority` in ('High','Medium','Low')),
  `Status` varchar(20) NOT NULL CHECK (`Status` in ('Pending','Approved','Rejected')),
  `RequestDate` date NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Hospital_id` varchar(5) NOT NULL,
  PRIMARY KEY (`Request_id`),
  KEY `Hospital_id` (`Hospital_id`),
  KEY `BloodType` (`BloodType`),
  CONSTRAINT `1` FOREIGN KEY (`Hospital_id`) REFERENCES `hospital` (`Hospital_id`),
  CONSTRAINT `2` FOREIGN KEY (`BloodType`) REFERENCES `bloodtype` (`blood_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `screening` (
  `Screening_id` varchar(5) NOT NULL,
  `ScreeningDate` date NOT NULL,
  `StaffID` varchar(5) NOT NULL,
  `BloodUnitID` varchar(5) NOT NULL,
  `OverallStatus` varchar(20) NOT NULL CHECK (`OverallStatus` in ('Pending','Passed','Failed')),
  PRIMARY KEY (`Screening_id`),
  KEY `StaffID` (`StaffID`),
  KEY `BloodUnitID` (`BloodUnitID`),
  CONSTRAINT `1` FOREIGN KEY (`StaffID`) REFERENCES `staff` (`staff_id`),
  CONSTRAINT `2` FOREIGN KEY (`BloodUnitID`) REFERENCES `bloodunit` (`bloodUnit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `staff` (
  `staff_id` varchar(5) NOT NULL,
  `staffFName` varchar(30) DEFAULT NULL,
  `staffLName` varchar(30) DEFAULT NULL,
  `staffType` varchar(20) NOT NULL,
  `branchID` varchar(5) NOT NULL,
  `role_id` varchar(5) NOT NULL,
  PRIMARY KEY (`staff_id`),
  KEY `branchID` (`branchID`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `1` FOREIGN KEY (`branchID`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `2` FOREIGN KEY (`role_id`) REFERENCES `staffrole` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `staffrole` (
  `role_id` varchar(5) NOT NULL,
  `roleName` varchar(30) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `roleName` (`roleName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `temporarydeferral` (
  `tempDeferral_id` varchar(5) NOT NULL,
  `deferralID` varchar(5) NOT NULL,
  `endDate` date NOT NULL,
  PRIMARY KEY (`tempDeferral_id`),
  KEY `deferralID` (`deferralID`),
  CONSTRAINT `1` FOREIGN KEY (`deferralID`) REFERENCES `deferral` (`deferralID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `test` (
  `Test_id` varchar(5) NOT NULL,
  `TestName` varchar(30) NOT NULL,
  PRIMARY KEY (`Test_id`),
  UNIQUE KEY `TestName` (`TestName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `testresult` (
  `TestResultID` varchar(5) NOT NULL,
  `Screening_id` varchar(5) NOT NULL,
  `Test_id` varchar(5) NOT NULL,
  `Result` varchar(10) DEFAULT NULL CHECK (`Result` in ('Positive','Negative')),
  PRIMARY KEY (`TestResultID`),
  KEY `Screening_id` (`Screening_id`),
  KEY `Test_id` (`Test_id`),
  CONSTRAINT `1` FOREIGN KEY (`Screening_id`) REFERENCES `screening` (`Screening_id`),
  CONSTRAINT `2` FOREIGN KEY (`Test_id`) REFERENCES `test` (`Test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` varchar(5) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `user_type` varchar(10) NOT NULL CHECK (`user_type` in ('staff','hospital')),
  `staff_id` varchar(5) DEFAULT NULL,
  `hospital_id` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `staff_id` (`staff_id`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`),
  CONSTRAINT `2` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`Hospital_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
