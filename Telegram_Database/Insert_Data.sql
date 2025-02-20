INSERT INTO telegram_user (user_id, username, first_name, last_name) VALUES
(1, 'mohammad', 'Mohammad', 'Karimi'),
(2, 'ali', 'Ali', 'Zadeh'),
(3, 'yasamin', 'Yasamin', 'Riahi'),
(4, 'kimia', 'Kimia', 'Sadeghi'),
(5, 'hossein', 'Hossein', 'Shahbazi'),
(6, 'first_bot', 'First bot' , NULL),
(7, 'second_bot', 'Second bot' , NULL);


INSERT INTO account (account_id, phone_number, last_seen, bio, birth_day, birth_month, birth_year, account_type) VALUES
(1, '09131234567', '2025-01-30 10:00:00', 'Bio of Mohammad', 1, 1, 1990, 0),
(2, '09126934568', '2025-01-29 10:00:00', 'Bio of Ali', 2, 2, 1991, 0),
(3, '09141234569', '2025-01-28 10:00:00', 'Bio of Yasamin', 3, 3, 1992, 0),
(4, '09121234570', '2025-01-27 10:20:00', 'Bio of Kimia', 4, 4, 1993, 2),
(5, '09121234578', '2025-01-26 10:50:00', 'Bio of Hossein', 5, 5, 1994, 0);


INSERT INTO bot (bot_id, about, number_of_users) VALUES
(6, 'First bot', 100),
(7, 'Second bot', 200);


INSERT INTO chat (chat_id, number_of_messages, chat_type) VALUES
(1, 50, 'Group'),
(2, 20, 'Channel'),
(3, 200000, 'Group'),
(4, 10000, 'PV'),
(5, 30, 'Channel'),
(6,657,'PV'),
(7,89000,'Group'),
(8,100,'PV'),
(9,110,'PV');


INSERT INTO folder (folder_id, account_id, folder_name) VALUES
(1, 4, 'KNTU'),
(2, 4, 'personel');


INSERT INTO user_pv (pv_id, user1_id, user2_id) VALUES
(4, 3, 4),
(6,1,5),
(8,3,6),
(9,4,6);


INSERT INTO telegram_group (group_id, invite_link, name, is_private, number_of_members, is_history_hidden) VALUES
(1, 'invite_link_1', 'DB', true, 100, true),
(3, 'invite_link_2', 'KNTU NEWS', false, 15000, false),
(7, 'invite_link_3', 'MUSIC',false,12000,false);


INSERT INTO channel (channel_id, invite_link, name, is_private, number_of_subscribers) VALUES
(2, 'channel_link_1', 'DB 4031 KNTU', false, 120),
(5, 'channel_link_2', 'MUSIC Channel', false, 12000);


INSERT INTO channel_discussion(channel_id,group_id) VALUES
(2,1);


INSERT INTO media (media_id, URL, size, media_type) VALUES
(1, 'hexample.com/media1', 10, 'text'),
(2, 'h/example.com/media2', 20, 'sticker'),
(3, 'h/example.com/media3', 100, 'document'),
(4, 'h/example.com/media4', 20, 'text'),
(5, 'h/example.com/media5', 10, 'sticker'),
(6, 'h/example.com/media6', 20, 'text'),
(7, 'h/example.com/media7', 150, 'document'),
(8, 'h/example.com/media8', 20, 'text'),
(9, 'h/example.com/media9', 10, 'sticker'),
(10, 'h/example.com/media10', 10, 'sticker'),
(11, 'h/example.com/media11', 20, 'text');


INSERT INTO sticker_pack (sticker_pack_id, name) VALUES
(1, 'Sticker Pack 1'),
(2, 'Sticker Pack 2');


INSERT INTO sticker (sticker_id, sticker_pack_id) VALUES
(2, 1),
(5, 1),
(9, 2),
(10,2);


