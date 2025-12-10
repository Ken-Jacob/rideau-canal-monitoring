-- Stream Analytics query for Rideau Canal Skateway project

WITH AggregatedData AS (
    SELECT
        System.Timestamp AS windowEnd,
        location,
        AVG(iceThicknessCm)      AS avgIceThickness,
        MIN(iceThicknessCm)      AS minIceThickness,
        MAX(iceThicknessCm)      AS maxIceThickness,
        AVG(surfaceTempC)        AS avgSurfaceTemp,
        MIN(surfaceTempC)        AS minSurfaceTemp,
        MAX(surfaceTempC)        AS maxSurfaceTemp,
        MAX(snowAccumulationCm)  AS maxSnowAccumulation,
        AVG(externalTempC)       AS avgExternalTemp,
        COUNT(*)                 AS readingCount
    FROM
        [IoTHubInput]
    GROUP BY
        TUMBLINGWINDOW(minute, 5),
        location
),

WithSafety AS (
    SELECT
        windowEnd,
        location,
        avgIceThickness,
        minIceThickness,
        maxIceThickness,
        avgSurfaceTemp,
        minSurfaceTemp,
        maxSurfaceTemp,
        maxSnowAccumulation,
        avgExternalTemp,
        readingCount,
        CASE
            WHEN avgIceThickness >= 30 AND avgSurfaceTemp <= -2 THEN 'Safe'
            WHEN avgIceThickness >= 25 AND avgSurfaceTemp <=  0 THEN 'Caution'
            ELSE 'Unsafe'
        END AS safetyStatus
    FROM AggregatedData
)

-- Output 1: Cosmos DB
SELECT
    location,
    windowEnd,
    avgIceThickness,
    minIceThickness,
    maxIceThickness,
    avgSurfaceTemp,
    minSurfaceTemp,
    maxSurfaceTemp,
    maxSnowAccumulation,
    avgExternalTemp,
    readingCount,
    safetyStatus,
    -- Document id for Cosmos DB (matches "Document id" = id in output config)
    CONCAT(location, '-',
        CAST(
            DATEDIFF(second, '1970-01-01T00:00:00Z', windowEnd)
            AS nvarchar(max)
        )
    ) AS id
INTO
    [CosmosOutput]
FROM
    WithSafety;

-- Output 2: Blob Storage
SELECT
    location,
    windowEnd,
    avgIceThickness,
    minIceThickness,
    maxIceThickness,
    avgSurfaceTemp,
    minSurfaceTemp,
    maxSurfaceTemp,
    maxSnowAccumulation,
    avgExternalTemp,
    readingCount,
    safetyStatus
INTO
    [BlobOutput]
FROM
    WithSafety;
