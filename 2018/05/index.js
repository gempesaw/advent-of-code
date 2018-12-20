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

const length = (input) => reduce(input).length;

const uniqueChars = (input) => Object.keys(input.split('').reduce((acc, it) => ({
  ...acc,
  [it.toLowerCase()]: (acc[it.toLowerCase()] || 0) + 1
}), {}));

const improve = (input) => (char) => {
  const improved = input.replace(new RegExp(`${char}`, 'ig'), '');
  const improvedLength = length(improved);

  return {
    char,
    length: improvedLength
  };
};

const getImprovedLengths = (input) => uniqueChars(input).map(improve(input));

const getMostImproved = (improved) => improved.slice().sort(({ length: a }, { length: b }) => a < b ? -1 : a > b ? 1 : 0)[0];

(() => {
  const input = 'dabAcCaCBAcCcaDA';
  const expected = 'dabCBAcaDA';

  assert.equal(length(input),expected.length);

  // { char: 'c', length: 4 }
  assert.equal(getMostImproved(getImprovedLengths(input)).length, 4);
})();

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8');
console.log(reduce(input).length);
console.log(getMostImproved(getImprovedLengths(input)));
