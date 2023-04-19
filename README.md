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
For movie recommendations, the most common model used is KMeans for grouping our dataset into clusters. This was by far the most popular model that I saw recommended over several articles. Despite this, I tried out a few other models to gauge performance. Before trainging models, there was a good deal of analysis that had to take place. Diving deeper into our data, I noticed there were several columns that needed some filtering. 

The first column I took a look at was the 'Video' column. The title of the column caught my attention, since the dataset was supposed to only contain movies. I filtered the column by True and found out our dataset contained a small amount of documentaries, tv shows, and even a video game cut scene. I filtered the 'Video' column to just include the rows containing False, then dropped the column.

The next column I took a look at was the 'Status' column. I wondered why the column existed as I assumed the data set only contained released movies. Upon inspection, the 'Status' column contained a few hundred rows of non-released movies. I filtered by only released movies, then dropped the column.

Afterwards, I dropped all columns that would not be helpful for machine learning, such as the 'Title', 'Id', and 'Imdb_id' columns. I then changed the data type of the 'Adult' column, which was a boolean, to object for encoding. The last thing to do with the columns was encode the 'Adult' and 'Original_Language' columns using Pandas.get_dummies() method. 

Finally, I checked the dataframe for null values and found that there were a good deal of null values in the split up genre columns. To remedy this, I called .fillna(0) to fill the null values with 0. 

For the machine learning portion, as stated earlier, I knew that K-Means was what most popular model to use for categorizing movies. Despite this fact, I researched other clustering models that could've been useful. I first started off with the DBSCAN which stands for Density-Based Spatial Clustering for Application with Noise. This model both excels at finding outliers as well as clustering nested data. Unfortunately for us, we quickly realized the shape of our data would affect how our models performed. Our data was largely skewed in one direction in the shape of a column, with a much smaller portion of the data set spreading out from there. This will be explained later.

Next, I tried using the MeanShift model. This model is another centroid based algorithm that aims to find 'blobs' in the data, which it works by updating candidates for centroids to be the mean of points in a given region. Once the model was plotted, we can see that it performed alright in the dense region, but falls apart in the middle of our plot.

Lastly, I worked with the KMeans model. The KMeans model tries to separate data in n groups  of equal variance while trying to minimize its within-cluster sum-of-squares(inertia). I started out by plotting an elbow curve to determine the number of clusters to start with. 

I then used that number on the KMeans model and plotted the results. This model performed the best, by far, compared to our other options. Had the data been less skewed, the plot might've looked even better. 

We used the labels created by our KMeans model to be used for grouping in our next section.
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
        - sklearn
        - plotly.express
        - hvplot.pandas
        - ast's literal_eval
- AWS Postgres SQL Database
