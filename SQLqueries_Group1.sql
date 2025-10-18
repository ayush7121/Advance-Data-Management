-- --------------------------------------------
-- Create Table: Wine
-- This table stores information about various wines, including their quality, chemical composition, and associated foreign keys
-- --------------------------------------------
CREATE TABLE Wine (
    Wine_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for Wine
    GrapeVariety_ID VARCHAR2(10),     -- Foreign Key linking to GrapeVariety table
    SoilComposition_ID VARCHAR2(10),  -- Foreign Key linking to SoilComposition table
    Winery_ID VARCHAR2(10),           -- Foreign Key linking to Winery table
    ClimateData_ID VARCHAR2(10),      -- Foreign Key linking to ClimateData table
    ProductionProcess_ID VARCHAR2(10),-- Foreign Key linking to ProductionProcess table
    Quality DECIMAL(3, 2),            -- Numeric value indicating the quality of the wine
    Fixed_Acidity DECIMAL(5, 2),      -- Chemical characteristic
    Volatile_Acidity DECIMAL(5, 2),   -- Chemical characteristic
    Citric_Acid DECIMAL(5, 2),        -- Chemical characteristic
    Residual_Sugar DECIMAL(5, 2),     -- Chemical characteristic
    Chlorides DECIMAL(5, 4),          -- Chemical characteristic
    Free_Sulfur_Dioxide DECIMAL(5, 2),-- Chemical characteristic
    Total_Sulfur_Dioxide DECIMAL(5, 2),-- Chemical characteristic
    Density DECIMAL(5, 3),            -- Physical characteristic
    PH DECIMAL(3, 2),                 -- pH level of the wine
    Sulphates DECIMAL(3, 2),          -- Chemical characteristic
    Alcohol DECIMAL(3, 2),            -- Alcohol content of the wine
    FOREIGN KEY (GrapeVariety_ID) REFERENCES GrapeVariety(GrapeVariety_ID) ON UPDATE CASCADE,
    FOREIGN KEY (SoilComposition_ID) REFERENCES SoilComposition(SoilComposition_ID) ON UPDATE CASCADE,
    FOREIGN KEY (Winery_ID) REFERENCES Winery(Winery_ID) ON UPDATE CASCADE,
    FOREIGN KEY (ClimateData_ID) REFERENCES ClimateData(ClimateData_ID) ON UPDATE CASCADE,
    FOREIGN KEY (ProductionProcess_ID) REFERENCES ProductionProcess(ProductionProcess_ID) ON UPDATE CASCADE
);

-- --------------------------------------------
-- Create Table: GrapeVariety
-- This table stores the different varieties of grapes used for winemaking
-- --------------------------------------------
CREATE TABLE GrapeVariety (
    GrapeVariety_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for GrapeVariety
    Name VARCHAR2(100) NOT NULL,              -- Name of the grape variety
    Description VARCHAR2(255)                 -- Description of the grape variety
);

-- --------------------------------------------
-- Create Table: SoilComposition
-- This table stores the type and pH levels of the soil used for winemaking
-- --------------------------------------------
CREATE TABLE SoilComposition (
    SoilComposition_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for SoilComposition
    Type VARCHAR2(50) NOT NULL,                  -- Type of soil
    PH_Level DECIMAL(3, 2)                       -- pH level of the soil
);

-- --------------------------------------------
-- Create Table: Winery
-- This table stores information about the wineries
-- --------------------------------------------
CREATE TABLE Winery (
    Winery_ID VARCHAR2(10) PRIMARY KEY,  -- Primary Key for Winery
    Name VARCHAR2(100) NOT NULL,         -- Name of the winery
    Location VARCHAR2(255)               -- Location of the winery
);

-- --------------------------------------------
-- Create Table: ClimateData
-- This table stores climate-related data such as temperature, humidity, and rainfall
-- --------------------------------------------
CREATE TABLE ClimateData (
    ClimateData_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for ClimateData
    Year INTEGER NOT NULL,                   -- Year of the data
    Temperature DECIMAL(5, 2),               -- Average temperature
    Humidity DECIMAL(5, 2),                  -- Humidity level
    Rainfall DECIMAL(5, 2),                  -- Rainfall amount
    Season VARCHAR2(50)                      -- Season of the data
);

