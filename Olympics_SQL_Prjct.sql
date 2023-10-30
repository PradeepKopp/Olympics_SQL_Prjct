select COUNT(id)
from athletes ---135571

select count (distinct team)  
from athletes ---1013

select * 
from athlete_events 

select distinct season 
from athlete_events
---Winter
---Summer

select COUNT(distinct sport)
from athlete_events ---66

select distinct medal
from athlete_events

select COUNT(distinct city) 
from athlete_events ---42 


select datediff(DAY,  MIN(year), MAX(year) ) as d
from athlete_events ---1896 to 2016 --120years data 

--1 which team has won the maximum gold medals over the years.


select * from athletes
select * from athlete_events 

select  team,count(distinct event) as cnt from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where medal='Gold'
group by team
order by cnt desc

/*--2 for each team print total silver medals and year in which 
they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver */
with cte as (
select t2.team, t1.year, SUM(case when medal='Silver' then 1 end) as Ttl_silver
from athlete_events t1 inner join athletes t2
on t1.athlete_id= t2.id
group by t2.team, t1.year
 ), cte1 as (
select *, DENSE_RANK() over(partition by team order by Ttl_silver desc) as rn 
from cte 
)
select *
 from cte1
  where rn=1
  order by Ttl_silver desc 

  with cte as (
select a.team,ae.year , count(distinct event) as silver_medals
,rank() over(partition by team order by count(distinct event) desc) as rn
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where medal='Silver'
group by a.team,ae.year)
select team,sum(silver_medals) as total_silver_medals, max(case when rn=1 then year end) as  year_of_max_silver
from cte
group by team
order by total_silver_medals desc ;

--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years


select * from athlete_events
where athlete_id =70965

select * from athletes
where name ='Ryan Steven Lochte'


with cte as (
select name, medal 
from athlete_events t1 inner join athletes t2
on t1.athlete_id =t2.id)
select name, COUNT(*) as no_of_Golds 
from cte 
where name not in( select distinct name from cte where medal in ('Silver', 'Bronze')) 
and medal ='Gold'
 group by name 
 order by no_of_Golds desc 

 
--4 in each year which player has won maximum gold medal . Write a query to print year,player name 
--and no of golds won in that year . In case of a tie print comma separated player names.


select * from athlete_events
select * from athletes


with cte as (
select t2.name, t1.year, COUNT(*) as No_of_medals 
from athlete_events t1 inner join athletes t2 
on t1.athlete_id =t2.id
where medal='Gold'
group by t2.name, t1.year), cte1 as (
select name,year,  DENSE_RANK() over (partition by year order by No_of_medals desc) as rn 
from cte )
select  year, STRING_AGG(name, ',') as Top_athlete
from cte1
where rn=1 
group by  year
order by year desc


--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport


 select distinct * from (
select medal,year,event,rank() over(partition by medal order by year) rn
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where team='India' and medal != 'NA'
) A
where rn=1

--6 find players who won gold medal in summer and winter olympics both.



with cte as (
select t2.name, t1.season, COUNT(*) as No_of_medals
from athlete_events t1 inner join athletes t2 
on t1.athlete_id =t2.id
where medal='Gold' and season in ('Summer', 'Winter')
group by t2.name, t1.season )
select name, COUNT(distinct season) as cnt
from cte 
group by name 
having COUNT(distinct season) =2


--7 find players who won gold, silver and bronze medal in a single olympics.
--print player name along with year.



with cte as (
select t2.name, t1.games, t1.year, t1.medal 
from athlete_events t1 inner join athletes t2
on t1.athlete_id=t2.id
where medal in ('Gold', 'Silver', 'Bronze'))
select name,games, year , COUNT(distinct medal) as cnt ,COUNT(medal) as cnt 
from cte 
group by name, games, year
having COUNT(distinct medal) =3
order by COUNT(medal) desc 

--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.


select * from athlete_events
select * from athletes
select * 
from athletes 
where name = 'Pter Biros'

select * 
from athlete_events 
where athlete_id= 11725

with cte as (
select t2.name, t1.season, t1.year, t1.medal, t1.event
from athlete_events t1 inner join athletes t2 
on t1.athlete_id =t2.id
where medal='Gold' and year in('2000', '2004', '2008') and season='Summer')

select name, event, COUNT(distinct year) as cnt
from cte 
group by name, event
having COUNT(distinct year) =3 

with cte as (
select name,year,event
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where year >=2000 and season='Summer'and medal = 'Gold'
group by name,year,event)
select * from
(select *, lag(year,1) over(partition by name,event order by year ) as prev_year
, lead(year,1) over(partition by name,event order by year ) as next_year
from cte) A
where year=prev_year+4 and year=next_year-4
