const marble = ({ number, prev = null, next = null, current = true }) => ({
  number,
  prev,
  next,
  current
});

const getStart = () => {
  const start = marble({ number: 0 });
  start.prev = start;
  start.next = start;
  return start;
};

const traverseCounterClockwise = (it, times = 0) => times ? traverseCounterClockwise(it.prev, --times) : it;

const remove = ({ prev, next }) => {
  prev.next = next;
  next.prev = prev;
  next.current = true;

  return next;
};

const score = (current) => {
  const { number, prev, next } = traverseCounterClockwise(current, 7);
  const newCurrent = remove({ prev, next });

  return { newCurrent, otherNumber: number };
};

const play = ({ current, scores }, number, player) => {
  number++;

  if (number % 23 === 0) {
    current.current = false;

    const scorer = player % scores.length;
    const { newCurrent, otherNumber } = score(current);

    scores[scorer] += number + otherNumber;
    return {
      current: newCurrent,
      scores
    };
  }

  current.current = false;

  const prev = current.next;
  const next = current.next.next;

  const node = marble({ number, prev, next });
  prev.next = node;
  next.prev = node;
  return { current: node, scores };
};

const walk = ({ number, next, current }, state = []) => {
  if (state.includes(number)) {
    return state;
  }

  if (current) {
    return walk(next, [ ...state, `(${number})` ]);
  }
  else {
    return walk(next, [ ...state, number ]);
  }
};

const fill = (n) => Array.from(Array(n)).map((_, x) => x);

const getScores = (n) => fill(n).map((_) => 0);

const run = (last = 71223, players = 455) => {
  const start = getStart();
  const { current, scores } = fill(last).reduce(play, { current: start, scores: getScores(players) });

  return scores.reduce((a, b) => a > b ? a : b, 0);
};

console.log(`1. ${run()}`);
console.log(`1. ${run(7122300)}`);

// tests
// 10 players; last marble is worth 1618 points: high score is 8317
// 13 players; last marble is worth 7999 points: high score is 146373
// 17 players; last marble is worth 1104 points: high score is 2764
// 21 players; last marble is worth 6111 points: high score is 54718
// 30 players; last marble is worth 5807 points: high score is 37305

// real
// 455 players; last marble is worth 71223 points
