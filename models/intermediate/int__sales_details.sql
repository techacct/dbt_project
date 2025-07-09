WITH base AS (
    SELECT *
    FROM {{ source('raw', 'sales_details') }}
),

transformed AS (
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        -- Parse and clean order date
        CASE 
            WHEN sls_order_dt = 0 OR LENGTH(CAST(sls_order_dt AS STRING)) != 8 THEN NULL
            ELSE TO_DATE(CAST(sls_order_dt AS STRING), 'YYYYMMDD')
        END AS sls_order_dt,

        -- Parse and clean ship date
        CASE 
            WHEN sls_ship_dt = 0 OR LENGTH(CAST(sls_ship_dt AS STRING)) != 8 THEN NULL
            ELSE TO_DATE(CAST(sls_ship_dt AS STRING), 'YYYYMMDD')
        END AS sls_ship_dt,

        -- Parse and clean due date
        CASE 
            WHEN sls_due_dt = 0 OR LENGTH(CAST(sls_due_dt AS STRING)) != 8 THEN NULL
            ELSE TO_DATE(CAST(sls_due_dt AS STRING), 'YYYYMMDD')
        END AS sls_due_dt,

        -- Calculate sales if missing or inconsistent
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
                THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,

        sls_quantity,

        -- Derive price if missing or invalid
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 
                THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS sls_price

    FROM base
)

SELECT *
FROM transformed
