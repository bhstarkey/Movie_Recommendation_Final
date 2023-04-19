CREATE TABLE "movies" (
    "movieId" int   NOT NULL,
    "title" varchar   NOT NULL,
    "genres" varchar   NOT NULL,

    CONSTRAINT "uc_movies_movieId" UNIQUE (
        "movieId"
    )
);

CREATE TABLE "movies_metadata" (
    "index" int   NOT NULL,
    "adult" boolean   NOT NULL,
    "budget" int   NOT NULL,
    "id" int   NOT NULL,
    "imdb_id" int   NOT NULL,
    "original_language" varchar,
    "popularity" float,
    "poster_path" varchar,
    "release_date" date,
    "revenue" float,
    "runtime" float,
    "status" varchar,
    "title" varchar   NOT NULL,
    "video" boolean,
    "vote_average" float,
    "vote_count" float,
    CONSTRAINT "pk_movies_metadata" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_movies_metadata_imdb_id" UNIQUE (
        "imdb_id"
    )
);

CREATE TABLE "genome_scores" (
    "movieId" int   NOT NULL,
    "tagId" int   NOT NULL,
    "relevance" float   NOT NULL,
    CONSTRAINT "pk_genome_scores" PRIMARY KEY (
        "movieId","tagId"
     )
);

CREATE TABLE "tags" (
    "userId" int   NOT NULL,
    "movieId" int   NOT NULL,
    "tag" varchar   NOT NULL,
    "timestamp" int   NOT NULL,
    CONSTRAINT "pk_tags" PRIMARY KEY (
        "userId","movieId","tag"
     )
);

CREATE TABLE "genome_tags" (
    "tagId" int   NOT NULL,
    "tag" varchar   NOT NULL,
    CONSTRAINT "pk_genome_tags" PRIMARY KEY (
        "tagId"
     )
);

CREATE TABLE "ratings" (
    "userId" int   NOT NULL,
    "movieId" int   NOT NULL,
    "rating" float   NOT NULL,
    "timestamp" int   NOT NULL,
    CONSTRAINT "pk_ratings" PRIMARY KEY (
        "userId","movieId"
     )
);

CREATE TABLE "links" (
    "movieId" int   NOT NULL,
    "imdbId" int   NOT NULL,
    "tmdbId" int,
    CONSTRAINT "pk_links" PRIMARY KEY (
        "movieId"
     )
);


CREATE TABLE "genres_encoded" (
    "index" int   NOT NULL,
    "genre_action" float   NOT NULL,
    "genre_adventure" float   NOT NULL,
    "genre_animation" float   NOT NULL,
    "genre_comedy" float   NOT NULL,
    "genre_crime" float   NOT NULL,
    "genre_documentary" float   NOT NULL,
    "genre_drama" float   NOT NULL,
    "genre_family" float   NOT NULL,
    "genre_fantasy" float   NOT NULL,
    "genre_foreign" float   NOT NULL,
    "genre_history" float   NOT NULL,
    "genre_horror" float   NOT NULL,
    "genre_music" float   NOT NULL,
    "genre_mystery" float   NOT NULL,
    "genre_romance" float   NOT NULL,
    "genre_science_fiction" float   NOT NULL,
    "genre_tv_movie" float   NOT NULL,
    "genre_thriller" float   NOT NULL,
    "genre_war" float   NOT NULL,
    "genre_western" float   NOT NULL,
    CONSTRAINT "pk_genres_encoded" PRIMARY KEY (
        "index"
     )
);