console.log('working')
// START of function for filtering table by genre
//______________________________________________________________

d3.csv("assets/resources/movie_df_for_website.csv").then(function(data) {
    var headerRow = Object.keys(data[0]);
    var action = 'action'
    var genreFilter = data.filter((x) => {
       return x.genre.includes(action);
    });
    genreFilter.sort((a, b) => {
        return d3.descending(a.vote_average, b.vote_average)
    });
    console.log(headerRow);
    console.log(genreFilter);
});
  // function init() {
//     var selector = d3.select("#selDataset");
//     d3.json("Website/assets/resources/website_json.json").then((data) => {
//       var genreNames = data.genre;
//       genreNames.forEach((sample) => {
//         selector
//           .append("option")
//           .text(sample)
//           .property("value", sample);
//       });
  
//       // Use the first sample from the list to build the initial plots
//       var firstGenre = genreNames[0];
//       buildCharts(firstGenre);
//       buildMetadata(firstGenre);
//     });
//   }
//   init();
