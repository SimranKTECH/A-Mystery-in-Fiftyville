-- Keep a log of any SQL queries you execute as you solve the mystery.
select description from crime_scene_reports
where day = 28 AND month = 7 AND year = 2020 AND street = "Chamberlin Street";

--Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse. 
--Interviews were conducted today with three witnesses who were present at the time — each of their 
--interview transcripts mentions the courthouse.

select name, transcript from interviews 
where day = 28 AND month = 7 AND year = 2020;

--Jose | “Ah,” said he, “I forgot that I had not seen you for some weeks. 
--It is a little souvenir from the King of Bohemia in return for my assistance in the case of the 
--Irene Adler papers.”
--Eugene | “I suppose,” said Holmes, “that when Mr. Windibank came back from France he was very annoyed 
--at your having gone to the ball.”
--Barbara | “You had my note?” he asked with a deep harsh voice and a strongly marked German accent. 
--“I told you that I would call.” He looked from one to the other of us, as if uncertain which to address.
--Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking 
--lot and drive away. If you have security footage from the courthouse parking lot, you might want to look 
--for cars that left the parking lot in that time frame.
--Eugene | I don't know the thief's name, but it was someone I recognized. Earlier this morning, 
--before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there 
--withdrawing some money.
--Raymond | As the thief was leaving the courthouse, they called someone who talked to them for less than 
--a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of 
--Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight
--tickets

select activity, license_plate, hour, minute from courthouse_security_logs
where day = 28 AND month = 7 AND year = 2020 AND hour = 10;

--exit | 5P2BI95 | 10 | 16
--exit | 94KL13X | 10 | 18
--exit | 6P58WS2 | 10 | 18
--exit | 4328GD8 | 10 | 19
--exit | G412CB7 | 10 | 20
--exit | L93JTIZ | 10 | 21
--exit | 322W7JE | 10 | 23
--exit | 0NTHK55 | 10 | 23
--exit | 1106N58 | 10 | 35

select account_number, transaction_type, amount from atm_transactions
where day = 28 AND month = 7 AND year = 2020 and atm_location = "Fifer Street";

--account_number | transaction_type | amount
--28500762 | withdraw | 48
--28296815 | withdraw | 20
--76054385 | withdraw | 60
--49610011 | withdraw | 50
--16153065 | withdraw | 80
--86363979 | deposit | 10
--25506511 | withdraw | 20
--81061156 | withdraw | 30
--26013199 | withdraw | 35

select *from flights where origin_airport_id = 8 and day = 29 and month = 7 and year = 2020;
--LONDON (flight id = 36 , destination airport id = 4, time - 8.20 am)

select *from passengers where flight_id = 36;
flight_id | passport_number | seat

select *from passengers where flight_id = 36;
-- flight_id | passport_number | seat
-- 36 | 7214083635 | 2A
-- 36 | 1695452385 | 3B
-- 36 | 5773159633 | 4A
-- 36 | 1540955065 | 5C
-- 36 | 8294398571 | 6C
-- 36 | 1988161715 | 6D
-- 36 | 9878712108 | 7A
-- 36 | 8496433585 | 7B

select people.name, people.phone_number, people.license_plate from people
join passengers on people.passport_number = passengers.passport_number
where passengers.flight_id = 36;

-- name | phone_number | license_plate   
-- Doris | (066) 555-9701 | M51FA04
-- Roger | (130) 555-0289 | G412CB7
-- Ernest | (367) 555-5533 | 94KL13X sus
-- Edward | (328) 555-1152 | 130LD9Z
-- Evelyn | (499) 555-9472 | 0NTHK55
-- Madison | (286) 555-6063 | 1106N58 sus
-- Bobby | (826) 555-1652 | 30G67EN sus
-- Danielle | (389) 555-5198 | 4328GD8 sus


select name, passport_number from people where id IN
(select person_id from bank_accounts where account_number IN
(select account_number from atm_transactions where day = 28 AND month = 7 AND year = 2020 
and atm_location = "Fifer Street"));

