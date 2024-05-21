CREATE TABLE `user` (
	`UserID` INT(11) NOT NULL AUTO_INCREMENT,
	`Username` VARCHAR(8) NOT NULL,
	`Password` VARCHAR(33) NOT NULL,
	`LastLoginTime` TIMESTAMP NULL DEFAULT NULL,
	`IsOnline` TINYINT(1) NOT NULL DEFAULT '0',
	`connectCount` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`UserID`),
	UNIQUE INDEX `Username` (`Username`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=9
;

CREATE TABLE `message` (
	`MessageID` INT(11) NOT NULL AUTO_INCREMENT,
	`SenderID` INT(11) NOT NULL,
	`ReceiveID` INT(11) NOT NULL,
	`MessageText` VARCHAR(40) NULL DEFAULT NULL,
	`MessageType` ENUM('Echo','Whisper') NOT NULL,
	`SendTime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`MessageID`),
	INDEX `SenderID` (`SenderID`),
	INDEX `ReceiveID` (`ReceiveID`),
	CONSTRAINT `message_ibfk_1` FOREIGN KEY (`SenderID`) REFERENCES `user` (`UserID`),
	CONSTRAINT `message_ibfk_2` FOREIGN KEY (`ReceiveID`) REFERENCES `user` (`UserID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=17
;

CREATE TABLE `friend` (
	`UserID` INT(11) NOT NULL,
	`FriendID` INT(11) NOT NULL,
	PRIMARY KEY (`UserID`, `FriendID`),
	INDEX `FriendID` (`FriendID`),
	CONSTRAINT `friend_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`),
	CONSTRAINT `friend_ibfk_2` FOREIGN KEY (`FriendID`) REFERENCES `user` (`UserID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

