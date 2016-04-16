@isTest
public class CalendarUtilsTest {
    static testMethod void testAddWorkingDaysSkipWeekends() {
        Date result = CalendarUtils.addWorkingDays(Date.newInstance(2016,4,15), 4);
        System.assertEquals(Date.newInstance(2016, 4, 21), result);
    }
    
    static testMethod void testAddWorkingDaysSkipHolidays() {
        Holiday h = new Holiday();
        h.IsAllDay = true;
        h.IsRecurrence = false;
        h.Name = 'Sample';
        h.ActivityDate = Date.newInstance(2016, 4, 12);
        insert h;
        Date result = CalendarUtils.addWorkingDays(Date.newInstance(2016, 4, 11), 2);
        System.assertEquals( Date.newInstance(2016, 4, 14), result);
    }
}
