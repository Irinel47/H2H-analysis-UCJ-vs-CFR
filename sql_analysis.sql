-- First game result, CFR played home
SELECT 
    matchday, 
    home_team, 
    away_team, 
    home_score, 
    away_score
FROM 
    df_matches
WHERE 
    home_team = 'CFR Cluj' 
    AND away_team = "'U' Cluj";

-- Round 19 game was played with U Cluj as home team and CFR Cluj away team. Stats before matchday 19:
SELECT 
    team,
    SUM(CASE 
            WHEN playing_at = 'Home' AND home_score > away_score THEN 1 
            ELSE 0 
        END) AS home_wins,
    SUM(CASE 
            WHEN playing_at = 'Away' AND away_score < home_score THEN 1 
            ELSE 0 
        END) AS away_wins,
    SUM(CASE 
            WHEN playing_at = 'Home' AND home_score = away_score THEN 1 
            ELSE 0 
        END) AS home_draws,
    SUM(CASE 
            WHEN playing_at = 'Away' AND away_score = home_score THEN 1 
            ELSE 0 
        END) AS away_draws,
    SUM(CASE 
            WHEN playing_at = 'Home' AND home_score < away_score THEN 1 
            ELSE 0 
        END) AS home_defeats,
    SUM(CASE 
            WHEN playing_at = 'Away' AND away_score > home_score THEN 1 
            ELSE 0 
        END) AS away_defeats,
    SUM(CASE 
            WHEN playing_at = 'Home' THEN home_score 
            ELSE 0 
        END) AS home_goals_for,
    SUM(CASE 
            WHEN playing_at = 'Home' THEN away_score 
            ELSE 0 
        END) AS home_goals_against,
    SUM(CASE 
            WHEN playing_at = 'Away' THEN home_score 
            ELSE 0 
        END) AS away_goals_for,
    SUM(CASE 
            WHEN playing_at = 'Away' THEN away_score 
            ELSE 0 
        END) AS away_goals_against
FROM (
    SELECT 
        home_team AS team,
        'Home' AS playing_at,
        home_score,
        away_score
    FROM df_matches
    WHERE home_team IN ("'U' Cluj", "CFR Cluj") 
        AND matchday <> 'Runda 19'
    
    UNION ALL
    
    SELECT 
        away_team AS team,
        'Away' AS playing_at,
        away_score AS home_score,
        home_score AS away_score
    FROM df_matches
    WHERE away_team IN ("'U' Cluj", "CFR Cluj") 
        AND matchday <> 'Runda 19'
) AS team_stats
GROUP BY team;

-- Summarize teams performances output vs average number of goals scored in games where the 2 played
SELECT 
    ROUND((AVG(home_score) + AVG(away_score)) / 2, 2) AS avg_goals_per_output, 
    output 
FROM (
    SELECT 
        matchday, 
        home_team, 
        away_team, 
        home_score, 
        away_score, 
        home_score - away_score AS goal_diff,
        CASE 
            WHEN home_team = "'U' Cluj" AND home_score = away_score THEN "'U' Cluj D"
            WHEN home_team = "'U' Cluj" AND home_score > away_score THEN "'U' Cluj W"
            WHEN home_team = "'U' Cluj" AND home_score < away_score THEN "'U' Cluj L"
            WHEN away_team = "'U' Cluj" AND home_score = away_score THEN "'U' Cluj D"
            WHEN away_team = "'U' Cluj" AND home_score < away_score THEN "'U' Cluj W"
            WHEN away_team = "'U' Cluj" AND home_score > away_score THEN "'U' Cluj L"
        END AS output
    FROM df_matches 
    WHERE (home_team = "'U' Cluj" OR away_team = "'U' Cluj") 
      AND matchday <> 'Runda 19'
    
    UNION ALL
    
    SELECT 
        matchday, 
        home_team, 
        away_team, 
        home_score, 
        away_score, 
        home_score - away_score AS goal_diff,
        CASE 
            WHEN home_team = "CFR Cluj" AND home_score = away_score THEN "CFR Cluj D"
            WHEN home_team = "CFR Cluj" AND home_score > away_score THEN "CFR Cluj W"
            WHEN home_team = "CFR Cluj" AND home_score < away_score THEN "CFR Cluj L"
            WHEN away_team = "CFR Cluj" AND home_score = away_score THEN "CFR Cluj D"
            WHEN away_team = "CFR Cluj" AND home_score < away_score THEN "CFR Cluj W"
            WHEN away_team = "CFR Cluj" AND home_score > away_score THEN "CFR Cluj L"
        END AS output
    FROM df_matches 
    WHERE (home_team = "CFR Cluj" OR away_team = "CFR Cluj") 
      AND matchday <> 'Runda 19'
) AS agg_table
GROUP BY output;

