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

For the machine learning portion, as stated earlier, I knew that K-Means was what most popular model to use for categorizing movies. Despite this fact, I researched other clustering models that could've been useful. I first started off with the DBSCAN which stands for Density-Based Spatial Clustering for Application with Noise. This model both excels at finding outliers as well as clustering nested data. Unfortunately for us, we quickly realized the shape of our data would affect how our models performed. Our data was largely skewed in one direction in the shape of a column, with a much smaller portion of the data set spreading out from there. This will be explained later. As you can see, the DBSCAN model had a hard time grouping our data due to its shape.
_______________________________________________
![DBSCAN](https://github.com/bhstarkey/Movie_Recommendation_Final/blob/7007ff3fe651e27c00389454c06e90ab7dc3911a/Resources/Images/dbscan_plot.PNG)

Next, I tried using the MeanShift model. This model is another centroid based algorithm that aims to find 'blobs' in the data, which it works by updating candidates for centroids to be the mean of points in a given region. Once the model was plotted, we can see that it performed alright in the dense region, but falls apart in the middle of our plot.
_______________________________________________
![MeanShift](https://github.com/bhstarkey/Movie_Recommendation_Final/blob/3c4d54d4a160ed6726e8e926f261fbba8d044cd8/Resources/Images/meanshift_plot.PNG)

Lastly, I worked with the KMeans model. The KMeans model tries to separate data in n groups  of equal variance while trying to minimize its within-cluster sum-of-squares(inertia). I started out by plotting an elbow curve to determine the number of clusters to start with. 
_______________________________________________
![KMeans Elbow Plot](https://github.com/bhstarkey/Movie_Recommendation_Final/blob/7007ff3fe651e27c00389454c06e90ab7dc3911a/Resources/Images/kmeans_elbow_curve.PNG)

I then used that number on the KMeans model and plotted the results. This model performed the best, by far, compared to our other options. Had the data been less skewed, the plot might've looked even better. I tried a few different column names to see how that changed the scatter plot. 
_______________________________________________
![Popularity, Revenue](https://github.com/bhstarkey/Movie_Recommendation_Final/blob/7007ff3fe651e27c00389454c06e90ab7dc3911a/Resources/Images/kmeans_scatter_pop.PNG)
_______________________________________________
![Rating, Revenue](https://github.com/bhstarkey/Movie_Recommendation_Final/blob/7007ff3fe651e27c00389454c06e90ab7dc3911a/Resources/Images/kmeans_scatter_rating.PNG)
_______________________________________________
![KMeans](https://github.com/bhstarkey/Movie_Recommendation_Final/blob/7007ff3fe651e27c00389454c06e90ab7dc3911a/Resources/Images/kmeans_3d.PNG)

 We used the labels created by our KMeans model to be used for grouping in our next section.

As mentioned earlier, the shape of our data was skewed. We found that a majority of the 'budget' column in our dataframe was 0 for most movies, while other movies had budgets in the hundreds of millions. We learned that, in hollywood, any movie with a budget less than $3 million is considered unsubstantial, leaving a lot of movies with a budget of 0.
<br />
### Our Web Application
_____________________________________
#### Preprocessing
_____________________________________
After the model was successfully built, the next step was to prepare the results to be visualized publically.  
We first started by adding back the `['Release_Date']` column, as well as drop all columns that may not be useful for the user. Then the genre columns were un-encoded and added to a single column. The entire dataset was filtered only include the group `0`, which we determined to be most in line the goal of our model.  
_____________________________________
#### Building the Web Application  
_____________________________________
For the web application, we found a pre-built `html` and `css` template with a free license that we could modify to suit our needs without having to build from the ground up. After tailoring the website to our project, we built a table in `html` that would house the data output from the model, as well as a column of radio buttons that would allow the user to filter by genre.  
![Alt text](Resources/Images/html_table.png)
_____________________________________
![Alt text](Resources/Images/html_buttons.png)
_____________________________________
We then built a JavaScript file that would allow the radio buttons to filter by genre. To do this, we used the `d3.js` library to build the table from the model's output .csv file. Every button had the corresponding genre as its `id`, so when the button was clicked, the `d3.js` code would add the corresponding `id` to a list and trigger a function that would filter the table by that genre. The function activated any time a button was either *"checked"* or *"unchecked"*, and would run an `if/else` statement to check if the genre in the list built from the button id's was also in the genre column of the table rows. If the genre of the films matched the `id` (and therefore genres) of the buttons pressed, the film would be displayed.  
![Alt text](Resources/Images/JavaScript_genreFilter.png)
_____________________________________
By far the biggest challenge was to filter multiple genres. Eventually (with outside help) we were able to get it to work.<br>

### With More Time
_____________________________________
With less than a month to come up with then execute a project that would reflect everything we learned, there were several things that we wanted to explore more with our project given the time. One of the datasets available to us had several keywords for each movie. We could have improved the functionality and usability of our model by creating a kind of search engine for the movies, where given the users input of descriptions of movies they like, we would recommend them a movie. We also would have liked to add a way for them to rate other movies and based off of their ratings recommend similar. Another feature we would have like to add would allow a user to customize their recommendations more by filtering out or including foreign films, animated films, or by release date.

To fix our skewed data, we could've built a python script that prompted google for movie titles with a budget of zero and then scraped the webpage for the answer. With that information, we could've analyzed the new shape of the data, and potentially have dropped more outliers(popular movies). 

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
