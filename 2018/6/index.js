// const input = [
//   [ 1, 1 ],
//   [ 1, 6 ],
//   [ 8, 3 ],
//   [ 3, 4 ],
//   [ 5, 5 ],
//   [ 8, 9 ]
// ];

const fs = require('fs');
const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n').map((line) => line.split(', ').map(Number));

const array = (n) => Array.from(Array(Number(n)));

const getSize = (input) => input.reduce(({ w = 0, h = 0 }, [ x, y ]) => ({
  w: x + 2 > w ? x + 2 : w,
  h: y + 1 > h ? y + 1 : h
}), {});

const makeGrid = ({ w, h }) => array(h).map(() => array(w).map(() => '.'));

const logGrid = (grid) => console.log(JSON.stringify(grid.map((row) => row.join('')), null, 2));

String.prototype.nextChar = function(i) {
    var n = i | 1;
    return String.fromCharCode(this.charCodeAt(0) + n);
};

const addPoints = (grid, input) => input.reduce(({ grid, label }, [ x, y ]) => {
  grid[y][x] = label;

  return { grid, label: label.nextChar() };
}, { grid, label: 'A' }).grid;

const manhattanDistance = ({ x, y }) => ([ ex, ey ]) => Math.abs(x - ex) + Math.abs(y - ey);

const calculateDistances = (grid, input) => {
  const points = input.reduce((acc, coords) => ({
    ...acc,
    [coords.join(',')]: 0
  }), {});

  console.log(grid.length, grid[0].length);
  grid.forEach((row, y) => row.forEach((col, x) => {
    const distances = input.map(manhattanDistance({ x, y }));
    const sorted = [ ...distances].sort((a, b) => a < b ? -1 : a > b ? 1 : 0);
    const smallest = sorted[0];

    if (sorted[0] === sorted[1]) {
      // console.log(`${x}, ${y} is tied`);
    }
    else {
      const index = distances.findIndex((it) => it === smallest);
      points[input[index].join(',')]++;

      if (y === 0 || x === 0 || y === grid.length + 1 || x === row.length + 1) {
        points[input[index].join(',')] = -10000;
      }
    }
  }));

  return points;
};

const byArea = (distancesByPoint) => {
  console.log(Object.values(distancesByPoint).sort((a, b) => a < b ? - 1 : a > b ? 1 : 0).reverse());
};

// console.log(logGrid(addPoints(makeGrid(getSize(input)), input)));

byArea(calculateDistances(makeGrid(getSize(input)), input));

`
aaaaa.cccc
aAaaa.cccc
aaaddecccc
aadddeccCc
..dDdeeccc
bb.deEeecc
bBb.eeee..
bbb.eeefff
bbb.eeffff
bbb.ffffFf
`;
