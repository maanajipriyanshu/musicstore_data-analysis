-- Which countries have the most invoices?

select top 25 count(*) as total_inv,billing_country from invoice
group by billing_country 
order by total_inv desc



--What are the top 3 values and countries of total invoices 

select top 3 total,billing_country from invoice
order by total desc



--Which city has the best customers?

select SUM(total) as invoice_total,billing_city from invoice
group by billing_city
order by invoice_total desc



--Who is the best customer?

select top 1 customer.customer_id,first_name,last_name,sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id,customer.first_name,customer.last_name
order by total desc



--Write query to return email,first name,last name & genre of all Rock music listeners.

select distinct email,first_name,last_name from customer
join invoice as i on customer.customer_id = i.customer_id
join invoice_line as il on i.invoice_id = il.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like '%Rock%'
)
order by email



--Artist written the most rock music
--Write a query to returns the artist name & total track count of the top 10 rock bands

select top 10 artist.artist_id,artist.name,count(artist.artist_id) as noOfSongs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id,artist.name
order by noOfSongs desc



--Return all the track names that have song length longer than avg. 
--Return name and Milliseconds



select top 95 name,milliseconds from track
where milliseconds > (select avg(milliseconds) as AvgTrackLength
from track)
order by milliseconds desc;



--Find How much amount spent by each customer on artists?
--Return customer name , artist name and total spent

with best_selling_artist as(
select top 1 artist.artist_id as artist_id,artist.name as artist_name, 
sum(invoice_line.unit_price * invoice_line.quantity)
as total_sales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by artist.artist_id,artist.name
order by 3 desc
)

select c.customer_id, c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price * il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album al on al.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = al.artist_id
group by c.customer_id, c.first_name,c.last_name,bsa.artist_name
order by 5 desc


