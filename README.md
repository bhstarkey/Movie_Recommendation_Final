# Movie Recommendation

### Our ETL Process
_____________________________________
We found our data in a couple different places. We originally were just going to use the Kaggle set, but it did not include revenue in it, so we would have a harder time distinguishing obscure from mainstream. The second MovieLens dataset included both the budget and revenues, and was easily merged with our other datasets.

While exploring the data, we encountered some unusable data in the CSVs that had to be dealt with. In the movies metadata CSV, there were several columns that had more than 75% null values. Because they would not offer any significant information to our model, they were dropped. There were also several columns that had JSON type data. The genres we were able to extract and put into a useable format, but the others would not have been valuable to our model, so they were dropped as well. We also had an issue with our movies metadata csv, where some of the rows were not exported correctly, so half of the line was shifted to a new line. Those lines were dropped, as there were only 6 in the 45,000 that were affected.

Cleaning the data was where I spent the majority of my time. The IMDB id in the movies metadata had two leading t's that needed to be dropped in order to join it with the other tables. I did a string replace for loop to get that data useable. I also did that for the titles and the tags data to get rid of commas that would mess with importing the CSVs into our database. We also had to deal with duplicates in the movies metadata CSV, there were several duplicated movie ids. 

Those were all dropped. The most difficult part of the cleaning was extracting the multiple genres from their column. They were all stored in a JSON type data, and we dealt with them in 2 different ways. The first way was using regex to extract the genres and store them in a list. The second way we dealt with it was to use for loops to index into the list and get the genre. The issue with using the for loops is that it created a Dataframe with multiple indexes, and a row for each genre that applied to each movie. After I got the Dataframe, I One Hot Encoded it to split out the genres into their own columns, then grouped by the index calling all the genre columns. This did 2 things. Not only did it allow me to make sure they were split out correctly, if there was a number other than 1 or 0 I would know it had not been preformed correctly, but it also allowed me to easily see what movies belonged in what genres. 

Once the data was to this stage, we imported it into an AWS Database. This had a couple challenges because of the nature of the data. Several of the tables had full sentences, quotes, apostrophes, etc. so the standard importing characters could not be used. I kept the comma as the delimiter as we were working with CSVs, but changed the quote to '^' and the escape to '*' as neither were used in the datasets. After we successfully imported the data into the database, we joined the genres table with the movies metadata table. After getting my group members connected to the database, it was ready to move onto the next stage.


### Our Machine Learning Process
_____________________________________
For movie recommendations, the most common model used is KMeans for grouping our dataset into clusters. We also toyed with implementing a DBSCAN model for detecting outliers. KNearestNeighbors was used in tandem with DBSCAN to help optimize the model. 


### With More Time
_____________________________________
With less than a month to come up with then execute a project that would reflect everything we learned, there were several things that we wanted to explore more with our project given the time. One of the datasets available to us had several keywords for each movie. We could have improved the functionality and usability of our model by creating a kind of search engine for the movies, where given the users input of descriptions of movies they like, we would recommend them a movie. We also would have liked to add a way for them to rate other movies and based off of their ratings recommend similar. Another feature we would have like to add would allow a user to customize their recommendations more by filtering out or including foreign films, animated films, or by release date.


### Resources
_____________________________________
- MovieLens Dataset
    - http://grouplens.org/datasets/
- Kaggle Dataset
    - https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=credits.csv
