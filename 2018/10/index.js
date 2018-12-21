const fs = require('fs');

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n');

const points = input
  .map((line) => line.match(/=<\s*(-?\d+),\s*(-?\d+)>.+<\s*(-?\d+),\s*(-?\d+)>/))
  .map(([ _, x, y, velx, vely ]) => ({
    x: Number(x),
    y: Number(y),
    velx: Number(velx),
    vely: Number(vely)
  }));

const tick = (points) => points.map(({ x, y, velx, vely }) => ({
  velx,
  vely,
  x: x +velx,
  y: y + vely
}));

const findPoint = (haystack, needle) => haystack.find(({ x: hx, y: hy }) =>
  needle.some(({ x: nx, y: ny }) => hx === nx && hy === ny));

// const findAdjacent = (points) => points.reduce((adjacentCount, { x, y }) => {
//   const north = { x, y: y + 1 };
//   const east = { x: x + 1, y };
//   const south = { x, y: y - 1 };
//   const west = { x: x - 1, y };

//   const nearbyPoints = [ north, east, south, west ];
//   const nearby = findPoint(points, nearbyPoints);

//   if (nearby) {
//     return adjacentCount + 1;
//   }

//   return adjacentCount;
// }, 0);


const findAdjacent = () => 0;

const draw = (points) => {
  const max = points.reduce((acc, { x, y }) => {
    const newX = x > acc.x ? x + 1 : acc.x;
    const newY = y > acc.y ? y + 1 : acc.y;

    return {
      x: newX % 2 === 1 ? newX + 1 : newX,
      y: newY % 2 === 1 ? newY + 1 : newY
    };
  }, { x: 0, y : 0 });

  const shifted = points.map(({ x, y }) => ({ x: x + max.x / 2, y: y + max.y / 2 }));
  // const shifted = points;

  for (let row = 0; row < max.y * 2; row++) {
    const points = shifted.filter(({ y }) => row === y).map(({ x }) => x);
    let line = '';
    for (let col = 0; col < max.x * 2; col++) {
      if (points.includes(col)) {
        line += '#';
      }
      else {
        line += '.';
      }
    }
    console.log(line);
  }
};

const calc = ({ points, bestPoints = [], adjacent = 0, ticksLeft = 5 }) => {
  if (ticksLeft === 0) {
    return { bestPoints, adjacent };
  }

  const nextPoints = tick(points);
  const count = findAdjacent(nextPoints);

  if (count > adjacent) {
    return calc({
      points: nextPoints,
      bestPoints: nextPoints,
      adjacent: count,
      ticksLeft: --ticksLeft
    });
  }

  return {
    points: nextPoints,
    bestPoints: points,
    adjacent,
    ticksLeft: --ticksLeft
  };
};

const doTicks = (points, ticks) => {
  let ret = points;
  while (ticks > 0) {
    ret = tick(ret);
    --ticks;
  }

  return ret;
};

const ticked = doTicks(points, 10117);

const max = (points) => points.reduce((acc, { x, y }) => {
  const newX = x > acc.x ? x + 1 : acc.x;
  const newY = y > acc.y ? y + 1 : acc.y;

  return {
    x: newX % 2 === 1 ? newX + 1 : newX,
    y: newY % 2 === 1 ? newY + 1 : newY
  };
}, { x: 0, y : 0 });

// for (let ticks = 1; ticks < 50; ticks++) {
//   console.log(ticks, max(doTicks(ticked, ticks)));
// }

draw(doTicks(points, 10117));
// RGRKHKNA
