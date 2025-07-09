WITH base AS (
    SELECT *
    FROM {{ source('raw', 'cust_az12') }}
),

transformed AS (
    SELECT
        -- Remove 'NAS' prefix if present
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
            ELSE cid
        END AS cid,

        -- Set future birthdates to NULL
        CASE
            WHEN bdate > CURRENT_DATE THEN NULL
            ELSE bdate
        END AS bdate,

        -- Normalize gender values
        CASE
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END AS gen

    FROM base
)

SELECT *
FROM transformed
