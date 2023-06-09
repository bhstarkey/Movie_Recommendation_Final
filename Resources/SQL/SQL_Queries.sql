SELECT mm.index,
	mm.adult,
	mm.budget,
	mm.id,
	mm.imdb_id,
	mm.original_language,
	mm.popularity,
	mm.poster_path,
	mm.release_date,
	mm.revenue,
	mm.runtime,
	mm.status,
	mm.title,
	mm.video,
	mm.vote_average,
	mm.vote_count,
	ge.genre_action,
	ge.genre_adventure,
	ge.genre_animation,
	ge.genre_comedy,
	ge.genre_crime,
	ge.genre_documentary,
	ge.genre_drama,
	ge.genre_family,
	ge.genre_fantasy,
	ge.genre_foreign,
	ge.genre_history,
	ge.genre_horror,
	ge.genre_music,
	ge.genre_mystery,
	ge.genre_romance,
	ge.genre_science_fiction,
	ge.genre_tv_movie,
	ge.genre_thriller,
	ge.genre_war,
	ge.genre_western
INTO movies_merged	
FROM movies_metadata as mm
LEFT JOIN genres_encoded as ge
ON mm.index = ge.index;

SELECT * FROM movies_merged