/**
 * Miscellaneous text manipulation utilities.
 */
public class StringUtils {
  /**
   * Replace HTML entities in the provided string with their encoded equivalent.
   */
    private static String htmlEncode(String input) {
        String[] fromArr  = new String[]{ '&', '<', '>', '"', '\''};
        String[] toArr  = new String[]{ '&amp;', '&lt;', '&gt;', '&quot;', '&#39;' };
        
        if (input == null || input.length() == 0)
            return input;

        for (Integer i = 0; i < fromArr.size(); ++i) {
            input = input.replace(fromArr[i], toArr[i]);
        }
        
        return input;
    }
}    
