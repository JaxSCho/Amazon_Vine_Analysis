# Amazon Vine Analysis
## Project Overview

The Amazon Vine program is a service that allows manufacturers and publishers to receive reviews for their products. Companies like SellBy pay a small fee to Amazon and provide products to Amazon Vine members, who are then required to publish a review. This report will analyze Amazon reviews written by members of the paid Amazon Vine program in the Office Products dataset to determine if there is any bias towards favorable reviews from Vine members. 
## Results
### Performing ETL on Amazon Product Reviews

Using PySpark via Google Collab, we performed the following ETL process to create the tables needed to determine if there is any bias towards reviews for office products that were written as part of the Vine program: 

1. Created an AWS RDS database with tables in pgAdmin, picked the [office products dataset](https://s3.amazonaws.com/amazon-reviews-pds/tsv/amazon_reviews_us_Office_Products_v1_00.tsv.gz) from the Amazon review datasets, and extract the dataset into a DataFrame 

2. Transformed the DataFrame into four separate DataFrames that match the table schema in pgAdmin --
    - customers_table
    - products_table
    - review_id_table
    - vine_table

3. Uploaded the transformed data into the appropriate tables and ran queries in pgAdmin to confirm that the data has been uploaded

### Determine Bias of Vine Reviews

We determined if having a paid Vine review makes a difference in the percentage of 5-star reviews using various SQL queries of the transformed [vine_table dataset](/vine_table.csv). Figure 1 displays the total number of reviews, the number of 5-star reviews, and the percentage of 5-star reviews for the two types of review (paid vs unpaid).

![image](https://user-images.githubusercontent.com/99936542/174420278-2e9e4fb4-dbe5-4f7c-aac9-f8bdc69ee9c4.png)

<b>Fig.1 - Percentage of 5-star Reviews for Office Products by Review Type (Vine vs non-Vine)</b> 

- There were 969 Vine and 43,745 non-Vine reviews in this dataset.
- There were 430 Vine and 19,233 non-Vine reviews were 5 stars in this dataset.
- 44.4% (430/969) of the Vine reviews were 5 stars while 44.0% (19,233/43,745) of non-Vine reviews were 5 stars.
## Summary

In summary, it appears that there could be a slight positivity bias for reviews in the Vine program in the office products dataset since the percentage of 5-star Vine reviews is 0.4% higher than the percentage of 5-star non-Vine reviews (i.e., 44.4% vs 44.0% respectively). To determine if the 0.4% difference between the percentage of 5-star Vine reviews vs 5-star non-Vine reivews is significant, we could perform a 2-sample z-test of proportion hypothesis test. The null hypothesis would be that there is no difference between the proportion of 5-star Vine reviews vs 5-star non-Vine reviews. 

![image](https://user-images.githubusercontent.com/99936542/174519925-f02595a2-7b8c-4013-9834-ca697585b7c8.png)

<b>Fig.2 - 2-sample z-test Results </b> 

Since the p-value = 0.8249 is above our significance level of 0.05 (see in Figure 2 above), we do not have sufficient evidence to reject the null hypothesis. Therefore, the proportion of 5-star Vine reviews vs 5-star non-Vine reviews are statistically similar at the 95% significance level and state that there is no positivity bias for reviews in the Vine program.   
 
## Resources
- Data Sources: [office products dataset](https://s3.amazonaws.com/amazon-reviews-pds/tsv/amazon_reviews_us_Office_Products_v1_00.tsv.gz), vine_table.csv
- Software: AWS RDS instance, PySpark via Google Collab, PostgreSQL, pgAdmin, R studio