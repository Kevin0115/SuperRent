import moment from 'moment';

export const formatDate = (date) => {
  return moment(date).format('YYYY-MM-DD');
}

export const formatTime = (date) => {
  return moment(date).format('hh:mm:ss');
}

export const capitalizeWord = (word) => {
  if (word == null) {
    return null;
  }
  let string = word.toLowerCase();
  return string.charAt(0).toUpperCase() + string.slice(1);
}

export const formatType = (vtname) => {
  if (vtname == null) {
    return null;
  }
  let type = vtname.toLowerCase().split('_')[1];
  let size = vtname.toLowerCase().split('_')[0];
  
  return capitalizeWord(type) + ' ' + capitalizeWord(size);
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

export const noNullState = (obj) => {
  for (let key in obj) {
    if(obj[key] == null) {
      return false;
    }
  }
  return true;
}