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

public fun add_item(list: &mut TodoList, item: String) {
    list.tasks.push_back(item);
}

public fun remove_item(list: &mut TodoList, index: u64) {
    list.tasks.remove(index);
}

public fun edit_item(list: &mut TodoList, index: u64, new_content: String) {
    let elem = &mut list.tasks[index];
    *elem = new_content;
}