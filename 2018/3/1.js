const fs = require('fs');
const assert = require('assert');

const array = (n) => Array.from(Array(Number(n)));

const makeCanvas = (n) => {
  const length = array(n);
  return length.map((a) => length.map((b) => 0));
};

const addClaimToCanvas = (canvas, { x, y, w, h }) => {
  const width = array(w);
  const height = array(h);

  width.forEach((_, windex) => height.forEach((_, hindex) => canvas[hindex + y][windex + x]++));

  return canvas;
};

const handleClaim = (canvas, claim) => {
  const [ , , x, y, , w, h ] = claim.split(/[ ,:x]/);

  return addClaimToCanvas(canvas, { x: Number(x), y: Number(y), w: Number(w), h: Number(h) });
};


(() => {
  const test = [
    '#1 @ 1,3: 4x4',
    '#2 @ 3,1: 4x4',
    '#3 @ 5,5: 2x2'
  ];

  const canvas = test.reduce(handleClaim, makeCanvas(8));
  const overlap = canvas.reduce((a, b) => a.concat(b)).filter((it) => it > 1).length;
  assert.equal(overlap, 4);
})();

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n');
const canvas = input.reduce(handleClaim, makeCanvas(1000));
const overlap = canvas.reduce((a, b) => a.concat(b)).filter((it) => it > 1).length;
console.log(overlap);
