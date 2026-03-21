/*
================================================================================
    Script:      Initialize DataWarehouse Database
    Purpose:     Sets up the DataWarehouse environment with Bronze, Silver, and Gold schemas.
                 This script ensures a clean start by removing any existing database 
                 with the same name before creation.
                 
    Warning:     The script will DROP the existing 'DataWarehouse' database if it exists.
                 All data in the existing database will be lost. Use with caution.
================================================================================
*/

-- Switch context to the master database to manage database creation
USE master;
GO

-- If the database already exists, terminate connections and drop it
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    -- Force single-user mode to disconnect active connections before drop
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Remove existing database to ensure a clean setup
    DROP DATABASE DataWarehouse;
END;
GO

-- Create a fresh DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the newly created database
USE DataWarehouse;
GO

/*
    Create separate schemas representing the Medallion Architecture layers:
    - bronze: Raw, ingested data
    - silver: Cleansed and standardized data
    - gold: Business-ready, analytics-optimized data
*/

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
