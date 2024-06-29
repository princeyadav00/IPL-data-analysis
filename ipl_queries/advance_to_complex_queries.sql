--Determine the bowler with the best bowling average (minimum 50 overs bowled).
 
 with cte1 as
 (
 select bowler, sum(total_runs) as total_run_conceded
 from deliveries
 group by bowler
 ),
 cte2 as 
 (
 select bowler , count(*) as total_wickets
 from deliveries
 where dismissal_kind != 'run_out' and dismissal_kind is not null
 group by bowler
 ),
 cte3 as
 (
 select bowler , count(*)/6.0 as over_bowled 
 from deliveries
 group by bowler
 )
 select top 1 cte1.bowler, cte1.total_run_conceded, cte2.total_wickets, cte3.over_bowled,
 case when total_wickets > 0 then total_run_conceded * 1.0/ total_wickets else null end as bowling_average
 from cte1 
 inner join cte2 on cte1.bowler = cte2.bowler
 inner join cte3 on cte2.bowler = cte3.bowler
 where over_bowled >= 50
 order by bowling_average desc;
    


--Analyze the impact of winning the toss on match outcomes.
    select toss_decision,
	count(case when toss_winner = winner then 1 else null end )as wins,
	count(case when toss_winner != winner then 1 else null end )as losses
	from matches 
	group by toss_decision;


--Find the highest partnership for each team.
 with cte1 as
 (
select match_id, batting_team,batter,non_striker, sum(batsman_runs) as partnership_runs
from deliveries
group by match_id, batting_team,batter,non_striker
),
cte2 as
(
select match_id, batting_team,batter,non_striker,partnership_runs,
rank() over ( partition by batting_team order by partnership_runs desc) as rnk
from cte1
)
select match_id, batting_team,batter,non_striker,partnership_runs
from cte2 
where rnk=1
order by partnership_runs desc;

--Calculate the average strike rate of each batsman (minimum 500 balls faced).

select batter, avg(strike_rate) as avg_strike_rate
from(
select batter, sum(batsman_runs) *100/count(ball)as strike_rate
from deliveries
group by batter
having count(ball)>=500
) as A
group by batter 
order by avg_strike_rate desc;


--Identify matches with the closest margin of victory (by runs).
select id, date, team1, team2, winner, result_margin
from 
(
select id, date, team1, team2, winner, result_margin,
rank() over (order by result_margin asc) as rnk
from matches
where result='runs'
) as A 
where rnk=1;


--Find the most economical bowler (minimum 200 overs bowled).

    select top 1 bowler , sum(total_runs)*6.0/count(ball) bowlers_economy
from deliveries
group by bowler
having count(ball)>=1200
order by bowlers_economy asc;


--Determine the player who has been dismissed the most by a particular bowler.*
    
	select top 1 bowler , player_dismissed, count(*) as dismissals
	from deliveries
	where player_dismissed is not null and player_dismissed != 'na'
	group by bowler, player_dismissed
	order by dismissals desc;


--Analyze the performance of teams when chasing targets (win percentage).

select team1 as chasing_team,
count(case when winner = team1 then 1 else null end)*100/count(*) as win_percentage
from matches
where toss_decision ='field'
group by team1
order by win_percentage desc;
    

--Find the top 5 bowlers with the most 5-wicket hauls.


select top 5 bowler, count(*) as fifer 
from(
select match_id, bowler, count(*) as wickets
from deliveries
where is_wicket = 1
group by match_id, bowler
having count(*)>=5
) as A 
group by bowler
order by fifer desc;

--Calculate the number of matches each umpire has officiated.

select umpire ,count(*) as match_officiated
from
(
select umpire1 as umpire
from matches
union
select umpire2 as umpire
from matches
 ) as A 
 group by umpire
 order by match_officiated desc;
 

--Analyze the impact of the toss decision on the total runs scored by the winning team.

select toss_decision, avg(total_run) avg_runs
from
(
 select match_id, toss_decision, sum(total_runs) as total_run
 from matches m
 inner join deliveries d on d.match_id = m.id
 where winner = team1 or winner = team2
 group by match_id, toss_decision
 ) as A 
 GROUP BY toss_decision;
    
--Identify the top 3 partnerships (by runs) for each team.

 with cte1 as
 (
select match_id, batting_team,batter,non_striker, sum(batsman_runs) as partnership_runs
from deliveries
group by match_id, batting_team,batter,non_striker
),
cte2 as
(
select match_id, batting_team,batter,non_striker,partnership_runs,
rank() over ( partition by batting_team order by partnership_runs desc) as rnk
from cte1
)
select top 3 match_id, batting_team,batter,non_striker,partnership_runs
from cte2 
where rnk=1
order by partnership_runs desc;


--- Analyzing Powerplay Efficiency
--Calculate the average runs scored in the powerplay overs (first 6 overs) and compare it to the overall 
--average runs scored per over for each team.

with cte1 as
(
select match_id, batting_team, sum(total_runs) as p_total_run  
from deliveries
where overs<=6
group by match_id, batting_team
),
cte2 as
(
select match_id, batting_team, sum(total_runs) as total_run
from deliveries
group by match_id, batting_team
),
cte3 as
(
select match_id, batting_team, count(distinct overs) as total_overs
from deliveries 
group by match_id, batting_team
)
select cte1.batting_team, avg(cte1.p_total_run) as avg_p_total_run,
avg(cte2.total_run)*1.0/avg(cte3.total_overs) as avg_runs_perover
from cte1
inner join cte2 on cte1.match_id = cte2.match_id and cte1.batting_team = cte2.batting_team 
inner join cte3 on cte2.match_id = cte3.match_id and cte2.batting_team = cte3.batting_team
group by cte1.batting_team
order by avg_p_total_run desc;

