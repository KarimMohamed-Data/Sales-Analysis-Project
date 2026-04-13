COPY    public.company_dim 
FROM    'F:\My Work\Data Analysis\Vs_Code_Projects\csv_files\company_dim.csv'
        DELIMITER ',' CSV HEADER;


COPY    public.job_postings_fact
FROM    'F:\My Work\Data Analysis\Vs_Code_Projects\csv_files\job_postings_fact.csv' 
        DELIMITER ',' CSV HEADER;


COPY    public.skills_dim
FROM    'F:\My Work\Data Analysis\Vs_Code_Projects\csv_files\skills_dim.csv' 
        DELIMITER ',' CSV HEADER;


COPY    public.skills_job_dim 
FROM    'F:\My Work\Data Analysis\Vs_Code_Projects\csv_files\skills_job_dim.csv' 
        DELIMITER ',' CSV HEADER;