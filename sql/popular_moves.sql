--Most popular moves for white and black

with

game_moves as (

    select
        "moves",
        regexp_extract_all("moves", '[A-Za-z]+[0-9]+') as move_list

    from "opening"."games"

),

first_moves as (

    select
        "moves",
        move_list[1] as white_first_move,
        move_list[2] as black_first_move

    from game_moves

),

first_move_count as (
    
        select
            *,
            count(*) over (partition by white_first_move) as white_first_move_count,
            count(*) over (partition by black_first_move) as black_first_move_count,
            count(*) over () as games_played
    
        from first_moves

),

first_move_rate as (

    select
        *,
        round(100.0 * white_first_move_count / games_played, 2) as white_first_move_rate,
        round(100.0 * black_first_move_count / games_played, 2) as black_first_move_rate

    from first_move_count

),

white_first_move as (

    select
        distinct white_first_move,
        white_first_move as move,
        white_first_move_rate as move_rate,
        'white' as player

    from first_move_rate
),

black_first_move as (

    select
        distinct black_first_move,
        black_first_move as move,
        black_first_move_rate as move_rate,
        'black' as player

    from first_move_rate
),

first_move_popularity as (

    select player, move, move_rate from white_first_move
    union
    select player, move, move_rate from black_first_move

)

select * from first_move_popularity
order by move_rate desc