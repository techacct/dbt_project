WITH base AS (
    SELECT *
    FROM {{ source('raw', 'px_cat_g1v2') }}
)

SELECT
    id,
    cat,
    subcat,
    maintenance
FROM base
