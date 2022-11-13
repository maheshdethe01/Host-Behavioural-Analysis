-- adding column city
Alter table listing_t add city nvarchar(10) default 'Toronto' not null;
Alter table listing_v add city nvarchar(10) default 'Vancouver' not null;
Alter table host_t add city nvarchar(10) default 'Toronto' not null;
Alter table host_v add city nvarchar(10) default 'Vancouver' not null;
Alter table review_t add city nvarchar(10) default 'Toronto' not null;
Alter table review_V add city nvarchar(10) default 'Vancouver' not null;
Alter table t_availability add city nvarchar(10) default 'Toronto' not null;
Alter table v_availability add city nvarchar(10) default 'Vancouver' not null;

select *  into listings from listing_t union select * from listing_V;
select *  into hosts from host_t union select * from host_v;
select *  into review from review_t union select * from review_V;
select *  into available from t_availability union select * from v_availability;

--Finding Hosts Acceptance rate & response rate
Update hosts set host_is_superhost = 'Superhost' where host_is_superhost = 'FALSE';
Update hosts set host_is_superhost = 'Host' where host_is_superhost = 'TRUE';


Select host_is_superhost,City,
Avg(host_response_rate) As host_response_rate,
Avg(host_acceptance_rate) as host_acceptance_rate
from hosts
where  host_response_rate is not null or host_acceptance_rate is not null  
group by host_is_superhost,City order by host_is_superhost,city;

-- Checking Hosts having Profile picture

select host_is_superhost,city ,host_has_profile_pic,COUNT(HOST_ID) as cnt
from hosts
where host_is_superhost is not null
group by host_is_superhost,city,host_has_profile_pic;

-- Checking Hosts having identity verified
select host_is_superhost,city ,host_Identity_verified,COUNT(HOST_ID) as cnt
from hosts
where host_is_superhost is not null
group by host_is_superhost,city,host_Identity_verified;

-- Checking if Customer can do instant booking

Select B.Host_is_superhost,B.city,A.instant_bookable,
Count(A.HOST_ID) AS count 
From listings as  A Inner Join hosts as B 
ON A.HOST_ID = B.HOST_ID 
where host_is_superhost is not null
Group by Host_is_superhost,instant_bookable,B.city

-- Checking Customer review scores

Select B.Host_is_superhost,B.City,
avg(A.review_scores_rating) as review_scores_rating,
avg(A.review_scores_accuracy) as review_scores_accuracy,
avg(A.review_scores_cleanliness) as review_scores_cleanliness,
avg(A.review_scores_checkin) as review_scores_checkin,
avg(A.review_scores_communication) as review_scores_communication,
avg(A.review_scores_location) as review_scores_location,
avg(A.review_scores_value) as review_scores_value
From listings as  A Inner Join hosts as B 
ON A.HOST_ID = B.HOST_ID 
where host_is_superhost is not null
Group by Host_is_superhost,B.City order by Host_is_superhost,B.City

-- no.of listings (for superhosts and hosts)

select host_is_superhost,a.city ,COUNT(distinct b.id) no_of_listings                           
from hosts as a inner join listings as b on a.host_id=b.host_id 
group by host_is_superhost,a.city







-- how the comments of reviewers varies for listings of Super Hosts vs Other Hosts
Select City,Host_is_superhost,Sum(Total_Comments) from (
Select C.Host_is_superhost,A.comments,Count(B.Host_ID) As Total_comments,A.city
from review as  A Inner Join listings as B ON A.listing_id = B.id
Inner join hosts as C ON B.Host_ID = C.HOST_ID 
where A.comments  like '%Beautiful%' or A.comments  like '%Fantastic%'
or A.comments  like '%100%%' or A.comments  like '%10/10%'
or A.comments  like '%11/10%' or A.comments  like '%12/10%'
or A.comments  like '%5 star%' or A.comments  like '%5 of 5 stars%'
or A.comments  like '%Great%' or A.comments  like '%Clean%'
or A.comments  like '%amazing%' or A.comments  like '%Wonderful%'
or A.comments  like '%5star%' or A.comments  like '%best%'
or A.comments  like '%Definitely%' or A.comments  like '%excellent%'
or A.comments  like '%Awesome%' or A.comments  like '%excellent%'
or A.comments  like '%Decent%'or A.comments  like '%Well%'
or A.comments  like '%quiet%' or A.comments  like '%love%'
group by C.Host_is_superhost,A.comments,A.city)c 
group by City,Host_is_superhost


-- large property types 
Select A.city,b.host_is_superhost,count(A.Host_ID) as Total_Property_Otherhost
From listings A Inner Join hosts B 
ON A.HOST_ID = B.HOST_ID 
where property_type  like '%ENTIRE%' and b.host_is_superhost is not null
group by A.city,b.host_is_superhost

-- Average price of the listings 

select A.city,host_is_superhost,AVG(price) from 
listings as a inner join hosts as b 
on a.host_id= b.host_id group by A.city,host_is_superhost


-- AVAILABILITY of the listings 

Select c.host_is_superhost,A.city,YEAR(A.date) AS YEAR,A.available,COUNT(distinct B.id) as cnt
from available as A  Inner Join listings as  B ON A.listing_id = B.id
Inner join hosts as  C ON B.Host_ID = C.HOST_ID 
GROUP BY c.host_is_superhost,A.city,YEAR(A.date),A.available







