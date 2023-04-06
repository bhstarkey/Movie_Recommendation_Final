# Movie_Recommendation_Final

### Our ETL Process
_____________________________________
We gathered our data from a couple different sources to get data about different movies, as well as their budget and revenue information. For the smaller, less known movies, their revenue and budget data was 0, indicating either that they did not meet the threshold for budget reporting, or that there was not any data for that movie.

The data was relatively clean, with a couple exceptions. There were a couple columns that had a large amount of null values, or had JSON type data stored in the column. There were also several rows that were not formatted correctly, and had the title start the row, instead of the boolean value for adult. 


### Our Machine Learning Process
_____________________________________
For movie recommendations, the most common model used is KMeans for grouping our dataset into clusters. We also toyed with implementing a DBSCAN model for detecting outliers. KNearestNeighbors was used in tandem with DBSCAN to help optimize the model. 


### Resources
_____________________________________
- MovieLens Dataset
    - http://grouplens.org/datasets/
- Kaggle Dataset
    - https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=credits.csv
