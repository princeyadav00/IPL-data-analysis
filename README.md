IPL Data Analysis Project

Introduction 

The Indian Premier League (IPL) is one of the most popular and competitive T20 cricket leagues globally. Analyzing IPL match data
can provide valuable insights into player performance, team strategies, and match outcomes. This project aims to delve deep into
the IPL datasets, matches.csv and deliveries.csv, to uncover such insights using advanced SQL queries.

The analysis covers various aspects of the game, including batting and bowling performances, team strategies during different phases 
of the game, the impact of toss decisions, and player consistency. 

Datasect consists of:

 matches (
         id INT PRIMARY KEY,
         season INT,
         city VARCHAR(50),
         date DATE,
         team1 VARCHAR(50),
         team2 VARCHAR(50),
         toss_winner VARCHAR(50),
         toss_decision VARCHAR(50),
         result VARCHAR(50),
         dl_applied INT, 
         winner VARCHAR(50),
         win_by_runs INT, 
         win_by_wickets INT,
         player_of_match VARCHAR(50),
         venue VARCHAR(100), 
         umpire1 VARCHAR(50 )
         umpire2 VARCHAR(50) 
         );

  deliveries ( match_id INT, inning INT, batting_team VARCHAR(50), bowling_team VARCHAR(50), over INT, ball INT, batter VARCHAR(50), bowler VARCHAR(50), wide_runs INT, bye_runs INT,legbye_runs INT,noball_runs INT,penalty_runs INT,batsman_runs INT,extra_runs INT, total_runs INT, player_dismissed VARCHAR(50), dismissal_kind VARCHAR(50), fielder VARCHAR(50) );

Key Queries and Insights

-Matches per Season
Analyzing the number of matches played each season helps us understand the growth of the league over time and identify any trends
in the scheduling and format changes.

--Total Runs by Each Team
Examining the total runs scored by each team across different seasons provides insights into the batting strength and consistency
of the teams. This can help identify dominant teams and seasons with high-scoring matches.

--Top Batsmen
Identifying the top-performing batsmen based on the total runs scored allows us to recognize consistent and high-impact players. 
This analysis can be used to highlight the key players in the league's history.

--Winning Margins
Studying the distribution of winning margins (runs or wickets) helps understand the competitiveness of the matches. It can reveal 
whether matches are typically close or if there are frequent one-sided games.

--Player of the Match Awards
Analyzing the distribution of Player of the Match awards among players can highlight the most impactful players in the league. 
It can also show trends in how often different types of performances (batting, bowling, all-round) are recognized.

--Best Batting Partnerships
Finding the best batting partnerships for each team by summing the runs scored by two batsmen while they were together at the 
crease can identify key duos that have been crucial for team success.

--Powerplay Efficiency
Calculating the average runs scored in the powerplay overs (first 6 overs) and comparing it to the overall average runs scored 
per over for each team helps analyze their approach and effectiveness in the crucial initial phase of the innings.

--Consistent Performers
Identifying batsmen who have scored at least 30 runs in at least 50% of their matches highlights consistency. This analysis can
be used to recognize reliable performers who frequently contribute to their team's success.

--Death Over Performance
Determining the average number of runs conceded by each bowler in the death overs (last 4 overs) of each match helps identify 
bowlers who excel under pressure and are effective in restricting runs in the final overs.

--Impact of Toss on Match Outcome
Analyzing the impact of winning the toss on winning the match, grouped by venue, provides insights into how significant the toss 
is in different conditions and locations.

--Player Performance in Different Seasons
Comparing the performance of a specific player (e.g., Virat Kohli) across different seasons in terms of runs scored helps track
their form and consistency over the years.

--Key Players in Winning Matches
Identifying the key players (top batsman and bowler) in matches where a specific team (e.g., Mumbai Indians) won helps understand
the contributions of individual players to team victories.

--Win Probability Based on Target and Current Score
Calculating the win probability of a team based on the current score and target at various points in the innings provides a dynamic
view of the match situation and can be used for real-time strategy adjustments.

--Bowling Performance in Powerplay and Death Overs
Analyzing the performance of bowlers specifically in powerplay (first 6 overs) and death overs (last 4 overs) helps identify specialists 
who are effective in these crucial phases of the game.

--Predicting Winning Team Based on Historical Data
Creating a model to predict the winning team based on historical data using logistic regression in SQL demonstrates the application of 
machine learning techniques in SQL to gain predictive insights.

Results

The analysis yielded several key findings:
- Top-performing players and teams: Identified consistent performers and key players who have made significant contributions to their
  teams over the seasons.
- Performance trends over different seasons: Highlighted the evolution of the league, including changes in scoring patterns
  and team performances.
- Impact of toss decisions on match outcomes: Revealed the significance of toss decisions in different venues and conditions.
- Insights into powerplay and death over performances: Showed which teams and players excel in crucial phases of the game,
  providing strategic insights for future matches.
- Consistency of player performances: Identified reliable performers who consistently contribute to their teams' success.

