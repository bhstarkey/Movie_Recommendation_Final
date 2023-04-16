console.log('working')
const url = "https://github.com/bhstarkey/Movie_Recommendation_Final/blob/main/Website_Rough_Code/Website/assets/resources/movie_test.csv"
localFile = "assets/resources/movie_test.csv"
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
}

function loadCSV() {
  d3.csv(localFile).then((data) => {
    buildTable(data);
    
  d3.selectAll("input[name='genre']").on("click", function() {
    var selected = this.id;
    this.classList.toggle("active");
    var trueFilter = data.filter((x) => x.genre.includes(selected));
    buildTable(trueFilter);
    console.log(selected);
    
      });


    // function buildFilters() {
    //   var trueFilter = data.filter((x) => x.genre.includes(selected));
    //   var falseFilter = data.filter((x) => !x.genre.includes(selected));
    //   if (trueFilter) {buildTable(trueFilter),console.log("got it", trueFilter);}
    //   if (falseFilter) {console.log("nope", falseFilter);}
    // }
    
      
      
    
    
})};




