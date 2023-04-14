console.log('working')
var tbody = d3.select("tbody");
function buildTable(data) {
    tbody.html("");
    data.forEach((dataRow) => {
        var row = tbody.append("tr");
        Object.values(dataRow).forEach((val) => {
            var cell = row.append("td");
            cell.text(val);
        });
    });
}
var genre = ['action','adventure','animation','comedy','crime','documentary','drama','family','fantasy','history','horror','music','mystery','romance','science fiction','tv movie','thriller','war','western'];
var genreValue = [];
d3.selectAll("input").on("click", function() {
  if (this.input.checked) {
    console.log("checked");
  }
  else {
    console.log("unchecked");
  }
});
// var checkboxID = checkboxActive.attr("id");
// var checkboxActive = myCheckbox.property(".active", true).attr("id");
function updateTable(data) {
      data.filter((x) => {
      return x.genre.includes(genreValue);
    });
  };
  

  d3.csv("assets/resources/movie_test.csv").then(function(data) {

    buildTable(data);
    console.log(genreValue);
});
    // genreFilter.sort((a, b) => {
    //   return d3.descending(a.vote_average, b.vote_average)
    // });
//   })
// })
// V2______________________________________________________________
// var checkboxChange = d3.selectAll(".myCheckbox");
// var genreFilters = [];
// function updateFilter() {
//   // var genre = ['action','adventure','animation','comedy','crime','documentary','drama','family','fantasy','history','horror','music','mystery','romance','science fiction','tv movie','thriller','war','western'];
//   let elementChanged = checkboxChange.property("checked");
//   // let elementValue = elementChanged.property("value");
//   let elementID = elementChanged.attr("id");
//   if (elementChanged) {
//     genreFilters.push(elementID)
//   } else {
//     delete genreFilters.pop(elementID);
//   };
//   filterTable();
// };

// function update() {
//   if(d3.select("#myCheckbox").property("checked")) {
//     filterByGenre(buildTable(data));
// } else {
//     buildTable(data);
// }}

// function filterTable() {
//   if (genreFilters.length > 0) {
//     filterData.filter((x) => {
//     return x.genre.includes(genre)})}
//       else {buildTable(data)
//         }
// };

//   // START of function for filtering table by genre
//______________________________________________________________

// d3.csv("assets/resources/movie_df_for_website.csv").then(function(data) {
//     var headerRow = Object.keys(data[0]);
//     var action = 'action'
//     var genreFilter = data.filter((x) => {
//        return x.genre.includes(action);
//     });
//     genreFilter.sort((a, b) => {
//         return d3.descending(a.vote_average, b.vote_average)
//     });
//     console.log(headerRow);
//     console.log(genreFilter)
//     console.log(data[0]);
// }));
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
