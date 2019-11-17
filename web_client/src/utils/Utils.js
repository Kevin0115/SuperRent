import moment from 'moment';

export const formatDate = (date) => {
  return moment(date).format('YYYY-MM-DD');
}

export const formatTime = (date) => {
  return moment(date).format('hh:mm:ss');
}

export const formatLocation = (location) => {
  let string = location.toLowerCase();
  return string.charAt(0).toUpperCase() + string.slice(1);
}

export const calculatePrice = (from, to, hourlyRate, dailyRate, weeklyRate) => {
  const intervalSeconds = moment(to).unix() - moment(from).unix();
  const intervalHours = intervalSeconds / 3600;
  const intervalDays = intervalHours / 24;
  const intervalWeeks = intervalDays / 7;
  let hourly = Number.MAX_SAFE_INTEGER;
  let daily = Number.MAX_SAFE_INTEGER;
  let weekly = Number.MAX_SAFE_INTEGER;
  if (intervalHours >= 1) {
    hourly = intervalHours * hourlyRate;
  }
  if (intervalDays >= 1) {
    daily = intervalDays * dailyRate;
  }
  if (intervalWeeks >= 1) {
    weekly = intervalWeeks * weeklyRate;
  }

  console.log('Hourly: ' + hourly)
  console.log('Daily: ' + daily)
  console.log('Weekly: ' + weekly)

  return Math.min(hourly, daily, weekly);
}