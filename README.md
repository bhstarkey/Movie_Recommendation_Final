# Movie_Recommendation_Final

### Our ETL Process
_____________________________________
We found our data in a couple different places. We originally were just going to use the Kaggle set, but it did not include revenue in it, so we would have a harder time distinguishing obscure from mainstream. The second MovieLens dataset included both the budget and revenues, and was easily merged with our other datasets.

While exploring the data, we encountered some unusable data in the CSVs that had to be dealt with. In the movies metadata CSV, there were several columns that had more than 75% null values. Because they would not offer any significant information to our model, they were dropped. There were also several columns that had JSON type data. The genres we were able to extract and put into a useable format, but the others would not have been valuable to our model, so they were dropped as well. We also had an issue with our movies metadata csv, where some of the rows were not exported correctly, so half of the line was shifted to a new line. Those lines were dropped, as there were only 6 in the 45,000 that were affected.

Cleaning the data was where I spent the majority of my time. The IMDB id in the movies metadata had two leading t's that needed to be dropped in order to join it with the other tables. I did a string replace for loop to get that data useable. I also did that for the titles and the tags data to get rid of commas that would mess with importing the CSVs into our database. We also had to deal with duplicates in the movies metadata CSV, there were several duplicated movie ids. Those were all dropped. The most difficult part of the cleaning was extracting the multiple genres from their column. They 


### Our Machine Learning Process
_____________________________________
For movie recommendations, the most common model used is KMeans for grouping our dataset into clusters. We also toyed with implementing a DBSCAN model for detecting outliers. KNearestNeighbors was used in tandem with DBSCAN to help optimize the model. 


### Resources
_____________________________________
- MovieLens Dataset
    - http://grouplens.org/datasets/
- Kaggle Dataset
    - https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=credits.csv
