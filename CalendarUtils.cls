public class CalendarUtils {
    /**
     * Use the holidays set up in the system to add a number of working days.
     */
    public static Date addWorkingDays(Date origin, Integer numDays) {
        List<Holiday> holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
        while(numDays > 0) {
            origin = origin.addDays(1);
            if(isWorkingDay(origin, holidays)) {
                numDays--;
            }
        }
        return origin;
    }
    
    private static boolean isWorkingDay(Date currentDate, List<Holiday> holidays){
        Date weekStart  = currentDate.toStartofWeek();
        for(Holiday hDay:holidays){
            if(currentDate.daysBetween(hDay.ActivityDate) == 0){
                return false;
            }
        }
        if(weekStart.daysBetween(currentDate) ==0 || weekStart.daysBetween(currentDate) == 6){
            return false;
        } else {
            return true;
        }
  	}
}

