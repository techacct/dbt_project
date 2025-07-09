WITH base AS (
    SELECT *
    FROM {{ source('raw', 'loc_a101') }}
),

transformed AS (
    SELECT
        -- Remove hyphens from customer ID
        REPLACE(cid, '-', '') AS cid,

        -- Normalize and clean up country codes
        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END AS cntry

    FROM base
)

SELECT *
FROM transformed
