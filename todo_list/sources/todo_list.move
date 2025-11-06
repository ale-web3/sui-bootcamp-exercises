module todo_list::todo_list;

use std::string::String;

public struct TodoList has key, store {
    id: UID,
    tasks: vector<String>
}

public fun new(ctx: &mut TxContext) {
    let list = TodoList {
        id: object::new(ctx),
        tasks: vector[]
    };

    transfer::transfer(list, tx_context::sender(ctx));
}