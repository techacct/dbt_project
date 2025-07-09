WITH base AS (
    SELECT *
    FROM {{ source('raw', 'prd_info') }}
),

transformed AS (
    SELECT
        prd_id,

        -- Extract category ID from first 5 chars and replace '-' with '_'
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,

        -- Extract remaining part of product key
        SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,

        prd_nm,

        -- Replace NULL cost with 0
        COALESCE(prd_cost, 0) AS prd_cost,

        -- Map product line codes to full names
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,

        -- Cast start date
        CAST(prd_start_dt AS DATE) AS prd_start_dt,

        -- Calculate end date as day before next start date
        CAST(
            LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
            AS DATE
        ) AS prd_end_dt

    FROM base
)

SELECT *
FROM transformed
