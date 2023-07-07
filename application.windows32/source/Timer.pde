import java.time.LocalTime;
import java.time.Duration;
import java.time.format.DateTimeFormatter;

class Timer {
    LocalTime startTime;

    public Timer() {
        startTime = LocalTime.now();
    }

    String getStartTime(){
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
      return startTime.format(formatter);
    }

    String getPassedTime(){
      LocalTime currentTime = LocalTime.now();
      Duration duration = Duration.between(startTime, currentTime);
  
      long seconds = duration.getSeconds();
      long hours = seconds / 3600;
      long minutes = ((seconds % 3600) / 60);
      seconds = seconds % 60;
  
      return String.format("%02d:%02d:%02d", hours, minutes, seconds);
  }
}
