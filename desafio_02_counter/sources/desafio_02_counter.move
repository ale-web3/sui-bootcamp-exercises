module desafio_02_counter::counter;

use std::debug::print;

public struct Counter has drop {
  current: u64,
  target: u64,
}

#[error]
const ECounterOverflow: u8 = 1;

public fun new(target: u64): Counter {
  Counter { current: 0, target: target }
}

public fun increment(counter: &mut Counter){
  assert!(counter.current < counter.target, ECounterOverflow);
  counter.current = counter.current + 1;
}

public fun get_current(counter: &Counter): u64 {
  print(&counter.current);
  counter.current
}

public fun is_completed(counter: &Counter): bool {
  counter.current == counter.target
}

public fun reset(counter: &mut Counter) {
  counter.current = 0
}

public fun play_counter(counter: &mut Counter): () {
  while (!is_completed(counter)) {
    get_current(counter);
    increment(counter);
  };
  reset(counter);
}

#[test]
public fun main() {
  let mut counter = new(10);
  play_counter(&mut counter);
}