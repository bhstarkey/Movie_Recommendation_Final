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
    "rating" money   NOT NULL,
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


CREATE TABLE "keywords" (
    "id" int   NOT NULL,
    "keywords" varchar   NOT NULL,
    CONSTRAINT "pk_keywords" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "genres_encoded" (
    "index" int   NOT NULL,
    "genre_Action" float   NOT NULL,
    "genre_Adventure" float   NOT NULL,
    "genre_Animation" float   NOT NULL,
    "genre_Comedy" float   NOT NULL,
    "genre_Crime" float   NOT NULL,
    "genre_Documentary" float   NOT NULL,
    "genre_Drama" float   NOT NULL,
    "genre_Family" float   NOT NULL,
    "genre_Fantasy" float   NOT NULL,
    "genre_Foreign" float   NOT NULL,
    "genre_History" float   NOT NULL,
    "genre_Horror" float   NOT NULL,
    "genre_Music" float   NOT NULL,
    "genre_Mystery" float   NOT NULL,
    "genre_Romance" float   NOT NULL,
    "genre_Science_Fiction" float   NOT NULL,
    "genre_TV_Movie" float   NOT NULL,
    "genre_Thriller" float   NOT NULL,
    "genre_War" float   NOT NULL,
    "genre_Western" float   NOT NULL,
    CONSTRAINT "pk_genres_encoded" PRIMARY KEY (
        "index"
     )
);