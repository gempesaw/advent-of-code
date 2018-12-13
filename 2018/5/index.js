const assert = require('assert');
const fs = require('fs');

const toggleCase = (char) => {
  if (char === char.toUpperCase()) {
    return char.toLowerCase();
  }

  return char.toUpperCase();
};

const reduce = (input) => {
  const { string, left } = input.split('').reduce(({ string, left }, right) => {
    if (left && right === toggleCase(left)) {
      const [ newLeft, ...newString ] = string;
      return {
        string: newString,
        left: newLeft
      };
    }

    return {
      string: [ left, ...string ],
      left: right
    };
  }, { string: '', left: null });

  return [ left, ...string ]
    .filter(Boolean)
    .reverse()
    .join('');
};


(() => {
  const input = 'dabAcCaCBAcCcaDA';
  const expected = 'dabCBAcaDA';

  assert.equal(expected, reduce(input));
})();

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8');
console.log(reduce(input), reduce(input).length);