--Identifying Consistent Performers
--Identify batsmen who have scored at least 30 runs in at least 50% of their matches.

with cte1 as
(
select match_id, batter, sum(batsman_runs) as total_run
from deliveries
group by match_id, batter
),
cte2 as
(
select batter, count(match_id) as no_of_matches
from cte1
group by batter
),
cte3 as
(
select batter, count(match_id) as plus30_run_matches
from cte1
where total_run >= 30
group by batter
)
select cte2.batter, cte2.no_of_matches, cte3.plus30_run_matches,
((plus30_run_matches * 100)/no_of_matches) as plus30_percentage
from cte2
inner join cte3 on cte2.batter=cte3.batter
where ((plus30_run_matches * 100)/no_of_matches) >= 50
order by plus30_percentage desc;



--Evaluating Death Over Performance
--Determine the average number of runs conceded by each bowler in the death overs (last 4 overs) of each match.


with cte1 as
(
select match_id, bowler, sum(total_runs) as total_run_conceded 
from deliveries
where overs > 16
group by match_id, bowler
),
cte2 as
( 
select match_id, bowler , count(distinct overs) as over_bowled
from deliveries
where overs > 16
group by match_id, bowler
)
select  cte1.bowler, avg( (cte1.total_run_conceded * 1.0)/cte2.over_bowled) as avg_run_per_over
from cte1 
inner join cte2 on cte1.match_id=cte2.match_id and cte2.bowler = cte1.bowler
group by cte1.bowler
order by avg_run_per_over asc;

--Impact of Toss on Match Outcome
--Analyze the impact of winning the toss on winning the match, grouped by venue.


select venue, count(*) as total_matches,
count(case when toss_winner = winner then 1 else 0 end) as toss_win_matches,
(count(case when toss_winner = winner then 1 else 0 end)/count(*) * 100) as toss_win_percent
from matches
group by venue
order by toss_win_percent desc;


--Player Performance in Different Seasons
--Compare the performance of a specific player (e.g., Virat Kohli) across different seasons in terms of runs scored.


select m.season, d.batter, sum(d.batsman_runs) as total_run
from deliveries d
inner join matches m on m.id = d.match_id
where batter = 'v kohli'
group by m.season , d.batter
order by total_run;

--Identifying Key Players in Winning Matches
--Identify the key players (top batsman and bowler) in matches where a specific team (e.g., Mumbai Indians) won.

with cte1 as
(
select match_id, bowler, batter, sum(batsman_runs) as total_run,
count(case when is_wicket = 1 then 1 else null end) as no_of_wickets
from deliveries
group by match_id, bowler, batter
),
cte2 as
(
select id
from matches 
where winner= 'mumbai indians'
)
select cte1.match_id, cte1.bowler, cte1.batter, cte1.total_run, cte1.no_of_wickets
from cte1
inner join cte2 on cte1.match_id = cte2.id
order by cte1.match_id, cte1.total_run desc, cte1.no_of_wickets desc;


--Win Probability Based on Target and Current Score
--Calculate the win probability of a team based on the current score and target at various points in the innings.

WITH innings_score AS (
    SELECT match_id, inning, overs, SUM(total_runs) OVER (PARTITION BY match_id, inning ORDER BY overs) AS cumulative_score
    FROM deliveries
), match_target AS (
    SELECT id AS match_id, target_runs
    FROM matches
    WHERE target_runs IS NOT NULL
)
SELECT isc.match_id, isc.inning, isc.overs, isc.cumulative_score, mt.target_runs,
       (isc.cumulative_score * 1.0 / mt.target_runs) * 100 AS win_probability
FROM innings_score isc
JOIN match_target mt ON isc.match_id = mt.match_id
WHERE isc.inning = 2
ORDER BY isc.match_id, isc.overs;

--Bowling Performance in Powerplay and Death Overs
--Analyze the performance of bowlers specifically in powerplay (first 6 overs) and death overs (last 4 overs).

with cte1 as 
(
select bowler, sum(total_runs) as powerplay_runs, count(ball) as p_ball_bowled
from deliveries
where overs <= 6
group by bowler
),
cte2 as 
(
select bowler, sum(total_runs) as death_over_runs, count(ball) as d_ball_bowled
from deliveries
where overs > 16
group by bowler
)
select cte1.bowler, cte1.powerplay_runs, cte1.p_ball_bowled, cte2.death_over_runs,  cte2.d_ball_bowled
from cte1
inner join cte2 on cte1.bowler = cte2.bowler
order by cte1.powerplay_runs asc, cte2.death_over_runs asc;


--Predicting Winning Team Based on Historical Data
--Create a model to predict the winning team based on historical data using logistic regression in SQL.


with cte1 as
(
select id, season, team1, team2, case when winner = team1 then 1 else 0 end as team1_wins,
case when winner = team2 then 1 else 0 end as team2_wins
from matches
),
cte2 as
(
select match_id, batting_team, sum(total_runs) as team1_runs
from deliveries
group by match_id, batting_team
having batting_team in (select team1 from cte1 where match_id = deliveries.match_id)
),
cte3 as
(
select  match_id, batting_team, sum(total_runs) as team2_runs
from deliveries
group by match_id, batting_team
having batting_team in (select team2 from cte1 where match_id = deliveries.match_id)
)
select cte1.id, cte1.season, cte1.team1, cte1.team2, cte2.team1_runs, cte3.team2_runs,
case when cte1.team1_wins = 1 then 'team1_wins' else 'team2_wins' end as match_result
from cte1 
inner join cte2 on cte1.id = cte2.match_id
inner join cte3 on cte1.id = cte3.match_id;




