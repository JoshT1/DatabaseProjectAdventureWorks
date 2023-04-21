/*

The purpose of the project is to install the adventureworks DB, create a backup,

delete the DB, and restore the DB via the backup file.

I am using 2 local mssql servers, on one my laptop and the other on my desktop

I am running the AdventureWorks script on my laptop, backing it up, and restoring
it on my desktop.

I am also using the AdventureWorks DB, and not theAdventureWorksDW.

I downloaded SQL Server 2022 Express from microsoft. SMSS cannot create servers AFAIK.

Server=JOSH2/SQLEXPRESS;Database=master;Trusted_Connection=True; Default connection string laptop
JOSH2\JoshT
Server=DESKTOP-B5CCE9E\SQLEXPRESS;Database=master;Trusted_Connection=True; Default connection string desktop
DESKTOP-B5CCE9E\Josh
C:\Samples\AdventureWorks is the directory, installed Full Text Search, SQLCMD mode turned on.
Running the db install script was successful.

Filestream access level: Full access enabled.
SSMS - allow remote connections
SQL server config manager - enable TCP/IP protocol, allow TCP port 1433

*/

-- Get connection string
SELECT
    'data source=' + @@SERVERNAME +
    ';initial catalog=' + DB_NAME() +
    CASE type_desc
        WHEN 'WINDOWS_LOGIN' 
            THEN ';trusted_connection=true'
        ELSE
            ';user id=' + SUSER_NAME()
    END
FROM sys.server_principals
WHERE name = suser_name()
 --data source=Josh2\SQLEXPRESS;initial catalog=AdventureWorks;trusted_connection=true
 --data source=DESKTOP-B5CCE9E\SQLEXPRESS;initial catalog=master;trusted_connection=true

-- Create backup of adventureworks DB on laptop, generated via SMSS tasks.
BACKUP DATABASE [AdventureWorks] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\AdventureWorks.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks-DB-BACKUP', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--Create user on desktop
--SERVER NAME: DESKTOP-B5CCE9E\SQLEXPRESS,1433

--Create restore of adventureworks DB on laptop to test, generated via SMSS tasks.
USE [master]
RESTORE DATABASE [AdventureWorks] 
FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\AdventureWorks.bak' 
WITH  FILE = 1,  
NOUNLOAD,  
STATS = 5
GO

-- transfer AdventureWorks.bak over to desktop, same directory.
-- Ran above script, Processed 25264 pages for database 'AdventureWorks', file 'AdventureWorks' on file 1.