# Movie Recommendation
<br />

### Purpose
_____________________________________
We chose to build a model to recommend movies that you may never have heard of. We collected data and filtered by the revenue and budget to find lesser known movies to recommend. We wanted to offer a service that instead of showing all of the same movies, we wanted to recommend ones you may have never heard of. 

<br />

### Our ETL Process
_____________________________________
We found our data in a couple different places. We originally were just going to use the Kaggle set, but it did not include revenue in it, so we would have a harder time distinguishing obscure from mainstream. The second MovieLens dataset included both the budget and revenues, and was easily merged with our other datasets.

While exploring the data, we encountered some unusable data in the CSVs that had to be dealt with. In the movies metadata CSV, there were several columns that had more than 75% null values. Because they would not offer any significant information to our model, they were dropped. There were also several columns that had JSON type data. The genres we were able to extract and put into a useable format, but the others would not have been valuable to our model, so they were dropped as well. We also had an issue with our movies metadata csv, where some of the rows were not exported correctly, so half of the line was shifted to a new line. Those lines were dropped, as there were only 6 in the 45,000 that were affected.

Cleaning the data was where I spent the majority of my time. The IMDB id in the movies metadata had two leading t's that needed to be dropped in order to join it with the other tables. I did a string replace for loop to get that data useable. I also did that for the titles and the tags data to get rid of commas that would mess with importing the CSVs into our database. We also had to deal with duplicates in the movies metadata CSV, there were several duplicated movie ids. 

Those were all dropped. The most difficult part of the cleaning was extracting the multiple genres from their column. They were all stored in a JSON type data, and we dealt with them in 2 different ways. The first way was using regex to extract the genres and store them in a list. The second way we dealt with it was to use for loops to index into the list and get the genre. The issue with using the for loops is that it created a Dataframe with multiple indexes, and a row for each genre that applied to each movie. After I got the Dataframe, I One Hot Encoded it to split out the genres into their own columns, then grouped by the index calling all the genre columns. This did 2 things. Not only did it allow me to make sure they were split out correctly, if there was a number other than 1 or 0 I would know it had not been preformed correctly, but it also allowed me to easily see what movies belonged in what genres. 

Once the data was to this stage, we imported it into an AWS Database. This had a couple challenges because of the nature of the data. Several of the tables had full sentences, quotes, apostrophes, etc. so the standard importing characters could not be used. I kept the comma as the delimiter as we were working with CSVs, but changed the quote to '^' and the escape to '*' as neither were used in the datasets. After we successfully imported the data into the database, we joined the genres table with the movies metadata table. After getting my group members connected to the database, it was ready to move onto the next stage.

<br />

### Our Machine Learning Process
_____________________________________
For movie recommendations, the most common model used is KMeans for grouping our dataset into clusters. We also toyed with implementing a DBSCAN model for detecting outliers. KNearestNeighbors was used in tandem with DBSCAN to help optimize the model. 

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

<br />

### Resources
_____________________________________
- MovieLens Dataset
    - http://grouplens.org/datasets/
- Kaggle Dataset
    - https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=credits.csv
