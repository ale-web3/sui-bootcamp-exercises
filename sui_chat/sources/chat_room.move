module sui_chat::chat_room;

use std::string::String;

#[error] const EEditMessageNoOwner:          vector<u8> = b"User can't edit the message: user is not the owner!";
#[error] const EDeleteMessageNotOwner:       vector<u8> = b"User can't delete the message: user not the owner!";
#[error] const EDeleteMessageInvalidMessage: vector<u8> = b"Message not found";

public struct ChatRoom has key {
    id: UID,
    // name: String,
    messages: vector<ID>
}

public struct Message has key {
    id: UID,
    sender: address,
    content: String,
    timestamp: u64
}

public fun create_room(ctx: &mut TxContext): ChatRoom {
    ChatRoom {
        id: object::new(ctx),
        messages: vector::empty(),
    }
}

public fun send_message(chat: &mut ChatRoom, content: String, timestamp: u64, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    
    let message_uid = object::new(ctx);
    let message_id = message_uid.to_inner();

    let message = Message {
        id: message_uid,
        sender,
        content,
        timestamp,
    };

    vector::push_back(&mut chat.messages, message_id);
    transfer::share_object(message);
}

public fun edit_message(message: &mut Message, new_content: String, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == message.sender, EEditMessageNoOwner);
    message.content = new_content;
}

public fun delete_message(chat: &mut ChatRoom, message: Message, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == message.sender, EDeleteMessageNotOwner);

    let mut found = false;
    let mut index = 0;
    let len = vector::length(&chat.messages);

    let Message { id: message_id, sender: _, content: _, timestamp: _ } = message;

    while (index < len) {
        let current_message_id = vector::borrow(&chat.messages, index);
        if (current_message_id == &message_id.to_inner()) {
            found = true;
            break
        };

        index = index + 1;
    };

    assert!(found, EDeleteMessageInvalidMessage);
    vector::remove(&mut chat.messages, index);

    object::delete(message_id);
}