INSERT INTO document(document_id,document_format,name) VALUES
(3,'pdf','Chapter1'),
(7,'.doc','Midterm');


INSERT INTO text (text_id,length) VALUES
(1,12),
(4,29),
(6,100),
(8,98),
(11,76);


INSERT INTO message (message_id, chat_id, media_id, read_status, edit_time) VALUES
(1, 1,2,false, NULL),
(2, 1,2,false, NULL),
(3, 3,7,false, NULL),
(4, 3,6,false, NULL),
(5, 1,7,false, NULL),
(6, 1,10,false, NULL),
(7, 1,6,false, NULL),
(8, 8,1,false, NULL),
(9, 9,4,false, NULL),
(10, 7,3,false, NULL),
(11, 2,5,false, NULL),
(12, 3,5,false, NULL),
(13, 1,8,false, NULL),
(14, 3,9,false, NULL);


INSERT INTO user_message_send (message_id, user_id, send_date, send_time) VALUES
(1, 1, CURRENT_DATE - INTERVAL '2 days', '10:00:00'),
(2, 1, CURRENT_DATE - INTERVAL '3 days', '11:30:00'),
(3, 1, CURRENT_DATE - INTERVAL '5 days', '15:45:00'),
(4, 1, CURRENT_DATE - INTERVAL '7 days', '18:20:00'),
(5, 3, CURRENT_DATE - INTERVAL '8 days', '22:10:00'),
(6, 3, CURRENT_DATE - INTERVAL '1 days', '09:15:00'),
(7, 3, CURRENT_DATE - INTERVAL '2 days', '13:30:00'),
(8, 3, CURRENT_DATE - INTERVAL '4 days', '17:00:00'),
(9, 4, CURRENT_DATE - INTERVAL '6 days', '20:45:00'),
(10, 1, CURRENT_DATE - INTERVAL '7 days', '23:59:00'),
(11, 2, CURRENT_DATE - INTERVAL '8 days', '12:10:00'),
(12, 3, CURRENT_DATE - INTERVAL '9 days', '14:05:00'),
(13, 1, CURRENT_DATE - INTERVAL '10 days', '08:30:00'),
(14, 2, CURRENT_DATE - INTERVAL '3 days', '16:25:00');


INSERT INTO user_message_receive(user_id,message_id,receive_date,receive_time) VALUES
(6, 8, CURRENT_DATE - INTERVAL '4 days', '17:00:00'),
(6, 9, CURRENT_DATE - INTERVAL '6 days', '20:45:00');


INSERT INTO account_stickers (account_id, sticker_id,number_of_use,is_favorite,is_recent) VALUES
(1, 5,250,false,true),
(3,2,190,true,true),
(1,9,500,true,true),
(1,10,10,false,false);


INSERT INTO contact(account1_id,account2_id,name) VALUES
(1,2,'Ali'),
(1,3,'Yasi'),
(1,4,'Kimia'),
(1,5,'Hossein'),
(2,3,'Yasamin'),
(2,5,'Hossein Shahbazi');


INSERT INTO group_account_memberOf(account_id,group_id,role,join_date,custom_title) VALUES
(1,1,'normal member','2010-01-30',NULL),
(1,3,'admin','2022-10-29',NULL),
(1,7,'owner','2021-03-03',NULL),
(4,1,'normal member','2010-01-30',NULL),
(4,3,'admin','2021-03-03',NULL),
(5,1,'admin','2021-03-03',NULL),
(5,3,'admin','2021-03-03',NULL),
(2,3,'admin','2021-03-03',NULL),
(2,1,'admin','2021-03-03',NULL),
(3,1,'normal member','2022-01-20',NULL);


INSERT INTO channel_account_subscriberOf (account_id,channel_id,role,join_date) VALUES
(2,2,'normal subscriber','2010-01-30'),
(2,5,'admin','2022-10-29'),
(1,2,'owner','2021-03-03');