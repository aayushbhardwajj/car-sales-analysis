SELECT * FROM `eastern-moment-369822.Assignment.car_sales` LIMIT 1000;

-- Correcting the column name

alter table
  `Assignment.car_sales`
rename column 
  Emplyee_Code to Employee_Code;


-- PROBLEM STATEMENT 1: Overall performance in the city?

-- a.1) Month that generates highest inquiry date

select 
  Month as month_of_the_year,
  count(*) as total_inquiry
from
  `eastern-moment-369822.Assignment.car_sales`
group by
  month
order by
  total_inquiry desc;


-- a.2) Month that generates highest Booking Confirmation

select
  Month as month_of_the_year,
  count(Booking_Confirmed) as total_booking_confirmed
from
  `eastern-moment-369822.Assignment.car_sales`
where
  booking_confirmed = true
group by
  month
order by
  total_booking_confirmed desc;


-- a.3) Month that generates highest Sale Confirmation

select
  Month as month_of_the_year,
  count(Sale_Confirmed) as total_sale_confirmed
from
  `eastern-moment-369822.Assignment.car_sales`
where
  sale_confirmed = true
group by
  month
order by
  total_sale_confirmed desc;


-- b) Car model that sell best and car with the highest % of bookings after a test drive
-- reference columns for the analysis - Car Model - Test Drives True - Booking Confirmed - order by sales count

select
  Car_Model,
  count(*) as total_test_drive_given,
  (countif(Booking_Confirmed) / count(*))*100 as percent_confirms,
  (countif(Sale_Confirmed) / (1+countif(Booking_Confirmed))) * 100 as percent_sales
from
  `Assignment.car_sales`
where
  Testdrive = 'Given'
group by
  Car_Model
order by
  percent_sales desc;


-- c) Overall metrics across the entire pipeline (Inquiry - Invoice confirmation)

-- Metric based on for car model

select
  Car_Model,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Car_Model;


-- Metric based on Dealer

select
  Dealer,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Dealer
order by
  sales_conversion desc;


-- Metrics based on month 

select
  Month,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Month;


-- Metrics based on Employees_code

select
  cast(Employee_Code as int) as employee_code,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Employee_Code;


-- Metrics based on financier

select
  Financier,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Financier;


-- d) Financiers that have been used frequently

select
  Financier,
  count(*) as total_number_of_sales
from
  `Assignment.car_sales`
where
  Financier is not null
group by
  Financier
order by
  total_number_of_sales desc;


-- PROBLEM STATEMENT 2: Insights on the individual dealers.

-- a) Identifing the high-performing dealers based on the volume of inquiry and their conversion through the pipeline.

select
  Dealer,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Dealer
order by
  sales_conversion desc;


-- b) Dealer optimization w.r.t to Source of Inquiry

select
  Dealer,
  max(Source_PV_) as customer_source,
  count(Source_PV_) as customer_source_count
from
  `Assignment.car_sales`
group by
  Source_PV_ , Dealer
order by customer_source_count desc
limit 1000;



-- c) Car models having a better performance at the store?

select
  Car_Model,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Car_Model
order by
  sales_conversion desc
Limit 5;


-- d) Does the showroom perform as expected based on the volume of staff it has? Justify with metrics.

-- Employee performance considering test drive convertion, booking convertion and sale conversion

select
  cast(Employee_Code as int) as employee_code,
  count(*) as total_inquiries,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Employee_Code
order by
  total_inquiries desc;


-- Employee performance considering test drive not given, but still have booking convertion and sale conversion

select
  cast(Employee_Code as int) as employee_code,
  count(*) as total_inquiries,
  (countif(Testdrive='Not given')/(1+count(*)))*100 as test_drives_conversion,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Not given')))*100 as bookings_conversion,
  (countif(Sale_Confirmed)/(1+countif(Testdrive='Not given')))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Employee_Code
order by
  total_inquiries desc;
-- the resul of the ablove query Shows that staff volume is important to have better showroom performance


-- PROBLEM STATEMENT 3:

-- a) Identifing top-performing employees

select
  cast(Employee_Code as int) as employee_code,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Employee_Code
order by
  sales_conversion desc
limit 10;



-- b) Identifing low-performing employees for an additional training program.

select
  cast(Employee_Code as int) as employee_code,
  count(*) as total_inquiries,
  countif(Testdrive='Given') as total_test_drives,
  (countif(Testdrive='Given')/(1+count(*)))*100 as test_drives_conversion,
  countif(Booking_Confirmed)as total_bookings,
  (countif(Booking_Confirmed)/(1+countif(Testdrive='Given')))*100 as bookings_conversion,
  countif(Sale_Confirmed) as total_sales ,
  (countif(Sale_Confirmed)/(1+countif(Booking_Confirmed)))*100 as sales_conversion
from
  `Assignment.car_sales`
group by
  Employee_Code
order by
  sales_conversion
limit 10;

