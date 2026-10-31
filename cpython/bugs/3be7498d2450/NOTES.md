Calls TextCalendar/HTMLCalendar.formatmonth(2017, 13) and (2017, -1).
Clean raises IllegalMonthError for both. The buggy build raises a bare IndexError
for month 13 (formatmonthname no longer validates); -1 still raises IllegalMonthError
(via monthrange).
