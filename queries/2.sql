--More promising openings for white and black

with

results_by_opening as (

    select
        "opening",
        count(*) filter(where "result" = '1-0') as white_wins,
        count(*) filter(where "result" = '0-1') as black_wins,
        count(*) filter(where "result" = '1/2-1/2') as draws,
        count(*) games_played

    from "games_app"
    group by "opening"

),

win_rate as (

    select
        *,
        round(100.0 * white_wins / games_played, 2) as white_win_rate,
        round(100.0 * black_wins / games_played, 2) as black_win_rate

    from results_by_opening

),

openings_rank as (

    select
        *,
        rank() over (order by white_win_rate desc) as rank_white_openings,
        rank() over (order by black_win_rate desc) as rank_black_openings

    from win_rate

)

select * from openings_rank