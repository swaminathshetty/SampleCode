drop table if exists MData;

drop table if exists SysConfig;

drop table if exists MeterProfile;



create table MData (
_id                  INTEGER                        PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
MType                INTEGER                        not null,
Value1               REAL                           not null,
Value2               REAL,
Value3               REAL,
Value4               REAL,
Value5               REAL,
MeterId              INTEGER,
RawData              TEXT,
MDateTime            INTEGER                        not null,
RecStatus            INTEGER                        not null default 0,
userNo               INTEGER                        not null default 1
);



create table SysConfig (
_id                  INTEGER                        PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
ConfName             TEXT                           not null,
ConfValueType        INTEGER                        not null,
ConfIntValue         INTEGER,
ConfStrValue         TEXT,
ConfFtValue          REAL
);


INSERT INTO SysConfig (ConfName, ConfValueType, ConfStrValue) VALUES('LANG', 1, 'en-US');
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_UNIT', 0, 0);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BPM_UNIT', 0, 0);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('HEIGHT_UNIT', 0, 0);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('WEIGHT_UNIT', 0, 0);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('userNo', 0, 1);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('SPO2', 0, 90);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('TEMP_Unit', 0, 0);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfFtValue) VALUES('TEMP_H', 0, 37.5);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfFtValue) VALUES('TEMP_L', 0, 36);

INSERT INTO SysConfig (ConfName, ConfValueType, ConfStrValue) VALUES('DEVICE_SERIAL_NUMBER', 1, '2AG08KRF7DNJ9C');
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_AC_SAFE_L', 0, 70);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_AC_SAFE_H', 0, 100);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_PC_SAFE_L', 0, 70);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_PC_SAFE_H', 0, 140);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_GEN_SAFE_L', 0, 70);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BGM_GEN_SAFE_H', 0, 100);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BPM_SYS_SAFE_L', 0, 90);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BPM_SYS_SAFE_H', 0, 119);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BPM_DIA_SAFE_L', 0, 60);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('BPM_DIA_SAFE_H', 0, 79);
INSERT INTO SysConfig (ConfName, ConfValueType, ConfIntValue) VALUES('WS_SAFE_H', 0, 0);



create table MeterProfile (
_id                  INTEGER                        PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
DeviceType           TEXT,
DeviceId             TEXT,
DeviceMac            TEXT                           not null,
LastImport           BLOB,
userNo               INTEGER                        not null default 1
);



