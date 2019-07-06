const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});
const sub = redisClient.duplicate();

function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

var comp_fib = 0;

sub.on('message', (channel, index) => {
  if(index == "") return;
  console.log("worker: (on message) channel: ", channel);
  console.log("worker: (on message) index: ", index);
  comp_fib = fib(parseInt(index));
  redisClient.hset('values', index, comp_fib);
  console.log("worker: index: ", index, " -- computed fib: ", comp_fib);
});
sub.subscribe('insert');
