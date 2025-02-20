--query1 : Print the three most used stickers by the user with the username mohammad.
SELECT  account_stickers.sticker_id, account_stickers.number_of_use
FROM account_stickers
JOIN telegram_user ON account_stickers.account_id = telegram_user.user_id
WHERE telegram_user.username = 'mohammad'
ORDER BY account_stickers.number_of_use DESC
LIMIT 3;


--query2 : Print all mutual contacts between users with the usernames ali and mohammad.
SELECT telegram_user.user_id,telegram_user.first_name,telegram_user.last_name
FROM telegram_user WHERE telegram_user.user_id in(SELECT contact.account2_id
FROM contact JOIN telegram_user ON telegram_user.user_id = contact.account1_id 
and telegram_user.username = 'mohammad' intersect (
SELECT contact.account2_id FROM telegram_user
JOIN contact ON telegram_user.user_id = contact.account1_id
WHERE telegram_user.username = 'ali'));


--query3 : Print the number of messages along with the names of groups that have more than 10,000 members, sorted by the number of messages.
SELECT telegram_group.name, chat.number_of_messages
FROM telegram_group
JOIN chat ON telegram_group.group_id = chat.chat_id
WHERE telegram_group.number_of_members > 10000
ORDER BY chat.number_of_messages DESC;


--query4 : Print the name of the group with the most messages in the last 10 days.
SELECT telegram_group.name 
FROM telegram_group
JOIN chat ON telegram_group.group_id = chat.chat_id
JOIN message ON chat.chat_id = message.chat_id
JOIN user_message_send ON message.message_id = user_message_send.message_id
WHERE user_message_send.send_date >= CURRENT_DATE - INTERVAL '10 days'
GROUP BY telegram_group.name
ORDER BY COUNT(message.message_id) DESC
LIMIT 1;


--query5 : Print the total size of files uploaded by the user with the most group memberships.
SELECT SUM(media.size) AS total_document_size
FROM document
JOIN media ON document.document_id = media.media_id
JOIN message ON message.media_id = media.media_id
JOIN user_message_send ON user_message_send.message_id = message.message_id
WHERE user_message_send.user_id = (
    SELECT group_account_memberOf.account_id
    FROM group_account_memberOf
    GROUP BY group_account_memberOf.account_id
    ORDER BY COUNT(group_account_memberOf.group_id) DESC
    LIMIT 1
);


--query6 : Print the names of users who are members of at most two groups.
SELECT DISTINCT telegram_user.first_name, telegram_user.last_name
FROM telegram_user
JOIN group_account_memberOf ON telegram_user.user_id = group_account_memberOf.account_id
WHERE group_account_memberOf.account_id IN (
    SELECT group_account_memberOf.account_id
    FROM group_account_memberOf
    GROUP BY group_account_memberOf.account_id
    HAVING COUNT(group_account_memberOf.group_id) <= 2
);


--query7 : Print phone numbers that start with +912 and end with 8.
SELECT phone_number
FROM account
WHERE phone_number LIKE '0912%' AND phone_number LIKE '%8';


--query8 : List users who are members of exactly 2 channels.
SELECT DISTINCT telegram_user.first_name, telegram_user.last_name
FROM telegram_user
JOIN channel_account_subscriberOf ON telegram_user.user_id = channel_account_subscriberOf.account_id
WHERE channel_account_subscriberOf.account_id IN (
    SELECT channel_account_subscriberOf.account_id
    FROM channel_account_subscriberOf
    GROUP BY channel_account_subscriberOf.account_id
    HAVING COUNT(channel_account_subscriberOf.channel_id) = 2
);


--query9 : Print all messages that exist in a group where both users with usernames hossein and ali are members.
SELECT message.message_id, media.URL
FROM message
JOIN media ON message.media_id = media.media_id
JOIN chat ON message.chat_id = chat.chat_id
JOIN telegram_group ON chat.chat_id = telegram_group.group_id
JOIN group_account_memberOf gam1 ON gam1.group_id = telegram_group.group_id
JOIN group_account_memberOf gam2 ON gam2.group_id = telegram_group.group_id
JOIN telegram_user tu1 ON gam1.account_id = tu1.user_id
JOIN telegram_user tu2 ON gam2.account_id = tu2.user_id
WHERE tu1.username = 'ali' 
AND tu2.username = 'hossein';


--query10 : Print the average number of characters in messages sent by the bot with the username first_bot.
SELECT AVG(text.length) AS average_text_length
FROM telegram_user
JOIN bot ON telegram_user.user_id = bot.bot_id
JOIN user_message_receive ON user_message_receive.user_id = telegram_user.user_id
JOIN message ON user_message_receive.message_id = message.message_id
JOIN media ON message.media_id = media.media_id
JOIN text ON media.media_id = text.text_id
WHERE telegram_user.username = 'first_bot' AND media.media_type = 'text';