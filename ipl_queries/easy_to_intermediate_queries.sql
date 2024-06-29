
--List all matches with their IDs and dates.
  
  select id, date
  from matches

--Get the total runs scored in each match.
    select match_id, sum(total_runs) as total_run
	from deliveries
	group by match_id

--Find the names of all the teams that have played in the league.

select distinct team1 as team_name 
from matches
union 
select distinct team2 as team_name
from matches
 
--Get the player with the most 'Player of the Match' awards.
   
   select top 1 player_of_match, count(*) as no_of_time
   from matches
   group by player_of_match
   order by no_of_time desc


--List matches where the result was decided by a margin of over 100 runs.
   
   select *
   from matches
   where result = 'runs' and result_margin > 100

--Find the number of wickets taken by each bowler.
   
   select bowler , count(*) as no_of_wickets
   from deliveries
   group by bowler
   

--Identify the match with the highest number of extras conceded.

select  top 1 match_id,sum(extra_runs) as total_extra_runs
from deliveries
group by match_id
order by total_extra_runs desc
   

--Get the total number of runs scored by each team in each season.
   
   select season,batting_team, sum(total_runs) as total_run
   from matches m
   inner join deliveries d on m.id=d.match_id
   where season is not null
   group by season, batting_team
   order by season, batting_team desc

--List the top 5 batsmen with the highest total runs scored.

select top 5 batter, sum(batsman_runs) as batter_total_runs
from deliveries
group by batter
order by batter_total_runs desc


---Retrieve the names and dates of matches played in a specific city (e.g., Bangalore).
   
   select date,season, city,match_type
   from matches
   where city ='bangalore' and season is not null

--List all distinct match types available in the dataset

select distinct match_type
from matches
   

  --List the winner of each match along with the date and venue.

select date, venue, winner
from matches


--Count the number of matches played each season.

select season, count(*) as matches_played
from matches
where season is not null
group by season
   

--Calculate the total runs scored by each team across all matches.

select batting_team , sum(total_runs) as total_run
from deliveries
group by batting_team

--Find the highest individual score by a batsman in each match.*
  
  select match_id, batter, sum(batsman_runs) as total_run
  from deliveries
  group by match_id, batter
  order by total_run desc

--Find the top 3 highest-scoring matches (by total runs).

select top 3 match_id,sum(total_runs) as total_run
from deliveries
group by match_id
order by total_run desc
   

--List the players who have won 'Player of the Match' more than 5 times.

select top 1 player_of_match, count(*) as no_of_times_pom
from matches
group by player_of_match
order by no_of_times_pom desc