-- --------------------------------------------
-- Create Table: ProductionProcess
-- This table stores the production process, including aging and fermentation
-- --------------------------------------------
CREATE TABLE ProductionProcess (
    ProductionProcess_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for ProductionProcess
    AgingMethod_ID VARCHAR2(10),                   -- Foreign Key linking to AgingMethod
    FermentationProcess_ID VARCHAR2(10),           -- Foreign Key linking to FermentationProcess
    FOREIGN KEY (AgingMethod_ID) REFERENCES AgingMethod(AgingMethod_ID),
    FOREIGN KEY (FermentationProcess_ID) REFERENCES FermentationProcess(FermentationProcess_ID)
);

-- --------------------------------------------
-- Create Table: AgingMethod
-- This table stores the different aging methods used in the winemaking process
-- --------------------------------------------
CREATE TABLE AgingMethod (
    AgingMethod_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for AgingMethod
    Type VARCHAR2(50) NOT NULL,              -- Type of aging method
    Aging_Duration INTEGER                   -- Duration of aging in months
);

-- --------------------------------------------
-- Create Table: FermentationProcess
-- This table stores the fermentation process details, such as yeast type and temperature
-- --------------------------------------------
CREATE TABLE FermentationProcess (
    FermentationProcess_ID VARCHAR2(10) PRIMARY KEY, -- Primary Key for FermentationProcess
    Temperature DECIMAL(5, 2),                       -- Fermentation temperature
    YeastType VARCHAR2(50),                          -- Type of yeast used
    Duration INTEGER                                 -- Duration of the fermentation process in days
);

-- --------------------------------------------
-- Sample Data Insertions
-- These INSERT commands populate the tables with realistic sample data for demonstration
-- --------------------------------------------

-- Inserting data into GrapeVariety table
INSERT INTO GrapeVariety (GrapeVariety_ID, Name, Description) VALUES 
('GV01', 'Merlot', 'Rich and fruity'),
('GV02', 'Cabernet Sauvignon', 'Bold with a strong finish'),
('GV03', 'Pinot Noir', 'Light and delicate'),
('GV04', 'Chardonnay', 'Buttery with a hint of oak'),
('GV05', 'Sauvignon Blanc', 'Crisp and fresh'),
('GV06', 'Syrah', 'Spicy and full-bodied'),
('GV07', 'Zinfandel', 'Sweet and jammy'),
('GV08', 'Riesling', 'Sweet with high acidity'),
('GV09', 'Malbec', 'Rich and dark'),
('GV10', 'Grenache', 'Fruity and spicy');

-- Inserting data into SoilComposition table
INSERT INTO SoilComposition (SoilComposition_ID, Type, PH_Level) VALUES 
('SC01', 'Sandy Loam', 6.5),
('SC02', 'Clay', 5.8),
('SC03', 'Loam', 6.0),
('SC04', 'Silty Clay', 6.3),
('SC05', 'Gravelly Loam', 6.1),
('SC06', 'Peat', 5.5),
('SC07', 'Sandstone', 6.2),
('SC08', 'Shale', 5.9),
('SC09', 'Volcanic Ash', 6.8),
('SC10', 'Limestone', 7.2);

-- Inserting data into Winery table
INSERT INTO Winery (Winery_ID, Name, Location) VALUES 
('W01', 'Hunter Valley Winery', 'Hunter Valley'),
('W02', 'Barossa Vineyards', 'Barossa Valley'),
('W03', 'Margaret River Estate', 'Margaret River'),
('W04', 'Clare Valley Wines', 'Clare Valley'),
('W05', 'Coonawarra Winery', 'Coonawarra'),
('W06', 'Yarra Valley Wines', 'Yarra Valley'),
('W07', 'Mornington Peninsula Estate', 'Mornington Peninsula'),
('W08', 'McLaren Vale Cellars', 'McLaren Vale'),
('W09', 'Tamar Valley Wines', 'Tamar Valley'),
('W10', 'Great Southern Vineyards', 'Great Southern');