-- Analyze performance of 'U' Cluj and CFR Cluj against top table teams, considering top 8 teams from matchday 18
SELECT
    match_result, 
    COUNT(*) AS total_matches
FROM (
    WITH TopTeams AS (
        SELECT team
        FROM final_standings
        WHERE matchday = 18 
          AND position BETWEEN 1 AND 8
    )
    SELECT
        DISTINCT
        CAST(SUBSTRING(df.matchday, 7) AS UNSIGNED) AS matchday_no,
        df.home_team,
        df.away_team,
        df.home_score,
        df.away_score,
        CASE 
            WHEN df.home_team = 'CFR Cluj' AND df.home_score > df.away_score THEN 'CFR Cluj W'
            WHEN df.away_team = 'CFR Cluj' AND df.away_score > df.home_score THEN 'CFR Cluj W'
            WHEN df.home_team = 'CFR Cluj' AND df.home_score = df.away_score THEN 'CFR Cluj D'
            WHEN df.away_team = 'CFR Cluj' AND df.home_score = df.away_score THEN 'CFR Cluj D'
            WHEN df.home_team = 'CFR Cluj' AND df.home_score < df.away_score THEN 'CFR Cluj L'
            WHEN df.away_team = 'CFR Cluj' AND df.away_score < df.home_score THEN 'CFR Cluj L'
            WHEN df.home_team = "'U' Cluj" AND df.home_score > df.away_score THEN "'U' Cluj W"
            WHEN df.away_team = "'U' Cluj" AND df.away_score > df.home_score THEN "'U' Cluj W"
            WHEN df.home_team = "'U' Cluj" AND df.home_score = df.away_score THEN "'U' Cluj D"
            WHEN df.away_team = "'U' Cluj" AND df.home_score = df.away_score THEN "'U' Cluj D"
            WHEN df.home_team = "'U' Cluj" AND df.home_score < df.away_score THEN "'U' Cluj L"
            WHEN df.away_team = "'U' Cluj" AND df.away_score < df.home_score THEN "'U' Cluj L"
        END AS match_result
    FROM df_matches df
    LEFT JOIN TopTeams tt 
        ON (df.home_team = tt.team AND df.away_team IN ('CFR Cluj', "'U' Cluj")) 
        OR (df.away_team = tt.team AND df.home_team IN ('CFR Cluj', "'U' Cluj"))
    WHERE (df.home_team IN ("'U' Cluj", 'CFR Cluj') AND df.away_team = tt.team) 
       OR (df.away_team IN ("'U' Cluj", 'CFR Cluj') AND df.home_team = tt.team)
) AS agg_table
GROUP BY match_result
ORDER BY match_result;

-- Summarize total performance up to the latest matchday
SELECT 
    position,
    team,
    wins,
    draws,
    losses,
    goals_for,
    goals_against,
    goal_difference,
    points,
    ROUND(points / matchday, 2) AS points_per_round,
    ROUND(points / goals_for, 2) AS points_per_goal,
    ROUND(goals_for / matchday, 2) AS goals_for_per_game,
    ROUND(goals_against / matchday, 2) AS goals_against_per_game
FROM 
    final_standings 
WHERE 
    team IN ("'U' Cluj", "CFR Cluj") 
    AND matchday = 19;

-- Average position in rankings for 'U' Cluj and CFR Cluj
SELECT
    'overall' AS type,
    ROUND(AVG(position), 2) AS avg_position,
    team
FROM 
    final_standings
WHERE 
    team IN ("'U' Cluj", "CFR Cluj")
GROUP BY 
    team

UNION ALL

-- Average position in rankings for 'U' Cluj and CFR Cluj after 5 rounds
SELECT
    'after 5 rounds' AS type,
    ROUND(AVG(position), 2) AS avg_pos,
    team
FROM 
    final_standings
WHERE 
    team IN ("'U' Cluj", "CFR Cluj") 
    AND matchday >= 5
GROUP BY 
    team;