# Movie Recommendation
<br />

### Purpose
_____________________________________
We chose to build a model to recommend movies that you may never have heard of. We collected data and filtered by the revenue and budget to find lesser known movies to recommend. We wanted to offer a service that instead of showing all of the same movies, we wanted to recommend ones you may have never heard of. 

<br />

### Our ETL Process
_____________________________________
We found our data in a couple different places. We originally were just going to use the Kaggle set, but it did not include revenue in it, so we would have a harder time distinguishing obscure from mainstream. The second MovieLens dataset included both the budget and revenues, and was easily merged with our other datasets as they both came from IMDB.

While exploring the data, we encountered some unusable data in the CSVs that had to be dealt with. In the movies metadata CSV, there were several columns that had more than 75% null values. <br /> ![original_data](https://user-images.githubusercontent.com/116474586/232959853-ec4e6d22-6f7e-427d-a854-1985228c65d2.png) <br />
Because they would not offer any significant information to our model, they were dropped. There were also several columns that had JSON type data. The genres we were able to extract and put into a useable format, but the others would not have been valuable to our model, so they were dropped as well. <br /> ![first_rows_original_data](https://user-images.githubusercontent.com/116474586/232959941-6165d2e2-1b4c-489d-b8e9-d68049de54d2.png)![last_columns_original_data](https://user-images.githubusercontent.com/116474586/232959963-6a091029-4e29-4283-a624-7149c366c586.png)
<br />
We also had an issue with our movies metadata csv, where some of the rows were not exported correctly, so half of the line was shifted to a new line. Those lines were dropped, as there were only 6 in the 45,000 that were affected.

Cleaning the data was where I spent the majority of my time. The IMDB id in the movies metadata had two leading t's that needed to be dropped in order to join it with the other tables. <br /> ![cleaning_imdb_id](https://user-images.githubusercontent.com/116474586/232960059-4f4b65ba-12b4-4a98-920e-eac4f6c978d2.png) <br />
I did a string replace for loop to get that data useable. I also did that for the titles and the tags data to get rid of commas that would mess with importing the CSVs into our database. We also had to deal with duplicates in the movies metadata CSV, there were several duplicated movie ids. Those were all dropped. 

The most difficult part of the cleaning was extracting the multiple genres from their column. They were all stored in a JSON type data, and we dealt with them in 2 different ways. The first way was using regex to extract the genres and store them in a list. <br /> ![regex_for_genres](https://user-images.githubusercontent.com/116474586/232960139-fc95f4e0-c1db-41ca-a88d-e5bb6ee2d7dc.png) <br />
 The second way we dealt with it was to use for loops to index into the list and get the genre. The issue with using the for loops is that it created a Dataframe with multiple indexes, and a row for each genre that applied to each movie. <br /> ![for_loop_genres](https://user-images.githubusercontent.com/116474586/232960189-cb3bc365-2f6c-41e4-aad3-02d0b2b84567.png) <br />
After I got the Dataframe, I One Hot Encoded it to split out the genres into their own columns, then grouped by the index calling all the genre columns. This did 2 things. Not only did it allow me to make sure they were split out correctly, if there was a number other than 1 or 0 I would know it had not been preformed correctly, but it also allowed me to easily see what movies belonged in what genres. 

Once the data was to this stage, we imported it into an AWS Database. This had a couple challenges because of the nature of the data. Several of the tables had full sentences, quotes, apostrophes, etc. so the standard importing characters could not be used. I kept the comma as the delimiter as we were working with CSVs, but changed the quote to '^' and the escape to '*' as neither were used in the datasets. <br /> ![postgres_importing_data_options](https://user-images.githubusercontent.com/116474586/232960363-74a09d50-0efe-4eb9-9093-119b0119989d.png) <br />
After we successfully imported the data into the database, we joined the genres table with the movies metadata table. After getting my group members connected to the database, it was ready to move onto the next stage.

<br />

### Our Machine Learning Process
_____________________________________
For movie recommendations, the most common model used is KMeans for grouping our dataset into clusters. This was by far the most popular model that I saw recommended over several articles. Despite this, I tried out a few other models to gauge performance.  

<br />

### With More Time
_____________________________________
With less than a month to come up with then execute a project that would reflect everything we learned, there were several things that we wanted to explore more with our project given the time. One of the datasets available to us had several keywords for each movie. We could have improved the functionality and usability of our model by creating a kind of search engine for the movies, where given the users input of descriptions of movies they like, we would recommend them a movie. We also would have liked to add a way for them to rate other movies and based off of their ratings recommend similar. Another feature we would have like to add would allow a user to customize their recommendations more by filtering out or including foreign films, animated films, or by release date.

<br />

### Resources
_____________________________________
- MovieLens Dataset
    - http://grouplens.org/datasets/
- Kaggle Dataset
    - https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=credits.csv

<br />

### Technology
_____________________________________
- Python version 3.7
    - Libraries used:
        - pandas
        - re (regex)
        - sklearn preprocessing
        - ast's literal_eval
        - numpy
- AWS Postgres SQL Database
