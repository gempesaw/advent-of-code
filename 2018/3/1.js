const fs = require('fs');
const assert = require('assert');

const array = (n) => Array.from(Array(Number(n)));

const makeCanvas = (n) => {
  const length = array(n);
  return length.map((a) => length.map((b) => 0));
};

const toClaim = (claim) => {
  const [ id, , x, y, , w, h ] = claim.split(/[ ,:x]/);

  return {
    id,
    x: Number(x),
    y: Number(y),
    w: Number(w),
    h: Number(h)
  };
};

const addClaimToCanvas = (canvas, { id, x, y, w, h }) => {
  const width = array(w);
  const height = array(h);

  // forEach ... blah.... prefer reduce here? but the double reduce
  // ... i can't figure it out
  width.forEach((_, windex) =>
    height.forEach((_, hindex) =>
      canvas[hindex + y][windex + x]++
    )
  );

  return canvas;
};

const isNotOverlapped = (canvas) => ({ id, x, y, w, h}) => {
  const width = array(w);
  const height = array(h);

  let sum = 0;
  width.forEach((_, windex) => height.forEach((_, hindex) => {
    sum += canvas[hindex + y][windex + x];
  }));

  if (sum === w * h) {
    return id;
  }

  return null;
};

(() => {
  const test = [
    '#1 @ 1,3: 4x4',
    '#2 @ 3,1: 4x4',
    '#3 @ 5,5: 2x2'
  ].map(toClaim);

  const canvas = test.reduce(addClaimToCanvas, makeCanvas(8));
  const overlap = canvas.reduce((a, b) => a.concat(b)).filter((it) => it > 1).length;
  assert.equal(overlap, 4);

  const perfect = test.find(isNotOverlapped(canvas));
  assert.deepStrictEqual(perfect, test[2]);
})();

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n').map(toClaim);
const canvas = input.reduce(addClaimToCanvas, makeCanvas(1000));
const overlap = canvas.reduce((a, b) => a.concat(b)).filter((it) => it > 1).length;
console.log(overlap);

const perfect = input.find(isNotOverlapped(canvas));
console.log(perfect);
