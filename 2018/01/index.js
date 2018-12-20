const fs = require('fs');
const assert = require('assert');

const getRepeated = (input) => (acc = [ 0 ], argFirst = null, it = 0) => {
  process.stdout.write(`${it}\r`);
  if (argFirst !== null) {
    return argFirst;
  }

  const { acc: nextAcc, first: nextFirst } = input
    .map(Number)
    .reduce(({ acc: list, first }, it) => {
      const next = list[list.length - 1] + it;
      const nextList = list.concat(next);

      if (first === null && list.includes(next)) {
        return { acc: nextList, first: next };
      }

      return { acc: nextList, first };
    }, { acc, first: null });

  return getRepeated(input)(nextAcc, nextFirst, ++it);
};

try {
  const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n');

  assert.equal(getRepeated([ +1, -1 ])(), 0);
  assert.equal(getRepeated([ +3, +3, +4, -2, -4 ])(), 10);
  assert.equal(getRepeated([ -6, +3, +8, +5, -6 ])(), 5);
  assert.equal(getRepeated([ +7, +7, -2, -7, -4 ])(), 14);

  console.log(JSON.stringify(getRepeated(input)(), null, 2));

}
catch (err) {
  console.log(err);
}
