--Number of games by extraction date

with

games as (
    select
        *,
        cast(date_parse("extracted_at", '%Y-%m-%d') as date) as extracted_at_parsed
    from "games_app"
)

select
    extracted_at_parsed,
    count(*) as games_played

from games
group by extracted_at_parsed