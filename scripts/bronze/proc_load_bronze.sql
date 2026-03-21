/*
=====================================================================================================
Stored Procedure : Load Bronze Layer ( SOURCE --> BRONZE )
=====================================================================================================
Script Purpose :
  Creaintg a stored procedure that loads data into the "BRONZE" schema from external .csv files.
  The following actions are performed :
  Truncating the bronze tables before loading data.
  Uses BULK INSERT command to load data from .csv files to bronze tables

  Usage : 
    EXEC bronze.load_bronze;
=====================================================================================================
*/

-- Stored procedure to load raw data into Bronze layer tables
CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '========================';
        PRINT 'Loading Bronze Layer';
        PRINT '========================';

        PRINT '------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------';

        -- Reload strategy: truncate before fresh ingestion
        PRINT '>> Trucating Table : bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into : bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'D:\Omarsss\Projects\SQL\Data Wharehouse Project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );

        SET @end_time = GETDATE();
        -- Track load duration per table for monitoring
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------';


        PRINT '>> Trucating Table : bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into : bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'D:\Omarsss\Projects\SQL\Data Wharehouse Project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------';


        PRINT '>> Trucating Table : bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into : bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'D:\Omarsss\Projects\SQL\Data Wharehouse Project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------';


        PRINT '------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------';

        PRINT '>> Trucating Table : bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into : bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\Omarsss\Projects\SQL\Data Wharehouse Project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------';


        PRINT '>> Trucating Table : bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into : bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\Omarsss\Projects\SQL\Data Wharehouse Project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------';


        PRINT '>> Trucating Table : bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into : bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\Omarsss\Projects\SQL\Data Wharehouse Project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------';


        SET @batch_end_time = GETDATE();

        PRINT '************************************';
        PRINT 'Loading Bronze Layer is Completed!!';
        -- Total batch duration across all tables
        PRINT 'Total Load Duration : ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '************************************';

    END TRY

    BEGIN CATCH 
        -- Centralized error capture for batch execution visibility
        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message :' + ERROR_MESSAGE();
        PRINT 'Error Number :' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State :' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