-- name | passport_number
-- Bobby | 9878712108
-- Elizabeth | 7049073643
-- Victoria | 9586786673
-- Madison | 1988161715
-- Roy | 4408372428
-- Danielle | 8496433585
-- Russell | 3592750733
-- Ernest | 5773159633
-- Robert | 8304650265

--suspects - Ernest 5773159633, Madison 1988161715, Bobby 9878712108, Daniell 8496433585

select name from people where license_plate in (select license_plate from courthouse_security_logs where day = 28 AND month = 7 AND year = 2020 AND hour = 10);

-- name
-- Patrick
-- Amber
-- Brandon
-- Elizabeth
-- Roger
-- Madison
-- Danielle
-- Russell
-- Evelyn
-- Denise
-- Thomas
-- Ernest
-- Sophia
-- Jeremy

--suspects - Ernest, Madison, Daniell


select caller, receiver from phone_calls
where day = 28 AND month = 7 AND year = 2020 and duration < 60;


--caller | receiver
--(130) 555-0289 | (996) 555-8899
--(499) 555-9472 | (892) 555-8872
--(367) 555-5533 | (375) 555-8161
--(499) 555-9472 | (717) 555-1342
--(286) 555-6063 | (676) 555-6554
--(770) 555-1861 | (725) 555-3243
--(031) 555-6622 | (910) 555-3251
--(826) 555-1652 | (066) 555-9701
--(338) 555-6650 | (704) 555-2131

select people.name, phone_calls.caller from people
JOIN phone_calls ON people.phone_number = phone_calls.caller
where phone_calls.day = 28 AND phone_calls.month = 7 AND phone_calls.year = 2020 and phone_calls.duration < 60;

-- name | caller
-- Roger | (130) 555-0289
-- Evelyn | (499) 555-9472
-- Ernest | (367) 555-5533
-- Evelyn | (499) 555-9472
-- Madison | (286) 555-6063
-- Russell | (770) 555-1861
-- Kimberly | (031) 555-6622
-- Bobby | (826) 555-1652
-- Victoria | (338) 555-6650

--suspect - Ernest or Madison

select people.name, phone_calls.receiver from people
JOIN phone_calls ON people.phone_number = phone_calls.receiver
where phone_calls.day = 28 AND phone_calls.month = 7 AND phone_calls.year = 2020 and phone_calls.duration < 60;

-- name | receiver
-- Jack | (996) 555-8899
-- Larry | (892) 555-8872
-- Berthold | (375) 555-8161
-- Melissa | (717) 555-1342
-- James | (676) 555-6554
-- Philip | (725) 555-3243
-- Jacqueline | (910) 555-3251
-- Doris | (066) 555-9701
-- Anna | (704) 555-2131

select *from people where name = "Ernest" or name = "Madison";

-- id | name | phone_number | passport_number | license_plate
-- 449774 | Madison | (286) 555-6063 | 1988161715 | 1106N58
-- 686048 | Ernest | (367) 555-5533 | 5773159633 | 94KL13X

--exit | 5P2BI95 | 10 | 16
--exit | 94KL13X | 10 | 18
--exit | 6P58WS2 | 10 | 18
--exit | 4328GD8 | 10 | 19
--exit | G412CB7 | 10 | 20
--exit | L93JTIZ | 10 | 21
--exit | 322W7JE | 10 | 23
--exit | 0NTHK55 | 10 | 23
--exit | 1106N58 | 10 | 35

--comparing both these tables as the witnesses said within 10 minutes the car left the couthouse, so approximately before
--10.25 car must have left, so Madison is eliminated as she left at 10.35. So we left with Ernest.

--caller | receiver
--(130) 555-0289 | (996) 555-8899
--(499) 555-9472 | (892) 555-8872
--(367) 555-5533 | (375) 555-8161
--(499) 555-9472 | (717) 555-1342
--(286) 555-6063 | (676) 555-6554
--(770) 555-1861 | (725) 555-3243
--(031) 555-6622 | (910) 555-3251
--(826) 555-1652 | (066) 555-9701
--(338) 555-6650 | (704) 555-2131

--also the number of Ernest is (367) 555-5533  and he called 555-8161

select name from people where phone_number = "(375) 555-8161";

--PARTNER - Berthold


















