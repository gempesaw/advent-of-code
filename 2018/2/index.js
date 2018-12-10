const assert = require('assert');
const fs = require('fs');

const countOccurences = (string) => {
  const pieces = string.split('');
  const chars = [ ...new Set(pieces) ];

  return chars.reduce((acc, it) => ({
    ...acc,
    [it]: pieces.filter((piece) => piece === it).length
  }), {});
};

const countTwosAndThrees = (string) => {
  const counts = Object.values(countOccurences(string));

  return {
    twos: +counts.includes(2),
    threes: +counts.includes(3)
  };
};

const checksum = (ids) => {
  const counts = ids.reduce((acc, it) => {
    const { twos, threes } = countTwosAndThrees(it);
    return {
      twos: acc.twos + twos,
      threes: acc.threes + threes
    };
  }, { twos: 0, threes: 0 });

  return counts.twos * counts.threes;
};

assert.deepEqual(countTwosAndThrees('abcdef'), { twos: 0, threes: 0 });
assert.deepEqual(countTwosAndThrees('bababc'), { twos: 1, threes: 1 });
assert.deepEqual(countTwosAndThrees('abbcde'), { twos: 1, threes: 0 });
assert.deepEqual(countTwosAndThrees('abcccd'), { twos: 0, threes: 1 });
assert.deepEqual(countTwosAndThrees('aabcdd'), { twos: 1, threes: 0 });
assert.deepEqual(countTwosAndThrees('abcdee'), { twos: 1, threes: 0 });
assert.deepEqual(countTwosAndThrees('ababab'), { twos: 0, threes: 1 });

const ids = [
  'abcdef',
  'bababc',
  'abbcde',
  'abcccd',
  'aabcdd',
  'abcdee',
  'ababab'
];

assert.equal(checksum(ids), 12);

const input = fs.readFileSync(`${__dirname}/input`, 'utf-8');
console.log(checksum(input.split('\n')));