-- Inserting data into ClimateData table
INSERT INTO ClimateData (ClimateData_ID, Year, Temperature, Humidity, Rainfall, Season) VALUES 
('CD01', 2022, 25.3, 60.0, 200, 'Summer'),
('CD02', 2021, 23.7, 55.2, 180, 'Autumn'),
('CD03', 2020, 24.5, 58.0, 190, 'Spring'),
('CD04', 2019, 26.1, 62.0, 210, 'Winter'),
('CD05', 2018, 24.8, 59.0, 185, 'Summer'),
('CD06', 2017, 22.9, 57.5, 175, 'Autumn'),
('CD07', 2016, 23.5, 60.2, 205, 'Winter'),
('CD08', 2015, 25.7, 63.0, 215, 'Spring'),
('CD09', 2014, 24.1, 58.8, 195, 'Summer'),
('CD10', 2013, 23.0, 56.5, 170, 'Autumn');

-- Inserting data into ProductionProcess table
INSERT INTO ProductionProcess (ProductionProcess_ID, AgingMethod_ID, FermentationProcess_ID) VALUES 
('PP01', 'AM01', 'FP01'),
('PP02', 'AM02', 'FP02'),
('PP03', 'AM03', 'FP03'),
('PP04', 'AM04', 'FP04'),
('PP05', 'AM05', 'FP05'),
('PP06', 'AM01', 'FP06'),
('PP07', 'AM02', 'FP07'),
('PP08', 'AM03', 'FP08'),
('PP09', 'AM04', 'FP09'),
('PP10', 'AM05', 'FP10');

-- Inserting data into AgingMethod table
INSERT INTO AgingMethod (AgingMethod_ID, Type, Aging_Duration) VALUES 
('AM01', 'Oak Barrel', 12),
('AM02', 'Stainless Steel', 8),
('AM03', 'Concrete Tank', 10),
('AM04', 'Amphora', 14),
('AM05', 'Glass Jar', 6),
('AM06', 'Clay Pot', 9),
('AM07', 'Oak Cask', 11),
('AM08', 'Stainless Steel Tank', 7),
('AM09', 'Terracotta', 13),
('AM10', 'Plastic Container', 5);

-- Inserting data into FermentationProcess table
INSERT INTO FermentationProcess (FermentationProcess_ID, Temperature, YeastType, Duration) VALUES 
('FP01', 28.5, 'Yeast A', 14),
('FP02', 22.3, 'Yeast B', 10),
('FP03', 26.7, 'Yeast C', 12),
('FP04', 24.0, 'Yeast D', 15),
('FP05', 25.1, 'Yeast E', 13),
('FP06', 29.2, 'Yeast F', 9),
('FP07', 27.8, 'Yeast G', 11),
('FP08', 23.5, 'Yeast H', 8),
('FP09', 24.9, 'Yeast I', 12),
('FP10', 26.2, 'Yeast J', 10);

