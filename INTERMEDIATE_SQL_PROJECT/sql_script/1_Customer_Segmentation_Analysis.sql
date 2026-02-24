WITH
  -- Step 1: Calculate the Lifetime Value (LTV) for each customer
  customer_ltv AS (
    SELECT
      customerkey,
      cleaned_name,
      SUM(total_net_revenue) AS total_ltv
    FROM
      cohort_analysis
    GROUP BY
      customerkey,
      cleaned_name
  ),
  -- Step 2: Determine the 25th and 75th percentile LTV values for segmentation
  customer_segments AS (
    SELECT
      PERCENTILE_CONT(0.25) WITHIN GROUP (
        ORDER BY
          total_ltv
      ) AS ltv_25th_percentile,
      PERCENTILE_CONT(0.75) WITHIN GROUP (
        ORDER BY
          total_ltv
      ) AS ltv_75th_percentile
    FROM
      customer_ltv
  ),
  -- Step 3: Assign a segment (Low, Mid, High) to each customer
  segment_values AS (
    SELECT
      c.customerkey,
      c.cleaned_name,
      c.total_ltv,
      CASE
        WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low-Value'
        WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2 - Mid-Value'
        ELSE '3 - High-Value'
      END AS customer_segment
    FROM
      customer_ltv c
      CROSS JOIN customer_segments cs
  )
  -- Final Step: Aggregate the results to get a summary for each segment
SELECT
  customer_segment,
  SUM(total_ltv) AS total_ltv,
  SUM(total_ltv) / (
    SELECT
      SUM(total_ltv)
    FROM
      segment_values
  ) AS ltv_percentage,
  COUNT(customerkey) AS customer_count,
  SUM(total_ltv) / COUNT(customerkey) AS avg_ltv
FROM
  segment_values
GROUP BY
  customer_segment
ORDER BY
  total_ltv DESC;

