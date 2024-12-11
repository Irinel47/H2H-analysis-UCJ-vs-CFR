🏟️ SQL & Python: Football Post-Game Analysis - 'U' Cluj vs CFR Cluj
This repository showcases a head-to-head analysis using SQL and Python for a football match between Romania's 'U' Cluj and CFR Cluj. The analysis leverages 2024-2025 match data and matchday statistics to provide insights into team performances, trends, and outcomes.

📂 Dataset Overview:
df_matches.csv: Contains data for all results up to matchday 19.
final_standings.csv: Includes matchday statistics such as wins, losses, draws, goals for/against, goal difference, points, and rankings by matchday.
📊 Key Analysis:
Pre-match comparison of the two teams' performances up to matchday 19.
Post-game analysis of match outcomes and their implications on standings.
Comparative demonstration of SQL and Python for data querying, transformation, and visualization.
🛠️ Tech Stack:
SQL: Used for structured queries and database-like analysis.
Python: Leveraged for advanced analytics, visualizations, and scripting.
🌟 Highlights:
Head-to-head stats and performance trends.
Insights into how each team evolved across matchdays.
A showcase of how SQL and Python can complement each other in data analysis.
This repository serves as an example of combining technical skills with a passion for football analytics. Feel free to explore, learn, and contribute! ⚽📈

Methodology
To analyze the match between U Cluj and CFR Cluj, I began by collecting and organizing data from the ongoing 2024–2025 Superliga season. The data was stored in two CSV files, which served as the backbone of the analysis:
1. df_matches
This dataset contains the match-by-match results across all rounds (from Matchday 1 to Matchday 19). Key columns include:
~ matchday: The round number, expressed as both a string (e.g., "Runda 1") and an integer (matchday_num).
~ home_team and away_team: The participating teams.
~ home_score and away_score: Goals scored by each team.

2. final_standings
This dataset tracks the progression of team performances across matchdays. Key columns include:
~ position: The team's rank after each round.
~ wins, draws, losses: The match results breakdown.
~ goals_for, goals_against: Offensive and defensive metrics.
~ goal_difference: A measure of team dominance.
~ points: Points earned (based on wins and draws).
