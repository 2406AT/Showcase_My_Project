select *  from spotify
limit 10;

--EDA Performing

select count (distinct artist) from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;

select * from spotify
where duration_min = 0 ;

Delete  from spotify
where duration_min = 0 ;


select distinct channel from spotify;

/* -------------------------------------------
--Data Analysis --easy catogery
------------------------------------------- */

1. -- Retrive all stream from table where stream is grater then 1M--

select * from spotify
where stream > 1000000000;

2. -- list all the album with their resspective artist--

select distinct album , artist from spotify
order by 1;


3. --get the total number of comments where the license = true--

select sum(comments) from spotify 
where licensed = 'True';

4. --select all the track that belong to the album type single--

select * from spotify
where album_type = 'single';

5. --count the total number of tracks by each artist--

select  artist,count(*) as countOfTrack from spotify 
group by artist
order by countOfTrack DESC ;

------------------------------------------------------------------------
-- Section 2 , Medium level question  ---
------------------------------------------------------------------------

6. calculate the denceablitity of tracks in each album

select 
album, Avg(danceability) as danceability
from spotify 
group by 1
order by 2 Desc;

7. -- find the top 5 track with higher energy values---
select track, Max(energy)   from spotify 
group by 1
order by 2 desc
limit 5;

8. -- list all the tracks along with their views and likes where official_video = 'true'--
select 
track, views, likes, official_video
from spotify 
where official_video = 'True';

9. -- for each album, calculate the views of all assosiate tracks--

	 select  album, track,
	 sum(views) from spotify
	 group by 1,2
	 order by 3 DESC;
10. -- retrive the track name that have been streamed on spotify more then Youtube--

select * from (select 
track , 
COALESCE(SUM(case when most_played_on = 'Youtube' then stream end ),0) as streamed_on_Youtube
COALESCE(sum(case when most_played_on = 'spotify' then stream end ),0)as streamed_on_spotify
from spotify 
group by 1;) as t1
where streamed_on_spotify > streamed_on_Youtube;

-----------------------------------------------------------------------------------------------------------
Next levle (11-13) difficult level but not for me
------------------------------------------------------------------------------------------

11. --find he all top 3 most viewed track for each artist using window function---

  with Ranking_artist as 
  (
select 
artist, 
track, sum(views),
DENSE_RANK OVER(PARTITION BY artist order by sum(views DESC)) as Rank
  group by 1,2
  order by 1,3 desc) 
  select * from Ranking_artist 
  where Rank <=3;


------------------------------------------------------------------------------------------------------------------
12.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
------------------------------------------------------------------------------------------------------------------

  WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC