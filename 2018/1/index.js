const fs = require('fs');

try {
  const input = fs.readFileSync(`${__dirname}/input`, 'utf-8').split('\n');

  console.log(input.map(Number).reduce((a, b) => a + b));
}
catch (err) {
  console.log(err);
}