-- Inserting data into Wine table
INSERT INTO Wine (Wine_ID, GrapeVariety_ID, SoilComposition_ID, Winery_ID, ClimateData_ID, ProductionProcess_ID, Quality, Fixed_Acidity, Volatile_Acidity, Citric_Acid, Residual_Sugar, Chlorides, Free_Sulfur_Dioxide, Total_Sulfur_Dioxide, Density, PH, Sulphates, Alcohol) VALUES 
('WINE01', 'GV01', 'SC01', 'W01', 'CD01', 'PP01', 7.5, 7.4, 0.70, 0.00, 1.9, 0.076, 11, 34, 0.9978, 3.51, 0.56, 9.4),
('WINE02', 'GV02', 'SC02', 'W02', 'CD02', 'PP02', 8.2, 7.8, 0.88, 0.00, 2.6, 0.098, 25, 67, 0.9968, 3.20, 0.68, 9.8),
('WINE03', 'GV03', 'SC03', 'W03', 'CD03', 'PP03', 6.8, 7.6, 0.65, 0.01, 1.8, 0.072, 14, 45, 0.9972, 3.40, 0.54, 10.2),
('WINE04', 'GV04', 'SC04', 'W04', 'CD04', 'PP04', 7.9, 7.1, 0.72, 0.00, 2.0, 0.080, 19, 56, 0.9969, 3.25, 0.60, 11.0),
('WINE05', 'GV05', 'SC05', 'W05', 'CD05', 'PP05', 8.5, 7.5, 0.80, 0.02, 2.3, 0.084, 12, 30, 0.9974, 3.48, 0.58, 10.4),
('WINE06', 'GV06', 'SC06', 'W06', 'CD06', 'PP06', 7.0, 7.9, 0.75, 0.01, 2.1, 0.070, 15, 40, 0.9971, 3.50, 0.55, 10.6),
('WINE07', 'GV07', 'SC07', 'W07', 'CD07', 'PP07', 6.5, 7.3, 0.78, 0.00, 1.7, 0.075, 10, 25, 0.9976, 3.45, 0.52, 9.5),
('WINE08', 'GV08', 'SC08', 'W08', 'CD08', 'PP08', 8.0, 7.7, 0.82, 0.00, 2.4, 0.077, 20, 50, 0.9965, 3.35, 0.62, 11.2),
('WINE09', 'GV09', 'SC09', 'W09', 'CD09', 'PP09', 7.4, 7.2, 0.85, 0.01, 1.5, 0.073, 17, 42, 0.9973, 3.30, 0.59, 9.9),
('WINE10', 'GV10', 'SC10', 'W10', 'CD10', 'PP10', 8.8, 7.9, 0.90, 0.00, 2.7, 0.080, 22, 60, 0.9962, 3.22, 0.65, 12.0);

--SELECT Query

SELECT * FROM GrapeVariety;
SELECT * FROM SoilComposition;
SELECT * FROM Winery;
SELECT * FROM ClimateData;
SELECT * FROM FermentationProcess;
SELECT * FROM AgingMethod;
SELECT * FROM ProductionProcess;
select * from Wine;


-- --------------------------------------------
-- Demonstrating DML Commands: UPDATE, ALTER, DROP
-- --------------------------------------------

-- Example of an UPDATE command to modify alcohol content for a specific wine
UPDATE Wine 
SET Alcohol = 10.0 
WHERE Wine_ID = 'WINE01';

-- Example of an ALTER command to add a description column to the Wine table
ALTER TABLE Wine 
ADD Wine_Description VARCHAR2(255);

-- Example of a DROP command to remove the FermentationProcess table
DROP TABLE FermentationProcess;

-- --------------------------------------------
-- SQL Queries: Simple, Moderately Complex, and Complex Queries
-- --------------------------------------------

-- Simple Query 1: Retrieve wine quality and pH level for wines with pH between 3.0 and 3.5, and quality greater than or equal to 7
SELECT Wine.Quality, Wine.PH 
FROM Wine
WHERE Wine.PH BETWEEN 3.0 AND 3.5
  AND Wine.Quality >= 7;

-- Simple Query 2: Retrieve sulphate and alcohol levels for wines with sulphates greater than 0.6 and alcohol less than 12
SELECT Wine.Sulphates, Wine.Alcohol 
FROM Wine
WHERE Wine.Sulphates > 0.6
  AND Wine.Alcohol < 12;

-- Moderately Complex Query: 
-- Retrieve the name of the grape variety, wine quality, and winery location by joining the Wine, GrapeVariety, and Winery tables
SELECT GrapeVariety.Name AS Grape_Variety, Wine.Quality, Winery.Location 
FROM Wine
LEFT JOIN GrapeVariety ON Wine.GrapeVariety_ID = GrapeVariety.GrapeVariety_ID
LEFT JOIN Winery ON Wine.Winery_ID = Winery.Winery_ID;

-- Complex Query: 
-- Retrieve wines where the alcohol content is greater than the average alcohol content of all wines (demonstrates subquery usage)
SELECT Wine.Alcohol, Wine.Quality
FROM Wine
WHERE Wine.Alcohol > (SELECT AVG(Wine.Alcohol) FROM Wine);

-- --------------------------------------------
-- End of SQL Script
-- This script covers table creation, data insertion, and query execution
-- With these queries, the project fulfills the requirement of SQL query use cases,
-- including simple, moderately complex, and complex queries.
-- --------------------------------------------

