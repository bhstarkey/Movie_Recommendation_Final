console.log('working')
const url = "https://github.com/bhstarkey/Movie_Recommendation_Final/blob/main/Website_Rough_Code/Website/assets/resources/movie_test.csv"
localFile = "assets/resources/movie_df_for_website.csv"
loadCSV();
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
};

function loadCSV() {
  d3.csv(localFile).then((data) => {
    var checked = d3.selectAll(".myCheckbox");
    var genreCol = data.map((row) => row.genre.split(" "));
    if (checked.property("checked")) {buildFilters(), console.log("checked")}
    else {buildTable(data), "unchecked"};
    
    function buildFilters() {
      // console.log(data);
      let trueFilter = [];
      let temp = [...data];
      // console.log(temp);
      genreFilters.forEach(attr => { // Iterate through genre filters.
        //console.log(attr);
        temp = temp.filter(obj => obj.genre.includes(attr)) // Filter on each genre chosen.
        //console.log(temp);
      });
      trueFilter = [...temp];

      console.log(trueFilter);
      var falseFilter = data.filter((x) => !x.genre.includes(genreFilters));
      if (trueFilter) {buildTable(trueFilter),console.log("got it", trueFilter);}
      if (falseFilter) {console.log("nope", falseFilter);}
    }

    var genreFilters = [];
    d3.selectAll(".myCheckbox").on("change", function() {
      if (this.checked) {
        genreFilters.push(this.id);
        console.log(genreFilters);
        buildFilters();
      }
      else {let index = genreFilters.indexOf(this.id);
          if (index > -1) {
            genreFilters.splice(index, 1);
          };
          console.log(genreFilters);
          buildFilters();
      };
        });
      
})};
