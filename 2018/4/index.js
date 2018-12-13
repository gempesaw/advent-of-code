const fs = require('fs');
const moment = require('moment');

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n');
// const input = [
//   '[1518-11-01 00:00] Guard #10 begins shift',
//   '[1518-11-01 00:05] falls asleep',
//   '[1518-11-01 00:25] wakes up',
//   '[1518-11-01 00:30] falls asleep',
//   '[1518-11-01 00:55] wakes up',
//   '[1518-11-01 23:58] Guard #99 begins shift',
//   '[1518-11-02 00:40] falls asleep',
//   '[1518-11-02 00:50] wakes up',
//   '[1518-11-03 00:05] Guard #10 begins shift',
//   '[1518-11-03 00:24] falls asleep',
//   '[1518-11-03 00:29] wakes up',
//   '[1518-11-04 00:02] Guard #99 begins shift',
//   '[1518-11-04 00:36] falls asleep',
//   '[1518-11-04 00:46] wakes up',
//   '[1518-11-05 00:03] Guard #99 begins shift',
//   '[1518-11-05 00:45] falls asleep',
//   '[1518-11-05 00:55] wakes up'
// ];

const records = input
  .map((line) => line.split(/\[|\]/))
  .map(([ , time, action ]) => ({
    time: moment(time),
    action: action.trim()
  }))
  .sort(({ time: a }, { time: b }) => {
    if (a < b) {
      return -1;
    }

    if (a > b) {
      return 1;
    }

    return 0;
  });

const { acc: byGuard } = records.reduce(({ acc, current }, { time, action }) => {
  const matches = action.match(/#(\d+) begins shift/);
  if (matches) {
    current = matches[1];
  }

  acc[current] = (acc[current] || []).concat({ time, action });

  return { acc, current };
}, { acc: {}, current: null });

const setState = (state = Array.from(Array(60)).fill(0), minute = 60, asleep = false) => state.slice(0, minute).concat( Array.from(Array(60 - minute)).fill(Number(asleep)));

const byDay = {};
Object.entries(byGuard).forEach(([ id, logs ]) => {
  logs.forEach(({ time, action }) => {
    const day = `${time.month() + 1}-${time.date()}`;
    byDay[id] = byDay[id] || {};

    const begins = action.includes('begins shift');

    const minute = begins
      ? 0
      : time.minutes();
    const asleep = action.includes('falls asleep');

    byDay[id][day] = setState(byDay[id][day] || setState(), minute, asleep);
  });
});

const byMinutesSlept = Object.entries(byDay).map(([id, days]) => ({
  id,
  minutes: Object.values(days).reduce((a, b) => a.concat(b), []).reduce((a, b) => a + b)
}));

const sleepiestId = byMinutesSlept.sort(({ minutes: a }, { minutes: b }) => a < b ? 1 : a > b ? -1 : 0)[0].id;

const sleepiestLogs = byDay[sleepiestId];
const byMinuteForSleepiest = Object.entries(sleepiestLogs)
  .map(([ day, minutes ]) => minutes.map((asleep, minute) => ({ asleep, minute })))
  .reduce((a, b) => a.concat(b), [])
  .reduce((acc, { asleep, minute }) => {
    acc[minute] = (acc[minute] || 0) + asleep;

    return acc;
  }, {});

const sleepiestMinute = Object.entries(byMinuteForSleepiest).reduce((acc, [ minute, slept ]) => {
  if (slept > acc.slept) {
    return {
      minute,
      slept
    };
  }

  return acc;
}, { slept: 0 });

// console.log('part 1: id #', sleepiestId, sleepiestMinute);

const byMinuteForAllGuards = Object.entries(byDay)
  .map(([ id, days ]) => ({
    id,
    minutes: Object.entries(days)
      .map(([ day, minutes ]) => { console.log(minutes.join(''), id, day); return [ day, minutes ]; })
      .map(([ day, minutes ]) => minutes.map((asleep, minute) => ({ asleep, minute })))
      .reduce((a, b) => a.concat(b), [])
      .reduce((acc, { asleep, minute }) => {
        acc[minute] = (acc[minute] || 0) + asleep;

        return acc;
      }, {})
  }));

const mostSleptMinute = byMinuteForAllGuards.reduce((acc, { id, minutes }) => {
  const mostSleptMinuteForGuard = Object.entries(minutes).reduce((acc, [ minute, frequency ]) => {
    if (frequency > acc.frequency) {
      return { minute, frequency };
    }

    return acc;
  }, { frequency: 0 });
  console.log(id, mostSleptMinuteForGuard);

  if (mostSleptMinuteForGuard.frequency > acc.frequency) {
    return {
      ...mostSleptMinuteForGuard,
      id
    };
  }

  return acc;

}, { frequency: 0 });

console.log(JSON.stringify(mostSleptMinute, null, 2));
